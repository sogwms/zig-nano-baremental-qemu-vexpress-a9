/* Some defines */
.equ MODE_FIQ, 0x11
.equ MODE_IRQ, 0x12
.equ MODE_SVC, 0x13

.global RawResetHandler
.global _vector_table

.section .text.vector_table
_vector_table:
    b RawResetHandler
    b . /* 0x4  Undefined Instruction */
    b . /* 0x8  Software Interrupt */
    b .  /* 0xC  Prefetch Abort */
    b . /* 0x10 Data Abort */
    b . /* 0x14 Reserved */
    b . /* 0x18 IRQ */
    b . /* 0x1C FIQ */

.section .text
RawResetHandler:
    msr cpsr_c, #0x13

    ldr r1, =_stack_start
    ldr sp, =_stack_end
stack_loop:
    cmp r1, sp
    strlt r0, [r1], #4
    blt stack_loop

    bl resetHandler
    b .

