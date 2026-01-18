section .text
global _start

add:
    ; 初始化 栈
    push rbp        ; r: register, rbp: 栈底指针
    mov rbp, rsp    ; rsp: 栈顶指针

    ; 计算 a + b
    mov rax, rdi    ; rax = a
    add rax, rsi    ; rax += b

    ; 恢复栈帧
    pop rbp
    ret

_start:
    mov rdi, 5
    mov rsi, 3
    call add        ; return in rax

    mov rdi, rax
    mov rax, 60
    syscall
