.text
.globl _mystrcpy

_mystrcpy:
	push	%ebp
	mov		8(%esp), %edi
	mov		12(%esp), %esi

loop:
	mov		(%esi), %eax
	mov		%eax, (%edi)
	movb	(%esi), %al
	cmpb	%al, 0x03
	je		end
	add		$1,	%edi
	add		$1, %esi
	jmp		loop

end:
	mov		8(%esp), %eax
	pop		%ebp
	ret

#_mystrcpy:
#	push	%ebp
#	mov		8(%esp), %edx
#	mov		12(%esp), %ebx
#
#loop:
#	movl	(%ebx), %eax
#	movb	(%ebx), %bl
#	cmpb	%bl, 0x03
#	je		end
#	mov		%eax, (%edx)
#	mov		%ebx, %ebx
#	mov		%edx, %edx
#	jmp		loop
#
#end:
#	mov		%eax, (%edx)
#	movl	%edx, %eax
#	pop 	%ebp
#	ret

#_mystrcpy:
#	push	%ebp
#	mov		8(%esp), %edx
#	mov		12(%esp), %ebx
#
#start:
#	mov		$0, %ecx
#	movl	(%ebx), %eax
#	movb	(%ebx), %bl
#
#loop:
#	cmp		$5, %ecx
#	je		next	
#	cmpb	%bl, 0x03
#	je		end
#	inc		%ecx
#	add		$1, %ebx
#	movb	(%ebx), %bl
#	jmp		loop
#
#next:
#	movl	%eax, (%edx)
#	add		$4, %edx
#	jmp		start
#
#end:
#	movl	%eax, (%edx)
#	movl	%edx, %eax
#	popl	%ebp
#	ret

#_mystrcpy:
#	push	%ebp
#	movl	8(%esp), %edx
#	mov		12(%esp), %ebx
#	movl	(%ebx), %eax
#	movb	(%ebx), %bl
#
#start:
#	cmpb	%bl, 0x00
#	jne		loop
#
#CheckNull:
#	add		$1, %ebx
#	movl	(%ebx), %eax
#	movb	(%ebx), %bl
#	cmpb	%bl, 0x00
#	je 		CheckNull
#	jmp		end
#
#loop:
#	movl	%eax, (%edx)
#	add		$4, %ebx
#	movl	(%ebx), %eax
#	movb	(%ebx), %bl
#	jmp		start	
#	
#end:
#	movl	%edx, %eax
#	popl	%ebp
#	ret



#_mystrcpy:
#	pushl	%ebp
#	movl	8(%esp), %ecx
#	movl	12(%esp), %eax
#	movl	(%eax), %edx
#	movl	%edx, (%ecx)
#	movl	(%eax), %edx
#	movl	%edx, (%ecx)
#	movl	(%eax), %edx
#	movl	%edx, (%ecx)
#	movl	%ecx, %eax
#	popl	%ebp
#	ret
