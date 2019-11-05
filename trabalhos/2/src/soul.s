

# Código baseado no Lab. 10 (como inspiração):

.align 4

int_handler:
  ###### Tratador de interrupÃ§Ãµes e syscalls ######
  
  # <= Implemente o tratamento da sua syscall aqui 
  
  csrr t0, mepc  # carrega endereÃ§o de retorno (endereÃ§o da instruÃ§Ã£o que invocou a syscall)
  addi t0, t0, 4 # soma 4 no endereÃ§o de retorno (para retornar apÃ³s a ecall) 
  csrw mepc, t0  # armazena endereÃ§o de retorno de volta no mepc
  mret           # Recuperar o restante do contexto (pc <- mepc)
  


.globl _start
_start:

  la t0, int_handler  # Carregar o endereÃ§o da rotina que tratarÃ¡ as interrupÃ§Ãµes
  csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar o
                      # vetor de interrupÃ§Ãµes.
  
  # ... 
  
  ecall               # Exemplo de chamada de sistema

  # ...

loop_infinito: 
  j loop_infinito
  
