FEGEN := ..
CC := mpicc
##### For intel complier ####
F77 := mpif90
#############################
AR := ar rv
RANLIB := ranlib
FEGEN := ..

default:
	(rm -fr ${FEGEN}/lib ;mkdir ${FEGEN}/lib )
	(cd fepgsolver ; make)
	(mv -f fepgsolver/libfepgsolv.a ${FEGEN}/lib )
	(cd metis-4.0 ; make )
	(mv -f metis-4.0/libmetis.a ${FEGEN}/lib )
	(cd blas ; make )
	(mv -f blas/libblas.a ${FEGEN}/lib )
	${F77} -c fepglib.f
	${AR} libfepg.a fepglib.o
	${RANLIB} libfepg.a
	(mv libfepg.a ${FEGEN}/lib )

clean:
	(cd metis-4.0 ; make clean )
	(cd blas ; make clean )
	(cd fepgsolver ; make clean )
	rm -f *.o ;

realclean :
	(cd metis-4.0 ; make realclean )
	(cd blas ; make realclean )
	(cd fepgsolver ; make clean )
	rm -f *.o ; rm -f *.a
