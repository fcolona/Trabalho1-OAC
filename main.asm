			.data
			.align 0
msg_boas_vindas:	.asciz "Boas Vindas!"
			.text
			.align 2
			.globl main
	
main:			addi a7, zero, 4
			la a0, msg_boas_vindas
			ecall