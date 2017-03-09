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