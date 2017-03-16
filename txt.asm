
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
	  	mov rax, 			qword [TEXT+%1+1]   	; [..] Instruction;
	  	mov rdx, 			rax
	  	mov ecx, 			32						; Shift 32 bits
	  	shr rdx, 			cl              		
		xor rax, 			rax
		mov eax, 			edx

	; The input text is hex in ASCII so you receive : 
	; word format     :		$eax : 0011abcd_0011efgh_0110ijkl_0110mnño...   
	; and you want it :     $rsp : abcd_efgh_ijkl_mnño...
	;------------------------------------------------
	       ; 20080003 >> for 3
	  	mov r8d, 			eax 					; $aux1
	  	mov r9d,            eax						; $r9d has the instruction to fix 
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
		mov eax, 			dword [TEXT+r13+1]  	; Truncate Buffer
			; 20080003 >> es el 2
		mov r8d, 			eax 	            	; $aux5 
		mov r9d,            eax 	
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
	mov r10d, 0x30 
	cmp eax, r10d 
	je _50

	mov r10d, 0x31
	cmp eax, r10d 
	je _51  
	
	mov r10d, 0x32
	cmp eax, r10d
	je _52 
	
	mov r10d, 0x33
	cmp eax, r10d
	je _53 
	
	mov r10d, 0x34
	cmp eax, r10d
	je _54 
	
	mov r10d, 0x35
	cmp eax, r10d 
	je _55 
	
	mov r10d, 0x36
	cmp eax, r10d
	je _56 

	mov r10d, 0x37
	cmp eax, r10d
	je _57
	
	mov r10d, 0x38
	cmp eax, r10d 
	je _58 
	
	mov r10d, 0x39
	cmp eax, r10d
	je _59 	
;------------------- Check which hex to fix {ABCDEF}
	mov r10d, 0x61
	cmp eax, r10d
	je _A5 
	
	mov r10d, 0x62
	cmp eax, r10d
	je _B5 
	
	mov r10d, 0x63
	cmp eax, r10d 
	je _C5 
	
	mov r10d, 0x64 
	cmp eax, r10d
	je _D5 
	
	mov r10d, 0x65
	cmp eax, r10d
	je _E5 
	
	mov r10d, 0x66
	cmp eax, r10d
	je _F5 
;------------------- This fix for {ABCDEF}
	_A5:
		mov r10d, 0x0A
		mov eax, r10d
		ret 
	_B5:
		mov r10d, 0x0B
		mov eax, r10d
		ret 
	_C5:	
		mov r10d, 0x0C
		mov eax, r10d
		ret 
	_D5:
		mov r10d, 0x0D
		mov eax, r10d			
		ret
	_E5:
		mov r10d, 0x0E
		mov eax, r10d
		ret 
	_F5:
		mov r10d, 0x0F
		mov eax, r10d
		ret
;------------------- This fix for {0123456789}
	_50:
		mov r10d, 0x00
		mov eax, r10d
		ret 					
	_51:
		mov r10d, 0x01
		mov eax, r10d
		ret 
	_52:	
		mov r10d, 0x02
		mov eax, r10d
		ret 
	_53:
		mov r10d, 0x03
		mov eax, r10d			
		ret
	_54:
		mov r10d, 0x04
		mov eax, r10d
		ret 
	_55:
		mov r10d, 0x05
		mov eax, r10d
		ret
	_56:	
		mov r10d, 0x06
		mov eax, r10d
		ret 
	_57:
		mov r10d, 0x07
		mov eax, r10d			
		ret 
	_58:
		mov r10d, 0x08
		mov eax, r10d
		ret 
	_59:
		mov r10d, 0x09
		mov eax, r10d
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

%macro DECO 1 ;$r10 is the instruction that will be decoded
	xor r8, r8 
	xor r9, r9 
	;xor r10, r10
	xor r12, r12 
	xor r13, r13
	xor r14, r14
	xor r15, r15 

	;mov r10, 0x2c ; INSTRUCCION QUE SE ESTA DECODIFICANDO 


