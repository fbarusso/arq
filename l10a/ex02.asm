.data

buffer:		.asciiz " "
arquivo:	.asciiz "dados2.txt"
erro:		.asciiz "Arquivo nao encontrado\n"
soma:		.asciiz "Soma: "
multiplicacao:	.asciiz " Multiplicacao: "
pares:		.asciiz " Pares: "
impares:	.asciiz " Impares: "
caracteres:	.asciiz " Caracteres: "
maior:		.asciiz " Maior:"
menor:		.asciiz " Menor:"

.text

main:		la $a0, arquivo		# nome do arquivo
		li $a1, 0 		# somente leitura
		jal abertura		# retorna file descriptor no sucesso
		
		move $s0, $v0		# salva file descriptor em $s0
		move $a0, $s0		# parametro $a0 recebe file descriptor
		
		la $a1, buffer		# buffer de entrada
		li $a2, 1		# caractere por leitura
 
		jal somar		# printa a soma dos elementos do arquivo
		
		jal reabrirArquivo	# reabre o arquivo
		
		jal multiplicar		# printa a multiplicacao dos elementos do arquivo
		
		jal reabrirArquivo	# reabre o arquivo
		
		jal numerosPares	# printa a quantidade de elementos pares
		
		jal reabrirArquivo	# reabre o arquivo
		
		jal contagem		# printa o numero de caracteres no arquivo
		
		jal reabrirArquivo	# reabre o arquivo
		
		jal getPrimeiro		# retorna o primeiro numero do arquivo
		
		move $s1, $v0		# $s1 recebe o primeiro numero do arquivo
		
		jal reabrirArquivo	# reabre o arquivo
		
		jal getMaior		# printa o maior numero
		
		jal reabrirArquivo	# reabre o arquivo
		
		jal getPrimeiro		# retorna o primeiro numero do arquivo
		
		move $s1, $v0		# $s1 recebe o primeiro numero do arquivo
		
		jal getMenor		# printa o maior numero
		
		jal fecharArquivo	# fecha o arquivo
		
		j finalizar		# finaliza o programa 
		
abertura:	li $v0, 13		# código de abertura de arquivo
		syscall			# tenta abrir o arquivo
		bgez $v0, aberto	# if (fileDescriptor >= 0) goto suscesso
		
		la $a0, erro		# else erro: carrega o endereço da string
		li $v0, 4		# código para impressão de string
		syscall			# imprime o erro
		
		j finalizar		# finaliza o programa
		
aberto:		jr $ra			# retorna para a main
		
somar:		li $t0, 0		# $t0 = 0
		li $t1, 0		# $t1 = 0
		li $t2, 0		# $t2 = 0
		li $t3, 0		# $t3 = 0

inicioS:	li $v0, 14		# codigo de leitura de arquivo
		syscall			# faz a leitura de 1 caractere
		beqz $v0, fimS		# if (EOF) termina a soma
		lb $t0, ($a1)		# carrega o caractere lido no buffer
		beq $t0, 13, inicioS	# if (carriage return) ignora
		beq $t0, 10, s		# if (newline) goto s
		beq $t0, 32, s		# if (space) goto s
		subi $t0, $t0, 48	# char para decimal
		mul $t1, $t1, 10	# casa decimal para esquerda
		add $t1, $t1, $t0	# soma da unidade lida
		j inicioS		# continua a leitura do numero
s:		add $t2, $t2, $t1	# soma o numero lido
		li $t1, 0		# zera o numero
		j inicioS		# leitura do proximo numero
fimS:		add $t3, $t2, $t1	# $t3 recebe o resultado da soma

		la $a0, soma		# carrega o endereço da string
		li $v0, 4		# código para printar string
		syscall			# printa a string
		
		move $a0, $t3		# parametro $a0 recebe o resultado
		li $v0, 1		# código para printar int
		syscall			# printa o int
		
		jr $ra			# retorna para a main
		
multiplicar:	li $t0, 0		# $t0 = 0
		li $t1, 0		# $t1 = 0
		li $t2, 1		# $t2 = 1
		li $t3, 0		# $t3 = 0

inicioMu:	li $v0, 14		# codigo de leitura de arquivo
		syscall			# faz a leitura de 1 caractere
		beqz $v0, fimMu		# if (EOF) termina a multiplicacao
		lb $t0, ($a1)		# carrega o caractere lido no buffer
		beq $t0, 13, inicioMu	# if (carriage return) ignora
		beq $t0, 10, mu		# if (newline) goto mu
		beq $t0, 32, mu		# if (space) goto mu
		subi $t0, $t0, 48	# char para decimal
		mul $t1, $t1, 10	# casa decimal para esquerda
		add $t1, $t1, $t0	# soma da unidade lida
		j inicioMu		# continua a leitura do numero
