			.data
			.align 0
msg_boas_vindas:	.asciz "Boas Vindas!\n"
msg_opcao_incorreta:	.asciz "Opção Incorreta.\n"
menu_str:		.asciz "Escolha uma das seguintes opções:\n 1 - Adicionar vagão no início\n 2 - Adicionar vagão no final\n 3 - Remover vagão por ID\n 4 - Listar trem\n 5 - Buscar vagão\n 6 - Sair\n"
msg_insercao:		.asciz "Informe o tipo do vagão: "
tipo_locomotiva:	.asciz "Locomotiva"
msg_nao_encontrado:	.asciz "Vagão não encontrado\n" 
msg_encontrado:	.asciz "Vagão encontrado\n"
pergunta_remocao:	.asciz "Informe o ID do vagão: "
msg_remocao:	.asciz "Vagão removido\n"
msg_nao_pode_remover:	.asciz "Esse vagão não pode ser removido\n"
print_ID:		.asciz "ID: "
print_tipo:		.asciz "Tipo: "
print_proximo:		.asciz "Próx: "
print_seta:		.asciz "-> "
			.text
			.align 2
			.globl main
			
			# SIGNIFICADO DOS REGISTRADORES NA MAIN/MENU:
			# s0 guarda o endereço da locomotiva
			# s1 guarda inteiro input do usuário
			# s9 último ID utilizado
			
			# ESTRUTURA DA STRUCT DE UM VAGÃO
			#ID: 4 bytes
			#Tipo: 24 bytes
			#Ptr Próx: 4 bytes
			#total: 32 bytes por vagão
			# FAZER UMA ASCII ARTE DO VAGÃO SERIA BACANA
	
main:			#aloca memória para a locomotiva						
			addi a7, zero, 9
			addi a0, zero, 32
			ecall
			add s0, zero, a0 #salva endereço da locomotiva
			
			#carrega o ID como 1
			addi s9, zero, 1 
			sw s9, 0(s0)
			
			#carrega ponteiro de próximo como 0
			sw zero, 28(s0)
			
			#carrega o campo como "locomotiva"
			la a1, tipo_locomotiva #aponta o ponteiro de src pro início da string tipo_locomotiva
			addi a2, s0, 4 #calcula o offset do campo "tipo" e aponta o ponteiro de dst pra lá
			jal copiar_string #copia a string de src pra dst

			#printa msg de boas vindas
			addi a7, zero, 4
			la a0, msg_boas_vindas
			ecall

menu:			#printa menu
			addi a7, zero, 4
			la a0, menu_str
			ecall
			
			#coleta input de opção do menu
			addi a7, zero, 5
			ecall
			add s1, zero, a0 #salva opção escolhida
			
			#redireciona de acordo com a opção escolhida
			addi t0, zero, 1
			beq s1, t0, opcao1
			addi t0, zero, 2
			beq s1, t0, opcao2
			addi t0, zero, 3
			beq s1, t0, opcao3
			addi t0, zero, 4
			beq s1, t0, opcao4
			addi t0, zero, 5
			beq s1, t0, opcao5
			addi t0, zero, 6
			beq s1, t0, opcao6
			
			#printa mensagem de opção incorreta
			addi a7, zero, 4
			la a0, msg_opcao_incorreta
			ecall
			j menu
			
			
################################################
# 					       #	
#		OPÇÕES DO MENU	       	       #
#					       #	
################################################


opcao1:			add a1, zero, s0 #passa o endereço da locomotiva como parâmetro
			add a2, zero, s9 #passa o último ID como parâmetro
			jal inserir_inicio #recebe o novo ID como retorno
			add s9, zero, a0 #atualiza o último ID
			j menu
			
opcao2:			add a1, zero, s0 #passa o endereço da locomotiva como parâmetro
			add a2, zero, s9 #passa o último ID como parâmetro
			jal inserir_final #recebe o novo ID como retorno
			add s9, zero, a0 #atualiza o último ID
			j menu
					
			
opcao3:			addi a7, zero, 4
			la a0, pergunta_remocao
			ecall #pede o ID do vagao removido
			
			addi a7, zero, 5
			ecall #lê um inteiro
			add a2, zero, a0 #passa o ID como parâmetro
			
			add a1, zero, s0 #passa o endereço da locomotiva como parâmetro
			
			jal remover
			j menu

opcao4:			add a1, zero, s0
			jal listar
			j menu		

opcao5:			add a1, zero, s0 #passa o endereço da locomotiva como parâmetro

			#coleta input do ID do vagão
 			addi a7, zero, 5
			ecall
			
			add a2, zero, a0 #passa o ID como parâmetro
			jal buscar
			j menu		

opcao6: 		addi a7, zero, 10
			ecall		


################################################
# 					       #	
#	      OPERAÇÕES DA LISTA       	       #
#					       #	
################################################			

