
;-------------------------  MACRO #1  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax, 1	;sys_write
	mov rdi, 1	;std_out
	mov rsi, %1	;primer parametro: Texto
	mov rdx, %2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------


;-------------------------  MACRO #2  ----------------------------------
;Macro-2: Gets 8-bytes, from index into buffer.
;	Loads Address/Instruction into $r12d register 
;	Input parameters:
;		%1 Is the Index of buffer truncation, passed by $r13 register.
;	Output: $r12d  
;-----------------------------------------------------------------------
%macro GetFromTxt 1   ; $r13 = %1 
	;------------------------------------------------
	;------- Copy upper dword from TEXT Buffer ------
	;------------------------------------------------

	  	mov rdx, 			qword [TEXT+%1+1]       ; [..] Instruction;
	  	mov ecx, 			32						; Shift 32 bits
	  	shr rdx, 			cl              		

	; The input text is hex in ASCII so you receive : 
	; word format     :		$eax : 0011abcd_0011efgh_0110ijkl_0110mnño...   
	; and you want it :     $rsp : abcd_efgh_ijkl_mnño...
	;------------------------------------------------
	       ; 20080003 >> for 3
	  	mov r8d, 			edx 					; $aux1
	  	mov r9d,            edx 					; $r9d has the instruction to fix 
	  	and r8d, 			0x0F000000				; masking abcd

		mov r10d,           r9d	
		and r10d,   		0xFF000000 				; masking ASCII(3 for 1234.. or 6 for ABCD...) and masking abcd 
		
		shr r10d, 			24 						; constant to make 0xFF000000 to 0xFF
		mov eax, 			r10d					
		call _HexAsciiFixer 						; This will fix the ASCII and leave the correct hex data
		shl eax, 			24						; returning the hex data to its original position

	  	mov edx, 			dword eax				; $edx is special for shift
	  	mov ecx, 			24 						; $ecx is special to pass shift num 										
	  	shr edx, 			cl              		; shifting abcd bits to 1st position
		
		or r12d,			edx 					; Partial data
	;------------------------------------------------ 
			; 200800b3 >> for b
		mov r8d, 			r9d 		  			; $aux2
		and r8d, 			0x000F0000				; save efgh

		mov r10d,           r9d	
		and r10d,   		0x00FF0000 				; masking 
		shr r10d, 			16 						; constant 
		mov eax, 			r10d
		call _HexAsciiFixer
		shl eax, 			16

	  	mov edx, 			dword eax		
	  	mov ecx, 			12 						; Shift 12 bits (to left)
	  	shr edx, 			cl              		; Shifting efgh to 2nd position 
		
		or r12d,			edx 					; Partial data
													; $rsp at this point: abcdefgh_00000000_....
	;------------------------------------------------ 
			; 20080c03 >> for c	
		mov r8d, 			r9d      				; $aux3
		and r8d, 			0x00000F00

		mov r10d,           r9d	
		and r10d,   		0x0000FF00              ; masking
		shr r10d, 			8						; contant >> 0xFF  	
		mov eax, 			r10d
		call _HexAsciiFixer
		shl eax, 			8

	  	mov edx, 			dword eax		
	  	mov ecx, 			0  				
	  	shr edx, 			cl              		; shifting

		or r12d,			edx 					; Partial data	  	
	; -----------------------------------------------
			; 2008d003 >> for d
		mov r8d, 			r9d                     ; $aux4
		and r8d, 			0x0000000F		

		mov r10d,           r9d	
		and r10d,   		0x000000FF 				; masking
		shr r10d, 			0 	
		mov eax, 			r10d
		call _HexAsciiFixer
		shl eax, 			0

	  	mov edx, 			dword eax		
	  	mov ecx, 			12      				; Shift left 16 bits
	  	shl edx, 			cl              
		
		or r12d,			edx 					; Partial data	 
	;................................................

	;------------------------------------------------
	;------- Copy lower dword from TEXT Buffer ------
	;------------------------------------------------
		;mov eax, 			dword [TEXT+r13+1]  	
			; 20080003 >> es el 2
		mov r8d, 			dword [TEXT+r13+1]     	; Truncate Buffer 
		mov r9d,            dword [TEXT+r13+1]      ; $aux5
		and r8d,   			0x0000000F
		
		mov r10d,           r9d 
		and r10d,   		0x000000FF 				; masking 
		shr r10d, 			0  	
		mov eax, 			r10d
		call _HexAsciiFixer
		shl eax, 			0

	  	mov edx, 			dword eax		
		mov ecx, 			28						; Shift = 0	
		shl edx, 			cl      		        ; Shift right 28 bits

		or r12d,			edx 					; Partial data	 		
    ; --------------------------------------------------------
			; 2g0800b3 >> es el g
		mov r8d, 			r9d 		            ; $aux6
		and r8d, 			0x00000F00	      

		mov r10d,           r9d	
		and r10d,   		0x0000FF00 				; masking 
		shr r10d, 			8 	
		mov eax, 			r10d
		call _HexAsciiFixer
		shl eax, 			8

	  	mov edx, 			dword eax		
	  	mov ecx, 			16						; Shift left 16 bits
	  	shl edx, 			cl              
		
		or r12d,			edx 					; Partial data	 
	; -------------------------------------------
			; 20f80003 >> es el f
		mov r8d, 			r9d      			    ; $aux7
		and r8d, 			0x000F0000

		mov r10d,           r9d	
		and r10d,   		0x00FF0000 				; masking 
		shr r10d, 			16 	
		mov eax, 			r10d
		call _HexAsciiFixer							; Calling to ascii fixer
		shl eax, 			16

	  	mov edx, 			dword eax		
	  	mov ecx, 			4						; Shift 4 bits
	  	shl edx, 			cl              		; dh, cl
		
		or r12d,			edx 					; Partial data	 
	; ---------------------------------------
			; 20080003 >> es el 8
		mov r8d, 			r9d 	             	; $aux8
		and r8d, 			0x0F000000				

		mov r10d,           r9d	
		and r10d,   		0xFF000000 				; masking 
		shr r10d, 			24 						; >> 0xFF, masked hex-ascii to fix 
		mov eax, 			r10d
		call _HexAsciiFixer							; Calling to ascii fixer 
		shl eax, 			24						; >>returning to 0xF'F'000000, but now fixed 

	  	mov edx, 			dword eax		
	  	mov ecx, 		    8						; Shift 4 bits
	  	shr edx, 			cl              		; dh, cl
		
		or r12d,			edx 					; $r12d contains the data 
