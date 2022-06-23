# switch to the Data segment
	.data
	# global data is defined here
	# Don't forget the backslash-n (newline character)
Homework:
	.asciiz	"ENE 1004 23480 Assignment 1\n"
Name:
	.asciiz "My name is: TaehyungKim\n"

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
	
# functions shuffle32 to be defined here

	.text
shuffle32:
   	addi    $sp, $sp, -8
        sw      $fp, 4($sp)
        move    $fp, $sp
        sw      $a0, 8($fp)
        lw      $v0, 8($fp)
        lw      $v0, 8($fp)
        
        sll     $v1, $v0, 8
        li      $v0, 16711680       # 0x0000ff0000 = 0000 0000 0000 0000 1111 1111 0000 0000
        and     $v1, $v1, $v0
        
        lw      $v0, ($a)
        srl     $v0, $v0, 8
        andi    $v0, $v0, 0xff00      
        or      $v1, $v1, $v0
        
        lw      $a0, 8($fp)
        li      $v0, -16777216      # 0xffffffffff000000
        ori     $v0, $v0, 0xff
        and     $v0, $a0, $v0
        or      $v0, $v1, $v0
        sw      $v0, 8($fp)
        
        lw      $v0, 8($fp)
        sll     $v1, $v0, 4
        li      $v0, 251658240      # 0xf000000
        ori     $v0, $v0, 0xf00
        and     $v1, $v1, $v0
        
        lw      $v0, 8($fp)
        srl     $a0, $v0, 4
        li      $v0, 15728640       # 0xf00000
        ori     $v0, $v0, 0xf0
        and     $v0, $a0, $v0
        or      $v1, $v1, $v0
        
        lw      $a0, 8($fp)
        li      $v0, -267452416     # 0xfffffffff00f0000
        ori     $v0, $v0, 0xf00f
        and     $v0, $a0, $v0
        or      $v0, $v1, $v0
        sw      $v0, 8($fp)
        
        lw      $v0, 8($fp)
        sll     $v1, $v0, 2
        li      $v0, 808452096      # 0x30300000
        ori     $v0, $v0, 0x3030
        and     $v1, $v1, $v0
        
        lw      $v0, 8($fp)
        srl     $a0, $v0, 2
        li      $v0, 202113024      # 0xc0c0000
        ori     $v0, $v0, 0xc0c
        and     $v0, $a0, $v0
        or      $v1, $v1, $v0
        
        lw      $a0, 8($fp)
        li      $v0, -1010630656    # 0xffffffffc3c30000
        ori     $v0, $v0, 0xc3c3
        and     $v0, $a0, $v0
        or      $v0, $v1, $v0
        sw      $v0, 8($fp)
        
        lw      $v0, 8($fp)
        sll     $v1, $v0, 1
        li      $v0, 1145307136     # 0x44440000
        ori     $v0, $v0, 0x4444
        and     $v1, $v1, $v0
        
        lw      $v0, 8($fp)
        srl     $a0, $v0, 1
        li      $v0, 572653568      # 0x22220000
        ori     $v0, $v0, 0x2222
        and     $v0, $a0, $v0
        or      $v1, $v1, $v0
        
        lw      $a0, 8($fp)
        li      $v0, -1718026240    # 0xffffffff99990000
        ori     $v0, $v0, 0x9999
        and     $v0, $a0, $v0
        or      $v0, $v1, $v0
        sw      $v0, 8($fp)
        
        lw      $v0, 8($fp)
        move    $sp, $fp
        lw      $fp, 4($sp)
        addi   	$sp, $sp, 8
        
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
