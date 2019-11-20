.data
N: .asciiz "N = " 
Resultado: .asciiz "Numero na posicao N: "

.text
main:
	la $a0, N		# Carrega a string em $v0
	li $v0, 4		# Codigo para impressao de string
	syscall			# Chamada de sistema para o print
	
	li $v0, 5		# Codigo para ler um inteiro	
	syscall			# Chamada de sistema para a leitura
	move $a0, $v0		# $a0 = $v0
	
	li $t2,1		# $t2 = 1
	jal fib			# fib (int n)
	
	j imprimeResultado	# imprimeResultado ()
	
fib:
	bgt $a0, 1, recursao	# if $a0 > 1 go to recursao
	beqz $a0, zero		# if $a0 = 0 go to zero
	beq $a0, $t2, um	# if $a0 = 1 go to um	
	jr $ra			# retorna pro caller

zero:
	li $v0, 0		# retorno recebe 0
	jr $ra			# retorna pro caller
um:
	li $v0, 1		# retorno recebe 1
	jr $ra			# retorna pro caller
		
recursao:
	sub $sp, $sp, 12
	sw $ra, 0($sp)		# guarda $ra
	sw $a0, 4($sp)		# guarda n
	
	addi $a0, $a0, -1 	# (n-1)
	jal fib			# fib (n-1)
	lw $a0, 4($sp)		
	sw $v0, 8($sp)		# salva o retorno de fib(n-1)
	
	addi $a0, $a0, -2	# (n-2)
	jal fib 		# fib (n-2)
	lw $t0, 8($sp)		
	add $v0, $t0, $v0	# retorna fib (n-1) + fib (n-2)
	
	lw $ra, 0($sp)		
	sub $sp, $sp, -12
	
	jr $ra			# retorna pro caller
	
imprimeResultado:
	move $t1, $v0		# $t1 = $v0
	
	la $a0, Resultado	# Carrega a string em $v0
	li $v0, 4		# Codigo para impressao de string
	syscall			# Chamada de sistema para o print
	
	move $a0, $t1		# $a0 = $t1
	li $v0, 1		# Codigo para imprimir int
	syscall			# Chamada de sistema para imprimir o int
	
exit:
	li $v0, 10		# Codigo para finalizar o programa
	syscall			# Chamada de sistema para finalizar o programa
	
