/*====================================================================
 * ------------------------
 * | CVS File Information |
 * ------------------------
 *
 * $RCSfile: md_wrap_sp2_c.c,v $
 *
 * $Author: kddevin $
 *
 * $Date: 1996/12/05 20:26:22 $
 *
 * $Revision: 5.0 $
 *
 * $Name:  $
 *====================================================================*/
#ifndef lint
static char *cvs_wrapsp2_id =
  "$Id: md_wrap_sp2_c.c,v 5.0 1996/12/05 20:26:22 kddevin Exp $";
#endif


/*******************************************************************************
 * Copyright 1995, Sandia Corporation.  The United States Government retains a *
 * nonexclusive license in this software as prescribed in AL 88-1 and AL 91-7. *
 * Export of this program may require a license from the United States         *
 * Government.                                                                 *
 ******************************************************************************/


#include <stdio.h>
#if defined (MPL)
#include <sys/utsname.h>
#include <mpproto.h>
#elif defined (MPI)
#include <sys/utsname.h>
#include <mpi.h>
#endif

void get_parallel_info(int *proc, int *nprocs, int *dim)

{

#if defined (MPL) || defined (MPI)
  int i;
  struct utsname sp2_host;
#endif

#if defined (MPL)
  mpc_environ(nprocs, proc);
#elif defined (MPI)
  MPI_Comm_size(MPI_COMM_WORLD, nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, proc);
#endif

#if defined (MPL) || defined (MPI)
  uname(&sp2_host);
  (void) fprintf(stderr, "Task %d is on node %s\n", *proc, sp2_host.nodename);
#else
  *proc   = 0;
  *nprocs = 1;
#endif
  *dim = 0;

} /* get_parallel_info */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void md_whoami(int *node, int *proc, int *host, int *dim)

{

}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

int md_read(char *buf, int bytes, int *source, int *type, int *flag)

{

#if defined (MPL)
  int err, nbytes, buffer;

  if (bytes == 0) {
    err = mpc_brecv(&buffer, 1, source, type, &nbytes);
  } else {
    err = mpc_brecv(buf, bytes, source, type, &nbytes);
  }

  if (err != 0) (void) fprintf(stderr, "mpc_brecv error = %d\n", mperrno);

#elif defined (MPI)
  int err, buffer;
  MPI_Status status;

  if (bytes == 0) {
    err = MPI_Recv(&buffer, 1, MPI_BYTE, *source, *type, MPI_COMM_WORLD,
                   &status);
  } else {
    err = MPI_Recv(buf, bytes, MPI_BYTE, *source, *type, MPI_COMM_WORLD,
                   &status);
  }
  if (err!=0) (void) fprintf(stderr, "MPI_Recv error = %d\n", err);
#endif

  return bytes;

}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

int md_write(char *buf, int bytes, int dest, int type, int *flag)

{
#if defined (MPL)
  int err, buffer;

  if (bytes == 0) {
      err = mpc_bsend(&buffer, 1, dest, type);
  } else {
      err = mpc_bsend(buf, bytes, dest, type);
  }

  if (err!=0) (void) fprintf(stderr, "mpc_bsend error = %d\n", mperrno);

#elif defined (MPI)
  int err, buffer;

  if (bytes == 0) {
      err = MPI_Send(&buffer, 1, MPI_BYTE, dest, type, MPI_COMM_WORLD);
  } else {
      err = MPI_Send(buf, bytes, MPI_BYTE, dest, type, MPI_COMM_WORLD);
  }

  if (err != 0) (void) fprintf(stderr, "MPI_Send error = %d\n", err);
#endif

  return 0;

}
