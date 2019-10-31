.globl _start

_start:

ler_linha:
    li a0, 0
    la a1, string1
    li a2, 32 
    li a7, 63
    ecall

# Queremos saber se é possível termos o valor 700 em um registrador.
# Queremos que o valor total esteja armazenado em t6
primeiro_numero:
    lb t0, 1(a1) # t0 <- 48
    li t5, 48
    sub t1, t0, t5 
    la t2, mil
    lh t3, 0(t2)
    mul t4, t1, t3
    addi t6, t4, 0

    lb t0, 2(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, cem
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 3(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, dez
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 4(a1)
    li t5, 48
    sub t1, t0, t5
    add t6, t6, t1

    # s1 = Yb
    addi s1, t6, 0

terminou_processamento_primeiro_numero:

segundo_numero:
    lb t0, 7(a1) 
    li t5, 48
    sub t1, t0, t5 
    la t2, mil
    lh t3, 0(t2)
    mul t4, t1, t3
    addi t6, t4, 0

    lb t0, 8(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, cem
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 9(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, dez
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 10(a1)
    li t5, 48
    sub t1, t0, t5
    add t6, t6, t1

    # s2 = Xc
    addi s2, t6, 0

terminou_processamento_segundo_numero:

terceiro_numero:
    lb t0, 12(a1) 
    li t5, 48
    sub t1, t0, t5 
    la t2, mil
    lh t3, 0(t2)
    mul t4, t1, t3
    addi t6, t4, 0

    lb t0, 13(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, cem
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 14(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, dez
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 15(a1)
    li t5, 48
    sub t1, t0, t5
    add t6, t6, t1

    # s3 = Ta
    addi s3, t6, 0

terminou_processamento_terceiro_numero:

quarto_numero:
    lb t0, 17(a1) 
    li t5, 48
    sub t1, t0, t5 
    la t2, mil
    lh t3, 0(t2)
    mul t4, t1, t3
    addi t6, t4, 0

    lb t0, 18(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, cem
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 19(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, dez
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 20(a1)
    li t5, 48
    sub t1, t0, t5
    add t6, t6, t1

    # s4 = Tb
    addi s4, t6, 0

terminou_processamento_quarto_numero:

quinto_numero:
    lb t0, 22(a1) 
    li t5, 48
    sub t1, t0, t5 
    la t2, mil
    lh t3, 0(t2)
    mul t4, t1, t3
    addi t6, t4, 0

    lb t0, 23(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, cem
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 24(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, dez
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 25(a1)
    li t5, 48
    sub t1, t0, t5
    add t6, t6, t1

    # s5 = Tc
    addi s5, t6, 0

terminou_processamento_quinto_numero:

sexto_numero:
    lb t0, 27(a1) 
    li t5, 48
    sub t1, t0, t5 
    la t2, mil
    lh t3, 0(t2)
    mul t4, t1, t3
    addi t6, t4, 0

    lb t0, 28(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, cem
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 29(a1)
    li t5, 48
    sub t1, t0, t5
    la t2, dez
    lh t3, 0(t2)
    mul t4, t1, t3
    add t6, t6, t4

    lb t0, 30(a1)
    li t5, 48
    sub t1, t0, t5
    add t6, t6, t1

    # s6 = Tr
    addi s6, t6, 0

terminou_processamento_sexto_numero:

# Atribuir sinal para o s1 e s2
# + = 43
# - = 45
sinal_primeiro_numero:
    lb t0, 0(a1)
    li t1, 45

    beq t0, t1, if1
    j coisas_pos_if1
    
    if1:
        la t2, negativo
        lb t3, 0(t2)
        mul s1, s1, t3

    coisas_pos_if1:

sinal_segundo_numero:
    lb t0, 6(a1)
    li t1, 45

    beq t0, t1, if2
    j coisas_pos_if2
    
    if2:
        la t2, negativo
        lb t3, 0(t2)
        mul s2, s2, t3

    coisas_pos_if2:

# Vamos calcular Ha = Tr-Ta e depois Da = (Ha*3)/10
variacao_tempo_a:
    sub s7, s6, s3

distancia_a:
    la t1, tres
    lb t2, 0(t1)
    mul s7, s7, t2
    la t1, dez
    lb t2, 0(t1)
    div s7, s7, t2

variacao_tempo_b:
    sub s8, s6, s4

distancia_b:
    la t1, tres
    lb t2, 0(t1)
    mul s8, s8, t2
    la t1, dez
    lb t2, 0(t1)
    div s8, s8, t2

variacao_tempo_c:
    sub s9, s6, s5

distancia_c:
    la t1, tres
    lb t2, 0(t1)
    mul s9, s9, t2
    la t1, dez
    lb t2, 0(t1)
    div s9, s9, t2

calculando_y:
    mul t0, s7, s7
    mul t1, s1, s1 
    mul t2, s8, s8
    add t3, t0, t1
    sub t4, t3, t2
    slli t5, s1, 1
    div s10, t4, t5

calculando_x:
    mul t1, s10, s10
    sub t2, t0, t1
    addi a1, t2, 0
    jal calculando_raiz_quadrada
    addi s11, a2, 0

    # Aqui vamos fazer uma verificação se o -sqrt(s11) ou sqrt(s11) é mais próximo do valor que é
    # do nosso interesse

    addi t0, s11, 0 # t0 = x1 = sqrt(...)

    addi t1, s11, 0
    la t2, negativo
    lb t3, 0(t2)
    mul t1, t1, t3 # t1 = x2 = -sqrt(...)

    # Aqui podemos usar os registradores a0, a1, ...
    # Primeiro queremos a0 = dc²-(x1-Xc)²-y²
    mul a0, s9, s9
    sub a1, t0, s2
    mul a1, a1, a1
    sub a0, a0, a1
    mul a1, s10, s10
    sub a0, a0, a1
    
    # Agora queremos a1 = dc²-(x2-Xc)²-y²
    mul a1, s9, s9
    sub a2, t1, s2
    mul a2, a2, a2
    sub a1, a1, a2
    mul a2, s10, s10
    sub a1, a1, a2

    # Agora queremos que eles estejam em modulo
    bgt zero, a0, if3
    j coisas_pos_if3

    if3:
        la t5, negativo
        lb t6, 0(t5)
        mul a0, a0, t6
    coisas_pos_if3:

    bgt zero, a1, if4
    j coisas_pos_if4

    if4:
        la t5, negativo
        lb t6, 0(t5)
        mul a1, a1, t6
    coisas_pos_if4:

    bgt a0, a1, if5
    j coisas_pos_if5

    if5:
        addi s11, t1, 0
        j coisas_pos_if5

    coisas_pos_if5:

gerando_saida:
    addi t0, zero, 43
    bgt zero, s11, if6
    j coisas_pos_if6

    if6:
        addi t0, zero, 45
    coisas_pos_if6:

    la t1, saida
    sb t0, 0(t1)

    addi t0, zero, 43
    bgt zero, s10, if7
    j coisas_pos_if7

    if7:
        addi t0, zero, 45
    coisas_pos_if7:

    sb t0, 6(t1)

    # Agora que já temos os sinais que precisamos,
    # podemos deixar os valores em s11 e s10 em módulo

    bgt zero, s10, if8
    j coisas_pos_if8

    if8:
        la t0, negativo
        lb t1, 0(t0)
        mul s10, s10, t1
    coisas_pos_if8:

    bgt zero, s11, if9
    j coisas_pos_if9

    if9:
        la t0, negativo
        lb t1, 0(t0)
        mul s11, s11, t1
    coisas_pos_if9:

    # primeiro numero
    la t0, mil
    lw t1, 0(t0)
    div t2, s11, t1
    mul t3, t1, t2
    sub s11, s11, t3
    addi t2, t2, 48
    la t4, saida
    sb t2, 1(t4)

    # segundo numero
    la t0, cem
    lw t1, 0(t0)
    div t2, s11, t1
    mul t3, t1, t2
    sub s11, s11, t3
    addi t2, t2, 48
    la t4, saida
    sb t2, 2(t4)

    # terceiro numero
    la t0, dez
    lw t1, 0(t0)
    div t2, s11, t1
    mul t3, t1, t2
    sub s11, s11, t3
    addi t2, t2, 48
    la t4, saida
    sb t2, 3(t4)

    # quarto numero
    addi s11, s11, 48
    sb s11, 4(t4)
    

    # primeiro numero
    la t0, mil
    lw t1, 0(t0)
    div t2, s10, t1
    mul t3, t1, t2
    sub s10, s10, t3
    addi t2, t2, 48
    la t4, saida
    sb t2, 7(t4)

    # segundo numero
    la t0, cem
    lw t1, 0(t0)
    div t2, s10, t1
    mul t3, t1, t2
    sub s10, s10, t3
    addi t2, t2, 48
    la t4, saida
    sb t2, 8(t4)

    # terceiro numero
    la t0, dez
    lw t1, 0(t0)
    div t2, s10, t1
    mul t3, t1, t2
    sub s10, s10, t3
    addi t2, t2, 48
    la t4, saida
    sb t2, 9(t4)

    # quarto numero
    addi s10, s10, 48
    sb s10, 10(t4)



escreve_linha:
    li a0, 1
    la a1, saida 
    li a2, 11
    li a7, 64
    ecall

printa_nova_linha:
    li a0, 1
    la a1, nova_linha
    li a2, 1
    li a7, 64
    ecall

return_0:
    li a0, 0
    li a7, 93
    ecall

calculando_raiz_quadrada:
    srli t0, a1, 1

    # 1ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 2ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 3ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 4ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 5ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 6ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 7ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 8ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 9ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    # 10ª
    div t1, a1, t0
    add t2, t0, t1
    srli t3, t2, 1
    addi t0, t3, 0

    addi a2, t0, 0

    retorno:
        ret

saida: .asciz "+0000 +0000\n"
string1: .skip 32
nova_linha: .word 10
dez: .word 10
cem: .word 100
mil: .word 1000
negativo: .word -1
tres: .word 3