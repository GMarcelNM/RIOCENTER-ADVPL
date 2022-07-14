#Include "protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
							
static cPath := "c:\temp\inventario\"
static cSeq	 := "0000"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |RIOA008   บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Mbrowse de transferencias entre sistemas.                  บฑฑ
//ฑฑบ          ณ A rotina de inventario foi customizada pois a Mare Mansa   บฑฑ
//ฑฑบ          ณ precisa utiliza-la para alterar tambem o custo.            บฑฑ                  
//ฑฑบ          ณ Alem disso, sao necessarias algumas especificidades da     บฑฑ
//ฑฑบ          ณ Mare Mansa, como um cadastro de/para entre os sistemas por บฑฑ
//ฑฑบ          ณ exemplo.                                                   บฑฑ
//ฑฑบ          ณ Para utilizar a rotina eh necessario seguir os passos:     บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ 1 - Incluir o inventario, esta tabela eh exclusiva, pois   บฑฑ
//ฑฑบ          ณ havera inventarios em todas as lojas.                      บฑฑ
//ฑฑบ          ณ 2 - Importar produtos, este botao ira jogar nos itens do   บฑฑ
//ฑฑบ          ณ inventario todo o cadastro de produtos, para o usuario nao บฑฑ
//ฑฑบ          ณ ter de digitar tudo la na tela de inclusao, porem, o usu-  บฑฑ
//ฑฑบ          ณ ario podera nao executar este passo, nao eh obrigatorio.   บฑฑ
//ฑฑบ          ณ 3 - Gerar planilha, este botao gera um TXT na pasta        บฑฑ
//ฑฑบ          ณ c:\temp\inventario\ da maquina, separado por ';', para o   บฑฑ
//ฑฑบ          ณ usuario abrir a planilha no excel e digitar as qtd, custo, บฑฑ
//ฑฑบ          ณ e codigos do SMM.                                          บฑฑ
//ฑฑบ          ณ 4 - Abrir a planilha, escolher as opcoes de configuracao   บฑฑ
//ฑฑบ          ณ do separador para ';' e tambem na coluna de produtos,      บฑฑ
//ฑฑบ          ณ marcar que sera texto, senao o excel ignorara os zeros a   บฑฑ
//ฑฑบ          ณ esquerda.                                                  บฑฑ
//ฑฑบ          ณ 5 - Salvar a planilha em CSV, eh importante fazer isso pq  บฑฑ
//ฑฑบ          ณ se salvar em TXT o excel retira os ';'.                    บฑฑ
//ฑฑบ          ณ 6 - Contar o estoque e preencher os dados na planilha      บฑฑ
//ฑฑบ          ณ 7 - Botao importar planilha, com isso os dados da planilha บฑฑ
//ฑฑบ          ณ serao jogados no sistema Protheus, eh importante manter a  บฑฑ
//ฑฑบ          ณ ordem dos primeiros 5 campos da planilha, pois estes camposบฑฑ
//ฑฑบ          ณ serao importados posteriormente.                           บฑฑ
//ฑฑบ          ณ 8 - Apos a importacao ja pode-se efetivar (botao) o        บฑฑ
//ฑฑบ          ณ inventario, com isso o sistema fara as movimentacoes de    บฑฑ
//ฑฑบ          ณ estoque para deixar o estoque da forma que foi informado   บฑฑ
//ฑฑบ          ณ no inventario. Note que os produtos que estiverm com ZERO  บฑฑ
//ฑฑบ          ณ tambem serao processados, e o sistema vai zerar o estoque  บฑฑ
//ฑฑบ          ณ deles.                                                     บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RIOA0008()

	Local aCores		:= {}

	Private cCadastro := "Inventแrio customizado - 2021-03-29 09:31."

	Private aRotina   := {{"Pesquisar"			,"axPesqui"						  							 ,0,1} ,;
						  {"Visualizar"			,"u_modeloaba(2,'RIOA008a')"								 ,0,2} ,;
	         		      {"Incluir"			,"u_modeloaba(3,'RIOA008a')" 								 ,0,3} ,;
	         		      {"Importar produtos"	,"Processa({|| U_RIOA08C()},'Imp. Prod. ','Processando',.T.)",0,4} ,;
		            	  {"Importar arquivo"	,"msAguarde({||U_RIOA08i() }, 'Importando...')"				 ,0,3} ,;
		            	  {"Atualizar Custo"	,"msAguarde({||U_RIOA08j() }, 'Validando...')"				 ,0,3} ,;
		            	  {"Imprimir Erros"		,"U_RIOR0013()"												 ,0,3} ,;
	         		      {"Efetivar inventario","Processa({|| U_RIOA08F()},'Efetivando ','Processando',.T.)",0,4} ,;
	         		      {"Cancelar"			,"u_RIOA08G()" 												 ,0,4} ,;
		             	  {"Alterar"			,"u_modeloaba(4,'RIOA008a')"								 ,0,4} ,;
		             	  {"Excluir"			,"u_RIOA08G()"												 ,0,5}}

	Private cDelFunc 	:= ".F."
	
	Private cString 	:= "ZI1"
	
	dbSelectArea("ZI1")
	
	ZI1->(dbSetOrder(1))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicio do trecho do ModeloAba()ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SetPrvt(u_modeloaba(0)) // declara as variaveis como private
	U_RIOA008a() // preenche os valores
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFim de trecho do ModeloAba()ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	AADD(aCores,{"ZI1_STATUS == 'A'","BR_BRANCO"}) //Aberto
	AADD(aCores,{"ZI1_STATUS == 'C'","BR_CANCEL"}) //Cancelado
	AADD(aCores,{"ZI1_STATUS == 'E'","BR_VERDE"	}) //Aprovado

	dbSelectArea(cString)
	MakeDir(cPath)
	mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ RIOA008a บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Fun็ใo que monta a tela para Cadastro, Altera็ใo, Visualizaบฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RIOA008a()
	
	aPrivates	:= u_modeloaba(1)
	
	for i:= 1 to len(aPrivates)
		&(aPrivates[i][1])	:= &(aPrivates[i][2])
	next
	//ฺฤฤฤฟ
	//ณPaiณ
	//ภฤฤฤู
	cCabec	:= 'ZI1'
	cRepCabec:= 'ZJ1'
	cTitulo	:= cCadastro

	//ฺฤฤฤฤฤฤฤฟ
	//ณFilha-1ณ
	//ภฤฤฤฤฤฤฤู
	aAdd(aFilhas	, 'ZI2')
	aAdd(aRepFilhas, 'ZJ2')	
	aAdd(aNomes		, 'Itens')
	aAdd(aOrdem 	, 1) // ZI2_FILIAL+ZI2_CODZI1+ZI2_SEQ
	aAdd(_aSeek		, "ZI1->ZI1_FILIAL + ZI1->ZI1_CODIGO")
	aAdd(aWhile		, {|| ZI2_FILIAL + ZI2_CODZI1})
	aAdd(aIniPos	, '+ZI2_SEQ')
	aAdd(aOrdItem	, 1) // ZI2_FILIAL+ZI2_CODZI1+ZI2_SEQ
	aLinha	:= {}
		aAdd(aLinha	, {'ZI2_FILIAL', "xFilial('ZI2')"			 	})
		aAdd(aLinha	, {'ZI2_CODZI1', "M->ZI1_CODIGO"				 	})
		aAdd(aLinha	, {'ZI2_SEQ'	, "GdFieldGet('ZI2_SEQ',n)"	})
	aAdd(_aChave	, aLinha)
	aAdd(aReadOnly	, .F.)
	
   if TYPE('VISUAL') <> 'U' .AND. VISUAL .AND. ZI1->ZI1_STATUS == 'E'
		aAdd(aFilhas	, 'SD3')
		aAdd(aNomes		, 'Movimenta็๕es de Estoque e custos')
		aAdd(aOrdem 	, 'CODZI1') // FILIAL + CODZI1 + SEQZI2
		aAdd(_aSeek		, "ZI1->ZI1_FILIAL + ZI1->ZI1_CODIGO")
		aAdd(aWhile		, {|| D3_FILIAL + D3_CODZI1})
		aAdd(aIniPos	, '+D3_CODZI1')
		aAdd(aOrdItem	, 'CODZI1') // FILIAL + CODZI1 + SEQZI2
		aLinha	:= {}
			aAdd(aLinha	, {'D3_FILIAL'	, "xFilial('SD3')"			 	})
			aAdd(aLinha	, {'D3_CODZI1'	, "M->ZI1_CODIGO"				 	})
			aAdd(aLinha	, {'D3_SEQZI2'	, "GdFieldGet('D3_SEQZI2',n)"	})
		aAdd(_aChave	, aLinha)
		aAdd(aReadOnly	, .T.)

		aLinha	:= {}
		aAdd(aLinha	, {'ZI2_SEQ'		, "D3_SEQZI2"})

		aAdd(aFiltro, {'ZI2', 'SD3', aLinha})
	endif

