#!/bin/bash -ex

. ./env

rm -rf ${TARGET_DIR}
mkdir -p ${TARGET_DIR}

arm-none-eabi-as -mcpu=arm926ej-s -g ${SRC_DIR}/startup.s -o ${TARGET_DIR}/startup.o
arm-none-eabi-gcc -c -mcpu=arm926ej-s -g ${SRC_DIR}/test.c -o ${TARGET_DIR}/test.o
$(
	cd ${TARGET_DIR} &&
	arm-none-eabi-ld -T ${SRC_DIR}/test.ld ./test.o ./startup.o -o ${TARGET_DIR}/test.elf
)
arm-none-eabi-objcopy -O binary ${TARGET_DIR}/test.elf ${TARGET_DIR}/test.bin