mu:		mul $t2, $t2, $t1	# adiciona o numero lido
		li $t1, 0		# zera o numero
		j inicioMu		# leitura do proximo numero
fimMu:		mul $t3, $t2, $t1	# $t3 recebe o resultado da multiplicacao

		la $a0, multiplicacao	# carrega o endereço da string
		li $v0, 4		# código para printar string
		syscall			# printa a string
		
		move $a0, $t3		# parametro $a0 recebe o resultado
		li $v0, 1		# código para printar int
		syscall			# printa o int
		
		jr $ra			# retorna para a main
		
numerosPares:	li $t0, 0		# $t0 = 0
		li $t1, 0		# $t1 = 0
		li $t2, 0		# $t2 = 0
		li $t3, 0		# $t3 = 0 pares
		li $t4, 0		# $t4 = 0 impares

inicioNP:	li $v0, 14		# codigo de leitura de arquivo
		syscall			# faz a leitura de 1 caractere
		beqz $v0, fimNP		# if (EOF) termina a soma
		lb $t0, ($a1)		# carrega o caractere lido no buffer
		beq $t0, 13, inicioNP	# if (carriage return) ignora
		beq $t0, 10, nP		# if (newline) goto s
		beq $t0, 32, nP		# if (space) goto s
		subi $t0, $t0, 48	# char para decimal
		mul $t1, $t1, 10	# casa decimal para esquerda
		add $t1, $t1, $t0	# soma da unidade lida
		j inicioNP		# continua a leitura do numero
nP:		div $t1, $t1, 2		# divide o numero por 2
		mfhi $t2		# $t2 recebe o resto
		bnez $t2, imparNP	# if impar goto imparNP
		addi $t3, $t3, 1	# pares ($t3) ++
		j continueNP		# continua
imparNP:	addi $t4, $t4, 1	# impares ($t4) ++
continueNP:	li $t1, 0		# zera o numero
		j inicioNP		# leitura do proximo numero
		
fimNP:		div $t1, $t1, 2		# divide o numero por 2
		mfhi $t2		# $t2 recebe o resto
		bnez $t2, imparNP2	# if impar goto imparNP
		addi $t3, $t3, 1	# pares ($t3) ++
		j continueNP2		# continua
imparNP2:	addi $t4, $t4, 1	# impares ($t4) ++

continueNP2:	la $a0, impares		# carrega o endereço da string
		li $v0, 4		# código para printar string
		syscall			# printa a string
		
		move $a0, $t4		# parametro $a0 recebe o resultado
		li $v0, 1		# código para printar int
		syscall			# printa o int

		la $a0, pares		# carrega o endereço da string
		li $v0, 4		# código para printar string
		syscall			# printa a string
		
		move $a0, $t3		# parametro $a0 recebe o resultado
		li $v0, 1		# código para printar int
		syscall			# printa o int

		jr $ra			# retorna para a main
		
contagem:	li $t0, 0		# $t0 = 0
co:		li $v0, 14		# código de leitura de arquivo
		syscall			# lê um caractere
		beqz $v0, sairCo	# if (EOF) goto sairCo
		addi $t0, $t0, 1
		j co
sairCo:		la $a0, caracteres	# carrega o endereço da string
		li $v0, 4		# código para printar string
		syscall			# printa a string
		move $a0, $t0		# parametro $a0 recebe o resultado
		li $v0, 1		# código para printar int
		syscall			# printa o int
		jr $ra			# retorna pra main

getPrimeiro:	li $t0, 0		# $t0 = 0
		li $t1, 0		# $t1 = 0
		li $t2, 0		# $t2 = 0
		
gP:		li $v0, 14		# codigo de leitura de arquivo
		syscall			# faz a leitura de 1 caractere
		lb $t0, ($a1)		# carrega o caractere lido no buffer
		beq $t0, 13, gP		# if (carriage return) ignora
		beq $t0, 10, fimGP	# if (newline) goto gP
		beq $t0, 32, fimGP	# if (space) goto gP
		subi $t0, $t0, 48	# char para decimal
		mul $t1, $t1, 10	# casa decimal para esquerda
		add $t1, $t1, $t0	# soma da unidade lida
		j gP			# continua a leitura do numero
