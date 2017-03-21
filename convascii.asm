segment .data

segment .bss
	regimp resb 8
	regout resb 16
segment .text

global _start

_start:
mov rbx,[regimp]
primero:
;mov rbx,[regimp]
mov rcx, 0xf0000000 
and rbx, rcx;mascara, para extraer los ultimos bits
mov rcx, 0x90000000 
cmp rbx, rcx
jbe esn1;  salta si es numero
ja ess1; salta si es string

esn1:
mov rcx, 0x300000000 
add rbx, rcx; lo convierte en numero ascii
jmp segundo
 ess1:
 mov rcx, 0x370000000 
add rbx, rcx; lo conv en letra

;_______________________________________________________________________
segundo:

mov [regout], rbx
mov rbx,[regimp]
and rbx, 0x0f000000;mascara, para extraer los ultimos bits
cmp rbx, 0x09000000
jbe esn2;  salta si es numero
ja ess2; salta si es string

esn2:
add rbx, 0x030000000; lo convierte en numero ascii
jmp tercero
 ess2:
add rbx, 0x037000000; lo conv en letra

;_____________________________________________________________________________

tercero:

or [regout], rbx
mov rbx,[regimp]
and rbx, 0x00f00000;mascara, para extraer los ultimos bits
cmp rbx, 0x00900000
jbe esn3;  salta si es numero
ja ess3; salta si es string

esn3:
add rbx, 0x003000000; lo convierte en numero ascii
jmp cuarto
 ess3:
add rbx, 0x003700000; lo conv en letra


;___________________________________________________________________________
cuarto:

or [regout], rbx
mov rbx,[regimp]
and rbx, 0x000f0000;mascara, para extraer los ultimos bits
cmp rbx, 0x00090000
jbe esn4;  salta si es numero
ja ess4; salta si es string

esn4:
add rbx, 0x000300000; lo convierte en numero ascii
jmp quinto
 ess4:
add rbx, 0x000370000; lo conv en letra

;____________________________________________________________________________
quinto:

or [regout], rbx
mov rbx,[regimp]
and rbx, 0x0000f000;mascara, para extraer los ultimos bits
cmp rbx, 0x00009000
jbe esn5;  salta si es numero
ja ess5; salta si es string

esn5:
add rbx, 0x000030000; lo convierte en numero ascii
jmp sexto
 ess5:
add rbx, 0x000037000; lo conv en letra
;_____________________________________________________________________
sexto:

or [regout], rbx
mov rbx,[regimp]
and rbx, 0x00000f00;mascara, para extraer los ultimos bits
cmp rbx, 0x00000900
jbe esn6;  salta si es numero
ja ess6; salta si es string

esn6:
add rbx, 0x000003000; lo convierte en numero ascii
jmp septimo
 ess6:
add rbx, 0x000003700; lo conv en letra
;________________________________________

septimo:

or [regout], rbx
mov rbx,[regimp]
and rbx, 0x000000f0;mascara, para extraer los ultimos bits
cmp rbx, 0x00000090
jbe esn7;  salta si es numero
ja ess7; salta si es string

esn7:
add rbx, 0x000000300; lo convierte en numero ascii
jmp octavo
 ess7:
add rbx, 0x000000370; lo conv en letra
;________________________________________

octavo:

or [regout], rbx
mov rbx,[regimp]
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

 mov eax, 1
 xor ebx, ebx
 int 0x80
 ret; se debe agregaral final

;devuelve texout 32bits en ascii

