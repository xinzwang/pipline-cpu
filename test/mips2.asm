add $t1,$t1,3
add $t2,$t2,-7

sll $t3,$t2,4
srl $t4,$t3,3
sra $5,$t2, 2

andi $t1,$t2,100
xori $t1,$t2,100
slti $t1,$t2,-100
addi $t1,$t2,99
addiu $t1,$t2,-100
lw $t1,12
sw $t1,20
