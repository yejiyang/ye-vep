## 1. compile the lib from src

### a. edit src/Makefile
	
	# change "rm xxx -fr" to "rm -fr xxx"
	# also change "mv xxx -f" to "mv -f xxx"

### b. edit ./fepgsolver/az_tools.c

	# change "#include <malloc.h>" to "#include <malloc/malloc.h>"

### c. edit ./fepgsolver

	# change to MPI_INCLUDE_DIR = -I/opt/local/include
	#           MPI_LIB         = -L/opt/local/lib -lmpich

### d. before make, clean first

	make realclean

## 2. prepare the datapre

	# switch "icc" to "gcc"
	# switch "ifort" to "gfortran"
