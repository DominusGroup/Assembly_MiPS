
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


;;;;;;;;;;;;;;; R-Type
%macro deco_RegBankPointers 1 ;$r10 is the instruction that will be decoded
	xor r9, r9 
	xor r12, r12 
	xor r13, r13
	xor r14, r14
	xor r15, r15 

	;mov r10, 0x2c ; INSTRUCCION QUE SE ESTA DECODIFICANDO 


;--------------------- Mask & shift for OPcode 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory; 
	and r8d, 1111_0000_0000_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			28  						  ; shifting 28 bits
	mov edx, 			dword r8d
	shr edx,			cl 							  ; $rdx is the output ( OPCODE )
	mov r12,            rdx


;--------------------- Mask & shift for $rs 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory; 
	and r8d, 0000_0011_1110_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			21  						  ; shifting 20 bits
	mov edx, 			dword r8d
	shr edx,			cl 	
	imul rdx, 			4 
	sub rdx, 			4	

	mov rax, 			rdx 
	mov r13, 			rax                           ; $r13 is the rs pointer
	add r13, 			OFFSET_POINTER_REG	          ; adding memory offset to $r13 to start in Register Bank allocation 

;--------------------- Mask & shift for $rt 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0001_1111_0000_0000_0000_0000b ; masking address $rt
	mov rcx, 			16       	    			  ; shifting 16 bits
	mov edx, 			dword r8d
	shr edx,			cl 
	imul rdx, 			4  							  ; escale x4
	sub rdx, 			4							  ; substract 4 to point propertly	

	mov rax, 			rdx
	mov r14, 			rax							  ; $r14 is the rt pointer
	add r14, 			OFFSET_POINTER_REG            ; Jumping Memory allocation 

;---------------------- Mask & shift for $rd 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1000_0000_0000b ; masking address $rd
	mov rcx, 			11							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	imul rdx, 			4
	sub rdx, 			4

	mov rax, 			rdx
	mov r15, 			rax					     	  ; $r14 is the rt pointer
	add r15, 			OFFSET_POINTER_REG 			  ; starting above memory 

;---------------------- Mask & shift for FUNCTION 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_0000_0000_0011_1111b ; masking address $rd
	mov rcx, 			0							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	mov r9,            rdx
%endmacro



;;;;;;;;;;;;;;; I-Type
%macro deco_RegBankPointersI 1 ;$r10 is the instruction that will be decoded
	xor r9, r9 
	xor r12, r12 
	xor r13, r13
	xor r14, r14
	xor r15, r15 

	;mov r10, 0x2c ; INSTRUCCION QUE SE ESTA DECODIFICANDO 


;--------------------- Mask & shift for OPcode 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory; 
	and r8d, 1111_0000_0000_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			28  						  ; shifting 28 bits
	mov edx, 			dword r8d
	shr edx,			cl 							  ; $rdx is the output ( OPCODE )
	mov r12,            rdx


;--------------------- Mask & shift for $rs 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory; 
	and r8d, 0000_0011_1110_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 			21  						  ; shifting 20 bits
	mov edx, 			dword r8d
	shr edx,			cl 	
	imul rdx, 			4 
	sub rdx, 			4	

	mov rax, 			rdx 
	mov r13, 			rax                           ; $r13 is the rs pointer
	add r13, 			OFFSET_POINTER_REG	          ; adding memory offset to $r13 to start in Register Bank allocation 

;--------------------- Mask & shift for $rt 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0001_1111_0000_0000_0000_0000b ; masking address $rt
	mov rcx, 			16       	    			  ; shifting 16 bits
	mov edx, 			dword r8d
	shr edx,			cl 
	imul rdx, 			4  							  ; escale x4
	sub rdx, 			4							  ; substract 4 to point propertly	

	mov rax, 			rdx
	mov r14, 			rax							  ; $r14 is the rt pointer
	add r14, 			OFFSET_POINTER_REG            ; Jumping Memory allocation 

;---------------------- Mask & shift for Inmediate 	
	mov r8d, 			dword [rsp+%1]					  ; getting instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1111_1111_1111b ; masking address $rd
	mov rcx, 			0							  ; shifting 11 bits
	mov edx,		    dword r8d
	shr edx,			cl 
	mov r9,             rdx 
%endmacro



%macro ALUx 5  
	; %1 = $r12 ( OPCODE )
	; %2 = $r13 ( rs )
	; %3 = $r14 ( rt )
	; %4 = $r15 ( rd )
	; %5 = $r9  (Function) 

