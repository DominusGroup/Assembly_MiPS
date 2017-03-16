;%macro escribe 2
;mov eax, 4
;mov ebx, 1
;mov ecx, %1
;mov edx, %2
;int 0x80
;%endmacro

segment .data
;msg2 db  "Escribe: ",0xA
;len2 equ $-msg2

archivo db "/home/nala/Escritorio/Resultados.txt"


segment .bss

texto resb 2  ; auxiliar de texto a escribir
idarchivo resd 1; identificador de archivo
;id resb 1

segment .text



;_____________________________________
leetecla:
	mov eax, 3
	mov ebx, 0
	mov edx, 2
	int 0x80
ret
;_____________________________________



global _start

_start:

mov eax, 8
mov ebx, archivo
mov ecx, 0x02
mov edx, 7777h
int 0x80

test eax, eax
jz salir
mov dword[idarchivo], eax


;_______llama a leetecla para guardar en la variable texto
mov ecx, texto
call leetecla
;____________________________________________________
mov ecx, 5
add ecx, '0'
mov [texto], ecx

mov eax, 4
mov ebx, dword[idarchivo]
mov ecx, texto
mov edx, 2
int 0x80



mov eax, 6
mov ebx, [idarchivo]
mov ecx, 0
mov edx, 0
int 0x80


salir:
 mov eax, 1
 xor ebx, ebx
 int 0x80
