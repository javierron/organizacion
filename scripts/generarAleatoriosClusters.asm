		.data
list: 		.space	256
temp:		.space	16
comma:		.asciiz	","
return:		.asciiz	"\n"
fout:   	.asciiz	"randomMIPSclusters.txt"     	# archivo por escribir

mensaje1: 	.asciiz "==========================\n\nIngrese el numero de dimensiones (max. 4): "
mensaje2: 	.asciiz "==========================\n\nIngrese el numero de clusters que desea: "
mensaje3: 	.asciiz "Error! Vuelva a ingresar el numero.\n\n"
mensaje4: 	.asciiz "==========================\nEl archivo se ha generado. Se llama randomMIPSclusters.txt."

		.text
	
	
	
	####### INTERFACE CODE ################################
	
	pedirdimension:
               
         li 	$v0, 	4				# imprimir mensaje 1
         la 	$a0, 	mensaje1
         syscall
         
         li 	$v0, 	5
         syscall
         
         li 	$a0, 	5				# si es mayor que cuatro, repetir
         
         blt 	$v0, 	$a0, 	guardardimension
         
         li 	$v0, 	4				# imprimir mensaje de error
         la 	$a0, 	mensaje3
         syscall
         
         j 	pedirdimension
         
 guardardimension:
 
 	li 	$a0	2
 	bgt 	$v0, 	$a0, 	guardarfinalmente
 	
 	li 	$v0, 	2				# valor default: 2
 	
guardarfinalmente:
 	
         addi 	$s0, 	$v0, 	0			# guardar valor
         
pedirclusters:
         
         li 	$v0, 	4				# imprimir mensaje 2
         la 	$a0, 	mensaje2
         syscall
         
         li 	$v0, 	5				
         syscall
         
         li 	$a0, 	6				# si es mayor que cuatro, repetir
         
         blt 	$v0, 	$a0, 	guardarclusters
         
         li 	$v0, 	4				# imprimir mensaje de error
         la 	$a0, 	mensaje3
         syscall
         
         j 	pedirclusters
         
guardarclusters:
 	li 	$a0, 	2
 	bgt 	$v0, 	$a0, 	guardarfinalmente2
 	
 	li 	$v0, 	2				# valor default: 2
 	
 guardarfinalmente2:
         addi 	$s1,	$v0, 	0			# pedir valor
	
	###################### END OF INTERFACE CODE#################################
	
	
	li   	$v0, 	13 				# abriendo el archivo      
  	la   	$a0, 	fout     
  	li   	$a1, 	1        
  	li   	$a2, 	0       
 	syscall            
 	move 	$s6, 	$v0       
	
	
	#li	$s0,	4				# numero de dimensiones
	#li	$s1,	5				# numero de clusters
	li	$s2,	1200				# items 
	li	$s3,	1000				# distancia entre clusters
	li	$s4,	26				# rango de clusters
	
	li 	$t1,	0				# contador de item de lista


#################### FUN CODE TO GENERATE CLUSTER CENTERS########################

generateItem:
	li 	$t0,	0 				# contador de dimensiones
	
generateNumber:
	li	$v0,	42                		# service 42 is to set up the upperbound of the random number
    	addi	$a1,	$zero,	950  			# loading upperbound
    	syscall	
    	
    	
    	la 	$t3,	list				# cargando direccion de arreglo
    	sll	$t0,	$t0,	2			# multiplicando indice por 4
    	
    	mul	$t4,	$s0,	$t1	
    	mflo	$t4
    	sll	$t4,	$t4,	2
    	
    	add	$t3,	$t4,	$t3
    	add	$t4,	$t3,	$t0			# sumando indice a la direccion del arreglo
    	sw	$a0,	0($t4)				# escribiendo en la direccion del arreglo
    	srl	$t0,	$t0,	2			# restaurando indice
    	addi	$t0,	$t0,	1			# aumentando indice
    	beq	$t0,	$s0,	continue		# comprobando que el indice haya llegado a su fin
    	
    	j	generateNumber				# jump de regreso si se continua el loop
    	
continue:

################### CHECK DISTANCE ##############################

	beq	$t1,	$zero,	skipDistanceCheck

	li	$t9,	0				# acumulador para la distancia
	li	$t3,	0				# iterador del distance checker
	
	
distanceCheckLoop:
	li 	$t4,	0				# indice dentro de lista
	
	
	la	$t5,	list
	mul	$t6,	$t1,	$s0
	sll	$t6,	$t6,	2
	add 	$t5,	$t5,	$t6		# $t5 tiene la direccion de la ultima lista
	
	
	la	$t6,	list
	mul	$t2,	$t3,	$s0
	sll	$t2,	$t2,	2
	add	$t6,	$t6,	$t2
	
