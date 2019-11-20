.data
Mat: .space 48
.align 2
Vet: .space 12
.align 2
Ent1: .asciiz "matriz["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
Ent4: .asciiz "vetor["
Ent5: .asciiz "Resultado da multiplicacao: "

.text
main: 
	la $a0, Mat
	li $a1, 4
	li $a2, 3
	jal readMat
	la $a0, Vet
	jal readVet
	la $a0, Mat
	jal write
	la $a0, Vet
	jal writeV
	la $a0, Mat
	la $a1, Vet
	jal multiply
	li $v0, 10
	syscall

indice:
	mul $v0, $t0, $a2
	add $v0, $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
	jr $ra
	
readVet:
	move $t2, $a0
	li $t3, 0
lv:	la $a0, Ent4
	li $v0, 4
	syscall
	move $a0, $t3
	li $v0, 1
	syscall
	la $a0, Ent3
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	sw $v0, ($t2)
	addi $t2, $t2, 4
	addi $t3, $t3, 1
	blt $t3, 3, lv
	li $t3, 0
	jr $ra

readMat:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
	l: la $a0, Ent1
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, Ent2
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, Ent3
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t2, $v0
	jal indice
	sw $t2, ($v0)
	addi $t1, $t1, 1
	blt $t1, $a2, l
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, l
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $v0, $a3
	jr $ra

write:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
e: 	jal indice
	lw $a0, ($v0)
	li $v0, 1
	syscall
	la $a0, 32
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	blt $t1, $a2, e
	la $a0, 10
	syscall
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, e
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $v0, $a3
	jr $ra

writeV:
	li $t0, 0
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
ev:	lw $a0, ($a3)
	li $v0, 1
	syscall
	la $a0, 32
	li $v0, 11
	syscall
	la $a0, 10
	syscall
	addi $t0, $t0, 1
	addi $a3, $a3, 4
	blt $t0, 3, ev
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $v0, $a3
	jr $ra
	
multiply:
	li $t5, 0
	li $t7, 0
	li $s0, 0
	move $t1, $a0 
	move $t2, $a1 
	la $a0, Ent5
	li $v0, 4
	syscall
	
	
m:	lw $t3, ($t1)
	lw $t4, ($t2)
	mul $t6, $t3, $t4
	add $t5, $t5, $t6
	addi $t7, $t7, 1
	addi $t1, $t1, 4
	add $t2, $t2, 4
	blt $t7, 3, m
	move $t2, $a1
	addi $s0, $s0, 1
	li $t7, 0
	
	la $a0, 10
	li $v0, 11
	syscall
	move $a0, $t5
	li $v0, 1
	syscall
	
	li $t5, 0
	blt $s0, 4, m
	jr $ra
