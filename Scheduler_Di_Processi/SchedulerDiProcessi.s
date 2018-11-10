#SCHEDULER DI PROCESSI

# Autori:
# Gabriele Bertini – gabriele.bertini3@stud.unifi.it
# Lorenzo Pratesi Mariti – lorenzo.pratesi@stud.unifi.it
# 
# Data di consegna:
# 29 maggio 2016

.data
#STRINGHE PER IL MENU CON VARIE OPZIONI INTERNE:
    intestMenu:                .asciiz "\n================== Menu ==================\n"
    opzione1:                  .asciiz "1. Inserire nuovo Task\n"
    	inserisciPriorita:             .asciiz "Inserisci un numero da 0 a 9 per Priorita' Task: "
    	inserisciNome:                 .asciiz "Inserisci al massimo 8 caratteri per Nome Task: "
    	inserisciNumEsecuzioni:        .asciiz "Inserisci un numero da 1 a 99 per Numero di Esecuzioni Rimanenti: "
    opzione2:                  .asciiz "2. Eseguire Task in testa\n"
    opzione3:                  .asciiz "3. Eseguire Task con ID #\n"
        inserisciIDDaEseguire:         .asciiz "Inserisci ID da eseguire: "
    opzione4:                  .asciiz "4. Eliminare Task con ID #\n"
        inserisciIDDaEliminare:        .asciiz "Inserisci ID da eliminare : "
    opzione5:                  .asciiz "5. Modificare priorita' Task\n"
        inserisciIDDaModificare:       .asciiz "Inserisci ID da modificare: "
        inserisciNuovaPriorita:        .asciiz "Inserisci priorita: "
    opzione6:                  .asciiz "6. Cambiare politica scheduling\n"
        politicaPerPriorita:           .asciiz "\nPolitica per priorità"
        politicaPerNumEsec:            .asciiz "\nPolitica per numero di esecuzioni"
    opzione7:                  .asciiz "7. Esci\n\n"
    
#STRINGHE PER CONTROLLO ERRORI INSERIMENTO    
    inserimento:               .asciiz "Inserisci un numero da 1 a 7\n\n"
    erroreMenu:                .asciiz "Il numero inserito non era compreso tra 1 e 7 \n\n"
    errorePriorita:            .asciiz "Il numero inserito non era compreso tra 0 e 9 \n\n"
    erroreEsecuzioniRimanenti: .asciiz "Il numero inserito non era compreso tra 1 e 99 \n\n"
    erroreIDNonPresente:       .asciiz "\nID non presente nella lista\n"
    codaVuota:                 .asciiz "\nCODA VUOTA\n"
    numeroNonPresenteInLista:  .asciiz "\nIl numero ID inserito non è presente nella lista.\n"
    
#STRINGHE VARIE PER LA STAMPA TASK
    fine:                      .asciiz "USCITA \n\n"
    aCapo:                     .asciiz "\n"
    campi:                     .asciiz "\n| ID | PRIORITA' | NOME TASK | ESECUZ. RIMANENTI|\n"
    interLinea:                .asciiz "+----+-----------+-----------+------------------+"
    barra:                     .asciiz "|"
    spazio:                    .asciiz " "
    spazioP:                   .asciiz "     "
    spazioEsecPost:            .asciiz "         "
    spazioEsecPre:             .asciiz "       "

#MEMORIZZAZIONE DATI
    name: .space 9  # buffer di appoggio per leggere un nomeTask
    policy: .space 3    # buffer di appoggio per mantenere salvata la politica attuale
    jump_table: .word 7 # jump table array a 7 word che verra' instanziata dal main con gli indirizzi delle label che chiameranno le corrispondenti procedure

.text
.globl  main

main:  
	li   $s4, 0             # registro per l'id dei task, viene inizializzato a zero ed incrementato ad ogni nuovo inserimento
	move $t8, $zero         # t8 (= Testa della lista) = 0
	move $t9, $zero         # t9 (= Coda della lista) = 0
	li   $t3, 'a'           # registro d'appoggio per inizializzare la politica: a = per priorità, b = per numero di esecuzioni
	sb   $t3, policy($zero) # buffer che contiene la politica attuale (a, b)


        # prepara la jump_table con gli indirizzi delle case actions
	la   $t1, jump_table
	la   $t0, inserimentoTask	  
	sw   $t0, 0($t1)
	la   $t0, esecuzioneTaskInTesta  
	sw   $t0, 4($t1)
	la   $t0, esecuzioneTaskSpecifico	  
	sw   $t0, 8($t1)
	la   $t0, eliminazioneTaskSpecifico	  
	sw   $t0, 12($t1)
	la   $t0, modificaPrioritaTaskSpecifico	  
	sw   $t0, 16($t1)
	la   $t0, cambioPoliticaScheduling	  
	sw   $t0, 20($t1)
	la   $t0, esci	  
	sw   $t0, 24($t1)
	  
stampaMenu: # ETICHETTA: STAMPA IL MENU 
	li   $v0, 4          # $v0 = codice della print_string 
	la   $a0, intestMenu # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa
	li   $v0, 4          # $v0 = codice della print_string 
        la   $a0, opzione1   # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa
	li   $v0, 4          # $v0 = codice della print_string 
        la   $a0, opzione2   # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa
	li   $v0, 4          # $v0 = codice della print_string 
        la   $a0, opzione3   # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa
	li   $v0, 4          # $v0 = codice della print_string 
        la   $a0, opzione4   # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa
	li   $v0, 4          # $v0 = codice della print_string 
        la   $a0, opzione5   # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa
	li   $v0, 4          # $v0 = codice della print_string 
        la   $a0, opzione6   # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa
	li   $v0, 4          # $v0 = codice della print_string 
        la   $a0, opzione7   # $a0 =  indirizzo della stringa 
	syscall              # stampa la stringa

