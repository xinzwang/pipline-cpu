add $t1,$t1,3
add $t2,$t2,1
add $t3,$t3,0

movn $t4,$t1,$t2
movn $t5, $t1,$t3

movz $t6,$t1,$t2
movz $t7, $t1,$t3

srav $t8,$t1,$t2