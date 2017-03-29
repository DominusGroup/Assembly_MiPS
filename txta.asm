

;-------------------------  MACRO #1  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 			;recibe 2 parametros
	mov rax, 1	;sys_write
	;mov rdi, 1	;std_out
	mov rsi, %1	;primer parametro: Texto
	mov rdx, %2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------
 
 %macro impr_textoPantalla 2 	;recibe 2 parametros
	mov rax, 1	;sys_write
	mov rdi, 1	;std_out
	mov rsi, %1	;primer parametro: Texto
	mov rdx, %2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------
 


_FillBuffer:
	;------- open file for reading
	mov rax, 	  		SYS_OPEN		            
	mov rdi, 	  		FILE_NAME
	mov rsi, 	  		STDIN      		; for read only access
	mov rdx, 0
	syscall  
	cmp rax,0
	jle _error
	
	mov [FD_IN],  		rax


	;------- read from file
	mov rax, 	  		SYS_READ    	; sys_read
	mov rdi, 	  		[FD_IN]
	mov rsi,            TEXT
	mov rdx, 	  		FILE_LENGTH   	; Data length 
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, noerror
	mov rdx, noerror1
	syscall

	mov rax, 0
	mov rdi, 0
	mov rsi, var_nombre
	mov rdx, var_nombre
	syscall

;------- print info  
	mov rax,      		SYS_WRITE 
	mov rdi,      		STDOUT
	mov rsi,      		TEXT			; The Buffer TEXT
	mov rdx,      		FILE_LENGTH     ; Data length 
	syscall	


;------- close the file 
	mov rax,      		SYS_CLOSE
	mov rdi,      		[FD_IN]
	mov rdx,0
	mov rsi,0
		

;------------------ At this point -------------------------
;----------- $rsi have txt instructions -------------------	
	ret 

 %macro Opentxt 0  ;ACTULIZAR LENGTH
;------- open file for writing
	mov rax, 	  		SYS_OPEN		            
	mov rdi, 	  		OUTPUT_FILE_NAME
	mov rsi, 	  		2 ;STDOUT ; write STDERR   ; read & write ; STDOUT      		; for read only access
	syscall  
	mov [FD_OUT],  		rax

%endmacro	


%macro Writetxt 2
		 ;------ write in txt 
			mov rax, 	  		SYS_WRITE    	; sys_write
			mov rdi, 	  		[FD_OUT]
			mov rsi,            %1 ; fmtint3 ; %1              ; Buffer output 
			mov rdx, 	  	    %2 ; 8 ;%2 ;1               ; Data length 
			syscall 

		;------- close the file 
			mov rax,      		SYS_CLOSE 
			mov rdi,      		[FD_OUT]

%endmacro

 
%macro PrintREGFinal 0

		mov eax, dword [rsp+OFFSET_POINTER_REG+12 -8 ]     ; $v0 content
		mov [string],                 eax		
		call Hex2Ascii	                        ; in [string] ; out rcx
		mov [fmtint_v0], rcx  

		mov eax, dword [rsp+OFFSET_POINTER_REG+12 -4 ]     ; $v1 content
		mov [string],                 eax		
		call Hex2Ascii	                      
		mov [fmtint_v1], rcx  

		mov eax, dword [rsp+OFFSET_POINTER_REG+12 +0]     ; $a0 content
		mov [string],                 eax		
		call Hex2Ascii	                      
		mov [fmtint_a0], rcx  


		mov eax, dword [rsp+OFFSET_POINTER_REG+12 +4]     ; $a1 content
		mov [string],                 eax		
		call Hex2Ascii	                
		mov [fmtint_a1], rcx  


		mov eax, dword [rsp+OFFSET_POINTER_REG+12 +8]     ; $a2 content
		mov [string],                 eax		
		call Hex2Ascii	                        
		mov [fmtint_a2], rcx  

		mov eax, dword [rsp+OFFSET_POINTER_REG+12 +12]     ; $a3 content
		mov [string],                 eax		
		call Hex2Ascii	                        
		mov [fmtint_a3], rcx  

		mov eax, 			dword [rsp+OFFSET_POINTER_REG+60]	    ; R[16]
		mov [string],       eax 										; $s0
		call Hex2Ascii	    
			mov [fmtint_s0], rcx

		mov eax, 			dword [rsp+OFFSET_POINTER_REG+64]	    ; R[17] $s1
		mov [string],       eax 	
		call Hex2Ascii 
		mov [fmtint_s1], rcx  							 


		mov eax, 			dword [rsp+OFFSET_POINTER_REG+68]	    ; R[18]
		mov [string],       eax 	
		call Hex2Ascii	   	
		mov [fmtint_s2], rcx  	

		mov eax, 			dword [rsp+OFFSET_POINTER_REG +72]	    ; R[19]
		mov [string],       eax 	
		call Hex2Ascii	    
			mov [fmtint_s3], rcx  

		mov eax, 			dword [rsp+OFFSET_POINTER_REG  +76]	    ; R[20]
		mov [string],       eax 	
		call Hex2Ascii	  ; in r15 
		mov [fmtint_s4], rcx  

		mov eax, 			dword [rsp+OFFSET_POINTER_REG +80]	    ; R[21]
		mov [string],       eax 	
		call Hex2Ascii	  ; in r15 
		mov [fmtint_s5], rcx  

		mov eax, 			dword [rsp+OFFSET_POINTER_REG +84]	    ; R[22]
		mov [string],       eax 	
		call Hex2Ascii	  ; in r15 
		mov [fmtint_s6 ], rcx  


		mov eax, 			dword [rsp+OFFSET_POINTER_REG +88]	    ; R[23]
		mov [string],       eax 	
		call Hex2Ascii	  ; in r15 
		mov [fmtint_s7], rcx  

		mov eax, 			dword [rsp+OFFSET_POINTER_REG +112]		; R[29]	
		mov [string],       eax 	
		call Hex2Ascii	  ; in r15 
		mov [fmtint_sp], rcx  


		Opentxt

		;Writetxt regout_family,        AllReg_Content_Length
		
		Writetxt pantalla_final_10, l16_tamano

		Writetxt model,     1	
		Writetxt family, 	1
 
		Writetxt v0_Reg,        AllReg_Content_Length
		Writetxt fmtint_v0,     8		

		Writetxt v1_Reg,        AllReg_Content_Length
		Writetxt fmtint_v1,     8		

		Writetxt a0_Reg,        AllReg_Content_Length
		Writetxt fmtint_a0,     8	

		Writetxt a1_Reg,        AllReg_Content_Length
		Writetxt fmtint_a1,     8		

		Writetxt a2_Reg,        AllReg_Content_Length
		Writetxt fmtint_a2,     8		

		Writetxt a3_Reg,        AllReg_Content_Length
		Writetxt fmtint_a3,     8	


		Writetxt s0_Reg,        AllReg_Content_Length
		Writetxt fmtint_s0,     8		

		Writetxt s1_Reg,        AllReg_Content_Length
		Writetxt fmtint_s1,     8		

		Writetxt s2_Reg,        AllReg_Content_Length
		Writetxt fmtint_s2,     8					

		Writetxt s3_Reg,        AllReg_Content_Length
		Writetxt fmtint_s3,     8		

		Writetxt s4_Reg,        AllReg_Content_Length
		Writetxt fmtint_s4,     8		

		Writetxt s5_Reg,        AllReg_Content_Length
		Writetxt fmtint_s5,     8	

		Writetxt s6_Reg,        AllReg_Content_Length
		Writetxt fmtint_s6,     8		

		Writetxt s7_Reg,        AllReg_Content_Length
		Writetxt fmtint_s7,     8		

		Writetxt sp_Reg,        AllReg_Content_Length
		Writetxt fmtint_sp,     8


