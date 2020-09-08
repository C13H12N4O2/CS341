.text
.global _printbin
.data
result:
		.ascii "0000 0000\0"

_printbin:
	push	%ebp
	mov		%esp, %ebp
	sub		$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -8(%ebp)
	movl	%eax, -8(%ebp)
	shrl	$4, -8(%ebp)
	movl	$result, %edx
	call	donibble
	addl	$1, %edx
	movl	-4(%ebp), %eax
	movl	%eax, -8(%ebp)
	call 	donibble
	movl	$result, %eax
	mov		%ebp, %esp
	popl	%ebp
	ret

donibble:
	push	%ebp
	mov		%esp, %ebp
	sub		$16, %esp
	movl	8(%ebp), %eax
	xor		%eax, %eax
	movb	%al, -4(%ebp)
	movl	$4, -12(%ebp)
	movl	$3, -16(%ebp)

loop:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-16(%ebp), %ecx
	shrl	%cl, -8(%ebp)
	and		$1, -8(%ebp)
	movzbl	-8(%ebp), %eax
	addb	$0x30, %al
	movb	%al, (%edx)
	addl	$1, %edx
	sub		$1, -16(%ebp)
	sub		$1, -12(%ebp)
	cmpb	$0, -12(%ebp)
	jne		loop
	mov		%ebp, %esp
	popl	%ebp
	ret