%endmacro


;----------------------------------------------------
;---------- Auxiliar for macros GetFromTxt-----------
; Helps to rid off the ascii offset per byte readed.
;----------------------------------------------------
_HexAsciiFixer: 
;------------------ Check which hex to fix {0123456789}
	cmp eax, 0x30 
	je _50

	cmp eax, 0x31 
	je _51  
	
	cmp eax, 0x32 
	je _52 
	
	cmp eax, 0x33 
	je _53 
	
	cmp eax, 0x34 
	je _54 
	
	cmp eax, 0x35  
	je _55 
	
	cmp eax, 0x36 
	je _56 

	cmp eax, 0x37 
	je _57
	
	cmp eax, 0x38 
	je _58 
	
	cmp eax, 0x39
	je _59 	
;------------------- Check which hex to fix {ABCDEF}
	cmp eax, 0x61 
	je _A5 
	
	cmp eax, 0x62 
	je _B5 
	
	cmp eax, 0x63  
	je _C5 
	
	cmp eax, 0x64 
	je _D5 
	
	cmp eax, 0x65 
	je _E5 
	
	cmp eax, 0x66 
	je _F5 
;------------------- This fix for {ABCDEF}
	_A5:
		mov eax, 0x0A 
		ret 
	_B5:
		mov eax, 0x0B
		ret 
	_C5:	
		mov eax, 0x0C
		ret 
	_D5:
		mov eax, 0x0D			
		ret
	_E5:
		mov eax, 0x0E 
		ret 
	_F5:
		mov eax, 0x0F 
		ret
;------------------- This fix for {0123456789}
	_50:
		mov eax, 0x00 
		ret 					
	_51:
		mov eax, 0x01 
		ret 
	_52:
		mov eax, 0x02
		ret 
	_53:
		mov eax, 0x03			
		ret
	_54:
		mov eax, 0x04 
		ret 
	_55:
		mov eax, 0x05 
		ret
	_56:
		mov eax, 0x06 
		ret 
	_57:
		mov eax, 0x07 
		ret 
	_58:
		mov eax, 0x08 
		ret 
	_59:
		mov eax, 0x09 
		ret 
;.......................................................................