%endmacro

	_PantallaTipoR:	
 
;------------------------- Opcode

		mov eax,                  	  [OPC]    ;dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +0]  ; [OPC] 
		mov [string],                 eax
		
		call Hex2Ascii	                        ; in [string] ; out [regout]
		 
		mov [regout_aux], rcx ;eax 
		impr_texto cons_banner01, cons_tamano_banner01      ; Texto descriptivo 	
		impr_textoPantalla fmtint4, 	      8  	; con solo este ya imprime todo en pantalla !!

;-------------------------- RS 

		mov eax,                      [RS]      ;dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +4] ;  
		mov [string],                 eax
		
		call Hex2Ascii 	                      ; in [string] ; out [regout]
		mov [regout_aux], rcx 
		impr_texto cons_banner02, cons_tamano_banner02			
		impr_textoPantalla fmtint4, 	      8  	; con solo este ya imprime todo en pantalla !!

;-------------------------- RT

		mov eax,                      [RT]      ;dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +8] 
		mov [string],                 eax
		
		call Hex2Ascii                       ; in [string] ; out [regout]
		mov [regout_aux], rcx 
		impr_texto cons_banner03, cons_tamano_banner03
		impr_textoPantalla fmtint4, 	      8  	; con solo este ya imprime todo en pantalla !!

;-------------------------- RD

		mov eax,                      [RD]		  ;dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +12] 
		mov [string],                 eax 
		
		call Hex2Ascii	                      ; in [string] ; out [regout]
		mov [regout_aux], rcx 		
		impr_texto cons_banner04, cons_tamano_banner04
  		impr_texto fmtint4, 	      8

;------------------------- Shamt

		mov eax,                      [Shamt]      ;dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +16] ; [Shamt] 
		mov [string],                 eax
		
		call Hex2Ascii                      ; in [string] ; out [regout]
		mov [regout_aux], rcx 			
		impr_texto cons_banner05, cons_tamano_banner05
  		impr_texto fmtint4, 	      8

;------------------------- Function

		mov eax,                      [FUNCT]       ;dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +20]  ;[FUNCT] 	
		mov [string],                 eax
		
		call Hex2Ascii	                      ; in [string] ; out [regout]
  		mov [regout_aux], rcx 
		impr_texto cons_banner06, cons_tamano_banner06	  		
  		impr_texto fmtint4, 	      8


	  	ret 

  

	  	_PantallaTipoI:	  	

;------------------------- Opcode

		mov eax,                      [OPC] 	 ;dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +0]  ; [OPC] 
		mov [string],                 eax
		
		call Hex2Ascii	                        ; in [string] ; out [regout]
		 
		mov [regout_aux], rcx  
		impr_texto cons_banner01, cons_tamano_banner01      ; Texto descriptivo 	
		impr_textoPantalla fmtint4, 	      8  	; con solo este ya imprime todo en pantalla !!

;------------------------- Immediate 
	
		mov eax,                      [IMM]			; dword [rsp+OFFSET_DECODE_PROCESS-8 +8 +24]  ;[Imm] 	
		mov [string],                 eax
		
		call Hex2Ascii	                      ; in [string] ; out [regout]
		mov [regout_aux], rcx 			
		impr_texto cons_banner06, cons_tamano_banner06
  		impr_textoPantalla fmtint4, 	      8
	
		ret 	
 



 
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
		xor r12,            r12 
	  	mov rdx, 		    %1 ;  qword [Ascii2Hex]		; qword [TEXT+%1+1]       ; [..] Instruction;
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
		mov rax,            %1	   ;dword [Ascii2Hex]		
		mov r8d, 			eax              ; dword [TEXT+r13+1]     	; Truncate Buffer 
		mov r9d,            eax              ; dword [TEXT+r13+1]      ; $aux5


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



_Instruction2Memory: 

	mov al, 		byte [TEXT+r13]		    ; 19 is a constant to find Index(;) 
	inc 			r13						; in format [yyyyyyyy] xxxxxxxx;

	cmp r13, 		FILE_LENGTH  			; Break condition
	je 				_Return  

	cmp al, 		0x3b 				    ; 0x3b => Index ( ; ) 
	je              _loadAddress  			
	jne             _Instruction2Memory					

