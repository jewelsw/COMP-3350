.data

A: .word 7, 42, 0, 27, 16, 8, 4, 15, 31, 45
N: .word 10
space: .asciiz " " #space string for in between each number

.text
.globl main

main:
#assigning/instantiating "variables"
	la $a0, A #assign/load array A (v) to $a0
	lw $a1, N #assign $a1 to length 10
	#lw $t0, 0 #temp reg $t0 for temp variable
	
	jal sort #jump to sort function
	jal output #jump to output function
	jal Exit
	#li $v0, 10 #offset 10
	#syscall 

swap:
#swapping values
	la $a0, A #assign/load array A (v) to $a0
	lw $t0, 4($sp) #assign $a1 to variable k starting at 0
	#lw $t0, 0 #temp reg $t0 for temp variable
	
	#getting address of v[k]
	sll $t1, $a1, 2 #reg $t1 = k * 4
	add $t1, $a0, $t1 #reg $t2 = v[k + 1], refering to the next element of v
	
	#load v[k]
	lw $t0, 0($t1) #temp reg $t3 for v[k]
	lw $t2, 4($t1) #temp reg $t4 for v[k + 1], referring to next element of v
	
	#store to the swapped addresses:
	sw $t2, 0($t1) #storing v[k] in $t4
	sw $t0, 4($t1) #storing v[k + 1] in $t3 (temp)
	
	jr $ra #return to calling route

sort:
	addi $sp, $sp, -20 #making room on stack for 5 registers (20/5 = 4 bytes)
	sw $ra, 16($sp) #save $ra on the stack
	sw $s3 12($sp) #save $s3 on the stack
	sw $s2, 8($sp) #save $s2 on the stack
	sw $s1, 4($sp) #save $s1 on the stack
	sw $s0, 0($sp) #save $s0 on the stack
	
	#li $s0, 0 #initialize i
	
	move $s2, $a0 #$a0 is copied into $s2 as parameter 
	move $s3, $a1 #$a1 is copied into $s3 as parameter
	move $s0, $zero #copy zero into $s0, i = 0

outer_loop:
	slt $t0, $s0, $s3 #if $s0 < $s3, set $t0 to 1, reg $t0 to 0 otherwise (checking if i < n)
	beq $t0, $zero, outer_loop_end #go to outer_loop_end iif $s0 < $s3
	
	#li $s1, -1 #initialize j
	addi $s1, $s0, -1 #decrement j by 1
	
inner_loop:
	#addi $t0, $s1, 0 #increment j by 1
	slti $t0, $s1, 0 #if #s1 < 0 (j< 0) set reg $t0 = 1
	bne $t0, $zero, inner_loop_end #go to inner_loop_end if $s1 < 0 (J < 0)
	
	sll $t1, $s1, 2 #reg $t1 = j * 4
	add $t2, $s2, $t1 #reg $t2 = v + (j * 4)
	lw $t3, 0($t2) #reg $t3 = v[j]
	lw $t4, 4($t2) #reg $t4 = v[j + 1]
	#ble $t3, $t4, no_swap #if $t3 <= $t4 go to inner_loop_end
	
	slt $t0, $t4, $t3 #if $t4 < $t3 set reg $t0 = 0
	beq $t0, $zero, inner_loop_end #go to inner_loop_end if $t4 < $t3
	
	move $a0, $s2 #v is parameter of swap 
	move $a1, $s1 #j is parameter of swap
	jal swap
	
	addi $s1, $s1, -1 #decrement j by 1
	j inner_loop #jumb back to beginning of inner loop

#no_swap:
	#j inner_loop #repeat inner loop
	
inner_loop_end:
	addi $s0, $s0, 1 #increment i by 1
	j outer_loop #jumb back to beginnning of outer loop

outer_loop_end:
	lw $s0, 0($sp) #resotre $s0 from stack
	lw $s1, 4($sp) #resotre $s1 from stack
	lw $s2, 8($sp) #resotre $s2 from stack
	lw $s3, 12($sp) #resotre $s3 from stack
	lw $ra, 16($sp) #resotre $ra from stack
	addi $sp, $sp, 20 #resotre stack pointer
	
	jr $ra #return to calling routine

output:
#reassigns "variables:" since they/their addresses have been altered
	la $t0, A #assign/load array A to $t0
	lw $t3, N #assign/load length N (10) to $t3
	li $t2, 0 #assign a counter variable to $t2 starting at 0

output_loop:
#iterate throught sorted array, outputting each value
	bge $t2, $t3, Exit #if the counter >= length N, jumps to Exit
	li $v0, 1 #loading syscall value 1 which outputs print integer
	lw $a0, 0($t0) #loads array current value of A[counter] to $a0
	syscall #outputs the value
	li $v0, 4 #loads syscall value 4 which outputs print string
	la $a0, space #loads space string
	syscall #outputs the space string
	addi $t0, $t0, 4 #moves to the next element in the array
	addi $t2, $t2, 1 #increments counter $t2 by 1
	j output_loop #jumps back to the beginning of output_loop
 
Exit:
	li $v0, 10 #offset 10
	syscall

#references
	#https://courses.cs.washington.edu/courses/cse378/02au/Lectures/07controlI.pdf clarification on branch instructions
	#https://www.cs.tufts.edu/comp/140/lectures/Day_3/mips_summary.pdf instructions
	#lecture slides 
	#MIPS Computer Organization and Design Textbook
	
	