;-----------------------------------------------------------------------
;------------------------ Instruction Decoder --------------------------
;-----------------------------------------------------------------------
	;---------- Input ---------
	; 			( Instruction Address )
	;--------- Output ---------
	; %1 = $r15 ( OPCODE )
	; %2 = $r14 ( rs )
	; %3 = $r13 ( rt )
	; %4 = $r12 ( rd )
	; %5 = $r10 ( Function ) 
	; %6 = $r9  ( Immediate) 
	; %7 = $r8  ( Address )

_DECO:
	xor r8, r8 
	xor r9, r9 
	;xor r10, r10
	xor r12, r12 
	xor r13, r13
	xor r14, r14
	xor r15, r15 

;--------------------- Mask & shift for OPcode 	
	mov r8d, 			dword [rsp+rbx]      		  ; getting instruction from memory; 
	and r8d, 1111_1100_0000_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			26  						  ; shifting 26 bits
	mov edx, 			dword r8d
	shr edx,			cl 							  ; $rdx is the output ( OPCODE )
	mov r15,            rdx


;--------------------- Mask & shift for $rs 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory; 
	and r8d, 0000_0011_1110_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			21  						  ; shifting 20 bits
	mov edx, 			dword r8d
	shr edx,			cl 	
	imul rdx, 			4 
	sub rdx, 			4	

	mov r14, 			rdx                           ; $r13 is the rs pointer
	add r14, 			OFFSET_POINTER_REG	          ; adding memory offset to $r13 to start in Register Bank allocation 

;--------------------- Mask & shift for $rt 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0001_1111_0000_0000_0000_0000b ; masking address $rt
	mov rcx, 			16       	    			  ; shifting 16 bits
	mov edx, 			dword r8d
	shr edx,			cl 
	imul rdx, 			4  							  ; escale x4
	sub rdx, 			4							  ; substract 4 to point propertly	
 
	mov r13, 			rdx      				      ; $r14 is the rt pointer
	add r13, 			OFFSET_POINTER_REG            ; Jumping Memory allocation 

;---------------------- Mask & shift for $rd 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1000_0000_0000b ; masking address $rd
	mov rcx, 			11							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	imul rdx, 			4
	sub rdx, 			4

	mov r12, 			rdx 				     	  ; $r14 is the rt pointer
	add r12, 			OFFSET_POINTER_REG 			  ; starting above memory 

;---------------------- Mask & shift for Shamt 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_0000_0111_1100_0000b ; masking address $rd
	mov rcx, 			6							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	mov [Shamt],        edx

;---------------------- Mask & shift for FUNCTION 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_0000_0000_0011_1111b ; masking address $rd
	mov rcx, 			0							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	mov r10,            rdx

;---------------------- Mask & shift for Inmediate 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1111_1111_1111b ; masking address $rd
	mov r9d,			r8d 

;---------------------- Mask & shift for Address 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0011_1111_1111_1111_1111_1111_1111b ; masking address $rd

	ret


;------------------------------------------------------------------------------
;------------------------------ Master ALU ------------------------------------
;------------------------------------------------------------------------------
	;--------- Input ---------
	; %1 = $r15 ( OPCODE )
	; %2 = $r14 ( rs )
	; %3 = $r13 ( rt )
	; %4 = $r12 ( rd )
	; %5 = $r10 ( Function ) 
	; %6 = $r9  ( Immediate) 
	; %7 = $r8  ( Address )

