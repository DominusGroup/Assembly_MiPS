
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
  iMEM_BYTES:   equ 32 ;64 			    ; Memory allocation
  msg:          db " Memory Allocated! ", 10
  len:          equ $ - msg
  fmtint:       db "%ld", 10, 0

  FILE_NAME:    db "code.txt", 0
  FILE_LENGTH:  equ 32 ;320        		; length of inside text
  
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
	sub rsp, 			iMEM_BYTES	    ; number of memory bytes allocation		

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

  	mov r8d, 			eax 			; $aux1
  	and r8d, 			0x0F000000		; save abcd
  	mov r9d,            r8d
  	
	mov edx, 			dword r9d		; $edx is special for shift
  	mov ecx, 			4 				; $ecx is special to pass shift num 										
  	shl edx, 			cl              ; shifting abcd bits to 1st position
	or dword [rsp],     edx				; sum aux_dword to $rsp (memory)
										; $rsp : abcd0000_00000000_.... 
		; ---------------------------- 
	mov r8d, 			eax  			; $aux2
	and r8d, 			0x000F0000		; save efgh
	mov r10d, 			r8d

  	mov edx, 			dword r10d		
  	mov ecx, 			8				; Shift 8 bits (to left)
  	shl edx, 			cl              ; Shifting efgh to 2nd position 
	or dword [rsp],     edx				; $rsp : abcdefgh_00000000_....

		; ----------------------------  
	mov r8d, 			eax				; $aux3
	and r8d, 			0x00000F00
	mov r12d, 			r8d				

  	mov edx, 			dword r12d
  	mov ecx, 			12				
  	shl edx, 			cl              
	or dword [rsp],     edx			    ; $rsp : abcdefgh_ijkl0000_....

		; ----------------------------
	mov r8d, 			eax             ; $aux4
	and r8d, 			0x0000000F
	mov r12d, 			r8d				

  	mov edx, 			dword r12d
  	mov ecx, 			16				; Shift left 16 bits
  	shl edx, 			cl              
	or dword [rsp],     edx


;---------- Copy lower dword from TEXT Buffer
	mov eax, 			dword [TEXT]	; Truncate Buffer

	mov r8d, 			eax             ; $aux5
	and r8d,   			0x0000000F
	mov r9d, 			r8d

	mov edx, 			dword r9d
	mov ecx, 			0				; Shift = 0	
	shr edx, 			cl              ; Shift right 0 bits
	or dword [rsp],     edx				; Filling to 32 bits instruction, last 4 bits

		; ----------------------------
	mov r8d, 			eax             ; $aux6
	and r8d, 			0x00000F00	      
	mov r9d, 			r8d

  	mov edx, 			dword r9d
  	mov ecx, 			4				; Shift 4 bits
  	shr edx, 			cl              
	or dword [rsp],     edx

		; ----------------------------
	mov r8d, 			eax  			; $aux7
	and r8d, 			0x000F0000
	mov r10d, 			r8d

  	mov edx, 			dword r10d
  	mov ecx, 			8				; Shift 4 bits
  	shr edx, 			cl              ; dh, cl
	or dword [rsp],     edx

		; ----------------------------
	mov r8d, 			eax             ; $aux8
	and r8d, 			0x0F000000
	mov r12d, 			r8d				; Holds last important data

  	mov edx, 			dword r12d
  	mov ecx, 			12				; Shift 4 bits
  	shr edx, 			cl              ; dh, cl
	or dword [rsp],     edx
;------------------------------- At this point -----------------------------------
;------------- Virtual memory $rsp contains decoded instructions -----------------

exit:                               
   mov rax,       SYS_EXIT
   mov rdi,       STDIN
   xor rbx,       rbx
   syscall
