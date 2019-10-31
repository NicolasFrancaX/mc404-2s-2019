
time_now:
    la a0, buffer_timeval
    la a1, buffer_timerzone
    li a7, 169 # chamda de sistema gettimeofday
    ecall
    la a0, buffer_timeval
    lw t1, 0(a0) # tempo em segundos
    lw t2, 8(a0) # fração do tempo em microssegundos
    #li t3, 1000
    #mul t1, t1, t3
    #div t2, t2, t3
    #add a0, t2, t1
    mv a0, t1
    #li t4, -1
    #mul a0, a0, t4
    ret

abs:
    bge a0, zero, positivo
    j negativo

    positivo:
        addi a0, a0, 0
        j quit

    negativo:
        li s0, -1
        mul a0, a0, s0
    quit:
        ret



.globl main
main:
    # Para pegar o input como string
    la a0, mask_string_scanf
    la a1, string
    jal scanf

    # No 4º caractere, sabemos qual é o valor do nosso interesse.
    la a2, string
    lb t0, 3(a2)


    # Fazendo verificações para o desvio do fluxo
    li t1, 114
    beq t0, t1, amarelo

    li t1, 108
    beq t0, t1, azul

    li t1, 100
    beq t0, t1, verde

    li t1, 109
    beq t0, t1, vermelho

    li t1, 97
    beq t0, t1, rosa
    

    amarelo:

        # Pegando valores dados na syscall 2104 e printando
        li  a7, 2104
        li  a0, 0
        ecall

        mv s4, a0

        # Em a0 temos o valor geral
        srli t0, a0, 20

        mv  a1, t0

        mv a0, s4

        slli t0, a0, 12
        srli t0, t0, 22

        mv a2, t0

        mv a0, s4
        slli t0, a0, 22
        srli t0, t0, 22

        mv a3, t0

        mv t5, a2
        mv t6, a3
        #mv a3, t0
        #la a0, mask_rot_x_z 
        #jal printf

        li a6, 1 # a6 é o contador de segundos

        mv a1, a6
        mv a2, t5
        mv a3, t6
        la a0, mask_res

        addi sp, sp, -4
        sw t0, 0(sp)
        addi sp, sp, -4
        sw t5, 0(sp)
        addi sp, sp, -4
        sw t6, 0(sp)
        addi sp, sp, -4
        sw a6, 0(sp)

        jal printf

        lw a6, 0(sp)
        addi sp, sp, 4
        lw t6, 0(sp)
        addi sp, sp, 4
        lw t5, 0(sp)
        addi sp, sp, 4
        lw t0, 0(sp)
        addi sp, sp, 4


        j exit
    azul:
        # Pegando valores dados na syscall 2104 e printando
        li  a7, 2104
        li  a0, 0
        ecall

        mv s4, a0

        # Em a0 temos o valor geral
        srli t0, a0, 20

        mv  a1, t0

        mv a0, s4

        slli t0, a0, 12
        srli t0, t0, 22

        mv a2, t0

        mv a0, s4
        slli t0, a0, 22
        srli t0, t0, 22

        mv a3, t0

        mv t5, a2
        mv t6, a3
        #mv a3, t0
        #la a0, mask_rot_x_z 
        #jal printf

        li a6, 1 # a6 é o contador de segundos

        mv a1, a6
        mv a2, t5
        mv a3, t6
        la a0, mask_res

        addi sp, sp, -4
        sw t0, 0(sp)
        addi sp, sp, -4
        sw t5, 0(sp)
        addi sp, sp, -4
        sw t6, 0(sp)
        addi sp, sp, -4
        sw a6, 0(sp)

        jal printf

        lw a6, 0(sp)
        addi sp, sp, 4
        lw t6, 0(sp)
        addi sp, sp, 4
        lw t5, 0(sp)
        addi sp, sp, 4
        lw t0, 0(sp)
        addi sp, sp, 4


        # Aqui eu faço o carro se movimentar
        move_azul_1:
            li a0, 1
            li a1, 27
            li a7, 2100
            ecall

        laco_azul_1:
            # Calculo a tripla_atual
            li  a7, 2104
            li  a0, 0
            ecall

            mv s1, a0

            # Diferenca das triplas anteriores
            sub s2, s1, s0

            # ultima_tripla = tripla_atual
            mv s0, s1

            addi sp, sp, -4
            sw s0, 0(sp)
            addi sp, sp, -4
            sw s1, 0(sp)
            addi sp, sp, -4
            sw s2, 0(sp)


            addi sp, sp, -4
            sw ra, 0(sp)
            addi sp, sp, -4
            sw t0, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)
            addi sp, sp, -4
            sw t6, 0(sp)
            addi sp, sp, -4
            sw a6, 0(sp)

            jal time_now

            lw a6, 0(sp)
            addi sp, sp, 4
            lw t6, 0(sp)
            addi sp, sp, 4
            lw t5, 0(sp)
            addi sp, sp, 4
            lw t0, 0(sp)
            addi sp, sp, 4
            lw ra, 0(sp)
            addi sp, sp, 4

            mv t0, a0

            #la a0, mask_int_t0
            #jal printf


            # Aqui eu printo os valores atuais até o carro parar.
            delay1:
                # delay
                addi sp, sp, -4
                sw ra, 0(sp)
                addi sp, sp, -4
                sw t0, 0(sp)
                addi sp, sp, -4
                sw t5, 0(sp)
                addi sp, sp, -4
                sw t6, 0(sp)
                addi sp, sp, -4
                sw a6, 0(sp)

                jal time_now

                mv t1, a0

                lw a6, 0(sp)
                addi sp, sp, 4
                lw t6, 0(sp)
                addi sp, sp, 4
                lw t5, 0(sp)
                addi sp, sp, 4
                lw t0, 0(sp)
                addi sp, sp, 4
                lw ra, 0(sp)
                addi sp, sp, 4

                #li t0, 50

                sub a0, t0, t1
                jal abs

                mv a3, a0
                mv t0, t1

                
                li t5, 1 # 1s é a mudança de tempo que eu desejo
                beq a3, t5, mudanca_tempo_azul_1

                j delay1

                mudanca_tempo_azul_1:
                    # contador de tempo
                    addi a6, a6, 1
                    
                    # Print dos valores
                    addi sp, sp, -4
                    sw a6, 0(sp)


                    li  a7, 2104
                    li  a0, 0
                    ecall

                    mv s4, a0

                    # Em a0 temos o valor geral
                    srli t0, a0, 20

                    mv  a1, t0

                    mv a0, s4

                    slli t0, a0, 12
                    srli t0, t0, 22

                    mv a2, t0

                    mv a0, s4
                    slli t0, a0, 22
                    srli t0, t0, 22

                    mv a3, t0

                    #addi sp, sp, -4
                    #sw a0, 0(sp)
                    #addi sp, sp, -4
                    #sw a1, 0(sp)

                    #mv a1, t0
                    #la a0, mask_int
                    #jal printf

                    #lw a1, 0(sp)
                    #addi sp, sp, 4
                    #lw a0, 0(sp)
                    #addi sp, sp, 4

                    mv t5, a2
                    mv t6, a3


                    mv a1, a6
                    mv a2, t5
                    mv a3, t6
                    la a0, mask_res

                    addi sp, sp, -4
                    sw t0, 0(sp)
                    addi sp, sp, -4
                    sw t5, 0(sp)
                    addi sp, sp, -4
                    sw t6, 0(sp)

                    jal printf

                    lw t6, 0(sp)
                    addi sp, sp, 4
                    lw t5, 0(sp)
                    addi sp, sp, 4
                    lw t0, 0(sp)
                    addi sp, sp, 4

                    lw a6, 0(sp)
                    addi sp, sp, 4

            # se aux != 0 => j laco_azul_
            verificacao_azul_1:

            lw s2, 0(sp)
            addi sp, sp, 4
            lw s1, 0(sp)
            addi sp, sp, 4
            lw s0, 0(sp)
            addi sp, sp, 4

            bne s2, zero, laco_azul_1


        exit_azul_1:

        gira_azul_2:
            li a0, 2
            li a1, 131
            li a7, 2100
            ecall

        # ATENÇÃO!!!!
        laco_azul_2:
            # Calculo a tripla_atual
            li  a7, 2104
            li  a0, 0
            ecall

            mv s1, a0

            # Diferenca das triplas anteriores
            sub s2, s1, s0

            # ultima_tripla = tripla_atual
            mv s0, s1

            addi sp, sp, -4
            sw s0, 0(sp)
            addi sp, sp, -4
            sw s1, 0(sp)
            addi sp, sp, -4
            sw s2, 0(sp)


            addi sp, sp, -4
            sw ra, 0(sp)
            addi sp, sp, -4
            sw t0, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)
            addi sp, sp, -4
            sw t6, 0(sp)
            addi sp, sp, -4
            sw a6, 0(sp)

            jal time_now

            lw a6, 0(sp)
            addi sp, sp, 4
            lw t6, 0(sp)
            addi sp, sp, 4
            lw t5, 0(sp)
            addi sp, sp, 4
            lw t0, 0(sp)
            addi sp, sp, 4
            lw ra, 0(sp)
            addi sp, sp, 4

            mv t0, a0

            #la a0, mask_int_t0
            #jal printf


            # Aqui eu printo os valores atuais até o carro parar.
            delay2:
                # delay
                addi sp, sp, -4
                sw ra, 0(sp)
                addi sp, sp, -4
                sw t0, 0(sp)
                addi sp, sp, -4
                sw t5, 0(sp)
                addi sp, sp, -4
                sw t6, 0(sp)
                addi sp, sp, -4
                sw a6, 0(sp)

                jal time_now

                mv t1, a0

                lw a6, 0(sp)
                addi sp, sp, 4
                lw t6, 0(sp)
                addi sp, sp, 4
                lw t5, 0(sp)
                addi sp, sp, 4
                lw t0, 0(sp)
                addi sp, sp, 4
                lw ra, 0(sp)
                addi sp, sp, 4

                #li t0, 50

                sub a0, t0, t1
                jal abs

                mv a3, a0
                mv t0, t1

                
                li t5, 1 # 1s é a mudança de tempo que eu desejo
                beq a3, t5, mudanca_tempo_azul_2

                j delay2

                mudanca_tempo_azul_2:
                    # Print dos valores
                    addi a6, a6, 1
                    
                    addi sp, sp, -4
                    sw a6, 0(sp)


                    li  a7, 2104
                    li  a0, 0
                    ecall

                    mv s4, a0

                    # Em a0 temos o valor geral
                    srli t0, a0, 20

                    mv  a1, t0

                    mv a0, s4

                    slli t0, a0, 12
                    srli t0, t0, 22

                    mv a2, t0

                    mv a0, s4
                    slli t0, a0, 22
                    srli t0, t0, 22

                    mv a3, t0

                    mv t5, a2
                    mv t6, a3


                    mv a1, a6
                    mv a2, t5
                    mv a3, t6
                    la a0, mask_res

                    addi sp, sp, -4
                    sw t0, 0(sp)
                    addi sp, sp, -4
                    sw t5, 0(sp)
                    addi sp, sp, -4
                    sw t6, 0(sp)

                    jal printf

                    lw t6, 0(sp)
                    addi sp, sp, 4
                    lw t5, 0(sp)
                    addi sp, sp, 4
                    lw t0, 0(sp)
                    addi sp, sp, 4

                    lw a6, 0(sp)
                    addi sp, sp, 4

            # se aux != 0 => j laco_azul_
            verificacao_azul_2:

            lw s2, 0(sp)
            addi sp, sp, 4
            lw s1, 0(sp)
            addi sp, sp, 4
            lw s0, 0(sp)
            addi sp, sp, 4

            bne s2, zero, laco_azul_2
        exit_azul_2:

        move_azul_3:
            li a0, 1
            li a1, 6
            li a7, 2100
            ecall

        # ATENÇÃO!!!!
        laco_azul_3:
            # Calculo a tripla_atual
            li  a7, 2104
            li  a0, 0
            ecall

            mv s1, a0

            # Diferenca das triplas anteriores
            sub s2, s1, s0

            # ultima_tripla = tripla_atual
            mv s0, s1

            addi sp, sp, -4
            sw s0, 0(sp)
            addi sp, sp, -4
            sw s1, 0(sp)
            addi sp, sp, -4
            sw s2, 0(sp)


            addi sp, sp, -4
            sw ra, 0(sp)
            addi sp, sp, -4
            sw t0, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)
            addi sp, sp, -4
            sw t6, 0(sp)
            addi sp, sp, -4
            sw a6, 0(sp)

            jal time_now

            lw a6, 0(sp)
            addi sp, sp, 4
            lw t6, 0(sp)
            addi sp, sp, 4
            lw t5, 0(sp)
            addi sp, sp, 4
            lw t0, 0(sp)
            addi sp, sp, 4
            lw ra, 0(sp)
            addi sp, sp, 4

            mv t0, a0

            #la a0, mask_int_t0
            #jal printf


            # Aqui eu printo os valores atuais até o carro parar.
            delay3:
                # delay
                addi sp, sp, -4
                sw ra, 0(sp)
                addi sp, sp, -4
                sw t0, 0(sp)
                addi sp, sp, -4
                sw t5, 0(sp)
                addi sp, sp, -4
                sw t6, 0(sp)
                addi sp, sp, -4
                sw a6, 0(sp)

                jal time_now

                mv t1, a0

                lw a6, 0(sp)
                addi sp, sp, 4
                lw t6, 0(sp)
                addi sp, sp, 4
                lw t5, 0(sp)
                addi sp, sp, 4
                lw t0, 0(sp)
                addi sp, sp, 4
                lw ra, 0(sp)
                addi sp, sp, 4

                #li t0, 50

                sub a0, t0, t1
                jal abs

                mv a3, a0
                mv t0, t1

                
                li t5, 1 # 1s é a mudança de tempo que eu desejo
                beq a3, t5, mudanca_tempo_azul_3

                j delay3

                mudanca_tempo_azul_3:
                    # Print dos valores
                    addi a6, a6, 1
                    
                    addi sp, sp, -4
                    sw a6, 0(sp)


                    li  a7, 2104
                    li  a0, 0
                    ecall

                    mv s4, a0

                    # Em a0 temos o valor geral
                    srli t0, a0, 20

                    mv  a1, t0

                    mv a0, s4

                    slli t0, a0, 12
                    srli t0, t0, 22

                    mv a2, t0

                    mv a0, s4
                    slli t0, a0, 22
                    srli t0, t0, 22

                    mv a3, t0

                    mv t5, a2
                    mv t6, a3


                    mv a1, a6
                    mv a2, t5
                    mv a3, t6
                    la a0, mask_res

                    addi sp, sp, -4
                    sw t0, 0(sp)
                    addi sp, sp, -4
                    sw t5, 0(sp)
                    addi sp, sp, -4
                    sw t6, 0(sp)

                    jal printf

                    lw t6, 0(sp)
                    addi sp, sp, 4
                    lw t5, 0(sp)
                    addi sp, sp, 4
                    lw t0, 0(sp)
                    addi sp, sp, 4

                    lw a6, 0(sp)
                    addi sp, sp, 4

            # se aux != 0 => j laco_azul_
            verificacao_azul_3:

            lw s2, 0(sp)
            addi sp, sp, 4
            lw s1, 0(sp)
            addi sp, sp, 4
            lw s0, 0(sp)
            addi sp, sp, 4

            bne s2, zero, laco_azul_3

        exit_azul_3:

        gira_azul_4:
            li a0, 2
            li a1, 90
            li a7, 2100
            ecall

        # ATENÇÃO!!!!
        laco_azul_4:
            # Calculo a tripla_atual
            li  a7, 2104
            li  a0, 0
            ecall

            mv s1, a0

            # Diferenca das triplas anteriores
            sub s2, s1, s0

            # ultima_tripla = tripla_atual
            mv s0, s1

            addi sp, sp, -4
            sw s0, 0(sp)
            addi sp, sp, -4
            sw s1, 0(sp)
            addi sp, sp, -4
            sw s2, 0(sp)


            addi sp, sp, -4
            sw ra, 0(sp)
            addi sp, sp, -4
            sw t0, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)
            addi sp, sp, -4
            sw t6, 0(sp)
            addi sp, sp, -4
            sw a6, 0(sp)

            jal time_now

            lw a6, 0(sp)
            addi sp, sp, 4
            lw t6, 0(sp)
            addi sp, sp, 4
            lw t5, 0(sp)
            addi sp, sp, 4
            lw t0, 0(sp)
            addi sp, sp, 4
            lw ra, 0(sp)
            addi sp, sp, 4

            mv t0, a0

            #la a0, mask_int_t0
            #jal printf


            # Aqui eu printo os valores atuais até o carro parar.
            delay4:
                # delay
                addi sp, sp, -4
                sw ra, 0(sp)
                addi sp, sp, -4
                sw t0, 0(sp)
                addi sp, sp, -4
                sw t5, 0(sp)
                addi sp, sp, -4
                sw t6, 0(sp)
                addi sp, sp, -4
                sw a6, 0(sp)

                jal time_now

                mv t1, a0

                lw a6, 0(sp)
                addi sp, sp, 4
                lw t6, 0(sp)
                addi sp, sp, 4
                lw t5, 0(sp)
                addi sp, sp, 4
                lw t0, 0(sp)
                addi sp, sp, 4
                lw ra, 0(sp)
                addi sp, sp, 4

                #li t0, 50

                sub a0, t0, t1
                jal abs

                mv a3, a0
                mv t0, t1

                
                li t5, 1 # 1s é a mudança de tempo que eu desejo
                beq a3, t5, mudanca_tempo_azul_4

                j delay4

                mudanca_tempo_azul_4:
                    # Print dos valores
                    addi a6, a6, 1
                    
                    addi sp, sp, -4
                    sw a6, 0(sp)


                    li  a7, 2104
                    li  a0, 0
                    ecall

                    mv s4, a0

                    # Em a0 temos o valor geral
                    srli t0, a0, 20

                    mv  a1, t0

                    mv a0, s4

                    slli t0, a0, 12
                    srli t0, t0, 22

                    mv a2, t0

                    mv a0, s4
                    slli t0, a0, 22
                    srli t0, t0, 22

                    mv a3, t0

                    mv t5, a2
                    mv t6, a3


                    mv a1, a6
                    mv a2, t5
                    mv a3, t6
                    la a0, mask_res

                    addi sp, sp, -4
                    sw t0, 0(sp)
                    addi sp, sp, -4
                    sw t5, 0(sp)
                    addi sp, sp, -4
                    sw t6, 0(sp)

                    jal printf

                    lw t6, 0(sp)
                    addi sp, sp, 4
                    lw t5, 0(sp)
                    addi sp, sp, 4
                    lw t0, 0(sp)
                    addi sp, sp, 4

                    lw a6, 0(sp)
                    addi sp, sp, 4

            # se aux != 0 => j laco_azul_
            verificacao_azul_4:

            lw s2, 0(sp)
            addi sp, sp, 4
            lw s1, 0(sp)
            addi sp, sp, 4
            lw s0, 0(sp)
            addi sp, sp, 4

            bne s2, zero, laco_azul_4
        exit_azul_4:

        move_azul_5:
            li a0, 1
            li a1, 19
            li a7, 2100
            ecall

        # ATENÇÃO!!!!
        laco_azul_5:
            # Calculo a tripla_atual
            li a7, 2104
            li a0, 0
            ecall

            mv s1, a0

            # Diferenca das triplas anteriores
            sub s2, s1, s0

            # ultima_tripla = tripla_atual
            mv s0, s1

            addi sp, sp, -4
            sw s0, 0(sp)
            addi sp, sp, -4
            sw s1, 0(sp)
            addi sp, sp, -4
            sw s2, 0(sp)


            addi sp, sp, -4
            sw ra, 0(sp)
            addi sp, sp, -4
            sw t0, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)
            addi sp, sp, -4
            sw t6, 0(sp)
            addi sp, sp, -4
            sw a6, 0(sp)

            jal time_now

            lw a6, 0(sp)
            addi sp, sp, 4
            lw t6, 0(sp)
            addi sp, sp, 4
            lw t5, 0(sp)
            addi sp, sp, 4
            lw t0, 0(sp)
            addi sp, sp, 4
            lw ra, 0(sp)
            addi sp, sp, 4

            mv t0, a0

            #la a0, mask_int_t0
            #jal printf


            # Aqui eu printo os valores atuais até o carro parar.
            delay5:
                # delay
                addi sp, sp, -4
                sw ra, 0(sp)
                addi sp, sp, -4
                sw t0, 0(sp)
                addi sp, sp, -4
                sw t5, 0(sp)
                addi sp, sp, -4
                sw t6, 0(sp)
                addi sp, sp, -4
                sw a6, 0(sp)

                jal time_now

                mv t1, a0

                lw a6, 0(sp)
                addi sp, sp, 4
                lw t6, 0(sp)
                addi sp, sp, 4
                lw t5, 0(sp)
                addi sp, sp, 4
                lw t0, 0(sp)
                addi sp, sp, 4
                lw ra, 0(sp)
                addi sp, sp, 4

                #li t0, 50

                sub a0, t0, t1
                jal abs

                mv a3, a0
                mv t0, t1

                
                li t5, 1 # 1s é a mudança de tempo que eu desejo
                beq a3, t5, mudanca_tempo_azul_5

                j delay5

                mudanca_tempo_azul_5:
                    # Print dos valores
                    addi a6, a6, 1
                    
                    addi sp, sp, -4
                    sw a6, 0(sp)


                    li  a7, 2104
                    li  a0, 0
                    ecall

                    mv s4, a0

                    # Em a0 temos o valor geral
                    srli t0, a0, 20

                    mv  a1, t0

                    mv a0, s4

                    slli t0, a0, 12
                    srli t0, t0, 22

                    mv a2, t0

                    mv a0, s4
                    slli t0, a0, 22
                    srli t0, t0, 22

                    mv a3, t0

                    mv t5, a2
                    mv t6, a3


                    mv a1, a6
                    mv a2, t5
                    mv a3, t6
                    la a0, mask_res

                    addi sp, sp, -4
                    sw t0, 0(sp)
                    addi sp, sp, -4
                    sw t5, 0(sp)
                    addi sp, sp, -4
                    sw t6, 0(sp)

                    jal printf

                    lw t6, 0(sp)
                    addi sp, sp, 4
                    lw t5, 0(sp)
                    addi sp, sp, 4
                    lw t0, 0(sp)
                    addi sp, sp, 4

                    lw a6, 0(sp)
                    addi sp, sp, 4

            # se aux != 0 => j laco_azul_
            verificacao_azul_5:

            lw s2, 0(sp)
            addi sp, sp, 4
            lw s1, 0(sp)
            addi sp, sp, 4
            lw s0, 0(sp)
            addi sp, sp, 4

            bne s2, zero, laco_azul_5

        exit_azul_5:
        j exit
    verde:
        # Pegando valores dados na syscall 2104 e printando
        li  a7, 2104
        li  a0, 0
        ecall

        mv s4, a0

        # Em a0 temos o valor geral
        srli t0, a0, 20

        mv  a1, t0

        mv a0, s4

        slli t0, a0, 12
        srli t0, t0, 22

        mv a2, t0

        mv a0, s4
        slli t0, a0, 22
        srli t0, t0, 22

        mv a3, t0

        mv t5, a2
        mv t6, a3
        #mv a3, t0
        #la a0, mask_rot_x_z 
        #jal printf

        li a6, 1 # a6 é o contador de segundos

        mv a1, a6
        mv a2, t5
        mv a3, t6
        la a0, mask_res

        addi sp, sp, -4
        sw t0, 0(sp)
        addi sp, sp, -4
        sw t5, 0(sp)
        addi sp, sp, -4
        sw t6, 0(sp)
        addi sp, sp, -4
        sw a6, 0(sp)

        jal printf

        lw a6, 0(sp)
        addi sp, sp, 4
        lw t6, 0(sp)
        addi sp, sp, 4
        lw t5, 0(sp)
        addi sp, sp, 4
        lw t0, 0(sp)
        addi sp, sp, 4



        j exit
    vermelho:
        # Pegando valores dados na syscall 2104 e printando
        li  a7, 2104
        li  a0, 0
        ecall

        mv s4, a0

        # Em a0 temos o valor geral
        srli t0, a0, 20

        mv  a1, t0

        mv a0, s4

        slli t0, a0, 12
        srli t0, t0, 22

        mv a2, t0

        mv a0, s4
        slli t0, a0, 22
        srli t0, t0, 22

        mv a3, t0

        mv t5, a2
        mv t6, a3
        #mv a3, t0
        #la a0, mask_rot_x_z 
        #jal printf

        li a6, 1 # a6 é o contador de segundos

        mv a1, a6
        mv a2, t5
        mv a3, t6
        la a0, mask_res

        addi sp, sp, -4
        sw t0, 0(sp)
        addi sp, sp, -4
        sw t5, 0(sp)
        addi sp, sp, -4
        sw t6, 0(sp)
        addi sp, sp, -4
        sw a6, 0(sp)

        jal printf

        lw a6, 0(sp)
        addi sp, sp, 4
        lw t6, 0(sp)
        addi sp, sp, 4
        lw t5, 0(sp)
        addi sp, sp, 4
        lw t0, 0(sp)
        addi sp, sp, 4



        j exit
    rosa:
        # Pegando valores dados na syscall 2104 e printando
        li  a7, 2104
        li  a0, 0
        ecall

        mv s4, a0

        # Em a0 temos o valor geral
        srli t0, a0, 20

        mv  a1, t0

        mv a0, s4

        slli t0, a0, 12
        srli t0, t0, 22

        mv a2, t0

        mv a0, s4
        slli t0, a0, 22
        srli t0, t0, 22

        mv a3, t0

        mv t5, a2
        mv t6, a3
        #mv a3, t0
        #la a0, mask_rot_x_z 
        #jal printf

        li a6, 1 # a6 é o contador de segundos

        mv a1, a6
        mv a2, t5
        mv a3, t6
        la a0, mask_res

        addi sp, sp, -4
        sw t0, 0(sp)
        addi sp, sp, -4
        sw t5, 0(sp)
        addi sp, sp, -4
        sw t6, 0(sp)
        addi sp, sp, -4
        sw a6, 0(sp)

        jal printf

        lw a6, 0(sp)
        addi sp, sp, 4
        lw t6, 0(sp)
        addi sp, sp, 4
        lw t5, 0(sp)
        addi sp, sp, 4
        lw t0, 0(sp)
        addi sp, sp, 4



    j exit 


    exit:

.data
.align 4

buffer_timeval: .skip 12
buffer_timerzone: .skip 12

string: .skip 32

mask_string_printf: .ascii "%s\n"
.skip 128

mask_string_scanf: .ascii "%s"
.skip 128

mask: .ascii "%x\n"
.skip 128

mask_int: .ascii "%i\n"
.skip 128

mask_rot_x_z: .ascii "%d %d %d\n"
.skip 128

mask_int_t0: .ascii "t0: %i\n"
.skip 128

mask_int_t1: .ascii "t1: %i\n"
.skip 128

mask_res: .ascii "[%i.0] (%i, %i)\n"
.skip 128
