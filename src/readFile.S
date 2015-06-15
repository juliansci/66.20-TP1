#include <mips/regdef.h>
#include <sys/syscall.h>

# retorna la cantidad de bytes leidos

# a0 = buffer
# a1 = bufIncrSize
# a2 = fileDescriptor

#
#constants
#
NEW_LINE_ASCII = 10

#sizes
ABA_SIZE = 16
LTA_SIZE = 16
SRA_SIZE = 16
FRAME_SIZE = ABA_SIZE + LTA_SIZE + SRA_SIZE

#offsets
LTA_OFFSET = ABA_SIZE
TOTAL_BYTES_READ_OFFSET = LTA_OFFSET
LAST_READ_CHAR_OFFSET = LTA_OFFSET + 4
BYTE_READ_OFFSET = LTA_OFFSET + 8

SRA_OFFSET = LTA_OFFSET + LTA_SIZE
GP_OFFSET = SRA_OFFSET
FP_OFFSET = SRA_OFFSET + 4
RA_OFFSET = SRA_OFFSET + 8

BUFFER_OFFSET = FRAME_SIZE
BUFF_INCR_SIZE_OFFSET = FRAME_SIZE + 4
FILE_DESCRIPTOR_OFFSET = FRAME_SIZE + 8


	.text
	.align	2
	.globl	readFile
	.ent	readFile

readFile:
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
    sw		a0, BUFFER_OFFSET($fp)
    sw 		a1, BUFF_INCR_SIZE_OFFSET($fp)
    sw 		a2, FILE_DESCRIPTOR_OFFSET($fp)
    
clearBuffer:
	lw		a0, BUFFER_OFFSET($fp)
	lw 		a1, BUFF_INCR_SIZE_OFFSET($fp)
	li		t0, 0 		# t0 = i
_forBuffer:
    bgeu 	t0, a1, readToBuffer	# si (i >= bufIncrSize) voy a read
    addu	t1, a0, t0		# t1 = &buffer + i
    sb		zero, 0(t1)		# buffer[i] = 0
    addiu	t0, t0, 1		# i++
    j _forBuffer

readToBuffer:
	lw 		t1, BUFF_INCR_SIZE_OFFSET($fp)	# t1 = cantidad maxima de bytes a leer
	li		t0, 0							# t0 = i
	sw		t0, TOTAL_BYTES_READ_OFFSET($fp)

_forRead:
	lw		t0, TOTAL_BYTES_READ_OFFSET($fp)
	lw 		t1, BUFF_INCR_SIZE_OFFSET($fp)
	bgeu 	t0, t1, _endRead	# si (i >= bufIncrSize) termino de leer

	#alloco memoria para leer un byte
	li 	a0, 1
	la	t9, mymalloc		#llamo a malloc
	jal	ra, t9
	sw	v0, BYTE_READ_OFFSET($fp)		#obtengo puntero al byte

	#read from file
	li 		v0, SYS_read      				 # system call for read from file
	lw 		a0, FILE_DESCRIPTOR_OFFSET($fp)  	# file descriptor
	lw		a1, BYTE_READ_OFFSET($fp)			# byte buffer
	li 		a2, 1								# buffer length
	syscall 					        # read from file
	# si devuelve 0, termino de leer
	beq		v0, zero, _freeAndEndRead

	#recupero el byte leido
	lw		t2, BYTE_READ_OFFSET($fp)	# t2 = direccion del byte leido
	lb		t3, 0(t2)					# t3 = byte leido

	#guardo el byte leido en el lugar correspondiente del buffer
	lw		t0, TOTAL_BYTES_READ_OFFSET($fp) # t0 = i
	lw		t4, BUFFER_OFFSET($fp)
	addu	t4, t4, t0
	sb		t3, 0(t4)					# buffer[i] <- byte leido

	# i++
	lw		t0, TOTAL_BYTES_READ_OFFSET($fp)
	addi	t0, t0, 1
	sw		t0, TOTAL_BYTES_READ_OFFSET($fp)

	#recupero el byte leido y lo comparo con newLine
	lw		t2, BYTE_READ_OFFSET($fp)	# t2 = direccion del byte leido
	lb		t3, 0(t2)					# t3 = byte leido
	li 		t5, NEW_LINE_ASCII
	beq		t3, t5, _freeAndEndRead

	# libero el byte de lectura
	lw	a0, BYTE_READ_OFFSET($fp)
	la	t9, myfree
	jal	ra, t9

	j		_forRead

_freeAndEndRead:
	# libero el byte de lectura
	lw	a0, BYTE_READ_OFFSET($fp)
	la	t9, myfree
	jal	ra, t9

_endRead:
	lw		v0, TOTAL_BYTES_READ_OFFSET($fp)
	lw 		gp, GP_OFFSET(sp)
	lw 		$fp, FP_OFFSET(sp)
	lw 		ra, RA_OFFSET(sp)
	addu 	sp,sp,FRAME_SIZE
	jr		ra


	.end readFile
    
  	.rdata