;--------------------- Mask & shift for OPcode 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory; 
	and r8d, 1111_1100_0000_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			26  						  ; shifting 26 bits
	mov edx, 			dword r8d
	shr edx,			cl 							  ; $rdx is the output ( OPCODE )
	mov r15,            rdx


;--------------------- Mask & shift for $rs 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory; 
	and r8d, 0000_0011_1110_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			21  						  ; shifting 20 bits
	mov edx, 			dword r8d
	shr edx,			cl 	
	imul rdx, 			4 
	sub rdx, 			4	

	mov rax, 			rdx 
	mov r14, 			rax                           ; $r13 is the rs pointer
	add r14, 			OFFSET_POINTER_REG	          ; adding memory offset to $r13 to start in Register Bank allocation 

;--------------------- Mask & shift for $rt 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0001_1111_0000_0000_0000_0000b ; masking address $rt
	mov rcx, 			16       	    			  ; shifting 16 bits
	mov edx, 			dword r8d
	shr edx,			cl 
	imul rdx, 			4  							  ; escale x4
	sub rdx, 			4							  ; substract 4 to point propertly	

	mov rax, 			rdx
	mov r13, 			rax							  ; $r14 is the rt pointer
	add r13, 			OFFSET_POINTER_REG            ; Jumping Memory allocation 

;---------------------- Mask & shift for $rd 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1000_0000_0000b ; masking address $rd
	mov rcx, 			11							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	imul rdx, 			4
	sub rdx, 			4

	mov rax, 			rdx
	mov r12, 			rax					     	  ; $r14 is the rt pointer
	add r12, 			OFFSET_POINTER_REG 			  ; starting above memory 

;---------------------- Mask & shift for FUNCTION 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_0000_0000_0011_1111b ; masking address $rd
	mov rcx, 			0							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	mov r10,            rdx

;---------------------- Mask & shift for Inmediate 	
		;CERO 
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1111_1111_1111b ; masking address $rd
	mov r9d,			r8d 
	
	;mov rcx, 			0							  ; shifting 11 bits
	;mov edx,		    dword r8d
	;shr edx,			cl 
	;;mov r9,             rdx 

;---------------------- Mask & shift for Address 	
	mov r8d, 			dword [rsp+%1]				  ; getting instruction from memory
	and r8d, 0000_0011_1111_1111_1111_1111_1111_1111b ; masking address $rd
	;mov rcx, 			0							  ; shifting 11 bits
	;mov edx,		    dword r8d
	;shr edx,			cl 
	;mov r8d,             rdx 
%endmacro


;------------------------------------------------------------------------------
;-------------------------------- ALU -----------------------------------------
;------------------------------------------------------------------------------
;%macro ALUx 4  

;	call _Alu2
	; %1 = [Opcode]   -------Control----- $r15    ( OPCODE )
	; %2 = $r14       ------Reg. Bank---- [rs]    ( rs )
	; %3 = $rax       ---------Mux------- [rax]   ( [rt]=r13 )
	; %4 = [Function] --------Control----      ([Function]=r10 or [Immendiate]=r9) 
	
	;mov r9, 			 rax    					; FUNCT :registro que indica la operacion a realizar
	
	;mov r8d, 			 0      					; registro indice de operacion
  
	;r13  ; --- rs : registro que almacena el primer parametro
	;r14  ; --- rt : registro que almacena el segundo parametro
	;Se compara el registro r9 con el r8 para saber que operacion se desea realizar

;;;;; Function or Immediate compare

	;mov esi, %1
	;call _addix
	;jmp _addix