return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |GravaArq  บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Faz a gravacao fisica em um arquivo, baseando-se nos para- บฑฑ
//ฑฑบ          ณ metros passados.                                           บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GravaArq(cPath, cFilename, cConteudo)
	Local cDiretorio := cPath
	Local nHandle, cArquivo          
	
	cArquivo := cFilename

	nHandle := FCREATE(cDiretorio+cArquivo, 2)
	
	FWRITE(nHandle, cConteudo) 
	FCLOSE(nHandle)  
Return cArquivo 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |RIOA008C  บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que faz a populacao de produtos na ZI2              บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function ImportProdutos()
return U_RIOA08C()

User Function RIOA08C()
	local lResult	:= .T.
	local cSeek		:= ''
	local cUltSeq	:= ''
	local nCont		:= 0
	local nContSB2	:= 0
	local nTotalSB1:= 0         
	local cQuery
	
	SB1->(dbSetOrder(1)) // filial cod
	ZI2->(dbSetOrder(2)) // filial codzi1 + produto		


	if ZI1->ZI1_STATUS <> 'A'
		apMsgInfo('Nใo ้ possํvel caso o inventแrio nใo esteja em aberto')
		return .F.
	endif

	if !msgYesNo('Deseja popular este inventแrio com todos os produtos do cadastro?')
		lResult	:= .F.   
	endif      
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณConta quantos registros serao processadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT Count(*) as QTD FROM " + RetSqlName('SB2') + " SB2 "
	cQuery += "	WHERE B2_FILIAL = '" + xFilial('SB2') + "' AND B2_LOCAL = '"+ZI1->ZI1_ALMOX+"'"
	cQuery += " AND B2_QATU <> 0 "
	cQuery += " AND D_E_L_E_T_ <> '*' "

	If Select('QRYSB2') > 0
		QRYSB2->(DbCloseArea())
	EndIf     
	
	TcQuery cQuery New Alias 'QRYSB2'

	If QRYSB2->(!Eof())
		nTotalSB2:=QRYSB2->QTD
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAbre novamente a query para importar os produtosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT * FROM " + RetSqlName('SB2') + " SB2 "
	cQuery += "	WHERE B2_FILIAL = '" + xFilial('SB2') + "' AND B2_LOCAL = '"+ZI1->ZI1_ALMOX+"'"
	cQuery += " AND B2_QATU <> 0 "
	cQuery += " AND D_E_L_E_T_ <> '*' "

	If Select('QRYSB2') > 0
		QRYSB2->(DbCloseArea())
	EndIf     
	
	TcQuery cQuery New Alias 'QRYSB2'

	ProcRegua(nTotalSB2/50)

	BeginTran()
		if lResult
			cUltSeq	:= u_Max('ZI2', 'ZI2_SEQ', "ZI2_CODZI1= '" + ZI1->ZI1_CODIGO + "'", '0000')
	
			While !QRYSB2->(EOF())
				If ! SB1->(DbSeek(xFilial('SB1') + QRYSB2->B2_COD))
					QRYSB2->(DbSkip())
					LOOP 									
				EndIf
				
				nContSB2++
	
				if nContSB2 % 50 == 0
					IncProc("Processando..."+ StrZero(nContSB2, 6) + "/" + StrZero(nTotalSB2, 6))	
				endif
					
				if SB1->B1_MSBLQL == '1'
					QRYSB2->(DbSkip())
					LOOP 				
				endif
				
				if !ZI2->(dbSeek(ZI1->ZI1_FILIAL+ZI1->ZI1_CODIGO+SB1->B1_COD))
					nCont++
					cUltSeq	:= Soma1(cUltSeq)
					RecLock('ZI2', .T.)
						ZI2->ZI2_FILIAL	:= ZI1->ZI1_FILIAL
						ZI2->ZI2_CODZI1	:= ZI1->ZI1_CODIGO
						ZI2->ZI2_SEQ		:= cUltSeq
						ZI2->ZI2_DESC		:= SB1->B1_DESC
						ZI2->ZI2_PRODUTO	:= SB1->B1_COD
						ZI2->ZI2_QTD		:= 0
						ZI2->ZI2_CUSTO		:= Custo(SB1->B1_COD) 
						ZI2->ZI2_STATUS	:= 'A'
					ZI2->(msUnLock())
					
				endif
	
				QRYSB2->(dbSkip())

			EndDo

			if lResult
				EndTran()
			else
				DisarmTransaction()
			endif
			MsUnLockAll()
		endif
	if lResult
		apMsgInfo('Foram incluidos ' + cValToChar(nCont) + ' itens no inventario')
	else
		apMsgInfo('Houve algum problema e nใo foram inclusํdos os itens no inventแrio')
	endif
