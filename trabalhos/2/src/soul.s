

# Código baseado no Lab. 10 (como inspiração):

.align 4


read_ultrasonic_sensor: # retorna o valor do sensor ou -1
	# 0xFFFF0020 <- 0
	# a0 <- 0xFFFF0024
	# ret

set_servo_anglo: # entradas: id do motor(a0) e angulo(a1) , saida: -1->angulo invalido, 		 # -2-> id invalido, 0 cc
	# jumps de acordo com o valor a0
	# a0 = 1  
		# if a1 entre(16,116) 0xFFFF001E <- a1
		# else ret -2
	# a0 = 2  
		# if a1 entre(52,90)  0xFFFF001D <- a1
		# else ret -2
 	# a0 = 3  
		# if a1 entre(0,156)  0xFFFF001C <- a1
		# else ret -2
	
	# a0 != 1,2,3 ret -1

set_engine_torque: # entradas: id do motor(a0) e torque(a1)
		   # saidas: id invalido-> -1, cc-> 0
	#jumps de acordo com o valor a0
	#a0=1	0xFFFF001A <- a1 , ret 0
	#a0=2 	0xFFFF0018 <- a1 , ret 0
	#a0 != 1,2 ret -1


int_handler:
  ###### Tratador de interrupcoes e syscalls ######
  
  # <= Implemente o tratamento da sua syscall aqui 
  
  csrr t0, mepc  # carrega endereco de retorno (endereco da instrucao que invocou a syscall)
  addi t0, t0, 4 # soma 4 no endereco de retorno (para retornar aas a ecall) 
  csrw mepc, t0  # armazena endereco de retorno de volta no mepc
  mret           # Recuperar o restante do contexto (pc <- mepc)
  


.globl _start
_start:

  la t0, int_handler  # Carregar o endereco da rotina que tratara as interrupcoes
  csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar o
                      # vetor de interrupcoes.
  
  # ... 
  
  ecall               # Exemplo de chamada de sistema

  # ...

loop_infinito: 
  j loop_infinito
  
