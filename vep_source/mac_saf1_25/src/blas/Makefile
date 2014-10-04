######################################
#       Makefile for libblas.a       #
###################################### 
include Makefile.in

CC := mpicc
F77 := mpif90
AR := ar rv
RANLIB := ranlib

#SOURCE := *.f
OBJS := $(patsubst %.f,%.o,${SOURCE})

default : libblas.a

libblas.a : ${OBJS}
	${AR} $@ ${OBJS}
	${RANLIB} $@

${OBJS} : ${SOURCE}
	${F77} -c ${SOURCE}

clean : 
	rm -f *.o

realclean :
	rm -f *.o ; rm -f libblas.a