;------------------------------------------------------------------------------
;-------------------------------- ALU -----------------------------------------
;------------------------------------------------------------------------------
	;mov r9, 			 rax    					; FUNCT :registro que indica la operacion a realizar
	mov r8, 			 0      					; registro indice de operacion
  

	;r13  ; --- rs : registro que almacena el primer parametro
	;r14  ; --- rt : registro que almacena el segundo parametro
	;Se compara el registro r9 con el r8 para saber que operacion se desea realizar

	cmp r8, %1 
	je _end 										; 0 La ALU no debe realizar ninguna operacion
	inc r8
	cmp r8, %1
	je _add 										; 1 La ALU debe realizar una suma
	inc r8
	cmp r8, %1
	je _and 										; 2 La ALU debe realizar un and
	inc r8
	cmp r8, %1
	je _or 											; 3 La ALU debe realizar un or
	inc r8
	cmp r8, %1
	je _nor 										; 4 La ALU debe realizar un nor
	inc r8
	cmp r8, %1
	je _shl 										; 5 La ALU debe realizar un Shift Logical Left
	inc r8
	cmp r8, %1
	je _shr 										; 6 La ALU debe realizar un Shift Logical Right
	inc r8
	cmp r8, %1
	je _sub 										; 7 La ALU debe realizar una resta
	inc r8
	cmp r8, %1
	je _imul 										; 8 La ALU debe realizar una multiplicacion

	;Direcciones de operacion de instrucciones

	_add:
	impr_texto Op1,tamano_Op1 ; Indica al usuario que operacion se realiza

	mov eax,		     dword [rsp+%2]			; Se pasan los datos a los registros que van a operar
	mov ebx,			 dword [rsp+%3] 			; SE DEBE MODIFICAR PARA QUE RECIBA INMEDIATO

	add eax, 			 ebx 						; Se realiza la operacion
	mov dword [rsp+%4], eax						; 
	cmp r8,				 %1  						; terminada la operacion, se sale del programa
	jae _end

	_and:
	impr_texto Op2,tamano_Op2
	mov eax,			 dword [rsp+%2]			; getting data 
	mov ebx,			 dword [rsp+%3]

	and eax, 			 ebx
	cmp r8,              %1
	jae _end

	_or:
	impr_texto Op3,tamano_Op3
	mov eax, 			 dword [rsp+%2]
	mov ebx,             dword [rsp+%3]

	or eax,              ebx

	cmp r8,				 %1
	jae _end

	_nor:
	impr_texto Op4,tamano_Op4
	mov eax, 		     dword [rsp+%2]
	mov ebx,             dword [rsp+%3]

	or eax, 			 ebx
	not eax

	cmp r8,				 %1
	jae _end

	_shl:
	impr_texto Op5,tamano_Op5
	mov eax,			 dword [rsp+%2]
	mov ecx,			 dword [rsp+%3]

	shl eax,             cl
	cmp r8,				 %1
	jae _end

	_shr:
	impr_texto Op6,tamano_Op6
	mov eax,			 dword [rsp+%2]
	mov ecx,			 dword [rsp+%3]

	shr eax,			 cl
	cmp r8,				 %1
	jae _end

	_sub:
	impr_texto Op7,tamano_Op7
	mov eax,			 dword [rsp+%2]
	mov ebx,			 dword [rsp+%3]

	sub eax,			 ebx
	cmp r8,				 %1
	jae _end

	_imul:
	impr_texto Op8,tamano_Op8
	mov eax,			 dword [rsp+%2]
	mov ebx,			 dword [rsp+%3]

	imul ebx
	cmp r8,			     %1
	jae _end
%endmacro	



section .data
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

;Alu
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
	FD_OUT: 	resb 1
	FD_IN: 		resb 1
	TEXT: 		resb 32
	Num: 		resb 33 

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




;-----------------------------------------------------------------------
;------------------- $rs $rt $rd Deco pointers -------------------------
;-----------------------------------------------------------------------
_Reg:
	;mov r10, 0x28 ; 20090002
	;deco_RegBankPointersI r10   ; I-Type Instructions


	mov r10, 0x2c ; 01095020 INSTRUCCION QUE SE ESTA DECODIFICANDO 
	deco_RegBankPointers r10   ; R-Type Instructions
_1:
	; $r10 is the input ( Pointing to actual instruction address into iMeM)
	; $r13 is rs pointer in Registers Bank
	; $r14 is rt pointer in Registers Bank
	; $r15 is rd pointer in Registers Bank

	mov dword [rsp+r13], 3
	mov dword [rsp+r14], 2							; preloading because there is not I-Intruct yet

_AALu:
	ALUx r9, r12, r13, r14, r15 ; , r9 

;_ALUx:


	
;exit:                               
	_end:
 	mov rax,       		 SYS_EXIT
   	mov rdi,       		 STDIN
    xor rbx,       		 rbx
    syscall
