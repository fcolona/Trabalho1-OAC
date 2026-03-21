			.data
			.align 0
msg_boas_vindas:	.asciz "Boas Vindas!\n"
msg_opcao_incorreta:	.asciz "Opção Incorreta.\n"
menu_str:		.asciz "Escolha uma das seguintes opções:\n 1 - Adicionar vagão no início\n 2 - Adicionar vagão no final\n 3 - Remover vagão por ID\n 4 - Listar trem\n 5 - Buscar vagão\n 6 - Sair\n"
msg_insercao:		.asciz "Informe o tipo do vagão: "
tipo_locomotiva:	.asciz "Locomotiva"
msg_nao_encontrado:	.asciz "Vagão não encontrado\n" 
msg_encontrado:	.asciz "Vagão encontrado\n"
print_ID:		.asciz "ID: "
print_tipo:		.asciz "Tipo: "
print_proximo:		.asciz "Próx: "
print_seta:		.asciz "-> "
buffer_tipo_vagao:	.space 12
			.text
			.align 2
			.globl main
	
main:			#aloca memória para a locomotiva
			#ID: 4 bytes
			#Tipo: 24 bytes
			#Ptr Próx: 4 bytes
			#total: 32 bytes por vagão
			addi a7, zero, 9
			addi a0, zero, 32
			ecall
			add s0, zero, a0 #salva endereço da locomotiva
			
			#carrega o ID como 1
			addi s9, zero, 1 
			sw s9, 0(s0)
			
			#carrega ponteiro de próximo como 0
			sw zero, 24(s0)
			
			#carrega o campo como "locomotiva"
			la t0, tipo_locomotiva #aponta o ponteiro pro início da string tipo
			addi t1, s0, 4 #calcula o offset do campo "tipo" e aponta pra lá
			
loop_load:		lbu t2, 0(t0) #pega o caractere atual da string tipo
			sb t2, 0(t1) #copia o caractere para o campo
			beq t2, zero, fim_loop_load #se o caractere for igual a zero, acabou a cópia
			
			addi t0, t0, 1 #incrementa o ponteiro da string tipo
			addi t1, t1, 1 #incrementa o ponteiro do campo "tipo"
			j loop_load

fim_loop_load:		#printa msg de boas vindas
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
			addi t0, zero, 6
			beq s1, t0, opcao6
			
			#printa mensagem de opção incorreta
			addi a7, zero, 4
			la a0, msg_opcao_incorreta
			ecall
			j menu

#insere vagão no início
opcao1:			#aloca memória para o novo vagão
			addi a7, zero, 9
			addi a0, zero, 32
			ecall
			add s2, zero, a0 #salva endereço do novo vagão

			#printa mensagem de inserção de vagão
			addi a7, zero, 4
			la a0, msg_insercao
			ecall
			
			#carrega o ID do novo vagão
			addi s9, s9, 1 #incrementa o último ID usado
			sw s9, 0(s2)
			
			#acerto dos ponteiros
			lw t0, 28(s0) #pega o endereço do próximo da locomotiva
			sw t0, 28(s2) #põe ele como próximo do novo vagão
			sw s2, 28(s0) #põe a locomotiva como próximo do novo vagão 
			
			
			#coleta input de tipo do vagão
			addi a7, zero, 8
			addi a0, s2, 4 #calcula o offset do tipo de vagão
			addi a1, zero, 23 #define o máximo de caracteres
			ecall
			
			#remove o \n, caso houver
			addi t0, s2, 4 #aponta o ponteiro pro primeiro caractere
			addi t2, zero, '\n'
			addi t3, zero, '\0'
loop_remocao_nl:	lbu t1, 0(t0) #pega o caractere atual
			beq t1, t2, fim_loop_remocao_nl
			beq t1, t3, fim_loop_remocao_nl
			addi t0, t0, 1 #vai pro próximo caractere
			j loop_remocao_nl
			
fim_loop_remocao_nl:	sb t3, 0(t0) #troca o \n (ou o próprio \0) por um \0
			j menu
			
			



opcao2: j saida
opcao3: j saida


opcao4:			add t0, zero, s0 #aponta o ponteiro pra locomotiva
loop_print:		beq t0, zero, fim_loop_print #se chegou no final, sai do loop
			
			#printa ID
			addi a7, zero, 4
			la a0, print_ID
			ecall
			addi a7, zero, 1
			lw a0, 0(t0)
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
			addi a0, t0, 4 #calcula offset do tipo
			ecall
			
			#printa separação
			addi a7, zero, 11
			addi a0, zero, '|'
			ecall
			
			#printa próximo
			#addi a7, zero, 4
			#la a0, print_proximo       #PARA DEBUG
			#ecall
			#addi a7, zero, 1
			#lw a0, 28(t0)
			#ecall
			
			#printa separação
			#addi a7, zero, 11         #PARA DEBUG
			#addi a0, zero, '|'
			#ecall
			
			#printa seta
			addi a7, zero, 4
			la a0, print_seta
			ecall		
			
			lw t0, 28(t0)
			j loop_print

fim_loop_print: 	#print newline
			addi a7, zero, 11
			addi a0, zero, '\n'
			ecall
			j menu	



			#coleta input do ID do vagão
opcao5: 		addi a7, zero, 5
			ecall
			add s1, zero, a0 #salva o ID
			
			add t0, zero, s0 #aponta o ponteiro pra locomotiva
loop_busca:		beq t0, zero, vagao_nao_encontrado #se chegou no final, não encontrou
			
			lw t1, 0(t0) #carrega ID do vagão atual
			beq t1, s1, vagao_encontrado #se o ID do atual for igual ao ID a ser buscado, encontrou
			
			lw t0, 28(t0) #carrega o endereço do próximo vagão
			j loop_busca
			
			#printa mensagem de vagão não encontrado
vagao_nao_encontrado:	addi a7, zero, 4
			la a0, msg_nao_encontrado
			ecall
			
			j menu
			
			#printa mensagem de vagão encontrado
vagao_encontrado:	addi a7, zero, 4
			la a0, msg_encontrado
			ecall
			
			j menu				



opcao6: 		j saida


saida:			addi a7, zero, 10
			ecall

			
