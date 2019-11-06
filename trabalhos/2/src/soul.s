

# Código baseado no Lab. 10 (como inspiração):

.align 4


#read_ultrasonic_sensor: # retorna o valor do sensor ou -1
	# 0xFFFF0020 <- 0
	# a0 <- 0xFFFF0024
	# ret

#set_servo_anglo: # entradas: id do motor(a0) e angulo(a1) , saida: -1->angulo invalido, 		 # -2-> id invalido, 0 cc
	# jumps de acordo com o valor a0
	# a0 = 1  
		# if a1 entre(16,116) 0xFFFF001E <- a1
		# else ret -1
	# a0 = 2  
		# if a1 entre(52,90)  0xFFFF001D <- a1
		# else ret -1
 	# a0 = 3  
		# if a1 entre(0,156)  0xFFFF001C <- a1
		# else ret -1
	
	# a0 != 1,2,3 ret -2

#set_engine_torque: # entradas: id do motor(a0) e torque(a1)
		   # saidas: id invalido-> -1, cc-> 0
	#jumps de acordo com o valor a0
	#a0=1	0xFFFF001A <- a1 , ret 0
	#a0=2 	0xFFFF0018 <- a1 , ret 0
	#a0 != 1,2 ret -1


.align 4

int_handler:
	# Salvar contexto

	###### Tratador de interrupÃ§Ãµes e syscalls ######

	li t0, 16
	beq a7, t0, read_ultrasonic_sensor

	li t0, 17
	beq a7, t0, set_servo_angles

	li t0, 18
	beq a7, t0, set_engine_torque

	li t0, 19
	beq a7, t0, read_gps

	li t0, 20
	beq a7, t0, read_gyroscope

	li t0, 21
	beq a7, t0, get_time

	li t0, 22
	beq a7, t0, set_time

	li t0, 64
	beq a7, t0, write

	j final

	# Parâmetros
	# Retorno
	# a0: Valor obtido na leitura do sensor; 
	# -1 caso nenhum objeto tenha sido detectado a menos 
	# de 600 centímetros.
	read_ultrasonic_sensor:
		# Atribuindo valor = 0 em 0xFFFF0020
		li t1, 0
		li t2, 0xFFFF0020
		sw t2, 0(t1)	

		# Esperando o valor de 0xFFFF0020 ser igual a 1
		volta:
			li t3, 1
			lw t4, 0(t2)
			beq t4, t3, sair_volta
			j volta
		sair_volta:

		# Valor a ser retornado
		li t1, 0xFFFF0024
		lw a0, 0(t1)

		j final

	# Parâmetros
	# a0: id do servo a ser modificado.
	# a1: ângulo para o servo. 
	# Retorno
	# a0: -1, caso o ângulo de um dos servos seja inválido
	# (neste caso, a operação toda deve ser cancelada e nenhum
	# ângulo definido). -2, caso o id do servo seja inválido.
	# Caso contrário, retorna 0. 
	set_servo_angles:
		li t1, 1
		li t2, 2
		li t3, 3


		beq a0, t1, servo1
		beq a0, t2, servo2
		beq a0, t3, servo3

		li a0, -2
		j final

		servo1:
			# 16 - 116
			li t1, 16
			li t2, 116

			li t3, 0xFFFF001E


			# <
			blt a1, t1, erro_servo
			blt t2, a1, erro_servo
			sw t3,0(a1)
			li a0, 0

			j final

		servo2:
			# 52 - 90
			li t1, 52
			li t2, 90

			li t3, 0xFFFF001D


			# <
			blt a1, t1, erro_servo
			blt t2, a1, erro_servo
			sw t3,0(a1)
			li a0, 0

			j final

		servo3:	
			# 0 - 156
			li t1, 0
			li t2, 156

			li t3, 0xFFFF001C


			# <
			blt a1, t1, erro_servo
			blt t2, a1, erro_servo
			sw t3,0(a1)
			li a0, 0

			j final

		erro_servo:
			li a0, -1


		j final
		

	
	# Parâmetros
	# a0: id do motor (0 ou 1)
	# a1: torque do motor. 
	# Retorno
	# a0: -1, caso o id do motor seja inválido. 
	# 0, caso contrário. A chamada de sistema não deve 
	# verificar a validade dos valores de torque. 
	set_engine_torque:
		li t1,1
		li t2,2
		beq a0,t1,engine1
		beq a0,t2,engine2
		li a0,-1
		j final
		engine1:
			li t1,0xFFFF001A
			sw t1,0(a1)
			l1 a0,0
			j final
		engine2:
			li t1,0xFFFF0018
			sw t1,0(a1)
			li a0,0
			j final
		j final

	# Parâmetros
	# a0: Endereço do registro (com três valores inteiros) 
	# para armazenar as coordenadas (x, y, z); 
	# Retorno
	# -
	read_gps:
		# x, y e z estao salvos em uma struct e sao armazenadas em enderecos consecutivos na memoria
		
		li t1,0xFFFF0004 
		li t2,0
		sw t1,0(t2)
		loop_gps:
			li t2,1
			lw t3,0(t1)
			beq t2,t3,cont_gps
			j loop_gps
		cont_gps:
			li t1,0xFFFF0008 # endereco do valor de X lido pelo gps
			li t2,0xFFFF000C # endereco do valor de Y lido pelo gps
			li t3,0xFFFF0010 # endereco do valor de Z lido pelo gps
			lw t1,0(t1) # X
			lw t2,0(t2) # Y
			lw t3 0(t3) # Z
			lw t4,0(a0)   # endereco onde X sera salvo
			addi t5,t4,4  # endereco onde Y sera salvo
			addi t6,t4,4  # endereco onde Z sera salvo
			sw t4,0(t1)
			sw t5,0(t2)
			sw t6,0(t3)
			j final

	# Parâmetros
	# a0: Endereço do registro (com três valores inteiros)
	# para armazenar os ângulos de Euler (x, y, z);
	# Retorno
	# -
	read_gyroscope:
		j final

	# Parâmetros
	# Retorno
	# a0: tempo do sistema, em milissegundos 	
	get_time:
		j final

	# Parâmetros
	# a0: tempo do sistema, em milissegundos 
	# Retorno
	# -
	set_time:
		j final

	# Parâmetros
	# a0: Descritor do arquivo
	# a1: Endereço de memória do buffer a ser escrito.
    # a2: Número de bytes a serem escritos. 
	# Retorno
	# a0: Número de bytes efetivamente escritos. 
	write:
		j final

	final:

  
	# <= Implemente o tratamento da sua syscall aqui 
  
	# Restaura contexto
	csrr t0, mepc  # carrega endereÃ§o de retorno (endereÃ§o da instruÃ§Ã£o que invocou a syscall)
	addi t0, t0, 4 # soma 4 no endereÃ§o de retorno (para retornar apÃ³s a ecall) 
 	csrw mepc, t0  # armazena endereÃ§o de retorno de volta no mepc
  	mret           # Recuperar o restante do contexto (pc <- mepc)
  


