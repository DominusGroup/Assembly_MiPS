;macro para convertir variable en memoria a string y que pueda ser impreso en pantalla
%macro convstr 1;  
  	mov eax, [%1]
	add eax, '0'
	mov [%1], eax
%endmacro


%macro imp 1;
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, %1
	mov edx, 1
	int 0x80


;etiqueta para imprimir
_imprimirdeco:
	; %1 = $r15 ( OPCODE )
	; %2 = $r14 ( rs )
	; %3 = $r13 ( rt )
	; %4 = $r12 ( rd )
	; %5 = $r10 ( Function ) 
	; %6 = $r9  ( Immediate) 
	; %7 = $r8  ( Address )

    ; se mueven los contenidos de los registro a las variables en memoria
    ; para evitar modificar el registro a la hora de convertirlo en string y se hace mejor en la variable de memoria
    mov[Opcode],r15d
    mov[RS],r14d
    mov[RT],r13d
    mov[RD],r12d
    mov[Address],r8d
    mov[Immediate],r9d	
    cmp r15d, 				   0x0 		 ; OPCODE = 0 for R-type
	je ImprimeR      
	cmp r15d, 				   0x02      ; OPCODE = 2 (j), J-type
	je ImprimeJ
	cmp r15d, 				   0x03      ; OPCODE = 3 (jal), J-type
	je ImprimeJ
	jne ImprimeI
	
      
      ImprimeR:
      	
      	mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner0				;Imprime:'La instruccion es de tipo R y posee el siguiente formato: '	
		mov rdx,cons_tamano_banner0	
		syscall								

        mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner01				;Imprime:'OpCode: '
		mov rdx,cons_tamano_banner01	
		syscall								
        
        convstr Opcode                       ;Convierte a String el contenido de la variable en memoria
        imp Opcode                           ; Se muestra display del opcode

		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner02				
		mov rdx,cons_tamano_banner02	
		syscall		
        convstr RS
        imp RS

		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner03				
		mov rdx,cons_tamano_banner03	
		syscall		
        convstr RT
        imp RT
		
		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner04				
		mov rdx,cons_tamano_banner04	
		syscall		
        convstr RD
        imp RD

		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner05				
		mov rdx,cons_tamano_banner05	
		syscall		
        convstr Shamt
        imp Shamt


		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner06				
		mov rdx,cons_tamano_banner06	
		syscall		
        convstr Function
        imp Function

        jmp Salidaimp


    ImprimeJ:

        mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner2				
		mov rdx,cons_tamano_banner2	
		syscall								

        mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner01				
		mov rdx,cons_tamano_banner01	
		syscall								
        convstr Opcode
        imp opcode

		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner08				
		mov rdx,cons_tamano_banner08	
		syscall		
        convstr Address
        imp Address

         jmp Salidaimp

    ImprimeI:

      	mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner3				
		mov rdx,cons_tamano_banner3	
		syscall								

        mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner01				
		mov rdx,cons_tamano_banner01	
		syscall								
        convstr Opcode
        imp opcode

		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner02				
		mov rdx,cons_tamano_banner02	
		syscall		
        convstr RS
        imp RS

		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner03				
		mov rdx,cons_tamano_banner03	
		syscall		
        convstr RT
        imp RT

		mov rax,1							
	    mov rdi,1							
		mov rsi,cons_banner07				
		mov rdx,cons_tamano_banner07	
		syscall		
        convstr Immediate
        imp Immediate

         jmp Salidaimp


    Salidaimp:
    ret     


section .data
	cons_banner0: db 'La instruccion es de tipo R y posee el siguiente formato: '		
	cons_tamano_banner0: equ $-cons_banner0				

	cons_banner01: db 'Opcode:'		
	cons_tamano_banner01: equ $-cons_banner01		

	cons_banner02: db 'RS: '		
	cons_tamano_banner02: equ $-cons_banner02		

	cons_banner03: db 'RT:'		
	cons_tamano_banner03: equ $-cons_banner03	

	cons_banner04: db 'RD:'		
	cons_tamano_banner04: equ $-cons_banner04

    cons_banner05: db 'Shamt:'		
	cons_tamano_banner05: equ $-cons_banner05

	cons_banner06: db 'Function:'		
	cons_tamano_banner06: equ $-cons_banner06

	cons_banner07: db 'Immediate:'		
	cons_tamano_banner07: equ $-cons_banner07

	cons_banner08: db 'Address:'		
	cons_tamano_banner08: equ $-cons_banner08

	cons_banner2: db 'La instruccion es de tipo I y posee el siguiente formato: '		
	cons_tamano_banner2: equ $-cons_banner2		

	cons_banner3: db 'La instruccion es de tipo J y posee el siguiente formato: '		
	cons_tamano_banner3: equ $-cons_banner3		


;Nuevas variables en memoria
section .bss

 RT: resb 1
 RS: resb 1
 RD: resb 1
 Address: resb 4
 Immediate: resb 2




 call _imprimirdeco:
