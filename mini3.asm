# 	Program to calculate factorial
# 	Theodoro Gasperin Terra Camargo 260842764

	.data
msg1:	.asciiz "Please input an integer value greater than or equal to 0: "
msg2:	.asciiz "The value you entered is less than zero.\nThis program only works with values greater than or equal to zero."
msg3:	.asciiz "Result of factorial: "
	
	.text
main:
	#printing first message
	la $a0, msg1
	li $v0, 4
	syscall
	
	#Getting user input
	li $v0, 5
	syscall
	move $t0, $v0		# x = user input
	
	ble $t0, $0, Error	# Error if x less equal than 0
	
	addiu $sp, $sp, -4	# Else:
	sw $t0, 0($sp)		# Push x into stack
	
	jal factorial		# Sets $ra to the address of the next instruction and go to factorial
	
	move $s0, $v0		# Saving result of factorial into $s0 bcs v0 will be used to print
	addiu $sp, $sp, 4	# Resest the Stack pointer to its original value (That is pop the s0,1
	
	#Printing Result message
	la $a0, msg3
	li $v0, 4
	syscall
	# Printing factorial result
	move $a0, $s0
	li $v0, 1
	syscall
	
	j Exit

Error:	
	#Error message
	la $a0, msg2
	li $v0, 4
	syscall
Exit:	
	#Exiting
	li $v0, 10
	syscall
	
factorial:
	
	lw $t0, 0($sp)		# Retrieve x from stack 
	
	# Push $ra
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	##
	# if x == 0:
	#	return 1
	# else:
	#	return x * factorial (x - 1)
	##
	
	beq $t0, $zero, base_case	# if x == 0: go to basecase
	
	addiu $sp, $sp, -4
	sw $t0, 0($sp)		# pushing x into the stack
	
	addiu $t1, $t0, -1	# $t1 gets x - 1
	
	addiu $sp, $sp, -4
	sw $t1, 0($sp)		# pushing x - 1 into the stack
	
	jal factorial
	
	addiu $sp, $sp, 4	# pooping x-1 from stack
	
	lw $t0, 0($sp)		# looding x to multiply
	addiu $sp, $sp, 4	# pooping x from stack
	
	mult $t0, $v0		# x * (x - 1)!
	
	mflo $v0
	j factorial_exit
	
base_case:			
	li $v0, 1		# if x = 1: return 1
	j factorial_exit

factorial_exit:
	
	# Pop ra
	lw $ra, 0($sp)		# poop address
	addiu $sp, $sp, 4
	
	jr $ra			# jump to address