_loadAddress:
	mov r15, 	    r13 
	sub r13,        20						; 20 positions before Index, starts the address

	mov rax,               qword [TEXT+r13+1]
	mov qword [Ascii2Hex], rax
	GetFromTxt 		[Ascii2Hex]    ; r13 					; output is $r12d

	mov r14, 		r12 				    ; $r14 is the Memory address pointer
	 
	and r14,        0xFF
	;mov dword [rsp+r14+OFFSET_POINTER_ADDRESS], r12d
	add r13,        20                      ; ( ; ) Position again 
	 

_loadInstruction:
	sub r13,             	10 
	xor r12d,            	r12d

	mov rax,                qword [TEXT+r13+1]
	mov qword [Ascii2Hex],  rax	
	GetFromTxt              [Ascii2Hex]      ;                r13 							; output is $r12d

	mov dword [rsp+r14], 	r12d 			; Saves addressed Intruction into Memory
													
	mov r13,            	r15 
	xor r12d,           	r12d
	jmp _Instruction2Memory

_Return:
	ret	
;------------------------------- At this point -----------------------------------
;------------- Virtual memory $rsp contains addressed instructions ---------------



_ArgumentsRegInit:
;------------------- Initialization of Arguments Registers -----------------------

	GetFromTxt [arg1] 									 ; Ascii to HEX ; out=r12
	mov r15,   r12 
	mov dword [rsp+OFFSET_POINTER_REG+OFFSET_RSPCALL+16 -4],   r15d     ; R[4]   

	GetFromTxt [arg2]
	mov r15,   r12 
	mov dword [rsp+OFFSET_POINTER_REG+OFFSET_RSPCALL+20 -4],   r15d     ; R[5]

	GetFromTxt [arg3]
	mov r15,   r12 	
	mov dword [rsp+OFFSET_POINTER_REG+OFFSET_RSPCALL+24 -4],   r15d     ; R[6]

	GetFromTxt [arg4]
	mov r15,   r12 	
    mov dword [rsp+OFFSET_POINTER_REG+OFFSET_RSPCALL+28 -4],   r15d     ; R[7],        4* 7 =28 -4 = 24  
	
	ret



Hex2Ascii:
	xor rax,      rax
	mov rcx , rax

	mov rax,      [string]      ; r15 
	and rax,      0x0000000f    ; máscara, para extraer los ultimos bits
	cmp rax,      0x00000009

	jbe esn1;  salta si es numero
	ja ess1; salta si es string

esn1:
	add rax, 0x30 

	;mov rsi, rax 

	jmp segundo
 ess1:
	add rax, 0x37 

	;mov rsi, rax 
	;add rsi, 0x29  ; 0x37 + 0x29 = 0x60 
	

;_______________________________________________________________________
segundo:
	shl rax, 56
	;shl rsi, 56

	mov rcx ,     rax        ; Storing value 
	;mov [SaveInTxt],  rsi        

	mov rax,      [string]   ; r15 
	shr rax, 4
	and rax, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rax, 0x00000009
	jbe esn2;  salta si es numero
	ja ess2; salta si es string

esn2:
	add rax, 0x30 

	;mov rsi, rax 

	jmp tercero
 ess2:
 	add rax, 0x37

	;mov rsi, rax 
	;add rsi, 0x29  ; 0x37 + 0x29 = 0x60 

	
;________________________________________
tercero:
	shl rax, 48
	;shl rsi, 48 
	or rcx ,     rax
	;or [SaveInTxt],  rsi 

	mov rax,      [string]   ; r15 
	shr rax, 8
	and rax, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rax, 0x00000009
	jbe esn3;  salta si es numero
	ja ess3; salta si es string

esn3:
	add rax, 0x30 
	;mov rsi, rax 	
	jmp cuarto
 ess3:
	add rax, 0x37

	;mov rsi, rax 
	;add rsi, 0x29  ; 0x37 + 0x29 = 0x60 	

cuarto:
	shl rax, 40
	;shl rsi, 40 
	or rcx ,    rax
	;or [SaveInTxt], rsi 

	mov rax,      [string]   ; r15 
	shr rax, 12
	and rax, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rax, 0x00000009
	jbe esn4;  salta si es numero
	ja ess4; salta si es string

esn4:
	add rax, 0x30 
	;mov rsi, rax 	
	jmp quinto
 ess4:
	add rax, 0x37

	;mov rsi, rax 
	;add rsi, 0x29  ; 0x37 + 0x29 = 0x60 	

quinto:
	shl rax, 32
	;shl rsi, 32 
	or rcx ,    rax
	;or [SaveInTxt], rsi 

	mov rax,      [string]   ; r15 
	shr rax, 16
	and rax, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rax, 0x00000009
	jbe esn5;  salta si es numero
	ja ess5; salta si es string

esn5:
	add rax, 0x30 
	;mov rsi, rax 		
	jmp sexto
 ess5:
	add rax, 0x37

	;mov rsi, rax 
	;add rsi, 0x29  ; 0x37 + 0x29 = 0x60 	

sexto:
	shl rax, 24
	;shl rsi, 24 
	or rcx ,    rax
	;or [SaveInTxt], rsi 

	mov rax,      [string]   ; r15 
	shr rax, 20
	and rax, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rax, 0x00000009
	jbe esn6;  salta si es numero
	ja ess6; salta si es string

esn6:
	add rax, 0x30 
	;mov rsi, rax
	jmp setimo
 ess6:
	add rax, 0x37

	;mov rsi, rax
	;add rsi, 0x29  ; 0x37 + 0x29 = 0x60 

setimo:
	shl rax, 16
	;shl rsi, 16 
	or rcx ,     rax
	;or [SaveInTxt],  rsi 

	mov rax,      [string]   ; r15 
	shr rax, 24
	and rax, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rax, 0x00000009
	jbe esn7;  salta si es numero
	ja ess7; salta si es string

