#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2
	.globl	printLines
	.ent	printLines

printLines:
	.frame	$fp,40,ra	
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu 	sp,sp,40
	.cprestore 24
	sw	$fp,28(sp) 
	sw	ra,32(sp)
	move 	$fp, sp

        sw      a0, 40($fp)
        sw      a1, 44($fp)
        move    t0, a0
        move    t1, a1
        subu    t0, t0, 1
        sw      t0, 16($fp)
        sll     t3, t0, 2   
        addu    t1, t1, t3  #Apunto a ultimo char*
        sw      t1, 20($fp)
_loop:  
        blt     t0, zero, _end_loop
        lw      t1, 20($fp)
        lw      t2, 0(t1)

        # Llamada strLength
	move 	a0, t2
	la	t9, strLength 
	jal	ra, t9
	move	t3, v0 #longitud

        # Llamo a syscall write
	li	v0, SYS_write 
	li	a0, 1   
	move 	a1, t2 #Contenido
	move	a2, t3    
	syscall

        # Actualizo estado variables
        lw      t0, 16($fp)
        lw      t1, 20($fp)
        subu    t0, t0, 1
        subu    t1, t1, 4
        sw      t0, 16($fp)
        sw      t1, 20($fp)
        j   _loop

_end_loop:
	lw	$fp,28(sp)
	lw	ra,32(sp)
	lw	gp,24(sp)
	addu	sp,sp,40
	jr	ra

	.end	printLines




