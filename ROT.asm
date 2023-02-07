.data
	MSG_word: .asciiz "input word: (10 chars): "
	MSG_key: .asciiz "input key: (<26)"
	ERR_LEN: .asciiz "Length error! \n"
	printline: .asciiz "\n"

.text
.globl main

main:
	#Dynamic allocation
	li $v0, 9
	li $a0, 20
	syscall
	move $s7, $v0
	
	#input request
	li $v0, 4
	la $a0, MSG_word
	syscall
	#user input
	li $v0, 8
	li $a0, 0
	addu $a0, $a0, $s7
	li $a1, 20 
	syscall
	#saving user input WORD into $s0
	move $s0, $v0
	input_key:
	#input request
	li $v0, 4
	la $a0, MSG_key
	syscall
	#user input
	li $v0, 5
	syscall
	#saving user input KEY into $s0
	move $s1, $v0
	bge $s1, 26, len_error

	li $a0, 0
	move $t7, $s7
	lb $t1, ($t7)
	loop:
		#saving parameters
		move $a0,$t1
		move $a1,$s1
		#jumping to procedure
		jal rotate
		
		sb $v0, ($t7)
		
		#printing rotated value
		li $v0, 1
		lb $a0, ($t7)
		syscall
		
		#adding 1 byte to the base adress
		addi $t7,$t7,1
		jal println
		lb $t1, ($t7)
		lb $t2, 1($t7)
		bne $t2,$zero,loop
	
	la $a0, ($s7)
	li $v0, 4
	syscall
	j exit
	
rotate:
	# $a0 = byte
	# $a1 = key
	# $v0 = rotated byte
	
	#fixing fp
	move $t0, $fp
	addiu $fp, $sp, -4
	
	
	sw $t0, 0($fp)
	sw $sp, -4($fp)
	sw $t1, -8($fp)
	sw $ra, -12($fp)
	addiu $sp, $fp, -12
	
	move $t3,$a0
	move $t1,$a1
	
	subi $t3, $t3, 97
	add $t3, $t3, $t1
	li $t1,26
	div $t3,$t1
	mfhi $v0
	addi $v0, $v0, 97
	
	lw $t0, 0($fp)
	lw $sp, -4($fp)
	sw $t1, -8($fp)
	sw $ra, -12($fp)
	
	move $fp, $t0
	jr $ra

exit:
	li $v0, 10
	syscall
	
len_error:
	li $v0, 4
	la $a0, ERR_LEN
	syscall
	j input_key

println:
	li $v0, 4
	la $a0, printline
	syscall
	jr $ra
