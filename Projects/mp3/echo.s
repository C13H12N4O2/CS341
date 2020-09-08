.text
.globl _echo
_echo:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp
	movb 12(%ebp), %bl 
	movl 8(%ebp), %edx 

	xorl %ecx, %ecx
	movb $0xfc, %dl
	inb (%dx), %al
	orb $0x03, %al
	outb %al, (%dx)
	movb $0xfe, %dl  
loop1:
	inb (%dx), %al  
	andb $0xb0, %al  
	xorb $0xb0, %al  
	jnz loop1
loop2:
	movl $0xfd, %dl	
	inb (%dx), %al	
	andb $0x01, %al	
	jz loop2		
	movl $0xf8, %dl	
	inb (%dx), %al	
	movb %al, %al	
	cmpb %cl, %bl
	je return
	movb $0xfd, %dl	
type:
	inb (%dx), %al	
	andb $0x20, %al
	jz loop2		
	movzbl %dl, %eax	
	movl $0xf8, %edx	
	outb %al, (%dx)	
	jmp loop2
return:
	mov %ebp, %esp
	popl %ebp
	ret
	.end