choice: # ETICHETTA: ATTENDE SCELTA DELL'UTENTE E SALTA ALLA LABEL CALCOLATA
# scelta della procedura o dell'uscita
	li   $v0, 4                 # $v0 = codice della print_string 
        la   $a0, inserimento       # $a0 =  indirizzo della stringa 
	syscall                     # stampa la stringa 
	  
        # legge la scelta
        li   $v0, 5
	syscall
	move $t2, $v0               # $t2 = scelta 1, ..., 7
	
	li   $v0, 4                 # $v0 = codice della print_string 
        la   $a0, aCapo             # $a0 =  indirizzo della stringa 
	syscall                     # stampa la stringa
        
	blez $t2, choice_err        # rimanda a choice_err se il numero inserito è minore di 7
	li   $t0, 7                 # inizializza t0 a 7   
	sle  $t0, $t2, $t0          
	beq  $t0, $zero, choice_err # errore se scelta > 7

branch_case:
	addi $t2, -1       # tolgo 1 da scelta perche' prima azione nella jump table (in posizione 0) corrisponde alla prima scelta del case
	add  $t0, $t2, $t2 
	add  $t0, $t0, $t0 # ho calcolato (scelta-1) * 4
	add  $t0, $t0, $t1 # sommo all'indirizzo della prima case action l'offset calcolato sopra
	lw   $t0, 0($t0)   # $t0 = indirizzo a cui devo saltare
	jr   $t0           # salto all'indirizzo calcolato
	
	choice_err:          # etichetta per errori inserimento scelta menu
        li   $v0, 4  
        la   $a0, erroreMenu # carico l'indirizzo della stringa 
        syscall              # stampa la stringa errore
        j    choice          # ritorna alla richiesta di inserimento di un numero tra 1 e 7
        
	
#Case 1: INSERIRE NUOVO TASK
inserimentoTask:
    inserimentoPriorita:
	la   $a0, inserisciPriorita # stampa stringa inserisci priorita
	li   $v0, 4
	syscall
	li   $v0, 5                 # prende intero da input
	syscall
	move $t2, $v0               # lo salva in t2
	blt  $t2, $zero, erroreP    # errore se scelta < 0
	li   $t0, 9
	sle  $t0, $t2, $t0
	beq  $t0, $zero, erroreP    # errore se scelta > 9

    inserimentoNome:
	la   $a0, inserisciNome # stampa stringa inserisci nome
	li   $v0, 4
	syscall
	li   $v0, 8             # prende stringa da input
	la   $a0, name          # alloca all'indirizzo name
	li   $a1, 9             # 8 byte = 8 caratteri
	syscall
	move $t3, $a0 #salva la stringa in t3

    inserimentoNumeroEsecuzioni:
	la   $a0, inserisciNumEsecuzioni    #stampa stringa inserisci numero esecuzioni
	li   $v0, 4
	syscall
	li   $v0, 5                         # prende intero da input
	syscall
	move $t4, $v0                       # lo salva in t4
	blez $t4, erroreE                   # salta se t4 è minore o uguale a 0
	li   $t0, 99                        # inizializzo li a 99 numero massimo di esecuzioni
	sle  $t0, $t4, $t0
	beq  $t0, $zero, erroreE            # errore se scelta > 99
        
        jal  creazione                      # chiamata a procedura creazione
        move $a1, $v0                       # salvo in a1 l'indirizzo del nuovo task
        move $a2, $t8                       # salvo in a2 la testa della lista
        
        lb   $t6, policy($zero)             # carico in t6 la politica attuale, vado a prenderla nel buffer policy di appoggio
        beq  $t6, 'a', inserisciModPriorita # salta a inserisciModPriorita se siamo nella condizione "a" (per Priorità)
        beq  $t6, 'b', inserisciModNumEsec  # salta a inserisciModNumEsec se siamo nella condizione "b" (per Numero di Esecuzioni)
        
        inserisciModPriorita:
             jal inserzionePriorita         # chiamata a procedura inserzionePriorita
             j   fineInserzione             # salto alla fine dell'etichetta inserimento
        
        inserisciModNumEsec:
             jal inserzioneNumEsecuzioni    # chiamata a procedura inserzioneNumEsecuzioni
             j   fineInserzione             # salto alla fine dell'etichetta inserimento
        
    fineInserzione:
	addi $s4, $s4, 1                    # aumenta numero ID task 
	move $a1, $t8                       # salvo la nuova testa (eventualmente modificata dall'inserimento del task) in a1 per poi passarla alla procedura di stampa

	jal  stampaTask                     # chiamata a procedura stampaTask 
	j    stampaMenu                     # esce, torna al menu

        erroreP:
             li $v0, 4
             la $a0, errorePriorita
             syscall                        # stampa la stringa errore
             j  inserimentoPriorita         # ritorna alla richiesta di inserimento di un numero tra 0 e 9

        erroreE:
             li $v0, 4  
             la $a0, erroreEsecuzioniRimanenti
             syscall                        # stampa la stringa errore
             j  inserimentoNumeroEsecuzioni # ritorna alla richiesta di inserimento di un numero tra 1 e 99


#Case 2: ESEGUO IL PRIMO TASK
esecuzioneTaskInTesta: 
	la   $a0, opzione2             # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                        # stampo la tringa "Eseguire Task in testa"
	
        jal  eseguiTaskInTestaAllaCoda # chiamata a procedura 
	j    stampaMenu                # esce, torna al menu

	
#Case 3: ESEGUIRE TASK a SCELTA
esecuzioneTaskSpecifico: 
	la   $a0, opzione3              # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                         # stampo la tringa "Eseguire Task con ID"
	la   $a0, inserisciIDDaEseguire # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                         # stampo la tringa "Inserisci ID da eseguire: "
	li   $v0, 5                     # prende intero da input
	syscall
	
	jal  eseguiTaskConID            # chiamata a procedura eseguiTaskConID
	j    stampaMenu                 # esce, torna al menu
	

#Case 4: ELIMINA TASK a SCELTA
eliminazioneTaskSpecifico: 
	la   $a0, opzione4               # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                          # stampo la tringa "Eliminare Task con ID #"
	la   $a0, inserisciIDDaEliminare # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                          # stampo la tringa "Inserisci ID da eliminare: "
	li   $v0, 5                      # prende intero da input
	syscall
	
	jal  eliminaTaskConID            # chiamata a procedura eliminaTaskConID
        move $a1, $t8                    # salvo la testa per passarla alla procedura di stampa
	jal  stampaTask                  # chiamata alla prcedura stampaTask
	j    stampaMenu                  # esce, torna al menu
	

