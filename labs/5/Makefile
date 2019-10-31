montagem: ra185137.s
	export PATH=$PATH:/opt/riscv/bin 
	riscv32-unknown-elf-as -g ra185137.s -o resultado.o
ligador: resultado.o
	riscv32-unknown-elf-ld -g resultado.o -o saida_ligador

montagem1: teste.s
	export PATH=$PATH:/opt/riscv/bin 
	riscv32-unknown-elf-as -g teste.s -o resul.o
ligador1: resul.o
	riscv32-unknown-elf-ld -g resul.o -o saida_ligador
