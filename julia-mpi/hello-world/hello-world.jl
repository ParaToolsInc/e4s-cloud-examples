# examples/01-hello.jl
using MPI
MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
size = MPI.Comm_size(comm)

# Get the hostname/processor name
node_name = MPI.Get_processor_name()

print("Hello world, I am rank $rank of $size running on $node_name\n")
MPI.Barrier(comm)
