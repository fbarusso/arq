.data
	arrayA: .space 60
	arrayB: .space 28
	Inter: 	.space 60
	
	arrayAInput: .asciiz "Insira um valor no vetor A: "
	arrayBInput: .asciiz "Insira um valor no vetor B: "
	intersec: .asciiz "Intersec: "
	
	sp: .asciiz " "
	br: .asciiz "\n"

.text

# Index:
	# Inter size ---------------- $s0


main:

	jal readArrayA
	
	jal readArrayB
	
	jal printInter
	
	j exit





readArrayA:

	move $t0, $zero		# i = 0

rAAFor:
	li $v0, 4		# String print code
	la $a0, arrayAInput	# Loads address of the string argument
	syscall			# Syscall to print the string
	
	li $v0, 5		# Reads integer from input and stores it in return $v0
	syscall			# Syscall to read the integer
	
	sw $v0, arrayA($t0)	# Stores red value in arrayA[i]
	
	addi $t0, $t0, 4	# i = i + 4
	blt $t0, 60, rAAFor	# if (i < 60) goto rAAFor
	
	jr $ra			# return





readArrayB:
	move $s0, $zero
	move $t0, $zero		# i = 0
	move $s7, $ra		# saves return address in $s7

rABFor:
	li $v0, 4		# String print code
	la $a0, arrayBInput	# Loads address of the string argument
	syscall			# Syscall to print the string
	
	li $v0, 5		# Reads integer from input and stores it in return $v0
	syscall			# Syscall to read the integer
	
	move $a1, $v0		# Sets argument $a1 to red integer
	
	jal intersectionTest	# void intersectionTest
	
	sw $v0, arrayB($t0)	# Stores red value in arrayB[i]
	
	addi $s1, $s1, 4
	
	addi $t0, $t0, 4	# i = i + 4
	blt $t0, 28, rABFor	# if (i < 28) goto rABFor
	
	jr $s7			# return





intersectionTest:
	move $t4, $zero		# i = 0
	la $t2, arrayA		# $t2 = arrayA address

iTFor:
	lw $t3, ($t2)		# $t3 t2 content 
	beq $a1, $t3, iTTrue	# if $t3 = $a1 intercects
	
	addi $t2, $t2, 4
	addi $t4, $t4, 4	# i = i + 4
	blt $t4, 60, iTFor	# if (i < 60) goto riTFor
	
	jr $ra			# return
	
iTTrue:
	j verify
	
iTTReturn:
	jr $ra
	
	
verify:
	move $t5, $zero		# i = 0
	la $t6, arrayB		# $t6 = arrayB address
	
vFor:
	lw $t7, ($t6)		# $t3 t2 content 
	beq $a1, $t7, vTrue	# if $t3 = $a1 intercects
	
	addi $t5, $t5, 4
	addi $t6, $t6, 4	# i = i + 4
	blt $t5, $s1, vFor	# if (i < 60) goto riTFor
	
	sw $a1, Inter($s0)	# Stores red value in auxInter[i]
	addi $s0, $s0, 4
	j iTTReturn

vTrue:

	j iTTReturn
	
	
	
	






printInter: 
	
	move $t0, $zero		# i = 0

	li $v0, 4		# String print code
	la $a0, intersec	# Loads address of the string argument
	syscall			# Syscall to print the string
pIFor:
	li $v0, 1		# String print code
	lw $a0, Inter($t0)	# Loads address of the int argument
	syscall	
	
	li $v0, 4		# String print code
	la $a0, sp		# Loads address of the string argument
	syscall			# Syscall to print the string
	
	
	addi $t0, $t0, 4	# i = i + 4
	blt $t0, $s0, pIFor	# if (i < $s0) goto pIFor
	
	jr $ra			# return




exit:
	li $v0, 10		# Code to terminate program
	syscall			# Finalizes the program	
