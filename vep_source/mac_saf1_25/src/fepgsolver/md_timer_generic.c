/*====================================================================
 * ------------------------
 * | CVS File Information |
 * ------------------------
 *
 * $RCSfile: md_timer_generic.c,v $
 *
 * $Author: tuminaro $
 *
 * $Date: 1999/09/30 17:04:27 $
 *
 * $Revision: 5.1 $
 *
 * $Name:  $
 *====================================================================*/
#ifndef lint
static char *cvs_timergen_id =
  "$Id: md_timer_generic.c,v 5.1 1999/09/30 17:04:27 tuminaro Exp $";
#endif

#include <time.h>

extern double second(void);
double second(void)

  /*
  *    Returns system cpu and wall clock time in seconds. This
  *    is a strictly Ansi C timer, since clock() is defined as an
  *    Ansi C function. On some machines clock() returns type
  *    unsigned long (HP) and on others (SUN) it returns type long.
  *       An attempt to recover the actual time for clocks which have
  *    rolled over is made also. However, it only works if this 
  *    function is called fairly regularily during
  *    the solution procedure.
  *
  *    clock() -> returns the time in microseconds. Division by
  *               the macro CLOCKS_PER_SEC recovers the time in seconds.
  */

{
  static clock_t last_num_ticks = 0;
  static double  inv_clocks_per_sec = 1./(double)CLOCKS_PER_SEC;
  static double  clock_width =
    (double)(1L<<((int)sizeof(clock_t)*8-2))*4./(double)CLOCKS_PER_SEC;
  static int     clock_rollovers = 0;
  double value;
  clock_t num_ticks = clock();
  if(num_ticks < last_num_ticks) clock_rollovers++;
  value = num_ticks * inv_clocks_per_sec;
  if(clock_rollovers) value += clock_rollovers * clock_width;
  last_num_ticks = num_ticks;
  return(value);
}
