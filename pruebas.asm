

SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1
%macro imp 1;
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, %1
	mov edx, 16
	int 0x80
%endmacro
segment .data


archivo db "/home/nala/Escritorio/Resultados.txt",0; nombre de archivo a escribir



segment .bss

;texto resb 4 ; auxiliar de texto a escribir 
idarchivo resd 1; identificador de archivo
;id resb 2
regimp resb 8
regout resb 8


segment .text

global _start


	

primero:
	mov rbx,[regimp]
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn1;  salta si es numero
	ja ess1; salta si es string

esn1:
	add rbx, 0x30 
	jmp segundo
 ess1:
	add rbx, 0x37 
	

;_______________________________________________________________________
segundo:
	shl rbx, 56
	mov [regout], rbx
	mov rbx,[regimp]
	shr rbx, 4
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn2;  salta si es numero
	ja ess2; salta si es string

esn2:
	add rbx, 0x30 
	jmp tercero
 ess2:
	add rbx, 0x37
	
;________________________________________
tercero:
	shl rbx, 48
	or [regout], rbx
	mov rbx,[regimp]
	shr rbx, 8
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn3;  salta si es numero
	ja ess3; salta si es string

esn3:
	add rbx, 0x30 
	jmp cuarto
 ess3:
	add rbx, 0x37

cuarto:
	shl rbx, 40
	or [regout], rbx
	mov rbx,[regimp]
	shr rbx, 12
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn4;  salta si es numero
	ja ess4; salta si es string

esn4:
	add rbx, 0x30 
	jmp quinto
 ess4:
	add rbx, 0x37

quinto:
	shl rbx, 32
	or [regout], rbx
	mov rbx,[regimp]
	shr rbx, 16
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn5;  salta si es numero
	ja ess5; salta si es string

esn5:
	add rbx, 0x30 
	jmp sexto
 ess5:
	add rbx, 0x37
sexto:
	shl rbx, 24
	or [regout], rbx
	mov rbx,[regimp]
	shr rbx, 20
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn6;  salta si es numero
	ja ess6; salta si es string

esn6:
	add rbx, 0x30 
	jmp setimo
 ess6:
	add rbx, 0x37

setimo:
	shl rbx, 16
	or [regout], rbx
	mov rbx,[regimp]
	shr rbx, 24
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn7;  salta si es numero
	ja ess7; salta si es string

esn7:
	add rbx, 0x30 
	jmp octavo
 ess7:
	add rbx, 0x37
octavo:

	shl rbx, 8
	or [regout], rbx
	mov rbx,[regimp]
	shr rbx, 28
	and rbx, 0x0000000f;mascara, para extraer los ultimos bits
	cmp rbx, 0x00000009
	jbe esn8;  salta si es numero
	ja ess8; salta si es string

esn8:
	add rbx, 0x00000030; lo convierte en numero ascii
	jmp saledec
 ess8:
	add rbx, 0x00000037; lo conv en letra
;________________________________________
saledec:
	
	;shl rbx, 8
	or [regout], rbx
	ret
;devuelve texout 32bits en ascii









_start:

crearchivo:
;____________________________________
mov eax, 8
mov ebx, archivo
mov ecx, 0x02
mov edx, 7777h
int 0x80
;____________________________________


cmp eax, 0; verifica que se haya creado correctamente
jle salir
mov dword[idarchivo], eax



;_____________________________________________________________________________________________
;#############################################################################################
;_____________________________________________________________________________________________
































;se genera el caracter a guardar
mov rax, 0xc00B01A0
;add eax, '0'
mov [regimp], rax
;add eax, 48
call primero

;mov [texto], eax

imp regout
mov eax, 4
mov ebx, dword[idarchivo]
mov ecx, regout
mov edx, 8;tamaño del texto
int 0x80






;_____ cierra el archivo
mov eax, 6
mov ebx, dword[idarchivo]
mov ecx, 0
mov edx, 0
int 0x80
salir:
 mov eax, 1
 xor ebx, ebx
 int 0x80
