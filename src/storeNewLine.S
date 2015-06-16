#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2

	.globl	storeNewLine
	.ent	storeNewLine
storeNewLine:
	.frame	$fp,48,ra		#informacion de debugging. Sf de 64 (4 ABA + 4 LTA + 4 SRA)

	.set	noreorder		#codigo PIC
	.cpload	t9			#codigo PIC
	.set	reorder			#codigo PIC

	subu	sp,sp,48		#creo stack frame de 48

	.cprestore 32			#guardo gp en SRA (sp + 32)

	sw	ra,36(sp)		#guardo ra en SRA (sp + 36)
	sw	$fp,40(sp)		#guardo fp en SRA (sp + 40)
	move	$fp,sp			#a partir de ahora uso fp	

	sw	a0,24($fp)		#int* lineCounter
	sw	a1,16($fp)		#char ** arrayLines
	sw	a2,28($fp)		#char** line

	lw	a0,16($fp)		#cargo en a0 arrayLines	

	lw	t0,24($fp)		#cargo en t0 int* lineCounter
	lw	a1,0(t0)		#cargo en a1 lo que apunta t0
	la	t9,resizeArrayLines	#llamo a resizeArrayLines	
	jal	ra,t9
	sw	v0,16($fp)		#resultado pisa arrayLines	

	lw	t0,24($fp)		#cargo en t0 int* lineCounter	
	lw	t0,0(t0)		#cargo en t1 lo que apunta t0
	lw	t1,16($fp)		#cargo en t1 direccion de arrayLines

        sll     t3, t0, 2  	 	
        addu    t1, t1, t3  		

	lw	t0,28($fp)		
	lw	t2,0(t0)		
	sw	t2,0(t1)	
	li 	a0,1
	la	t9,mymalloc		
	jal	ra,t9	

	lw	t0,28($fp)		
	sw	v0,0(t0)	

	lw	t0,24($fp)		#cargo en t0 direccion de lineCounter	
	lw	t1,0(t0)		#cargo en t1 lo que apunta t0
	addu 	t1,t1,1			#le sumo 1
	sw	t1,0(t0)	  	#guardo en direccion que esta en t0 el contenido de t1	

	lw	v0,16($fp)		#return arrayLines
	lw	gp,32(sp)		#restauro gp (sp + 32)
	lw	ra,36(sp)		#restauro ra (sp + 36)
	lw	$fp,40(sp)		#restauro fp (sp + 40)
	addu	sp,sp,48		#destruyo stack frame
        jr 	ra

	.end	storeNewLine
	.rdata

