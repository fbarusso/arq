.data
entradaN: .asciiz "Insira o numero de posicoes do vetor: "
entradaVet: .asciiz "Insira vet["
entradaAux: .asciiz "]: "
saida: .asciiz "Soma do maior segmento: "

.text

#variáveis
#	$s0 = tamanho do vetor
#	$s1 = endereço base do vetor
#	$s2 = maior
#	$s3 = soma

main:
	jal n
	move $s0, $v0		#Salva em $s0 o valor lido
	
	move $a0, $s0		#Passa o tamanho do vetor para o argumento $a0
	jal alloc
	move $s1, $v0 		#Salva o endereço base do vetor retornado da função alloc em $s1
	
	move $a0, $s1		#Passa o endereço base do vetor para o argumento $a0
	move $a1, $s0		#Passa o tamanho do vetor para o argumento $a1
	jal scanVet
	
	move $a0, $s1		#Passa o endereço base do vetor para o argumento $a0
	move $a1, $s0		#Passa o tamanho do vetorpara o argumento $a1
	jal segSum
	
	move $a0, $s2		#Passa maior para o argumento $a0
	jal printInt
	
	j exit
	 
n:
	la $a0, entradaN
	li $v0, 4		#Código de impressão de string
	syscall
	
	li $v0, 5		#Código de leitura de inteiro
	syscall
	
	jr $ra
	
alloc:
	mul $a0, $a0, 4		#Multiplica o tamanho do vetor por 4 bits
	li $v0, 9		#Código de alocação dinâmica
	syscall
	
	jr $ra

scanVet:
	move $t0, $a0		#Salva o endereço base do vetor em $t0
	move $t1, $t0		#Salva o endereço base do vetor em $t1 ($t1 será incrementado)
	li $t2, 0		#$t2 recebe 0 (contador de verificação)
	move $t3, $a1		#Salva o tamanho do vetor em $t3
	
l:	la $a0, entradaVet	
	li $v0, 4		#Código de impressão de string
	syscall
	
	move $a0, $t2
	li $v0, 1		#Código de impressão de inteiro
	syscall
	
	la $a0, entradaAux
	li $v0, 4		#Código de impressão de string
	syscall
	
	li $v0, 5		#Código de leitura de inteiro
	syscall
	
	sw $v0, ($t1)		#Salva o valor lido no endereço armazenado em $t1
	addi $t1, $t1, 4	#Incrementa o endereço do vetor
	addi $t2, $t2, 1	#Incrementa o contador
	
	blt $t2, $t3, l		#Pula para l se o contador for menor que o tamanho do vetor
	
	jr $ra
	
segSum:
	move $t0, $a0		#Passa o endereço base do vetor para $t0
	move $t1, $t0		#Passa o endereço base do vetor para $t1(será incementado)
	move $t3, $a1		#Passa o tamanho do vetor para $t3
	li $t4, 0		#Variável X (para verificação)
	li $t5, 0		#Variável Y (para verificação)
	li $t6, 0		#Contador i
	lw $s2, ($t0)		#maior = vet[0]
	la $s3, 0		#soma = 0
	
while:
	bne $t5, $t3, v1	#Se Y != N pula para v2
	jr $ra			#Volta para a main (break)
	
v1:	move $t6, $t5		#i = Y
	
for:	mul $t1, $t6, 4		#Multiplica o contador por 4 para ter o endereço da posição do vetor e salva em $t1
	add $t1, $t1, $t0	#Adiciona o valor salvo em $t1 ao endereço base do vetor, e salva em $t1
	lw $t7, ($t1)		#Salva o conteudo do endereço armazenado em $t1 em $t7
	add $s3, $s3, $t7	#Adiciona esse valor a $s3 (soma)
	addi $t6, $t6, 1	#Incrementa o contador em 1
	blt $t6, $t4, for	#Volta para o loop se i < X
	
	bne $t4, $t3, v2	#Se X != N pula vara v1
	addi $t5, $t5, 1	#incrementa Y em 1
	move $t4, $t5		#X = Y
	
v2:	blt $s3, $s2, v3	#Se soma < maior, pula para v3
	move $s2, $s3		#maior = soma
	
v3:	li $s3, 0		#Reseta $s3 (soma)
	addi $t4, $t4, 1	#Incrementa X em 1
	
	j while			#Pula para while
	
printInt:
	move $t0, $a0		#Passa maior para $t0
	
	la $a0, saida		#Carrega $a0 com saida
	li $v0, 4		#Código para impressão de string
	syscall
	
	move $a0, $t0		#Carrega $a0 com maior
	li $v0, 1		#Código para impressão de inteiro
	syscall
	
	jr $ra
	
exit:
	li $v0, 10		#Código de finalização de programa
	syscall