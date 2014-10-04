##########################################################################
# Makefile for datapre for vep				                 #
##########################################################################
#
FEGEN       =    ..
#CC          =    icc
#F77         =    ifort
#F90         =    ifort
#FLINKER     =    ifort
CC          =    gcc
F77         =    gfortran
F90         =    gfortran
FLINKER     =    gfortran
OPTFLAGS    =    -O2 -L${FEGEN}/lib
#OPTFLAGS    =    -O2 -L${FEGEN}/lib
#OPTFLAGS1   =    -O2 -zero -save -static -L${FEGEN}/lib
#OPTFLAGS1   =    -O2 -zero -save -static -L${FEGEN}/lib
AR          =     ar rv
#
##########################################################################
#
CFLAGS    = -O2 
#CFLAGS    = -O2 -zero -save
FFLAGS    = $(OPTFLAGS)
########## For all kinds of BLAS library  ###########################

default: amend frame  bdseg prgla  prg  forgid   

amend: amend.o
	$(FLINKER) -o $@ amend.o
frame: frame.o
	$(FLINKER) -o $@ frame.o
bdseg: bdseg.o
	$(FLINKER) -o $@ bdseg.o
prgla: prgla.o
	$(FLINKER) -o $@ prgla.o
prg: prg.o
	$(FLINKER) -o $@ prg.o
forgid: forgid.o
	$(FLINKER) -o $@ forgid.o
.c.o:
	$(CC)  $(CFLAGS) -c $*.c
.F.o:
	$(F90) $(FFLAGS) -c $*.F
.f.o:
	$(F77) $(FFLAGS)  -c $*.f
.for.o:
	$(F77) $(FFLAGS) -c $*.for
clean:
	/bin/rm -f *.o amend frame bdseg prgla prg forgid 
	/bin/rm -f coor0 elem0 id0 disp0
	/bin/rm -f tli0 disp1
	/bin/rm -f data1 amend.flavia.msh mesh.* bd.*
	/bin/rm -f all-boundaries boundaries data disp.dat
	/bin/rm -f partition.flavia.res partition.flavia.msh
	/bin/rm -f ??000 ???000 ????000
	/bin/rm -f data0.tgz part0.tgz
#
#========================================================================
#