.globl _start
_start:
	# Configurando o Tratador de Interrupções:
  	la t0, int_handler  # Carregar o endereÃ§o da rotina que tratarÃ¡ as interrupÃ§Ãµes
  	csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar o
                      # vetor de interrupÃ§Ãµes.

	# Habilita Interrupções Global
	csrr t1, mstatus # Seta o bit 7 (MPIE)
	ori t1, t1, 0x80 # do registrador mie
	csrw mstatus, t1

	# Habilita Interrupções Externas
	csrr t1, mie # Seta o bit 11 (MEIE)
	li t2, 0x800 # do registrador mie
	or t1, t1, t2
	csrw mie, t1

	# Ajusta o mscratch
	la t1, reg_buffer # Coloca o endereço do buffer para salvar
	csrw mscratch, t1 # registradores em mscratch

	# Muda para o Modo de usuário
	csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
	li t2, ~0x1800   # do registrador mstatus
	and t1, t1, t2   # com o valor 00
	csrw mstatus, t1

	# PERGUNTAR:
	# la t0, user   # Grava o endereço do rótulo user
	# csrw mepc, t0 # no registrador mepc

	mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP


	# AQUI PODEMOS BRINCAR COM AS SYSCALLS:
  
  	# ecall               # Exemplo de chamada de sistema

  	# ...

loop_infinito: 
  	j loop_infinito
