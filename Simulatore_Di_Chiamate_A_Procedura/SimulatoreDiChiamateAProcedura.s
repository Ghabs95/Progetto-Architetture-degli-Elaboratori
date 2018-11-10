#SIMULATORE DI CHIAMATE A PROCEDURA

# Autori:
# Gabriele Bertini – gabriele.bertini3@stud.unifi.it
# Lorenzo Pratesi Mariti – lorenzo.pratesi@stud.unifi.it
# 
# Data di consegna:
# 29 maggio 2016

# Il file "chiamate.txt" deve trovarsi nella stessa cartella in cui si trova l'eseguibile QtSpim
.data
fnf:    .ascii   "The file was not found: "
file:   .asciiz  "chiamate.txt"
cont:   .ascii   "File contents: "
buffer: .space   156
strSomma: .asciiz "somma"
strSottr: .asciiz "sottrazione"
strProd: .asciiz "prodotto"
strDiv: .asciiz "divisione"
strReturn: .asciiz "-return("
aCapo:  .asciiz  "\n"
result: .asciiz  "Result: "
strClose:  .asciiz ")\n"
frecciaIn: .asciiz "-->"
frecciaOut: .asciiz "<--"
error:  .asciiz  "Errore: divisione per zero"

 
.text
.globl  main

main:
        # PUSH nello Stack
        addi $sp, $sp, -4 # alloco memoria
        sw   $ra, 0($sp)  # salvo ra nello stack
        
        jal  letturaFile  # richiamo la procedura letturaFile
        
        la   $a0, aCapo
        li   $v0, 4
        syscall
        
        la   $a0, buffer  # carico in $a0 l'indirizzo del buffer
        jal  readChar     # richiamo la procedura readChar che opera sulla stringa in input
        
        la   $a0, aCapo
        li   $v0, 4
        syscall
        
        la   $a0, result  # carico in $a0 la stringa result per stamparla
        li   $v0, 4
        syscall
        
        move $a0, $v1     # carico il risultato delle operazioni in $a0 per stamparlo
        li   $v0, 1
        syscall
        
        # POP nello Stack: 
        lw   $ra, 0($sp)  # riprendo ra
        addi $sp, $sp, 4  # dealloco
        jr   $ra          # torno al chiamante (exeption handler)

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
readChar:
        addi $sp, $sp, -4                # alloco memoria
        sw   $ra, 0($sp)                 # salvo ra nello stack
        
        move $a1, $a0
        jal stampaTraccia
        addi $a0, 2                      # avanzo il puntatore di 2 byte
        lb   $t1, 0($a0)                 # carico il carattere a cui punta il puntatore in $t1

        beq  $t1, 'm', chiamaSomma       # controllo se la lettera e' una "m", quindi richiamo la procedura chiamaSomma
        beq  $t1, 't', chiamaSottrazione # controllo se la lettera e' una "t", quindi richiamo la procedura chiamaSottrazione
        beq  $t1, 'o', chiamaProdotto    # controllo se la lettera e' una "o", quindi richiamo la procedura chiamaProdotto
        beq  $t1, 'v', chiamaDivisione   # controllo se la lettera e' una "v", quindi richiamo la procedura chiamaDivisione
        
        chiamaSomma:
             jal  somma                  # richiamo la procedura somma
             li $t1, 'm'
             move $a1, $t1
             jal stampaTracciaRitorno
             lw   $ra, 0($sp)            # riprendo ra
             addi $sp, $sp, 4            # dealloco
             jr   $ra                    # torno al chiamante (exeption handler)
            
        chiamaSottrazione:
             jal  sottrazione            # richiamo la procedura sottrazione
             li $t1, 't'
             move $a1, $t1
             jal stampaTracciaRitorno
             lw   $ra, 0($sp)            # riprendo ra
             addi $sp, $sp, 4            # dealloco
             jr   $ra                    # torno al chiamante (exeption handler)
            
        chiamaProdotto:
             jal  prodotto               # richiamo la procedura prodotto
             li $t1, 'o'
             move $a1, $t1
             jal stampaTracciaRitorno

             lw   $ra, 0($sp)            # riprendo ra
             addi $sp, $sp, 4            # dealloco
             jr   $ra                    # torno al chiamante (exeption handler)
            
        chiamaDivisione:
             jal  divisione              # richiamo la procedura divisione
             li $t1, 'v'
             move $a1, $t1
             jal stampaTracciaRitorno

             lw   $ra, 0($sp)            # riprendo ra
             addi $sp, $sp, 4            # dealloco
             jr   $ra                    # torno al chiamante (exeption handler)

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
somma:
        addi $sp, $sp, -8  # alloco memoria
        sw   $ra, 0($sp)   # salvo ra nello stack

        addi $a0, 4        # avanzo il puntatore di 4 byte
        jal  check         # richiamo la funzione check
        move $t0, $v0      # copio il valore di ritorno (indirizzo del puntatore)
        sw   $v1, 4($sp)   # salvo nello stack il valore di ritorno (numero)
        addi $t0, 1        # avanzo il puntatore di 1 byte
        move $a0, $t0      # copio l'indirizzo del puntatore per passarlo alla funzione check
        jal  check         # richiamo la funzione check
        move $t6, $v1      # carico il contenuto a cui punta il puntatore in $t6
        lw   $s1, 4($sp)   # riprendo il numero che avevo salvato nello stack
        add  $s0, $s1, $t6 # sommo il contenuto dei due registri e lo carico in $s0
        move $v1, $s0      # carico il risultato in $v1 come valore di ritorno per il chiamante
        
        lw   $ra, 0($sp)   # riprendo ra
        addi $sp, $sp, 8   # dealloco
        jr   $ra           # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sottrazione:
        addi $sp, $sp, -8  # alloco memoria
        sw   $ra, 0($sp)   # salvo ra nello stack

        addi $a0, 10       # avanzo il puntatore di 10 byte
        jal  check         # richiamo la funzione check
        move $t0, $v0      # copio il valore di ritorno (indirizzo del puntatore)
        sw   $v1, 4($sp)   # salvo nello stack il valore di ritorno (numero)
        addi $t0, 1        # avanzo il puntatore di 1 byte
        move $a0, $t0      # copio l'indirizzo del puntatore per passarlo alla funzione check
        jal  check         # richiamo la funzione check
        move $t6, $v1      # carico il contenuto a cui punta il puntatore in $t6
        lw   $s1, 4($sp)   # riprendo il numero che avevo salvato nello stack
        sub  $s0, $s1, $t6 # sottraggo il contenuto dei due registri e lo carico in $s0
        move $v1, $s0      # carico il risultato in $v1 come valore di ritorno per il chiamante

        lw   $ra, 0($sp)   # riprendo ra
        addi $sp, $sp, 8   # dealloco
        jr   $ra           # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
