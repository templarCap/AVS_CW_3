.globl	main
	.type	main, @function
main:
	push	rbx	
	movsd	xmm3, QWORD PTR .LC1[rip]	# 
	mov	ebx, edi                    #
	movsd	xmm1, QWORD PTR .LC2[rip]	#
	movsd	xmm2, QWORD PTR .LC9[rip]	# double result = methodChord(from, to, eps)
	movapd	xmm0, xmm3	            #
	call	methodChord@PLT	          #
	mov	rax, QWORD PTR .LC2[rip]	
	xor	edi, edi	# 
	cmp	ebx, 1	  # int file = argc != 1 ? 1 : 0
	setne	dil	    #
	movq	xmm2, rax	              #
	mov	rax, QWORD PTR .LC1[rip]	# print(result, file, from, to)
	movq	xmm1, rax	              #
	call	print@PLT	              #
	xor	eax, eax
	pop	rbx	
	ret	
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC2:
	.long	0
	.long	1074266112
	.align 8
.LC9:
	.long	-1998362383
	.long	1055193269
