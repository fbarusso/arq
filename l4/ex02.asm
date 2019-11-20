.data
	input: .asciiz "Informe um numero: "
	output: .asciiz "Maior valor: "
	
.text

main:
	jal read	# int read()
	move $s0, $v0	# Moves return to $s0
	jal read	# int read()
	move $s1, $v0	# Moves return to $s1
	
	move $a0, $s0	# Moves $s0 to parameter $a0
	move $a1, $s1	# Moves $s1 to parameter $a1
	
	jal greater	# int greater(int a, int b)
	move $s2, $v0	# Moves return to $s2
	
	move $a0, $s2	# Moves $s2 to parameter $a0
	jal display	# void display(int i)
	j exit		# void exit()
	
			
							
read:
	li $v0, 4	# String print code
	la $a0, input	# Loads address of the input argument
	syscall		# Syscall to print the string
	
	li $v0, 5	# Reads integer from input and stores it in $v0
	syscall		# Syscall to read the integer
	
	jr $ra		# Return to main



greater: 
	bgt $a0, $a1, returnA	# if a > b return A
	move $v0, $a1		# else return b
	jr $ra			# return to main



returnA:
	move $v0, $a0	# return a
	jr $ra		# Return to main


display:
	move $t0, $a0	# Move parameter $a0 to temp $t0

	li $v0, 4	# String print code
	la $a0, output	# Load "output" argument addres
	syscall		# Syscall to print the string
	
	li $v0, 1	# Integer print code
	move $a0, $t0	# Move $t0 to argument $a0
	syscall		# Syscall to print the integer



exit:
	li $v0, 10	# Code to terminate program
	syscall		# Finalizes the program	
