#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2
	.globl	printVersion
	
printVersion:
	.ent	printVersion
	li	v0, SYS_write 
	li	a0, 1         
	la	a1, msg       
	li	a2, 224	#Reemplazar 224 por stringLength	     
	syscall

	move	v0, zero
	j	ra
	.end	printVersion

	.rdata
msg:
	.asciiz	"tp1 1.1\n" 
	.asciiz	"Copyright © 2015 FIUBA.\n"
	.asciiz	"Esto es software libre: usted es libre de cambiarlo y redistribuirlo.\n"
	.asciiz	"No hay NINGUNA GARANTÍA, hasta donde permite la ley.\n"
	.asciiz "\n"
	.asciiz	"Escrito por Julian Scialabba, Kaoru Heanna y Paula Saffioti.\n" 



