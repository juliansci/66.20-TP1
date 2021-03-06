#include <mips/regdef.h>
#include <sys/syscall.h>

# params: a0 = fileDescriptor

#sizes
ABA_SIZE = 16	# 4 words
LTA_SIZE = 32	# 8 words
SRA_SIZE = 16	# 4 words
FRAME_SIZE = ABA_SIZE + LTA_SIZE + SRA_SIZE

#offsets
LTA_OFFSET = ABA_SIZE
LINE_COUNTER_OFFSET = LTA_OFFSET 				# 16
ARRAY_LINES_ADDRESS_OFFSET = LTA_OFFSET + 4  	# 20
LAST_READ_LINE_ADDRESS_OFFSET = LTA_OFFSET + 8

SRA_OFFSET = LTA_OFFSET + LTA_SIZE
GP_OFFSET = SRA_OFFSET
FP_OFFSET = SRA_OFFSET + 4
RA_OFFSET = SRA_OFFSET + 8

FILE_DESCRIPTOR_OFFSET = FRAME_SIZE


	.text
	.align	2

	.globl	tacFile
	.ent	tacFile
tacFile:
	.frame	$fp,FRAME_SIZE,ra		#informacion de debugging. Sf de 64 (4 ABA + 8 LTA + 4 SRA)
	.set	noreorder		#codigo PIC
	.cpload	t9				#codigo PIC
	.set	reorder			#codigo PIC
	#creo stack frame
	subu	sp,sp,FRAME_SIZE
	# Guardo $gp, $fp y ra en SRA
	.cprestore GP_OFFSET			#guardo gp
	sw 		$fp, FP_OFFSET(sp)
    sw 		ra, RA_OFFSET(sp)
    move 	$fp,sp
	sw 		a0, FILE_DESCRIPTOR_OFFSET($fp)
	
	li		t0, 0			# t0 = lineCounter
	sw 		t0, LINE_COUNTER_OFFSET($fp)		#guardo lineCounter en (fp + 16)

	# alloc arrayLines con 1 posicion
	li 		a0,1
	la		t9,mymalloc		#llamo a malloc
	jal		ra,t9
	sw		v0,ARRAY_LINES_ADDRESS_OFFSET($fp)		#obtengo puntero a arrayLines y lo guardo en (fp + 20)


cond_while: 
	# leo del archivo
	lw		a0,FILE_DESCRIPTOR_OFFSET($fp)	#recupero el fileDescriptor
	la		t9,readFile
	jal		ra,t9
	sw		v0, LAST_READ_LINE_ADDRESS_OFFSET($fp)

	bne		v0,zero,bloque_while	# si (v0!=0) => entra a bloque_while
	b		end

bloque_while: 
	sw	v0,24($fp)		#guardo nuevo puntero a line en (fp + 24)

	addu	a0,$fp,16		#&lineCounter
	lw	a1,20($fp)		#arrayLines
	addu	a2,$fp,24		#&line
	la	t9,storeNewLine		#llamo a storeNewLine
	jal	ra,t9	
	sw	v0,20($fp)
	
	b	cond_while
end: 

	lw	a0,16($fp)		#carga en a0 lineCounter que esta en (fp + 16)
	lw	a1,20($fp)		#carga en a1 arrayLines que esta en (fp + 20)
	la	t9,printLines		#llamo a printLines
	jal	ra,t9

	lw	a0,20($fp)		#carga en a0 arrayLines que esta en (fp + 20)
	la	t9,myfree		#llamo a myfree
	jal	ra,t9

	li 	v0,1

	lw	gp,48(sp)		#restauro gp (sp + 48)
	lw	ra,56(sp)		#restauro ra (sp + 56)
	lw	$fp,52(sp)		#restauro fp (sp + 52)
	addu	sp,sp,FRAME_SIZE		#destruyo stack frame
        jr 	ra

	.end	tacFile

	.rdata
	.align 2
