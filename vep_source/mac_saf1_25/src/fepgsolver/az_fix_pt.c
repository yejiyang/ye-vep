/*====================================================================
 * ------------------------
 * | CVS File Information |
 * ------------------------
 *
 * $RCSfile: az_fix_pt.c,v $
 *
 * $Author: tuminaro $
 *
 * $Date: 2000/06/02 16:46:55 $
 *
 * $Revision: 1.7 $
 *
 * $Name:  $
 *====================================================================*/
#ifndef lint
static char rcsid[] = "$Id: az_fix_pt.c,v 1.7 2000/06/02 16:46:55 tuminaro Exp $";
#endif


/*******************************************************************************
 * Copyright 1995, Sandia Corporation.  The United States Government retains a *
 * nonexclusive license in this software as prescribed in AL 88-1 and AL 91-7. *
 * Export of this program may require a license from the United States         *
 * Government.                                                                 *
 ******************************************************************************/


#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <float.h>
#include "az_aztec.h"

void AZ_fix_pt(double b[], double x[], double weight[], int options[], 
	double params[], int proc_config[],double status[], AZ_MATRIX *Amat, 
	AZ_PRECOND *precond, struct AZ_CONVERGE_STRUCT *convergence_info)

/*******************************************************************************

  Fixed pt iteration :  x^(i+1) = x^(i) + M (b - A x^(i)).

  Author:          Ray Tuminaro, SNL, 9222
  =======

  Return code:     void
  ============

  Parameter list:
  ===============

  b:               Right hand side of linear system.

  x:               On input, contains the initial guess. On output contains the
                   solution to the linear system.

  weight:          Vector of weights for convergence norm #4.

  options:         Determines specific solution method and other parameters.

  params:          Drop tolerance and convergence tolerance info.

  proc_config:     Machine configuration.  proc_config[AZ_node] is the node
                   number.  proc_config[AZ_N_procs] is the number of processors.

  status:          On output, indicates termination status:
                    0:  terminated normally.
                   -1:  maximum number of iterations taken without achieving
                        convergence.
                   -2:  Breakdown. The algorithm can not proceed due to
                        numerical difficulties (usually a divide by zero).
                   -3:  Internal residual differs from the computed residual due
                        to a significant loss of precision.

  Amat:            Structure used to represent the matrix (see file az_aztec.h
                   and Aztec User's Guide).

  precond:         Structure used to represent the preconditionner  
                   (see file az_aztec.h and Aztec User's Guide).
*******************************************************************************/



