mapa_s: mapa.c
	riscv32-unknown-elf-gcc -g mapa.c -S -o mapa.s

arquivos_objetos: mapa.s ra185137.s
	riscv32-unknown-elf-as -g mapa.s -o mapa.o
	riscv32-unknown-elf-as -g ra185137.s -o dfs.o

ligacao:
	riscv32-unknown-elf-ld -g mapa.o dfs.o -o program

construir: mapa.c ra185137.s
	make mapa_s
	make arquivos_objetos
	make ligacao

python: program bridge.py
	riscv32-unknown-elf-gdb program -ex 'target remote | python3 bridge.py'
