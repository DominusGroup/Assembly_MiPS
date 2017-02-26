;#######################################################################
;Modulo ALU - Emula el comportamiento de una ALU en una arquitectura MIPS
;EL4313 - Laboratorio de Estructura de Microprocesadores
;Estudiante: Carlos Gomez 2013003421 I SEM 2017
;#######################################################################
;-------------------------  MACRO #1  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO # 1 --------------------------------
;-------------------------  MACRO #2  ----------------------------------
;Macro-2: leer_texto.
;	Lee un mensaje desde teclado y se almacena en la variable que se
;	pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion de memoria donde se guarda el texto
;		%2 es la cantidad de bytes a guardar
;-----------------------------------------------------------------------
%macro leer_texto 2 	;recibe 2 parametros
	mov rax,0	;sys_read
	mov rdi,0	;std_input
	mov rsi,%1	;primer parametro: Variable
	mov rdx,%2	;segundo parametro: Tamano
	syscall
%endmacro
;------------------------- FIN DE MACRO # 2 --------------------------------
;-------------------------  MACRO #3  ----------------------------------
;Macro-3: limpiar_pantalla.
;	Limpa la pantalla de texto
;	Recibe 2 parametros:
;		%1 es la direccion de memoria donde se guarda el texto
;		%2 es la cantidad de bytes a guardar
;-----------------------------------------------------------------------
%macro limpiar_pantalla 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: caracteres especiales para limpiar la pantalla
	mov rdx,%2	;segundo parametro: Tamano
	syscall
%endmacro
;------------------------- FIN DE MACRO # 3 --------------------------------
;-------------------------  MACRO #4  ----------------------------------
;Macro-4: leer stdin_termios.
;	Captura la configuracion del stdin
;	recibe 2 parametros:
;		%1 es el valor de stdin
;		%2 es el valor de termios
;-----------------------------------------------------------------------
%macro read_stdin_termios 2
        push rax
        push rbx
        push rcx
        push rdx
        mov eax, 36h
        mov ebx, %1
        mov ecx, 5401h
        mov edx, %2
        int 80h
        pop rdx
        pop rcx
        pop rbx
        pop rax
%endmacro
;------------------------- FIN DE MACRO # 4--------------------------------
;-------------------------  MACRO #5  ----------------------------------
;Macro-5: escribir stdin_termios.
;	Captura la configuracion del stdin
;	recibe 2 parametros:
;		%1 es el valor de stdin
;		%2 es el valor de termios
;-----------------------------------------------------------------------
%macro write_stdin_termios 2
        push rax
        push rbx
        push rcx
        push rdx
        mov eax, 36h
        mov ebx, %1
        mov ecx, 5402h
        mov edx, %2
        int 80h
        pop rdx
        pop rcx
        pop rbx
        pop rax
%endmacro
;------------------------- FIN DE MACRO # 5--------------------------------
;-------------------------  MACRO #6  ----------------------------------
;Macro-6: apagar el modo canonico.
;	Apaga el modo canonico del Kernel
;	recibe 2 parametros:
;		%1 es el valor de ICANON
;		%2 es el valor de termios
;-----------------------------------------------------------------------
%macro canonical_off 2
	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        read_stdin_termios stdin,termios
	;Se escribe el nuevo valor de ICANON en EAX, para apagar el modo canonico
        push rax
        mov eax, %1
        not eax
        and [%2 + 12], eax
        pop rax
	;Se escribe la nueva configuracion de TERMIOS
        write_stdin_termios stdin,termios
%endmacro
;------------------------- FIN DE MACRO # 6--------------------------------
;-------------------------  MACRO #7  ----------------------------------
;Macro-6: encender el modo canonico.
;	Recupera el modo canonico del Kernel
;	recibe 2 parametros:
;		%1 es el valor de ICANON
;		%2 es el valor de termios
;-----------------------------------------------------------------------
%macro canonical_on 2
	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
	read_stdin_termios stdin,termios
        ;Se escribe el nuevo valor de modo Canonico
        or dword [%2 + 12], %1
	;Se escribe la nueva configuracion de TERMIOS
        write_stdin_termios stdin,termios