_Alu2: 
	cmp r15d, 0x00
	je _OPcodeR
	jne _OPcodeI

	_OPcodeI:  
		cmp r15d, 0x8 ; addi
		je _addi 

		cmp r15d, 0xd ; ori
		je _ori 

		cmp r15d, 0xc ; andi  
		je _andi

		cmp r15d, 0xa ; slti
		je _slti

		cmp r15d, 0xb 
		je _sltiu

		cmp r15d, 0x4 ; beq
		je _beq

		cmp r15d, 0x5 ; bne
		je _bne

		cmp r15d, 0x2 ; j
		je _j 

		cmp r15d, 0x3 ; jal
		je _jal 

		cmp r15d, 0x23 ; lw
		je _lw

		ret
 

	_OPcodeR:
		cmp r10d, 0x00 ; shl function
		je _shl 			
 
		cmp r10d, 0x02 ; shr function
		je _shr
 
		cmp r10d, 0x18 ; *mult function
		je _imul 

		cmp r10d, 0x20 ; add function
		je _add 									

		cmp r10d, 0x22 ; and function
		je _sub 

		cmp r10d, 0x23 ; subu function 
		je _subu
		
		cmp r10d, 0x24 ; and function
		je _and 										
									 
		cmp r10d, 0x25 ; or function
		je _or 						
 
		cmp r10d, 0x27 ; nor function
		je _nor 

		cmp r10d, 0x2a ; slt function
		je _slt 

		;cmp r10d, 0x2b ; sltu function
		;je _sltu 

		cmp r10d, 0x21 ; addu function
		je _addu 

		cmp r10d, 0x8  ; jr function
		je 	_jr
		
		jmp _endAlu


	_add:
		impr_texto Op1, tamano_Op1 ; Indica al usuario que operacion se realiza
		mov eax,		       dword [rsp+r14+OFFSET_RSPCALL] ; +8, because call use rsp register	; Se pasan los datos a los registros que van a operar
		add eax, 			   dword [rsp+r13+OFFSET_RSPCALL] ; Se realiza la operacion
		mov dword [rsp+r12+OFFSET_RSPCALL], eax
		ret 

	_addu:		
		mov eax,               dword [rsp+r13+OFFSET_RSPCALL] ; rt
		cmp eax,               0
		jg _adduRtIsPositive                     ; Unsigned op
		mov r9d,         -1  					 ; se carga el registro con -1 para multiplicar
		imul r9d 						         ; se multiplica por -1 para que el resultado sea positivo
		 
		_adduRtIsPositive:
			mov r9d,         eax 				 ; guarda el valor modificado en el registro deseado

			mov eax,     dword [rsp+r14+OFFSET_RSPCALL] 		 ; rs pointer
			cmp eax,     0
			jg _adduRsIsPositive
			mov ebp,     -1
			imul ebp
		
		_adduRsIsPositive:
			add eax,     r9d
			mov dword [rsp+r12+OFFSET_RSPCALL], eax
			ret 
  
	_and:
		impr_texto Op2, tamano_Op2
		mov eax,			 dword [rsp+r14+OFFSET_RSPCALL]	 ; getting data 
		and eax, 			 dword [rsp+r13+OFFSET_RSPCALL] 
		mov dword [rsp+r12+OFFSET_RSPCALL], eax
		ret

	_andi: 
		mov eax,             dword [rsp+r14+OFFSET_RSPCALL]
		and eax,             r9d                 ; Imm
		mov dword [rsp+r13+OFFSET_RSPCALL], eax
		ret 

	_or:
		impr_texto Op3,tamano_Op3
		mov eax, 			 dword [rsp+r14+OFFSET_RSPCALL]
		or eax,              dword [rsp+r13+OFFSET_RSPCALL] 
		mov dword [rsp+r12+OFFSET_RSPCALL], eax		
		ret 
	_nor:
		impr_texto Op4,tamano_Op4
		mov eax, 		     dword [rsp+r14+OFFSET_RSPCALL]
		or eax, 			 dword [rsp+r13+OFFSET_RSPCALL] 
		not eax
		mov dword [rsp+r12+OFFSET_RSPCALL], eax			 
		ret 

	_shl: ; ******   sll 
		;impr_texto Op5,tamano_Op5 
		mov eax,             dword [rsp+r13+OFFSET_RSPCALL] ; rt ! 
		mov ecx, 			 dword [Shamt]
		shl eax,             cl
		mov dword [rsp+r12+OFFSET_RSPCALL], eax		       ; output pointer is rd
		ret 

	_shr: ; ******   srl
		;impr_texto Op6,tamano_Op6
		mov eax,			 dword [rsp+r13+OFFSET_RSPCALL]
		mov ecx, 			 dword [Shamt]
		shr eax,			 cl
		mov dword [rsp+r12+OFFSET_RSPCALL], eax		       ; output pointer is rd		
		ret 

	_jr:	 ; PC = R[rs]
		mov ebx,             dword [rsp+r14+OFFSET_RSPCALL] ; PC<--R[rs] 
		ret 

	_lw:
		mov eax,             dword [rsp+r14+OFFSET_RSPCALL] ; [rs]
		mov r8d, 4
		add eax,             r9d               ; [rs] + Imm
		;imul eax, 4 						   ; (6)*4 = 24, byte adjust 
		imul r8d 
		_1:

							         ; se multiplica por -1 para que el resultado sea positivo
		 
		_GoGetIt:
			;mov dword [PlayHard],         eax 				 ; guarda el valor modificado en el registro deseado
			
			mov r10d,            dword [rsp+rax+OFFSET_RSPCALL+OFFSET_POINTER_DATAMEM]
			mov dword [rsp+r13+OFFSET_RSPCALL], r10d ;eax
		_2:
		ret 




	_sub:
		impr_texto Op7,tamano_Op7
		mov eax,			 dword [rsp+r14+OFFSET_RSPCALL]
		sub eax,			 dword [rsp+r13+OFFSET_RSPCALL] 
		mov dword [rsp+r12+OFFSET_RSPCALL], eax	 
		ret

	_subu:
		mov eax,         dword [rsp+r13+OFFSET_RSPCALL] 	   ; rt pointer	
		cmp eax,         0
		jg _subuRtIsPositive              	   ; Unsigned operation 
		mov r9d,         -1                    ; se carga el registro con -1 para multiplicar
		imul r9d                               ; se multiplica por -1 para que el resultado sea positivo

		
		_subuRtIsPositive:
			mov r9d,         eax 			    

			mov eax,     dword [rsp+r14+OFFSET_RSPCALL]     ; rs pointer
			cmp eax,     0
			jg _subuRsIsPositive
			mov ebp,     -1
			imul ebp 
 
		_subuRsIsPositive:
			sub eax,     r9d 
			mov dword [rsp+r12+OFFSET_RSPCALL], eax
			ret 

	_ori:
		mov eax,         dword [rsp+r14+OFFSET_RSPCALL]
		or eax,          r9d  				   ; Imm
		mov dword [rsp+r13+OFFSET_RSPCALL], eax
		ret


	_beq: 
		mov eax,         dword [rsp+r14+OFFSET_RSPCALL]  ; [rs]
		sub eax,         dword [rsp+r13+OFFSET_RSPCALL]  ; [rt]

		cmp eax,         0
		je _BeqC
		jne _BeqR

		_BeqC:
			add ebx,                    r9d 
			ret 

		_BeqR: 
			ret 


	_bne: 
		mov eax,         dword [rsp+r14+OFFSET_RSPCALL]  ; [rs]
		sub eax,         dword [rsp+r13+OFFSET_RSPCALL]  ; [rt]
		cmp eax,         0
		je _bneC
		jne _bneR

		_bneR:
			add ebx,                    r9d  
			ret 

		_bneC:  
			ret 

	_j:
		mov ebx, 		r8d 				; getting the jAddress
		ret         

	_jal: 
		;add ebx, 8
		;PC+8;sub ebx,  8  ; apuntando a la instruccion anterior (suponiendo que estan consecutivas, REVISAR)
		mov dword [rsp+OFFSET_POINTER_REG+OFFSET_RSPCALL +124], ebx ; R[31] = PC+8
											; R[31] => 31*4 = 124
		add ebx, 8
		_jal2:			
			mov ebx,        r8d  
		ret 

	_slt: 
		;impr_texto Op15,tamano_Op15
		mov eax,      dword [rsp+r14+OFFSET_RSPCALL] ; rs pointer
		cmp eax,      dword [rsp+r13+OFFSET_RSPCALL] ; rt pointer
		jl _Rd1

		_Rd0:
			mov eax,  0
			mov dword [rsp+r12+OFFSET_RSPCALL], eax
			ret 

		_Rd1:
			mov eax,  1
			mov dword [rsp+r12+OFFSET_RSPCALL], eax
			ret	

	_slti:
		mov eax,         dword [rsp+r14+OFFSET_RSPCALL] ; rs pointer	
		cmp eax,         r9d               ; cmp with imm 
		jl _sltiSetLess

		mov dword [rsp+r13+OFFSET_RSPCALL],  0          ; [rs] = 0
		ret

		_sltiSetLess: 
			mov dword [rsp+r13+OFFSET_RSPCALL], 1       ; [rt] = 1
			ret


    _sltiu: ; ESTA TODAVIA NO FUNCIONA
    	mov eax,         dword [rsp+r14+OFFSET_RSPCALL]       ; [rs]
    	cmp eax,         0
		jg _sltiuSetLess
		; Unsigned operation 
		mov r10d,        -1  ; r10d reg because we don't need function
		imul r10d             ; se multiplica por -1 para que el resultado sea positivo

		_sltiuSetLess:
			mov r8d,      eax			
			continueSltiu0:
				mov eax,       r9d	

				cmp eax,      0
				jg _continueSltiu

				mov ebp,     -1
				imul ebp            ; eax = imm
		
		_continueSltiu:
			cmp eax,      r8d
			jl _Rd0iu

		_Rd0iu:
			mov eax,  0
			mov dword [rsp+r13+OFFSET_RSPCALL], eax
			ret 

		_Rd1iu:
			mov eax,  1
			mov dword [rsp+r13+OFFSET_RSPCALL], eax
			ret	    	



