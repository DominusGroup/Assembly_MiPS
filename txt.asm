
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
  iMEM_BYTES:   equ 32     ; Memory allocation
  msg:          db " Memory Allocated! ", 10
  len:          equ $ - msg
  fmtint:       db "%ld", 10, 0

  FILE_NAME:    db "code.txt", 0
  FILE_LENGTH:  equ 32 ;320        ; length of inside text
  
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
   global _start        ;must be declared for using gcc
   global _1
   global _2
   global _3
   global _4
   global _5
   global _6
   global _7

_start:                     	; tell linker entry point

	xor rcx, rcx 
	sub rsp, iMEM_BYTES	    	; number of memory bytes allocation		

_txt:
;------- open file for reading
	mov rax, 	  SYS_OPEN		            
	mov rdi, 	  FILE_NAME
	mov rsi, 	  STDIN      	; for read only access
	syscall  
	mov [FD_IN],  rax

;------- read from file
	mov rax, 	  SYS_READ    	; sys_read
	mov rdi, 	  [FD_IN]
	mov rsi, 	  TEXT 			; The Buffer 
	mov rdx, 	  FILE_LENGTH   ; Data length 
	syscall
	_1:

;------- close the file 
	mov rax,      SYS_CLOSE 
	mov rdi,      [FD_IN]
	
;------- print info  
	mov rax,      SYS_WRITE 
	mov rdi,      STDOUT
	mov rsi,      TEXT			; The Buffer TEXT
	mov rdx,      FILE_LENGTH   ; Data length 
	syscall	
;----------------- Hasta este punto -----------------------
;------------- $rsi con el dato del txt ------------------


exit:                               
   mov rax,       SYS_EXIT
   mov rdi,       STDIN
   xor rbx,       rbx
   syscall