#DESCRIÇÃO:
#	insere vagão no início (logo antes da 
#	locomotiva) do trem.
#PARÂMETROS:
# 	a1: endereço da locomotiva
# 	a2: último ID
#RETORNO:
#	a0: novo ID
inserir_inicio:		addi sp, sp, -16 #reserva espaço na pilha
			sw s3, 12(sp) #salva s3
			sw s2, 8(sp)  #salva s2
            		sw s1, 4(sp)  #salva o s1 
            		sw ra, 0(sp)  #salva o return address
            		
            		add s1, zero, a1 #salva o endereço da locomotiva
            		add s2, zero, a2 #salva o último ID     

			#aloca memória para o novo vagão            
            		addi a7, zero, 9
			addi a0, zero, 32
			ecall
			add s3, zero, a0 #salva endereço do novo vagão

	            	#printa mensagem de inserção de vagão
	            	addi a7, zero, 4
	            	la a0, msg_insercao
	            	ecall	            
	
	            	#carrega o ID do novo vagão
	            	addi s2, s2, 1 #incrementa o último ID usado
	            	sw s2, 0(s3)
	            
	            	#acerto dos ponteiros
	            	lw t0, 28(s1) #pega o endereço do próximo da locomotiva
	            	sw t0, 28(s3) #põe ele como próximo do novo vagão
	            	sw s3, 28(s1) #põe o novo vagão como próximo da locomotiva 
	
	            	#coleta input de tipo do vagão
	            	addi a7, zero, 8
	            	addi a0, s3, 4 #calcula o offset do tipo de vagão
	            	addi a1, zero, 23 #define o máximo de caracteres
	            	ecall
	
	            	addi a1, s3, 4 #aponta o ponteiro pro primeiro caractere da string
	            	jal remover_new_line	            
	
			add a0, zero, s2 #retorna o novo ID
			
			#restaura os registradores salvos e o return address
	            	lw s3, 12(sp) 
	            	lw s2, 8(sp)
	            	lw s1, 4(sp)
	            	lw ra, 0(sp)
	                addi sp, sp, 16 #libera o espaço na pilha
	                
	            	jr ra 			

#DESCRIÇÃO:
#	insere vagão no final do trem.
#PARÂMETROS:
# 	a1: endereço da locomotiva do trem
# 	a2: último ID
#RETORNO:
#	a0: novo ID
inserir_final:		addi sp, sp, -16
			sw s3, 12(sp)
			sw s2, 8(sp)
			sw s1, 4(sp)
			sw ra, 0(sp)
			
			#salva os parâmetros
			add s2, zero, a2
			add s1, zero, a1

			#aloca memoria para o novo vagao
			addi a7, zero, 9
			addi a0, zero, 32
			ecall
			add s3, zero, a0 #salva o endereco do novo vagao em s3

			#printa a mensagem de insercao
			addi a7, zero, 4
			la a0, msg_insercao
			ecall
			
			#armazena o input tipo do vagao
			addi a7, zero, 8
			addi a0, s3, 4 
			addi a1, zero, 23 #max de caracteres
			ecall
			
			#remover o \n 
			addi a1, s3, 4 #aponta o ponteiro pro primeiro caractere da string
			jal remover_new_line

			#como ele vai pro fim, o prox ponteiro dele tem que ser zero
			sw zero, 28(s3)
			
			#incrementa o ID
			addi s2, s2, 1 
			sw s2, 0(s3)

			add t0, zero, s1 # t0 começa na locomotiva
loop_busca_fim:		lw t1, 28(t0) #carrega o ponteiro prox do vagao atual
			beq t1, zero, encontrou_o_fim #se for igual a 0, t0 é o ultimo vagao e sai do loop
			add t0, zero, t1 #se nao for igual a 0, avanca t0 para o proximo vagao
			j loop_busca_fim

encontrou_o_fim:	#t0 tem o endereco do (antigo) ultimo vagao
			sw s3, 28(t0) #salva o endereço do novo vagao (s3) no campo prox do ultimo (t0)

			add a0, zero, s2 #retorna o novo ID

			#restaura os registradores salvos e o return address
			lw s3, 12(sp)
			lw s2, 8(sp)
			lw s1, 4(sp)
			lw ra, 0(sp)
			
			#libera espaço na pilha
			addi sp, sp, 16
			
			jr ra
			

#DESCRIÇÃO: 
#	remove um vagão (exceto a locomotiva)
#	do trem.
# a1: endereço da locomotiva
# a2: ID a ser removido
remover:		add t2, zero, a1 #carrega o endereço da locomotiva
			lw t0, 0(t2) #guarda o id do vagao atual
