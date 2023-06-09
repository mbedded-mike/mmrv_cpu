BASE=riscv32-elf
AS=${BASE}-as
OBJCOPY=${BASE}-objcopy
AS_FLAGS=-march=rv32i -mlittle-endian
OBJCOPY_FLAGS=-O binary

all: testprog

testprog:
	${AS} ${AS_FLAGS} testprog.s -o build/testprog.elf
	${OBJCOPY} ${OBJCOPY_FLAGS} build/testprog.elf build/testprog.bin

clean: 
	rm build/*.elf
	rm build/*.bin
