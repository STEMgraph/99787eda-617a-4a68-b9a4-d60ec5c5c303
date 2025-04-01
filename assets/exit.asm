; file: exit.asm
section .text
    global _start

_start:
    mov     rax, 60     ; syscall: exit
    mov     rdi, 42     ; return code
    syscall             ; invoke kernel