_Alu2: 
	cmp dword [OpCode], 0x00
	je _OPcodeR
	jne _OPcodeI

	_OPcodeI:  
		cmp dword [OpCode], 0x08   ; addi 
		je _addi 

		;cmp dword [Function], 0x09      FALTA HACER ESTAS ETIQUETAS I
		;je _addiu

	_OPcodeR:
		mov eax, 0x20  ; add function
		cmp dword [Function], eax
		je _add 									

		mov eax, 0x24  ; and function
		cmp dword [Function], eax
		je _and 										
														
		mov eax, 0x25  ; or function
		cmp dword [Function], eax
		je _or 						

		mov eax, 0x27  ; nor function
		cmp dword [Function], eax
		je _nor 

		mov eax, 0x00  ; shl function
		cmp dword [Function], eax
		je _shl 			

		mov eax, 0x02  ; shr function
		cmp dword [Function], eax
		je _shr

		mov eax, 0x18  ; *mult function
		cmp dword [Function], eax
		je _imul 
	


	_add:
		;impr_texto Op1, tamano_Op1 ; Indica al usuario que operacion se realiza
		mov eax,		       dword [rsp+r14+8] ; +8, because call use rsp register	; Se pasan los datos a los registros que van a operar
		mov edx,			   dword [rsp+r13+8]  ; %3] 		; SE DEBE MODIFICAR PARA QUE RECIBA INMEDIATO
		add eax, 			   edx 						    ; Se realiza la operacion
		mov dword [rsp+r12+8], eax
		;mov r9d,             eax
		ret 
	_and:
		impr_texto Op2, tamano_Op2
		mov eax,			 dword [rsp+r14+8]			; getting data 
		mov ebx,			 dword [rsp+r13+8]
		and eax, 			 ebx
		mov r9d,             eax
		ret
	_or:
		impr_texto Op3,tamano_Op3
		mov eax, 			 dword [rsp+r14+8]
		mov ebx,             dword [rsp+r13+8]
		or eax,              ebx
		mov r9d,             eax
		ret 
	_nor:
		impr_texto Op4,tamano_Op4
		mov eax, 		     dword [rsp+r14+8]
		mov ebx,             dword [rsp+r13+8]
		or eax, 			 ebx
		not eax
		mov r9d,             eax
		ret 

	_shl: ; ******   sll 
		impr_texto Op5,tamano_Op5
		mov eax,			 dword [rsp+r14+8]
		mov ecx,			 dword [rsp+r13+8]
		shl eax,             cl
		mov r9d,             eax
		ret 

	_shr: ; ******   srl
		impr_texto Op6,tamano_Op6
		mov eax,			 dword [rsp+r14+8]
		mov ecx,			 dword [rsp+r13+8]
		shr eax,			 cl
		mov r9d,             eax
		ret 

	_sub:
		impr_texto Op7,tamano_Op7
		mov eax,			 dword [rsp+r14+8]
		mov ebx,			 dword [rsp+r13+8]
		sub eax,			 ebx
		mov r9d,             eax
		ret

	_imul: ; *******
		impr_texto Op8,tamano_Op8
		mov eax,			 dword [rsp+r14+8]
		mov ebx,			 dword [rsp+r13+8]
		imul ebx
		mov r9d,             eax
		ret 

;----------------- I-Type----------------------------
; Pointer 	 $rs  ($r14)
; Pointer is $rt  ($r13)
	_addi:
		mov eax, 	    	 dword [rsp+r14+8]    ; Register ( $rs ) Data 
		mov ecx, 			 dword [ImCtrl]     ; Immediate from Control 
		add eax,    		 ecx                ; ImmediateCtrl
		mov dword [rsp+r13+8], eax                ; addi into Reg Bank (addressed $rt) i-type
		ret 



	; OpCode = 0 =>> R-type

%macro CtrlSel 3
	cmp %1, 0x0 
	je _CtrlSelR
	jne _CtrlSelI

	_CtrlSelR: 
		ControlR %1, %2       ; r15d, r10d  
		jmp _endCtrlSel

	_CtrlSelI:
		ControlI %1, %3       ; r15d, r9d

	_endCtrlSel:
%endmacro	