#Case 5: MODIFICA PRIORITA' TASK a SCELTA
modificaPrioritaTaskSpecifico: 
	la   $a0, opzione5                # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                           # stampo la tringa "Modificare priorita' Task"
	la   $a0, inserisciIDDaModificare # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                           # stampo la tringa "Inserisci ID da modificare: "
	li   $v0, 5                       # prende intero da input
	syscall
	
        move $t2, $v0                     # salvo in t2 l'id da modificare
	
	la   $a0, inserisciPriorita       # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                           # stampo la tringa "Inserisci priorità: "
	li   $v0, 5                       # prende intero da input
	syscall
        
        jal  modificaPrioritaTask         # chiamata a procedura modificaPrioritaTask
        move $a1, $t8                     # salvo la testa per passarla alla procedura di stampa
        jal  stampaTask                   # chiamata alla prcedura stampaTask   
	j stampaMenu                      # esce, torna al menu

	
#Case 6: CAMBIA LA POLITICA
cambioPoliticaScheduling: 
	la   $a0, opzione6               # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                          # stampo la tringa "Cambiare politica scheduling"
	
	lb   $t3, policy($zero)          # carico in t3 la politica attuale, vado a prenderla nel buffer policy di appoggio 
	beq  $t3, 'a', cambiaB           # salta a cambiaB se t3 = a
	li   $t3, 'a'                    # altrimenti significa che t3 = b, devo cambiare in a
	sb   $t3, policy($zero)          # carico nel buffer la nuova politica cambiata
	la   $a0, politicaPerPriorita    # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall                          # stampo la tringa "Politica per priorità"
	j    cambiaPolitica              # salto all' etichetta cambiaPolitica nella quale verra cahimata la procedura adeguata
	
	cambiaB: 
            li   $t3, 'b'                # se sono a questa etichetta significa che t3 = a, devo cambiare in b
            sb   $t3, policy($zero)      # carico nel buffer la nuova politica cambiata    
            la   $a0, politicaPerNumEsec # carico l'indirizzo della stringa 
            li   $v0, 4
            syscall                      # stampo la tringa "Politica per numero di esecuzioni"
        
        cambiaPolitica:
            jal  ordinamentoPerPolitica  # chiamata a procedura ordinamentoPerPolitica
            move $a1, $t8                # salvo la testa per passarla alla procedura di stampa
            jal  stampaTask              # chiamata alla prcedura stampaTask   
            j    stampaMenu              # esce, torna al menu
            

#Case 7: ESCE DAL PROGRAMMA
esci: 
	la   $a0, opzione7 # carico l'indirizzo della stringa 
	li   $v0, 4
	syscall            #stampo la tringa "Esci"

	j    exit          # esce
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
creazione:                            #PROCEDURA: crea un record e lo riempie con i dati inseriti dall'utente
	li   $v0, 9                   # chiamata sbrk: restituisce un blocco di 8 byte, puntato da v0: il nuovo record
	li   $a0, 28                  # byte allocati
	syscall
	
        move $t7, $v0                 # salvo il ptr al nuovo record -> v0= ptr record
	addi $t7, 8
	sw   $s4, 0($v0)              # campo id
	sw   $t2, 4($v0)              # campo priorita
        move $a0, $t3                 # a0 = indirizzo della stringa inserita
	mettiCarattere:
             lb   $t3, 0($a0)         # carico int t3 il carattere digitato
             beq  $t3, '\n', fineNome # se t3 = \n salta
             sb   $t3, 0($t7)         # metto in memoria il carattere
             addi $t7, 1              # avanzo alla locazione successiva
             addi $a0, 1              # avanzo al carattere successivo
             j    mettiCarattere
    fineNome:
	sb   $zero, 0($t7)            # metto in memoria carattere fine stringa
	sw   $t4, 20($v0)             # campo numEsec
	sw   $zero, 24($v0)           # campo next

        jr   $ra                      # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
inserzionePriorita: #PROCEDURA: inserisce task in lista in modo ordinato (per priorità)
        move $t2, $a1                        # salvo in t2 il ptr al task da inserire
        move $t8, $a2                        # salvo in t8 la testa (eventualmente modificata)
        move $t6, $t8                        # t6 verra utilizzato come testa per scorrere
	bne  $t8, $zero, link_list           # se t8!=nil (coda non vuota) vai a link_list 
	move $t8, $t2                        # coda vuota, inserisco l'unico elemento, testa = t2
	move $t9, $t2                        # coda = t2
	j    esciInserzione                  # esco dall'inserzione

        link_list:          
             lw   $t3, 4($t6)                # t3 = priorità task puntato
             lw   $t4, 4($t2)                # t4 = priorità nuovo task
             slt  $t5, $t4, $t3              # t5 = nuovo campo priorità < attuale campo priorità puntato
            
             beq  $t3, $t4, controllaID      # se le priorità sono uguali controllo l'id di ciascun task 
             beqz $t5, attaccaAllaLista      # salta se t5 == false ( 0 ) 
             move $t7, $t6                   # t7 = t6 salvo puntatore attuale
             lw   $t3, 24($t6)               # t3 = puntatore elemento successivo
             bnez $t3, vaiAlSuccessivo       # salta se t3 != nil
             sw   $t2, 24($t9)               # il campo elemento successivo dell'ultimo del record prende v0
             move $t9, $t2                   # Coda = v0
             sw   $zero, 24($t2)             # rimetto a zero prt next
             j    esciInserzione             # fine inserizione
        
        vaiAlSuccessivo:
             lw   $t6, 24($t6)               # vado al sucessivo
             j    link_list                  # torno a link list
            
        controllaID:
             lw   $t3, 0($t6)                # t3 = id task puntato
             lw   $t4, 0($t2)                # t4 = id nuovo task
             slt  $t5, $t4, $t3              # t5 = nuovo campo id < attuale campo id puntato
             beqz $t5, attaccaAllaLista      # salta se t5 == false ( 0 ) 
             move $t7, $t6                   # t7 = t6 salvo puntatore attuale
             lw   $t3, 24($t6)               # t3 = puntatore elemento successivo
             bnez $t3, vaiAlSuccessivo       # salta se t3 != nil
             sw   $t2, 24($t9)               # il campo elemento successivo dell'ultimo del record prende v0
             move $t9, $t2                   # Coda = v0
             sw   $zero, 24($t2)             # rimetto a zero prt next
             j    esciInserzione             # fine inserizione
        
        attaccaAllaLista:
             bne  $t6, $t8, inserisciInLista # se il task nuovo non ha priorità massima, salta a inserisciInLista 
             sw   $t8, 24($t2)               # sennò puntatore next = punt nex del task in testa 
             move $t8, $t2                   # il task inserito è la nuova testa
             j    esciInserzione             # fine inserizione
            
        inserisciInLista:    
             sw   $t6, 24($t2)               # puntatore next del nuovo task = task successivo 
             sw   $t2, 24($t7)               # puntatore next del task precendente = punt next al nuovo task inserito                      

    esciInserzione:
        jr   $ra                             # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
