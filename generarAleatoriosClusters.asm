         .data      
fout:   .asciiz 	"randomMIPSclusters.txt"      # archivo por escribir

comma: 	.asciiz 	","				# coma para los archivos
return: .asciiz 	"\n"				# enter para los archivos

mensaje1: .asciiz "==========================\n\nIngrese el numero de dimensiones (max. 4): "
mensaje2: .asciiz "==========================\n\nIngrese el numero de clusters que desea: "
mensaje3: .asciiz "Error! Vuelva a ingresar el numero.\n\n"
mensaje4: .asciiz "==========================\nEl archivo se ha generado. Se llama randomMIPSclusters.txt."

var0: .word 0					# archivos para convertir numeros a strings
var1: .word 0					# para convertir archivos
var2: .word 0
var3: .word 0

list: .word -9999, -9999, -9999, -9999, -9999 	# guardar puntos centrales en x de clusters

saltos: .word 0

data:    .word     0 : 1200       # lista de 1200 puntos
         .text
   
pedirdimension:
               
         li $v0, 4				# imprimir mensaje 1
         la $a0, mensaje1
         syscall
         
         li $v0, 5
         syscall
         
         li $a0, 5				# si es mayor que cuatro, repetir
         
         blt $v0, $a0, guardardimension
         
         li $v0, 4				# imprimir mensaje de error
         la $a0, mensaje3
         syscall
         
         j pedirdimension
         
 guardardimension:
 
 	li $a0, 2
 	bgt $v0, $a0, guardarfinalmente
 	
 	li $v0, 2				# valor default: 2
 	
guardarfinalmente:
 	
         addi $t4, $v0, 0			# guardar valor
         
pedirclusters:
         
         li $v0, 4				# imprimir mensaje 2
         la $a0, mensaje2
         syscall
         
         li $v0, 5				
         syscall
         
         li $a0, 6				# si es mayor que cuatro, repetir
         
         blt $v0, $a0, guardarclusters
         
         li $v0, 4				# imprimir mensaje de error
         la $a0, mensaje3
         syscall
         
         j pedirclusters
         
guardarclusters:
 	li $a0, 2
 	bgt $v0, $a0, guardarfinalmente2
 	
 	li $v0, 2				# valor default: 2
 	
guardarfinalmente2:
         addi $t5,$v0, 0			# pedir valor
         
         li $t6,1200
         
         div $t6, $t4
         mflo $t6 
 
         addi	$v0,	$v0,	5678
          
         addi       $t0, $t6,0        # $t0 = number of rows
         addi       $t1, $t4,0        # $t1 = number of columns
         addi 	  $t8, $t5,0       # $t8 = numero de clusters
         move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
  
    	li   $v0, 13       # system call for open file
  	la   $a0, fout     # output file name
  	li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  	li   $a2, 0        # mode is ignored
 	syscall            # open a file (file descriptor returned in $v0)
 	move $s6, $v0      # save the file descriptor  
 	
 	li $t9, -1			#valor central en xy, valor temporal de -1
 	
 	div $t0, $t8
 	mflo $t7	
 	
 	sw $t7, saltos	
 	
 	
#  Each loop iteration will store incremented $t1 value into next element of matrix.
#  Offset is calculated at each iteration. offset = 4 * (row*#cols+col)
#  Note: no attempt is made to optimize runtime performance!

loop:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        
         
         bne $t9, -1, crearnuevonumero
         
       
        li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 1000  # loading upperbound
    	syscall
    		
    	addi $t9, $a0, 0		#t9 va a tener el centro
    	addi $a0, $t9, 0
    	
    	la $t6, list
    	li $t3, 0
    	add $t3, $t3, $t3
    	add $t3, $t3, $t3
    	add $t4, $t3, $t6
    	sw $t9, 0($t4)			#guardamos en el arreglo
    	
    	j continue

crearnuevonumero:	
 
        li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 100  # loading upperbound
    	syscall
    	
    	#addi $a0, $a0, -50		#a0 tiene numero entre -50 y 50
    	add $a0, $a0, $t9		#a0 tiene numero original sumado el numero anterior
   
 	bgt $a0, 1000, hacerlomil
 	j continue
 	
hacerlomil:
	
	li $a0,1000
 	
 continue:
    	########################## FUN ################################
    	
    	#addi $a0, $t8, 0
    	
    	add $t2, $a0, 0
    	
    	beq $s1, 1, newnumber			# si la dimension actual recorrida
    	beq $s1, 3, newnumber			# es uno, tres y cinco,
    	beq $s1, 5, newnumber			# calcular nuevo numero
    	j continue2
    	
newnumber:
    	
        li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 1000  # loading upperbound
    	syscall
    	
    	abs $a0, $a0
    	
    	add $t2, $a0, 0
    	
 continue2:  	
  
  	add $a0, $t2, 0
  	
  	bgt $a0, 0, continue3
  	
  	li $a0, 0
  
  	
 continue3:
    	
    	blt $a0, 1000, continue4
    	
    	li $a0, 1000
    	
 continue4:
    	
    	
 	li 	$t3,	10			# imprimir numero en el archivo
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
	beq $s1,$t1, seguir
               
         li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, comma   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall            # write to file
         
  seguir:       
         bne      $s1, $t1, loop # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 1    # increment row counter
         
        bne $s0, $t7, seguir2
        
        lw $t2, saltos
    	
    	add $t7, $t7, $t2 # $t7 * 2
    	
    	beq $s0, $t0, terminar
    	
    	li $t2, 0
    	la $t6, list	
    	
    	li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 1000  # loading upperbound
    	syscall
    	
    	
 crearunnuevonumero:
         
    	addi $t3, $t2,0
    	add $t3, $t3, $t3
    	add $t3, $t3, $t3
    	add $t4, $t3, $t6
    	lw $t3, 0($t4)			#chequeamos en el arreglo
    	
    	beq $t3, -9999, guardarnumero	# si llegamos a una posicion con -9999, entonces guardar el numero

    	sub $t3, $a0, $t3
    	abs $t3, $t3
    	
    	blt $t3, 120, encerar		# si el nuevo numero generado esta cercano a otro, crear uno nuevo
    	
    	addi $t2, $t2, 1
    	j crearunnuevonumero

encerar:

	li $t2, 0
	li  $v0, 42                 # service 42 is to set up the upperbound of the random number
    	addi $a1, $zero, 1000  # loading upperbound
    	syscall
    	
	j crearunnuevonumero


guardarnumero:

  addi $t9, $a0, 0		#t9 va a tener el centro

      	la $t6, list
      	add $t3, $t2,0
    	add $t3, $t3, $t3
    	add $t3, $t3, $t3
    	add $t4, $t3, $t6
    	sw $t9, 0($t4)			#chequeamos en el arreglo
    	
 seguir2: 	

         li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, return   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall  
         
         bne      $s0, $t0, loop # not at end of matrix so loop back
         
terminar:
           # Close the file 
 	 li   $v0, 16       # system call for close file
  	move $a0, $s6      # file descriptor to close
	syscall            # close file
	
	 li $v0, 4				# imprimir mensaje de exito
         la $a0, mensaje4
         syscall
    	
	
#  We're finished traversing the matrix.
         li       $v0, 10        # system service 10 is exit
         syscall                 # we are outta here.
