# Makefile for QR Decomposition
# Engineer: Sufeng Niu
# Company: ECASP

ZYNQ_PATH = /tools/Xilinx/14.4/ISE_DS/EDK/gnu/arm/lin/bin/
BUILDROOT_PATH=$(HOME)/ZynqLinux/buildroot/

CC = gcc
CC_ZYNQ = $(ZYNQ_PATH)arm-xilinx-linux-gnueabi-gcc 
VERSION = 0.0.1
CFLAGS = -O3 -Wall
CFLAGS_ZYNQ = -O3 -mfpu=neon -L$(BUILDROOT_PATH)/output/target/lib/

.PHONY: all clean tar

all: qrd_cpu qrd_zynq 

qrd_cpu: main_cpu.o givens_rotation_cpu.o
	$(CC) $(CFLAGS) main_cpu.o givens_rotation_cpu.o -o qrd_cpu -lrt -lm

givens_rotation_cpu.o: givens.c givens.h
	$(CC) $(CFLAGS) -c givens.c -o givens_rotation_cpu.o 

main_cpu.o: main.c givens.h
	$(CC) $(CFLAGS) -c main.c -o main_cpu.o

qrd_zynq: main_zynq.o givens_rotation_zynq.o
	$(CC_ZYNQ) $(CFLAGS_ZYNQ) main_zynq.o givens_rotation_zynq.o -o qrd_zynq -lrt -lm

givens_rotation_zynq.o: givens.c givens.h
	$(CC_ZYNQ) $(CFLAGS_ZYNQ) -c givens.c -o givens_rotation_zynq.o

main_zynq.o: main.c givens.h
	$(CC_ZYNQ) $(CFLAGS_ZYNQ) -c main.c -o main_zynq.o 

tar:
	tar czvf QRD.tar *.h *.c makefile

clean: 
	rm -f *.o qrd_cpu qrd_zynq givens_rotation_zynq givens_rotation_cpu res_vector.dat *.tar

