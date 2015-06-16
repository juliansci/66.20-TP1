#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align		2

	.globl		isEndOfLine
	.ent		isEndOfLine
isEndOfLine:
#creo frame
	.frame		$fp, 8, ra   # 2(SRA) + 0(FPA) + 0(LTA) + 0(ABA) (leaf function)
	.set		noreorder
	.cpload		t9
	.set		reorder
	subu		sp, sp, 8
# guardo registros
	.cprestore 	0
	sw			$fp, 4(sp)
	move		$fp, sp
	sw 			a0, 8($fp) 		#guardo el primer argumento en el ABA de mi caller

	# Use v0 for the result.
	li			v0, 0
	# el codigo ascii de new line es 10
	li			t0, 10
	beq 		a0, t0, endOfLineTrue
	li			v0, 0
	j			isEndOfLine_return
endOfLineTrue:
	li			v0, 1
	j			isEndOfLine_return

isEndOfLine_return:
	# Destruimos el frame.
	# Restauro callee-saved regs
	lw			$fp, 4(sp)
	lw			gp, 0(sp)
	addu		sp, sp, 8

	# Retorno.
	#
	jr			ra
	.end		isEndOfLine