prodotto:
        addi $sp, $sp, -8  # alloco memoria
        sw   $ra, 0($sp)   # salvo ra nello stack

        addi $a0, 7        # avanzo il puntatore di 7 byte
        jal  check         # richiamo la funzione check
        move $t0, $v0      # copio il valore di ritorno (indirizzo del puntatore)
        sw   $v1, 4($sp)   # salvo nello stack il valore di ritorno (numero)
        addi $t0, 1        # avanzo il puntatore di 1 byte
        move $a0, $t0      # copio l'indirizzo del puntatore per passarlo alla funzione check
        jal  check         # richiamo la funzione check
        move $t6, $v1      # carico il contenuto a cui punta il puntatore in $t6
        lw   $s1, 4($sp)   # riprendo il numero che avevo salvato nello stack
        mul  $s0, $s1, $t6 # moltiplico il contenuto dei due registri e lo carico in $s0
        move $v1, $s0      # carico il risultato in $v1 come valore di ritorno per il chiamante

        lw   $ra, 0($sp)   # riprendo ra
        addi $sp, $sp, 8   # dealloco
        jr   $ra           # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
divisione:
        addi $sp, $sp, -8        # alloco memoria
        sw   $ra, 0($sp)         # salvo ra nello stack

        addi $a0, 8              # avanzo il puntatore di 8 byte
        jal  check               # richiamo la funzione check
        move $t0, $v0            # copio il valore di ritorno (indirizzo del puntatore)
        sw   $v1, 4($sp)         # salvo nello stack il valore di ritorno (numero)
        addi $t0, 1              # avanzo il puntatore di 1 byte
        move $a0, $t0            # copio l'indirizzo del puntatore per passarlo alla funzione check
        jal  check               # richiamo la funzione check
        move $t6, $v1            # carico il contenuto a cui punta il puntatore in $t6
        beq  $t6, $zero, divZero # gestisco il caso in cui il denominatore e' 0
        lw   $s1, 4($sp)         # riprendo il numero che avevo salvato nello stack
        div  $s0, $s1, $t6       # divido il contenuto dei due registri e lo carico in $s0
        move $v1, $s0            # carico il risultato in $v1 come valore di ritorno per il chiamante

        lw   $ra, 0($sp)         # riprendo ra
        addi $sp, $sp, 8         # dealloco
        jr   $ra                 # torno al chiamante (exeption handler)

    divZero:
             la $a2, error       # carico in $a0 la stringa error per stamparla
             li $v0, 4
             syscall
             li $v0, 10          # esco dal programma
             syscall
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
check:
        addi $sp, $sp, -4             # alloca memoria
        sw   $ra, 0($sp)              # salva ra nello stack
        
        lb   $t0, 0($a0)              # leggo il carattere della stringa in input a cui punta il puntatore
        li   $t4, 1                   #
        beq  $t0, '-', numeroNegativo # controllo se il numero e' negativo        
        
        slt  $t1, $t0, 58             # controllo se il valore ascii del carattere e' minore di 58
        bne  $t1, $zero, esciCheck    # vado all'etichetta esciCheck se lo e'
        jal  readChar                 # il carattere e' una lettera quindi richiamo la funzione readChar
        lw   $ra, 0($sp)              # riprendo ra
        addi $sp, $sp, 4              # dealloco
        jr   $ra                      # torno al chiamante (exeption handler)
        
        esciCheck:
             jal  prendiIntero        # il carattere e' un intero quindi richiamo la funzione prendiIntero
             mul  $v1, $v1, $t4       # moltiplico l'intero per il contenuto di $t4 per ottenere un valore positivo/negativo
             lw   $ra, 0($sp)         # riprendo ra
             addi $sp, $sp, 4         # dealloco
             jr   $ra                 # torno al chiamante (exeption handler)
                
        numeroNegativo:
             li   $t4, -1             # carico -1 per ottenere l'intero negativo
             addi $a0, 1              # avanzo il puntatore di 1 byte
             j    esciCheck           # vai all'etichetta esciCheck
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
prendiIntero:
        li   $t1, 0                     # azzero il registro $t1
        li   $t2, 0                     # azzero il registro $t2
        li   $t3, 10                    # carico l'intero 10 in $t3
        move $t0, $a0                   # copio il contenuto di $a0 (indirizzo del puntatore) in $t0
        
        ciclo:
             lb   $t1, 0($t0)           # memorizzo il contenuto di $t0 in $t1
             beq  $t1, ',', esci        # chiudo il ciclo e vado all'etichetta esci se il carattere e' una virgola
             beq  $t1, ')', fineStringa # chiudo il ciclo e vado all'etichetta fineStringa se il carattere e' una parentesi chiusa
             addi $t1, -48              # trasformo in intero sottraendo 48 dal valore ascii
             mul  $t2, $t2, $t3         # moltiplico per 10 il contenuto di $t2
             add  $t2, $t2, $t1         # sommo decine con unita'
             addi $t0, 1                # sposto il puntatore di una posizione
             j    ciclo                 # continuo il ciclo tornando all'etichetta ciclo
        esci:
             move $v0, $t0              # copio l'indirizzo del puntatore per restituirlo al chiamante
             move $v1, $t2              # copio il valore per restituirlo al chiamante
             jr   $ra                   # chiudo la funzione e torno al chiamante
            
        fineStringa:
             addi $t0, 1                # sposto il puntatore di una posizione 
             lb   $t3, 0($t0)           # memorizzo il contenuto a cui punta $t0 in $t3
             beqz $t3, esci             # vado all'etichetta esci se il carattere e' un byte zero (fine stringa)
             j    ciclo                 # continuo il ciclo tornando all'etichetta ciclo perche' ancora non ho trovato la fine della stringa
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
letturaFile:
    # Open File
    open:
        li   $v0, 13        # Open File Syscall
        la   $a0, file      # Load File Name
        li   $a1, 0         # Read-only Flag
        li   $a2, 0         # (ignored)
        syscall
        move $t6, $v0       # Save File Descriptor
        blt  $v0, 0, err    # Goto Error

    # Read Data
    read:
        li   $v0, 14        # Read File Syscall
        move $a0, $t6       # Load File Descriptor
        la   $a1, buffer    # Load Buffer Address
        li   $a2, 156       # Buffer Size 
        syscall

    # Print Data
    print:
        li   $v0, 4         # Print String Syscall
        la   $a0, cont      # Load Contents String
        syscall

    # Close File
    close:
        li   $v0, 16        # Close File Syscall
        move $a0, $t6       # Load File Descriptor
        syscall
        j    done           # Goto End

    # Error
    err:
        li   $v0, 4         # Print String Syscall
        la   $a0, fnf       # Load Error String
        syscall
        li   $v0, 10 
        syscall

    # Done
    done:
        jr   $ra
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
stampaTraccia:
        move $t8, $a0                            # salvo a0 per non perdelo
        move $t7, $a1                            # t7 = indirizzo attuale puntatore buffer
        li $t1, 0                                # t1 = contatore parentesi aperte
        li $t2, 0                                # t2 = contatore parentesi chiuse

        contaParentesiAperte:   
            addi $t7, 5                          # salta di 5 posizioni 
            lb $t3, 0($t7)                       # t3 -> char estratto
            li $t4,'('                           # t4 -> Carattere di confronto
            beq $t3, $t4, contatoreAperte        # se il carattere estratto è una parentesi vado ad incrementare il contatore

            li $t4,'a'
            beq $t3, $t4, saltaSottrazione

            li $t4,'t'
            beq $t3, $t4, saltaProdotto

            li $t4,'i'
            beq $t3, $t4, saltaDivisione

            contatoreAperte:        
                addi $t1, 1                      # incremento il contatore delle parentesi aperte
                addi $t7, 1                      # vado al carattere successivo
                j contaParentesiChiuse           # vado a contare le parentesi chiuse

            saltaSottrazione:
                addi $t1, 1                      # incremento il contatore delle parentesi aperte
                addi $t7, 7                      # vado al carattere successivo
                j contaParentesiChiuse           # vado a contare le parentesi chiuse

            saltaProdotto:
                addi $t1, 1                      # incremento il contatore delle parentesi aperte
                addi $t7, 4                      # vado al carattere successivo
                j contaParentesiChiuse           # vado a contare le parentesi chiuse

            saltaDivisione:
                addi $t1, 1                      # incremento il contatore delle parentesi aperte
                addi $t7, 5                      # vado al carattere successivo
                j contaParentesiChiuse           # vado a contare le parentesi chiuse

                
            contaParentesiChiuse: 
                lb $t3, 0($t7)                   # t3 -> char estratto
                li $t4, ')'                      # t4 -> confronto

                beq $t3, $t4, contatoreChiuse      # se ho trovato una parentesi chiusa vado a contarla
                li $t4, 'a'                      # confronto
                slt $t5, $t3, $t4                # se t3 < t4 il char è un numero (o una virgola), altrimenti è una lettera
                bnez $t5, jumpNum                # se t5 = 1 allora t3 non è una lettera
                j contaParentesiAperte           # se è una lettera è l'inizio di una funzione, quindi troverò prima una parentesi aperta

                contatoreChiuse:
                    addi $t2, 1                  # countChiuse++
                    addi $t7, 1                  # scorro il ptr
                    beq $t1, $t2, printSubstring # se il numero di parentesi aperte è uguale al numero di quelle chiuse allora ho individuato la sottostringa
                    j contaParentesiChiuse       # altrimenti continuo la conta 

                jumpNum:
                    addi $t7, 1     
                    j contaParentesiChiuse



                printSubstring:                    
                    li $t1, 0 
                    lb $t1, 0($t7)               # carico i char da salvare in t1
                
                    sb $zero, 0($t7)             # metto in fine stringa 
                    li $v0, 4
                    la $a0, frecciaIn            # stampo la stringa "-->"
                    syscall
                            
                    li $v0, 4           
                    move $a0, $t8                # posizione stringa
                    syscall                      # stampo
                    
                    sb $t1, 0($t7)               # ripristino ciò che avevo estratto

                    li $v0, 4           
                    la $a0, aCapo                # vado a capo
                    syscall             
                    move $a0, $t8                # riprendo il puntatore al buffer originale
            
        jr $ra                                   # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
