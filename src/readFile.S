#include <mips/regdef.h>
#include <sys/syscall.h>

# params: a0 = fileDescriptor
# retorna la direccion de la linea, o 0 si no leyo nada

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
BYTE_READ_OFFSET = LTA_OFFSET + 4
LINE_READ_OFFSET = LTA_OFFSET + 8

SRA_OFFSET = LTA_OFFSET + LTA_SIZE
GP_OFFSET = SRA_OFFSET
FP_OFFSET = SRA_OFFSET + 4
RA_OFFSET = SRA_OFFSET + 8

FILE_DESCRIPTOR_OFFSET = FRAME_SIZE


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
	# Guardo $gp, $fp y ra en SRA
	.cprestore GP_OFFSET
    sw 		$fp, FP_OFFSET(sp)
    sw 		ra, RA_OFFSET(sp)
    move 	$fp,sp
    sw 		a0, FILE_DESCRIPTOR_OFFSET($fp)
    
readToBuffer:
	li		t0, 0							# t0 = i
	sw		t0, TOTAL_BYTES_READ_OFFSET($fp)

_forRead:
	#alloco memoria para leer un byte
	li 		a0, 1
	la		t9, mymalloc		#llamo a malloc
	jal		ra, t9
	sw		v0, BYTE_READ_OFFSET($fp)		#obtengo puntero al byte

	#read from file
	li 		v0, SYS_read      				 # system call for read from file
	lw 		a0, FILE_DESCRIPTOR_OFFSET($fp)  	# file descriptor
	lw		a1, BYTE_READ_OFFSET($fp)			# byte buffer
	li 		a2, 1								# buffer length
	syscall 					        	# read from file
	# si devuelve 0, termino de leer
	beq		v0, zero, _freeAndEndRead

	#
	#concateno el byte leido a lo que ya tengo
	#
		#recupero la direccion de lo que ya tengo leido
	lw 		a0, LINE_READ_OFFSET($fp)
		#recupero la cantidad de bytes leidos (sin contar el ultimo)
	lw		a1, TOTAL_BYTES_READ_OFFSET($fp)
		#recupero el byte leido
	lw		t2, BYTE_READ_OFFSET($fp)	# t2 = direccion del byte leido
	lb		a2, 0(t2)					# byte leido
		#llamo a la funcion para concatenar, que me devuelve la direccion de la nueva linea (y libera la anterior)
	la		t9, concatByte
	jal		ra, t9
	sw		v0, LINE_READ_OFFSET($fp)

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
	lw		a0, BYTE_READ_OFFSET($fp)
	la		t9, myfree
	jal		ra, t9

	j		_forRead

_freeAndEndRead:
	# libero el byte de lectura
	lw		a0, BYTE_READ_OFFSET($fp)
	la		t9, myfree
	jal		ra, t9

_endRead:
	lw		t0, TOTAL_BYTES_READ_OFFSET($fp)
	beq		t0, zero, _returnZero
	lw		v0, LINE_READ_OFFSET($fp)	#retorna la direccion de la linea
	j		_return

# si leyo 0 bytes, retorna 0
_returnZero:
	move	v0, zero
	j		_return

_return:
	lw 		gp, GP_OFFSET(sp)
	lw 		$fp, FP_OFFSET(sp)
	lw 		ra, RA_OFFSET(sp)
	addu 	sp,sp,FRAME_SIZE
	jr		ra


	.end readFile
    
  	.rdata
