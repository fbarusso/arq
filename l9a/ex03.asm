.data
numeroAlunos: .asciiz "Insira o numero de alunos: "
mediaAluno: .asciiz "Média do aluno "
alunosAprovados: .asciiz "Numero de alunos aprovados (media >= 6,0): "
alunosReprovados: .asciiz "Numero de alunos reprovados (media < 6,0): "
mediaSala: .asciiz "Media da sala: "
entradaMatriz: .asciiz "Insira a nota "
entradaMatriz2: .asciiz " do aluno "
entradaMatriz3: .asciiz ": "
quebraDeLinha: .asciiz "\n"
espaco: .asciiz " "
zero: .float 0.0
tres: .float 3.0
sessenta: .float 6.0

.text

main: 
	li $a2, 3		# $a2 = 3
	lwc1 $f7, tres		# $f7 = 3.0
	
	la $a0, numeroAlunos	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	li $v0, 5		# leitura do numero de alunos
	syscall			# leitura do valor (retorna em $v0)
	
	move $a1, $v0		# $a1 = $v0
	mtc1 $a1, $f13		# $f13 = (float) $a1
  	cvt.s.w $f13, $f13
	
	mul $t0, $a1, $a2	# $t0 = $a1 x #a2
	mul $a0, $t0, 4		# $a0 = tamanho da matriz * 4
	li $v0, 9		# código de alocação dinamica
	syscall			# aloca tamanho * 4 bytes (endereço em $v0)
	
	li $t0, 0		# $t0 = 0
	la $a0, ($v0)		# $a0 aponta para $v0 (local onde a matriz esta alocada)
	
	jal leitura		# leitura ()
	move $a0, $v0		# move o endereço da matriz para argumento $a0
	
	li $t5, 0		# contador de alunos reprovados
	li $t6, 0		# contador de alunos aprovados
	
	jal percorreLinhas	# percorreLinhas (), funcao que faz as verificacoes na matriz
	
	jal imprimirResultados	# imprimeResultados ()
	
	li $v0, 10		# código para finalizar o programa
	syscall			# finaliza o programa

indice:	mul $v0, $t0, $a2	# i * numeroColunas
	add $v0, $v0, $t1	# (i * numeroColunas) + j
	sll $v0, $v0, 2		# [(i * numeroColunas) + j] * 4 (inteiro)
	add $v0, $v0, $a3	# soma o endereço base de matriz
	jr $ra			# retorna para o caller

leitura:subi $sp, $sp, 4	# espaço para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno para a main
	move $a3, $a0		# aux = endereço base de matriz
	
l:	la $a0, entradaMatriz	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	move $a0, $t1		# valor de j para impressao
	addi $a0, $a0, 1	# $a0++
	li $v0, 1		# código de impressao de inteiro
	syscall			# imprime j	
	
	la $a0, entradaMatriz2	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	move $a0, $t0		# valor de i para impressao
	addi $a0, $a0, 1	# $a0++
	li $v0, 1		# código de impressao de inteiro
	syscall			# imprime i
	
	la $a0, entradaMatriz3	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	li $v0, 6		# codigo de leitura de float
	syscall			# leitura do valor (retorna em $v0)
	
	mov.s $f2, $f0		# aux = valor lido
	
	jal indice		# calcula o endereço de matriz[i][j]
	
	s.s $f2, ($v0)		# matriz[i][j] = aux
	
	addi $t1, $t1, 1	# j++
	blt $t1, $a2, l		# if (j < numeroColunas1) goto 1
	li $t1, 0		# j = 0
	
	addi $t0, $t0, 1	# i++
	blt $t0, $a1, l		# if (i < numeroLinhas) goto 1
	li $t0, 0		# i = 0
	
	lw $ra, ($sp)		# recupera o retorno para a main
	addi $sp, $sp, 4	# libera o espaço na pilha
	move $v0, $a3		# endereço da matriz para retorno
	
	jr $ra

percorreLinhas:
	subi $sp, $sp, 4	# espaço para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno para a main
	move $a3, $a0		# aux = endereço base de matriz
	li $s0, 0		# media turma
	li $s1, 0		# numero reprovados
	li $s2, 0		# numero aprovados
	li $t4, 0		# variavel intermediaria: media aluno
	lwc1 $f8, zero		# $f8 = o.0
	
	la $a0, quebraDeLinha	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
pL:	jal indice		# calcula o endereço de matriz[i][j]
	
	l.s $f0, ($v0)		# $f0 = valor de matriz[i][j]
	add.s $f3, $f3, $f0	# $f3 = $f3 + $f0
	
	addi, $t1, $t1, 1	# i++
	blt $t1, $a2, pL	# if (i < numeroLinhas) goto pL
	
	bne $s0, 0, continueLinhas
	
continueLinhas:
	div.s $f4, $f3, $f7	# $f4 = $f3/$f7
	mov.s $f12, $f4		# $f12 = $f4
	add.s $f8, $f8, $f4	# f8 = $f8 + $f4
	
	lwc1 $f9, sessenta	# $f9 = 60.0
	
	jal definirSituacao	# definirSituacao ()
	
	la $a0, mediaAluno	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	move $a0, $t0		# $a0 = $t0
	addi $a0, $a0, 1	# $a0++
	li $v0, 1		# código de impressao de inteiro
	syscall			# imprime i
	
	la $a0, entradaMatriz3	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	li $v0, 2		# código de impressao de float
	syscall			# imprime i
				
	la $a0, espaco		# carrega o endereço da string
	li $v0, 4		# código de impressao de string
	syscall			# imprime a string
	
	la $a0, quebraDeLinha	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	lwc1 $f3, zero		# $f3 = 0.0
	li $t1, 0 		# i = 0
	
	addi $t0, $t0, 1	# j++
	
	blt $t0, $a1, pL	# if (j < numeroColunas) goto pL
	
	li $t0, 0		# j = 0
	
	lw $ra, ($sp)		# recupera o endereço de retorno pra main
	addi $sp, $sp, 4	# libera espaço na pilha
	move $v0, $a3		# endereço base da matriz para retorno
	
	jr $ra 			#retorna para a main
	
definirSituacao:
	c.lt.s $f4, $f9		# if $f4 < 60.0
	bc1t reprovado		# go to reprovado
	c.lt.s $f4, $f9		# else
	bc1f aprovado		# go to aprovado

	jr $ra
	
aprovado:
	addi $t6, $t6, 1	# alunosAprovados++
	jr $ra

reprovado:
	addi $t5, $t5, 1	# alunosReprovados++
	jr $ra
	
imprimirResultados:
	div.s $f8, $f8, $f13	# $f8 = $f8/$f13
	la $a0, mediaSala 	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	mov.s $f12, $f8		# $f12 = $f8
	li $v0, 2		# código de impressao de float
	syscall			# imprime i
	
	la $a0, quebraDeLinha	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imrprime a string
	
	la $a0, alunosReprovados# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	move $a0, $t5		# $a0 = $t5
	li $v0, 1		# código de impressao de inteiro
	syscall			# imprime i
	
	la $a0, quebraDeLinha	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	la $a0, alunosAprovados	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall	
				
	move $a0, $t6		# $a0 = $t6
	li $v0, 1		# código de impressao de inteiro
	syscall			# imprime i
	
	jr $ra
	 	

	
	
