
.globl _start

_start:

ler_linha:
    li a0, 0
    la a1, string1
    li a2, 32 
    li a7, 63
    ecall

    li a0, 1 # file descriptor = 1 (stdout)
    la a1, string #  buffer
    li a2, 19 # size
    li a7, 64 # syscall write (64)
    ecall

    li a0, 0 # exit code
    li a7, 93 # syscall exit
    ecall


string:  .asciz "Nicolas - ra185137\n"  #coloca a string na memoria
string1: .skip 32
