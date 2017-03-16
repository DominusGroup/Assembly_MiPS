
; 1.  opcode------r15d
; 2.  RegDst------RegDST1
; 3.  Jump--------Jump1


; 4.  Branch------Agregarla
; 5.  MemRead-----Agregarla


; 6.  MemtoReg----MemtoReg0
; 7.  Aluop-------OpCode

; 8.  MemWrite-----Agregarla


; 9.  AluSrc-------AluScr0
;10.  RegWrite-----RegWrite1
;11. function------Function
;Reistros usados interiormente, Eax, Ebx,Ecx, Edx
;---------------------------------------------------------
	mov eax, 0
	mov ebx, 1
	;mov r8, [%1]; copia opcode
	cmp r15d, 0;
	je tipo_R
	cmp r15d, 0x02;
	je tipo_J
	cmp r15d, 0x03
	je tipo_J
	jmp tipo_I;si no es ni r ni j salta a tipo tipo_I
	
	tipo_R:
		
		mov [RegDST1], ebx
		mov [Jump1], eax
		mov [Branch], eax; branch
		mov [MemRead], eax
		mov [MemtoReg0], eax
		mov [OpCode], r15d
		mov [MemWrite], ebx
		mov [AluScr0], eax
		mov edx, [Function] ;otro registro, cambiar
		cmp edx,0x18
		je mult
		cmp edx,0x08
		je mult
		mov [RegWrite], ebx
		jmp salecontrol

	mult: 
		mov [RegWrite], eax
		jmp salecontrol

º	tipo_J:

		mov [RegDST1], ebx
		mov [Jump1], ebx
		mov [Branch], eax; branch
		mov [MemRead], eax
		mov [MemtoReg0], eax 
		mov [OpCode], r15d
		mov [MemWrite], ebx
		mov [AluScr0], eax 
		cmp r15d,0x02
		je  jumpj
		mov [RegWrite], ebx
		jmp salecontrol
	
	jumpj:
		mov [RegWrite], eax
		jmp salecontrol

	tipo_I:
		mov [RegDST1], eax
		mov [Jump1], eax
		mov [Branch], ebx; branch
		mov [OpCode], r15d;
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
		mov [MemRead], eax
		mov [MemtoReg0], eax
		jmp conti1

	MemRI:
		mov [MemRead], ebx
		mov [MemtoReg0], ebx; agregada para loadword
		jmp conti1

	conti1:
		;mov ecx, [%1]
		cmp r15d, 0x28;sb
		je MemWI
		cmp r15d, 0x38;sc
		je MemWI
		cmp r15d, 0x29;sh
		je MemWI
		cmp r15d, 0x2b
		je MemWI
		mov [MemWrite], ebx
		jmp conti2
	MemWI:
		mov [MemWrite], eax
		mov [RegWrite], eax
		mov [AluScr0], ebx;
		;jmp conti2
		jmp salecontrol
	conti2:
		mov [AluScr0], ebx;
		cmp r15d, 0x04;be
		je RegWI
		cmp r15d, 0x05;bne
		je RegWI
		mov [RegWrite], ebx
		jmp salecontrol
	RegWI:
		mov [RegWrite], eax
		jmp salecontrol
	salecontrol:

