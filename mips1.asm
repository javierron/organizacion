         .data      
fout:   .asciiz "randomMIPS.txt"      # filename for output
coma: ","
enter: "\n"
data:    .word     0 : 1200       # storage for 16x16 matrix of words
         .text
             
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
         
         #generar un numero aleatorio de caracteres (entre 1 y 3 caracteres)
         
         li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 3  # loading upperbound
    	syscall    
    	addi $t3, $a0, 1  	#t3 va a tener la cantidad de caracteres
    	
    	li $t4, 0		#t4 va a ser un contador
    	
generar:

    	#generar un numero aleatorio (entre 0 y 9)    	      
        li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 9  # loading upperbound
    	syscall
    	add $t2, $a0, 49     # saving random int from $a0
    	
        sw  $t2, data($s2) # store the value in matrix element
 
        li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, data($s2)   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
 	
 	add $t4, $t4, 1    #agregar al contador
 	bne $t4, $t3, generar
 		
  
     #    addi     $t2, $t2, 1    # increment value to be stored
         
#  Loop control: If we increment past last column, reset column counter and increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 1    # increment column counter
         
                 bne $s1, $t1, imprimircoma
                 
 imprimirenter:
        li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, enter   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
 	j seguir
                                                                             
imprimircoma:
        li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, coma   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
 	
 seguir:     	
         bne      $s1, $t1, loop # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 1    # increment row counter
         bne      $s0, $t0, loop # not at end of matrix so loop back
         
           # Close the file 
 	 li   $v0, 16       # system call for close file
  	move $a0, $s6      # file descriptor to close
	syscall            # close file
	
#  We're finished traversing the matrix.
         li       $v0, 10        # system service 10 is exit
         syscall                 # we are outta here.