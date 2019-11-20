Main:	li $t0 0		# Contador i
	li $t1 0		# Soma parcial
	li $s0 0		# Soma total
	
Loop:	beq $t0, 20, Exit	# Se contador for 20, vai para Exit
	addi $t0, $t0, 1	# Adiciona 1 ao contador
	mul $t1, $t0, 4		# Multiplcia contador por 4 e guarda o resultado em soma parcial
	addi $t1, $t1, 2	# Adiciona 2 à soma parcial
	add $s1, $s1, $t1	# Adiciona a soma parcial à soma total
	
	j Loop			# Jump incondicional para Loop
	
Exit:	li $v0, 1		# Sistema para printar Int
	move $a0, $s1		# Move o contúdo de $s1 para $a0
	syscall			# Chama o sistema
	
