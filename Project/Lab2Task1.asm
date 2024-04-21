.data

A: .word 21, 50, 63, 72, 0, 95, 11, 28, 4, 5, 16, 7 
N: .word 12 #size of A
space: .asciiz " " #space string for in between each number

.text
.globl  main

main:
#assigning "variables"
	la $t0, A #assign/load array A to $t0
	lw $t1, N #assign/load length N (12) to $t1
	li $t2, 1 #assign i to $t2
	la $t0, A #temp reg $t0 to A
 
outer_loop:
#outer 'for' loop
	bge $t2, $t1, outer_loop_end  #continue while i < N
	move $t3, $t2 #temp reg for i
    
inner_loop:
#inner 'for' loop
	la $t0, A #reload A to $t0
	mul $t4, $t3, 4 #store multiplied $t3 by 4 in $t4 to calculate offset
	add $t0, $t0, $t4 #add offset to $t0 to get current element
	ble $t3, $zero, inner_loop_end  #if j <= 0, go to inner_loop_end
	lw $t6, 0($t0) #temp reg $t6 for A[j]
	lw $t5, -4($t0) #temp reg $t5 for A[j-1]
	bge $t6, $t5, inner_loop_end #if values of A[j] < A[j-1], go to inner_loop_end
	lw $t7, 0($t0) #temp reg $t7 for A[i]
	sw $t5, 0($t0) #stores the value of A[j - 1] in $t5
	sw $t7, -4($t0) #stores the address for A[j - 1] in $t7
	addi $t3, $t3, -1 #decrement j by 1
	j inner_loop #back to the beginning of inner_loop

inner_loop_end:
	addi $t2, $t2, 1 #increment i by 1
	j outer_loop #back to the beginning of outer_loop

outer_loop_end:
	jal output #goes to start printing the values after sorting

Exit:
	li $v0, 10 #offset 10
	syscall 

output:
#reassigns "variables" since they/their addresses have been altered
	la $t0, A #assign/load array A to $t0 again
	lw $t1, N #assign/load length N (12) to $t1 again
	li $t2, 0 #assign a counter variable to $t2 starting at 0
    
output_loop:
#iterate through sorted array, outputting each value
	bge $t2, $t1, Exit #if the counter >= length N, jumps to Exit
	li $v0, 1 #loading in syscall value 1 which outputs print integer
	lw $a0, 0($t0) #loads array current value of A[counter] to $a0
	syscall #outputs the value
	li $v0, 4 #loading in syscall value 4 which outputs print string
	la $a0, space #loads
	syscall #outputs the space string
	addi $t0, $t0, 4 #adds 4 to address $t0 
	addi $t2, $t2, 1 #increments counter $t2 by 1
	j output_loop #back to the beginning of output_loop
    
#references:
	#https://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html for syscall values
	#https://courses.cs.washington.edu/courses/cse378/02au/Lectures/07controlI.pdf for clarification on branching and jumps
	#https://max.cs.kzoo.edu/cs230/Resources/MIPS/Conditions/LoopsInMIPS.html for loops help
	#https://www.cs.cornell.edu/~tomf/notes/cps104/mips.html to get spaces in between array (coupled with syscall values)
	#lecture slides
	
	