esn7:
	add rax, 0x30 
	;mov rsi, rax 
	jmp octavo
 ess7:
	add rax, 0x37

	;mov rsi, rax 
	;add rsi, 0x29 
octavo:

	shl rax, 8
	;shl rsi, 8 
	or rcx ,    rax
	;or [SaveInTxt], rsi 

	mov rax,      [string]   ; r15 
	shr rax, 28
	and rax, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rax, 0x00000009
	jbe esn8;  salta si es numero
	ja ess8; salta si es string

esn8:
	add rax, 0x00000030; lo convierte en numero ascii
	;mov rsi, rax 
	jmp saledec
 ess8:
	add rax, 0x00000037; lo conv en letra

	;mov rsi, rax 
	;add rsi, 0x00000029 
;________________________________________
saledec:
	or rcx , rax 
	;or [regout],    rax
	;or [SaveInTxt], rsi 

;	mov r13, [regout]
 	ret





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
;	mov dword [rsp+OFFSET_DECODE_PROCESS],    r15d 
	mov [OPC], 			rdx 

;--------------------- Mask & shift for $rs 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory; 
	and r8d, 0000_0011_1110_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			21  						  ; shifting 20 bits
	mov edx, 			r8d
	shr edx,			cl 	

	
	mov [RS], 			rdx  

	imul rdx,            4 
	mov r14, 			rdx                           ; $r14 is the rs pointer
 
	add r14, 			OFFSET_POINTER_REG	          ; adding memory offset to $r13 to start in Register Bank allocation 
	
 ;	mov rax,            r14
 ;	sub rax,            OFFSET_POINTER_REG
; 	shr rax, 2 
	;mov dword [rsp+OFFSET_DECODE_PROCESS+4],  r14d ;    eax



;--------------------- Mask & shift for $rt 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0001_1111_0000_0000_0000_0000b ; masking address $rt
	mov rcx, 			16       	    			  ; shifting 16 bits
	mov edx, 			dword r8d
	shr edx,			cl 

	mov [RT], 			rdx   ; ?[rdx]

	imul rdx, 			4  							  ; escale x4
;	sub rdx, 			4							  ; substract 4 to point propertly	
	;add rbx, 4

	mov r13, 			rdx      				      ; $r13 is the rt pointer
	add r13, 			OFFSET_POINTER_REG            ; Jumping Memory allocation 

;---------------------- Mask & shift for $rd 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1000_0000_0000b ; masking address $rd
	mov rcx, 			11							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	
	mov [RD], 			rdx 

	imul rdx, 		  	4
;	sub rdx, 			4
	;add rbx, 4

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
	mov [FUNCT], 			rdx 

;---------------------- Mask & shift for Inmediate 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1111_1111_1111b ; masking address $rd
	mov r9d,			r8d 
	mov [IMM], 			rdx 

;---------------------- Mask & shift for Address 	
	mov r8d, 			dword [rsp+rbx]				  ; getting instruction from memory
	and r8d, 0000_0011_1111_1111_1111_1111_1111_1111b ; masking address $rd
	mov [ADDRS], 			rdx 

	
	
	ret

%macro CmpItype 0 
		cmp r15d, 0x8 ; addi
		je _addi 

;		cmp r15d, 0xd ; ori
;		je _ori 

		cmp r15d, 0xc ; andi  
		je _andi

		;cmp r15d, 0xa ; slti
		;je _slti

		;cmp r15d, 0xb 
		;je _sltiu

;		cmp r15d, 0x4 ; beq
;		je _beq

;		cmp r15d, 0x5 ; bne
;		je _bne

		cmp r15d, 0x2 ; j
		je _j 

		cmp r15d, 0x3 ; jal
		je _jal 

		cmp r15d, 0x23 ; lw
		je _lw

		ret
%endmacro		


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
	;mov [Opcode], r15d
	;mov [Function], r10d 

	cmp r15d, 0x00
	je  _OPcodeR
	jne _OPcodeI

	_OPcodeI:  
		CmpItype
 

	_OPcodeR:




;		cmp r10d, 0x00 ; shl function
;		je _shl 			
 
;		cmp r10d, 0x02 ; shr function
;		je _shr
 
		cmp r10d, 0x18 ; *mult function
		je _imul 

		;cmp r10d, 0x10 ; mfhi function
		;je _mfhi
		;cmp r10d, 0x12 ; mfhi function
		;je _mflo

		cmp r10d, 0x20 ; add function
		je _add 									

		cmp r10d, 0x22 ; sub function
		je _sub 

;		cmp r10d, 0x23 ; subu function 
;		je _subu
		
		cmp r10d, 0x24 ; and function
		je _and 										
									 
		cmp r10d, 0x25 ; or function
		je _or 						
 
;		cmp r10d, 0x27 ; nor function
;		je _nor 

		;cmp r10d, 0x2a ; slt function
		;je _slt 

		;cmp r10d, 0x2b ; sltu function
		;je _sltu 

		cmp r10d, 0x21 ; addu function
		je _addu 

		cmp r10d, 0x8  ; jr function
		je 	_jr
		


		jmp _endAlu


	_add:
		

  		;call _ApilaDecodific   ; Guarda decodificaciones en rsp para llamarlo al final del codigo para imprimirlo en el txt 
 		call _PantallaTipoR    ; Imprime el contenido de la decodificación para instruccion R  

		mov eax,		       dword [rsp+r14+OFFSET_RSPCALL-4] ; +8, because call use rsp register	; Se pasan los datos a los registros que van a operar
		add eax, 			   dword [rsp+r13+OFFSET_RSPCALL-4] ; Se realiza la operacion
		mov dword [rsp+r12+OFFSET_RSPCALL-4], eax
		
