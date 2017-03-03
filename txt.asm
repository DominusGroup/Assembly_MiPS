
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



section .data
  iMEM_BYTES:   equ 8 ; x/4 = words num     ;   256  			    ; Memory allocation
  REG_BYTES:	equ 128   ; 64 dwords 
  TOT_MEM:		equ 136;384


  msg:          db " Memory Allocated! ", 10
  len:          equ $ - msg
  fmtint:       db "%ld", 10, 0

  FILE_NAME:    db "code.txt", 0
  FILE_LENGTH:  equ 32 ;320        		; length of inside text
  
  OFFSET_POINTER_REG:  equ 8 ;256    ; 1 dword = 4 bytes
  						  ; 128bytes = 32 dwords
  						  ; offset for Registers Allocation
  ;OFFSET_POINTER_rt:  equ 384 ; iMEM_BYTES+128  						 
  ;OFFSET_POINTER_rd:  equ 512 ; iMEM_BYTES+128+128

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
	sub rsp, 			TOT_MEM ;iMEM_BYTES	    ; number of memory bytes allocation		



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
	mov rsi, 	  		TEXT 			; The Buffer 
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


;---------- Copy upper dword from TEXT Buffer	
  	mov rax, 			qword [TEXT]
  	mov rdx, 			rax
  	mov ecx, 			32				; Shift 32 bits
  	shr rdx, 			cl              ; dh, cl
	xor rax, 			rax
	mov eax, 			edx

; The input text is hex in ASCII so you will need to 
; word format :  $eax : 0011abcd_0011efgh_0011ijkl_0011mnño...   
; you want it :  $rsp : abcd_efgh_ijkl_mnño...
       ; 20080003 >> es el 3
  	mov r8d, 			eax 			; $aux1
  	and r8d, 			0x0F000000		; save abcd
  	mov r9d,            r8d
  	
	mov edx, 			dword r9d		; $edx is special for shift
  	mov ecx, 			24 				; $ecx is special to pass shift num 										
  	shr edx, 			cl              ; shifting abcd bits to 1st position
	or dword [rsp], edx		            ; sum aux_dword to $rsp (instructions memory)
										; $rsp : abcd0000_00000000_.... 
		; ---------------------------- 
		; 200800b3 >> es el b
	mov r8d, 			eax  			; $aux2
	and r8d, 			0x000F0000		; save efgh
	mov r10d, 			r8d

  	mov edx, 			dword r10d		
  	mov ecx, 			12 				; Shift 8 bits (to left)
  	shr edx, 			cl              ; Shifting efgh to 2nd position 
	or dword [rsp],     edx				; $rsp : abcdefgh_00000000_....

		; ----------------------------  
	mov r8d, 			eax				; $aux3
	and r8d, 			0x00000F00
	mov r12d, 			r8d				

  	mov edx, 			dword r12d
  	mov ecx, 			0  				
  	shr edx, 			cl              
	or dword [rsp],     edx			    ; $rsp : abcdefgh_ijkl0000_....

		; ----------------------------
		; 2008d003 >> es el d
	mov r8d, 			eax             ; $aux4
	and r8d, 			0x0000000F
	mov r12d, 			r8d				

  	mov edx, 			dword r12d
  	mov ecx, 			12 				; Shift left 16 bits
  	shl edx, 			cl              
	or dword [rsp],     edx



;---------- Copy lower dword from TEXT Buffer
	mov eax, 			dword [TEXT]	; Truncate Buffer

		; 20080003 >> es el 2
	mov r8d, 			eax             ; $aux5
	and r8d,   			0x0000000F
	mov r9d, 			r8d

	mov edx, 			dword r9d
	mov ecx, 			28				; Shift = 0	
	shl edx, 			cl              ; Shift right 0 bits
	or dword [rsp],     edx				; Filling to 32 bits instruction, last 4 bits

		; ----------------------------
		; 2g0800b3 >> es el g
	mov r8d, 			eax             ; $aux6
	and r8d, 			0x00000F00	      
	mov r9d, 			r8d

  	mov edx, 			dword r9d
  	mov ecx, 			16				; Shift 4 bits
  	shl edx, 			cl              
	or dword [rsp],     edx

		; ----------------------------
		; 20f80003 >> es el f
	mov r8d, 			eax  			; $aux7
	and r8d, 			0x000F0000
	mov r10d, 			r8d

  	mov edx, 			dword r10d
  	mov ecx, 			4				; Shift 4 bits
  	shl edx, 			cl              ; dh, cl
	or dword [rsp],     edx

		; ----------------------------
		; 20080003 >> es el 8
	mov r8d, 			eax             ; $aux8
	and r8d, 			0x0F000000
	mov r12d, 			r8d				; Holds last important data

  	mov edx, 			dword r12d
  	mov ecx, 		    8				; Shift 4 bits
  	shr edx, 			cl              ; dh, cl
	or dword [rsp],     edx
;------------------------------- At this point -----------------------------------
;------------- Virtual memory $rsp contains decoded instructions -----------------
	xor r10, r10


;------------------- $rs $rt $rd Deco pointers -------------------------
;-----------------------------------------------------------------------
	_Reg:
; Enmascarar y hacer shift para $rs 	
	mov r8d, dword [rsp]		; passing instruction from memory; 
	and r8d, 0000_0011_1110_0000_0000_0000_0000_0000b ; masking address $rs 
	mov rcx, 21					; shifting 20 bits
	mov edx, dword r8d
	shr edx,	cl 	
	imul rdx, 4 
	sub rdx, 4	

	mov rax, rdx 
	mov r13, rax                     ; $r13 is the rs pointer
	add r13, OFFSET_POINTER_REG	     ; adding memory offset to $r13 to start in Reg allocation 
