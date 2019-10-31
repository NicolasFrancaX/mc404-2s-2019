
dfs:
    addi sp, sp, -4
    sw a0, 0(sp)
    addi sp, sp, -4
    sw a1, 0(sp)
    addi sp, sp, -4
    sw a2, 0(sp)
    addi sp, sp, -4
    sw a3, 0(sp)

    addi a0, a2, 0
    addi a1, a3, 0

    # Depois daqui, caso o a0 != 0, então pula pra vizinho2
    jal foiVisitado
    bne a0, zero, exit0

    lw a3, 0(sp)
    addi sp, sp, 4
    lw a2, 0(sp)
    addi sp, sp, 4
    lw a1, 0(sp)
    addi sp, sp, 4
    lw a0, 0(sp)
    addi sp, sp, 4

    addi sp, sp, -4
    sw a0, 0(sp)
    addi sp, sp, -4
    sw a1, 0(sp)
    addi sp, sp, -4
    sw a2, 0(sp)
    addi sp, sp, -4
    sw a3, 0(sp)

    pre_processamento_print:
        la t0, saida_x
        addi a0, a0, 48
        sw a0, 0(t0)
        la t1, saida_y
        addi a1, a1, 48
        sw a1, 0(t1)
    escreve_linha:
        li a0, 1
        la a1, saida_x
        li a2, 1
        li a7, 64
        ecall
        li a0, 1
        la a1, espaco
        li a2, 1
        li a7, 64
        ecall
        li a0, 1
        la a1, saida_y
        li a2, 1
        li a7, 64
        ecall
        li a0, 1
        la a1, nova_linha
        li a2, 1
        li a7, 64
        ecall

    lw a3, 0(sp)
    addi sp, sp, 4
    lw a2, 0(sp)
    addi sp, sp, 4
    lw a1, 0(sp)
    addi sp, sp, 4
    lw a0, 0(sp)
    addi sp, sp, 4

    addi sp, sp, -4
    sw a0, 0(sp)
    addi sp, sp, -4
    sw a1, 0(sp)
    addi sp, sp, -4
    sw a2, 0(sp)
    addi sp, sp, -4
    sw a3, 0(sp)
    addi sp, sp, -4
    sw ra, 0(sp)
    
    jal visitaCelula

    lw ra, 0(sp)
    addi sp, sp, 4
    lw a3, 0(sp)
    addi sp, sp, 4
    lw a2, 0(sp)
    addi sp, sp, 4
    lw a1, 0(sp)
    addi sp, sp, 4
    lw a0, 0(sp)
    addi sp, sp, 4

    # Quando o a0, a1 com os parâmetros de meu interesse vem pra cá,
    # podemos perceber que eles são logo substituidos pelos valores que foram trazidos
    # das chamadas de função posicaoXRobinson

    # O caso é, eu devo colocar esses posicaoXRobinson de toda forma. Mas aonde?
    # E como eu faço pra ATUALIZAR a posicaoXRobinson/posicaoYRobinson?
    # Ou só usamos esse valor uma vez durante a chamada e devemos ficar
    # espertos com a posição atual dele pela mudança dos registradores?

    # Fixando 0 nessa linha em t0-t3
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0

    addi t0, a0, 0
    addi t1, a1, 0

    sub t2, t0, a2
    sub t3, t1, a3

    # O a0 e o a1 continuam o mesmo aqui... Podemos salva-los na pilha.


    # Se o valor de a2-a3 passados como parâmetro da função
    # foiVisitado retornar verdadeiro, então entramos no exit0 automaticamente

    addi sp, sp, -4
    sw a0, 0(sp)
    addi sp, sp, -4
    sw a1, 0(sp)

    


    # ...

    # If c is the goal
    bne t2, zero, else_goal
    bne t3, zero, else_goal
    if_goal:
        j exit0

    # Else
    else_goal:
        # Foreach neighbor n of c

        # Empilhando o a0-a1 fora do vizinho.
        addi sp, sp, -4
        sw a0, 0(sp)
        addi sp, sp, -4
        sw a1, 0(sp)

        vizinho1:
            # Quando eu fizer chamadas de FUNÇÕES, meus t4-t5 serão sobreescritos, por isso deve ser melhor eu
            # ir pegando o a0-a1 da pilha e depois jogando neles.

            # ATENÇÃO: O segredo aqui é salvar os a0-a1 na pilha, depois jogar em t4-t5 e ir utilizando
            # depois que acabar esse processamento, puxar o a0-a1 da pilha e continuar o processo com os outros vizinhos.

            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, 0
            addi a1, t5, -1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, vizinho2

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, 0
            addi a1, t5, -1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            beq a0, zero, vizinho2

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, 0
            addi a1, t5, -1

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

        vizinho2: # -1 1
            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, -1
            addi a1, t5, 0

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, vizinho3

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, -1
            addi a1, t5, 0

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            beq a0, zero, vizinho3
            
            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, -1
            addi a1, t5, 0

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

        vizinho3: # 0 1
            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, 0
            addi a1, t5, 1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, vizinho4

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, 0
            addi a1, t5, 1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)
            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            beq a0, zero, vizinho4

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, 0
            addi a1, t5, 1

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

        vizinho4: # 1 1
            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, 1
            addi a1, t5, 1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, vizinho5

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, 1
            addi a1, t5, 1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            beq a0, zero, vizinho5

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, 1
            addi a1, t5, 1

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

        vizinho5: # -1 0
            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, -1
            addi a1, t5, 1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, vizinho6

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4


            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, -1
            addi a1, t5, 1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            beq a0, zero, vizinho6

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, -1
            addi a1, t5, 1

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

        vizinho6: # 1 -1
            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, 1
            addi a1, t5, -1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, vizinho7

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, 1
            addi a1, t5, -1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)
            
            beq a0, zero, vizinho7

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, 1
            addi a1, t5, -1

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

        vizinho7: # 0 -1
            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, 1
            addi a1, t5, 0

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, vizinho8

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4


            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, 1
            addi a1, t5, 0

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            beq a0, zero, vizinho8

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, 1
            addi a1, t5, 0

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

        vizinho8: # -1 -1
            # Desempilha a1-a0 e coloca em t5-t4
            lw a1, 0(sp)
            addi sp, sp, 4
            lw a0, 0(sp)
            addi sp, sp, 4

            # t4-t5 <- a0-a1.
            addi t4, a0, 0
            addi t5, a1, 0

            # Os novos valores de a0 e a1 que serão passados para dfs.
            addi a0, t4, -1
            addi a1, t5, -1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Depois daqui, caso o a0 != 0, então pula pra vizinho2
            jal foiVisitado

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            bne a0, zero, sem_vizinho

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui vamos reaproveitar os registradores temporários que usamos
            addi a0, t4, -1
            addi a1, t5, -1

            addi sp, sp, -4
            sw a2, 0(sp)
            addi sp, sp, -4
            sw a3, 0(sp)

            # Aqui dá pra eu fazer a verificação se daParaPassar()
            # Depois eu verifico se o a0 == 0, se for, então vai pra vizinho2
            jal daParaPassar

            lw a3, 0(sp)
            addi sp, sp, 4
            lw a2, 0(sp)
            addi sp, sp, 4

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)

            beq a0, zero, sem_vizinho

            lw t5, 0(sp)
            addi sp, sp, 4
            lw t4, 0(sp)
            addi sp, sp, 4

            # Aqui eu devo colocar em a0-a1 os valores que eu quero que sejam passados na função
            addi a0, t4, -1
            addi a1, t5, -1

            addi sp, sp, -4
            sw ra, 0(sp)

            jal dfs

            lw ra, 0(sp)
            addi sp, sp, 4

            # Empilha t4-t5 pra depois pegar como a0-a1.

            addi sp, sp, -4
            sw t4, 0(sp)
            addi sp, sp, -4
            sw t5, 0(sp)
    sem_vizinho:
        lw a1, 0(sp)
        addi sp, sp, 4
        lw a0, 0(sp)
        addi sp, sp, 4

    exit0:
    ret

.global ajudaORobinson
ajudaORobinson:
    jal inicializaVisitados

    jal posicaoXRobinson
    addi t1, a0, 0

    jal posicaoYRobinson
    addi t2, a0, 0

    jal posicaoXLocal
    addi t3, a0, 0
    jal posicaoYLocal
    addi t4, a0, 0

    addi a0, t3, 0
    addi a1, t4, 0
    addi a2, t1, 0
    addi a3, t2, 0

    addi sp, sp, -4
    sw ra, 0(sp)

    jal dfs

    lw ra, 0(sp)
    addi sp, sp, 4

    ret


.data 
.align 4

saida_x: .skip 4
saida_y: .skip 4
espaco: .word 32
nova_linha: .word 10

