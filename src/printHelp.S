#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2
	.globl	printHelp
	.ent	printHelp
printHelp:
	.frame	$fp,40,ra	#4SRA + 2LTA + 4ABA
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu 	sp,sp,40
	.cprestore 24
	sw	$fp,28(sp) 
	sw	ra,32(sp)
	move 	$fp, sp
	la 	a0, msg
	la	t9, strLength
	jal	ra, t9

	move	t0, v0
	sw	t0,16($fp)
	li	v0, SYS_write 
	li	a0, 1         
	la	a1, msg   
	lw	t0,16($fp)
	move	a2, t0     
	syscall
	
	lw	$fp,28(sp)
	lw	ra,32(sp)
	lw	gp,24(sp)
	addu	sp,sp,40
	jr	ra
	.end	printHelp

	.rdata
msg:
	.asciiz	"Usage:\n	tp0 -h\n	tp0 -V\n	tp0 [file...]\nOptions:\n	-V, --version Print version and quit.\n	-h, --help Print this information and quit.\nExamples:\n	tp0 foo.txt bar.txt\n	tp0 gz.txt\n"
