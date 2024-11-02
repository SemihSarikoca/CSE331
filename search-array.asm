.data
array: .word 1, 2, 3, 4, 5
size: .word 5
target: .word 3

.text
.globl main
main:
	la $t0, array
	lw $t1, size
	li $t2, 0
	lw $t3, target
	
	loop:	
		bge $t2, $t1, exit
		lw $s3, 0($t0)
		addi $t0, $t0, 4
		addi $t2, $t2, 1
		bgt $s3, $t3, print
		j loop
	print:
		move $a0, $s3
		li $v0, 1
		syscall
		j loop
	exit:
		li $v0, 10
		syscall
