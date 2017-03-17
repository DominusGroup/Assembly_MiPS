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
Op9: db 'Se realiza un beq',0xa
tamano_Op9: equ $-Op9
Op10: db 'Se realiza un bne',0xa
tamano_Op10: equ $-Op10
Op11: db 'Se realiza un addu',0xa
tamano_Op11: equ $-Op11
Op12: db 'Se realiza un sltiu',0xa
tamano_Op12: equ $-Op12
Op13: db 'Se realiza un sltu',0xa
tamano_Op13: equ $-Op13
Op14: db 'Se realiza un subu',0xa
tamano_Op14: equ $-Op14
Op15: db 'Se realiza un slt',0xa
tamano_Op15: equ $-Op15
Op16: db 'Se realiza un slti',0xa
tamano_Op16: equ $-Op16
Op17: db 'Se realiza un andi',0xa
tamano_Op17: equ $-Op17
Op18: db 'Se realiza un ori',0xa
tamano_Op18: equ $-Op18
l3: db 'Fin del Programa!',0xa
tamano_l3: equ $-l3

num1: equ 0xc

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
	limpiar_pantalla limpiar,limpiar_tam ; Limpia la pantalla antes de iniciar
	impr_texto l1,tamano_l1 ; Mensaje de inicio de programa

	mov r9,num1 ; registro que indica la operacion a realizar
	mov r8,0 ; registro indice de operacion

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
	inc r8
	cmp r8,r9
	je _beq ; 9 La ALU debe realizar un beq
	inc r8
	cmp r8,r9
	je _bne ; 10 La ALU debe realizar un bne
	inc r8
	cmp r8,r9
	je _addu ; 11 La ALU debe realizar un addu
	inc r8
	cmp r8,r9
	je _sltiu ; 12 La ALU debe realizar un sltu
	inc r8
	cmp r8,r9
	je _sltu ; 13 La ALU debe realizar un sltiu
	inc r8
	cmp r8,r9
	je _subu ; 14 La ALU debe realizar un subu
	inc r8
	cmp r8,r9
	je _slt ; 15 La ALU debe realizar un slt
	inc r8
	cmp r8,r9
	je _slti ; 16 La ALU debe realizar un slti
	inc r8
	cmp r8,r9
	je _andi ; 17 La ALU debe realizar un andi
	inc r8
	cmp r8,r9
	je _ori ; 18 La ALU debe realizar un ori


	;Direcciones de operacion de instrucciones

	_add:   ;-------------listo con registros MIPS para utilizar------------------------------

	impr_texto Op1,tamano_Op1 ; Indica al usuario que operacion se realiza

	mov rax,[rsp+r14] ; $rs Se pasan los datos a los registros que van a operar
	mov rbx,[rsp+r13] ; $rt

	add rax,rbx ; Se realiza la operacion
	mov [rsp+r12],rax; $rd se guarda la operacion en el registro deseado
	_AddR:
	cmp r8,r9 ; terminada la operacion, se sale del programa
	jae _end
;-------------------------------------------------------------------------

;----------------Listo con Registros MIPS para utilizar--------------------
	_addu:
	impr_texto Op11,tamano_Op11 ; Indica al usuario que operacion se realiza

	mov rax,[rsp+r13] ;

	_compare11:
	cmp rax,0 ; compara r12 con 0 para saber si es mayor a el
	jg _CR211 ;si es mayor a cero realiza un salto, ya que no se debe modificar el registro
	mov rbx,-1 ; se carga el registro con -1 para multiplicar
	imul  rbx; se multiplica por -1 para que el resultado sea positivo
	mov rbx,rax ; guarda el valor modificado en el registro deseado
	_CR211: ; brinco a evaluar el contenido del segundo registro
	mov rax , r12 ; [rsp+ r14]
	cmp rax,0 ; procedimiento igual al aplicado al registro anterior
	jg _CRL11 ; brinco a ejecucion ALU
	mov rbp,-1
	imul rbp
	_CRL11: ; Ejecucion ALU realiza la operacion deseada

	add rax,rbx ; Se realiza la operacion
	mov [rsp+r12],rax; $rd se guarda la operacion en el registro deseado

	_AdduR:
	cmp r8,r9 ; terminada la operacion, se sale del programa
	jae _end
;------------------------------------------------------------------------------