%macro ControlR 2
		; %1 = $r15    ( opcode )
		; %2 = $r10    ( function )
	_Inicio:
        ; obtiene el opcode de la instruccion que esta almacenada en memoria
    	mov dword [OpCode],     %1 	     	  ; obtenido el opcode, se almacena en la direccion de memoria del registro Opcode, para empezar a comparar   

		mov	eax, 			 	 R		      ; Mueve el OpCode de tipo R al registro para su posterior comparacion
    	mov ebx, 			 	 %1 ; OpCode
    	cmp	eax, 			     ebx     	  ; Compara los OpCode
		je       			 	 _ControlR	  ; Si son iguales salta al bloque que ejecuta las instrucciones que dan las salidas 
		jne      			     _endControlR ; _Comparaddi  ; Si no son iguales salta a otro bloque para seguir comparando el OpCode
	    
	_ControlR:
		;mov dword [OpCode],     %1 ; r15d
		mov dword [Function],   %2  ; r10d          ; Passing function 
	    mov eax, 		 	 	AluOP1    ; almacena el valor de operacion en el registro de proposito general
	    mov dword [AluOp],	    eax 		 ; almacena el codigo de operacion en la direccion de memoria AluOp
	    mov eax,		 		RegDST1   ; 
	    mov dword [RegDest],    eax         ; almacena el codigo de en la direccion de memoria RegDest
	    mov eax,		 		Jump1     ;
	    mov dword [Jump],       eax         ;almacena el codigo de en la direccion de memoria Jump
	    mov eax,		 		AluScr0   ;
		mov dword [AluSrc],     eax 		 ;almacena el codigo de en la direccion de memoria AluSrc
		mov eax,		 		RegWrite1 ;
		mov dword [RegWrite],   eax          ;almacena el codigo de en la direccion de memoria Regwrite      
		mov eax,		 		MemtoReg0 ;
		mov dword [MemtoReg],   eax         ;almacena el codigo de en la direccion de memoria MemtoReg
	    					 				 ; Al terminar de asignar los valores a los registros, salta incodicionalmente al inicio para volver a obtener el Opcode         

	_endControlR:     
%endmacro


%macro ControlI 2  ; %2 = immediate (r9d) from deco 
	_InicioI:		
		mov dword [OpCode],     %1

		mov eax, 				addi            ; I-Type
		mov ebx, 				 %1 ;OpCode
		cmp eax, 				ebx
		je 						_ControlI
		jne 					_endControlI

	_ControlI:	 
	   	mov dword [ImCtrl],     %2         ; immediate (r9d)          ; Passing function 
	   	mov eax,                AluOP2    ; almacena el valor de operacion en el registro de proposito general
	   	mov dword [AluOp],      eax       ; almacena el codigo de operacion en la direccion de memoria AluOp
	   	mov eax,                RegDST1   ; 
	    mov dword [RegDest],    eax         ; almacena el codigo de en la direccion de memoria RegDest
	    mov eax,                Jump1     ;
	    mov dword [Jump],       eax       ;almacena el codigo de en la direccion de memoria Jump
	    mov eax,                AluScr0  ;
	    mov dword [AluSrc],     eax       ;almacena el codigo de en la direccion de memoria AluSrc
	    mov eax,                RegWrite1 ;
	    mov dword [RegWrite],   eax       ;almacena el codigo de en la direccion de memoria Regwrite      
	    mov eax,                MemtoReg0 ;
	    mov dword [MemtoReg],   eax       ;almacena el codigo de en la direccion de memoria MemtoReg  

	_endControlI:
%endmacro




section .data
;-------------------  Memory Data -------------------------
  iMEM_BYTES:   equ 56    ; x/4 = words num       		; Instructions Memory allocation
  REG_BYTES:	equ 128   ; 32 dwords 
  TOT_MEM:		equ 184   ; iMEM+REG_B

  msg:          db " Memory Allocated! ", 10
  len:          equ $ - msg
  fmtint:       db "%ld", 10, 0

  FILE_NAME:    db "code.txt", 0
  FILE_LENGTH:  equ 1300 				        		; length of inside text
  
  OFFSET_POINTER_REG:  equ iMEM_BYTES 					; 1 dword = 4 bytes
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

