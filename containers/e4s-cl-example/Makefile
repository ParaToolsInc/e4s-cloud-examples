CC=mpicc

ifeq ($(HYPRE_DIR),)
	HYPRE_DIR := `spack location -i --first hypre+mpi`
endif 
LIBS=-L$(HYPRE_DIR)/lib -Wl,-rpath,$(HYPRE_DIR)/lib -lHYPRE -lm
CFLAGS=-I$(HYPRE_DIR)/include  -DHYPRE_TIMING -DHAVE_CONFIG

hypre_test: hypre_test.o
		$(CC) $< -o $@ $(LIBS)
hypre_test.o: hypre_test.c
		$(CC) -c $< $(CFLAGS)
run: hypre_test
		mpirun -np 8 ./hypre_test -P 2 2 2 -n 100 100 100
clean:
		/bin/rm -f hypre_test.o hypre_test
