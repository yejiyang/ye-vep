FEGEN := ..
CC := mpicc
##### For intel complier ####
F77 := mpif90
#############################
AR := ar rv
RANLIB := ranlib
FEGEN := ..

default:
	(rm ${FEGEN}/lib -rf ;mkdir ${FEGEN}/lib )
	(cd fepgsolver ; make)
	(mv fepgsolver/libfepgsolv.a ${FEGEN}/lib -f )
	(cd metis-4.0 ; make )
	(mv metis-4.0/libmetis.a ${FEGEN}/lib -f )
	(cd blas ; make )
	(mv blas/libblas.a ${FEGEN}/lib -f )
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