;--------------------- Control Data -------------------------
;se definen las constantes que van a ser los 6 bits del opcode, de acuerdo a la instrucción, y son los que //se van a comparar con el opcode entrante para realizar los condicionales
R: equ 0x00  ;// definicion de la constante del OPCode de las instrucciones tipo R
;definiciones de la constante del OPCode de las instrucciones tipo i y j
addi: equ 0x08
addiu: equ 0x09
andi: equ 0x0C
beq: equ 0x04
;bne: equ 0x05
j: equ 0x02
jal: equ 0x03
lbu: equ 0x24
lhu: equ 0x25
lui: equ 0x25
lw: equ 0x23
sb: equ 0x28
sh: equ 0x29
slti: equ 0x0a
sltiu: equ 0x0b
sw: equ 0x2b



; definicion de los valores que van a obtener las senales de control, segun la tabla de verdad
AluOPx: equ 00000001b ; instruccion branch on equal
AluOP1: equ  00000000b ; instruccion store word y load word ? 
AluOP2: equ  00001000b ; instrucciones R ? 

RegDST0: equ 00000000b ; segundo campo de 5 bits en la instrucción para lw
RegDST1: equ 00000001b ; tercer campo de 5 bits en la instrucción para operaciones de tipo R

Jump0: equ 00000000b ; Dirección de alguna instrucción de tipo I
Jump1: equ 00000001b ; PC + 4

AluScr0: equ 00000000b; (operaciones de tipo R)
AluScr1: equ 00000001b ;Extension de signo(lw, sw)

RegWrite0: equ 00000000b; (No permite escritura)
RegWrite1: equ 00000001b; (Permite escritura)

MemtoReg0: equ 00000000b; desde ALUoutput (para operaciones de tipo R);
MemtoReg1: equ 00000001b; de MDR (para lw)
;---------------------------------------------


section .bss
	FD_OUT: 	resb 1
	FD_IN: 		resb 1
	TEXT: 		resb 32
	Num: 		resb 33 

;------------ Control -----------------
; se reserva 1 byte para cada una
   AluSrc:   resb 4 ; r8
   RegWrite: resb 4 ;r9
   MemtoReg: resb 4 ;r10
   AluOp:    resb 4 ;r11
   RegDest:  resb 4 ;r12
   Jump:     resb 4 ;r13
   OpCode:   resb 4 ;r14 
   Function: resb 4
   ImCtrl:   resb 4 



section  .text
   global _start       
   global _txt
   global _shift
   global _1
   global _2
   global _3
   global _4
   global _5
   global _6
   global _7

_start:                     			; tell linker entry point

	xor rcx, 			rcx 
	sub rsp, 			TOT_MEM         ; number of memory bytes allocation		
 
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
		sub r13,        20						; 20 positions before Index starts the address
		GetFromTxt 		r13 					; output is $r12d
		mov eax,        r12d
		mov r14, 		rax					    ; $r14 is the Memory address pointer
		and r14,        0xFF
		add r13,        20

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

	;mov rbx, 0x2c 		      		; 01095020 INSTRUCCION QUE SE ESTA DECODIFICANDO 
	mov rbx, 0x28                   ; 20080002
	DECO rbx 
	CtrlSel r15d, r10d, r9d 
	call _Alu2

	mov rbx, 0x24                   ; 20080003
	DECO rbx 
	CtrlSel r15d, r10d, r9d 
	call _Alu2

	mov rbx, 0x2c                   ; 01095020
	DECO rbx 
	CtrlSel r15d, r10d, r9d 
	call _Alu2	

	;DECO [rsp+rbx] rbx        			    ; I & R-Type Instructions
	;mov dword [rsp+r13], 3         
	;mov dword [rsp+r14], 2			; preloading because there is not I-Intruct yet
	;ControlR r15d, r10d 

	;ControlI r15d, r9d
	;call _Alu2
	_4:
	

;exit:                               
	_end:
 	mov rax,       		 SYS_EXIT
   	mov rdi,       		 STDIN
    xor rbx,       		 rbx
    syscall
