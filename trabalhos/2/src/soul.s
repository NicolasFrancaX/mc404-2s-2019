# Código baseado no Lab. 10 (como inspiração):

.align 4

int_handler:
	# salvar contexto
	csrrw a2, mscratch, a2
	sw a1, 0(a2)
	sw a3, 4(a2)
	sw a4, 8(a2)
	sw a5, 12(a2)
	sw a6, 16(a2)
	sw a7, 20(a2)
	sw t0, 24(a2)
	sw t1, 28(a2)
	sw t2, 32(a2)
	sw t3, 36(a2)
	sw t4, 40(a2)
	sw t5, 44(a2)
	sw t6, 48(a2)
	sw ra, 52(a2)
	
	# decodifica a causa da interrupção
	
	csrr a6, mcause # lê a causa da exceção e trata de
					# acordo com a causa

	# Desvio de fluxo

	bge a6, zero, handler_syscalls
	j handler_interrupcoes

	###### Tratador de interrupcoes ######

	handler_interrupcoes:
		# Aqui vamos configurar o gpt

		li t0, 0xFFFF0100
		li t1, 0xFFFF0104
		li t2, 1
		li t3, 100

		lw t4, 0(t0)
		lw t5, 0(t1)


		beq t5, zero, saida_interrupcoes

		#beq t4, t2, tratador_gpt
		#j saida_interrupcoes

		tratador_gpt:
			sw zero, 0(t1)

			#sw t2, 0(t1) # M[0xFFFF0104] = 1

			# adicionar 100 no count_time
			la t6, count_time
			lw a1, 0(t6)
			addi a1, a1, 100
			sw a1, 0(t6)

			# colocar 100 no t0 (sw t3, 0(t0))
			sw t3, 0(t0)

			# Significa que a interrupcao foi tratada
			

		saida_interrupcoes:
			lw ra, 52(a2)
			lw t6, 48(a2)
			lw t5, 44(a2)
			lw t4, 40(a2)
			lw t3, 36(a2)
			lw t2, 32(a2)
			lw t1, 28(a2)
			lw t0, 24(a2)
			lw a7, 20(a2)
			lw a6, 26(a2)
			lw a5, 12(a2)
			lw a4, 8(a2)
			lw a3, 4(a2)
			lw a1, 0(a2)
			csrrw a2, mscratch, a2
		mret

	# ATENÇÃO: DEPOIS DO TRATAMENTO DE SYSCALLS, 
	# ATUALIZAR PC = PC+4...
	handler_syscalls:
		# Salva o contexto!


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
				sb a1,0(t3)
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
				sb a1,0(t3)
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
				sb a1,0(t3)
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
			li t1,0
			li t2,1
			beq a0,t1,engine1
			beq a0,t2,engine2
			li a0,-1
			j final
			engine1:
				li t1,0xFFFF001A
				sw a1,0(t1)
				li a0,0
				j final
			engine2:
				li t1,0xFFFF0018
				sw a1,0(t1)
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
			li t4,0
			loop_gps:
				li t2,1
				lw t3,0(t1)
				beq t2,t3,cont_gps
				j loop_gps
			cont_gps:
				li t1,0xFFFF0008 # endereco do valor de X lido pelo gps
				li t2,0xFFFF000C # endereco do valor de Y lido pelo gps
				li t3,0xFFFF0010 # endereco do valor de Z lido pelo gps
				mv t4,a0
				addi t5,t4,4
				addi t6,t4,8
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
			li t1,0
			li t2,0xFFFF0004
			sw t2,0(t1)
			loop_gyro:
				li t1,1
				lw t3,0(t2)
				beq t1,t3,cont_gyro
				j loop_gyro
			cont_gyro:
				li t1,0xFFFF0014
				lw t1,0(t1)
				mv t2,t1
				mv t3,t1

				# X
				srli t1,t1,20
				# Y 
				slli t2,t2,12 
				srli t2,t2,22
				# Z
				slli t3,t3,22
				srli t3,t3,22
				# Vector3
				mv t4,a0
				addi t5,t4,4
				addi t6,t4,8
				sw t4,0(t1)
				sw t5,0(t2)
				sw t6,0(t3)

			j final

		# Parâmetros
		# Retorno
		# a0: tempo do sistema, em milissegundos 	
		get_time:
			la t0, count_time
			lw a0, 0(t0)
			j final

		# Parâmetros
		# a0: tempo do sistema, em milissegundos 
		# Retorno
		# -
		set_time:
			la t0, count_time
			sw a0, 0(t0)
			j final

		# Parâmetros
		# a0: Descritor do arquivo
		# a1: Endereço de memória do buffer a ser escrito.
		# a2: Número de bytes a serem escritos. 
		# Retorno
		# a0: Número de bytes efetivamente escritos. 
		write:
			# Se a0 = 0, POR ENQUANTO sair!
			li t1,1
			bne a0, t1, nao_deveria_ser_stdin

			# a0 = 1 => stdout

			# 0xFFFF0108
			# Quando atribuído valor 1, a UART inicia a transmissão do valor armazenado em 0xFFFF0109.
			# Quando a transmissão terminar e a UART estiver pronta para iniciar a transmissão de um novo byte, o valor 0 é atribuído ao registrador. 

			# 0xFFFF0109
			# Valor a ser transmitido pela UART. 

			# t0 := base do endereco
			# t1 := contador

			li t1, 0 

			li t5, 0
			
			addi t5, a2, 0

			li t2, 0xFFFF0109

			loop:
				beq t1, a2, sair_loop

				# Queremos o caracter
				add t5,t5,t1
				mv t4, t5

				sb t2, 0(t4)

				loop2: 
					# UART
					li t3, 0xFFFF0108
					lb t3, 0(t3)

					beq t3, zero, loop2 # Se t3 = 0, sai da transmissao

				addi t1, t1, 1 # contador++
				j loop

			sair_loop:

			mv a0, t1

			j final

			# Se a0 = 0
			nao_deveria_ser_stdin:
				li a0, -1

			j final

		final:
			# Restaura contexto
			lw ra, 52(a2)
			lw t6, 48(a2)
			lw t5, 44(a2)
			lw t4, 40(a2)
			lw t3, 36(a2)
			lw t2, 32(a2)
			lw t1, 28(a2)
			lw t0, 24(a2)
			lw a7, 20(a2)
			lw a6, 16(a2)
			lw a5, 12(a2)
			lw a4, 8(a2)
			lw a3, 4(a2)
			lw a1, 0(a2)
			csrrw a2, mscratch, a2


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

	# Pilha do usuário
	la sp, pilha_usuario

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
	la t6, reg_buffer # Coloca o endereço do buffer para salvar
	csrw mscratch, t6 # registradores em mscratch


	# Muda para o Modo de usuário
	csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
	li t2, ~0x1800   # do registrador mstatus
	and t1, t1, t2   # com o valor 00
	csrw mstatus, t1

	# PERGUNTAR:
	la t0, main   # Grava o endereço do rótulo user
	csrw mepc, t0 # no registrador mepc
	# Configurar o GPT para gerar interrupção após 100 ms; <-
	li t0,0xFFFF0100
	li t1,100 # t = 100 ms
	#sw t1,0(t0) # aqui liga/desliga GTP comentando


	# Configurar o torque dos dois motores para zero;
	li t1,0
	li t2,0xFFFF001A
	sw t1,0(t2)
	li t2,0xFFFF0018
	sw t1,0(t2)
	# Configurar as articulações da cabeça do Uóli para a posição natural (Base = 31, Mid = 80, Top = 78);
	li t0,31
	li t1,80
	li t2,78
	li t3,0xFFFF001C # motor 3 - cabeca
	li t4,0xFFFF001D # motor 2 - pesoco
	li t5,0xFFFF001E # motor 1 - base
	sw t0,0(t5)
	sw t1,0(t4)
	sw t2,0(t3)

	mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP


	# ATENÇÃO:
    # Configurar o GPT para gerar interrupção após 1100 ms;
    # Configurar o torque dos dois motores para zero; <- por syscall
    # Configurar as articulações da cabeça do Uóli para a posição natural (Base = 31, Mid = 80, Top = 78); <- por syscall


	# AQUI PODEMOS BRINCAR COM AS SYSCALLS:

  	# ecall               # Exemplo de chamada de sistema

  	# ...

loop_infinito: 
  	j loop_infinito

.data 
count_time: .word 0
reg_buffer: .skip 1000
final_pilha:

.comm pilha,30000000,4
pilha_usuario:
