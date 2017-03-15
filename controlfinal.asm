%macro Control 11; recibe el opcode, y crea las 9 salidas de control, todas direcciones de memoria
; 1.  opcode
; 2.  RegDst
; 3.  Jump
; 4.  Branch
; 5.  MemRead
; 6.  MemtoReg
; 7.  Aluop
; 8.  Memwrite
; 9.  AluSrc
;10.  RegWrite
;11. function
;Reistros usados interiormente, Eax, Ebx,Ecx, Edx
;---------------------------------------------------------
	mov eax, 0
	mov ebx, 1
	mov r8, [%1]; copia opcode
	cmp r8, 0;
	je tipo_R
	cmp r8, 0x02;
	je tipo_J
	cmp r8, 0x03
	je tipo_J
	jmp tipo_I;si no es ni r ni j salta a tipo tipo_I
	
	tipo_R:
		
		mov [%2], ebx
		mov [%3], eax
		mov [%4], eax; branch
		mov [%5], eax
		mov [%6], eax
		mov [%7], r8
		mov [%8], ebx
		mov [%9], eax
		mov edx, [%11] ;otro registro, cambiar
		cmp edx,0x18
		je mult
		cmp edx,0x08
		je mult
		mov [%10], ebx
		jmp salecontrol

	mult: 
		mov [%10], eax
		jmp salecontrol

	tipo_J:

		mov [%2], ebx
		mov [%3], ebx
		mov [%4], eax; branch
		mov [%5], eax
		mov [%6], eax 
		mov [%7], r8
		mov [%8], ebx
		mov [%9], eax 
		cmp r8,0x02
		je  jumpj
		mov [%10], ebx
		jmp salecontrol
	
	jumpj:
		mov [%10], eax
		jmp salecontrol

	tipo_I:
		mov [%2], eax
		mov [%3], eax
		mov [%4], ebx; branch
		mov [%7], r8;
		;mov r8, [%1];
		;cmp r8, 0x24 ;lbu
		;mov [%6],eax
		;je MemRI
		;cmp r8, 0x25;lhu
		;je MemRI
		;cmp r8, 0x30;ll
		;mov [%6], ebx
		;je MemRI
		cmp r8, 35;lw
		je MemRI
		mov [%5], eax
		mov [%6], eax
		jmp conti1

	MemRI:
		mov [%5], ebx
		mov [%6], ebx; agregada para loadword
		jmp conti1

	conti1:
		;mov ecx, [%1]
		cmp r8, 0x28;sb
		je MemWI
		cmp r8, 0x38;sc
		je MemWI
		cmp r8, 0x29;sh
		je MemWI
		cmp r8, 0x2b
		je MemWI
		mov [%8], ebx
		jmp conti2
	MemWI:
		mov [%8], eax
		mov [%10], eax
		mov [%9], ebx;
		;jmp conti2
		jmp salecontrol
	conti2:
		mov [%9], ebx;
		cmp r8, 0x04;be
		je RegWI
		cmp r8, 0x05;bne
		je RegWI
		mov [%10], ebx
		jmp salecontrol
	RegWI:
		mov [%10], eax
		jmp salecontrol
	salecontrol:

%endmacro