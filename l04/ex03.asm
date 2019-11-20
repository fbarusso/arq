.data
	input: .asciiz "Informe um numero: "
	outputHighest: .asciiz "\nMaior numero: "
	outputLowest: .asciiz "\nMenor numero: "
	outputEvenSum: .asciiz "\nSoma de numeros pares: "
	outputOddSum: .asciiz "\nSoma de numeros impares: "
	outputPrimeNumbers: .asciiz "\nQuantidade de numeros primos: "
	outputAmicableNumbers: .asciiz "\nQuantidade de numeros amigos: "
	outputPerfectNumbers: .asciiz "\nQuantidade de numeros perfeitos: "
	br: .asciiz "\n"
	
.text

# Index:
	# Highest number----------------$s0
	# Lowest number-----------------$s1
	# Even numbers sum--------------$s2
	# Odd numbers sum---------------$s3
	# Prime numbers counter---------$s4
	# Amicable numbers counter------$s5
	# Perfect numbers counter-------$s6

main:
	jal firstRead		# void firstRead()
	
	jal secondRead		# void secondRead()
	
	jal display		# void display()
	
	j exit

	



firstRead:
	move $s7, $ra		# Saves $ra in $s7
	
	li $s2,0		# Sets even sum to 0
	li $s3,0		# Sets odd sum to 0
	li $s4,0		# Sets prime numbers counter to 0
	li $s5,0		# Sets amicable numbers counter to 0
	li $s6,0		# Sets perfect numbers counter to 0

	li $v0, 4		# String print code
	la $a0, input		# Loads address of the input argument
	syscall			# Syscall to print the string
	
	li $v0, 5		# Reads integer from input and stores it in return $v0
	syscall			# Syscall to read the integer
	
	move $a0, $v0		# Moves read integer to parameter $a0
	
	jal evenOrOddSum	# void evenOrOddSum(int i)
	
	jal testPrime		# void testPrime(int i)
	
	jal testAmicable	# void testAmicable(int i)
	
	jal testPerfect		# void testPerfect(int i)
	
	move $s0, $v0		# Sets first read number as highest
	move $s1, $v0		# Sets first read number as lowest
	
	jr $s7			# Return to main


	


secondRead:
	li $t0, 1		# Set couter ($t0) to 1
	move $s7, $ra		# Saves $ra in s7
	
	b sRFor			# Enters for

sRFor:	add $t0, $t0 1		# Counter++

	li $v0, 4		# String print code
	la $a0, input		# Loads address of the input argument
	syscall			# Syscall to print the string
	
	li $v0, 5		# Reads integer from input and stores it in return $v0
	syscall			# Syscall to read the integer
	
	move $a0, $v0		# Moves read integer to parameter $a0
	
	jal testHigher		# void testHigher(int i)
	
	jal testLower		# void testLower(int i)
	
	jal evenOrOddSum	# void evenOrOddSum(int i)
	
	jal testPrime		# void testPrime(int i)
	
	jal testAmicable	# void testAmicable(int i)
	
	jal testPerfect		# void testPerfect(int i)

	beq $t0, 10, sRReturn	# If counter == 10 returns
	b sRFor			# Else goto sRFor
	
sRReturn: jr $s7		# Return





testHigher:
	bgt $a0, $s0 isHigher
	jr $ra
isHigher:
	move $s0, $a0
	jr $ra



testLower:
	bgt $a0, $s0 isHigher
	jr $ra
isLower:
	move $s1, $a0
	jr $ra





evenOrOddSum:
	div $t1, $a0, 2		# i / 2
	mfhi $t1		# remainder to $t1
	
	beq $t1, $zero, evenSum	# if reminder == 0, is even
	
	add $s3, $s3, $a0	# else add to odd numbers sum
	
	jr $ra			# return
evenSum:
	add $s2, $s2, $a0	# add to even numbers sum
	
	jr $ra			# return





