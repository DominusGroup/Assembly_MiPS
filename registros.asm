section .data


section .bss
;direcciones de registro parametros de entrada
	rega: resw	1;numero de registro a
	regb: resw	1;numero de registro b
	regw: resw	1  ;numero de registro a cambiar
	dator: resw	1	;dato a escribir
;direcciones auxiliares
	auxl: resw	1;auxiliar de busqueda
	asal: resw 	1;auxiliar de salida
	sala: resw	1;salida a
	salb: resw	1;salida b
;Contador de acción
	contr: resb	1;
;indicador de escritura
	indi: resb 	1;
;valores de registro parametros de salida y modificables
	reg0: resd	1
	reg1: resd	1
	reg2: resd	1
	reg3: resd	1
	reg4: resd	1	
	reg5:  resd	1
	reg6:  resd	1
	reg7: resd	1
	reg8: resd	1
	reg9: resd	1
	reg10: resd	1
	reg11: resd	1
	reg12: resd	1
	reg13: resd	1
	reg14: resd	1
	reg15: resd	1
	reg16: resd	1
	reg17: resd	1
	reg18: resd	1
	reg19: resd	1
	reg20: resd	1
	reg21: resd	1
	reg22: resd	1
	reg23: resd	1
	reg24: resd	1
	reg25: resd	1
	reg26: resd	1
	reg27: resd	1
	reg28: resd	1
	reg29: resd	1
	reg30: resd	1
	reg31: resd	1

section .text
global _inir
global _bancor
_inir:
	mov eax, 0
	mov [contr], eax
	int 0x80
	syscall;llamada para los recursos
_bancor:
	;identifica el caso de la busqueda
	mov eax, [contr]
	cmp eax, 1; se debe inicializar en cero
	jb _busca
	je _buscb
	ja _buscw

_busca:
	mov auxl,rega; se asigna al aux la dirección del registro a
	jmp _busqueda

_buscb:
	mov auxl,regb; se asigna al aux la direcció del registro a
	jmp _busqueda

_buscw:
	cmp [indi],1; preguna si debe escribir, uno indica que si
	jne _ebancor; es para salir y continuar con el programa
	mov auxl,regw; se asigna al aux la direcció del registro a
	jmp _busqueda

;..................................


;_______________________________________________
;Se utiliza el algoritmo de busqueda de Newton
;_______________________________________________

_busqueda:
	cmp [auxl], 16; numero de registro
	je _asig16
	ja _busq2
	jb _busq3

_busq2:
	cmp [auxl], 24; numero de registro
	je _asig24
	ja _busq4
	jb _busq5

_busq3:
	cmp [auxl], 8; numero de registro
	je _asig8
	ja _busq6
	jb _busq7

_busq4:
	cmp [auxl], 28; numero de registro
	je _asig28
	ja _busq8
	jb _busq9

_busq5:
	cmp [auxl], 20; numero de registro
	je _asig20
	ja _busq10
	jb _busq11

_busq6:
	cmp [auxl], 12; numero de registro
	je _asig12
	ja _busq12
	jb _busq13
_busq7:
	cmp [auxl], 4; numero de registro
	je _asig4
	ja _busq14
	jb _busq15
_busq8:
	cmp [auxl], 30; numero de registro
	je _asig30
	ja _busq16
	jb _busq17
_busq9:
	cmp [auxl], 26; numero de registro
	je _asig26
	ja _busq18
	jb _busq19
_busq10:
	cmp [auxl], 22; numero de registro
	je _asig22
	ja _busq20
	jb _busq21
_busq11:
	cmp [auxl], 18; numero de registro
	je _asig18
	ja _busq22
	jb _busq23
_busq12:
	cmp [auxl], 14; numero de registro
	je _asig14
	ja _busq24
	jb _busq25
_busq13:
	cmp [auxl], 10; numero de registro
	je _asig10
	ja _busq26
	jb _busq27

_busq14:
	cmp [auxl], 6; numero de registro
	je _asig6
	ja _busq28
	jb _busq29
_busq15:
	cmp [auxl], 2; numero de registro
	je _asig2
	ja _busq30
	jb _busq31

