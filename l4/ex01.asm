.data
	input: .asciiz "Informe um numero: "
	output: .asciiz "\nSoma: "

.text

main:
	li $s0, 0		# Sets soma to 0
	li $t0, 0		# Sets contador to 0
	
	j readingLoop
	
	j exit
	
readingLoop:
	add $t0, $t0 1		# Contador ++
	
	li $v0, 4		# String print code
	la $a0, input		# Loads address of the input argument
	syscall			# Syscall to print the string
	
	li $v0, 5		# Read integer from input and stores in $v0
	syscall			# Syscall to read the integer
	add $s0, $s0 $v0	# Adds read value to soma
	beq $t0, 10, display	# If contador == 10 goto display
	j readingLoop		# Else goto readingLoop
	

display:
	li $v0, 4		# String print code
	la $a0, output		# Load addres argument output (soma)
	syscall
	
	li $v0, 1		# Integer print code
	move $a0, $s0		# Move soma to argument
	syscall
	
exit:
	li $v0, 10		# Code to terminate program
	syscall			# Finalizes the program	