;	_sltu:
;		mov eax,         dword [rsp+r13+OFFSET_RSPCALL] ; rt pointer	
;		cmp eax,         0
;		jg _isPositive
		; Unsigned operation 
;		mov r9d,         -1                ; se carga el registro con -1 para multiplicar
;		imul r9d                           ; se multiplica por -1 para que el resultado sea positivo

;		_isPositive:
;			mov r9d,         eax           ; guarda el valor modificado en el registro deseado
;			mov eax,     dword [rsp+r14+OFFSET_RSPCALL] ; rs pointer
;			cmp eax,     0
;			jg _continueSlt
;			mov ebp,     -1
;			imul ebp
		
;		_continueSlt:
;			cmp eax,     r9d       
;			jl _Rd1u

;		_Rd0u:
;			mov eax,  0
;			mov dword [rsp+r12+OFFSET_RSPCALL], eax
;			ret 

		_Rd1u:
			mov eax,  1
			mov dword [rsp+r12+OFFSET_RSPCALL], eax
			ret	


	_imul: ; *******
		;impr_texto Op8,tamano_Op8
		;mov eax,			 dword [rsp+r14+8] ; (?)
		;mov ebx,			 dword [rsp+r13+8]
		mov eax,			 dword [rsp+r13+OFFSET_RSPCALL]
		imul eax ;ebx
		ret 

