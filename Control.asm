section.data
;se definen las constantes que van a ser los 6 bits del opcode, de acuerdo a la instrucción, y son los que //se van a comparar con el opcode entrante para realizar los condicionales
R: db 0x00  ;// definicion de la constante del OPCode de las instrucciones tipo R
;definiciones de la constante del OPCode de las instrucciones tipo i y j
addi: db 0x08
addiu: db 0x09
andi: db 0x0C
beq: db 0x04
bne: db 0x05
j: db 0x02
jal: db 0x03
lbu: db 0x24
lhu: db 0x25
lui: db 0x25
lw: db 0x23
sb: db 0x28
sh: db 0x29
slti: db 0x0A
sltiu: db 0x0B
sw: db 0x2B

; definicion de los valores que van a obtener las senales de control, segun la tabla de verdad

AluOP1: db 00000001 ; instruccion branch on equal
AluOP1: db 00000000 ; instruccion store word y load word
AluOP2: db 00000010 ; instrucciones R

RegDST0: db 00000000 ; segundo campo de 5 bits en la instrucción para lw
RegDST1: db 00000001 ; tercer campo de 5 bits en la instrucción para operaciones de tipo R

Jump0: db 00000000 ; Dirección de alguna instrucción de tipo I
Jump1: db 00000001 ; PC + 4

AluScr0: db 00000000; (operaciones de tipo R)
AluScr1: db 00000001 ;Extension de signo(lw, sw)

RegWrite0: db 00000000; (No permite escritura)
RegWrite1: db 00000001; (Permite escritura)

MemtoReg0: db 00000000; desde ALUoutput (para operaciones de tipo R);
MemtoReg1: db 00000001; de MDR (para lw)


segment .bss  ; en esta seccion se definen las variables no inicializada, las senales de control.
; se reserva 1 byte para cada una
   
   AluSrc   resb 1 ; r8
   RegWrite resb 1 ;r9
   MemtoReg resb 1 ;r10
   AluOp    resb 1 ;r11
   RegDest  resb 1 ;r12
   Jump     resb 1 ;r13
   OpCode   resb 1 ;r14 
   
section .text

global_start

_start:

Inicio:
        ; obtiene el opcode de la instruccion que esta almacenada en memoria
        move[OpCode],xxx ; obtenido el opcode, se almacena en la direccion de memoria del registro Opcode, para empezar a comparar   
        jmp ComparaR; salta al bloque de comparacion

ComparaR:
	mov	rax,[R]	        ; Mueve el OpCode de tipo R al registro para su posterior comparacion
	mov	rbx,[OpCode]	        ; Mueve el OpCode de entrada, proveniente de la instruccion	
    cmp	rax,rbx		; Compara los OpCode
	je	SalidaR		; Si son iguales salta al bloque que ejecuta las instrucciones que dan las salidas 
	jne    Comparaddi       ; Si no son iguales salta a otro bloque para seguir comparando el OpCode


SalidaR:
         mov   r11, [AluOP2] ; almacena el valor de operacion en el registro de proposito general
         mov [Aluop],r11 ; almacena el codigo de operacion en la direccion de memoria AluOp
         mov r12,[RegDST1]; 
         mov [RegDest],r12; almacena el codigo de en la direccion de memoria RegDest
         mov r13,[Jump1];
         mov [Jump],r13 ;almacena el codigo de en la direccion de memoria Jump
         mov r8,[AluScr0];
	     mov [AluSrc], r8 ;almacena el codigo de en la direccion de memoria AluSrc
	     mov r9,[RegWrite1];
	     mov [Regwrite], r9 ;almacena el codigo de en la direccion de memoria Regwrite      
 	     mov r10,[MemtoReg0];
	     mov [MemtoReg], r10 ;almacena el codigo de en la direccion de memoria MemtoReg
         jmp Inicio; Al terminar de asignar los valores a los registros, salta incodicionalmente al inicio para volver a obtener el Opcode         

	
