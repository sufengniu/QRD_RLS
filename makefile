# Makefile for QR Decomposition
# author: Sufeng Niu
# company: ECASP

CC = gcc
VERSION = 0.0.1
CFLAGS = -O3

.PHONY: all clean 

all: qrd_cpu 

qrd_cpu: main_cpu.o
	$(CC) $(CFLAGS) -g main_cpu.o -o qrd_cpu

main_cpu.o: main.c
	$(CC) $(CFLAGS) -c -g main.c -o main_cpu.o

clean: 
	rm -f *.o qrd_cpu res_vector.dat

