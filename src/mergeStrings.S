#include <mips/regdef.h>
#include <sys/syscall.h>

# a0: char* string1 -> t0
# a1: size_t len1 -> t1
# a2: char* string2 -> t2
# a3: size_t len2 -> t3

	.text
	.align		2

	.globl		mergeStrings
	.ent		mergeStrings
mergeStrings:
#creo frame
	.frame		$fp, 56, ra   # 4(SRA) + 0(FPA) + 6(LTA) + 4(ABA) (non-leaf function, llama a mymalloc)
	.set		noreorder
	.cpload		t9
	.set		reorder
	subu		sp, sp, 56

# guardo callee-saved registers
	.cprestore 	40 		# guardo gp
	sw			$fp, 44(sp)
	move		$fp, sp
	sw 			ra, 48($fp)
#guardo a0,a1,a2,a3 en el ABA de mi caller
	sw 			a0, 56($fp)
	sw 			a1, 60($fp)
	sw 			a2, 64($fp)
	sw 			a3, 68($fp)

	move 		t0, a0
	sw			t0, 16($fp)		# string1
	move 		t1, a1
	sw			t1, 20($fp)		# len1
	move 		t2, a2
	sw			t2, 24($fp)		# string2
	move 		t3, a3
	sw			t3, 28($fp)		# len2

allocMemory:
	addu		t4, t1, t3		# t4 = len1 + len2. pos 32
	sw			t4, 32($fp)
	addiu		t4, t4, 1		# t4 <- t4 +1
	move 		a0, t4			# cantidad de bytes a allocar
	la			t9, mymalloc
	jal			ra, t9
	sw			v0, 36($fp)		# dir(concat) = address allocated memory. pos 36

copyString1:
	move		t6, zero		# t6 = i
	lw			t0, 16($fp)		# t0 = &string1
	lw			t1, 20($fp)		# t1 = len1
	lw			t5, 36($fp)		# t5 = &concat
_forString1:
	bge 		t6, t1, copyString2		# si (i >= len1) voy a copyString2

	addu		t7, t0, t6		# t7 = &string1[i]
	lb 			t8, 0(t7) 		# t8 = string1[i]

	addu		t7, t5, t6		# t7 = &concat[i]
	sb			t8, 0(t7)		# concat[i] <- string1[i]

	addiu		t6, t6, 1		# i++
	j			_forString1

copyString2:
	move		t6, zero		# t6 = i
	lw			t2, 24($fp)		# t2 = &string2
	lw			t3, 28($fp)		# t3 = len2
	lw			t5, 36($fp)		# t5 = &concat
	lw			t1, 20($fp)		# t1 = len1
_forString2:
	bge 		t6, t3, endMerge		# si (i >= len2) voy a endMerge
	addu		t7, t2, t6		# t7 = &string2[i]
	lb			t8, 0(t7)		# t8 = string2[i]

	addu 		t7, t6, t1		# t7 = j <- i + len1
	addu		t7, t5, t7		# t7 = &concat[j]
	sb 			t8, 0(t7)		# concat[j] = string2[i]

	addiu		t6, t6, 1		#i++
	j			_forString2

endMerge:
	lw			t5, 36($fp)		# t5 = dir(concat)
	lw			t4, 32($fp)		# t4 = len1 + len2
	addu		t7, t5, t4		# t7 = &concat[len1+len2]
	sb			zero, 0(t7)		# concat[len1+len2] = 0
	lw			v0, 36($fp)		# devuelvo dir(concat)

return:
	# Restauro callee-saved regs
	lw 			gp, 40(sp)
	lw 			$fp, 44(sp)
	lw 			ra, 48(sp)

# Destruimos el frame.
	addu		sp, sp, 56

# Retorno.
	jr			ra
	.end		mergeStrings

