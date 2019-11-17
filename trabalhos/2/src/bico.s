.globl set_torque
.globl set_engine_torque
.globl set_head_servo
.globl get_us_distance
.globl get_current_GPS_position
.globl get_gyro_angles
.globl get_time
.globl set_time
.globl puts

# Parâmetros
# a0: valor do torque do motor 1
# a1: valor do torque do motor 2
# Retorno
# a0: -1 se estiver fora do intervalo [-100, 100]
# a0: 0 se estiver ok!
set_torque:
    # Chamar syscall 18 para motor 1; a0 = 0; a1 h a0
    li t2,-1
    mv t0,a0
    mv t1,a1
    li a0,0
    mv a1,t0
    
    # empilha os regs
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw ra, 12(sp)
    
    jal set_engine_torque
    
    #desempilha os regs
    lw ra, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16
    
    beq t2,a0,erro_torque
    li a0,1
    mv a1,t1
    
     # empilha os regs
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw ra, 12(sp)

    jal set_engine_torque

     #desempilha os regs
    lw ra, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16
    
    beq t2,a0,erro_torque
    ret
    erro_torque:
    li a0,-1
    ret


# Parâmetros
# a0: id do motor (0 ou 1)
# a1: torque
# Retorno
# a0: -1 se estiver fora do intervalo
# a0: -2 se id for invalido
# a0: 0 se estiver ok
set_engine_torque:
    # Verificar o range
    li t0, -100
    li t1, 100

    blt a1, t0, fora_range
    blt t1, a1, fora_range

    dentro_range:
        li a7, 18
        ecall

        bne a0, zero, id_invalido # Se a0 != 0, então o id é inválido!

        ret

    fora_range:
        li a0, -1
        ret

    id_invalido:
        li a0, -2
        ret


set_head_servo:
    li a7, 17
    ecall
    # inverter as saidas de erros -1 e -2
    li t1,-1
    li t2,-2
    beq a0,t1,inverte_1
    beq a0,t2,inverte_2
    j retorno
    inverte_1:
    li a0,-2
    j retorno
    inverte_2:
    li a0,-1
    j retorno

    retorno:
    ret


get_us_distance:
    li a7, 16
    ecall
    ret

get_current_GPS_position:
    li a7, 19
    ecall
    ret

get_gyro_angles:
    li a7, 20
    ecall
    ret

get_time:
    li a7,21
    ecall
    ret

set_time:
    li a7,22
    ecall
    ret

puts:
    # aqui temos que definir o tamanho da string e salvar em a2
    li a7, 64
    mv a1, a0 # a1 = enredeco 
    mv t0, a0
    li a0, 1 # output 
    li t1, 0
    loop_string:
        # ler os bytes ate achar o \0
        add t0, t0, t1
        lb t2, 0(t0) 
        addi t1, t1, 1
        # checar se t1 encosta no tamanho maximo
        bne t2, zero, loop_string
    mv a2,t1
    ecall

    ret
