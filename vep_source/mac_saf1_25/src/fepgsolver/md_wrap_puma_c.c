/*====================================================================
 * ------------------------
 * | CVS File Information |
 * ------------------------
 *
 * $RCSfile: md_wrap_puma_c.c,v $
 *
 * $Author: tuminaro $
 *
 * $Date: 1998/04/15 22:06:33 $
 *
 * $Revision: 5.1 $
 *
 * $Name:  $
 *====================================================================*/
#ifndef lint
static char *cvs_wrappuma_id =
  "$Id: md_wrap_puma_c.c,v 5.1 1998/04/15 22:06:33 tuminaro Exp $";
#endif


/*******************************************************************************
 * Copyright 1995, Sandia Corporation.  The United States Government retains a *
 * nonexclusive license in this software as prescribed in AL 88-1 and AL 91-7. *
 * Export of this program may require a license from the United States         *
 * Government.                                                                 *
 ******************************************************************************/


#ifdef MPI
#include <mpi.h>
#else
#define MPI_Request int
#endif

#define nCUBE 1
#define INTEL 2
#define SUN   3
#define DELTA 4
#define MACHINE INTEL
#define CUBESIZ 128 /* a power of two >= number of processors */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void get_parallel_info(int *proc, int *nprocs, int *dim)

{

  int dummy1, dummy2, dummy3;
  int host, nodeID;

  *proc   = mynode();
  *nprocs = numnodes();
  *dim    = 0;

} /* get_parallel_info */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

int md_read(char *buf, int bytes, int *source, int *type, int *flag)

{
  int i;

  i = nread(buf, bytes, source, type, flag);
  return i;

} /* md_read */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

int md_write(char *buf, int bytes, int dest, int type, int *flag)

{
  int i;

  i = nwrite(buf, bytes, dest, type, flag);
  return i;

} /* md_write */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

int md_wrap_iread(void *buf, int bytes, int *source, int *type,
                  MPI_Request *request)

/*******************************************************************************

  Machine dependent wrapped message-reading communication routine for the
  Intel.  This routine is a simple no-op but is used in order to provide
  compatibility with the MPI communication routine order.

  Author:          Scott A. Hutchinson, SNL, 9221
  =======

  Return code:     int
  ============

  Parameter list:
  ===============

  buf:             Beginning address of data to be sent.

  bytes:           Length of message in bytes.

  source:          Source processor number.

  type:            Message type

*******************************************************************************/

{

  return 0;

} /* md_wrap_iread */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

int md_wrap_write(void *buf, int bytes, int dest, int type, int *flag)

/*******************************************************************************

  Machine dependent wrapped message-sending communication routine for the
  Intel.  This routine is exactly the same as md_write.

  Author:          Scott A. Hutchinson, SNL, 9221
  =======

  Return code:     int
  ============

  Parameter list:
  ===============

  buf:             Beginning address of data to be sent.

  bytes:           Length of message in bytes.

  dest:            Destination processor number.

  type:            Message type

  flag:

*******************************************************************************/

{

  int i;

  i = nwrite(buf, bytes, dest, type, flag);
  return i;

} /* md_wrap_write */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

int md_wrap_wait(void *buf, int bytes, int *source, int *type, int *flag,
                 MPI_Request *request)

/*******************************************************************************

  Machine dependent wrapped message-wait communication routine for the Intel.
  This routine is identical to md_read but is put here in order to be compatible
  with the order required to do MPI communication.

  Author:          Scott A. Hutchinson, SNL, 9221
  =======

  Return code:     int
  ============

  Parameter list:
  ===============

  buf:             Beginning address of data to be sent.

  bytes:           Length of message in bytes.
  dest:            Destination processor number.

  type:            Message type

  flag:

*******************************************************************************/

{
  int i;

  i = nread(buf, bytes, source, type, flag);
  return i;

} /* md_wrap_wait */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

/*
 * This section is used to kill the program on all nodes when an "exit" is
 * called from the program.  The "exit" call must be redefined in a header file
 * (e.g., rf_salsa.h) to mean "puma_exit" when being compiled for PUMA on the
 * Intel.  Make sure -DPUMA is used when compiling.
 */

#include <signal.h>

int puma_exit(int ignore)

{
  nodekill(-1, 1, SIGKILL);
}
int md_wrap_iwrite(void *buf, int bytes, int dest, int type, int *flag,
                  int *request)
{
int ret_info;
 
ret_info = md_wrap_write(buf, bytes, dest, type, flag);
return(ret_info); 
}

