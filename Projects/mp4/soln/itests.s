#------------------------------------------------------------------
#
#    file:      itests.s
#    author:    Betty O'Neil
#    date:      ?
#
#    revisions: Richard Eckhouse, Spring 1993
#               Betty O'Neil, to SAPC, S96
#               Betty O'Neil/John Lentz, 2001: use batches of 32
#                instructions, to average out 32-byte prefetches
#                of current CPUs (can't turn off the prefetch buffer)
#               Bob Wilson, Spring 2009
#                added comments that test overhead loop is not accurate
#
#    Assembler routines to time x86 instructions.
#
#    callable from C: for example
#
#          test1(loopcount);
#
# runs loop executing a test instruction loopcount times:
# test0: no test instruction at all, just measuring test overhead
# test1: register-to-register doubleword move
# test2: memory-to-register doubleword move
# test3: to be finished: immed-to-register doubleword move
# test4: to be added

#  make test0, etc. globally accessible via ld--
.globl _test0, _test1, _test2, _test3, _test4
.text

# The following code is repetitious and dull, but it's not clear how to 
# avoid it--it's tempting to "patch in" one instruction to the loop, but 
# besides being self-modifying code (generally considered a terrible 
# idea and often impossible in timesharing), it's dangerous because the 
# various instructions have different lengths.  One could compose code 
# in the data area, making sure to get the right bpl encoding after the 
# tested instruction, and execute it there, but this would be quite a 
# project, so let's tolerate repetitious and dull here...
# Note:	 using decl, jnz instead of loop to allow jumps back
# by more than 128 bytes.  Also, S&S claims decl, jnz is faster (pg 93).
# Note 1: there are 30 of each timed instruction, plus 2 loop-control
#	  instructions, for a total of 32 instructions/loop
	
# Note 2: the timing of the loop0 overhead test case is affected by the
#         5 least significant bits of memory address where it is located.
#         There appears to be a prefetch of addresses beyond 16 byte boundary 
#         based on the LSBs of loop0 memory address, the overhead measures: 
#             LSBs 00000 - 01111:    15 ms
#             LSBs 10000 - 11101:   530 ms
#             LSBs 11110 - 11111:  1060 ms
#
#         hence, this loop does not reliably measure the test overhead
#         the assembler .align directive does not accept .align 32
#         the only way to fix it is to pad nops between _test0: & loop0:
#         for simplicity:
#         in itimes.c, a constant is substituted for this test value

_test0: movl 4(%esp),%ecx       # count param is just under return pc on stack
loop0:  
	decl %ecx
        jnz loop0               # decrement count in %ecx and branch if > 0
        ret

_test1: movl 4(%esp),%ecx       # count param is just under return pc on stack
loop1:  
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed

        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed

        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed

        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed

        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed

        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed
        movl %eax, %edx         # instruction being timed

	decl %ecx
        jnz loop1              # decrement count in %ecx and branch if > 0
        ret

_test2: movl 4(%esp),%ecx       # count param is just under return pc on stack
loop2:  
        movl memaddr1, %eax      # instruction being timed
        movl memaddr2, %eax      # instruction being timed
        movl memaddr3, %eax      # instruction being timed
        movl memaddr4, %eax      # instruction being timed
        movl memaddr5, %eax      # instruction being timed

        movl memaddr1, %eax      # instruction being timed
        movl memaddr2, %eax      # instruction being timed
        movl memaddr3, %eax      # instruction being timed
        movl memaddr4, %eax      # instruction being timed
        movl memaddr5, %eax      # instruction being timed

        movl memaddr1, %eax      # instruction being timed
        movl memaddr2, %eax      # instruction being timed
        movl memaddr3, %eax      # instruction being timed
        movl memaddr4, %eax      # instruction being timed
        movl memaddr5, %eax      # instruction being timed

        movl memaddr1, %eax      # instruction being timed
        movl memaddr2, %eax      # instruction being timed
        movl memaddr3, %eax      # instruction being timed
        movl memaddr4, %eax      # instruction being timed
        movl memaddr5, %eax      # instruction being timed

        movl memaddr1, %eax      # instruction being timed
        movl memaddr2, %eax      # instruction being timed
        movl memaddr3, %eax      # instruction being timed
        movl memaddr4, %eax      # instruction being timed
        movl memaddr5, %eax      # instruction being timed

        movl memaddr1, %eax      # instruction being timed
        movl memaddr2, %eax      # instruction being timed
        movl memaddr3, %eax      # instruction being timed
        movl memaddr4, %eax      # instruction being timed
        movl memaddr5, %eax      # instruction being timed

	decl %ecx
        jnz loop2              # decrement count in %ecx and branch if > 0
        ret


# _test3 is just a stub - you finish it

_test3:	movl 4(%esp),%ecx	# count param is just under return pc on stack
loop3:
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax

	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax

	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax

	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax

	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax

	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax
	movl $0, %eax

	decl %ecx
        jnz loop3              # decrement count in %ecx and branch if > 0
     	ret

# _test4

_test4: movl 4(%esp),%ecx       # count param is just under return pc on stack
loop4:
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)

	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)

	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)

	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)

	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)

	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)
	movl $12345678, -4(%esp)

	decl %ecx
	jnz loop4
	ret

.data
# ensure "aligned doubleword" with .align 4
# that is, make sure memaddr1's address value is a multiple of 4
# you could try a mis-aligned doubleword by adding .ascii "abc"
# between the .align and memaddr: lines., to push the address down by 3
.align 4
memaddr1:	.long 6                # memory location for test2
memaddr2:	.long 7
memaddr3:	.long 8
memaddr4:	.long 9	
memaddr5:	.long 10	
