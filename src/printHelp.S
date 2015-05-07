#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2
	.globl	printHelp
	
printHelp:
	.ent	printHelp
	li	v0, SYS_write 
	li	a0, 1         
	la	a1, msg       
	li	a2, 183	#Reemplazar 183 por stringLength	     
	syscall

	move	v0, zero
	j	ra
	.end	printHelp

	.rdata
msg:
	.asciiz	"Usage:\n" 
	.asciiz	"	tp0 -h\n"
	.asciiz	"	tp0 -V\n"
	.asciiz	"	tp0 [file...]\n"
	.asciiz	"Options:\n" 
	.asciiz	"	-V, --version Print version and quit.\n"
	.asciiz	"	-h, --help Print this information and quit.\n"
	.asciiz	"Examples:\n"
	.asciiz	"	tp0 foo.txt bar.txt\n"
	.asciiz	"	tp0 gz.txt\n"