stampaTracciaRitorno:
    
        move $t2, $a0                   # salvo il puntatore al buffer per non perderlo
        move $t3, $v0                   # salvo v0 per non perderlo
        move $t8, $a1                   # metto in t8 l'id della funzione
        move $t9, $s0                   # in t9 ho il valore di ritorno
        
        li $v0, 4
        la $a0, frecciaOut              # stampo la stringa "<--"
        syscall
    
        li $t1, 'm'
        beq $t8, $t1, caricaSomma       # somma

        li $t1, 't'
        beq $t8, $t1, caricaSottrazione # sottrazione

        li $t1, 'o'
        beq $t8, $t1, caricaProdotto    # prodotto

        li $t1, 'v'
        beq $t8, $t1, caricaDivisione   # divisione


        caricaSomma:
            la $a0, strSomma            # carico la posizione della stringa
            j stampaRitorno

        caricaSottrazione:
            la $a0, strSottr            # carico la posizione della stringa
            j stampaRitorno

        caricaProdotto:
            la $a0, strProd             # carico la posizione della stringa
            j stampaRitorno

        caricaDivisione:
            la $a0, strDiv              # carico la posizione della stringa
            j stampaRitorno


        stampaRitorno:
            li $v0, 4                   # codice per stampare una stringa
            syscall                     # stampo

            la $a0, strReturn           # carico la posizione dell'altro pezzo di stringa da stampare
            li $v0, 4                   # codice per stampare una stringa
            syscall                     # stampo

            move $a0, $t9               # carico il return value
            li $v0,1                    # codice per stampare un intero
            syscall                     # stampo

            la $a0, strClose            # carico la posizione dell'altro pezzo di stringa da stampare
            li $v0, 4                   # codice per stampare una stringa
            syscall                     # stampo
        
        move $a0, $t2
        move $v0, $t3
        
        jr $ra                          # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++