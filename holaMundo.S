#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2

	.globl	holaMundo
	.ent	holaMundo
holaMundo:
	li	v0, SYS_write 
	li	a0, 1         
	la	a1, msg       
	li	a2, 12	     
	syscall

	move	v0, zero
	j	ra
	.end	holaMundo

	.rdata
msg:
	.asciiz	"Hola mundo.\n"
