
construir: lab9.s
	riscv32-unknown-elf-gcc -g lab9.s -o lab9
python: program bridge.py
	riscv32-unknown-elf-gdb lab9 -ex 'target remote | python3 bridge.py'
