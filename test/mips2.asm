lui $t1,4
lui $t2,5
lui $t3,6
or $t1,$t2,$t3
and $t1,$t2,$t3
xor $t1,$t2,$t3
nor $t1,$t2,$t3
ori $t1,$t2,100
andi $t1,$t2,100
xori $t1,$t2,100

sllv $t1,$t2,$t3
srlv $t1,$t2,$t3
movn $t1,$t2,$t3
slt  $t1,$t2,$t3
sltu  $t1,$t2,$t3
add $t1,$t2,100
addu $t1,$t2,10000
sub $t1,$t2,99
subu $t1,$t2,55
ori $t1,$t2,100

andi $t1,$t2,100
xori $t1,$t2,100
slti $t1,$t2,-100
addi $t1,$t2,99
addiu $t1,$t2,-100
lw $t1,12
sw $t1,20
