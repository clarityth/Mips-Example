# switch to the Data segment
	.data
	# global data is defined here
	# Don't forget the backslash-n (newline character)
Homework:
	.asciiz	"ENE 1004 23480 Assignment 2\n"
Name:
	.asciiz "My name is: Taehyung Kim\n"

# switch to the Text segment
	.text
	# the program is defined here
	.globl	main
main:
	# Whose program is this?
	la	$a0, Homework
	jal	Print_string
	la	$a0, Name
	jal	Print_string
	
	la	$a0, cr
	jal	Print_string
	la	$a0, header
	jal	Print_string
	
	# int i, n;
	# for (i = 0; i < 18; i++)
	#   {
	#      ... calculate n from i
	#      ... print i and n
	#   }
	
	# register assignments
	#	$s0	i
	#	$s1	n
	#	$s2	address of testcase[0]
	#	$s3	testcase[i]
	#	$t0	temporary values
	#	$a0	argument to Print_integer, Print_string, etc.
	#	add to this list if you use any other registers
	
	la	$s2, testcase
	
	# for (i = 0; i < 18; i++)
	li	$s0, 0		# i = 0
	bge	$s0, 18, bottom
top:
	# calculate n from shuffle32(testcase[i])
	sll	$t0, $s0, 2	# 4*i
	add	$t0, $s2, $t0	# address of testcase[i]
	lw	$s3, 0($t0)	# testcase[i]
	
	move	$a0, $s3
	jal	shuffle32
	move	$s1, $v0	# n = shuffle32(testcase[i])
	
	# print i and n
	# if (i < 10) print an extra space for alignment
	bge	$s0, 10, L1
	la	$a0, sp		# space
	jal	Print_string
L1:
	move	$a0, $s0	# i
	jal	Print_integer
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s3	# testcase[i]
	jal	Print_hex
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s3	# testcase[i]
	jal	Print_binary
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s1	# n
	jal	Print_binary
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s1	# n
	jal	Print_hex
	la	$a0, cr		# newline
	jal	Print_string
	
	# for (i = 0; i < 18; i++)
	add	$s0, $s0, 1	# i++
	blt	$s0, 18, top	# i < 18
bottom:
	
	la	$a0, done	# mark the end of the program
	jal	Print_string
	
	jal	Exit	# end the program, no explicit return status

	
# switch to the Data segment
	.data
	# global data is defined here
sp:
	.asciiz	" "
cr:
	.asciiz	"\n"
done:
	.asciiz	"All done!\n"
header:
	.asciiz	" i testcase[i]           testcase[i] in binary        shuffled result in binary     result\n"

testcase:
	.word	0xffffffff,	#  0
		0xffff0000,	#  1
		0x0000ffff,	#  2
		0xff00ff00,	#  3
		0x00ff00ff,	#  4
		0xf0f0f0f0,	#  5
		0x0f0f0f0f,	#  6
		0xcccccccc,	#  7
		0x33333333,	#  8
		0xaaaaaaaa,	#  9
		0x55555555,	# 10
		0x00000000,	# 11
		0xffff0000,	# 12
		0xaaaaaaaa,	# 13
		0xcccccccc,	# 14
		0xf0f0f0f0,	# 15
		0xff00ff00,	# 16
		0x12345678	# 17
		
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Your part starts here
# switch to the Text segment
	.text
	
# functions shuffle4, shuffle8, etc. are to be defined here

	.globl	shuffle4
shuffle4:
	# the "perfect shuffle" on 4-bit units
	# $a0 (as bits) 1100
	# $v0 (as bits) 1010
	# $a0 (as original bit positions)
	#   03 02 01 00
	# $v0 (as original bit positions)
	#   03 01 02 00
	andi	$t0, $a0, 0x9 #1001
	andi	$t1, $a0, 0x4 #0100
	srl	$t1, $t1, 1
	andi	$t2, $a0, 0x2 #0010
	sll	$t2, $t2, 1
	or	$v0, $t0, $t1
	or	$v0, $v0, $t2
        jr      $ra
        
	.globl	shuffle8