Return lResult  

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |POS       บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao auxiliar criada para localizar o nome do campo      บฑฑ
//ฑฑบ          ณ dentro do array aCampos.                                   บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function Pos(cItem)
	local nPos	:= aScan(aCampos, {|x| AllTrim(x) = cItem})
return nPos

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |TxtToVal  บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao auxiliar que converte um numero em texto para       บฑฑ
//ฑฑบ          ณ numerico, foi necessario pois a funcao deve estar preparadaบฑฑ
//ฑฑบ          ณ para lidar com pontos e virgulas.                          บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function TxtToVal(cValor)
	local cResult 	:= cValor
	local nResult	:= 0
	// tira o ponto
	cResult	:= StrTran(cResult, '.','')

	// transforma as virgulas em ponto
	cResult	:= StrTran(cResult, ',','.')	
	nResult	:= Val(cResult)
Return nResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |RIOA08F   บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que faz a efetivacao do inventario                  บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function Efetivar()
Return U_RIOA08F()


User Function RIOA08F(cFilInvent, cCodInvent, nRecNoIni, nRecNoFim)
	local lResult			:= .T.
	local cSeek				:= ''
	local aLog				:= {}
	local aZI2aProcessar	:= {}
	local i
	local aLjSempreco		:= {}
	local cArquivoLog		:= ''
	local nContIncProc	:= 0
	local TotalIncProc	:= 0
	
	Default cFilInvent	:= ''
	Default cCodInvent	:= ''
	Default nRecNoIni		:= 0
	Default nRecNoFim		:= 99999999999999
	
	If Empty(Funname())
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL cFilInvent
		ZI1->(DBSETORDER(1))
		ZI1->(dbseek(xFilial('ZI1')+cCodInvent))
		nRecNoIni		:= Val(nRecNoIni)
		nRecNoFim		:= Val(nRecNoFim)
	Else
		cFilInvent	:= cFilAnt
		cCodInvent	:= ZI1->ZI1_CODIGO
		nRecNoIni		:= 0
		nRecNoFim		:= 9999999999999
	EndIf
	
	cArquivoLog		:= cPath + 'LOG ' + ZI1->ZI1_CODIGO + '.TXT'
	
	cSeq	:= '000'
	
	if ZI1->ZI1_STATUS <> 'A'
		apMsgInfo('Inventแrio s๓ pode ser efetivado se estiver com status A - Aberto.(RIOA008)')
		lResult	:= .F.
	endif

	SB1->(dbSetOrder(1))

	if lResult
		
		ZI2->(dbSetOrder(1)) // filial codzi1 seq
		ZI2->(dbSeek(cSeek:=ZI1->ZI1_FILIAL + ZI1->ZI1_CODIGO))
		SB2->(dbSetOrder(1)) // filial cod almoxarifado

		nContIncProc	:= 0
		nTotalIncProc	:= Val(u_Max('ZI2', 'ZI2_SEQ', "ZI2_CODZI1= '" + ZI1->ZI1_CODIGO + "'", '0000'))

		ProcRegua(nTotalIncProc/50)		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVarre todos os itens do inventarioณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		while !ZI2->(EOF()) .AND. cSeek == ZI2->ZI2_FILIAL + ZI2->ZI2_CODZI1
			
			nContIncProc++

			if nContIncProc % 50 == 0
				IncProc("Processando..."+ StrZero(nContIncProc, 6) + "/" + StrZero(nTotalIncProc, 6))	
			endif  		           
			
			// parte do fonte criada para processar por faixa			
			If ! ( ZI2->(RECNO()) >= nRecNoIni .and.  ZI2->(RECNO()) <= nRecNoFim  )
				ZI2->(dbSkip())
				LOOP
			endif
			
			if	!SB1->(dbSeek(xFilial('SB1')+ZI2->ZI2_PRODUT)) .OR. SB1->B1_MSBLQL == '1'
				ZI2->(dbSkip())
				LOOP
			endif
			
			If ZI2->ZI2_STATUS == 'E'
				ZI2->(dbSkip())
				LOOP   		
   		    EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณOs produtos que nao tem quantidade, sao ignoradosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			if ZI2->ZI2_QTD > 0
				if ZI2->ZI2_CUSTO <= 0					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณSe permite custo zerado na planliha, achou o SB2 e o SB2 tem custo. ณ
					//ณEntao coloca o custo do SB2 na ZI2                                  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					if ZI1->ZI1_CUSZER == 'S' .AND. SB2->(dbSeek(ZI2->ZI2_FILIAL+ZI2->ZI2_PRODUT+ZI1->ZI1_ALMOX)) .AND. SB2->B2_CM1 >  0
					else
						aAdd(aLog, 'Seq ' + ZI2->ZI2_SEQ + '. Produto ' + ZI2->ZI2_PRODUT + ' estแ sem custo e com quantidade, nใo serแ possํvel efetivar')
					endif
				endif
				if empty(aLog)
					aAdd(aZI2aProcessar, ZI2->(RecNo()))
				endif				
			elseif ZI2->ZI2_QTD == 0
				if ZI2->ZI2_CUSTO > 0
					RecLock('ZI2', .F.)
						ZI2->ZI2_CUSTO 	:= 0
					ZI2->(msUnLock())
				endif
				aAdd(aZI2aProcessar, ZI2->(RecNo()))
			endif
			
			ZI2->(dbSkip())
		enddo     

		nContIncProc	:= 0
		nTotalIncProc	:= Len(aZI2aProcessar)
		ProcRegua(nTotalIncProc/50)						

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe o aLog esta VAZIO, entao esta OK para processar as movimentacoes de estoque ณ
		//ณe custos                                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if lResult .AND. empty(aLog)
			for i:= 1 to len(aZI2aProcessar)

				nContIncProc++

				if nContIncProc % 50 == 0
					IncProc("Processando Estoques..."+ StrZero(nContIncProc, 6) + "/" + StrZero(nTotalIncProc, 6))	
				endif  					

				ZI2->(dbGoTo(aZI2aProcessar[i]))

				BeginTran()

					RecLock('ZI2', .F.)
						ZI2->ZI2_STATUS := 'E'
					ZI2->(MsUnLock())						
	
					lResult	:= SetaEstoque(ZI2->ZI2_FILIAL, ZI2->ZI2_PRODUT, ZI1->ZI1_ALMOX, ZI2->ZI2_QTD, ZI2->ZI2_CUSTO, {'D3_CODZI1', 'D3_SEQZI2'}, {ZI1->ZI1_CODIGO, ZI2->ZI2_SEQ})
	
				If lResult
					EndTran()
				Else
					DisarmTransaction()
					Exit
				EndIf		

			next
		else
			GeraArquivo(aLog)
			lResult	:= .F.
		endif
	endif  	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMuda o status do inventario caso nao tenha mais itens que nao estejam efetivadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lResult .AND. ValidaStatus()
		RecLock('ZI1', .F.)
			ZI1->ZI1_STATUS 	:= 'E'
		ZI1->(msUnLock())  
		ApMsgInfo('Foi feita a efetiva็ใo do inventแrio '+ ZI1->ZI1_CODIGO +' com sucesso')
	Else
		ApMsgInfo('O inventario nao foi efetivado pois existem produtos ainda nao processados.')
	EndIf

