#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2

	.globl	tacFile
	.ent	tacFile
tacFile:
	.frame	$fp,64,ra		#informacion de debugging. Sf de 64 (4 ABA + 8 LTA + 4 SRA)

	.set	noreorder		#codigo PIC
	.cpload	t9			#codigo PIC
	.set	reorder			#codigo PIC

	subu	sp,sp,64		#creo stack frame de 64

	.cprestore 48			#guardo gp en SRA (sp + 48)

	sw	ra,56(sp)		#guardo ra en SRA (sp + 56)
	sw	$fp,52(sp)		#guardo fp en SRA (sp + 52)
	move	$fp,sp			#a partir de ahora uso fp	
	
	sw	$a0,64($fp)		#guardo a0 afuera del frame. a0 es file pointer

	li	t0,10			#guardo 10 en t0. 10 es bufIncrSize
	sw	$t0,16($fp)		#guardo t0(bufIncrSize) en LTA (fp + 16)

	sw 	$zero,20($fp)		#arrayLines en LTA (fp + 20)
	sw 	$zero,24($fp)		#lineCounter en LTA (fp + 24)

	la	$t0,buffer		#en t0 guardo pos de comienzo del array (buffer)
	sw	$t0,28($fp)		#almaceno pos de comiezo del array (buffer) en (fp + 28)

	lw	$a0,16($fp)		#guardo en a0 t0(bufIncrSize) que esta en (fp + 16)
	li	$a1,1			#guardo en a1 el valor 1 (seria size of char, despues cambiar segun calloc)

	la	$t9,calloc		#llamo a calloc
	jal	$ra,$t9			

	sw	$v0,32($fp)		#obtengo puntero a line y lo guardo en (fp + 32)

$cond_while: 
	lw	$a0,28($fp)		#direccion de comienzo de buffer que esta en (fp + 28)
	lw	$a1,16($fp) 		#bufIncSize que esta en (fp + 16)
	lw	$a2,64($fp) 		#file pointer que esta en (fp + 64)
	la	$t9,fgets		#llamo a fgets
	jal	$ra,$t9
	bne	$v0,$zero,bloque_while	#en v0 esta lo que devuelve fgets. v0!=0 => entra a bloque_while
	b	$despues_while

$bloque_while: 
	lw	$a0,32($fp)		#puntero a line que esta en (fp + 32)
	lw	$a1,28($fp)		#direccion de comienzo de buffer que esta en (fp + 28)
	la	$t9,concatBuffer	#llamo a concatBuffer. 
	jal	$ra,$t9

	lw	$a0,28($fp)		#direccion de comienzo de buffer que esta en (fp + 28)
	la	$t9,strlen		#llamo a strlen. No se si esta bien pasarle la direccion de buffer. Revisar 
	jal	$ra,$t9


	.rdata
	align 2
buffer: .word 0,0,0,0,0,0,0,0,0,0


	
	