_busq16:
	cmp [auxl], 31; numero de registro
	je _asig31
_busq17:
	cmp [auxl], 29; numero de registro
	je _asig29

_busq18:
	cmp [auxl], 27; numero de registro
	je _asig27

_busq19:
	cmp [auxl], 25; numero de registro
	je _asig25

_busq20:
	cmp [auxl], 23; numero de registro
	je _asig23

_busq21:
	cmp [auxl], 21; numero de registro
	je _asig21

_busq22:
	cmp [auxl], 19; numero de registro
	je _asig19

_busq23:
	cmp [auxl], 17; numero de registro
	je _asig17

_busq24:

	cmp [auxl], 15; numero de registro
	je _asig15

_busq25:
	cmp [auxl], 13; numero de registro
	je _asig13

_busq26:
	cmp [auxl], 11; numero de registro
	je _asig11

_busq27:
	cmp [auxl], 9; numero de registro
	je _asig9

_busq28:
	cmp [auxl], 7; numero de registro
	je _asig7

_busq29:
	cmp [auxl], 5; numero de registro
	je _asig5

_busq30:
	cmp [auxl], 3; numero de registro
	je _asig3

_busq31:
	cmp [auxl], 1; numero de registro
	je _asig1

_busq0:
	cmp [auxl], 0; 
	je _asig0
;__________________________________________________________

_asig0:
	jmp _presalida

_asig1:
	mov asal, reg1
	jmp _presalida
_asig2:
	mov asal, reg2
	jmp _presalida

_asig3:
	mov asal, reg3
	jmp _presalida

_asig4:
	mov asal, reg4
	jmp _presalida

_asig5:
	mov asal, reg5
	jmp _presalida

_asig6:
	mov asal, reg6
	jmp _presalida

_asig7:
	mov asal, reg7
	jmp _presalida

_asig8:
	mov asal, reg8
	jmp _presalida

_asig9:
	mov asal, reg9
	jmp _presalida

_asig10:
	mov asal, reg10
	jmp _presalida

_asig11:
	mov asal, reg11
	jmp _presalida

_asig12:
	mov asal, reg12
	jmp _presalida

_asig13:
	mov asal, reg13
	jmp _presalida

_asig14:
	mov asal, reg14
	jmp _presalida

_asig15:
	mov asal, reg15
	jmp _presalida

_asig16:
	mov asal, reg16
	jmp _presalida

_asig17:
	mov asal, reg17
	jmp _presalida

_asig18:
	mov asal, reg18
	jmp _presalida

_asig19:
	mov asal, reg19
	jmp _presalida

_asig20:
	mov asal, reg20
	jmp _presalida

_asig21:
	mov asal, reg21
	jmp _presalida

_asig22:
	mov asal, reg22
	jmp _presalida

_asig23:
	mov asal, reg23
	jmp _presalida

_asig24:
	mov asal, reg24
	jmp _presalida

_asig25:
	mov asal, reg25:
	jmp _presalida

_asig26:
	mov asal, reg26
	jmp _presalida

_asig27:
	mov asal, reg27
	jmp _presalida

_asig28:
	mov asal, reg28
	jmp _presalida

_asig29:
	mov asal, reg29
	jmp _presalida

_asig30:
	mov asal, reg30
	jmp _presalida

_asig31:
	mov asal, reg31
	jmp _presalida

;la dirección del dato se encuentra en asal

_presalida:
	;identifica el caso de la busqueda
	cmp [contr], 1
	jb _salia
	je _salib
	ja _escribe

_salia:
	mov sala, asal; se asigna al registro a la dirección del asal
	inc [contr]
	jmp _bancor

_salib:
	mov salb, asal; se asigna al registro b la dirección del asal
	inc [contr]
	jmp _ebancor
_escribe:
	mov [contr], 0
	cmp [indi],1
	jne _pccont
	mov [asal],[dator]; se asigna al dato señalado por asal el dato de regw
	

_ebancor:
syscall
;jmp ;se debe especificar la etiqueta del siguiente bloque de hardware

;se debe llamar a bancor para usar el banco de registros