;		call _ifRegPantalla
  

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
		mov eax,			 dword [rsp+r14+OFFSET_RSPCALL -4]	 ; getting data 
		and eax, 			 dword [rsp+r13+OFFSET_RSPCALL -4] 
		mov dword [rsp+r12+OFFSET_RSPCALL -4], eax
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
;	_nor:
;		impr_texto Op4,tamano_Op4
;		mov eax, 		     dword [rsp+r14+OFFSET_RSPCALL]
;		or eax, 			 dword [rsp+r13+OFFSET_RSPCALL] 
;		not eax
;		mov dword [rsp+r12+OFFSET_RSPCALL], eax			 
;		ret 

;	_shl: ; ******   sll 
;		;impr_texto Op5,tamano_Op5 
;		mov eax,             dword [rsp+r13+OFFSET_RSPCALL] ; rt ! 
;		mov ecx, 			 dword [Shamt]
;		shl eax,             cl
;		mov dword [rsp+r12+OFFSET_RSPCALL], eax		       ; output pointer is rd
;		ret 

;	_shr: ; ******   srl
;		;impr_texto Op6,tamano_Op6
;		mov eax,			 dword [rsp+r13+OFFSET_RSPCALL]
;		mov ecx, 			 dword [Shamt]
;		shr eax,			 cl
;		mov dword [rsp+r12+OFFSET_RSPCALL], eax		       ; output pointer is rd		
;		ret 

	_jr:	 ; PC = R[rs]
		mov ebx,             dword [rsp+r14+OFFSET_RSPCALL] ; PC<--R[rs] 
		ret 

	_lw:
		mov eax,             dword [rsp+r14+OFFSET_RSPCALL] ; [rs]
		mov r8d, 4
		add eax,             r9d               ; [rs] + Imm
		;imul eax, 4 						   ; (6)*4 = 24, byte adjust 
		imul r8d 
 

							         ; se multiplica por -1 para que el resultado sea positivo
		 
		_GoGetIt:
			;mov dword [PlayHard],         eax 				 ; guarda el valor modificado en el registro deseado
			
			mov r10d,            dword [rsp+rax+OFFSET_RSPCALL+OFFSET_POINTER_DATAMEM]
			mov dword [rsp+r13+OFFSET_RSPCALL], r10d ;eax
	 
		ret 




	_sub:
		impr_texto Op7,tamano_Op7
		mov eax,			 dword [rsp+r14+OFFSET_RSPCALL -4]
		sub eax,			 dword [rsp+r13+OFFSET_RSPCALL -4] 
		
		_sub2:
			mov dword [rsp+r12+OFFSET_RSPCALL -4], eax	 
		ret

;	_subu:
;		mov eax,         dword [rsp+r13+OFFSET_RSPCALL] 	   ; rt pointer	
;		cmp eax,         0
;		jg _subuRtIsPositive              	   ; Unsigned operation 
;		mov r9d,         -1                    ; se carga el registro con -1 para multiplicar
;		imul r9d                               ; se multiplica por -1 para que el resultado sea positivo

		
;		_subuRtIsPositive:
;			mov r9d,         eax 			    

;			mov eax,     dword [rsp+r14+OFFSET_RSPCALL]     ; rs pointer
;			cmp eax,     0
;			jg _subuRsIsPositive
;			mov ebp,     -1
;			imul ebp 
 
;		_subuRsIsPositive:
;			sub eax,     r9d 
;			mov dword [rsp+r12+OFFSET_RSPCALL], eax
;			ret 

;	_ori:
;		mov eax,         dword [rsp+r14+OFFSET_RSPCALL]
;		or eax,          r9d  				   ; Imm
;		mov dword [rsp+r13+OFFSET_RSPCALL], eax
;		ret


;	_beq: 
;		mov eax,         dword [rsp+r14+OFFSET_RSPCALL]  ; [rs]
;		sub eax,         dword [rsp+r13+OFFSET_RSPCALL]  ; [rt]

;		cmp eax,         0
;		je _BeqC
;		jne _BeqR

;		_BeqC:
;			add ebx,                    r9d 
;			ret 

;		_BeqR: 
;			ret 


;	_bne: 
;		mov eax,         dword [rsp+r14+OFFSET_RSPCALL]  ; [rs]
;		sub eax,         dword [rsp+r13+OFFSET_RSPCALL]  ; [rt]
;		cmp eax,         0
;		je _bneC
;		jne _bneR

;		_bneR:
;			add ebx,                    r9d  
;			ret 

;		_bneC:  
;			ret 

	_j:
		mov ebx, 		r8d 				; getting the jAddress
		ret         

	_jal: 
		;add ebx, 8
		;PC+8;sub ebx,  8  ; apuntando a la instruccion anterior (suponiendo que estan consecutivas, REVISAR)
		mov dword [rsp+OFFSET_POINTER_REG+OFFSET_RSPCALL +124], ebx ; R[31] = PC+8
											; R[31] => 31*4 = 124
		;add ebx, 8
		;_jal2:			
		mov ebx,        r9d  
		add ebx, 4
		ret 

;	_slt: 
		;impr_texto Op15,tamano_Op15
;		mov eax,      dword [rsp+r14+OFFSET_RSPCALL] ; rs pointer
;		cmp eax,      dword [rsp+r13+OFFSET_RSPCALL] ; rt pointer
;		jl _Rd1

;		_Rd0:
;			mov eax,  0
;			mov dword [rsp+r12+OFFSET_RSPCALL], eax
;			ret 

;		_Rd1:
;			mov eax,  1
;			mov dword [rsp+r12+OFFSET_RSPCALL], eax
;			ret	

;	_slti:
;		mov eax,         dword [rsp+r14+OFFSET_RSPCALL] ; rs pointer	
;		cmp eax,         r9d               ; cmp with imm 
;		jl _sltiSetLess

;		mov dword [rsp+r13+OFFSET_RSPCALL],  0          ; [rs] = 0
;		ret

;		_sltiSetLess: 
;			mov dword [rsp+r13+OFFSET_RSPCALL], 1       ; [rt] = 1
;			ret


