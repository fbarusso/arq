.data

buffer:		.space 20
newline:	.asciiz "\r\n"
arquivo:	.asciiz "saida.txt"

.text

main:		jal abrirArquivo	# retorna file descriptor em $v0
		move $s0, $v0		# salva file descriptor em $s0
		jal fecharArquivo	# fecha o arquivo		
		jal sair		# finaliza o programa
		

testarPrimo:	beq $a0, 1, naoPrimo	# if (n == 1) goto naoPrimo
		beq $a0, 2, primo	# if (n == 2) goto primo
		li $t0, 2		# i = 2
tP:		div  $a0, $t0		# num / i
		mfhi, $t1		# aux = resto
		beq, $t1, 0, naoPrimo	# if (aux == 0) goto naoPrimo
		add $t0, $t0, 1 	# i++
		blt $t1, $a0, tP	# if (i < n) goto tP
primo:		jr $ra			# Return	
naoPrimo:	jr $ra			# Return
		
intToString:	div $a0, $a0, 10	# n = n / 10
		mfhi $t0		# aux = resto
		subi $sp, $sp, 4	# espaço para 1 item na pilha
		sw $t0, ($sp)		# empilha o resto da divisão
		addi $v0, $v0, 1	# número de caracteres++
		bnez $a0, intToString	# if (n != 0) goto intToString
iTS:		lw $t0, ($sp)		# desempilha um resto de divisão
		addi $sp, $sp, 4	# libera espaço de 1 item na pilha
		add $t0, $t0, 48	# converte a unidade (0-9) para caractere
		sb $t0, ($a1)		# aramazena no buffer de saida
		addi $a1, $a1, 1	# incrementa o endereço do buffer
		addi $t1, $t1, 1	# i++
		bne $t1, $v0, iTS	# if (iterações != caracteres) goto iTS
		sb $zero, ($a1)		# armazena NULL no buffer de saida
		li $t0, 0		# reseta $t0
		li $t1, 1		# reseta $t1
		jr $ra			# retorna para o caller

abrirArquivo:	la $a0, arquivo		# nome do arquivo
		li $a1, 1		# somente escrita
		li $v0, 13		# código de abertura de arquivo
		syscall			# abre o arquivo (se não existir, será criado)
		jr $ra			# retorna para o caller
		
fecharArquivo:	move $a0, $s0		# parâmetro $a0 recebe file descriptor
		li $v0, 16		# código para fechar o arquivo
		syscall			# fecha o arquivo
		jr $ra			# retorna para caller
		
sair:		li $v0, 10		# código para finalizar o programa
		syscall			# finaliza o programa