Return

Static Function ValidaStatus               
	Local cQuery

	cQuery := " SELECT * FROM " + RetSqlName('ZI2') + " ZI2 "
	cQuery += " WHERE D_E_L_E_T_ <> '*' " 
	cQuery += " AND ZI2_CODZI1 = '" + ZI1->ZI1_CODIGO + "' AND ZI2_FILIAL = '" + ZI1->ZI1_FILIAL + "' "
	cQuery += " AND ZI2_STATUS <> 'E' "
	
	If Select('QRYZI2') > 0
		QRYZI2->(DbCloseArea())
	EndIF

	TcQuery cQuery New Alias "QRYZI2"

   If QRYZI2->(!Eof())
   	lRet := .F.
   Else
   	lRet := .T.
   EndIf

Return lRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |SetaEstoquบ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que fara a correcao do estoque se baseando no que   บฑฑ
//ฑฑบ          ณ foi informado no inventario                                บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function SetaEstoque(_cFilial, cProduto, cAlmox, nQtd, nCusto, aCampos_, aConteudos)
	local nQtdEstoque
	local nQtdReservas
	local nQtdDisponivel
	local nCustoAtual          
	local nQtdAjuste		:= 0
	local lResult			:= .T.
	local nQtdPlanilha	:= nQtd
	local nCustoPlanilha	:= nCusto
	local lEntrada			:= .F.
	local lSaida			:= .F.
	local nCustoTotal		:= 0
	local nQtd
	local nCustoAtual		:= 0
	local nCustoPlanilha	:= 0
	SB1->(dbSetOrder(1)) // filial cod
	SB2->(dbSetOrder(1)) // filial cod local
	SB9->(dbSetOrder(1)) // filial cod local
	
	if !SB9->(dbSeek(_cFilial+cProduto+cAlmox))
		 SB9->(RecLock("SB9",.T.))
          SB9->B9_FILIAL	:= _cFilial
          SB9->B9_COD		:= cProduto
          SB9->B9_LOCAL		:= cAlmox
   	SB9->(msUnLock())
   endif
          