%endmacro
;-----------------------FIN  MACRO # 7-----------------------------


;---------------------- Segmento de Datos ---------------------------
section .data
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

;Definicion de los caracteres especiales para limpiar la pantalla
limpiar    db 0x1b, "[2J", 0x1b, "[H"
limpiar_tam equ $ - limpiar

;Definicion de constantes para manejar el modo canonico y el echo
termios:	times 36 db 0	;Estructura de 36bytes que contiene el modo de operacion de la consola
stdin:		equ 0		;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
ICANON:		equ 1<<1	;ICANON: Valor de control para encender/apagar el modo canonico
ECHO:           equ 1<<3	;ECHO: Valor de control para encender/apagar el modo de eco

;segmento de datos no-inicializados, que se pueden usar para capturar variables
;del usuario, por ejemplo: desde el teclado
section .bss
tecla_capturada: resb 1
;#######################################################################
;----------------------Segmento de codigo------------------------------
section .text

global _start
global _end

_start:
	limpiar_pantalla limpiar,limpiar_tam
	impr_texto l1,tamano_l1

	mov r9,num1 ; registro que indica la operacion a realizar
	mov r8,0 ; registro indice de operacion

	mov r12,5; r12 --- registro que almacena el primer parametro
	mov r13,6; r13 ---  registro que almacena el segundo parametro
	;Se compara el registro r9 con el r8 para saber que operacion se desea realizar

	cmp r8,r9
	je .end ; 0  La ALU no debe realizar ninguna operacion
	inc r8
	cmp r8,r9
	je .add ; 1 La ALU debe realizar una suma
	inc r8
	cmp r8,r9
	je .and ; 2 La ALU debe realizar un and
	inc r8
	cmp r8,r9
	je .or ; 3 La ALU debe realizar un or
	inc r8
	cmp r8,r9
	je .nor ; 4 La ALU debe realizar un nor
	inc r8
	cmp r8,r9
	je .shl ; 5 La ALU debe realizar un Shift Logical Left
	inc r8
	cmp r8,r9
	je .shr ; 6 La ALU debe realizar un Shift Logical Right
	inc r8
	cmp r8,r9
	je .sub ; 7 La ALU debe realizar una resta
	inc r8
	cmp r8,r9
	je .imul ; 8 La ALU debe realizar una multiplicacion

	;Direcciones de operacion de instrucciones

	.add:
	impr_texto Op1,tamano_Op1

	mov rax,r12
	mov rbx,r13

	add rax,rbx

	cmp r8,r9
	jae .end

	.and:
	impr_texto Op2,tamano_Op2
	mov rax,r12
	mov rbx,r13

	and rax,rbx

	cmp r8,r9
	jae .end

	.or:
	impr_texto Op3,tamano_Op3
	mov rax,r12
	mov rbx,r13

	or rax,rbx

	cmp r8,r9
	jae .end

	.nor:
	impr_texto Op4,tamano_Op4
	mov rax,r12
	mov rbx,r13

	or rax,rbx
	not rax

	cmp r8,r9
	jae .end

	.shl:
	impr_texto Op5,tamano_Op5
	mov rax,r12
	mov rcx,r13

	shl rax,cl

	cmp r8,r9
	jae .end

	.shr:
	impr_texto Op6,tamano_Op6
	mov rax,r12
	mov rcx,r13

	shr rax,cl

	cmp r8,r9
	jae .end

	.sub:
	impr_texto Op7,tamano_Op7
	mov rax,r12
	mov rbx,r13

	sub rax,rbx

	cmp r8,r9
	jae .end

	.imul:
	impr_texto Op8,tamano_Op8
	mov rax,r12
	mov rbx,r13

	imul rbx

	cmp r8,r9
	jae .end

	.end:
	impr_texto l3,tamano_l3
	mov rax,60						;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0							;en rdi se carga un 0
	syscall								;se llama al sistema.