inserzioneNumEsecuzioni:                      #PROCEDURA: inserisce task in lista in modo ordinato (per numero di esecuzioni)
        move $t2, $a1                         # salvo in t2 il ptr al task da inserire
        move $t8, $a2                         # salvo in t8 la testa (eventualmente modificata)
        move $t6, $t8                         # t6 verra utilizzato come testa per scorrere
	bne  $t8, $zero, link_list1           # se t8!=nil (coda non vuota) vai a link_list1
	move $t8, $t2                         # coda vuota, inserisco l'unico elemento, testa = t2
	move $t9, $t2                         # coda = t2
	j    esciInserzione1                  # esco dall'inserzione

        link_list1:          
             lw   $t3, 20($t6)                # t3 = numEsecuzioni task puntato
             lw   $t4, 20($t2)                # t4 = numEsecuzioni nuovo task
             slt  $t5, $t3, $t4               # t5 = nuovo campo numEsecuzioni > attuale campo numEsecuzioni puntato
            
             beq  $t3, $t4, controllaID1      # se il numero di esecuzione di esntrambi i task sono uguali controllo l'id di ciascun task   
             beqz $t5, attaccaAllaLista1      # salta se t5 == false ( 0 ) 
             move $t7, $t6                    # t7 = t6 salvo puntatore attuale
             lw   $t3, 24($t6)                # t3 = puntatore elemento successivo
             bnez $t3, vaiAlSuccessivo1       # salta se t3 != nil
             sw   $t2, 24($t9)                # il campo elemento successivo dell'ultimo del record prende v0
             move $t9, $t2                    # Coda = v0
             sw   $zero, 24($t2)              # rimetto a zero prt next
             j    esciInserzione1             # esco dall'inserzione
        
        controllaID1:
             lw   $t3, 0($t6)                 # t3 = id task puntato
             lw   $t4, 0($t2)                 # t4 = id nuovo task
             slt  $t5, $t4, $t3               # t5 = nuovo campo id < attuale campo id puntato
             beqz $t5, attaccaAllaLista1      # salta se t5 == false ( 0 ) 
             move $t7, $t6                    # t7 = t6 salvo puntatore attuale
             lw   $t3, 24($t6)                # t3 = puntatore elemento successivo
             bnez $t3, vaiAlSuccessivo1       # salta se t3 != nil
             sw   $t2, 24($t9)                # il campo elemento successivo dell'ultimo del record prende v0
             move $t9, $t2                    # Coda = v0
             sw   $zero, 24($t2)              # rimetto a zero prt next
             j    esciInserzione1             # esco dall'inserzione
        
        vaiAlSuccessivo1:
             lw   $t6, 24($t6)                # vado al sucessivo
             j    link_list1                  # torno a link list
            
        attaccaAllaLista1:
             bne  $t6, $t8, inserisciInLista1 # se il task nuovo non ha numEsecuzioni massimo, salta a inserisciInLista 
             sw   $t8, 24($t2)                # sennò puntatore next = punt nex del task in testa 
             move $t8, $t2                    # il task inserito è la nuova testa
             j    esciInserzione1             # esco dall'inserzione
            
        inserisciInLista1:    
             sw   $t6, 24($t2)                # puntatore next del nuovo task = task successivo 
             sw   $t2, 24($t7)                # puntatore nest del task precendente = punt next al nuovo task inserito                      

    esciInserzione1:
        jr   $ra                              # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
eseguiTaskInTestaAllaCoda:                           #PROCEDURA: esegue il task in coda.
        # PUSH nello Stack
        addi $sp, $sp, -4                            # alloca memoria
        sw   $ra, 0($sp)                             # salva ra nello stack

	move $t6, $t8                                # puntatore scorrimento
	move $t7, $t6                                # salvo in t7 il puntatore alla coda
        scorri1:
             lw   $t3, 24($t6)                       # salvo in t3 il next attuale
             beqz $t3, decrementaNumEsec             # se next == 0 salta
             move $t7, $t6                           # aggiorno t7
             lw   $t6, 24($t6)                       # vado al sucessivo
             j    scorri1                            # ciclo fino a che non sono arrivato in coda alla lista
            
        decrementaNumEsec:     
             lw   $t3, 20($t9)                       # metto in t3 il valore di num esecuzioni
             addi $t3, -1                            # faccio eseguire = decremento il numero
             beqz $t3, eliminaUltimoTask             # se t3 è arrivato a 0 sato ad elimina task
             sw   $t3, 20($t9)                       # metto in memoria il nuovo num esec
            
             lb   $t4, policy($zero)                 # carico in t4 la policy
             beq  $t4, 'a', trascuraOrdinamento      # se sono in politica Per priorità non necessito di ordinare i task per num esecuzioni
             bne  $t6, $t8, eseguiUltimo             # altrimenti eseguo l'ultimo task
             li   $t8, 0
             
        eseguiUltimo:
             sw   $zero, 24($t7)                     # metto a zero il next_ptr del task precedente a quello eseguito (stacco dalla lista il task eseguito) 
             move $t9, $t7                           # coda = t7
             move $a1, $t6                           # salvo in a1 il puntatore del task eseguito
             move $a2, $t8                           # salvo in a2 la testa
             jal  inserzioneNumEsecuzioni            # chiamo la procedura inserzioneNumEsecuzioni
             move $a1, $t8                           # salvo la nuova testa (eventualmente modificata) per passarla alla procedura stampa task
            
        trascuraOrdinamento:
             jal  stampaTask                         # stampo la lista
             j    esciEliminaTask                    # esco
            
        eliminaUltimoTask:
             beq  $t8, $t9, stampaMessaggioCodaVuota # se il task che voglio eliminare è l'unico della lista -> lista vuota
             sw   $zero, 24($t7)                     # elimino il collegamento a quel task
             move $t9, $t7                           # salvo in t9 la nuova coda della lista
             jal  stampaTask                         # stampo la lista
             j    esciEliminaTask                    # esco
    
        stampaMessaggioCodaVuota:
             jal  stampaMessaggioListaVuota          # se la lista è vuota chiamo la procedura stampaMessaggioListaVuota
            
    esciEliminaTask:    
        # POP nello Stack: 
        lw   $ra, 0($sp)                             # riprendo ra
        addi $sp, $sp, 4                             # dealloco 
        jr   $ra                                     # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