;-----------------Listo para usar con registros MIPS ---------------------------
	_and:
	impr_texto Op2,tamano_Op2
	mov rax,[rsp+r14]
	mov rbx,[rsp+r13]

	and rax,rbx
	mov [rsp+r12], rax
	_AndR:
	cmp r8,r9
	jae _end

	;-----------------Listo para usar con registros MIPS ---------------------------
		_andi:
		impr_texto Op17,tamano_Op17

		mov rax,[rsp+r14]
		mov rbx,[rsp+r9]

		and rax,rbx
		mov [rsp+r13], rax
		_AndiR:
		cmp r8,r9
		jae _end

;----------------Listo Con Registros MIPS a Utilizar -----------------------
	_or:
	impr_texto Op3,tamano_Op3
	mov rax, [rsp+r14]
	mov rbx, [rsp+r13]

	or rax,rbx
	mov [rsp+r12], rax
	_OrR:
	cmp r8,r9
	jae _end
;--------------------------------------------------------------------------

;----------------Listo Con Registros MIPS a Utilizar -----------------------
	_ori:
	impr_texto Op18,tamano_Op18
	mov rax, [rsp+r14]
	mov rbx, [rsp+r9]

	or rax,rbx
	mov [rsp+r13], rax
	_OriR:
	cmp r8,r9
	jae _end
;--------------------------------------------------------------------------

;------------listo Con Registros MIPS a Utilizar---------------------------
	_nor:
	impr_texto Op4,tamano_Op4
	mov rax, [rsp+r14]
	mov rbx, [rsp+r13]

	or rax,rbx
	not rax
	mov [rsp+r12], rax
	_NorR:
	cmp r8,r9
	jae _end
;--------------------------------------------------------------------------

;------------listo---------------------------------------
	_shl:
	impr_texto Op5,tamano_Op5
	mov rax,[rsp+r13]
	mov rcx,[rsp+rdx]

	shl rax,cl
	mov [rsp+r12], rax
	_ShlR:
	cmp r8,r9
	jae _end
;--------------------------------------------------------------------------

;------------Listo------------------------------------
	_shr:
	impr_texto Op6,tamano_Op6
	mov rax, [rsp+13]
	mov rcx, [rsp+rdx]	;

	shr rax,cl
	mov [rsp+r12], rax
	_ShrR:
	cmp r8,r9
	jae _end
;--------------------------------------------------------------------------

;--------------Registros MIPS Listos a Operar------------------------------
	_sub:
	impr_texto Op7,tamano_Op7
	mov rax,[rsp+r14]
	mov rbx,[rsp+r13]

	sub rax,rbx
	mov [rsp+r12], rax
	_SubR:
	cmp r8,r9
	jae _end
;---------------------------------------------------------------------------
;-----------------Con Registros MIPS Listos a Operar------------------------
	_subu:
	impr_texto Op14,tamano_Op14

	mov rax,[rsp+r13] ;

	_compare14:
	cmp rax,0 ; compara r12 con 0 para saber si es mayor a el
	jg _CR214 ;si es mayor a cero realiza un salto, ya que no se debe modificar el registro
	mov rbx,-1 ; se carga el registro con -1 para multiplicar
	imul  rbx; se multiplica por -1 para que el resultado sea positivo
	mov rbx,rax ; guarda el valor modificado en el registro deseado
	_CR214: ; brinco a evaluar el contenido del segundo registro
	mov rax , [rsp+ r14]
	cmp rax,0 ; procedimiento igual al aplicado al registro anterior
	jg _CRL14 ; brinco a ejecucion ALU
	mov rbp,-1
	imul rbp
	_CRL14: ; Ejecucion ALU realiza la operacion deseada

	sub rax,rbx
	mov [rsp+r12], rax
	_SubuR:
	cmp r8,r9
	jae _end

	_imul: ;el resultado se guarda en rax, y si sobre pasa el tamano de este registro
				 ; la bandera CF y OF se ponen en uno y los demas bits se guardan en RDX
	impr_texto Op8,tamano_Op8
	mov rax,[rsp+r14]
	mov rbx,[rsp+r13]
	imul rbx
	mov [rsp+r12], rax
	_ImulR:
	cmp r8,r9
	jae _end

	_beq:
	impr_texto Op9,tamano_Op9
	mov rax, [rsp+r14]
	mov rbx, [rsp+r9]
	sub rax,rbx
	cmp rax,0
	je _BeqC
	mov rax,0
	jmp _BeqR
	_BeqC:
	mov rax,1
	_BeqR:
	mov [rsp+r13], rax
	cmp r8,r9
	jae _end

	_bne:
	impr_texto Op10,tamano_Op10
	mov rax, [rsp+r14]
	mov rbx, [rsp+r9]
	sub rax,rbx
	cmp rax,0
	je _BneC
	mov rax,1
	jmp _BneR
	_BneC:
	mov rax,0
	_BneR:
	mov [rsp+r13], rax
	cmp r8,r9
	jae _end