listIterationLoop:

	sll	$t4,	$t4,	2
	add	$t6,	$t6,	$t4			# $t6 tiene la direccion del item actual
	add	$t5,	$t5,	$t4
	srl	$t4,	$t4,	2
	
	
	lw	$t7,	0($t5)
	lw	$t8,	0($t6)
	
	
	sub	$t7,	$t7,	$t8
	mul	$t7,	$t7,	$t7
	
	add	$t9,	$t9,	$t7
	
	addi	$t4,	$t4,	1
	beq	$t4,	$s0,	exitListIteration
	j listIterationLoop
exitListIteration:
	
	addi	$t3,	$t3,	1
	beq	$t3,	$t1,	exitDistanceCheck
	j distanceCheckLoop
exitDistanceCheck:
#################################################################

	blt	$t9,	$s3,	generateItem
skipDistanceCheck:
	addi	$t1,	$t1,	1			# aumentando indice
	beq	$t1,	$s1,	doneCreatingCenters	# comprobando que el indice haya llegado a su fin
    	
    	
    	j	generateItem				# jump de regreso si se continua el loop
	
doneCreatingCenters:

#################### END OF CODE TO GENERATE CLUSTER CENTERS########################


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ RELEASED ALL TEMPORALS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#################### FUN CODE TO GENERATE CLUSTERS########################

					#indice de cluster

	li	$t0,	0				#indice de elemento, not important.

forEachItemPerCluster:

	li	$v0,	42                		# service 42 is to set up the upperbound of the random number
    	add	$a1,	$zero,	$s1			# loading upperbound
    	syscall	

	move	$t1,	$a0	

	li	$t3,	0				#indice de elemento dentro de lista
forEachNumberPerItem:

	li	$v0,	42                		# service 42 is to set up the upperbound of the random number
    	add	$a1,	$zero,	$s4			# loading upperbound
    	syscall	

	
	la	$t4,	list				# accediendo a valor correspondiente en la lista
	mul	$t5,	$t1,	$s0
	sll	$t5,	$t5,	2
	add	$t4,	$t4,	$t5
	sll	$t3,	$t3,	2
	add	$t4,	$t4,	$t3
	srl	$t3,	$t3,	2
	
	lw	$t4,	0($t4)
	li	$t5,	2
	div	$s4,	$t5
	mflo	$t5
	
	sub	$t4,	$t4,	$t5
	
	add	$t4,	$t4,	$a0	

	move	$a0,	$t4
	li	$v0,	1
	syscall

########################PRINTING NUMBER TO FILE#################################
	move	$t6,	$a0

	li	$t9,	0
printIntLoop:
	li	$t7,	10
	
	div	$t6,	$t7
	mfhi	$t7
	addi	$t7,	$t7,	48
	
	la	$t8,	temp
	sll	$t9,	$t9,	2
	add	$t8,	$t8,	$t9
	srl	$t9,	$t9,	2
	sw	$t7,	0($t8)
	
	
 	
 	mflo	$t6
 	addi	$t9,	$t9,	1
 	beq	$t6,	$zero,	endPrintInt
 	j	printIntLoop	

endPrintInt:	
	li   	$v0,	15      
  	move 	$a0,	$s6      
  	la   	$a1, 	temp 
  	addi	$a1,	$a1,	8
  	li   	$a2, 	1       
 	syscall 
 	
 	li   	$v0,	15   
 	addi	$a1,	$a1,	-4
 	syscall
 	
 	li   	$v0,	15   
 	addi	$a1,	$a1,	-4
 	syscall
 	
	
################################################################################
		
	addi	$t3,	$t3,	1
	beq	$t3,	$s0,	endNumberPerItem
							
	la	$a0,	comma
	li	$v0,	4
	syscall
	
	li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, comma   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall  

	
	j	forEachNumberPerItem
endNumberPerItem:

	la	$a0,	return
	li	$v0,	4
	syscall

	li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, return   # address of buffer from which to write
  	li   $a2, 1       # hardcoded buffer length
 	syscall 


	addi	$t0,	$t0,	1
	beq	$t0,	$s2,	endItemPerCuster
	j	forEachItemPerCluster
endItemPerCuster:



#################### END OF CODE TO GENERATE CLUSTERS########################

	
	
    	
    	
    	
    	