eseguiTaskConID:                                       #PROCEDURA: esegue il task assegnato
        # PUSH nello Stack
        addi $sp, $sp, -4                              # alloca memoria
        sw   $ra, 0($sp)                               # salva ra nello stack
        
        move $t6, $t8                                  # salvo in t6 la testa, t6 verra utilizzato come testa per scorrere
        move $t7, $t6                                  # salvo in t7 la testa, t7 mi serve come puntatore al task precendente, puntato da t6
        scorri2:
             lw   $t3, 0($t6)                          # carico l'id del task puntato
             beq  $t3, $v0, decrementaNumEsecID        # se t3 è uguale e v0 (task inserito dall'utente) salta a decrementaNumEsecID
             move $t7, $t6                             # altrimenti salvo in t7 ciò che punta t6
             lw   $t6, 24($t6)                         # avanzo t6, t6 punta al task successivo
             beqz $t6, numeroIDNonPresente             # se t6 è uguale a zero (significa che è arrivato in fondo alla lista) salta alla stampa di errore id
             j    scorri2                              # ritorna a scorri2

        decrementaNumEsecID:     
             lw   $t3, 20($t6)                         # metto in t3 il valore di num esecuzioni
             addi $t3, -1                              # faccio eseguire = decremento il numero
             beqz $t3, eliminaTask                     # se t3 è arrivato a 0 sato ad elimina task
             sw   $t3, 20($t6)                         # metto in memoria il nuovo num esec
             lb   $t4, policy($zero)                   # carico in t4 la policy
             beq  $t4, 'a', trascuraOrdinamento2       # se sono in politica Per priorità non necessito di ordinare i task per num esecuzioni
             beq  $t6, $t8, spostaLaTesta              # se voglio eseguire la testa, salto all'etichetta indicata
             beq  $t6, $t9, spostaLaCoda               # se voglio eseguire la coda, salvo all'etichetta indicata
             lw   $t3, 24($t6)                         # salvo in t3 il next_ptr del task puntato
             sw   $t3, 24($t7)                         # stacco il task puntato (faccio puntare t7 a ciò che puntava t6)
             j    modificaPrioritaTaskINS              # salto a modificaPrioritaTaskINS
            
             spostaLaTesta:
                  lw   $t8, 24($t8)                    # stacco la testa (basta avanzarla)
                  j    modificaPrioritaTaskINS
                
             spostaLaCoda:
                  sw   $zero, 24($t7)                  # stacco la coda (basta far puntare a zero il task precedente)
                  move $t9, $t7                        # salvo la nuova coda
                  j    modificaPrioritaTaskINS
            
             modificaPrioritaTaskINS:
                  sw   $zero, 24($t6)                  # metto a zero il next_ptr del task che ho eseguito
                  move $a1, $t6                        # salvo in a1 il task interessato
                  move $a2, $t8                        # salvo in a2 la testa
                  jal  inserzioneNumEsecuzioni         # chiamata alla procedura inserzioneNumEsecuzioni
                  move $a1, $t8                        # salvo la nuova testa (eventualmente modificata) per passarla alla procedura stampa task
            
        trascuraOrdinamento2:     
             jal  stampaTask                           # stampo la lista
             j    esciEliminaTaskID                    # esco    
            
        eliminaTask:
             beq  $t8, $t9, stampaMessaggioCodaVuotaID # se il task che voglio eliminare è l'unico della lista -> lista vuota
             beq  $t6, $t8, eliminaLaTesta             # se t6 è la testa salto a eliminaLaTesta
             lw   $t3, 24($t6)                         # altrimenti, salvo in t3 il next_ptr del task puntato
             sw   $t3, 24($t7)                         # stacco il task puntato (faccio puntare t7 a ciò che puntava t6)
             jal  stampaTask                           # stampo la lista
             j    esciEliminaTaskID                    # esco
            
        eliminaLaTesta:
             lw   $t3, 24($t6)                         # salvo in t3 il next_ptr del task puntato
             move $t8, $t3                             # salvo la nuova testa che è il successivo next_ptr di t6
             jal  stampaTask                           # stampo la lista
             j    esciEliminaTaskID
        
        numeroIDNonPresente:
             li   $v0, 4   
             la   $a0, numeroNonPresenteInLista        # carico l'indirizzo della stringa 
             syscall                                   # stampo la stringa "Numero ID non presente"
             j    esciEliminaTaskID                    # esco
        
        stampaMessaggioCodaVuotaID:
             jal  stampaMessaggioListaVuota            # se la lista è vuota chiamo la procedura stampaMessaggioListaVuota
            
    esciEliminaTaskID:
        # POP nello Stack: 
        lw   $ra, 0($sp)                               # riprendo ra
        addi $sp, $sp, 4                               # dealloco 
        jr   $ra                                       # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