{

  /* local variables */

  register int i;
  int          N, NN, converged, one = 1, iter = 1, r_avail = AZ_TRUE, j;
  int          precond_flag, print_freq, proc;
  double       alpha = 1.0;
  double       *res, actual_residual = -1.0;
  double       rec_residual;
  double       scaled_r_norm, epsilon;
  int          *data_org, str_leng, first_time = AZ_TRUE;
  double       *dummy = (double *) 0;
  char         label[64],suffix[32], prefix[64];

  /**************************** execution begins ******************************/

  sprintf(suffix," in fixed%d",options[AZ_recursion_level]);
					/* set string that will be used */
                                        /* for manage_memory label      */
  /* set prefix for printing */

  str_leng = 0;
  for (i = 0; i < 16; i++) prefix[str_leng++] = ' ';
  for (i = 0 ; i < options[AZ_recursion_level]; i++ ) {
     prefix[str_leng++] = ' '; prefix[str_leng++] = ' '; prefix[str_leng++] = ' ';
     prefix[str_leng++] = ' '; prefix[str_leng++] = ' ';
  }
  prefix[str_leng] = '\0';

  /* pull needed values out of parameter arrays */

  data_org = Amat->data_org;
  
  N            = data_org[AZ_N_internal] + data_org[AZ_N_border];
  precond_flag = options[AZ_precond];
  epsilon      = params[AZ_tol];
  proc         = proc_config[AZ_node];
  print_freq   = options[AZ_print_freq];

  /* allocate space for necessary vectors */

  NN = N + data_org[AZ_N_external];
  if (NN == 0) NN++;  /* make sure everybody allocates something */
  NN = NN + (NN%2);   /* make sure things are aligned for assembly */
                      /* matvec on paragon. */

  sprintf(label,"z%s",suffix);
  res  = (double *) AZ_manage_memory(NN*sizeof(double),AZ_ALLOC, 
			           AZ_SYS, label, &j);
  if (options[AZ_init_guess] != AZ_ZERO)
     AZ_compute_residual(b, x, res, proc_config, Amat);
  else dcopy_(&N, b, &one, res, &one);

  /* compute a few global scalars:                                 */
  /*     1) ||r||                corresponding to options[AZ_conv] */
  /*     2) scaled ||r||         corresponding to options[AZ_conv] */

  AZ_compute_global_scalars(Amat, x, b, res,
                            weight, &rec_residual, &scaled_r_norm, options,
                            data_org, proc_config, &r_avail,dummy,dummy,dummy,
                            convergence_info);

  if ((options[AZ_output] != AZ_none) &&
      (options[AZ_output] != AZ_last) &&
      (options[AZ_output] != AZ_warnings) && (proc == 0))
    (void) fprintf(stdout, "%siter:    0           residual = %e\n",
                   prefix,scaled_r_norm);

  converged = scaled_r_norm < epsilon;
  status[AZ_first_precond] = AZ_second();

  for (iter = 1; iter <= options[AZ_max_iter] && !converged; iter++ ) {

    if (precond_flag)
      precond->prec_function(res,options,proc_config,params,Amat,precond);
    if (iter == 1) 
       status[AZ_first_precond] = AZ_second() - status[AZ_first_precond];

    if (options[AZ_solver] == AZ_analyze)
       dscal_(&N,&(params[AZ_temp]), res, &one);
    daxpy_(&N,&alpha, res, &one, x, &one);

    if ( (iter%print_freq == 0) || (options[AZ_max_iter] > 10) ||
         (iter < options[AZ_max_iter]) ) {

    AZ_compute_residual(b, x, res, proc_config, Amat);

       /* compute a few global scalars:                                 */
       /*     1) ||r||                corresponding to options[AZ_conv] */
       /*     2) scaled ||r||         corresponding to options[AZ_conv] */

       if ( (iter%print_freq == 0) || (options[AZ_max_iter] > 10)) 

          AZ_compute_global_scalars(Amat, x, b,
			 res, weight, &rec_residual, &scaled_r_norm, options,
                         data_org, proc_config, &r_avail, dummy, dummy, 
			 dummy, convergence_info);

       if ( (iter%print_freq == 0) && proc == 0 )
          (void) fprintf(stdout, "%siter: %4d           residual = %e\n", 
		     prefix, iter, scaled_r_norm);

       converged = scaled_r_norm < epsilon;
       if (options[AZ_check_update_size] & converged)
          converged = AZ_compare_update_vs_soln(N, -1.,alpha, res, x,
                                           params[AZ_update_reduction],
                                           options[AZ_output], proc_config, &first_time);



     }

  }

  iter--;
  if ( (iter%print_freq != 0) && (proc == 0) && (options[AZ_output] != AZ_none)
       && (options[AZ_output] != AZ_warnings) )
    (void) fprintf(stdout, "%siter: %4d           residual = %e\n", 
		   prefix, iter, scaled_r_norm);

  /* check if we exceeded maximum number of iterations */

  if (converged) i = AZ_normal;
  else i = AZ_maxits;
  if (options[AZ_solver] == AZ_analyze) i = AZ_normal;

  AZ_terminate_status_print(i, iter, status, rec_residual, params,
                            scaled_r_norm, actual_residual, options,
                            proc_config);


} /* AZ_fixed_pt */