;----------------- I-Type----------------------------
; Pointer 	 $rs  ($r14)
; Pointer is $rt  ($r13)
	_addi:
		;impr_texto Op1, tamano_Op1
		mov eax, 	    	 dword [rsp+r14+OFFSET_RSPCALL]    ; Register ( $rs ) Data 
		add eax,    		 r9d                  ; ImmediateCtrl
		mov dword [rsp+r13+OFFSET_RSPCALL], eax                ; addi into Reg Bank (addressed $rt) i-type
		ret 

	_endAlu:
		ret



section .data
;-------------------  Memory Data -------------------------
  iMEM_BYTES:     equ 400 ;600 ;56 ;400 ;                          ; x/4 = words num	; 100 dwords, Instructions Memory allocation 
  REG_BYTES:	  equ 128              				   ; 32 dwords
  DATAMEM_BYTES:  equ 400 ;56  ;400 
  TOT_MEM:		  equ 928 ;1128 ;928 ;240 ; 928    ; iMEM+REG_B

  msg:          db " Memory Allocated! ", 10
  len:          equ $ - msg
  fmtint:       db "%ld", 10, 0

  FILE_NAME:    db "code.txt", 0
  FILE_LENGTH:  equ 240 				        		; length of inside text
  

  ;OFFSET_POINTER_ADDRESS:  equ 184 ; 
  OFFSET_RSPCALL: equ 8  
  OFFSET_POINTER_DATAMEM:  equ 528 ;728 ;528 ; 184  ;528;; iMEM_BYTES+REG_BYTES
  OFFSET_POINTER_REG:      equ iMEM_BYTES 				; 1 dword = 4 bytes
  						  								; 128bytes = 32 dwords
  	    				  								; offset for Registers Allocation

  SYS_EXIT: 	equ 60
  SYS_READ: 	equ 0
  SYS_WRITE: 	equ 1
  SYS_OPEN: 	equ	2  
  SYS_CLOSE: 	equ 3  
  SYS_BRK:		equ 12 
  SYS_STAT:		equ	4 
  O_RDONLY:		equ	0
  O_WRONLY:		equ	1
  O_RDWR:		equ 2

  STDIN:        equ 0
  STDOUT:       equ 1
  STDERR:       equ 2  

