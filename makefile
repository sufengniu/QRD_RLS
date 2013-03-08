# Makefile for QR Decomposition
# author: Sufeng Niu
# company: ECASP

CC = gcc
CC_ZYNQ = 
VERSION = 0.0.1
CFLAGS = -O3
CFLAGS_ZYNQ = -O3 -mfpu = neon

.PHONY: all clean tar

all: qrd_cpu qrd_zynq 

qrd_cpu: main_cpu.o givens_rotation_cpu.o
	$(CC) main_cpu.o givens_rotation.o -o qrd_cpu -lm

givens_rotation_cpu.o: givens.c givens.h
	$(CC) $(CFLAGS) -c givens.c -o givens_rotation_cpu.o 

main_cpu.o: main.c givens.h
	$(CC) $(CFLAGS) -c main.c -o main_cpu.o

qrd_zynq: main_zynq.o givens_rotation_zynq.o
	$(CC_ZYNQ) $(CFLAGS_ZYNQ) -c main_zynq.o givens_rotation_zynq.o -o qrd_zynq -lm

givens_rotation_zynq.o: givens.c givens.h
	$(CC_ZYNQ) $(CFLAGS_ZYNQ) -c givens.c -o givens_rotation_zynq.o -o givens_rotation_zynq.o

main_zynq.o: main.c givens.h
	$(CC_ZYNQ) $(CFLAGS_ZYNQ) -c main.c -o main_zynq.o 

tar: main.c givens.c givens.h

clean: 
	rm -f *.o qrd_cpu givens_rotation_zynq givens_rotation_cpu res_vector.dat

