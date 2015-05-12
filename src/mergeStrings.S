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
	.frame		$fp, 56, ra   # 4(SRA) + 0(FPA) + 6(LTA) + 4(ABA) (leaf function)
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
	li 			v0, 9          	# codigo de system call para allocar heap memory
	move 		a0, t4			# cantidad de bytes a allocar
	syscall						# v0 contains address of allocated memory
	sw			v0, 36($fp)		# dir(concat) = address allocated memory. pos 36

copyString1:
	move		t6, zero		# t6 = charIndex de string1
	lw			t0, 16($fp)		# t0 = string1
	lw			t1, 20($fp)		# t1 = len1
	lw			t5, 36($fp)		# t5 = address a escribir
_forString1:
	addu		t7, t0, t6		# t7 = address a leer <- string1[charIndex]
	lb 			t8, 0(t7) 		# t8 = char leido de t7
	sb			t8, 0(t5)		# escribo el char en t5 (en heap)
	addiu		t6, t6, 1		# charIndex <- charIndex + 1
	addiu		t5, t5, 1		# address <- address + 1
	subu		t4, t1, t6		# t4 <- len1 - charIndex
	blez 		t4, copyString2		# si (t4 <= 0) voy a copyString2
	j			_forString1

copyString2:
	move		t6, zero		# t6 = charIndex de string2
	lw			t2, 24($fp)		# t2 = string2
	lw			t3, 28($fp)		# t3 = len2
	lw			t5, 36($fp)		# t5 = dir(concat)
	lw			t1, 20($fp)		# t1 = len1
	addu		t5, t5, t1		# t5 = address a escribir <- dir(concat) + len1
_forString2:
	addu		t7, t2, t6		# t7 = address a leer <- string2[charIndex]
	lb			t8, 0(t7)		# t8 = char leido de t7
	sb			t8, 0(t5)		# escribo el char en t5 (en heap)
	addiu		t6, t6, 1		# charIndex <- charIndex + 1
	addiu		t5, t5, 1		# address <- address + 1
	subu		t4, t3, t6		# t4 <- len2 - charIndex
	blez 		t4, endMerge		# si (t4 <= 0) voy a endMerge
	j			_forString2

endMerge:
	lw			t5, 36($fp)		# t5 = dir(concat)
	lw			t4, 32($fp)		# t4 = len1 + len2
	addu		t5, t5, t4		# address a escribir <- dir(concat) + len1 + len2
	addu		t8, zero, zero	# t8 <- zero (fin de string)
	sb			t8, 0(t5)		# escribo el char en t5 (en heap)
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


