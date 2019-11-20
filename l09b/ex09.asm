.data

entradaX: 	.asciiz "Numero inteiro x: "
entradaY: 	.asciiz "Numero inteiro y: "
saida:		.asciiz "Numero de divisoes possiveis: "

.text

main:		la $a0, entradaX	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
		
		li $v0, 5		# codigo de leitura de inteiro
		syscall			# leitura do valor (retorna em $v0)
		
		move $t0, $v0		# aux $t0 = x
		
		la $a0, entradaY	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
		
		li $v0, 5		# codigo de leitura de inteiro
		syscall			# leitura do valor (retorna em $v0)
		
		move $a0, $t0		# parametro $a0 = x
		move $a1, $v0		# parametro $a1 = y
		
		jal divisivel		# divisivel(x, y), retorna o numero de vezes que y divide x em $v0
		
		move $a0, $v0		# parametro $a0 recebe o retorno $v0
		
		jal imprime		# imprime(resultado), imprime -1 caso não seja possível realizar a divisão
		
		j finalizar		# finaliza o programa
		
divisivel: 	bgt $a1, $a0, falso	# caso y > x, retorna -1
		beq $a1, 1 falso	# caso y = 1, retorna -1
		beq $a1, -1 falso	# caso y = -1, retorna -1

		li $v0, 0		# retorno = 0
		
d:		div $a0, $a1		# x / y
	
		mfhi $t0		# aux $t0 = resto de x / y
		
		bne $t0, $zero, fim	# caso resto != 0, não é divisivel
		
		div $a0, $a0, $a1	# x = x / y
		
		addi $v0, $v0, 1	# retorno++
		
		bge $a0, $a1, d		# se x > y goto d

fim:		jr $ra			# retorna para o caller
		
falso:		li $v0, -1		# retorno $v0 recebe -1
		jr $ra			# retorna para o caller
		
imprime:	move $t0, $a0		# aux $t0 recebe o parametro $a0 (resultado)

		la $a0, saida		# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string

		move $a0, $t0		# valor de $t0 (resultado) para impressao
		li $v0, 1		# código de impressao de inteiro
		syscall			# imprime resultado
		
		jr $ra			# retorna para o caller
		
finalizar:	li $v0, 10		# código para finalizar o programa
		syscall			# finaliza o programa
