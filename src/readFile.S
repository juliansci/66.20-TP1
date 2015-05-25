#include <mips/regdef.h>
#include <sys/syscall.h>

# a0 = buffer
# a1 = bufIncrSize
# a2 = filePointer

	.text
	.align	2
	.globl	readFile
	.ent	readFile

readFile:
	.frame	$fp, 32, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	#creo stack frame
	subu	sp, sp, 32
	# Guardo $gp y $fp en SRA
	.cprestore 16
    sw 		$fp, 20(sp)
    sw 		ra, 24(sp)
    move 	$fp,sp
    sw		a0, 32($fp)
    sw 		a1, 36($fp)
    sw 		a2, 40($fp)
    
    #read from file
#	li 		v0, 14       # system call for read from file
#	lw 		a0, 40($fp)  # file pointer
#	lw 		a1, 32($fp)  # address of buffer to which to read
#	lw 		a2, 36($fp)  # buffer length
#	syscall         # read from file
	
	jal fgets         # Call fgets.
	
	lw 		gp, 16(sp)
	lw 		$fp, 20(sp)
	lw 		ra, 24(sp)
	addu 	sp,sp,32
	jr		ra
	.end readFile
    
    
    
