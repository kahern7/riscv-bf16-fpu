	.file	"modified_nn_float.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	__gtsf2
	.align	1
	.globl	relu
	.type	relu, @function
relu:
	addi	sp,sp,-16
	mv	a1,zero
	sd	s0,0(sp)
	sd	ra,8(sp)
	mv	s0,a0
	call	__gtsf2
	ble	a0,zero,.L6
	ld	ra,8(sp)
	mv	a0,s0
	ld	s0,0(sp)
	addi	sp,sp,16
	jr	ra
.L6:
	ld	ra,8(sp)
	ld	s0,0(sp)
	mv	a0,zero
	addi	sp,sp,16
	jr	ra
	.size	relu, .-relu
	.align	1
	.globl	simple_rand
	.type	simple_rand, @function
simple_rand:
	lui	a3,%hi(seed)
	lw	a4,%lo(seed)(a3)
	li	a5,1103515648
	addiw	a5,a5,-403
	mulw	a5,a5,a4
	li	a4,12288
	addiw	a4,a4,57
	addw	a5,a5,a4
	slli	a0,a5,33
	sw	a5,%lo(seed)(a3)
	srli	a0,a0,49
	ret
	.size	simple_rand, .-simple_rand
	.globl	__floatunsisf
	.globl	__divsf3
	.globl	__subsf3
	.align	1
	.globl	init_weights
	.type	init_weights, @function
init_weights:
	ble	a1,zero,.L15
	addi	sp,sp,-112
	lui	a5,%hi(seed)
	sd	s11,8(sp)
	lw	s11,%lo(seed)(a5)
	lui	a5,%hi(.LC0)
	sd	s7,40(sp)
	lw	s7,%lo(.LC0)(a5)
	lui	a5,%hi(.LC1)
	sd	s6,48(sp)
	lw	s6,%lo(.LC1)(a5)
	sd	s0,96(sp)
	sd	s1,88(sp)
	sd	s2,80(sp)
	sd	s3,72(sp)
	slli	s0,a1,2
	li	s3,1103515648
	li	s2,12288
	li	s1,32768
	sd	s4,64(sp)
	sd	s5,56(sp)
	sd	s8,32(sp)
	sd	s10,16(sp)
	sd	ra,104(sp)
	sd	s9,24(sp)
	mv	s4,a1
	mv	s8,a0
	mv	s10,a0
	add	s0,s0,a0
	addiw	s3,s3,-403
	addiw	s2,s2,57
	addi	s1,s1,-1
	li	s5,2000
.L12:
	mulw	s11,s11,s3
	addi	s10,s10,4
	addw	s11,s11,s2
	srliw	a0,s11,16
	and	a0,a0,s1
	remuw	a0,a0,s5
	call	__floatunsisf
	mv	a1,s7
	call	__divsf3
	mv	a1,s6
	call	__subsf3
	sw	a0,-4(s10)
	bne	s0,s10,.L12
	addiw	s4,s4,-1
	slli	a4,s4,32
	ld	ra,104(sp)
	ld	s0,96(sp)
	srli	s4,a4,30
	lui	a5,%hi(seed)
	sw	s11,%lo(seed)(a5)
	add	s8,s8,s4
	sw	a0,0(s8)
	ld	s1,88(sp)
	ld	s2,80(sp)
	ld	s3,72(sp)
	ld	s4,64(sp)
	ld	s5,56(sp)
	ld	s6,48(sp)
	ld	s7,40(sp)
	ld	s8,32(sp)
	ld	s9,24(sp)
	ld	s10,16(sp)
	ld	s11,8(sp)
	addi	sp,sp,112
	jr	ra
.L15:
	ret
	.size	init_weights, .-init_weights
	.globl	__addsf3
	.globl	__mulsf3
	.align	1
	.globl	neural_network_forward
	.type	neural_network_forward, @function
neural_network_forward:
	addi	sp,sp,-80
	lui	a3,%hi(seed)
	sd	s0,64(sp)
	lw	s0,%lo(seed)(a3)
	li	a5,1103515648
	addiw	a5,a5,-403
	mulw	s0,a5,s0
	li	a4,12288
	addiw	a4,a4,57
	sd	s1,56(sp)
	sd	s2,48(sp)
	li	s2,32768
	addi	s2,s2,-1
	sd	s6,16(sp)
	li	s6,2000
	sd	ra,72(sp)
	addw	s0,s0,a4
	mulw	s1,s0,a5
	sd	s3,40(sp)
	sd	s4,32(sp)
	sd	s5,24(sp)
	lui	s5,%hi(.LC0)
	lui	s4,%hi(.LC1)
	srliw	s0,s0,16
	addw	s1,s1,a4
	mulw	a5,s1,a5
	srliw	s1,s1,16
	and	s1,s1,s2
	addw	a5,a5,a4
	srliw	a0,a5,16
	and	a0,a0,s2
	remuw	a0,a0,s6
	sw	a5,%lo(seed)(a3)
	call	__floatunsisf
	lw	a1,%lo(.LC0)(s5)
	call	__divsf3
	lw	a1,%lo(.LC1)(s4)
	call	__subsf3
	mv	s3,a0
	and	a0,s0,s2
	remuw	a0,a0,s6
	call	__floatunsisf
	lw	a1,%lo(.LC0)(s5)
	call	__divsf3
	lw	a1,%lo(.LC1)(s4)
	call	__subsf3
	mv	a1,zero
	call	__addsf3
	mv	s0,a0
	remuw	a0,s1,s6
	call	__floatunsisf
	lw	a1,%lo(.LC0)(s5)
	call	__divsf3
	lw	a1,%lo(.LC1)(s4)
	call	__subsf3
	lui	a5,%hi(.LC2)
	lw	a1,%lo(.LC2)(a5)
	call	__mulsf3
	mv	a1,s0
	call	__addsf3
	mv	a1,zero
	mv	s0,a0
	call	__gtsf2
	bgt	a0,zero,.L19
	mv	s0,zero
.L19:
	mv	a1,s3
	mv	a0,s0
	call	__mulsf3
	mv	a1,zero
	call	__addsf3
	mv	a1,zero
	mv	s0,a0
	call	__gtsf2
	bgt	a0,zero,.L21
	mv	s0,zero
.L21:
	sw	s0,12(sp)
	ld	ra,72(sp)
	ld	s0,64(sp)
	ld	s1,56(sp)
	ld	s2,48(sp)
	ld	s3,40(sp)
	ld	s4,32(sp)
	ld	s5,24(sp)
	ld	s6,16(sp)
	addi	sp,sp,80
	jr	ra
	.size	neural_network_forward, .-neural_network_forward
	.align	1
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-16
	sd	ra,8(sp)
	call	neural_network_forward
.L27:
	j	.L27
	.size	_start, .-_start
	.globl	seed
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	1148846080
	.align	2
.LC1:
	.word	1065353216
	.align	2
.LC2:
	.word	1056964608
	.section	.sdata,"aw"
	.align	2
	.type	seed, @object
	.size	seed, 4
seed:
	.word	12345
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
