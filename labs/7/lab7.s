.globl _start
# Função para obtenção do tempo atual. ao <= tempo atual
time_now:
  la a0, buffer_timeval
  la a1, buffer_timerzone
  li a7, 169 # chamada de sistema gettimeofday
  ecall
  la a0, buffer_timeval
  lw t1, 0(a0) # tempo em segundos
  lw t2, 8(a0) # fração do tempo em microssegundos
  li t3, 1000
  mul t1, t1, t3
  div t2, t2, t3
  add a0, t2, t1
  ret

# Função para tocar o canal a0 canal do sintetizador
play_channel:
  slli a1, a0, 2     # canal = canal*4 // calcula posicao do canal no vetor C
  add a7, s8, a1     # soma deslocamento na matriz M 
  add a4, s4, a1     # soma deslocamento no vetor P
  add a5, s5, a1     # soma deslocamento no vetor P2
  add a3, s3, a1     # soma deslocamento no vetor C
  lw t1, 0(a7)       # lê matriz
  srli t2, t1, 16    # t2 = frequencia||velocidade
  beq t2, zero, end  # se zero, não tocar nada
  lw t3, 0(a4)       # t3 = (frequencia||velocidade) tocadas por último
  bne t2, t3, tocar; # se diferente, trocou a nota, então deve tocar
  lw t3, 0(a5)       # Tempo de termino do que está tocando
  ble s7, t3, end;   # Se ainda não parou de tocar anterior, não deve tocar novamente
  tocar:
    sw t2, 0(a4)     # Atualiza (frequencia||velocidade) em P
    and t2, t1, s6   # t2 = delay
    add t2, t2, s7   # Calcula até quando ir tocar
    sw t2, 0(a5)     # Armazena no vetor P2
    mv a2, a0        # Define o Canal
    lw a0, 0(a3)     # Carrega instrumento do canal
    mv a1, t1        # move (frequencia||velocidade||delay) para a1
    li a7, 2048      # chamada de sistema
    ecall
  end:
    ret

# Função para tocar todos os canais do sintetizador
play_all_channels:
  li a0, 15
  mv s10, ra
  while_channels: 
    mv s9, a0
    jal play_channel
    add a0, s9, -1
    bge a0, zero, while_channels
  mv ra, s10
  ret

.text
_start:
############  Implemente o Parser aqui  #############



############        Fim do Parser       #############

play:
  jal time_now 
  mv s1, a0 # s1 recebe o tempo atual em ms
  la s2, M
  la s3, C
  la s4, P
  la s5, P2
  li s6, 0xffff
while_1:
  jal time_now        # a0 recebe o tempo atual em ms
  sub s7, a0, s1      # s7 recebe o tempo desde o início da função
  slli a1, s7, 6      # a1 = a1*64 // calculo do deslocamento para linha
  add s8, s2, a1      #s8 = &M + a1 // endereço da linha a ser processada
  jal play_all_channels
j while_1

.data 
.align 4
buffer_timeval: .skip 12
buffer_timerzone: .skip 12
P:  .skip 64
P2: .skip 64
C:  .skip 64
.comm	M,19200000,4 # Reserva um espaço de memória com 19.2MB iniciado no endereço marcalo pelo rótulo M
