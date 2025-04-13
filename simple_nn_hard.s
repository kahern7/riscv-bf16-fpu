	.file	"modified_nn_float.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	relu
	.type	relu, @function
relu:
	fmv.s.x	fa5,zero
	fgt.s	a5,fa0,fa5
	beq	a5,zero,.L8
	ret
.L8:
	fmv.s	fa0,fa5
	ret
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
	.align	1
	.globl	init_weights
	.type	init_weights, @function
init_weights:
	ble	a1,zero,.L10
	lui	a5,%hi(.LC0)
	flw	fa3,%lo(.LC0)(a5)
	lui	t5,%hi(seed)
	lui	a5,%hi(.LC1)
	lw	a3,%lo(seed)(t5)
	flw	fa4,%lo(.LC1)(a5)
	slli	a6,a1,2
	li	t3,1103515648
	li	t1,12288
	li	a7,32768
	mv	a4,a0
	add	a6,a6,a0
	addiw	t3,t3,-403
	addiw	t1,t1,57
	addi	a7,a7,-1
	li	t4,2000
.L12:
	mulw	a3,a3,t3
	addi	a4,a4,4
	addw	a3,a3,t1
	srliw	a5,a3,16
	and	a5,a5,a7
	remuw	a5,a5,t4
	fcvt.s.w	fa5,a5
	fdiv.s	fa5,fa5,fa3
	fsub.s	fa5,fa5,fa4
	fsw	fa5,-4(a4)
	bne	a6,a4,.L12
	addiw	a1,a1,-1
	slli	a5,a1,32
	srli	a1,a5,30
	sw	a3,%lo(seed)(t5)
	add	a0,a0,a1
	fsw	fa5,0(a0)
.L10:
	ret
	.size	init_weights, .-init_weights
	.align	1
	.globl	neural_network_forward
	.type	neural_network_forward, @function
neural_network_forward:
	lui	a7,%hi(seed)
	lw	a5,%lo(seed)(a7)
	li	a0,1103515648
	addiw	a0,a0,-403
	mulw	a5,a0,a5
	li	a2,12288
	addiw	a2,a2,57
	lui	a4,%hi(.LC0)
	flw	fa2,%lo(.LC0)(a4)
	li	a3,32768
	lui	a4,%hi(.LC1)
	flw	fa3,%lo(.LC1)(a4)
	addi	a3,a3,-1
	li	a6,2000
	addw	a5,a5,a2
	mulw	a4,a5,a0
	srliw	a5,a5,16
	and	a5,a5,a3
	fmv.s.x	fa1,zero
	addi	sp,sp,-16
	remuw	a5,a5,a6
	addw	a4,a4,a2
	srliw	a1,a4,16
	and	a1,a1,a3
	remuw	a1,a1,a6
	fcvt.s.w	fa4,a5
	fdiv.s	fa4,fa4,fa2
	fsub.s	fa4,fa4,fa3
	fadd.s	fa4,fa4,fa1
	mulw	a5,a4,a0
	fcvt.s.w	fa5,a1
	fdiv.s	fa5,fa5,fa2
	addw	a5,a5,a2
	srliw	a4,a5,16
	and	a4,a4,a3
	remuw	a4,a4,a6
	sw	a5,%lo(seed)(a7)
	lui	a5,%hi(.LC2)
	flw	fa0,%lo(.LC2)(a5)
	fsub.s	fa5,fa5,fa3
	fmadd.s	fa5,fa5,fa0,fa4
	fgt.s	a5,fa5,fa1
	fcvt.s.w	fa4,a4
	fdiv.s	fa4,fa4,fa2
	fsub.s	fa4,fa4,fa3
	bne	a5,zero,.L15
	fmv.s	fa5,fa1
.L15:
	fmv.s.x	fa3,zero
	fmadd.s	fa5,fa5,fa4,fa3
	fgt.s	a5,fa5,fa3
	bne	a5,zero,.L17
	fmv.s	fa5,fa3
.L17:
	fsw	fa5,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	neural_network_forward, .-neural_network_forward
	.align	1
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-16
	sd	ra,8(sp)
	call	neural_network_forward
.L23:
	j	.L23
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