eliminaTaskConID:                                       #PROCEDURA: elimina task da id dato in input
        # PUSH nello Stack
        addi $sp, $sp, -4                               # alloca memoria
        sw   $ra, 0($sp)                                # salva ra nello stack
        
        move $t6, $t8                                   # salvo in t6 la testa, t6 verra utilizzato come testa per scorrere   
        move $t7, $t6                                   # salvo in t7 la testa, t7 mi serve come puntatore al task precendente, puntato da t6
        scorri3:
             lw   $t3, 0($t6)                           # carico l'id del task puntato
             beq  $t3, $v0, eliminaTaskId               # se t3 è uguale e v0 (task inserito dall'utente) salta a eliminaTaskConID
             move $t7, $t6                              # altrimenti salvo in t7 ciò che punta t6
             lw   $t6, 24($t6)                          # avanzo t6, t6 punta al task successivo
             beqz $t6, numeroIDNonPresente2             # se t6 è uguale a zero (significa che è arrivato in fondo alla lista) salta alla stampa di errore id 
             j    scorri3                               # torno a scorri3
        
        eliminaTaskId:
             beq  $t8, $t9, stampaMessaggioCodaVuotaID2 # se il task che voglio eliminare è l'unico della lista -> lista vuota
             beq  $t6, $t8, eliminaLaTestaID            # se il task che voglio eliminare è la testa salto ad eliminaLaTestaID
             beq  $t6, $t9, eliminaLACodaID             # se il task che voglio eliminare è la coda salto  ad eliminaLACodaID
             lw   $t3, 24($t6)                          # altrimenti, salvo in t3 il next_ptr del task puntato
             sw   $t3, 24($t7)                          # stacco il task puntato (faccio puntare t7 a ciò che puntava t6)
             j    esciEliminaTaskID2                    # esco 
         
        eliminaLaTestaID:
             lw   $t3, 24($t6)                          # salvo in t3 il next_ptr del task puntato
             move $t8, $t3                              # salvo la nuova testa che è il successivo next_ptr di t6
             j    esciEliminaTaskID2                    # esco   
         
        eliminaLACodaID:
             sw   $zero, 24($t7)                        # stacco t6, metto a zero il next_ptr di t7
             move $t9, $t7                              # t7 = la nuova coda
             j    esciEliminaTaskID2                    # esco
         
        numeroIDNonPresente2:
             li   $v0, 4  
             la   $a0, numeroNonPresenteInLista         # carico l'indirizzo della stringa 
             syscall                                    # stampo la stringa "Numero ID non presente"
             j    esciEliminaTaskID2                    # esco
            
        
        stampaMessaggioCodaVuotaID2:
             jal  stampaMessaggioListaVuota             # se la lista è vuota chiamo la procedura stampaMessaggioListaVuota
            
    esciEliminaTaskID2:
        # POP nello Stack: 
        lw $ra, 0($sp)                                  # riprendo ra
        addi $sp, $sp, 4                                # dealloco 
        jr $ra                                          # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
