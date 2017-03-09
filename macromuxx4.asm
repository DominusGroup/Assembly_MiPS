;---------MACRO MUX4-----------
	%macro muliplexx4 6 
						;%1 es la direccion de memoria selector, 
						;%2 Es la direccion de entrada 1
						;%3 es la dirección de enrada 2, 
						;%4 Es la direccion de entrada 3
						;%5 es la dirección de enrada 4, 
						;%6 es la direccion de memoria de salida
	mov eax, [%1]
	cmp eax, 0
	je _select0;
	cmp eax, 1
	je _select1
	cmp eax, 2
	je _select2;
	cmp eax, 3
	je _select3

	_select0:
		mov eax, [%2]
		mov [%6], eax
		jmp _salemux1

	_select1:
		mov eax, [%3]
		mov [%6], eax
		jmp _salemux1
		_select1:
		mov eax, [%4]
		mov [%6], eax
		jmp _salemux1
		_select1:
		mov eax, [%5]
		mov [%6], eax
		jmp _salemux1

	_salemux1:
	%endmacro