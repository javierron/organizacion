         .data      
fout:   .asciiz 	"randomMarsaglia.txt"      # filename for output

comma: 	.asciiz 	","
return: .asciiz 	"\n"

var0: .word 0
var1: .word 0
var2: .word 0
var3: .word 0

data:    .word     0 : 1200       # storage for 16x16 matrix of words
         .text
             
             
      
         addi	$v0,	$v0,	5678
          
         li       $t0, 600        # $t0 = number of rows
         li       $t1, 2        # $t1 = number of columns
         move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
  
    	li   $v0, 13       # system call for open file
  	la   $a0, fout     # output file name
  	li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  	li   $a2, 0        # mode is ignored
 	syscall            # open a file (file descriptor returned in $v0)
 	move $s6, $v0      # save the file descriptor  
 	
#  Each loop iteration will store incremented $t1 value into next element of matrix.
#  Offset is calculated at each iteration. offset = 4 * (row*#cols+col)
#  Note: no attempt is made to optimize runtime performance!

loop:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         
        li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 1000  # loading upperbound
    	syscall
    	
    	
    	
    	
    	########################## FUN ################################
    	
    	
 	li 	$t3,	10
	div	$a0,	$t3
	mfhi 	$t4
	mflo	$t5
	addi	$t4,	$t4,	48
	sw 	$t4,	var3	

	div	$t5,	$t3
	mfhi 	$t4
	mflo	$t5
	addi	$t4,	$t4,	48
	sw 	$t4,	var2
	
	div	$t5,	$t3
	mfhi 	$t4
	mflo	$t5
	addi	$t4,	$t4,	48
	sw 	$t4,	var1
	
	div	$t5,	$t3
	mfhi 	$t4
	mflo	$t5
	addi	$t4,	$t4,	48
	sw 	$t4,	var0
	
 	
 	 li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, var0   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
 	
 	 li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, var1   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
 	
 	 li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, var2   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
 	
 	 li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, var3   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
    	
    	
    	######################## END FUN ##############################   	
    	
    	add $t2, $a0, 48     # saving random int from $a0
    	 	
        sw  $t2, data($s2) # store the value in matrix element    
  
         addi     $t2, $t2, 1    # increment value to be stored
         
#  Loop control: If we increment past last column, reset column counter and increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 1    # increment column counter
         
         li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, comma   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
         
         
         bne      $s1, $t1, loop # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 1    # increment row counter
         
         li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, return   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall  
         
         bne      $s0, $t0, loop # not at end of matrix so loop back
         
           # Close the file 
 	 li   $v0, 16       # system call for close file
  	move $a0, $s6      # file descriptor to close
	syscall            # close file
	
#  We're finished traversing the matrix.
         li       $v0, 10        # system service 10 is exit
         syscall                 # we are outta here.




	
	
