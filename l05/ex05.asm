.data
	valueInput: .asciiz "Insira um valor: "
	outputTrue: .asciiz "\nNumero palindrome"
	outputFalse: .asciiz "\nNumero nao palindrome"
	
.text

# Index
	# Red integer ---------- $a1
	# Original integer ----- $s0
	# Reversed integer ----- $s1
	# Remainder ------------ $s2

main:
	jal read
	
	jal testPalindrome
	
	j exit
	
read:
	li $v0, 4		# String print code
	la $a0, valueInput	# Loads address of the string argument
	syscall			# Syscall to print the string
	
	li $v0, 5		# Reads integer from input and stores it in return $v0
	syscall			# Syscall to read the integer
	
	move $a1, $v0		# Stores red value in argument $a1
	move $s0, $v0		# Stores red value in originalInteger $s0
	
	jr $ra			# Returns to link
	
testPalindrome:

tPWhile:
	
	div $a1, $a1, 10	# n /= 10
	mfhi $s2		# $s2 = remainder
	
	mul $s1, $s1, 10	# reversedInteger = reversedInteger * 10
	
	add $s1, $s1, $s2	# reversedInteger = reversedInteger + remainder;
	
	
	
	bne $a1, $zero, tPWhile  # while( n!=0 )
	
	beq $s0, $s1, tPTrue
	
	# Not palindrome
	
	li $v0, 4		# String print code
	la $a0, outputFalse	# Loads address of the string argument
	syscall			# Syscall to print the string
	
	jr $ra
	
	# Palindrome
tPTrue:

	li $v0, 4		# String print code
	la $a0, outputTrue	# Loads address of the string argument
	syscall			# Syscall to print the string

	jr $ra
	
exit: 
	li $v0, 10		# Code to terminate program
	syscall			# Finalizes the program	