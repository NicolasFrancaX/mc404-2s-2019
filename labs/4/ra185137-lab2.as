.org 0x000 # O código começa aqui
LOAD M(0x105) # Puxando entrada x
STOR M(x) # Jogando o valor vindo de 0x105 para x
LOAD MQ, M(x) # Pegando o valor de x
MUL M(g) # E multiplicando pela gravidade
LOAD MQ # Jogando de MQ para AC
STOR M(m) # m = x*g
LOAD M(m)
RSH # m/2
STOR M(k) # k = m/2
repeticao:
    # Aqui basicamente preciso começar a iteração do k' até passar por 10x
    LOAD M(m)

    # a = m/k
    DIV M(k)
    LOAD MQ
    STOR M(a)

    # b = k+a
    LOAD M(k)
    ADD M(a)
    STOR M(b)

    # c = b/2
    LOAD M(b)
    RSH
    STOR M(c)

    # k = c
    LOAD M(c)
    STOR M(k)

    # Aqui basicamente faz com que o loop execute 10 vezes
    LOAD M(i)
    SUB M(um)
    STOR M(i)
    JUMP+ M(repeticao)
LOAD M(c)
JUMP M(saida)


# Aqui vai ter meu mapa de memória inicial
.org 0x060
g: .word 0x000000000A
v: .word 0x0000000000
m: .word 0x0000000000
m_2: .word 0x0000000000
sqrt: .word 0x0000000000
i: .word 0x0000000009 # i começa com 9
um: .word 0x0000000001
x: .word 0x0000000000
a: .word 0x0000000000 # a = m/k
b: .word 0x0000000000 # b = k + a
c: .word 0x0000000000 # c = b/2
k: .word 0x0000000000 # k

.org 0x400
saida: