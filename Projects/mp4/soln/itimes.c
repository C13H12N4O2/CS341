
/******************************************************************
*
*   file:     itimes.c
*   author:   Betty O'Neil
*   date:     '88
*
*   Driver for program to time assembly language instructions.
*
*   Tests are external, as is timing package
*
*   revisions: Ethan Bolker, Fall 1990
*              Richard Eckhouse, Spring 1993
*              Betty O'Neil, to SAPC, S96, faster systems S00
*              Bob Wilson, fixed nulltime problem with a fixed constant 3/13/2009
*       
*   revisions needed (but not part of mp3, just think about it):
*
*      It would be nice to replace the ugly repeated code for calling 
*      test1, test2, test3 by an appropriate loop. A good way would be
*      to build an external table of tests and mimic the structure of cmds.c 
*      in mp2. If you do that you can even make the text describing
*      each test part of a test struct rather than having it hard 
*      wired in this file.
*
*      Also it would be good to check the values returned
*      by the routines in the timing package.
*/

#include <stdio.h>
#include <timepack.h>
#ifdef SAPC
#include <cpu.h>
#include <mmu.h>
#endif

#define MILLION 1000000
/* INSTRUCTIONS_PER_TEST should divide MILLION */
#define INSTRUCTIONS_PER_TEST 32
/* default to 100M instructions in test */
#define DEFAULT_M_INSTRUCTIONS 100

void ctest(int loopcount);
void cpu_caches_off(void);
void cpu_caches_on(void);
void print_decimal(int n);
void experiment(int k_instructions, int report);

/* assembler looping routines */
extern void test0(int), test1(int), test2(int), test3(int), test4(int); 


int main(void)
{
  int n_Minstructions;

  printf("Calling inittimer...\n");
  inittimer();
  printf("...inittimer done.\n");

/* set this symbol if you want to vary the loopcount */
#ifdef WANT_USER_INPUT_OF_LOOPCOUNT
  printf("\nEnter loopcount (millions of iterations): ");
  scanf("%d",&n_Minstructions);
#else
  /* use fixed value for easier debugging */
  n_Minstructions = DEFAULT_M_INSTRUCTIONS;
  printf("Each instruction timing test will execute %d million instructions\n",
	 DEFAULT_M_INSTRUCTIONS);
#endif

#ifdef SAPC
  cpu_caches_off();
  printf("\nCPU Caches off and empty now\n");
#endif
  experiment(1, /* report */ 0);  /* warm up (UNIX: make sure pages in mem) */
  experiment(n_Minstructions, /* report */ 1);
#ifdef SAPC
  cpu_caches_on();
  printf("\nCPU Caches back on, as normal\n");
  experiment(1, /* report */ 0);  /* warm up (fill caches) */
  experiment(n_Minstructions, /* report */ 1);
#endif
  shutdowntimer();
  printf("\nEnd of itimes.\n");
  return 0;			/* (ineffective but harmless on SAPC) */
}


/* do a run of tests, and report result if argument report is true */
void experiment(int n_Minstructions, int report)
{
  int testcount, ctesttime;
#ifdef SAPC
  int itime, nulltime, looptime;
#endif

  testcount = n_Minstructions * (MILLION/INSTRUCTIONS_PER_TEST);
  starttimer();
  ctest(testcount);		/* run a portable test first */
  stoptimer(&ctesttime);
  if (report)
    printf("C Test takes %d ms, %d ns/pass\n",
	   ctesttime/1000, ctesttime/(testcount/1000));
#ifndef SAPC
  if (report&&ctesttime>2*MILLION) /* took over 2 sec on timesharing sys */
    printf("Please don't do tests over 2 sec on timesharing!\n");
#endif
    
#ifdef SAPC
  starttimer();
  test0(testcount);	/* run loop with no actual test instruct. */
  stoptimer(&nulltime);
  nulltime = 11000;     /* the above does not work reliably due to cache */
  if (report)
     printf("Test overhead is %d ms\n", nulltime/1000);

  starttimer();
  test1(testcount);		/* register-to-register moves */
  stoptimer(&looptime);		/* time in us */
  itime = (looptime-nulltime)/n_Minstructions; /* per-instruction picosecs */
  if (report) {
    printf("Test 1: movl %%eax,%%edx --- %d ms, ", (looptime-nulltime)/1000);
    print_decimal(itime);  /* to hundredths of ns */
    printf(" ns/instruction\n");
  }

  starttimer();
  test2(testcount);		/* memory-to-register moves */
  stoptimer(&looptime);
  itime = (looptime-nulltime)/n_Minstructions; /* per-instruction picosecs */
  if (report) {
    printf("Test 2: movl <mem address>, %%eax --- %d ms, ",
	   (looptime-nulltime)/1000);
    print_decimal(itime);  /* to hundredths of ns */
    printf(" ns/instruction\n");
  }

  starttimer();
  test3(testcount);		/* immediate-to-register moves */
  stoptimer(&looptime);
  itime = (looptime-nulltime)/n_Minstructions; /* per-instruction picosecs */
  if (report) {
    printf("Test 3: movl $IDATA, %%eax --- %d ms, ",
	   (looptime-nulltime)/1000);
    print_decimal(itime);  /* to hundredths of ns */
    printf(" ns/instruction\n");
  }

  starttimer();
  test4(testcount);
  stoptimer(&looptime);
  itime = (looptime-nulltime)/n_Minstructions; /* per-instruction picosecs */
  if (report) {
    printf("Test 4: movl $12345678, -4(%%esp) --- %d ms, ",
           (looptime-nulltime)/1000);
    print_decimal(itime);  /* to hundredths of ns */
    printf(" ns/instruction\n");

  }


#endif
}

/* little loop in C for testing */
void ctest(int loopcount)
{
  int i;
  int sum = 0;

  for (i=0;i<loopcount; i++)
    sum *=i;
}

#ifdef SAPC

/* Turn on cache-disable bits in CR0 to disable x86's on-chip cache
 * Mark all of user memory as uncacheable, to disable external cache.
 * Also, empty out both on-chip cache and external cache.
 * See cpu.c and mmu.c in $pclibsrc for code if interested.
 */
void cpu_caches_off()
{
  set_user_pages_uncacheable();	/* mark user pages noncacheable */
  cpu_cache_off();		/* turn off on-chip cache, 
				   empty both caches */
}

/* Turn off cache-disable bits in CR0 to enable x86's CPU cache 
 * and put user pages back to normal cacheability
 */
void cpu_caches_on()
{
  set_user_pages_cacheable();	/* back to normal case */
  cpu_cache_on();		/* on-chip cache back on */
}

/* print n/1000, including decimal fraction to 2 decimal places, given n.
 * Note that SAPC library printf can't do %f, so we use %d.%d with 
 * the whole number and the number of hundredths.
 * Add 5 to cause rounding on last digit.  For example if n = 12344 
 * then n/1000 = 12 and (n+5)%1000/10 = 12349%1000/10 = 349/10=34
 * and "12.34" is printed, but if n = 12345, then (n+5)%1000/10 =
 * 12350%1000/10 = 350/10=35 and "12.35" is printed.
 */
void print_decimal(int n)
{
   printf("%d.%02d", n/1000, ((n+5)%1000)/10);
}
#endif