//	CriaSB2(cProduto,cAlmox,_cFilial)
	
	if ! SB2->(dbSeek(PadR(AllTrim(_cFilial),TamSX3("B2_FILIAL")[1]) +;
	                  PadR(AllTrim(cProduto),TamSX3("B2_COD")[1]) + cAlmox))
	   CriaSB2(cProduto,cAlmox,_cFilial)

	   SB2->(dbSeek(_cFilial+cProduto+cAlmox))
//		apMsgInfo('Produto ' + cProduto + ' nใo encontrado no SB2 para a filial ' + _cFilial + '.')
//		lResult	:=  .F.
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGuarda as variaveis que podem ser uteis no decorrer do fonteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nQtdEstoque			:= SB2->B2_QATU
	nQtdReservas		:= SB2->B2_RESERVA
	nQtdDisponivel		:= SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QEMP

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณQuantidade que sera ajustada no 'SB2'ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nQtdAjuste		:= nQtdPlanilha - nQtdEstoque
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe for retirar do estoque, tem de verificar as reservas, para cancela-lasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lResult .AND. nQtdAjuste < 0
		if nQtdReservas > nQtdPlanilha
			lResult	:= CancelaReservas(_cFilial, cProduto, cAlmox, nQtdReservas - nQtdPlanilha)
		endif
	endif

	if lResult
		if nQtdAjuste > 0
			lEntrada	:= .T.
		elseif nQtdAjuste <= 0
			lSaida	:= .F.
		endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณParte referente a QTDณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			if lEntrada
				cTM	:= '201' // NAO VALORIZADA, QTD NAO ZERO
				lResult	:= ValidaTM(cTM, 'N', '2')
			else
				cTM	:= '601' // NAO VALORIZADA, QTD NAO ZERO
				lResult	:= ValidaTM(cTM, 'N', '2')
			endif         
			
			if lResult .AND. nQtdAjuste <> 0
				SB1->(dbSeek(xFilial('SB1')+cProduto))
				lResult	:= RodaSd3(cTm, Abs(nQtdAjuste), 0/*nCustoTotal*/, cAlmox, aCampos_, aConteudos)
			endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFim da parte referente a QTDณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณParte referente ao custoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if lResult
			nCustoAtual			:= SB2->B2_VATU1
			nCustoPlanilha		:= nCusto * nQtd		
			
			lEntrada	:= .F.
			lSaida	:= .F.
			
			if nCustoPlanilha > nCustoAtual
				lEntrada	:= .T.
			else
				lEntrada	:= .F.
			endif

			if lEntrada
				cTM	:= '002' // VALORIZADA, QTD ZERO
				lResult	:= ValidaTM(cTM, 'S', '1')
			else
				cTM	:= '505' // VALORIZADA, QTD ZERO
				lResult	:= ValidaTM(cTM, 'S', '1')
			endif         
			
			if lResult .AND. nQtdPlanilha >0
				if nCustoPlanilha <= 0
					if ZI1->ZI1_CUSZER == 'S'
						nCustoPlanilha	:= nCustoAtual
					endif
					if nCustoPlanilha <= 0
						apMsgInfo('Erro, o produto ' + cProduto + ' estแ sem custo atual e tambem nใo foi passado custo na planilha.')
						lResult	:= .F.
					endif
				endif
			endif
			
			nCustoTotal	:= nCustoPlanilha - nCustoAtual

			if lResult .AND. nCustoTotal <> 0
				SB1->(dbSeek(xFilial('SB1')+cProduto))
				lResult	:= RodaSd3(cTm, 0/*Abs(nQtdAjuste)*/, Abs(nCustoTotal), cAlmox, aCampos_, aConteudos)
			endif
		endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFim da parte referente ao custoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	endif
	
Return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |RodaSD3   บ Autor ณ George Allan       บ Data ณ  21/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que faz a movimentacao no SD3                       บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
static function rodaSd3(cTm, nQtd, nCusto, cLocal, aCampos_, aConteudos)
	local i
	local cD3_DOC		:= ''
	local lResult		:= .T.
	default aCampos_	:= {}
	default aConteudos:= {}
	
	cSeq := soma1(cSeq)

	cD3_DOC	:= ZI1->ZI1_CODIGO + cSeq
	
	if cD3_DOC == 'ZZZ'
		apMsgInfo('O mแximo de itens foi alcan็ado, impossํvel continuar (RIOA008)')
		lResult	:= .F.
	endif
	
	if lResult
		lMsErroAuto := .F.
				
			aVetor := { ;
			{"D3_TM"			,cTm				,NIL},;
			{"D3_COD"		,SB1->B1_COD	,NIL},;
			{"D3_UM"			,SB1->B1_UM		,NIL},;
			{"D3_LOCAL"		,cLocal			,NIL},;
			{"D3_TIPO"		,SB1->B1_TIPO	,NIL},;
			{"D3_EMISSAO"	,dDataBase		,NIL},;
			{"D3_DOC"		,cD3_DOC			,NIL},;	
			{"D3_CUSTO1"	,nCusto			,NIL},;		
			{"D3_QUANT"		,nQtd				,NIL}}
			
			if !empty(aCampos_) .AND. len(aCampos_) == len(aConteudos)
				for i:= 1 to len(aCampos_)
					aAdd(aVetor[1], {aCampos_[i], aConteudos[i], NIL})
				next
			endif
			
		 	MSExecAuto({|x,y| mata240(x,y)},aVetor,3)
			
			If lMsErroAuto
				MostraErro()
				lResult	:= .F.
			else
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFaz alteracao no SD3 para colocar os campos customizados.ณ
				//ณTentei colocar isto direto no execauto mas nao deu certo.ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if len(aCampos_) > 0
					RecLock('SD3', .F.)
						for i:= 1 to len(aCampos_)
							SD3->&(aCampos_[i])	:= aConteudos[i]
						next
					SD3->(msUnLock())
				endif
			endif
	endif
