#include <mips/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2
	.globl	strLength
	.ent	strLength

strLength:
	.frame	$fp, 16, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
        
        #creo stack frame
	subu	sp, sp, 16

        # Guardo $gp y $sp en SRA
	.cprestore 8
        sw	$fp, 12(sp)
        
        #De ahora en adelante utilizo $fp como sp
	move	$fp, sp

        # Guardo argumento en ABA de caller
        sw a0, 16($fp)

        # Creo variable incremental y la guardo en primer registro de LTA
        move t0, zero
        sw t0, 0($fp)

_for:
        # Condicion de corte del for
        addu t1, a0, t0  # Apunto en t1 al siguiente byte del string recibido por param
        lb t1, 0(t1) # Cargo el character apuntado en t1
        beq t1, zero, _end_for
        addu t0, t0, 1
        j _for

_end_for:
        
        # Preparo todo para retorno
        move v0, t0
        lw gp, 8($fp)
        lw $fp, 12(sp)
        addu sp, sp, 16
        jr ra

        .end strLength