;    _sltiu: ; ESTA TODAVIA NO FUNCIONA
;    	mov eax,         dword [rsp+r14+OFFSET_RSPCALL]       ; [rs]
;    	cmp eax,         0
;		jg _sltiuSetLess
		; Unsigned operation 
;		mov r10d,        -1  ; r10d reg because we don't need function
;		imul r10d             ; se multiplica por -1 para que el resultado sea positivo

;		_sltiuSetLess:
;			mov r8d,      eax			
;			continueSltiu0:
;				mov eax,       r9d	

;				cmp eax,      0
;				jg _continueSltiu

;				mov ebp,     -1
;				imul ebp            ; eax = imm
		
;		_continueSltiu:
;			cmp eax,      r8d
;			jl _Rd0iu

;		_Rd0iu:
;			mov eax,  0
;			mov dword [rsp+r13+OFFSET_RSPCALL], eax
;			ret 

;		_Rd1iu:
;			mov eax,  1
;			mov dword [rsp+r13+OFFSET_RSPCALL], eax
;			ret	    	



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

;		_Rd1u:
;			mov eax,  1
;			mov dword [rsp+r12+OFFSET_RSPCALL], eax
;			ret	


	_imul: ; *******
		;impr_texto Op8,tamano_Op8
		;mov eax,			 dword [rsp+r14+8] ; (?)
		;mov ebx,			 dword [rsp+r13+8]
		mov r9d,             dword [rsp+r14+OFFSET_RSPCALL]
		mov eax,			 dword [rsp+r13+OFFSET_RSPCALL]
		 
		imul r9 ;eax ;ebx
		_continueImul:
			mov rsi, rax
		;mov [var_mfhi], rax
		 
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
  DecodeProccess: equ 320  ; op, funct, rs ...    ; 8(10 veces) *4 

  TOT_MEM:		  equ 1248 ;928 ;1128 ;928 ;240 ; 928    ; iMEM+REG_B
 

  msg:            db " Memory Allocated! ", 10
  len:            equ $ - msg
  fmtint:         equ $RS ; $string ; $RS ;, 10, 0
  fmtint2:        equ $string ;
  enterNow:       equ $enter





  fmtint3:        equ $regout
  fmtint4:        equ $regout_aux

  model:          equ $regout_Model
  family:         equ $regout_family

  fmtint01:		  equ $regout_aux1
  fmtint02:		  equ $regout_aux2
  fmtint03:		  equ $regout_aux3
  fmtint04:		  equ $regout_aux4
  fmtint05:		  equ $regout_aux5
  fmtint06:		  equ $regout_aux6
  fmtint07:		  equ $regout_aux7
  fmtint08:		  equ $regout_aux8

  fmtint_v0:		  equ $regout_v0
  fmtint_v1:		  equ $regout_v1
  fmtint_a0:		  equ $regout_a0
  fmtint_a1:		  equ $regout_a1
  fmtint_a2:		  equ $regout_a2
  fmtint_a3:		  equ $regout_a3
  fmtint_s0:		  equ $regout_s0
  fmtint_s1:		  equ $regout_s1  
  fmtint_s2:		  equ $regout_s2
  fmtint_s3:		  equ $regout_s3
  fmtint_s4:		  equ $regout_s4
  fmtint_s5:		  equ $regout_s5 
  fmtint_s6:		  equ $regout_s6
  fmtint_s7:		  equ $regout_s7
  fmtint_sp:		  equ $regout_sp 

  fmtint5:        equ $TEXT
;  fmtint3_aux:    equ $regout_aux
  ;SaveInTxt_Print:     equ $SaveInTxt
;  SaveInTxt_aux2: equ $SaveInTxt_aux

  RS1:			  equ $RS
  
  OUTPUT_FILE_NAME:    db "Resultados.txt", 0 ; nombre de archivo a escribir
  OUTPUT_FILE_LENGTH:  equ 21

  FILE_NAME:      db "code.txt", 0
  FILE_LENGTH:    equ 21 ;40 ;200 				        		; length of inside text
  

  ;OFFSET_POINTER_ADDRESS:  equ 184 ; 
  OFFSET_DECODE_PROCESS:   equ 924 ; 928
  OFFSET_RSPCALL:          equ 8  
  OFFSET_POINTER_DATAMEM:  equ 528 ;728 ;528 ; 184  ;528;; iMEM_BYTES+REG_BYTES
  OFFSET_POINTER_REG:      equ 400 ; iMEM_BYTES 				; 1 dword = 4 bytes
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




;tecla
var_nombre: db ''

;Inicio
	pantalla_inicio_1: db 'Bienvenido al Emulador MIPS', 0xa
	l1_tamano: equ $-pantalla_inicio_1

	pantalla_inicio_2: db 'EL-4313-Lab. Estructura de Microprocesadores', 0xa
	l2_tamano: equ $-pantalla_inicio_2

	pantalla_inicio_3: db '1S-2017', 0xa
	l3_tamano: equ $-pantalla_inicio_3

	pantalla_inicio_4: db 'Buscando archivo ROM.txt', 0xa
	l4_tamano: equ $-pantalla_inicio_4

;Error archivo
	error: db 'Archivo ROM.txt no encontrado', 0xa
	error1: equ $-error

	noerror: db 'Archivo ROM.txt encontrado', 0xa
	noerror1: equ $-noerror