loop:			beq t0, a2, efetuar_remocao #se o id do vagao atual for igual ao id digitado
			add t3, zero, t2 #guardar o endereço do vagão atual num registrador de backup
			lw t2, 28(t2) #carrega o endereço da proxima locomotiva
			beq t2, zero, nao_encontrado # se o endereço da proxima locomotiva for 0, o vagao nao foi encontrado
			lw t0, 0(t2) #guarda o id do vagao atual
			j loop

efetuar_remocao:	#primeiro, vamos checar se o vagao encontrado é a locomotiva
			beq t2, a1, nao_pode_remover

			#nesse estagio, t2 guarda o endereço do vagao que se deve remover, e t3 guarda o endereço do vagao antes
			lw t4, 28(t2) # carrega em t4 o endereço do vagão depois
			sw t4, 28(t3) # liga o vagão antes ao vagão depois
			
			addi a7, zero, 4
			la a0, msg_remocao
			ecall #imprime que o vagão foi removido
			
			jr ra

nao_pode_remover:
			addi a7, zero, 4
			la a0, msg_nao_pode_remover
			ecall #imprime que o vagão não pode ser removido
			
			jr ra

nao_encontrado:	

			addi a7, zero, 4
			la a0, msg_nao_encontrado
			ecall #imprime que o vagão não foi encontrado
			
			jr ra
    			
# DESCRIÇÃO:
#	lista todos os vagões do trem.
# PARÂMETROS:
# 	a1: endereço da locomotiva do trem
listar:			addi sp, sp, -4
			sw s1, 0(sp) 

			add s1, zero, a1 #aponta o ponteiro pra locomotiva
loop_print:		beq s1, zero, fim_loop_print #se chegou no final, sai do loop
			
			#printa ID
			addi a7, zero, 4
			la a0, print_ID
			ecall
			addi a7, zero, 1
			lw a0, 0(s1)
			ecall
			
			#printa separação
			addi a7, zero, 11
			addi a0, zero, '|'
			ecall
			
			#printa tipo
			addi a7, zero, 4
			la a0, print_tipo
			ecall
			addi a7, zero, 4
			addi a0, s1, 4 #calcula offset do tipo
			ecall
			
			#printa separação
			addi a7, zero, 11
			addi a0, zero, '|'
			ecall
			
			#printa seta
			addi a7, zero, 4
			la a0, print_seta
			ecall		
			
			lw s1, 28(s1)
			j loop_print

fim_loop_print: 	#print newline
			addi a7, zero, 11
			addi a0, zero, '\n'
			ecall
			
			lw s1, 0(sp) #restaura s1
			addi sp, sp, 4 #libera espaço na stack
			jr ra	



# DESCRIÇÃO:
#	busca um vagão de um trem pelo ID.
# PARÂMETROS:
# 	a1: endereço da locomotiva do trem
buscar:			add t0, zero, a1 #aponta o ponteiro pra locomotiva
loop_busca:		beq t0, zero, vagao_nao_encontrado #se chegou no final, não encontrou
			
			lw t1, 0(t0) #carrega ID do vagão atual
			beq t1, a2, vagao_encontrado #se o ID do atual for igual ao ID a ser buscado, encontrou
			
			lw t0, 28(t0) #carrega o endereço do próximo vagão
			j loop_busca
			
			#printa mensagem de vagão não encontrado
vagao_nao_encontrado:	addi a7, zero, 4
			la a0, msg_nao_encontrado
			ecall
			jr ra
			
			#printa mensagem de vagão encontrado
vagao_encontrado:	addi a7, zero, 4
			la a0, msg_encontrado
			ecall
			jr ra

			
			
			
################################################
# 					       #	
#	  PROCEDIMENTOS UTILITÁRIOS    	       #
#					       #	
################################################

#DESCRIÇÃO:
#	copia uma string de um endereço de origem
#	para um endereço de destino. 
#PARÂMETROS:			
# 	a1: endereço do src
# 	a2: endereço do dst
copiar_string:		lbu t2, 0(a1) #pega o caractere atual da string src
			sb t2, 0(a2) #copia o caractere para a string dst
			beq t2, zero, fim_copia #se o caractere for igual a zero, acabou a cópia
			addi a1, a1, 1 #incrementa o ponteiro do src
			addi a2, a2, 1 #incrementa o ponteiro do dst
			j copiar_string
			
fim_copia:		jr ra
		
				
#DESCRIÇÃO:
#	remove o \n de uma string, caso houver
#PARÂMETROS:
#	a1: endereço da str
remover_new_line:	addi t2, zero, '\n'
			addi t3, zero, '\0'
loop_remocao_nl:	lbu t1, 0(a1) #pega o caractere atual
			beq t1, t2, fim_loop_remocao_nl
			beq t1, t3, fim_loop_remocao_nl
			addi a1, a1, 1 #vai pro próximo caractere
			j loop_remocao_nl
			
fim_loop_remocao_nl:	sb t3, 0(a1) #troca o \n (ou o próprio \0) por um \0
			jr ra

			
