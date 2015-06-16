#include <mips/regdef.h>
#include <sys/syscall.h>

#
# params: recibe la linea original, el tamaño de la linea original y el byte a concatenar
# Devuelve la direccion a la nueva linea. Y libera la memoria de la linea original
#
# a0 = originalLine address
# a1 = originalSize
# a2 = byteToConcat

#sizes
ABA_SIZE = 16	# es non-leaf (llama a mymalloc y myfree)
LTA_SIZE = 8	# a verificar
SRA_SIZE = 16	# gp, fp y ra
FRAME_SIZE = ABA_SIZE + LTA_SIZE + SRA_SIZE

#offsets
LTA_OFFSET = ABA_SIZE
NEW_LINE_ADDRESS_OFFSET = LTA_OFFSET
INDEX_OFFSET = LTA_OFFSET + 4

SRA_OFFSET = LTA_OFFSET + LTA_SIZE
GP_OFFSET = SRA_OFFSET
FP_OFFSET = SRA_OFFSET + 4
RA_OFFSET = SRA_OFFSET + 8

ORIG_LINE_ADDRESS_OFFSET = FRAME_SIZE
ORIG_SIZE_OFFSET = FRAME_SIZE + 4
BYTE_TO_CONCAT_OFFSET = FRAME_SIZE + 8

.text
	.align	2
	.globl	concatByte
	.ent	concatByte

concatByte:
	.frame	$fp, FRAME_SIZE, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	#creo stack frame
	subu	sp, sp, FRAME_SIZE
	# Guardo $gp y $fp en SRA
	.cprestore GP_OFFSET
    sw 		$fp, FP_OFFSET(sp)
    sw 		ra, RA_OFFSET(sp)
    move 	$fp,sp
    sw 		a0, ORIG_LINE_ADDRESS_OFFSET($fp)
    sw		a1, ORIG_SIZE_OFFSET($fp)
    sw		a2, BYTE_TO_CONCAT_OFFSET($fp)
    #termine inicializacion

_allocNewLine:
	#alloco memoria para la nueva linea
	lw 		a0, ORIG_SIZE_OFFSET($fp) 	#recupero el tamaño de la linea original
	addi	a0, a0, 1					#le sumo 1 (del byte a concatenar)
	la		t9, mymalloc				#llamo a malloc
	jal		ra, t9
	sw		v0, NEW_LINE_ADDRESS_OFFSET($fp)	#guardo puntero a new line

_copyOriginalLine:
	#copio la linea original en la nueva
	li		t0, 0						# t0 = index
	sw		t0, INDEX_OFFSET($fp)
_for:
	lw		t0, INDEX_OFFSET($fp)		# t0 = index
	lw		t1, ORIG_SIZE_OFFSET($fp)	# t1 = originalSize
	bge		t0, t1, _copyNewByte		# si (index >= originalSize) termine la iteracion

	lw		t2, ORIG_LINE_ADDRESS_OFFSET($fp)  # t2 = &originalLine[0]
	addu	t2, t2, t0					# t2 = 	&originalLine[index]
	lb		t3, 0(t2)					# t3 = byte en originalLine[index]

	lw		t4, NEW_LINE_ADDRESS_OFFSET($fp)	# t4 = &newLine[0]
	addu	t4, t4, t0					# t4 = &newLine[index]
	sb		t3, 0(t4)					# guardo el byte en newLine

	addi	t0, t0, 1					# index++
	sw		t0, INDEX_OFFSET($fp)
	j		_for

_copyNewByte:
	lw		t1, ORIG_SIZE_OFFSET($fp)			# t1 = originalSize
	lw		t4, NEW_LINE_ADDRESS_OFFSET($fp)	# t4 = &newLine[0]
	addu	t4, t4, t1							# t4 = &newLine[originalSize]

	lb		t5, BYTE_TO_CONCAT_OFFSET($fp)		# t5 = byteToConcat
	sb		t5, 0(t4)							# guardo el byteToConcat al final de newLine

	#libero originalLine si existia
	lw		t1, ORIG_SIZE_OFFSET($fp)			# t1 = originalSize
	beq		t1, zero, _return					# si (originalSize == 0), originalLine no existia

	# libero originalLine
	lw		a0, ORIG_LINE_ADDRESS_OFFSET($fp)
	la		t9, myfree
	jal		ra, t9

_return:
	lw		v0, NEW_LINE_ADDRESS_OFFSET($fp)
	lw 		gp, GP_OFFSET(sp)
	lw 		$fp, FP_OFFSET(sp)
	lw 		ra, RA_OFFSET(sp)
	addu 	sp,sp,FRAME_SIZE
	jr		ra

	.end		concatByte
