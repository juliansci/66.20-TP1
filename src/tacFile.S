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
	
	sw	a0,64($fp)		#guardo a0 afuera del frame. a0 es file pointer

	li	t0,10			#guardo 10 en t0. 10 es bufIncrSize
	sw	t0,16($fp)		#guardo t0(bufIncrSize) en LTA (fp + 16)

	sw 	zero,20($fp)		#arrayLines en LTA (fp + 20)
	sw 	zero,24($fp)		#lineCounter en LTA (fp + 24)

	la	t0,buffer		#en t0 guardo pos de comienzo del array (buffer)
	sw	t0,28($fp)		#almaceno pos de comiezo del array (buffer) en (fp + 28)

	lw	a0,16($fp)		#guardo en a0 t0(bufIncrSize) que esta en (fp + 16)
	li	a1,1			#guardo en a1 el valor 1 (seria size of char, despues cambiar segun calloc)

	la	t9,calloc		#llamo a calloc
	jal	ra,t9			

	sw	v0,32($fp)		#obtengo puntero a line y lo guardo en (fp + 32)

$cond_while: 
	lw	a0,28($fp)		#direccion de comienzo de buffer que esta en (fp + 28)
	lw	a1,16($fp) 		#bufIncSize que esta en (fp + 16)
	lw	a2,64($fp) 		#file pointer que esta en (fp + 64)
	la	t9,fgets		#llamo a fgets
	jal	ra,t9
	bne	v0,zero,$bloque_while	#en v0 esta lo que devuelve fgets. v0!=0 => entra a bloque_while
	b	$end

$bloque_while: 
	lw	a0,32($fp)		#puntero a line que esta en (fp + 32)
	lw	a1,28($fp)		#direccion de comienzo de buffer que esta en (fp + 28)
	la	t9,concatBuffer		#llamo a concatBuffer. 
	jal	ra,t9

	lw	a0,28($fp)		#direccion de comienzo de buffer que esta en (fp + 28)
	la	t9,strlen		#llamo a strlen. No se si esta bien pasarle la direccion de buffer. Revisar 
	jal	ra,t9

	move	t0,v0			#guardo en t0 el valor de v0 (que es lo que me devuelve strlen)
	addu	t0,t0,-1		#le resto 1
	lw 	t1,28($fp)		#direccion de comienzo de buffer que esta en (fp + 28)
	addu	t0,t0,t1		#direccion de buffer + tamaño de buffer- 1 = dir ultimo elemento
	lbu	t0,0(t0)		#cargo contenido del ultimo elemento
	move	a0,t0			#muevo a a0 el contenido del ultimo elemento		
	la	t9,isEndOfLine		#llamo a isEndOfLine
	jal	ra,t9

	beq	v0,zero,$cond_while	#v0=0 => no es fin de linea => vuelvo a la cond del while

	lw	t0,24($fp)		#cargo LineCounter que esta en (fp + 24)
	addu	t0,t0,1			#le sumo 1, esta bien sumarle 1 a un int asi?
	lw	a0,20($fp)		#cargo en a0 arrayLines que esta en (fp + 20)
	move	a1,t0			#cargo en a1 el contenido de t0 
	la	t9,realloc
	jal	ra,t9

					#...
	
	b	$cond_while		#vuelvo a la condicion del while
$end: 
	lw	a0,24($fp)		#carga en a0 lineCounter que esta en (fp + 24)
	lw	a1,20($fp)		#carga en a1 arrayLines que esta en (fp + 20)
	lw	a2,32($fp)		#carga en a2 line que esta en (fp + 32)
	la	t9,printLines		#llamo a printLines
	jal	ra,t9

	.end	tacFile

	.rdata
	.align 2
buffer: .word 0,0,0,0,0,0,0,0,0,0
	
