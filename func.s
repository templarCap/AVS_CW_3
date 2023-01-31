	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	func
	.type	func, @function
func:
	movapd	xmm1, xmm0	# x
	sub	rsp, 24	
	mulsd	xmm1, xmm0	              # 
	movsd	QWORD PTR 8[rsp], xmm0	  # pow(2, x*x + 1)
	movsd	xmm0, QWORD PTR .LC1[rip]	#
	addsd	xmm1, QWORD PTR .LC0[rip]	#
	call	pow@PLT	   # pow(2, x*x + 1)
	movsd	xmm2, QWORD PTR 8[rsp]	  # pow(2, x*x + 1) + x - 3;
	addsd	xmm0, xmm2	              # 
	subsd	xmm0, QWORD PTR .LC2[rip]	# 
	add	rsp, 24	
	ret	
	.size	func, .-func
	.globl	methodChord
	.type	methodChord, @function
methodChord:
	sub	rsp, 56	
	movapd	xmm3, xmm0	# prev
	pxor	xmm4, xmm4 # double next = 0
	movsd	QWORD PTR 40[rsp], xmm2	e
.L10:
	movapd	xmm0, xmm1	
	movsd	QWORD PTR 32[rsp], xmm4	# 
	movsd	QWORD PTR 16[rsp], xmm3	# func(curr)
	movsd	QWORD PTR 8[rsp], xmm1	# 
	call	func@PLT	
	movsd	xmm3, QWORD PTR 16[rsp]	# 
	movsd	xmm1, QWORD PTR 8[rsp]	# prev - curr
	movapd	xmm2, xmm0	          # 
	movapd	xmm0, xmm3	
	subsd	xmm0, xmm1	            #
	mulsd	xmm2, xmm0	            # func(prev)
	movapd	xmm0, xmm3	          #
	movsd	QWORD PTR 24[rsp], xmm2	#
	call	func@PLT	
	movsd	xmm1, QWORD PTR 8[rsp]	# 
	movsd	QWORD PTR 16[rsp], xmm0	# func(curr)
	movapd	xmm0, xmm1	          #
	call	func@PLT	
	movsd	xmm3, QWORD PTR 16[rsp]	# 
	movsd	xmm2, QWORD PTR 24[rsp]	# (func(curr) * (prev - curr) / (func(prev) - func(curr))
	movsd	xmm4, QWORD PTR 32[rsp]	# 
	movsd	xmm1, QWORD PTR 8[rsp]	# 
	subsd	xmm3, xmm0	  # 
	movapd	xmm5, xmm4	# next = 
	movapd	xmm4, xmm1	# 
	divsd	xmm2, xmm3	  #
	subsd	xmm4, xmm2
	comisd	xmm4, xmm5	# next > curr
	jbe	.L5	
	movapd	xmm0, xmm4	# 
	movapd	xmm3, xmm1	# next - curr
	subsd	xmm0, xmm5	  #
	comisd	xmm0, QWORD PTR 40[rsp]	# (next - curr) > e)
	jbe	.L5	
	movapd	xmm1, xmm5	
	jmp	.L10	
.L5:
	movapd	xmm0, xmm5	#
	movapd	xmm3, xmm1	# curr - next
	movapd	xmm1, xmm5	#
	subsd	xmm0, xmm4	
	comisd	xmm0, QWORD PTR 40[rsp]	# if (((curr - next) > e))
	ja	.L10	
	movapd	xmm0, xmm4
	add	rsp, 56	
	ret	
	.size	methodChord, .-methodChord
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"Previous interval is incorrect: (%d, %d)\n"
	.align 8
.LC5:
	.string	"Correct interval from %d to %d\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC6:
	.string	"%func "
.LC7:
	.string	"w"
.LC8:
	.string	"output.txt"
	.text
	.globl	print
	.type	print, @function
print:
	push	rbp	
	sub	rsp, 32	
	test	edi, edi	# if (!file)
	jne	.L13	      #
	comisd	xmm1, xmm0	# from > answer
	ja	.L14	# if (from > answer)
	comisd	xmm0, xmm2	# to < answer
	jbe	.L15	# if (to < answer)
.L14:
	cvttsd2si	ecx, xmm2	          # 
	lea	rsi, .LC4[rip]	          # 
	mov	edi, 1	                  # printf
	xor	eax, eax	                #
	cvttsd2si	edx, xmm1	          # 
	movsd	QWORD PTR 8[rsp], xmm0	# 
	call	__printf_chk@PLT	
	movsd	xmm0, QWORD PTR 8[rsp]	#
	lea	rsi, .LC5[rip]	          #
	xor	eax, eax	                # подготовка к выводу 
	mov	edi, 1	                  #
	cvttsd2si	edx, xmm0	          #
	lea	ecx, 1[rdx]	
	call	__printf_chk@PLT	
	movsd	xmm0, QWORD PTR 8[rsp]
.L15:
	add	rsp, 32	        #
	mov	edi, 1	        #
	mov	eax, 1	        #
	lea	rsi, .LC6[rip]	# printf
	pop	rbp	
	jmp	__printf_chk@PLT	
.L13:
	lea	rsi, .LC7[rip]	          # 
	lea	rdi, .LC8[rip]	          # 
	movsd	QWORD PTR 24[rsp], xmm2	# fout = fopen("output.txt", "w")
	movsd	QWORD PTR 16[rsp], xmm1	# 
	movsd	QWORD PTR 8[rsp], xmm0	# 
	call	fopen@PLT	              #
	movsd	xmm0, QWORD PTR 8[rsp]	# answer
	movsd	xmm1, QWORD PTR 16[rsp]	# from
	movsd	xmm2, QWORD PTR 24[rsp]	# to
	mov	rbp, rax	# fout = fopen("output.txt", "w");
	comisd	xmm1, xmm0	# from > answer
	ja	.L17	# if (from > answer)
	comisd	xmm0, xmm2	# to < answer
	jbe	.L18	# if (to < answer)
.L17:
	cvttsd2si	ecx, xmm1	
	lea	rdx, .LC4[rip]	          # 
	mov	rdi, rbp	                #
	xor	eax, eax	                #
	cvttsd2si	r8d, xmm2	          # fprintf
	mov	esi, 1	                  #
	movsd	QWORD PTR 8[rsp], xmm0	#
	call	__fprintf_chk@PLT	      #
	movsd	xmm0, QWORD PTR 8[rsp]	#
	mov	rdi, rbp	                # подготовка к выводу
	xor	eax, eax	                #
	lea	rdx, .LC5[rip]	          #
	mov	esi, 1	
	cvttsd2si	ecx, xmm0	
	lea	r8d, 1[rcx]	
	call	__fprintf_chk@PLT	
	movsd	xmm0, QWORD PTR 8[rsp]
.L18:
	mov	rdi, rbp	          #
	mov	esi, 1	            #
	mov	eax, 1	            # fprintf
	lea	rdx, .LC6[rip]	    #
	call	__fprintf_chk@PLT	#
	add	rsp, 32	
	mov	rdi, rbp	
	pop	rbp	 
	jmp	fclose@PLT	# fclose(fout)
	.size	print, .-print