fimGP:		add $v0, $t2, $t1	# $s1 recebe o primeiro numero
		jr $ra			# retorna para a main
		
getMaior:	li $t0, 0		# $t0 = 0
		li $t1, 0		# $t1 = 0
		li $t2, 0		# $t2 = 0
		li $t3, 0		# $t3 = maior

inicioGMa:	li $v0, 14		# codigo de leitura de arquivo
		syscall			# faz a leitura de 1 caractere
		beqz $v0, fimGMa	# if (EOF) termina a soma
		lb $t0, ($a1)		# carrega o caractere lido no buffer
		beq $t0, 13, inicioGMa	# if (carriage return) ignora
		beq $t0, 10, gMa	# if (newline) goto s
		beq $t0, 32, gMa	# if (space) goto s
		subi $t0, $t0, 48	# char para decimal
		mul $t1, $t1, 10	# casa decimal para esquerda
		add $t1, $t1, $t0	# soma da unidade lida
		j inicioGMa		# continua a leitura do numero
gMa:		bge $t1, $s1, mudaMaior	# se o numero lido for maior que $s1
		j continueGMa
mudaMaior:	move $s1, $t1
continueGMa:	li $t1, 0		# zera o numero
		j inicioGMa		# leitura do proximo numero
		
fimGMa:		bge $t1, $s1, mudaMaior2# se o numero lido for maior que $s1
		j continueGMa2
mudaMaior2:	move $s1, $t1
continueGMa2:	la $a0, maior		# carrega o endereço da string
		li $v0, 4		# código para printar string
		syscall			# printa a string
		
		move $a0, $s1		# parametro $a0 recebe o resultado
		li $v0, 1		# código para printar int
		syscall			# printa o int
		
		jr $ra			# retorna para a main
		
getMenor:	li $t0, 0		# $t0 = 0
		li $t1, 0		# $t1 = 0
		li $t2, 0		# $t2 = 0
		li $t3, 0		# $t3 = menor

inicioGMe:	li $v0, 14		# codigo de leitura de arquivo
		syscall			# faz a leitura de 1 caractere
		beqz $v0, fimGMe	# if (EOF) termina a soma
		lb $t0, ($a1)		# carrega o caractere lido no buffer
		beq $t0, 13, inicioGMe	# if (carriage return) ignora
		beq $t0, 10, gMe	# if (newline) goto s
		beq $t0, 32, gMe	# if (space) goto s
		subi $t0, $t0, 48	# char para decimal
		mul $t1, $t1, 10	# casa decimal para esquerda
		add $t1, $t1, $t0	# soma da unidade lida
		j inicioGMe		# continua a leitura do numero
gMe:		ble $t1, $s1, mudaMenor	# se o numero lido for menor que $s1
		j continueGMe
mudaMenor:	move $s1, $t1
continueGMe:	li $t1, 0		# zera o numero
		j inicioGMe		# leitura do proximo numero
		
fimGMe:		ble $t1, $s1, mudaMenor2# se o numero lido for maior que $s1
		j continueGMe2
mudaMenor2:	move $s1, $t1
continueGMe2:	la $a0, menor		# carrega o endereço da string
		li $v0, 4		# código para printar string
		syscall			# printa a string
		
		move $a0, $s1		# parametro $a0 recebe o resultado
		li $v0, 1		# código para printar int
		syscall			# printa o int
		
		jr $ra			# retorna para a main
		


		
reabrirArquivo:	subi $sp, $sp, 4	# espaco para 1 item na pilha
		sw $ra, ($sp)		# salva o retorno para a main
		jal fecharArquivo	# fecha o arquivo
		la $a0, arquivo		# nome do arquivo
		li $a1, 0 		# somente leitura
		jal abertura		# retorna file descriptor no sucesso
		move $s0, $v0		# salva file descriptor em $s0
		move $a0, $s0		# parametro $a0 recebe file descriptor
		la $a1, buffer		# buffer de entrada
		li $a2, 1		# caractere por leitura
		lw $ra, ($sp)		# recupera o retorno para a main
		addi $sp, $sp, 4	# libera espaco na pilha
		jr $ra			# retorna para a main
		
fecharArquivo:	li $v0, 16		# código para fechar o arquivo
		move $a0, $s0		# parametro $a0 recebe file descriptor
		syscall			# fecha o arquivo
		jr $ra			# retorna para o caller

finalizar:	li $v0, 10		# código para finalizar o programa
		syscall			# finaliza o programa
