.data
	input: .asciiz "Informe um numero: "
	outputIsSemiprime: .asciiz "\nSemiprimo"
	outputNotSemiprime: .asciiz "\nNao e semiprimo"
	br: .asciiz "\n"
	sp: .asciiz " "

.text

main:
	jal read	# int read()
	move $s0, $v0	# Moves return to $s0
	
	move $a0, $s0	# Moves $s0 to parameter $a0
	jal testSemiprime # void isSemiprime(int pNum)
		
	j exit		# Exits program
	


read:
	li $v0, 4	# String print code
	la $a0, input	# Loads address of the input argument
	syscall		# Syscall to print the string
	
	li $v0, 5	# Reads integer from input and stores it in return $v0
	syscall		# Syscall to read the integer
	
	jr $ra		# Return to main



testSemiprime:
	move $t3, $a0	# num = pNum
	li $t4, 0	# a = 0
	li $t5, 0	# b = 0
	li $t6, 0	# res = 0
	li $t7, 0	# prime counter
	
iSFor1:	li $t5, 0
	add $t4, $t4, 1
	
iSFor2: add $t5, $t5, 1

	mul $t6, $t4, $t5
	
	beq $t6, $t3, testPrime
	b continue
	
testPrime:

	li $t7, 0
	
	move $a1, $t4
	jal isPrime
	add $t7, $t7, $v0
	
	move $a1, $t5
	jal isPrime
	add $t7, $t7, $v0
	
	beq $t7, 2, isSemiprime
	
	b continue

continue: 
	
	blt $t5, $t3, iSFor2
	blt $t4, $t3, iSFor1
	
	b notSemiprime

isSemiprime:
	li $v0, 4			# String print code
	la $a0, outputIsSemiprime	# Loads address of the input argument
	syscall				# Syscall to print the 
	j exit

notSemiprime:
	li $v0, 4			# String print code
	la $a0, outputNotSemiprime	# Loads address of the input argument
	syscall				# Syscall to print the 
	j exit



isPrime:
	move $t0, $a1		# num = pNum
	li $t1, 2		# int i = 2
	
	# Exceptions
	beq $t0, 1, notPrime	# if num == 1 -> notPrime
	beq $t0, 2, prime	# if num == 2 -> prime
	
iPFor:	div  $t0, $t1		# num / i
	mfhi, $t2		# move remainder to $t2
	
	beq, $t2, $zero, notPrime	# if num % i == 0 -> not prime
	
	add $t1, $t1, 1 	# i++
	blt $t1, $t0, iPFor	# if i < num goto iPFor

	b prime



notPrime:
	li $v0, 0	# return 0
	jr $ra		# Return
	
prime:
	li $v0, 1	# Return $v0 = 1
	jr $ra		# Return



exit:
	li $v0, 10	# Code to terminate program
	syscall		# Finalizes the program	