;Pantalla final
    
	pantalla_final_0: db 0xa,'Ejecucion Exitosa',0xa 
	l5_tamano: equ $-pantalla_final_0


     pantalla_final_1: db 'Felipe Munoz Soto 201121294', 0xa
	l7_tamano: equ $-pantalla_final_1

	pantalla_final_2: db 'Jose Alvarado Montero 2011251289  ', 0xa
	l8_tamano: equ $-pantalla_final_2

     pantalla_final_3: db 'Benjamin Jimenez Camacho 201124725   ', 0xa
	l9_tamano: equ $-pantalla_final_3

        pantalla_final_4: db 'Carlos Andres Gomez Garcia 2013003421   ', 0xa
	l10_tamano: equ $-pantalla_final_4

        pantalla_final_5: db 'Edgar Daniel Chaves Godinez 2013095110  ', 0xa
	l11_tamano: equ $-pantalla_final_5

        pantalla_final_6: db 'Benjamin Jimenez Camacho 201124725  ', 0xa
	l12_tamano: equ $-pantalla_final_6

        pantalla_final_7: db 0xa,'Fabricante del Procesador:  '
	l13_tamano: equ $-pantalla_final_7

        pantalla_final_8: db 0xa,'Modelo del Procesador :   '
	l14_tamano: equ $-pantalla_final_8

      pantalla_final_9: db 0xa,'Familia del Procesador :   '
	l15_tamano: equ $-pantalla_final_9

        pantalla_final_10: db 0xa,'Presione Enter para terminar'
	l16_tamano: equ $-pantalla_final_10     



;------------------- Alu -----------------------------
  l1: db 0xa, 'Inicio del Programa '
  tamano_l1: equ $-l1

  Print_Add:		db 0xa, 'Se realiza un add ' 
  Add_Length:       equ $-Print_Add

  Op2: db 0xa, 'Se realiza un and '
  tamano_Op2: equ $-Op2
  Op3: db 0xa, 'Se realiza un or ' 
  tamano_Op3: equ $-Op3
  Op4: db 0xa, 'Se realiza un nor '
  tamano_Op4: equ $-Op4
  Op5: db 0xa, 'Se realiza un Shift left '
  tamano_Op5: equ $-Op5
  Op6: db 0xa, 'Se realiza un Shift Right '
  tamano_Op6: equ $-Op6
  Op7: db 0xa, 'Se realiza una Resta '
  tamano_Op7: equ $-Op7
  Op8: db 0xa, 'Se realiza una multiplicacion '
  tamano_Op8: equ $-Op8
  l3: db 0xa, 'Fin del Programa '
  tamano_l3: equ $-l3
  num1: equ 0x1

;----------------- Prints ----------------------------
	cons_banner0: db 0xa, 'La instruccion es de tipo R y posee el siguiente formato : ', 0xa 		
	cons_tamano_banner0: equ $-cons_banner0				

	cons_banner01: db 0xa, 'Opcode :   ' 			
	cons_tamano_banner01: equ $-cons_banner01		

	cons_banner02: db 0xa, 'RS :       '			
	cons_tamano_banner02: equ $-cons_banner02		

	cons_banner03: db 0xa, 'RT :       '			
	cons_tamano_banner03: equ $-cons_banner03	

	cons_banner04: db 0xa, 'RD :       '			
	cons_tamano_banner04: equ $-cons_banner04

    cons_banner05: db 0xa, 'Shamt :    '
	cons_tamano_banner05: equ $-cons_banner05

	cons_banner06: db 0xa, 'Function : ' 
	cons_tamano_banner06: equ $-cons_banner06

	cons_banner07: db 0xa, 'Immediate : '			
	cons_tamano_banner07: equ $-cons_banner07

	cons_banner08: db 0xa, 'Address :   '			
	cons_tamano_banner08: equ $-cons_banner08

	cons_banner2: db 0xa, 'La instruccion es de tipo I y posee el siguiente formato : '
	cons_tamano_banner2: equ $-cons_banner2		

	cons_banner3: db 0xa, 'La instruccion es de tipo J y posee el siguiente formato : '			
	cons_tamano_banner3: equ $-cons_banner3		


	v0_Reg:       db     0xa, 'Contenido en Registro $v0 : '
	v1_Reg:		  db     0xa, 'Contenido en Registro $v1 : '
	a0_Reg:		  db     0xa, 'Contenido en Registro $a0 : '   
	a1_Reg:		  db     0xa, 'Contenido en Registro $a1 : '
	a2_Reg:		  db     0xa, 'Contenido en Registro $a2 : '
	a3_Reg:		  db     0xa, 'Contenido en Registro $a3 : '
	s0_Reg:		  db     0xa, 'Contenido en Registro $s0 : '
	s1_Reg:		  db     0xa, 'Contenido en Registro $s1 : '
	s2_Reg:		  db     0xa, 'Contenido en Registro $s2 : '
	s3_Reg:		  db     0xa, 'Contenido en Registro $s3 : '
	s4_Reg:		  db     0xa, 'Contenido en Registro $s4 : '
	s5_Reg:		  db     0xa, 'Contenido en Registro $s5 : '
	s6_Reg:		  db     0xa, 'Contenido en Registro $s6 : '
	s7_Reg:		  db     0xa, 'Contenido en Registro $s7 : '
	sp_Reg:       db     0xa, 'Contenido en Registro $sp : '
	AllReg_Content_Length: equ 28                            ; Contant = 28 for this block



	string:    db 8
	Ascii2Hex: db 8 ; 32
 
section .bss
	FD_OUT: 	    resb 1
	FD_IN: 		    resb 1
	TEXT: 		    resb 32

	Shamt:          resb 4
   	BranchAddress:  resb 4   
 
  	OPC: 			resb 64
  	RS:  			resb 64 
	RT:  			resb 64
 	RD:  			resb 64
 	FUNCT:          resb 64
 	IMM:            resb 64
 	ADDRS: 			resb 64

 	Address: resb 4
 	Immediate: resb 2
 	Opcode: resb 1
 	Function: resb 1
 
	regout: 		resb 8

	texto1:         resb 30 

	regout_Model:   resb 8
	regout_family:  resb 8 

	regout_aux: 	     resb 100 ; 64
	regout_aux_RegFinal: resb 250 ;100 ; 64
	regout_aux1:    resb 8 
	regout_aux2:    resb 8
	regout_aux3:    resb 8 
	regout_aux4:    resb 8
	regout_aux5:    resb 8
	regout_aux6:    resb 8 
	regout_aux7:    resb 8  
	regout_aux8:    resb 8 
	regout_aux9:    resb 8 

	regout_v0:    resb 8 
	regout_v1:    resb 8 
	regout_a0:    resb 8 
	regout_a1:    resb 8 
 	regout_a2:    resb 8 
 	regout_a3:    resb 8 
 	regout_s0:    resb 8 
	regout_s1:    resb 8   
 	regout_s2:    resb 8 
	regout_s3:    resb 8 
	regout_s4:    resb 8 
 	regout_s5:    resb 8  
  	regout_s6:    resb 8 
 	regout_s7:    resb 8 
 	regout_sp:    resb 8 
 

	contador: resb 8
	 
 	enter: resb 1
	arg1: resb 8 
	arg2: resb 8
	arg3: resb 8 
	arg4: resb 8	