return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |CancelaResบ Autor ณ George Allan       บ Data ณ  21/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que cancela as reservas para poder viabilizar a cor-บฑฑ
//ฑฑบ          ณ rcao do estoque.                                           บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function CancelaReservas(_cFilial, cProduto, cAlmox, nQtd)
	local i
	local lResult		:= .T.
	local cQuery		:= ''

	local nQtdCancel	:= 0
	
	cQuery	:= " SELECT TOP " + StrZero(nQtd) + " Z20.R_E_C_N_O_ AS RECNOZ20 FROM " + RetSqlName('Z20') + ' Z20 '
	cQuery	+= " INNER JOIN " + RetSqlName('SC0') + " SC0 ON C0_FILIAL + C0_NUM + SC0.D_E_L_E_T_ =  Z20_FILORI + Z20_RESERV + Z20.D_E_L_E_T_ "
	cQuery	+= " WHERE Z20_STATUS IN ('0','1') "
	cQuery	+= " AND Z20_RESERV > '.' "
	cQuery	+= " AND Z20.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND Z20_PROD = '" 	+ cProduto 	+ "' "
	cQuery	+= " AND C0_LOCAL = '" 	+ cAlmox	 	+ "' "
	cQuery	+= " AND Z20_FILORI = '"+ _cFilial 	+ "' "
	
	cQuery	+= " ORDER BY Z20_DTVEND DESC "
	
	TcQuery cQuery New Alias "QRYA043"

	while !QRYA043->(EOF()) .AND. lResult
		Z20->(dbGoTo(QRYA043->RECNOZ20))
		oEntrega := entrega():editar(Z20->Z20_COD)
		lResult	:= oEntrega:excluirReserva(.T., Z20->Z20_ITEM, Z20->Z20_SEQ)

		if lResult
			nQtdCancel++
		else
			MostraErro()
		endif

		QRYA043->(dbSkip())
	enddo

	QRYA043->(dbCloseArea())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz esta verificacao pois pode ser que nem entre no while,  ณ
	//ณcom isso o lResult seria true mas nao tinha processado nada.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if nQtdCancel == nQtd
		lResult	:= .T.
	else
		apMsgInfo('Quantidade de reservas encontradas no Z20/SC0 ้ insuficiente. Produto ' + cProduto + ' almox ' + cAlmox + ' Qtd a cancelar ' + StrZero(nQtd,5) + ' <br> Qtd de reservas encontradas ' + StrZero(nQtdCancel,5))
		lResult	:= .F.
	endif

Return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |GeraArquivบ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao auxiliar que gera um arquivo TT se baseando no      บฑฑ
//ฑฑบ          ณ array passado no parametro, sera utilizado para o log de   บฑฑ
//ฑฑบ          ณ erros.                                                     บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GeraArquivo(aArray, cArqTxt)
	local i
	local lPrimeiraVez	:= .T.
	local cConteudoCampo := ''
	local cLinCab			:=''
	local cLin				:= ''
	default cArqTxt 		:= cPath + 'LOG' + AllTrim(ZI1->ZI1_CODIGO) + ".txt"
	Private nHdl   		:= fCreate(cArqTxt)
	Private cEOL    		:= "CHR(13)+CHR(10)"
		
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif
	

	for i:= 1 to len(aArray)
		cLin	:= aArray[i] + cEOL
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Exit
			Endif
		Endif
		ZI2->(dbSkip())
	next

	fClose(nHdl)

	apMsgInfo('Ocorreram erros. Foi gerado o arquivo ' + cArqTxt)
	ShellExecute( "Open", cArqTxt,'' , Left(cArqTxt, 2), 1 )
return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |RIOA08G   บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que faz o cancelamento de um inventario.            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RIOA08G()
	local lResult	:= .T.
   BeginTran()
	if ZI1->ZI1_STATUS <> 'A'
		apMsgInfo('S๓ ้ permitido se cancelar inventแrio em aberto')
		lResult	:= .F.
	endif

	if lResult .and. MsgYesNo('Tem certeza que deseja cancelar este inventแrio?')
		RecLock('ZI1', .F.)
			ZI1->ZI1_STATUS := 'C'
		ZI1->(msUnLock())
	endif
	if lResult
		EndTran()
		apMsgInfo('Foi cancelado o inventแrio ' + ZI1->ZI1_CODIGO + ' com sucesso.')
	else
		DisarmTran()
		apMsgInfo('Houve algum problema no cancelamento do inventแrio, o mesmo nใo foi cancelado.')
	endif
Return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |GetCodSMM บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que baseado no codigo do TOTVS procura o codigo do  บฑฑ
//ฑฑบ          ณ SMM na tabela de/para e retorna o codigo do SMM.           บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function GetCodSmm(cCodTOTVS)
	local cResult	:= ''
	ZB2->(dbSetOrder(2)) // filial + codpro
	if ZB2->(dbSeek(xFilial('ZB2')+cCodTOTVS))
		cResult	:= ZB2->ZB2_CODSMM
	endif
return cResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |SetCodSMM บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que cadastra na tabela de de/para o codigo do SMM   บฑฑ
//ฑฑบ          ณ que foi cadastrado na planilha, caso ja nao exista.        บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function SetCodSMM(cProduto, cCodSMM)
	ZB2->(dbSetOrder(1)) // filial + codpro
	BeginTran()
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe achar o produto do TOTVS, entao altera, senao incluiณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ZB2->(dbSeek(xFilial('ZB2')+cProduto))
		RecLock('ZB2', !ZB2->(Found()))
			ZB2->ZB2_CODPRO	:= cProduto
			ZB2->ZB2_CODSMM	:= cCodSMM
			ZB2->ZB2_FILIAL	:= xFilial('ZB2')	
		ZB2->(msUnlock())
	
	EndTran()
