.data
vetA: .space 40
vetB: .space 40
entradaA: .asciiz "Insira VetA["
entradaB: .asciiz "Insira vetB["
entradaAux: .asciiz "]: "
saidaA: .asciiz "Somatoria dos elementos em posicoes pares do VetA: "
saidaB: .asciiz "Somatoria dos elementos em posicoes impares do VetB: "
breakLine: .asciiz "\n"

.text
main: 	
	li $s0, 0		#Carrega $s0 com 0
	li $s1, 0		#Carrega $s1 com 0
	la $a0, vetA		#Carrega $a0 com o endereço base de vetA
	jal scanA		#Faz a leitura do vetA
	
	la $a0, vetB		#Carrega $a0 com o endereço base de vetB
	jal scanB		#Faz a leitura do vetB
	
	la $a0, vetA		#Carrega $a0 com o endereço base de vetA
	jal sumPairs		#Soma todos os elementos das posições pares do vetA e salva o resultado em $s0
	
	la $a0, vetB		#Carrega $a0 com o endereço base de vetB
	jal sumOdd		#Soma todos os elementos das posições ímpares do vetB e salva o resultado em $s1
	
	move $a0, $s0		#Carrega $a0 com $s0
	jal printSumP		#Imprime o resultado de somatória contido em $s0
	
	move $a0, $s1		#Carrega $a0 com $s1
	jal printSumO		#Imprime o resultado da somatória contido em $s1
	
	j exit			#Encerra o programa

scanA:	
	move $t0, $a0		#Salva o endereço base de vetA em $t0
	move $t1, $t0		#$t1 recebe o endereço base de vetA ($t1 será incrementado)
	li $t2, 0		#Carrega $t2 com 0
lA:	la $a0, entradaA	#Carrega a string contida em entradaA em $a0
	li $v0, 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	move $a0, $t2 		#Move o conteúdo de $t2 para $a0
	li $v0, 1		#Código de impressão de inteiro
	syscall			#Chamada de sistema
	
	la $a0, entradaAux	#Carrega a string contida em entradaAux em $a0
	li $v0, 4		#Código para impressão de string
	syscall			#Chamada de sistema
	
	li $v0, 5		#Código para leitura de inteiro
	syscall			#Chamada de sistema
	
	sw $v0, ($t1)		#Salva o valor lido no endereço salvo por $t1
	addi $t1, $t1, 4	#Incrementa o endereço do vetor em 1 posição
	addi $t2, $t2, 1	#Incrementa $t2 em 1
	blt $t2, 10, lA		#Pula para lA se $s0 for menor que 10
	move $v0, $t0		#Retorna o endereço base de vetA
	jr $ra			#Retorna para instrução seguinte a chamada de função
	
scanB:	
	move $t0, $a0		#Salva o endereço base de vetB em $t0
	move $t1, $t0		#$t1 recebe o endereço base de vetB ($t1 será incrementado)
	li $t2, 0		#Carrega $t2 com 0
lB:	la $a0, entradaB	#Carrega a string contida em entradaB em $a0
	li $v0, 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	move $a0, $t2 		#Move o conteúdo de $t2 para $a0
	li $v0, 1		#Código de impressão de inteiro
	syscall			#Chamada de sistema
	
	la $a0, entradaAux	#Carrega a string contida em entradaAux em $a0
	li $v0, 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	li $v0, 5		#Código para leitura de inteiro
	syscall			#Chamada de sistema
	
	sw $v0, ($t1)		#Salva o valor lido no endereço salvo por $t1
	addi $t1, $t1, 4	#Incrementa o endereço do vetor em 1 posição
	addi $t2, $t2, 1	#Incrementa $t2 em 1
	blt $t2, 10, lB		#Pula para lB se $s0 for menor que 10
	move $v0, $t0		#Retorna o endereço base de vetB
	jr $ra			#Retorna para o ponto seguinte a chamada de função
	
sumPairs:
	move $t0, $a0		#Salva o endereço base do vetor em $t0
	move $t1, $t0		#Salva o endereço base do vetor em $t1 ($t1 será incrementado)
	li $t2, 0		#$t2 recebe 0
pair:	lw $t3, ($t1)		#t3 recebe o conteúdo salvo na posição $t1 do vetor
	add $s0, $s0, $t3	#Adiciona o valor contido em $t3 ao registrador soma $s0
	addi $t1, $t1, 8	#Incrementa o endereço do vetor em 2 posições
	addi $t2, $t2, 2	#Incrementa o contador em 2
	blt $t2, 10, pair	#Pula para pair se o contador for menor que 10
	move $v0, $t0		#Retorna o endereço base do vetor
	jr $ra			#Retorna para o ponto seguinte a chamada de função
	
sumOdd:
	move $t0, $a0		#Salva o endereço base do vetor em $t0
	move $t1, $t0		#Salva o endereço base do vetor em $t1 ($t1 será incrementado)
	add $t1, $t1, 4		#Incrementa o endereço do vetor em 1 posição
	li $t2, 1		#$t2 recebe 1
odd:	lw $t3, ($t1)		#t3 recebe o conteúdo salvo na posição $t1 do vetor
	add $s1, $s1, $t3	#Adiciona o valor contido em $t3 ao registrador soma $s1
	addi $t1, $t1, 8	#Incrementa o endereço do vetor em 2 posições
	addi $t2, $t2, 2	#Incrementa o contador em 2
	blt $t2, 10, odd	#Pula para pair se o contador for menor que 10
	move $v0, $t0		#Retorna o endereço base do vetor
	jr $ra			#Retorna para o ponto seguinte a chamada de função
	
printSumP:
	move $t0, $a0		#Move o conteúdo de $a0 para $t0
	la $a0, saidaA		#Carrega $a0 com a string contida em saidaA
	li $v0, 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	move $a0, $t0		#Move o conteúdo de $t0 para $a0
	li $v0, 1		#Código de impressão de inteiro
	syscall			#Chamada de sistema
	
	la $a0, breakLine	#Carrega $a0 com a string contida em breakLine
	li $v0, 4		#Código para impressão de string
	syscall			#chamada de sistema
	
	jr $ra			#Retorna para o ponto seguinte a chamada de função
	
printSumO:
	move $t0, $a0		#Move o conteúdo de $a0 para $t0
	la $a0, saidaB		#Carrega $a0 com a string contida em saidaB
	li $v0, 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	move $a0, $t0		#Move o conteúdo de $t0 para $a0
	li $v0, 1		#Código de impressão de inteiro
	syscall			#Chamada de sistema
	
	jr $ra			#Retorna para o ponto seguinte a chamada de função
	
exit:	
	li $v0, 10		#Código para finalização do programa
	syscall			#Chamada de sistema
