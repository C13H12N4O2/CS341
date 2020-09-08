/******************************************************************
*
*   file:     cmds.c
*   author:   betty o'neil
*   date:     ?
*
*   semantic actions for commands called by tutor (cs341, hw2)
*
*   revisions:
*      9/90  eb   cleanup, convert function declarations to ansi
*      9/91  eb   changes so that this can be used for hw1
*      9/02  re   minor changes to quit command
*/
/* the Makefile arranges that #include <..> searches in the right
   places for these headers-- 200920*/

#include <stdio.h>
#include "slex.h"

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

/* command table */

Cmd cmds[] = {{"md",  mem_display, "Memory Display	: MD <adddr>"},
			  {"ms",  mem_set,     "Memory Set      : MS <addr> <val> [<val>...]"},
			  {"h",   help,		   "Display help	: H [command]"},
              {"s",   stop,        "Stop        	: S" },
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
	int address, i;
	unsigned char *ptr;

	sscanf(arguments, "%x", &address);
	ptr = (unsigned char *) address;
	
	printf("%x ", address);

	for (i = 0; i < 16; i++)
		printf("%02x ", *ptr++);
	
	ptr = (unsigned char *) address;

	for (i = 0; i < 16; i++) {
		if (32 <= (int) *ptr && 126 >= (int) *ptr) 
			printf("%c", *ptr++);
		else {
			printf(".");
			*ptr++;
		}
	}
	printf("\n");
	return 0;			/* not done */
}

int mem_set(Cmd *cp, char *arguments) {
	int address, value;
	char *ptr;

	sscanf(arguments, "%x %x", &address, &value);
	ptr = (char *) address;
	*ptr = value;
	
	return 0;
}

int help(Cmd *cp, char *arguments) {
	char command[1];
	int i;
	sscanf(arguments, "%s", command);
	
	for (i = 0; i < 4; i++) {
		if ((strcmp(cmds[i].cmdtoken, command)) == 0) {
			printf("%s\n", cmds[i].help);
			return 0;
		}
	}

	for (i = 0; i< 4; i++)
		printf("%s\n", cmds[i].help);
	return 0;
}
