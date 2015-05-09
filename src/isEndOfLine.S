#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2

	.globl	isEndOfLine
	.ent	isEndOfLine
isEndOfLine:
	.frame	$fp, 16, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp, sp, 16
	.cprestore 0
	sw	$fp, 4(sp)
	move	$fp, sp
	# Use v0 for the result.
	li	v0, 0
	# el codigo ascii de new line es 10
	li	t0, 10
	beq a0, t0, endOfLineTrue
	li	v0, 0
	j	isEndOfLine_return
endOfLineTrue:
	li	v0, 1
	j	isEndOfLine_return

isEndOfLine_return:
	# Destruimos el frame.
	#
	lw	$fp, 4(sp)
	addu	sp, sp, 16

	# Retorno.
	#
	j	ra
	.end	isEndOfLine