;------------------Listo ----------------------------------------
	_slt:
	impr_texto Op15,tamano_Op15
	mov rax, [rsp+r14]
	mov rbx, [rsp+r13]
	cmp rax,rbx
	jl _Runo15
	mov rax,0
	cmp rax,0
	je _SltR
	_Runo15:
	mov rax,1
	_SltR:
	mov [rsp+r12], rax
	cmp r8,r9
	jae _end
;--------------------------REVISAR ESTA OPERACION------------------------------
	_sltu:
	impr_texto Op13,tamano_Op13
;------------------unsigned operation---------------
	mov rax,[rsp+r13] ;
	_compare13:
	cmp rax,0 ; compara r12 con 0 para saber si es mayor a el
	jg _CR213 ;si es mayor a cero realiza un salto, ya que no se debe modificar el registro
	mov rbx,-1 ; se carga el registro con -1 para multiplicar
	imul  rbx; se multiplica por -1 para que el resultado sea positivo
	mov rbx,rax ; guarda el valor modificado en el registro deseado
	_CR213: ; brinco a evaluar el contenido del segundo registro
	mov rax , [rsp+ r14]
	cmp rax,0 ; procedimiento igual al aplicado al registro anterior
	jg _CRL13 ; brinco a ejecucion ALU
	mov rbp,-1
	imul rbp
	_CRL13: ; Ejecucion ALU realiza la operacion deseada
;------------------instruction operation----------------------
	cmp rax,rbx
	jl _Runo13
	mov rax,0
	cmp rax,0
	je _SltuR13
	_Runo13:
	mov rax,1
	_SltuR13:
	mov [rsp+r12], rax
	cmp r8,r9
	jae _end

;----------------Listo---------------------------------
	_sltiu:
	impr_texto Op12,tamano_Op12

	;------------------unsigned operation---------------
		mov rax,[rsp+r13] ;
		_compare12:
		cmp rax,0 ; compara r12 con 0 para saber si es mayor a el
		jg _CR212 ;si es mayor a cero realiza un salto, ya que no se debe modificar el registro
		mov rbx,-1 ; se carga el registro con -1 para multiplicar
		imul  rbx; se multiplica por -1 para que el resultado sea positivo
		mov rbx,rax ; guarda el valor modificado en el registro deseado
		_CR212: ; brinco a evaluar el contenido del segundo registro
		mov rax , [rsp+ r9]
		cmp rax,0 ; procedimiento igual al aplicado al registro anterior
		jg _CRL12 ; brinco a ejecucion ALU
		mov rbp,-1
		imul rbp
		_CRL12: ; Ejecucion ALU realiza la operacion deseada
	;------------------instruction operation----------------------

	cmp rax,rbx
	jl _Runo12
	mov rax,0
	cmp rax,0
	je _SltiuR
	_Runo12:
	mov rax,1
	_SltiuR:
	mov [rsp+r13], rax
	cmp r8,r9
	jae _end

	;----------------Listo---------------------------------
		_slti:
		impr_texto Op16,tamano_Op16

		;------------------unsigned operation---------------
		mov rax,[rsp+r14] ;
		mov rbx, [rsp+r3]

		cmp rax,rbx
		jl _Runo16
		mov rax,0
		cmp rax,0
		je _SltiR
		_Runo16:
		mov rax,1
		_SltiR:
		mov [rsp+r13], rax
		cmp r8,r9
		jae _end

	_end:
	impr_texto l3,tamano_l3
	mov rax,60						;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0							;en rdi se carga un 0
	syscall								;se llama al sistema.