modificaPrioritaTask:                            #PROCEDURA: modifica la priorità del task indicato da input
        # PUSH nello Stack
        addi $sp, $sp, -4                        # alloca memoria
        sw   $ra, 0($sp)                         # salva ra nello stack
        
        move $a3, $t8                            # salva in a3 la testa della lista
        move $t5, $a3                            # salva in t5 la testa della lista
        loop1:
             lw   $t3, 0($a3)                    # prendo id 
             beq  $t3, $t2, controlloPolicy      # se id preso è uguale a quella inserita da input salto.
             move $t5, $a3                       # altrimenti, salvo in t5 ciò che punta a3  
             lw   $a3, 24($a3)                   # altrimenti scorro
             beqz $a3, numeroIDNonPresente3      # se a3 è uguale a zero (significa che è arrivato in fondo alla lista) salta alla stampa di errore id 
             j    loop1                          # ritorno a loop1
        
        controlloPolicy:
             lb   $t3, policy($zero)             # carico in t3 la policy
             beq  $t3, 'b', esciModificaPriorita # se siamo in modalità numero esecuzioni, cambia la priorità senza ordinare

             beq  $a3, $t8, testaAA              # salta se voglio modificare la testa
             beq  $a3, $t9, codaAA               # salta se voglio modificare la coda
             lw   $t3, 24($a3)                   # carico in t3 il puntatore dell'id che voglio modificare
             sw   $t3, 24($t5)                   # lo stacco dalla lista, t5 = puntatore precedente
             sw   $v0, 4($a3)                    # metto la priorità desiderata nel task staccato
             move $a1, $a3                       # salvo il task staccato in a1
             move $a2, $t8                       # salvo la testa in a2
             j    chiamaINS                      # vado ad inserire
             testaAA:
                  move $a1, $a3,                 # salvo il task che staccherò in a1 
                  sw   $v0, 4($t8)               # metto la priorità desiderata nel task staccato
                  lw   $t8, 24($t8)              # avanzo la testa
                  move $a2, $t8                  # salvo la testa in a2
                  j    chiamaINS                 # vado ad inserire
             codaAA:
                  sw   $v0, 4($a3)               # metto la priorità desiderata nel task staccato
                  move $a1, $a3                  # salvo il task che staccherò in a1 
                  sw   $zero, 24($t5)            # stacco la coda mettensdo a zero il ptr precedente
                  move $a2, $t8                  # salvo la testa in a2
                  move $t9, $t5                  # salvo la nuova coda 
                  j    chiamaINS                 # vado ad inserire
                
             chiamaINS:
                  jal  inserzionePriorita        # chiamata a procedura inserzione per priorità 
                  j    esciFunzione              # esco 
      
        numeroIDNonPresente3:
             jal  stampaMessaggioIDNonPresente
             j    esciFunzione
    
    esciModificaPriorita:
        sw   $v0, 4($a3)
        
    esciFunzione:
        # POP nello Stack: 
        lw   $ra, 0($sp)                         # riprendo ra
        addi $sp, $sp, 4                         # dealloco 
        jr   $ra                                 # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ordinamentoPerPolitica:                      #PROCEDURA: faccio un ciclo di estrazioni in testa dalla vecchia lista e reinserisco i record 1 a 1 con i metodi di inserzione ordinati
        # PUSH nello Stack
        addi $sp, $sp, -4                    # alloca memoria
        sw   $ra, 0($sp)                     # salva ra nello stack
   
        li   $s7, 0                          # registro per contare quanti task ho inserito
        move $s3, $t8                        # se = testa
        beqz $s3, stampaMessaggioCodaVuotaOP # se la lista è vuota chiamo la procedura stampaMessaggioListaVuota
    numTask:
        lw   $s3, 24($s3)                    # avanza il ptr
        beqz $s3, selezione                  # salta se sono arrivato alla fine
        addi $s7, 1                          # incremento il contatore
        j    numTask
      
    selezione:
        lb   $t3, policy($zero)              # carico in t3 la politica attuale, vado a prenderla nel buffer policy di appoggio 
        beq  $t3, 'a', inserisciPerPriorita  # salta a inserisciModPriorita se siamo nella condizione "a" (per Priorità)
        beq  $t3, 'b', inserisciPerNumEsec   # salta a inserisciModNumEsec se siamo nella condizione "b" (per Numero di Esecuzioni)
        
    inserisciPerPriorita: 
        li   $s3, 0                          # inizializzo a 0 il contatore dei cicli
        li   $s6, 0                          # inizializzo a 0 la nuova testa
        move $s2, $t8                        # salvo la vecchia testa in t2
    cicloPriorita: 
        move $s5, $s2                        # s5 = testa
        lw   $s2, 24($s2)                    # avanzo t8 = estraggo la testa
        sw   $zero, 24($s5)                  # metto a 0 il next_ptr di s5
        move $a1, $s5                        # salvo in a1 il task da inserire
        move $a2, $s6                        # salvo in a2 la nuova testa
        jal  inserzionePriorita              # chimata alla procedura inserzionePriorita 
        move $s6, $t8                        # salvo in s6 la nuova testa
        beq  $s3, $s7, fineCiclo             # salta se ho raggiunto il nmero dei task
        addi $s3, 1                          # incremento il contatotore dei cicli
        j    cicloPriorita                   # ciclo finche non ho estratto tutti i task dalla vecchia lista
        
    inserisciPerNumEsec: 
        li   $s3, 0                          # inizializzo a 0 il contatore dei cicli
        li   $s6, 0                          # inizializzo a 0 la nuova testa  
        move $s2, $t8                        # salvo la vecchia testa in t2
    cicloNumEsec: 
        move $s5, $s2                        # s5 = testa
        lw   $s2, 24($s2)                    # avanzo t8 = estraggo la testa
        sw   $zero, 24($s5)                  # metto a 0 il next_ptr di s5
        move $a1, $s5                        # salvo in a1 il task da inserire
        move $a2, $s6                        # salvo in a2 la nuova testa
        jal  inserzioneNumEsecuzioni         # chimata alla procedura inserzioneNumEsecuzioni
        move $s6, $t8                        # salvo in s6 la nuova testa
        beq  $s3, $s7, fineCiclo             # salta se ho raggiunto il nmero dei task
        addi $s3, 1                          # incremento il contatotore dei cicli
        j    cicloNumEsec                    # ciclo finche non ho estratto tutti i task dalla vecchia lista
    
    
    stampaMessaggioCodaVuotaOP:
        jal  stampaMessaggioListaVuota
    
    fineCiclo:
        # POP nello Stack: 
        lw   $ra, 0($sp)                     # riprendo ra
        addi $sp, $sp, 4                     # dealloco
        jr   $ra                             # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++            
        
exit: # stampa messaggio di uscita e esce
	li   $v0, 4
	la   $a0, fine
	syscall

	li   $v0, 10 
        syscall

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++            

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
stampaTask:                   #PROCEDURA: stampa la lista con tutti i task
	# PUSH nello Stack
        addi $sp, $sp, -4     # alloca memoria
        
        sw   $ra, 0($sp)      # salva ra nello stack
        beqz $t8, esciStampa  # se t8 == 0 non ci sono elementi in lista, salta alla stampa del messaggio adeguato
	
        jal  vaiACapo         # chiamata alla procedura vaiACapo
	jal  stampaInterlinea # chiamata alla procedura stampaInterlinea

	li   $v0, 4    
	la   $a0, campi       # stampa i campi 
	syscall

	jal  stampaInterlinea # chiamata alla procedura stampaInterlinea
	jal  vaiACapo         # chiamata alla procedura vaiACapo

	move $t6, $a1         # t6 verra utilizzato come testa per scorrere
    initLoop:
        lw   $t7, 24($t6)     # t7 = valore del campo elemento-successivo dell'elemento corrente (puntato da t6)
        beqz $t7, endLoop     # va a endLoop se si è raggiunto la fine
        jal  stampaSingolo    # chiama a procedura di stampa Singolo task
        j    initLoop         # cicla 
    
    endLoop:
	jal  stampaSingolo    # chiama a procedura di stampa Singolo task (stampa L'ultimo task)
    esciStampa:   
        # POP nello Stack: 
        lw   $ra, 0($sp)      # riprendo ra
        addi $sp, $sp, 4      # dealloco
        jr   $ra              # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++       
