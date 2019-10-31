.org 0x000 
LOAD M(0x3FF)
SUB M(um)
STOR M(n_1)
comeco:
    LOAD M(0x3FD)
    ADD M(i)
    STA M(zero_quatro)
    LOAD M(0x3FE)
    ADD M(i)
    STA M(zero_cinco)
    zero_quatro:
    LOAD MQ, M(0x000)
    zero_cinco:
    MUL M(0x000)
    LOAD MQ
    STOR M(m)
    LOAD M(res)
    ADD M(m)
    STOR M(res)
    LOAD M(i)
    ADD M(um)
    STOR M(i)
    LOAD M(n_1) 
    SUB M(i)
    JUMP+ M(comeco)
    LOAD M(res)
    JUMP M(saida)

.org 0x060
res: .word 0x0000000000 # res
a:   .word 0x0000000000 # A[i]
b:   .word 0x0000000000 # B[i]
m:   .word 0x0000000000 # M = A[i]*B[i]
i:   .word 0x0000000000 # i (começa 0)
n_1: .word 0x0000000000 # N-1
um:  .word 0x0000000001 # 1

.org 0x400
saida:

