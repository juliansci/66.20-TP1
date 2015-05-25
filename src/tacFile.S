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

	li	t0,0			#guardo 0 en t0
	sw 	t0,16($fp)		#guardo lineCounter en (fp + 16)
	li 	a0,1
	la	t9,mymalloc		#llamo a malloc
	jal	ra,t9		
	sw	v0,20($fp)		#obtengo puntero a arrayLines y lo guardo en (fp + 20)

	li	a0,1			#guardo 1 en a0
	la	t9,mymalloc		#llamo a mymalloc
	jal	ra,t9		
	sw	v0,24($fp)		#obtengo puntero a lines y lo guardo en (fp + 24)	

cond_while: 
	la	a0,buffer
	li	a1,10
	lw	a2,64($fp)
	la	t9,fgets
	jal	ra,t9

	#li	v0, 14			# Read File Syscall
	#lw	a0, 64($fp) 		# Load File Descriptor
	#la	a1, buffer		# Load Buffer Address
	#li	a2, 10			# Buffer Size
	#syscall

	bne	v0,zero,bloque_while	#v0!=0 => entra a bloque_while
	b	end

bloque_while: 

# char *newLine = concatBuffer(line, buffer);
	lw	a0,24($fp)		#puntero a line que esta en (fp + 24)
	la	a1,buffer		#direccion de comienzo de buffer
	la	t9,concatBuffer		#llamo a concatBuffer. 
	jal	ra,t9
	sw	v0,28($fp)		#obtengo puntero a newLine y lo guardo en (fp + 28)
	
# myfree(line);
	lw	a0,24($fp)		#cargo puntero a line que esta en (fp + 24)
	la	t9,myfree		#llamo a myfree
	jal	ra,t9	

# \line = newLine
	lw	t0,28($fp)		#obtengo puntero a newLine que esta en (fp + 28)
	sw	t0,24($fp)		#guardo nuevo puntero a line en (fp + 24)

#char lastCharacterBuffer = buffer[strlen(buffer) - 1];
	la 	a0,buffer
	la	t9,strlen		#llamo a strlen.
	jal	ra,t9
	move 	t0,v0			
	subu	t0,t0,1
	la	t1,buffer
	addu	t2,t1,t0
	lw	t2,0(t2)
	sw	t2,32($fp)		#lastCharacterBuffer en (fp + 32)

#arrayLines = storeNewLine(lastCharacterBuffer,&lineCounter,arrayLines,&line); 
	lw	a0,32($fp)		#lastCharacterBuffer
	addu	a1,$fp,16		#&lineCounter
	lw	a2,20($fp)		#arrayLines
	addu	a3,$fp,24		#&line
	la	t9,storeNewLine		#llamo a storeNewLine
	jal	ra,t9	
	lw	v0,20($fp)
end: 

#printLines(lineCounter, arrayLines);
	lw	a0,16($fp)		#carga en a0 lineCounter que esta en (fp + 16)
	lw	a1,20($fp)		#carga en a1 arrayLines que esta en (fp + 20)
	la	t9,printLines		#llamo a printLines
	jal	ra,t9

#myfree(line);
	lw	a0,24($fp)		#carga en a0 line que esta en (fp + 24)
	la	t9,myfree		#llamo a myfree
	jal	ra,t9

#myfree(arrayLines);
	lw	a0,20($fp)		#carga en a0 arrayLines que esta en (fp + 20)
	la	t9,myfree		#llamo a myfree
	jal	ra,t9

#return (EXIT_SUCCESS);
	li 	v0,1

	lw	gp,48(sp)		#restauro gp (sp + 48)
	lw	ra,56(sp)		#restauro ra (sp + 56)
	lw	$fp,52(sp)		#restauro fp (sp + 52)
	addu	sp,sp,64		#destruyo stack frame
        jr 	ra

	.end	tacFile

	.rdata
	.align 2
buffer: .space 10
	