;	Banco_Registros:  resb 128 

section  .text
   global _start       


_start:                     			; tell linker entry point


_inicio:
	
	mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_inicio_1
	mov rdx, l1_tamano
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_inicio_2
	mov rdx, l2_tamano
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_inicio_3
	mov rdx, l3_tamano
	syscall

	
	mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_inicio_4
	mov rdx, l4_tamano
	syscall



_Reg0:

	pop rcx ;argc
	;cmp rcx, 4 ;if no arguments, then
	;jl _end ;noArgs ;error.
	pop rcx ;argv[0] (program name)
		
	pop_arg1:
		pop rcx ; 1st arg
		mov r15,     [rcx]
		mov [arg1],  r15  

	pop_arg2:
		pop rcx ; 2nd arg
		mov r15,     [rcx]
		mov [arg2],  r15
		;impr_texto [arg2], 8
	pop_arg3:
		pop rcx ; 3th arg
		mov r15,     [rcx]
		mov [arg3],  r15 
		;impr_texto [arg3], 8
	pop_arg4:
		pop rcx ; 1st arg
		mov r15,     [rcx]
		mov [arg4],  r15 
    	;impr_texto [arg4], 8

	

_MIPS:

	xor rcx, 			rcx 
	xor r12, r12
	sub rsp, 			TOT_MEM         ; number of memory bytes allocation		
      

	
_txt:

	call _FillBuffer
;------------------ At this point -------------------------
;----------- $rsi have txt instructions -------------------


	xor r13, r13
	xor r14, r14
	xor rax, rax 
;	mov r10, 0xa 
;	mov [enter], r10  

;------------- Loads Instruction into Memory --------------
;------------------------- PC -----------------------------

	call _Instruction2Memory

;------------------------------- At this point -----------------------------------
;------------- Virtual memory $rsp contains addressed instructions ---------------
 

;------------------- Initialization of Arguments Registers -----------------------
	call _ArgumentsRegInit





_Reg001:
	mov rcx, iMEM_BYTES/4   								; Number of words for the assignation ;  
	mov ebx, 0x4     									; 0x38 last word  ; 0x24  ; first instruct address +4 
	
	xor rax, rax 


	jmp _PCLoop
	;mov eax, [arg1]
	;mov dword [rsp+OFFSET_POINTER_DATAMEM +28], eax ;0xf     ; (29)*4 =116 , 
												        ;manually load to dataMem


_PCLoop:

	add ebx,                0x4 
	dec rcx  
	mov [contador],         rcx


	call _DECO 
    call _Alu2
     
	mov rcx, [contador]

	cmp rcx, 0x0
	je _Reg1
	jne _PCLoop

_Reg1: 
	mov r10, 0xa 
	mov [enter], r10  
  
	jmp _pantallafinal


_error:

	mov rax, 1
	mov rdi, 1
	mov rsi, error
	mov rdx, error1
	syscall
    
    mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_final_10
	mov rdx, l16_tamano
	syscall

	mov rax, 0
	mov rdi, 0
	mov rsi, var_nombre
	mov rdx, var_nombre
	syscall

	jmp _end
 	
_pantallafinal:

	impr_textoPantalla pantalla_final_0, l5_tamano

	impr_textoPantalla pantalla_final_1, l7_tamano

	impr_textoPantalla pantalla_final_2, l8_tamano    

	impr_textoPantalla pantalla_final_3, l9_tamano

	impr_textoPantalla pantalla_final_4, l10_tamano

	impr_textoPantalla pantalla_final_5, l11_tamano    

	impr_textoPantalla pantalla_final_6, l12_tamano
    

;Imprime Fabricante
 	
    mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_final_7
	mov rdx, l13_tamano
	syscall

 	mov eax, 0; fabricante
 	cpuid; get the vendor name
 	mov [texto1],ebx ; store the result in vendor_id
 	mov [texto1+4],edx
 	mov [texto1+8],ecx
 	impr_textoPantalla texto1 , 30


;imprime el modelo del procesador
 	
 	mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_final_8
	mov rdx, l14_tamano
	syscall    


    mov eax, 1 
 	cpuid;familia
 	and eax,0x0F0
 	shl eax, 24
 	mov [string], eax
 	call Hex2Ascii
    mov[regout_Model], rcx
    impr_textoPantalla  model,1

;imprime la familia que pertenece al procesador
 	mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_final_9
	mov rdx, l15_tamano
	syscall     

    mov eax, 1 
 	cpuid
	and eax,0xF00
	shl eax, 20 
 	mov[string],eax
 	call Hex2Ascii
 	mov [regout_family], rcx
 	impr_textoPantalla  family,1
 	
 
    mov rax, 1
	mov rdi, 1
	mov rsi, pantalla_final_10 
	mov rdx, l16_tamano
	syscall

	mov rax, 0
	mov rdi, 0
	mov rsi, var_nombre
	mov rdx, var_nombre
	syscall

 

	Opentxt

	PrintREGFinal

		
_end:
 	mov rax,       		 SYS_EXIT
   	mov rdi,       		 STDIN
    xor rbx,       		 rbx
    syscall
