CC=nvcc
all: matmult

matmult: matmult.o
	$(CC) -o $@ $<

matmult.o: matmult.cu
	$(CC) -g -c $< -o $@

clean: 
	rm -rf matmult matmult.o profile* tauprofile*

run:
	tau_exec -T serial -cuda ./matmult
