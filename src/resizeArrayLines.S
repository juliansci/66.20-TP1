#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2
	.globl	resizeArrayLines
	.ent	resizeArrayLines

resizeArrayLines:
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

        move    t0, zero
        sw      t0, 16($fp)

        addu	t1, a1, 1
	sll     t1, t1, 2
	move    a0, t1
	la	t9, mymalloc
	jal	ra, t9
	sw	v0, 20($fp)	

        lw      t0, 16($fp)
        lw      t1, 44($fp)
_loop:  
        bge     t0, t1, _end_loop

        lw      t2, 40($fp)
        lw      t3, 20($fp)

        sll     t4, t0, 2
        addu    t2, t2, t4
        addu    t3, t3, t4 
        lw      t4, 0(t2)
        sw      t4, 0(t3)

        addu    t0, t0, 1
        j   _loop

_end_loop:

        lw      a0, 40($fp)
	la      t9, myfree
	jal	ra, t9

        lw      v0, 20($fp)
	lw	$fp,28(sp)
	lw	ra,32(sp)
	lw	gp,24(sp)
	addu	sp,sp,40
	jr	ra

	.end	resizeArrayLines