return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |ValidaTM  บ Autor ณ George Allan       บ Data ณ  19/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que valida se a TM esta da forma que deveria estar  บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function ValidaTM(cTM, cValorizada, cQtdZero)
	local lResult	:= .T.
	SF5->(dbSetOrder(1)) //filial + codigo
	if SF5->(dbSeek(xFilial('SF5')+cTM))
		if SF5->F5_VAL <> cValorizada .OR. SF5->F5_QTDZERO <> cQtdZero
			apMsgInfo('Ajuste a TM na rotina RIOA008 (SetaEstoque) ou no cadastro de TM. A TM ' + cTM + ' deveria ser valorizada = ' + cValorizada + ' e QtdZero = ' + cQtdZero)
			lResult	:= .F.
		endif
	else
		lResult	:= .F.
		apMsgInfo('Ajuste a TM na rotina RIOA008 (SetaEstoque) ou no cadastro de TM. A TM ' + cTM + ' nใo foi encontrada no cadastro' )
	endif
return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  |NomCateg  บ Autor ณ George Allan       บ Data ณ  21/03/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que retorna o nome da categoria.                    บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function NomCateg(cCategoria)
Return Posicione('AY0', 1, xFilial('AY0')+cCategoria, 'AY0_DESC')

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ RIOA007a บ Autor ณ Sidney Sales       บ Data ณ  09/07/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Importa o arquivo com as contagens dos produtos.           บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RIOA08i()
	Local aLinha := aRet := {}
	Local cArquivo 	:= ''
	Local nPosLoja		:= 1
	Local nPosCodBar	:= 2
	Local nPosAlmox	:= 3
	Local nPosQuant	:= 4    
	Local aErros		:= {}     
	Local cPasta		:= cPath
	Local cFile			:= ZI1->ZI1_CODIGO +"_"+ DtoS(dDataBase) +"_"+StrTran(Time(),":","_") + ".txt"
	Local cErro

	If ZI1->ZI1_STATUS <> 'A'
		apMsgInfo('Nใo ้ possํvel caso o inventแrio nใo esteja em aberto')
		return
	endif

	cArquivo := cGetFile('Importar Inventแrio | *.*','Drives Locais',0,'C:\',.f.,GETF_LOCALHARD,.F.)

	If ft_fuse(cArquivo) > 0			
		While !ft_feof()	   
			cLinha	:= ft_freadln()										
		  	If !Empty(cLinha)
//			  	aLinha 	:=	u_StrToArray(cLinha, ';')
				aLinha  := StrTokArr(cLinha,";")
			  	aAdd(aRet, aLinha)
			EndIf
			ft_fskip()    
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAlltera a tela de processoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                       
		 	MsProcTxt("Lendo arquivo...")
	      ProcessMessage()
	   EndDo
	Endif   	

	If Len(aRet) > 0

	   SB1->(DbSetOrder(5))	
	   ZI2->(DbSetOrder(2))		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPercorre o arrary criado com os dados do arquivo e faz as validacoes dos dadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For i := 1 to Len(aRet)               
		 	cErro := ""

		 	MsProcTxt("Gravando dados...")
	        ProcessMessage()

			If ZI1->ZI1_FILIAL <> aRet[i][nPosLoja]
				cErro += " LOJA(FILIAL) DIFERENTE DA DO INVENTARIO ESCOLHIDO |" 
			EndIf
			
			If ZI1->ZI1_ALMOX <> aRet[i][nPosAlmox]
				cErro += " ALMOXARIFADO DIFERENTE DO ALMOXARIFA DO INVENTARIO ESCOLHIDO |"  
			EndIf
			
			If Empty(cErro)
				If ! SB1->(DbSeek(xFilial('SB1') + aRet[i][nPosCodBar]))					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณTenta localizar incluindo o zero na frenteณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAlguma etiquetas da rio center contem um '0' na frente e o leitor nao le, por isso foi feito esse 'ajuste'ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If ! SB1->(DbSeek(xFilial('SB1') + '0' +aRet[i][nPosCodBar]))
						lLocalizou := .F.
					Else
						lLocalizou := .T.						
					EndIf
				Else
            	lLocalizou := .T.
				EndIf				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVeriifica se localizou o produtoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lLocalizou
				   If ! ZI2->(DbSeek(xFilial('ZI2') + ZI1->ZI1_CODIGO + SB1->B1_COD))
						cUltSeq	:= u_Max('ZI2', 'ZI2_SEQ', "ZI2_CODZI1= '" + ZI1->ZI1_CODIGO + "'", '0000')
						cUltSeq	:= Soma1(cUltSeq)		
						RecLock('ZI2', .T.)
							ZI2->ZI2_FILIAL	:= ZI1->ZI1_FILIAL
							ZI2->ZI2_CODZI1	:= ZI1->ZI1_CODIGO
							ZI2->ZI2_SEQ		:= cUltSeq
							ZI2->ZI2_DESC		:= SB1->B1_DESC
							ZI2->ZI2_PRODUTO	:= SB1->B1_COD
							ZI2->ZI2_QTD		:= Val(aRet[i][nPosQuant])//  0
							nCustoUni			:= Custo()
							If nCustoUni > 0
								ZI2->ZI2_CUSTO := nCustoUni
							EndIf
						ZI2->(msUnLock())
					Else
						RecLock('ZI2', .F.)
							ZI2->ZI2_QTD 	:= Val(aRet[i][nPosQuant])  
							nCustoUni		:= Custo()
							If nCustoUni > 0
								ZI2->ZI2_CUSTO := nCustoUni
							EndIf
						ZI2->(MsUnlock())
					EndIf			
				Else
					cErro := " PRODUTO NAO LOCALIZADO NO CADASTRO"
				EndIf

         EndIf

			If !Empty(cErro)
				aAdd(aErros, {aRet[i], cErro})
			Endif

		Next

		ApMsgInfo('Importado com sucesso.')
	Else
		ApMsgInfo('Nใo foram encontrados dados vแlidos para importar.')
	EndIf

	If Len(aErros) > 0
		If ! File(cPasta)
			MakeDir(cPasta)
	   EndIf

		nHdl := FCreate(cPasta + cFile)
	
		If (nHdl == -1 .or. nHdl == Nil)               
			ApMsgInfo('Erro na cria็ใo do arquivo para ger็aใo de log de erros, o log nใo serแ gerado.')
		Else			
			For i := 1 to Len(aErros)         	
				cLinha := aErros[i][1][nPosCodBar] + ";" + aErros[i][2] + chr(13) + Chr(10)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
				//ณGrava o conteudo da linha no arquivoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
				If FWrite(nHdl,cLinha,Len(cLinha))<>Len(cLinha)
				   ApMsgInfo("Ocorreu um erro na gravacao do arquivo.")
				Endif
			Next
				
		EndIF		
		
		ApMsgInfo('Erros foram localizados na importa็ใo verifique o arquivo com o log de erros em ' + cPasta + cFile)      
		
		FClose(nHdl)

	EndIf

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ RIOA08j  บ Autor ณ Sidney Sales       บ Data ณ  09/07/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para preecher todos os custos do inventario.        บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RIOA08j()
	Local cSeek
	Local nVlrCusto	:= 0
	Local lRet			:= .T.

	ZI2->(DbSetOrder(1))
    ZI2->(DbSeek(cSeek := xFilial('ZI1') + ZI1->ZI1_CODIGO ))

	While ZI2->(!Eof()) .AND. cSeek == ZI2->ZI2_FILIAL + ZI2->ZI2_CODZI1		
		                   
	 	MsProcTxt("Verificando custos - " + ZI2->ZI2_DESC )
        ProcessMessage()

		nVlrCusto := Custo()

		If nVlrCusto > 0 			
			RecLock('ZI2',.F.)
				ZI2->ZI2_CUSTO := nVlrCusto  
			ZI2->(MsUnLock())
		Else
			If ZI2->ZI2_CUSTO == 0
				lRet := .F.
			Endif
		Endif

		ZI2->(DbSkip())

	EndDo	

	If ! lRet
		ApMsgInfo('Aten็ใo existem produtos sem custo. Favor verifique o relat๓rio de erros.')		
	EndIf

Return lRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ Custo    บ Autor ณ Sidney Sales       บ Data ณ  09/07/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao que verifica o ultimo custo da nota de entrada do   บฑฑ
//ฑฑบ          ณ produto em qualquer filial.                                บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function Custo(cProd)
	Local cQuery
	Local nRet := 0
	Default cProd := ZI2->ZI2_PRODUT

	cQuery := " SELECT TOP 1 "
	cQuery += " D1_FILIAL, D1_EMISSAO, (D1_CUSTO / D1_QUANT) AS CUSTO, R_E_C_N_O_, D1_VUNIT "
	cQuery += " FROM " + RetSqlName('SD1')
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND D1_COD = '" + cProd + "' "
	cQuery += " AND D1_TIPO = 'N' "
	cQuery += " AND D1_FILIAL = '"+cFilAnt+"' "
	cQuery += " ORDER BY D1_EMISSAO DESC, R_E_C_N_O_ DESC "

	If Select('QRY') > 0
		QRY->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRY'

	If ! QRY->(Eof())
		If !Empty(QRY->CUSTO)
			nRet := QRY->CUSTO
		Else
			nRet := D1_VUNIT
		EndIf
	Else
	    cQuery := "Select TMP1.DA1_PRCVEN, TMP2.B1_PRV1"
		cQuery += "  from (Select b.DA1_PRCVEN, b.DA1_CODTAB"
	    cQuery += "          from " + RetSqlName("DA1") + " b, " + RetSqlName("DA0") + " a"
        cQuery += "           where b.D_E_L_E_T_ = ' '"
        cQuery += "             and b.DA1_CODPRO = '" + Alltrim(cProd) + "'"
        cQuery += "             and b.DA1_DATVIG <= '" + DToS(dDataBase) + "'"
        cQuery += "             and a.D_E_L_E_T_ = ' '"
        cQuery += "             and a.DA0_CODTAB = b.DA1_CODTAB"
        cQuery += "             and a.DA0_DATDE <= '" + DToS(dDataBase) + "'"
        cQuery += "             and (a.DA0_DATATE >= '" + DToS(dDataBase) + "' or a.DA0_DATATE = ' ')"
        cQuery += "             and a.DA0_ATIVO = '1') TMP1 FULL JOIN"
		cQuery += "       (Select SB1.B1_PRV1 from " + RetSqlName("SB1") + " SB1"
		cQuery += "          where SB1.D_E_L_E_T_ = ' '"
		cQuery += "            and SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
		cQuery += "            and SB1.B1_COD     = '" + Alltrim(cProd) + "') TMP2 ON 1 = 1"
        cQuery := ChangeQuery(cQuery)
	    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPRC",.T.,.F.) 

		If ! TMPRC->(Eof()) 
           nRet := IIf(TMPRC->DA1_PRCVEN == 0, TMPRC->B1_PRV1, TMPRC->DA1_PRCVEN) / 2
		EndIf

        TMPRC->(dbCloseArea())
//		If SB0->(DbSeek(xFilial('SB0') + ZI2->ZI2_PRODUT))		
//		   nRet := SB0->B0_PRV1	/ 2 //VALOR INFORMADO POR BRUNO		
//		EndIf
	Endif

Return nRet
