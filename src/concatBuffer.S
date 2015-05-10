#include <mips/regdef.h>
#include <sys/syscall.h>

# en LTA guardo: line, lineLength, buffer, bufferLength, ¿concatAddress?

	.text
	.align		2

	.globl		concatBuffer
	.ent		concatBuffer
concatBuffer:
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
#guardo a0 y a1 en el ABA de mi caller
	sw 			a0, 56($fp)
	sw 			a1, 60($fp)

lineLength:
	move 		t0, a0			# t0 = line. pos 16
	sw 			t0, 16($fp)
	move 		t1, zero		# t1 = lineLength. pos 20
	sw 			t1, 20($fp)
	beq 		t0, zero, bufferLength 	#si line esta vacio, queda lineLength en 0
	move 		a0, t0
	la			t9, strLength
	jal			ra, t9
	move 		t1, v0			# guardo en t1 lo que devolvio strLength
	sw 			t1, 20($fp)

bufferLength:
	move 		t2, a1			# t2 = buffer. pos 24
	sw 			t2, 24($fp)
	move 		t3, zero		# t3 = bufferLength. pos 28
	sw 			t3, 28($fp)
	beq 		t2, zero, concat # si buffer esta vacio, queda bufferLength en 0
	move 		a0, t2
	la			t9, strLength
	jal			ra, t9
	move 		t3, v0			# guardo en t3 lo que devolvio strLength
	sw 			t3, 28($fp)
	bne 		t3, zero, concat
	lw 			v0, 16($fp)		# si bufferLength es 0, devuelvo line
	j			return

concat:
	lw			a0, 16($fp)		# string 1
	lw 			a1, 20($fp)		# len1
	lw 			a2, 24($fp)		# string 2
	lw 			a3, 28($fp)		# len2
	la			t9, mergeStrings
	jal			ra, t9
	j			return			# ya tengo guardado en v0 el string a retornar


#	addu		t4, t1, t3		# t4 = largo total
#	addiu		t4, t4, 1		# le agrega una posicion mas
#	li 			v0, 9          	# codigo de system call para allocar heap memory
#	move 		a0, t4			# cantidad de bytes a allocar
#	syscall
#	sw			v0, 32($fp)		# address de concat guardado en 32($fp)
#	move		t5, zero		# t5 = charIndex de line



return:
# Restauro callee-saved regs
	lw 			gp, 40(sp)
	lw 			$fp, 44(sp)
	lw 			ra, 48(sp)

# Destruimos el frame.
	addu		sp, sp, 56

# Retorno.
	jr			ra
	.end		concatBuffer