_1:

; Enmascarar y hacer shift para $rt 	
	mov r8d, dword [rsp]		; passing instruction from memory
	and r8d, 0000_0000_0001_1111_0000_0000_0000_0000b ; masking address $rt
	mov rcx, 16					; shifting 16 bits
	mov edx, dword r8d
	shr edx,	cl 
	imul rdx, 4  ; escalar por 4
	sub rdx, 4

	mov rax, rdx
	mov r14, rax			; $r14 is the rt pointer
	add r14, OFFSET_POINTER_REG    ; starting above memory 
 _2:

; Enmascarar y hacer shift para $rd 	
	mov r8d, dword [rsp]		; passing instruction from memory
	and r8d, 0000_0000_0000_0000_1111_1000_0000_0000b ; masking address $rd
	mov rcx, 11					; shifting 11 bits
	mov edx, dword r8d
	shr edx,	cl 
	imul rdx, 4
	sub rdx, 4

	mov rax, rdx
	mov r15, rax			; $r14 is the rt pointer
	add r15, OFFSET_POINTER_REG    ; starting above memory 
 
_3:

;--------------------------- Control --------------------------------------------
;------------------------------------------------------------------------------
	; ------------------- OPCODE
	mov r8d, dword [rsp]
	and r8d, 1111_1100_0000_0000_0000_0000_0000_0000b ; masking opcode
	mov rcx, 26 ; shifting 0 bits 
	mov edx, dword r8d 
	shr edx, cl 

	mov rax, rdx		 ; Rax is the OPCODE
	; ver a que registro se lo paso 
_4:
	; ------------------- FUNCT
	mov r8d, dword [rsp]
	and r8d, 0000_0000_0000_0000_0000_0000_0011_1111b ; masking opcode
	mov rcx, 0 ; shifting 26 bits 
	mov edx, dword r8d 
	shr edx, cl 

	mov rax, rdx		 ; Rax is the FUNCT
_5:

;--------------------------- ALU ----------------------------------------------
;------------------------------------------------------------------------------
	mov r9, rax    ; FUNCT :registro que indica la operacion a realizar
	mov r8, 0      ; registro indice de operacion

	;mov r13, 5 ; r12 , r13 
	;mov r14, 6
	mov eax, 5
	mov dword [rsp+r13], eax ; precargndo a 5

	mov eax, 6
	mov dword [rsp+r14], eax ; precargndo a 6	
_6:	
	;mov r12,5; r12 --- registro que almacena el primer parametro
	;mov r13,6; r13 ---  registro que almacena el segundo parametro
	;Se compara el registro r9 con el r8 para saber que operacion se desea realizar

	cmp r8,r9
	je _end ; 0  La ALU no debe realizar ninguna operacion
	inc r8
	cmp r8,r9
	je _add ; 1 La ALU debe realizar una suma
	inc r8
	cmp r8,r9
	je _and ; 2 La ALU debe realizar un and
	inc r8
	cmp r8,r9
	je _or ; 3 La ALU debe realizar un or
	inc r8
	cmp r8,r9
	je _nor ; 4 La ALU debe realizar un nor
	inc r8
	cmp r8,r9
	je _shl ; 5 La ALU debe realizar un Shift Logical Left
	inc r8
	cmp r8,r9
	je _shr ; 6 La ALU debe realizar un Shift Logical Right
	inc r8
	cmp r8,r9
	je _sub ; 7 La ALU debe realizar una resta
	inc r8
	cmp r8,r9
	je _imul ; 8 La ALU debe realizar una multiplicacion

	;Direcciones de operacion de instrucciones

	_add:
	impr_texto Op1,tamano_Op1 ; Indica al usuario que operacion se realiza

	mov eax,dword [rsp+r13] ;r12 ;Se pasan los datos a los registros que van a operar
	mov ebx,dword [rsp+r14] ;r13

	add eax, ebx ; Se realiza la operacion

	mov dword [rsp+r15], eax
	cmp r8,r9 ; terminada la operacion, se sale del programa
	jae _end

	_and:
	impr_texto Op2,tamano_Op2
	mov eax,dword [rsp+r13];r12
	mov ebx,dword [rsp+r14];r13

	and eax, ebx

	cmp r8,r9
	jae _end

	_or:
	impr_texto Op3,tamano_Op3
	mov eax, dword [rsp+r13];r12
	mov ebx, dword [rsp+r14];r13

	or eax, ebx

	cmp r8,r9
	jae _end

	_nor:
	impr_texto Op4,tamano_Op4
	mov eax,dword [rsp+r13];r12
	mov ebx,dword [rsp+r14];r13

	or eax, ebx
	not eax

	cmp r8,r9
	jae _end

	_shl:
	impr_texto Op5,tamano_Op5
	mov eax,dword [rsp+r13];r12
	mov ecx,dword [rsp+r14];r13

	shl eax,cl

	cmp r8,r9
	jae _end

	_shr:
	impr_texto Op6,tamano_Op6
	mov eax,dword [rsp+r13];r12
	mov ecx,dword [rsp+r14];r13

	shr rax,cl

	cmp r8,r9
	jae _end

	_sub:
	impr_texto Op7,tamano_Op7
	mov eax,dword [rsp+r13];r12
	mov ebx,dword [rsp+r14];r13

	sub rax,rbx

	cmp r8,r9
	jae _end

	_imul:
	impr_texto Op8,tamano_Op8
	mov eax,dword [rsp+r13];r12
	mov ebx,dword [rsp+r14];r13

	imul rbx

	cmp r8,r9
	jae _end

	
;exit:                               
	_end:
 	mov rax,       SYS_EXIT
   	mov rdi,       STDIN
    xor rbx,       rbx
    syscall