stampaSingolo:                    #PROCEDURA: stampa singolarmente il task 
        # PUSH nello Stack
        addi $sp, $sp, -4         # alloca memoria
        sw   $ra, 0($sp)          # salva ra nello stack
        
        jal  stampaBarra          # stampa la barra
	li   $v0, 1               # altrimenti si stampa l'elemento corrente. Cioe':
	lw   $a0, 0($t6)          # a0 = valore del campo intero dell'elemento corrente (puntato da t6)
	jal  stampaSpazioID       # chiamata alla procedura stampaSpazioID
	li   $v0, 1               # altrimenti si stampa l'elemento corrente. Cioe':
	lw   $a0, 0($t6)          # a0 = valore del campo intero dell'elemento corrente (puntato da t6)
	syscall                   # stampa valore intero dell'elemento corrente
        jal  stampaSpazio         # stampa uno spazio

	jal  stampaBarra          # stampa la barra
	jal  stampaSpazioPriorita # chiamata a procedura stampaSpazioPriorita
	li   $v0, 1
	lw   $a0, 4($t6)          # stampa la priorità del task
	syscall
	jal  stampaSpazioPriorita # chiamata a procedura stampaSpazioPriorita

	jal  stampaBarra          # stampa la barra
	li   $v0, 4
	addi $a0, $t6, 8          # aumenta il puntatore al campo successivo
	syscall
	jal  stampaSpazioNome     # chiamata alla procedura stampa spazio nome

	jal  stampaBarra          # stampa la barra
	jal  stampaSpazioEsecPre  # chiamata alla procedura stampaSpazioEsecPre
	li   $v0, 1
	lw   $a0, 20($t6)         # stampa il campo numero esecuzioni
	syscall
	jal  stampaSpazioEsecPost # chimata alla procedura stampaSpazioEsecPre

	lw   $t6, 24($t6)         # t0 = valore del campo elemento-successivo dell'elemento corrente (puntato da t0)
	jal  stampaBarra          # stampa la barra
	jal  vaiACapo
	jal  stampaInterlinea
	jal  vaiACapo
        
        # POP nello Stack: 
        lw   $ra, 0($sp)          # riprendo ra
        addi $sp, $sp, 4          # dealloco
        jr   $ra                  # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#VARIE PROCEDURE DI STAMPA SPAZZI PER UNA CORRETTA VISONE DELLA TABELLA DEI TASK
vaiACapo:
	li   $v0, 4
	la   $a0, aCapo      # stampa "\n"
	syscall
	jr   $ra             # torna al chiamante

stampaInterlinea:
	li   $v0, 4
	la   $a0, interLinea # stampa interlina es: +------+------+-----
	syscall
	jr   $ra             # torna al chiamante

stampaBarra: 
	li   $v0, 4
	la   $a0, barra      # stampa barra |
	syscall
	jr   $ra             # torna al chiamante
	
stampaSpazio:
        li   $v0, 4
        la   $a0, spazio     # stampa uno spazio " "
        syscall
        jr   $ra             # torna al chiamante
        
stampaSpazioPriorita:
        li   $v0, 4   
        la   $a0, spazioP    # stampa 6 spazi 
        syscall
        jr   $ra             # torna al chiamante
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#VARIE POCEDURE DI STAMPA ERRORI
stampaMessaggioListaVuota:
        li   $t8, 0                   # azzero la testa
        li   $t9, 0                   # azzero la coda
        la   $a0, codaVuota           # stampo il messaggio CODA VUOTA
        li   $v0, 4   
        syscall
        jr   $ra                      # torna al chiamante

stampaMessaggioIDNonPresente:
        li   $v0, 4
        la   $a0, erroreIDNonPresente # stampa messaggio "ID non presente"
        syscall
        jr   $ra                      # torna al chiamante
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++      
stampaSpazioID:              #PROCEDURA: stampa i corretti spazi del campo id 
        # PUSH nello Stack
        addi $sp, $sp, -4    # alloca memoria
        sw   $ra, 0($sp)     # salva ra nello stack
        
        slt  $t7, $a0, 10    # guarda se il numero è < 10
        beqz $t7, dueCifreID # salta se non lo è 
        jal  stampaSpazio
	jal  stampaSpazio
	j    uscita
    
    dueCifreID:
        slt  $t7, $a0, 100   # guarda se il numero è < 100
        beqz $t7, uscita     # salta se non lo è 
        jal  stampaSpazio
    
    uscita:
        # POP nello Stack: 
        lw   $ra, 0($sp)     # riprendo ra
        addi $sp, $sp, 4     # dealloco
        jr   $ra             # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++      

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++      
stampaSpazioNome:          #PROCEDURA: stampa i corretti spazi del campo nome 
        # PUSH nello Stack
        addi $sp, $sp, -4  # alloca memoria
        sw   $ra, 0($sp)   # salva ra nello stack

        li   $t2, 11       # inizializzo il contatore di spazi a 11
    loop:
        lb   $t7, 0($a0)   # carica il carattere del nome task
        beqz $t7, fineLoop # se il carattere è uguale a zero salta
        addi $t2, -1       # decrementa il contatore 
        addi $a0, 1        # va al prossimo carattere
        j    loop
    fineLoop:
        beqz $t2, ex       # salta quando il contatore ragginge zero
        jal  stampaSpazio    
        addi $t2, -1       # decrementa il contatore
        j    fineLoop
        
    ex:    
        # POP nello Stack: 
        lw   $ra, 0($sp)   # riprendo ra
        addi $sp, $sp, 4   # dealloco
        jr   $ra           # torno al chiamante (exeption handler)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++      

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++      
stampaSpazioEsecPre:            #PROCEDURA: stampa i corretti spazi prima del num esecuzione 
        # PUSH nello Stack
        addi $sp, $sp, -4       # alloca memoria
        sw   $ra, 0($sp)        # salva ra nello stack
        
        li   $v0, 1
	lw   $a0, 20($t6)       # carica in a0 il campo num esecuzioni puntato
        slt  $t7, $a0, 10
        beqz $t7, dueCifreEsec  # salta se il num di esecuzini è > 10 
        li   $v0, 4
        la   $a0, spazioEsecPre # stampo 7 spazi
        syscall
        jal  stampaSpazio
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra
    
    dueCifreEsec:
        li   $v0, 4
        la   $a0, spazioEsecPre # il numeo è a due cifre
        syscall
        
        # POP nello Stack: 
        lw   $ra, 0($sp)        # riprendo ra
        addi $sp, $sp, 4        # dealloco
        jr   $ra                # torno al chiamante (exeption handler)
            
stampaSpazioEsecPost:           #PROCEDURA: stampa i corretti spazi dopo del num esecuzione 
        li   $v0, 4
        la   $a0, spazioEsecPost
        syscall
        jr   $ra
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++