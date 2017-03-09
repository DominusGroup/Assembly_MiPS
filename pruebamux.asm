
SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1

;---------MACRO MUX-----------
	%macro muliplex 4 
						; %1 es la direccion de memoria selector, %2 Es la direccion de entrada 1
						; %3 es la dirección de enrada 2, %4 es la direccion de memoria de salida
	mov eax, [%1]
	cmp eax, 0
	je _selec0;
	jne _selec1

	_selec0:
		mov eax, [%2]
		mov [%4], eax
		jmp _salemux

	_selec1:
		mov eax, [%3]
		mov [%4], eax
		jmp _salemux

	_salemux:
	%endmacro

segment .data

segment .bss
	selec:		resb 1 
	regi1: 		resb 16
	reg1: 		resb 16
	reg2: 		resb 16
	salmux: 	resb 16
section .text

	global _start

	_start:
	;int 0x80
	mov eax, 6
	mov [reg1], eax
	mov eax, 5
	mov [reg2], eax
	mov eax, 0;Seleciona la patilla del muxt
	mov  [selec], eax

	muliplex selec,reg1,reg2,salmux

	; imprime en pantalla
	mov eax, [salmux]
	add eax, '0'
	mov [salmux], eax
	;............

	mov eax, [reg1]
	add eax, '0'
	mov [reg1], eax
	;
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, salmux;
	mov edx, 16

	int 0x80;llamada al ssistema de interrupciones
salida:
	mov eax, SYS_EXIT 
	;xor ebx, ebx  ;EBX=0 INDICA EL CODIGO DE RETORNO (0=SIN ERRORES)
	int 0x80
	;mov eax, 1; system pause, sysexit
	;mov rax, 60
	;mov rdi, 0
	syscall




