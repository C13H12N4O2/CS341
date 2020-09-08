/******************************************************************
*
*   file:     cmds.c
*   author:   betty o'neil (Solution by Bob Wilson)
*   date:     ? (9/13/2003)
*
*   semantic actions for commands called by tutor (cs341, hw2)
*
*   revisions:
*      9/90  eb   cleanup, convert function declarations to ansi
*      9/91  eb   changes so that this can be used for hw1
*      9/02  re   minor changes to quit command
*/
/* the Makefile arranges that #include <..> searches in the right
   places for these headers-- */

#include <stdio.h>
#include <slex.h>
#include <string.h>

/*===================================================================*
*
*   Command table for tutor program -- an array of structures of type
*   cmd -- for each command provide the token, the function to call when
*   that token is found, and the help message.
*
*   slex.h contains the typdef for struct cmd, and declares the
*   cmds array as extern to all the other parts of the program.
*   Code in slex.c parses user input command line and calls the
*   requested semantic action, passing a pointer to the cmd struct
*   and any arguments the user may have entered.
*
*===================================================================*/

PROTOTYPE int stop(Cmd *cp, char *arguments);
PROTOTYPE int mem_display(Cmd *cp, char *arguments);
PROTOTYPE int mem_set(Cmd *cp, char *arguments);
PROTOTYPE int help(Cmd *cp, char *arguments);
PROTOTYPE unsigned int atox(char **arguments);

/* command table */

Cmd cmds[] = {{"md",  mem_display, "Memory display: MD <addr>"},
	      {"ms",  mem_set, "Memory set: MS <addr> <value>"},
	      {"h",   help, "Help: H <command>"},
              {"s",   stop,        "Stop" },
              {NULL,  NULL,        NULL}};  /* null cmd to flag end of table */

char xyz = 6;  /* test global variable  */
char *pxyz = &xyz;  /* test pointer to xyz */
/*===================================================================*
*		command			routines
*
*   Each command routine is called with 2 args, the remaining
*   part of the line to parse and a pointer to the struct cmd for this
*   command. Each returns 0 for continue or 1 for all-done.
*
*===================================================================*/

int stop(Cmd *cp, char *arguments)
{
  return 1;			/* all done flag */
}

/*===================================================================*
*
*   mem_display: display contents of 16 bytes in hex
*
*/

int mem_display(Cmd *cp, char *arguments)
{
  unsigned int address, i;

  if (sscanf(arguments, "%x", &address) == 1) {
    /* print the address in hex */
    printf("%08x    ", address);
    /* print 16 locations as two hex digits per memory byte */ 
    for (i = 0; i < 16; i++)
	printf("%02x ", *(unsigned char *)(address + i));
    /* print 16 locations as one ascii coded character per byte */
    for (i = 0; i < 16; i++)
	printf("%c",
	(*(unsigned char *)(address + i) >= ' ' &&
	 *(unsigned char *)(address + i) <= '~') ?
	 *(unsigned char *)(address + i) : '.');
    /* and print end of line */
    printf("\n");
  } else
    printf("        help message: %s\n", cp->help);

  return 0;			/* not done */
}

int mem_set(Cmd *cp, char *arguments)
{

  unsigned int address, value;

  if (sscanf(arguments, "%x %x", &address, &value) == 2) {
    if(value < 0x100)
       *(unsigned char *)address = value;
    else
       *(unsigned int *)address = value;

    printf("OK\n");
  } else
    printf("        help message: %s\n", cp->help);

  return 0;
}

int help(Cmd *cp, char *arguments)
{
  printf("     cmd    help message\n");
  while(*arguments == ' ')
     arguments++;
  for(cp = cmds; cp->cmdtoken; cp++)
     if (!strcmp(arguments, cp->cmdtoken)) {
	printf("%8s    %s\n", cp->cmdtoken, cp->help);
	return 0;
     }
  for(cp = cmds; cp->cmdtoken; cp++)
     printf("%8s    %s\n", cp->cmdtoken, cp->help);
  return 0;
}

