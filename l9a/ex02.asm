.data

.align 2
barraene: .asciiz "\n"
lixo: .word 1337
.align 2
teste: .asciiz "ENTROU\n"
.align 3
r: .float 1

.text

jal readAndPrint
#S0 INT E F2 FLOAT GUARDADOS SAFE
move $s1, $s0
move $a0, $s1
jal loop
back:
lw $a0, barraene
li $v0, 11
syscall
mov.s $f12, $f8						#print float result
li $v0, 2
syscall
j exit



readAndPrint:
li $v0, 6							#read float
syscall
mov.s $f2, $f0

li $v0, 5							#read int
syscall
move $s0, $v0

#mov.s $f12, $f2					#print float
#li $v0, 2
#syscall

lw $a0, barraene
li $v0, 11
syscall

#move $a0, $s0						#print int
#li $v0, 1
#syscall
jr $ra






loop:

move $s7, $a0
move $s6, $s7
mov.s $f4, $f2
subi $s1, $s1, 1
subi $s6, $s6, 1
subi $s7, $s7, 1

#$A0 = $S0 = $S1 = $S6 = $S7 TA COM O INT E $F2 = $F4 TA COM O FLOAT

loopL:
move $s7, $s1
mov.s $f4, $f2
sub $sp,$sp,4
sw $ra, 0($sp)

sll $s6, $s6, 1

jal potencia
#F4 com x^2k feito



move $a0, $s6

jal fact
move $s5, $v0
#S5 com (2k)! feito





mtc1 $s5, $f6
cvt.s.w $f6, $f6





div.s $f4, $f4, $f6



move $s6, $s1
div $s6, $s6, 2
mfhi $t5
bnez $t5, minusHack

add.s $f8, $f8, $f4
j hackBack

minusHack:
	
	sub.s $f8, $f8, $f4

hackBack:
	


subi $s1, $s1, 1
move $s6, $s1



bgtz $s6, loopL

l.s $f14, r
add.s $f8, $f8, $f14

j back






fact:
      li $t9, 1
      sub $sp,$sp,8   # Ajusta a stack para 2 items
      sw $ra, 4($sp)   # Guarda endereço de retorno
      sw $a0, 0($sp)   # Guarda argumento n

      slt $t0,$a0,$t9   # testa se n < 1
      beq $t0,$zero,L1   # Se n >= 1, vai fazer outra chamada

      li $v0,1      # Se não for devolve 1
      add $sp,$sp,8   # liberta o espaço da stack antes de
      jr $ra      # retornar

L1:   sub $a0,$a0,1   # Nova chamada: novo argumento (n - 1)
      jal fact      # call fact com (n - 1)

         # Ponto de retorno da chamada recursiva:
      lw $a0, 0($sp)   # Recupera o argumento passado
      lw $ra, 4($sp)   # Recupera o endereço de retorno
      add $sp,$sp,8   # Liberta o espaço da stack

      mul $v0,$a0,$v0   # Calcula n * fact (n - 1)
      jr $ra            # Retorna com o resultado
      

potencia:

mov.s $f30,$f4
li $t0,1
while:  
beq $t0,$s6,fim  
mul.s $f30,$f30,$f4
add $t0,$t0,1  
j while
fim:
mov.s $f4, $f30
jr $ra
      
      
exit:
