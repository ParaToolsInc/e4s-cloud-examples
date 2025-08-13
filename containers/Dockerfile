# MPI Dockerfile
FROM ecpe4s/ubuntu24.04:latest

ADD helloworld.c /app/

RUN cd /app && mpicc helloworld.c -o /app/hello