shuffle8:
	# the "perfect shuffle" on 8-bit units
	# $a0 (as bits) 11110000
	# $v0 (as bits) 10101010
	# $a0 (as original bit positions)
	#   07 06 05 04 03 02 01 00
	# $v0 (as original bit positions)
	#   07 03 06 02 05 01 04 00 
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	andi	$t0, $a0, 0x000000c3 # binary = 11000011
	andi	$t1, $a0, 0x00000030 # binary = 00110000
	srl	$t1, $t1, 2
	andi	$t2, $a0, 0x0000000c # binary = 00001100
	sll	$t2, $t2, 2
	or	$t3, $t0, $t1
	or	$t3, $t3, $t2
	andi	$a0, $t3, 0x000000f0 # binary = 11110000
	srl	$a0, $a0, 4
	sw	$t3, 4($sp) 
	jal	shuffle4
	lw	$t3, 4($sp)
	sll	$t4, $v0, 4
	andi	$a0, $t3, 0x0000000f # binary = 00001111
	sw	$t4, 0($sp)
	jal	shuffle4
	lw	$t4, 0($sp)
	or	$v0, $v0, $t4
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
        jr      $ra

	.globl	shuffle16
shuffle16:
	# the "perfect shuffle" on 16-bit units
	# $a0 (as bits) 1111111100000000
	# $v0 (as bits) 1010101010101010
	# $a0 (as original bit positions)
	#   15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
	# $v0 (as original bit positions)
	#   15 07 14 06 13 05 12 04 11 03 10 02 09 01 08 00
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	andi	$t0, $a0, 0x0000f00f # binary = 1111000000001111
	andi	$t1, $a0, 0x00000f00 # binary = 0000111100000000
	srl	$t1, $t1, 4
	andi	$t2, $a0, 0x000000f0 # binary = 0000000011110000
	sll	$t2, $t2, 4
	or	$t3, $t0, $t1
	or	$t3, $t3, $t2
	andi	$a0, $t3, 0x0000ff00 # binary = 1111111100000000
	srl	$a0, $a0, 8
	sw	$t3, 4($sp)
	jal	shuffle8
	lw	$t3, 4($sp)
	sll	$t4, $v0, 8
	andi	$a0, $t3, 0x000000ff # binary = 0000000011111111
	sw	$t4, 0($sp)
	jal	shuffle8
	lw	$t4, 0($sp)
	or	$v0, $v0, $t4
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
        jr      $ra
	
	.globl	shuffle32
shuffle32:
	# the "perfect shuffle" on 32-bit units
	# $a0 (as bits) 11111111111111110000000000000000
	# $v0 (as bits) 10101010101010101010101010101010
	# $a0 (as original bit positions)
	#   31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
	# $v0 (as original bit positions)
	#   31 15 30 14 29 13 28 12 27 11 26 10 25 09 24 08 23 07 22 06 21 05 20 04 19 03 18 02 17 01 16 00
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	andi	$t0, $a0, 0xff0000ff # binary = 11111111000000000000000011111111
	andi	$t1, $a0, 0x00ff0000 # binary = 00000000111111110000000000000000
	srl	$t1, $t1, 8
	andi	$t2, $a0, 0x0000ff00 # binary = 00000000000000001111111100000000
	sll	$t2, $t2, 8
	or	$t3, $t0, $t1
	or	$t3, $t3, $t2
	andi	$a0, $t3, 0xffff0000 # binary = 11111111111111110000000000000000
	srl	$a0, $a0, 16
	sw	$t3, 4($sp)
	jal	shuffle16
	lw	$t3, 4($sp)
	sll	$t4, $v0, 16
	andi	$a0, $t3, 0x0000ffff # binary = 00000000000000001111111111111111
	sw	$t4, 0($sp)
	jal	shuffle16
	lw	$t4, 0($sp)
	or	$v0, $v0, $t4
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
        jr      $ra

# Your part ends here

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Wrapper functions around some of the system calls
# See P&H COD, Fig. B.9.1, for the complete list.  More are available with MARS.

# switch to the Text segment
	.text

	.globl	Print_integer
Print_integer:	# print the integer in register a0, decimal
	li	$v0, 1
	syscall
	jr	$ra

	.globl	Print_hex
Print_hex:	# print the integer in register a0, hexadecimal
	li	$v0, 34
	syscall
	jr	$ra

	.globl	Print_binary
Print_binary:	# print the integer in register a0, binary
	li	$v0, 35
	syscall
	jr	$ra

	.globl	Print_string
Print_string:	# print the string whose starting address is in register a0
	li	$v0, 4
	syscall
	jr	$ra

	.globl	Exit
Exit:		# end the program, no explicit return status
	li	$v0, 10
	syscall
	jr	$ra

	.globl	Exit2
Exit2:		# end the program, with return status from register a0
	li	$v0, 17
	syscall
	jr	$ra
