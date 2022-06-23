	
	.text
main:
	ori $t0, $zero, 512
	slt $t1, $zero, $t0
	bne $t1, $zero, L0
	ori $t2, $zero, 1024
	j L1
L0:
	ori $t2, $zero, 2048 
L1:	
	or $t3, $t0, $t2 
	add $t4, $zero, $zero 
L2:	
	add $t3, $t3, $t0
	add $t4, $t4, $t1 
	slti $t5, $t4, 3
	bne $t5, $zero, L2 
	jal Exit
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	.data
# .align 0	
str1:
	.asciiz "The sum from 0 .. 100 is :"
str2:
	.asciiz "\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# switch to the Text segment
	.text

Print_integer: # print the integer in register a0
	li $v0, 1
	syscall
	jr $ra

Print_string: # print the string whose starting address is in register a0
	li $v0, 4
	syscall
	jr $ra

Exit: # end the program, no explicit return status
	li $v0, 10
	syscall
	jr $ra

Exit2: # end the program, with return status from register a0
	li $v0, 17
	syscall
	jr $ra
	
