.text
.globl _count

_count:
	push	%ebp
	mov		%esp, %ebp
	sub		$8, %esp
	mov		8(%ebp), %esi
	movb	12(%ebp), %ebx
	mov		$0, %eax
	mov		$0, %ecx
	cmpb	(%esi), %ebx
	je		inc

loop:
	inc		%ecx
	cmp		$100, %ecx
	je		end
	add		$1, %esi
	cmpb	(%esi), %ebx
	jne		loop

inc:
	inc		%eax
	jmp		loop

end:
	mov		%ebp, %esp
	pop		%ebp
	ret
