.global set_torque
.global set_engine_torque
.global set_head_servo
.global get_us_distance
.global get_current_GPS_position
.global get_gyro_angles
.global get_time
.global set_time
.global puts

# Parâmetros
# a0: valor do torque do motor 1
# a1: valor do torque do motor 2
# Retorno
# a0: -1 se estiver fora do intervalo [-100, 100]
# a0: 0 se estiver ok!
set_torque:
    # Chamar syscall 18 para motor 1; a0 = 0; a1 = a0


    # Chamar syscall 18 para motor 2; a0 = 1; a1 = a1

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
    ret

get_us_distance:
    ret

get_current_GPS_position:
    ret

get_gyro_angles:
    ret

get_time:
    ret

set_time:
    ret

puts:
    ret