testPrime:
	li $t1, 2			# int i = 2
	
	beq $a0, 1, notPrime		# if num == 1 -> notPrime
	beq $a0, 2, prime		# if num == 2 -> prime
	
tPFor:	div  $a0, $t1			# num / i
	mfhi, $t2			# move remainder to $t2
	
	beq, $t2, $zero, notPrime	# if num % i == 0 -> not prime
	
	add $t1, $t1, 1 		# i++
	blt $t1, $a0, tPFor		# if i < num goto tPFor

	b prime				# goto prime

prime: 
	add $s4, $s4, 1			# if is prime, primeCounter++
	jr $ra				# Return
	
notPrime:
	jr $ra				# Return





testAmicable:
	beq $a0, 1, tAmNotAmicable	# 1 is not amicable 
	li $t1, 1		# int i = 1
	li $t2, 0		# int tempSum = 0
	
tAmFor:	
	add $t1, $t1, 1		# i++
	bge $t1, $a0, tAm2	# Second part
	
	div $a0, $t1		# num / i
	mfhi $t3		# Moves reaminder to temp $t3
	
	beq $t3, $zero, tAmDiv	# if reaminder == 0, goto tAmDiv
	
	j tAmFor
	
tAmDiv:
	add $t2, $t2, $t1
	j tAmFor
	
tAm2: 
	add $t2, $t2, 1		# Divisors sum++
	beq $a0, $t2, tAmNotAmicable	# If perfect number, not amicable
	li $t1, 1		# int i = 1
	li $t4, 0		# int tempSum2 = 0
	

tAmFor2:	
	add $t1, $t1, 1		# i++
	bge $t1, $t2, tAmReturn	# Return
	
	div $t2, $t1		# num / i
	mfhi $t3		# Moves reaminder to temp $t3
	
	beq $t3, $zero, tAmDiv2	# if reaminder == 0, goto tAmDiv
	
	j tAmFor2
	
tAmDiv2:
	add $t4, $t4, $t1
	j tAmFor2
	
tAmReturn:
	add $t4, $t4, 1		# Divisors sum++
		
	beq $a0, $t4, tAmAmicable
	b tAmNotAmicable

tAmAmicable:
	add $s5, $s5, 1
	jr $ra

tAmNotAmicable:
	jr $ra






testPerfect:
	li $t1, 1		# int i = 1
	li $t2, 0		# int tempSum = 0
	move $t7, $ra		# $t7 = $ra
	beq $a0, 1, tPeNotPerfect	# if num == 1 -> notPerfect
	
tPeFor:	
	add $t1, $t1, 1		# i++
	bge $t1, $a0, tPeReturn	# Return
	
	div $a0, $t1		# num / i
	mfhi $t3		# Moves reaminder to temp $t3
	
	beq $t3, $zero, tPeDiv	# if reaminder == 0, goto tPeDiv
	
	j tPeFor
	
tPeDiv:
	add $t2, $t2, $t1
	j tPeFor

	
tPeReturn:

	add $t2, $t2, 1
	beq $t2, $a0, tPePerfect
	b tPeNotPerfect
	
tPePerfect:
	add $s6, $s6, 1
	jr $t7
	
tPeNotPerfect:
	jr $t7

	



display:
	#Highest number
	li $v0, 4		
	la $a0, outputHighest
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	#Lowest number
	li $v0, 4
	la $a0, outputLowest
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	# Even numbers sum
	li $v0, 4
	la $a0, outputEvenSum
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	# Odd number sums
	li $v0, 4
	la $a0, outputOddSum
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	# Prime numbers
	li $v0, 4
	la $a0, outputPrimeNumbers
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	# Amicable numbers
	li $v0, 4
	la $a0, outputAmicableNumbers
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	# Perfect numbers
	li $v0, 4
	la $a0, outputPerfectNumbers
	syscall
	
	li $v0, 1
	move $a0, $s6
	syscall
	
	jr $ra	# Return	




exit:
	li $v0, 10		# Code to terminate program
	syscall			# Finalizes the program	
