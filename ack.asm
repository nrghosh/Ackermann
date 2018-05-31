; Nikhil Ghosh
; Comp 331 Homework 9 | Prof Epstein

; Compile like this:
;     nasm -f elf -gstabs ack.asm && ld -o ack -m elf_i386 ack.o
; Run like this:
;     ./ack


; Gives us various IO functions
%include "io.asm"

section .data
message_m: db "Please enter a value for m: "
message_m_len equ $-message_m
message_n: db "Please enter a value for n: "
message_n_len equ $-message_n

result_f1: db "f1 result: "
result_f1_len equ $-result_f1

result_f2: db "f2 result: "
result_f2_len equ $-result_f2


; The text section is for code
section .text
global _start

; function f1
f1:
    push ebp
    mov ebp, esp

    mov ebx, [ebp+8]		;; Move n to ebx
    mov ecx, [ebp+12] 		;; Move m to ecx

    cmp ecx, 0				;; Check if m=0
    je .ret_n 				;; Base Case 1: If m=0, jump and return n

    cmp ebx, 1				;; Check if n=1
    je .expo				;; Base Case 2: If n=1, jump and return 2^m

	.recursive_bit:
		dec ecx				;; m -> m-1 for inner loop and outer loop
		push ecx			;; Push ecx to stack twice- once for inner and once for outer loop
		push ecx
		inc ebx				;; n -> n+1 for inner loop
		push ebx

		call f1 			;; f1(m-1, n+1)
		push eax			;; push result of inner call to stack

		call f1 			;; f1(m-1, f1(m-1, n+1))
		jmp .end

	.expo:
		shl ebx, cl 		;; Calculate 2^m using left shift
		mov eax, ebx		;; Store the 2^m value in eax
		jmp .end

	.ret_n:
		mov eax, ebx		;; Return n
		jmp .end

	.end:
		pop ebp
		ret 8


; function f2
f2:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+8]		;; Move n to ebx
    mov ecx, [ebp+12] 		;; Move m to ecx

    cmp ebx, 0				;; Check if n=0
    je .ret_1 				;; Base Case 1: If n=0, jump and return 1

    cmp ecx, 0				;; Check if m=0
    je .ret_1				;; Base Case 2: If m=0, jump and return 1

    cmp ecx, 1				;; Check if m=1
    je .ret_2n 				;; Base Case 3: If m=1, jump and return 2n


	.recursive_bit:
		dec ecx					;; m -> m-1 for outer loop
		push ecx
		inc ecx					;; m-1+1 -> m for inner loop
		push ecx
		dec ebx					;; n -> n-1 for inner loop
		push ebx

		call f2 				;; f2(m, n-1)
		push eax				;; Push result of inner call to stack

		call f2 				;; f2(m-1, f2(m, n-1))
		jmp .end


	.ret_1:
		mov eax, 1				;; Return 1
		jmp .end

	.ret_2n:
		xor eax, eax			;; Clear out eax so that we're just storing 2n there
		add ebx, ebx			;; Multiply ebx by 2 by adding it to itself
		mov eax, ebx			;; Store it in eax to return
		jmp .end

	.end:
		pop ebp
  		ret 8






; The entrypoint of the program. Test the functions and print the result
_start:


    ; Prompt the user to enter a number for m
    mov eax,4
    mov ebx,1
    mov ecx,message_m
    mov edx,message_m_len
    int 80h
    call read_int
    push eax     ; push value of m


    ; Prompt the user to enter a number for n
    mov eax,4
    mov ebx,1
    mov ecx,message_n
    mov edx,message_n_len
    int 80h
    call read_int
    push eax      ; push value of n

    pop ebx       ; pop value of n
    pop ecx       ; pop value of m

    push ecx      ; set up params for f1 call
    push ebx
    push ecx      ; set up params for f2 call
    push ebx
    ; At this point, the stack contains m,n,m,n
    ; The first m and n will be consumed by f1
    ; The second by f2


    ; Call f1
    call f1
    push eax      ; push the result for print_int
    mov eax,4
    mov ebx,1
    mov ecx,result_f1
    mov edx,result_f1_len
    int 80h
    call print_int ; print_the result
    call print_newline


    ; Call f2
    call f2
    push eax      ; push the result for print_int
    mov eax,4
    mov ebx,1
    mov ecx,result_f2
    mov edx,result_f2_len
    int 80h
    call print_int ;print the result
    call print_newline


; We're done, tell the OS to kill us
    call exit