;------------------- Alu -----------------------------
  l1: db 'Inicio del Programa',0xa
  tamano_l1: equ $-l1
  Op1: db 'Se realiza un add',0xa
  tamano_Op1: equ $-Op1
  Op2: db 'Se realiza un and',0xa
  tamano_Op2: equ $-Op2
  Op3: db 'Se realiza un or',0xa
  tamano_Op3: equ $-Op3
  Op4: db 'Se realiza un nor',0xa
  tamano_Op4: equ $-Op4
  Op5: db 'Se realiza un Shift left',0xa
  tamano_Op5: equ $-Op5
  Op6: db 'Se realiza un Shift Right',0xa
  tamano_Op6: equ $-Op6
  Op7: db 'Se realiza una Resta',0xa
  tamano_Op7: equ $-Op7
  Op8: db 'Se realiza una multiplicacion',0xa
  tamano_Op8: equ $-Op8
  l3: db 'Fin del Programa!',0xa
  tamano_l3: equ $-l3
  num1: equ 0x1



section .bss
	FD_OUT: 	    resb 1
	FD_IN: 		    resb 1
	TEXT: 		    resb 32

	Shamt:          resb 4
   	BranchAddress:  resb 4   
   	PlayHard: resb 4


section  .text
   global _start       


_start:                     			; tell linker entry point

	xor rcx, 			rcx 
	sub rsp, 			TOT_MEM         ; number of memory bytes allocation		
 
 ;%macros OpenFile 
_txt:
;------- open file for reading
	mov rax, 	  		SYS_OPEN		            
	mov rdi, 	  		FILE_NAME
	mov rsi, 	  		STDIN      		; for read only access
	syscall  
	mov [FD_IN],  		rax

;------- read from file
	mov rax, 	  		SYS_READ    	; sys_read
	mov rdi, 	  		[FD_IN]
	mov rsi,            TEXT
	mov rdx, 	  		FILE_LENGTH   	; Data length 
	syscall

;------- close the file 
	mov rax,      		SYS_CLOSE 
	mov rdi,      		[FD_IN]

;------- print info  
	mov rax,      		SYS_WRITE 
	mov rdi,      		STDOUT
	mov rsi,      		TEXT			; The Buffer TEXT
	mov rdx,      		FILE_LENGTH     ; Data length 
	syscall	
;------------------ At this point -------------------------
;----------- $rsi have txt instructions -------------------

	xor r13, r13
	xor r14, r14
	xor rax, rax 
	

;------------- Loads Instruction into Memory --------------
;------------------------- PC -----------------------------
_PC:  
	mov al, 		byte [TEXT+r13]		    ; 19 is a constant to find Index(;) 
	inc 			r13						; in format [yyyyyyyy] xxxxxxxx;

	cmp r13, 		FILE_LENGTH  			; Break condition
	je 				_Reg  

	cmp al, 		0x3b 				    ; 0x3b => Index ( ; ) 
	je              _loadAddress  			
	jne             _PC					

_loadAddress:
	mov r15, 	    r13 
	sub r13,        20						; 20 positions before Index, starts the address
	GetFromTxt 		r13 					; output is $r12d

	mov r14, 		r12 				    ; $r14 is the Memory address pointer
	_3:
	and r14,        0xFF
	;mov dword [rsp+r14+OFFSET_POINTER_ADDRESS], r12d
	add r13,        20                      ; ( ; ) Position again 
	_4:

_loadInstruction:
	sub r13,             	10 
	xor r12d,            	r12d
	GetFromTxt r13 							; output is $r12d

	mov dword [rsp+r14], 	r12d 			; Saves addressed Intruction into Memory
													
	mov r13,            	r15 
	xor r12d,           	r12d
	jmp _PC
;------------------------------- At this point -----------------------------------
;------------- Virtual memory $rsp contains addressed instructions ---------------


_Reg:	
	mov rdi, iMEM_BYTES;/4 								; Number of words for the assignation ; 0xE ; iMEM_BYTES/4 ; 3
	mov ebx, 0x4     									; 0x38 last word  ; 0x24  ; first instruct address +4 
	mov dword [rsp+OFFSET_POINTER_DATAMEM +24], 0xf     ; (29)*4 =116 , 
												        ;manually load to dataMem

;and ebx,  0xFF ; 
	;mov dword [BranchAddress], 0x0 

_PCLoop:
	; add ebx, dword [BranchAddress]
	add ebx,                0x4 
	dec rdi

	call _DECO 
	call _Alu2
	;_2:
	cmp rdi, 0x0
	je _Reg1
	jne _PCLoop

_Reg1:

                             
_end:
 	mov rax,       		 SYS_EXIT
   	mov rdi,       		 STDIN
    xor rbx,       		 rbx
    syscall