Comparaddi:
	mov	rax,[addi]	        ; Mueve el OpCode de la instruccion addi al registro para su posterior comparacion
	mov	rbx,[OpCode]	        ; Mueve el OpCode de entrada, proveniente de la instruccion	
        cmp	rax,rbx		; Compara los OpCode
	je      Salidaddi		; Si son iguales salta al bloque que ejecuta las instrucciones que dan las salidas 
	jne    ComparaLW       ; Si no son iguales salta a otro bloque para seguir comparando el OpCode


Salidaddi:
         mov   r11, [AluOP2] ; almacena el valor de operacion en el registro de proposito general
         mov [Aluop],r11 ; almacena el codigo de operacion en la direccion de memoria AluOp
         mov r12,[RegDST1]; 
         mov [RegDest],r12; almacena el codigo de en la direccion de memoria RegDest
         mov r13,[Jump1];
         mov [Jump],r13 ;almacena el codigo de en la direccion de memoria Jump
         mov r8,[AluScr0];
	     mov [AluSrc], r8 ;almacena el codigo de en la direccion de memoria AluSrc
	     mov r9,[RegWrite1];
	     mov [Regwrite], r9 ;almacena el codigo de en la direccion de memoria Regwrite      
 	     mov r10,[MemtoReg0];
	     mov [MemtoReg], r10 ;almacena el codigo de en la direccion de memoria MemtoReg  
         jmp Inicio    


ComparaLW:

	mov	rax,[lw]	        ; Mueve el OpCode de la instruccion Load word al registro para su posterior comparacion
	mov	rbx,[OpCode]	        ; Mueve el OpCode de entrada, proveniente de la instruccion	
    cmp	rax,rbx		       ;  Compara los OpCode
	je   SalidaLW		 ; Si son iguales salta al bloque que ejecuta las instrucciones que dan las salidas 
	jne   ComparaSW       ; Si no son iguales salta a otro bloque para seguir comparando el OpCode


SalidaLW:
         mov   r11, [AluOP2] ; almacena el valor de operacion en el registro de proposito general
         mov [Aluop],r11 ; almacena el codigo de operacion en la direccion de memoria AluOp
         mov r12,[RegDST1]; 
         mov [RegDest],r12; almacena el codigo de en la direccion de memoria RegDest
         mov r13,[Jump1];
         mov [Jump],r13 ;almacena el codigo de en la direccion de memoria Jump
         mov r8,[AluScr0];
	 mov [AluSrc], r8 ;almacena el codigo de en la direccion de memoria AluSrc
	 mov r9,[RegWrite1];
	 mov [Regwrite], r9 ;almacena el codigo de en la direccion de memoria Regwrite      
 	 mov r10,[MemtoReg0];
	 mov [MemtoReg], r10 ;almacena el codigo de en la direccion de memoria MemtoReg  
     jmp Inicio;    

ComparaSW:

	mov	rax,[sw]	        ; Mueve el OpCode de la instruccion store word al registro para su posterior comparacion
	mov	rbx,[OpCode]	        ; Mueve el OpCode de entrada, proveniente de la instruccion	
    cmp	rax,rbx		; Compara los OpCode
	je     SalidaSW		; Si son iguales salta al bloque que ejecuta las instrucciones que dan las salidas 
	jne    Jumpi       ; Si no son iguales salta a otro bloque para seguir comparando el OpCode

SalidaSW:
         mov   r11, [AluOP2] ; almacena el valor de operacion en el registro de proposito general
         mov [Aluop],r11 ; almacena el codigo de operacion en la direccion de memoria AluOp
         mov r12,[RegDST1]; 
         mov [RegDest],r12; almacena el codigo de en la direccion de memoria RegDest
         mov r13,[Jump1];
         mov [Jump],r13 ;almacena el codigo de en la direccion de memoria Jump
         mov r8,[AluScr0];
	     mov [AluSrc], r8 ;almacena el codigo de en la direccion de memoria AluSrc
	 	 mov r9,[RegWrite1];
	     mov [Regwrite], r9 ;almacena el codigo de en la direccion de memoria Regwrite      
 	     mov r10,[MemtoReg0];
	     mov [MemtoReg], r10 ;almacena el codigo de en la direccion de memoria MemtoReg  
         jmp Inicio;     
      
;faltan tdavia agregar el resto de instrucciones que no son R, pero por ahora para probar una suma