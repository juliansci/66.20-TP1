#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2
	.globl	printVersion
	.ent	printVersion
printVersion:
	.frame	$fp,32,ra	#3SRA + 1LTA + 4ABA
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu 	sp,sp,32
	.cprestore 20
	sw	$fp,24(sp) 
	sw	ra,28(sp)
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
	
	lw	$fp,24(sp)
	lw	ra,28(sp)
	lw	gp,20(sp)
	addu	sp,sp,32
	jr	ra
	.end	printVersion

	.rdata
msg:
	.asciiz	"tp1 1.1\nCopyright © 2015 FIUBA.\nEsto es software libre: usted es libre de cambiarlo y redistribuirlo.\nNo hay NINGUNA GARANTÍA, hasta donde permite la ley.\n\nEscrito por Julian Scialabba, Kaoru Heanna y Paula Saffioti.\n" 



