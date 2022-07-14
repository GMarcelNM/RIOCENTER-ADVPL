#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "PROTHEUS.ch"

#Define _Inicial	  1
#Define _Dinheiro     2
#Define _RioCenter    3
#Define _GiftCard     4
#Define _PresCard     5
#Define _Peggy        6
#Define _CCredito	  7
#Define _CDebito	  8
#Define _Sangria      9
#Define _VlrFinal    10
#Define _CupomCan    12
#Define _ItensCan    13
#Define _CartaoR4    14        // Adicionado por Rapahel Neves 29.09.2017
#Define _Abatimentos 15        
#Define _CancelRet   16        
#Define _Movimenta   18        
#Define _VendaBruta  19        
#Define _Trocas      20       
#Define _Bonus       21       
#Define _VendaLiq    22       
#Define _PagConta    23       
#Define _PgCtDin     24       
#Define _PgCtDeb     25       
#Define _PgCtCre     26      // Adicionado por Marcel Maia  22.07.2021  
#Define _MediaVenda  27       

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ RIOR0002 ºAutor  ³SIDNEY SALES        º Data ³  11/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³RELATORIO DE MAPA RESUMO, LISTA AS VENDAS POR FORMA DE PGTO º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function RIOR0002

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "Relatório de Mapa Resumo"
Private cPict        := ""
Private titulo       := "Relatório de Mapa Resumo"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""

Private imprime      := .T.
Private aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RIOR0002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RIOR0002" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SL4"

Private aEntradas	  := {}
Private aRecebimentos := {}
Private aSaidas       := {}
Private aResumo	      := {}
Private aCaixas	      := {}
Private aSaldos	      := {}
Private aCartoes	  := {}

Private cPerg     := "U_RIOR0002"
Private lGeral	  := .F.
Private nEstornos := 0
//Private cExcluiCxs:= u_StrQryIn(SuperGetMv('MS_CXFORAS',.F.,'COF,CTR,CX1' ),',')
  Private cExcluiCxs:= SuperGetMv('MS_CXFORAS',.F.,'COF,CTR,CX1' )
  
dbSelectArea("SL4")
dbSetOrder(1)

ValidPerg()

If !(Pergunte(cPerg,.T.))
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso o usuario nao escolha o caixa, entao sera gerado um         ³
//³relatorio somando todos os caixas, se nao, ira gerar um relatorio³
//³para cada caixa do intervalo                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(MV_PAR01) .AND. Empty(MV_PAR02)
	lGeral	:= .T.
	aAdd(aCaixas,{"GERAL", "TODOS OS CAIXAS"})
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciona os caixas(bancos) informados nos parametros³
	//³e coloca no arrau de caixas para impressao.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery	:= " SELECT * FROM " + RetSqlName("SA6") + " SA6 "
	cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND A6_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery	+= " AND A6_FILIAL BETWEEN '" + left(MV_PAR05,2) + "' AND '" + left(MV_PAR06,2) + "' "
	cQuery 	+= " AND A6_COD NOT IN (" + cExcluiCxs + ") "

	If Select('QRYSA6') > 0
		QRYSA6->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYSA6'

	MemoWrit("c:\Query_QRYSA6",cQuery)

	While QRYSA6->(!Eof())
		aAdd(aCaixas,{QRYSA6->A6_COD, QRYSA6->A6_NOME})
		QRYSA6->(DbSkip())
	Enddo

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

  nTipo := If(aReturn[4]==1,15,18)

  RptStatus({|| RunReport() },Titulo)
Return

Static Function RunReport()
  Local i  := 0
  Local j  := 0
  Local nX := 0
  Local nI := 0
  
  Local nVlDin := 0
  Local nVlChq := 0
  Local nVlDeb := 0
  Local nVlCre := 0
  Local nTtPFt := 0
  Local nTtVen := 0
  
  Entradas()          // Montar array de entradas dos caixas
  Recebimentos()      // Montar array de recebimentos

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Apos montar o array de recebimentos faz a ordenacao pela posicao 4³
	//³que diferencia transferencia de pagamentos de fatura e acordo     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For i := 1 to Len(aRecebimentos)
      aSort(aRecebimentos[i][2],,,{|x,y|x[4] > y[4]})
  Next

  Saidas()           // Montar array de saídas

 // --- Aqui ira percorrer o array gerado de caixas, imprimindo cada caixa em uma página
 // ------------------------------------------------------------------------------------
  For i := 1 To Len(aCaixas)
	  Cabec1 := "FECHAMENTO DE CAIXA | " + Alltrim(aCaixas[i][1]) + " - " + Alltrim(aCaixas[i][2]) + " | Data: " + DtoC(MV_PAR03) + " a " + DtoC(MV_PAR04)

	  If i > 1
	     nLin := 100
	  Endif

	  AddLinha(@nLin)

	  VendasNaoProcessadas()

	  nEntradas	   := 0
	  nSaidas	   := 0
	  nQtdEntradas := 0
	  nQtdSaidas   := 0
	  nQtdReceb	   := 0
	  nSaldoTotal  := 0

	  Resumo()         // Montar o array do Resumo

	 // --- Procura em que posição do array de entradas o caixa atual estão
	 // -------------------------------------------------------------------
	  nPosCx := aScan(aEntradas,{|x| x[1] == aCaixas[i][1]})

	 // --- Verifica o saldo inicial e coloca no array de resumo
	 // --------------------------------------------------------
	  aResumo[_Inicial][2] += SldInicial(aCaixas[i][1], MV_PAR03)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso tenha entradas etnao imprime as entradas do caixa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPosCx > 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chama rotina que ira incluir bonus das entradas, esse bonus³
			//³sao nccs incluidas que nao tem nota de entrada vinculada   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAux := Bonus(aCaixas[i][1])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Coloca no resumo o valor e a quantidade de itens bonus     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aResumo[_Bonus][2] := aAux[1]
			aResumo[_Bonus][3] := aAux[2]

			if aAux[1] > 0
				aAdd(aEntradas[nPosCx][2], {'', 'NCC', '', '', aAux[1],aAux[2]})
   			Endif

		  	If ! Empty(mv_par05) .or. mv_par05 == mv_par06
		  	   @nLin,05 PSAY " FILIAL - " + Posicione("SM0",1,SM0->M0_CODIGO + mv_par05,"M0_FILIAL")
		  	   AddLinha(@nLin)
		  	EndIf
		  	   
		  	@nLin,35 PSAY " ENTRADAS "
		  	AddLinha(@nLin)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Soma todas as entradas do caixa, foi somado antes para poder³
			//³colocar o percentual de cada tipo de pagamento ao imprimir  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotEntra := SomaEntra(aEntradas[nPosCx][2])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime todas as entradas do caixa³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTtVen := 0
			
			For j := 1 To Len(aEntradas[nPosCx][2])
			    AddLinha(@nLin)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica na tabela 24 qual a descricao da forma de pgto³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aEntradas[nPosCx][2][j][2] == 'NCC'
					cDescricao := 'BONUS RIO CENTER'
				Else
					cDescricao := Left(Posicione("SX5",1,xFilial("SX5") + "24" + aEntradas[nPosCx][2][j][2],"X5_DESCRI"),16)
				Endif

		      	@nLin,02 PSAY Alltrim(aEntradas[nPosCx][2][j][2]) + " " + cDescricao 	//FORMA E DESCRICAO
		     	@nLin,22 PSAY Left(Padr(Alltrim(aEntradas[nPosCx][2][j][3]),15),15)  	//ADMINISTRADORA DO CARTAO
		   	    @nLin,38 PSAY aEntradas[nPosCx][2][j][4] + Iif(Empty(aEntradas[nPosCx][2][j][4])," ","x")	//QUANTIDADE DE PARCELAS
				@nLin,42 PSAY Transform(aEntradas[nPosCx][2][j][5],"@e 999,999,999.99")	//VALOR DA ENTRADA
				@nLin,56 PSAY "(" + StrZero(aEntradas[nPosCx][2][j][6],4) + ")"		  	//QUANTIDADE

				@nLin,62 PSAY Transform(aEntradas[nPosCx][2][j][5] / aEntradas[nPosCx][2][j][6],"@e 9,999.99")	//CUPOM MEDIO

				@nLin,70 PSAY Transform(aEntradas[nPosCx][2][j][5] / nTotEntra * 100, "@e 999.99") + "%"

			   // --- Soma ao total de entradas 
			   // -----------------------------
				nEntradas	 += aEntradas[nPosCx][2][j][5]
				nQtdEntradas += aEntradas[nPosCx][2][j][6]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a forma de pagamento para somar no array de RESUMO de caixa³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Do Case
	   		       Case Alltrim(aEntradas[nPosCx][2][j][2]) == "R$"
				        aResumo[_Dinheiro][2] += aEntradas[nPosCx][2][j][5]      // Dinheiro

				   Case Alltrim(aEntradas[nPosCx][2][j][2]) == "CC"
		     			aResumo[_CCredito][2] += aEntradas[nPosCx][2][j][5]      // Cartão de Crédito

	   		       Case Alltrim(aEntradas[nPosCx][2][j][2]) == "CD"
					    aResumo[_CDebito][2] += aEntradas[nPosCx][2][j][5]       // Cartão de Débito

				   Case Alltrim(aEntradas[nPosCx][2][j][2]) == "R1"
     	                aResumo[_RioCenter][3] += aEntradas[nPosCx][2][j][6]     // Cartão de Crédito

				   Case Alltrim(aEntradas[nPosCx][2][j][2]) == "R2"
     	                aResumo[_GiftCard][3] += aEntradas[nPosCx][2][j][6]      // Gift Card

				   Case Alltrim(aEntradas[nPosCx][2][j][2]) == "R3"
     	                aResumo[_PresCard][3] += aEntradas[nPosCx][2][j][6]      // Cartão Presente

				   Case Alltrim(aEntradas[nPosCx][2][j][2]) == "R4"
     	                aResumo[_Peggy][3] += aEntradas[nPosCx][2][j][6]     // PEGGY - Cartão de Crédito
				EndCase

				//Adicionado por Raphael Neves 08.05.2017
				IF aEntradas[nPosCx][2][j][2] <> 'NCC' //Desconsiderar na venda líquida os valores de bônus
				   aResumo[_VendaLiq][2] += aEntradas[nPosCx][2][j][5]
				Endif

                nTtVen += aEntradas[nPosCx][2][j][5]
	   	    Next

            AddLinha(@nLin)
		    AddLinha(@nLin)

	  	    @nLin,02 PSAY "TOTAL DE VENDAS:"
		    @nLin,50 PSAY Transform(nTtVen, "@E 999,999,999.99")        // Recebimento Fatura em Dinheiro
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Procura se o caixa teve recebimentos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosCx	:=	aScan(aRecebimentos,{|x| AllTrim(x[1]) == AllTrim(aCaixas[i][1])})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso o caixa tenha recebimentos entao imprime³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTipoRec :=	'xx'

		If nPosCx > 0
 		   AddLinha(@nLin)
           nEstornos := 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realiza a impressa de todos os recebimetnos do caixa³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTtPFt := 0
			
			For j := 1  to Len(aRecebimentos[nPosCx][2])
   			    If cTipoRec <> Alltrim(aRecebimentos[nPosCx][2][j][4])
			       cTipoRec	:= Alltrim(aRecebimentos[nPosCx][2][j][4])
				   AddLinha(@nLin)
				   
				   If cTipoRec == 'TR'
					  @nLin,02 PSAY "TRANSFERENCIAS | ESTORNOS"
					else
					  @nLin,02 PSAY "RECEBIMENTOS | FATURA"
				   Endif
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Pesquisa a descricao da forma de pgto do pagamento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    AddLinha(@nLin)
			    
				cDescricao := Posicione("SX5",1,xFilial("SX5") + "24" + aRecebimentos[nPosCx][2][j][1],"X5_DESCRI")

		     	@nLin,07 PSAY aRecebimentos[nPosCx][2][j][1] + " - " + cDescricao 				//FORMA E DESCRICAO
				@nLin,50 PSAY Transform(aRecebimentos[nPosCx][2][j][2], "@E 99,999,999.99")  	//VALOR
				@nLin,65 PSAY "(" + StrZero(aRecebimentos[nPosCx][2][j][3],4) + ")"  			//QUANTIDADE

                Do Case 
                   Case aRecebimentos[nPosCx][2][j][1] == "R$"
                        nVlDin += aRecebimentos[nPosCx][2][j][2]
                        
                   Case aRecebimentos[nPosCx][2][j][1] == "CD"
                        nVlDeb += aRecebimentos[nPosCx][2][j][2]

                   Case aRecebimentos[nPosCx][2][j][1] == "CC"
                        nVlCre += aRecebimentos[nPosCx][2][j][2]

                   Case aRecebimentos[nPosCx][2][j][1] == "CH"
                        nVlChq += aRecebimentos[nPosCx][2][j][2]
                End Case

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Soma ao total de entradas e tambem soma a quantidade de recebimentos ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nTtPFt    += aRecebimentos[nPosCx][2][j][2]
				nEntradas += aRecebimentos[nPosCx][2][j][2]
				nQtdReceb += aRecebimentos[nPosCx][2][j][3]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Adiciona o valor no array de resumo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cTipoRec <> 'TR'
				   If aRecebimentos[nPosCx][2][j][1] == 'R$'
//					  aResumo[_Dinheiro][2] += aRecebimentos[nPosCx][2][j][2]                 //DINHEIRO
					  aResumo[_PgCtDin][2] += aRecebimentos[nPosCx][2][j][2]                  // Dinheiro pagamento de Conta
               		
               		elseIf aRecebimentos[nPosCx][2][j][1] == 'CD'
//					       aResumo[_CDebito][2] += aRecebimentos[nPosCx][2][j][2]             //CARTAO DE DÉBITOO
					       aResumo[_PgCtDeb][2] += aRecebimentos[nPosCx][2][j][2]             // Cartão de Débito pagamento de Conta

               		elseIf aRecebimentos[nPosCx][2][j][1] == 'CC'
//					       aResumo[_CDebito][2] += aRecebimentos[nPosCx][2][j][2]             //CARTAO DE CREDITO
					       aResumo[_PgCtCre][2] += aRecebimentos[nPosCx][2][j][2]             // Cartão de Credito pagamento de Conta
				   Endif

				   aResumo[_PagConta][2] += aRecebimentos[nPosCx][2][j][2]
				 else
				    Do Case
					   Case aRecebimentos[nPosCx][2][j][1] == 'R$'
						    nEstornos += aRecebimentos[nPosCx][2][j][2]
					
					   Case aRecebimentos[nPosCx][2][j][1] == "R1"
						    aResumo[_RioCenter][2] -= aRecebimentos[nPosCx][2][j][2]

 					   Case aRecebimentos[nPosCx][2][j][1] == "R2"
						    aResumo[_GiftCard][2] -= aRecebimentos[nPosCx][2][j][2]

					   Case aRecebimentos[nPosCx][2][j][1] == "R3"
						    aResumo[_PresCard][2] -= aRecebimentos[nPosCx][2][j][2]
   				   
					   Case aRecebimentos[nPosCx][2][j][1] == "R4"
						    aResumo[_Peggy][2] -= aRecebimentos[nPosCx][2][j][2]
					EndCase
				Endif
			Next
			
		   // --- Imprimir totais Recebimento | Fatura
		   // ----------------------------------------
            If nVlDin > 0
		       AddLinha(@nLin)
		       AddLinha(@nLin)

	  	       @nLin,02 PSAY "TOTAL EM DINHEIRO:"
		       @nLin,50 PSAY Transform(nVlDin, "@E 999,999,999.99")        // Recebimento Fatura em Dinheiro
		    EndIf   
 
            If nVlDeb > 0
		       If nVlDin == 0 
		          AddLinha(@nLin)
		       EndIf
		          
		       AddLinha(@nLin)

	  	       @nLin,02 PSAY "TOTAL EM DÈBITO:"
		       @nLin,50 PSAY Transform(nVlDeb, "@E 999,999,999.99")        // Recebimento Fatura em Débito
		    EndIf   

            If nVlCre > 0
		       If (nVlDin == 0) .and. (nVlDeb == 0) 
		          AddLinha(@nLin)
		       EndIf
		          
		       AddLinha(@nLin)

	  	       @nLin,02 PSAY "TOTAL EM CREDITO:"
		       @nLin,50 PSAY Transform(nVlCre, "@E 999,999,999.99")        // Recebimento Fatura em Crédito
		    EndIf   

            If nVlChq > 0
		       If nVlDin == 0 .and. nVlDeb == 0 .and. nVlCre == 0
		          AddLinha(@nLin)
		       EndIf
		          
		       AddLinha(@nLin)

	  	       @nLin,02 PSAY "TOTAL EM CHEQUE:"
		       @nLin,50 PSAY Transform(nVlChq, "@E 999,999,999.99")        // Recebimento Fatura em Débito
		    EndIf   

  	        AddLinha(@nLin)
		    AddLinha(@nLin)

	  	    @nLin,02 PSAY "TOTAL PAGTO FATURA:"
		    @nLin,50 PSAY Transform(nTtPFt, "@E 999,999,999.99")          // Total Pagamento de Fatura
		   // ----------------------------------------	
      Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o total de entradas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AddLinha(@nLin)
		AddLinha(@nLin)

	  	@nLin,02 PSAY "TOTAL DE ENTRADAS:"
		@nLin,50 PSAY Transform(nEntradas, "@E 999,999,999.99")        //VALOR DE ENTRADAS
		@nLin,65 PSAY "(" + StrZero(nQtdEntradas + nQtdReceb,6) + ")" //QTD DE ENTRADAS + QTD DE RECEBIMENTOS
		AddLinha(@nLin)
	  	@nLin,00 PSAY Replicate("-",limite)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa no array de saidas se teve saida para o caixa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosCx	:=	aScan(aSaidas,{|x| x[1] == aCaixas[i][1]})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso tenha saida imprime a saida de caixa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPosCx > 0
		    AddLinha(@nLin)
		    @nLin,35 PSAY " SANGRIAS "
		    AddLinha(@nLin)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Procura a posicao do caixa no array de saldos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosCxSal := aScan(aSaldos,{|x| x[1] == aCaixas[i][1]})

		   // --- Faz a impressao de todas as saidas de caixa
		   // -----------------------------------------------
			For j := 1  to Len(aSaidas[nPosCx][2])
			    AddLinha(@nLin)

			   // --- Pega a descricao da forma de pgto
			   // -------------------------------------
                cDescricao := Posicione("SX5",1,xFilial("SX5") + "24" + aSaidas[nPosCx][2][j][1],"X5_DESCRI")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Adiciona no array de resumo a sangria em dinheiro³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    	If aSaidas[nPosCx][2][j][1] == 'R$'
					aResumo[_Sangria][2]	+= aSaidas[nPosCx][2][j][2]
//					aSaidas[nPosCx][2][j][2] -= nEstornos
		    	Endif

		    	@nLin,02 PSAY aSaidas[nPosCx][2][j][1] + " - " + cDescricao              // FORMA DE PGTO
				@nLin,50 PSAY Transform(aSaidas[nPosCx][2][j][2], "@E 999,999,999.99")   // VALOR
				@nLin,65 PSAY "(" + StrZero(aSaidas[nPosCx][2][j][3], 4) + ")"			 // QUANTIDADE

		    	nSaidas 	+= aSaidas[nPosCx][2][j][2]
	    	   	nQtdSaidas	+= aSaidas[nPosCx][2][j][3]

				// --- Adiciona no array de resumo os valores cartao RC
				// ----------------------------------------------------
		   	    If aSaidas[nPosCx][2][j][1] == "R1"
				   aResumo[_RioCenter][2] += aSaidas[nPosCx][2][j][2]

				 elseIf aSaidas[nPosCx][2][j][1] == "R2"
				        aResumo[_GiftCard][2] += aSaidas[nPosCx][2][j][2]
				
				   elseIf aSaidas[nPosCx][2][j][1] == "R3"
				          aResumo[_PresCard][2] += aSaidas[nPosCx][2][j][2]

 				    elseIf aSaidas[nPosCx][2][j][1] == "R4"
				           aResumo[_Peggy][2] += aSaidas[nPosCx][2][j][2]
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se tem saidas para o caixa, se tiver, procura a posicao dessa forma de pgto³
				//³no array para coloar o valor de saida(sangria) para essa forma de pgto              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If nPosCxSal > 0
			       nPosForma := aScan(aSaldos[nPosCxSal][2],{|x| Alltrim(x[1]) == Alltrim(aSaidas[nPosCx][2][j][1])})

			       If nPosForma > 0
				      aSaldos[nPosCxSal][2][nPosForma][3] := aSaidas[nPosCx][2][j][2]
	   		       Endif
			    Endif
		    Next
        Endif

	   // --- Imprime o total de saida
	   // ----------------------------
	    AddLinha(@nLin)
	    AddLinha(@nLin)

	  	@nLin,02 PSAY "TOTAL DE SAIDAS: "
		@nLin,50 PSAY Transform(nSaidas, "@E 999,999,999.99")     // VALOR DE SAIDAS
		@nLin,65 PSAY "(" + StrZero(nQtdSaidas, 6) + ")"          // QUANTIDADE DE SAIDAS

	    AddLinha(@nLin)

	  	@nLin,00 PSAY Replicate("-",limite)

	   // --- Procura a posição do caixa no array de saldos
	   // -------------------------------------------------
		nPosCx	:=	aScan(aSaldos,{|x| x[1] == aCaixas[i][1]})

	   // --- Caso tenha sados imprime os saldos do caixa
	   // -----------------------------------------------
		If nPosCx > 0
		   AddLinha(@nLin)

		   @nLin,25 PSAY " RESUMO DE ENCERRAMENTO DE CAIXAS "
		   AddLinha(@nLin)
		  
		  // --- Faz a impressão de todas as saidas de caixa
		  // -----------------------------------------------
		   For j := 1  to Len(aSaldos[nPosCx][2])
			   AddLinha(@nLin)

			  // --- Pega a descricao da forma de pgto
			  // -------------------------------------
			   cDescricao := Posicione("SX5",1,xFilial("SX5") + "24" + aSaldos[nPosCx][2][j][1],"X5_DESCRI")

			  // --- Calcula o valor do saldo diminiuindo a posicao 2 menos a 3 do array de saldos
              // ---------------------------------------------------------------------------------
               If Alltrim(aSaldos[nPosCx][2][j][1]) == "R$"
                  nSaldo := aSaldos[nPosCx][2][j][3] - (aSaldos[nPosCx][2][j][2] + aResumo[_Inicial][2]) 
                else  
    		      nSaldo := aSaldos[nPosCx][2][j][2] - aSaldos[nPosCx][2][j][3]
 	    	   EndIf
 	    		   
		       @nLin,12 PSAY Alltrim(aSaldos[nPosCx][2][j][1]) + " - " + cDescricao       // FORMA DE PGTO
			   @nLin,50 PSAY Transform(nSaldo, "@E 999,999,999.99")			              // VALOR
			   
			   nSaldoTotal	+=	nSaldo

			  // --- Adiciona no array de resumo os valores cartão RC 
			  // ----------------------------------------------------
		   	   If Alltrim(aSaldos[nPosCx][2][j][1]) == "R1"
		          aResumo[_RioCenter][2] += nSaldo

		   	    elseIf Alltrim(aSaldos[nPosCx][2][j][1]) == "R2"
		               aResumo[_GiftCard][2] += nSaldo

		   	      elseIf Alltrim(aSaldos[nPosCx][2][j][1]) == "R3"
		                 aResumo[_PresCard][2] += nSaldo

 		   	       elseIf Alltrim(aSaldos[nPosCx][2][j][1]) == "R4"
		                  aResumo[_Peggy][2] += nSaldo
		   	   Endif
		   Next
        Endif

	   // --- Imprime o total de saldo
	   // ----------------------------
	    AddLinha(@nLin)
	    AddLinha(@nLin)

	  	@nLin,12 PSAY "SALDO TOTAL: "
		@nLin,50 PSAY Transform(nSaldoTotal, "@E 999,999,999.99")    // VALOR FINAL DO SALDO

	    AddLinha(@nLin)

	  	@nLin,00 PSAY Replicate("-",limite)

	    AddLinha(@nLin)


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz os calculos para alimentar o array de resumos para depois realizar³
		//³a impressao dos valores totais do resumo                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tira os estornos da Sangria³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_Sangria][2] -=	nEstornos
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valor Final no resumo e' o valor de entrada em dinheiro menos a sangria³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	  	aResumo[_VlrFinal][2] := aResumo[_Dinheiro][2] - aResumo[_Sangria][2]
	  	aResumo[_VlrFinal][2] := aResumo[_Sangria][2] - (aResumo[_Dinheiro][2] + aResumo[_Inicial][2])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama funcao para ver o valor e qtd de cuponscancelados para colocar no resumo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAux	:= CupomCancel(aCaixas[i][1],'A')
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Coloca no resumo o valor e a quantidade de itens cancelados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_CupomCan][2]	:= aAux[1]
		aResumo[_CupomCan][3]	:= aAux[2]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama funcao para ver o valor e qtd de itens cancelados para colocar no resumo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAux	:= CupomCancel(aCaixas[i][1],'I')
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Coloca no resumo o valor e a quantidade de itens cancelados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_ItensCan][2]	:= aAux[1]
		aResumo[_ItensCan][3]	:= aAux[2]


		aAux	:=	CartaoPresente(aCaixas[i][1])
		aResumo[_CartaoR4][2]	:= aAux[1]
		aResumo[_CartaoR4][3]	:= aAux[2]


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama a funcao para verificar o total de abatimentos e a quantidade de abatimentos dados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAux	:=	Abatimentos(aCaixas[i][1])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Coloca no array de resumo o valor e quantidade de abatimentos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_Abatimentos][2]	:= aAux[1] - aResumo[_CartaoR4][2]
		aResumo[_Abatimentos][3]	:= aAux[2]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama funcao que verificara o valor das trocas e quantidade³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAux :=	Trocas(aCaixas[i][1])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Coloca no resumo o valor e a quantidade de trocas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_Trocas][2]	:= aAux[1]
		aResumo[_Trocas][3] := aAux[2]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma as trocas, pgtos de contas e venda liquida e coloca no resumo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_Movimenta][2] := aResumo[_VendaLiq][2] + aResumo[_PagConta][2] + aResumo[_Trocas][2] + aResumo[_Bonus][2]
		aResumo[_Movimenta][3] := aResumo[_VendaLiq][3] + aResumo[_PagConta][3] + aResumo[_Trocas][3] + aResumo[_Bonus][3]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Coloca as quantidades de pgto de conta e venda liquida³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_PagConta][3] := nQtdReceb
		aResumo[_VendaLiq][3] := nQtdEntradas

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma a venda liquida e as trocas e coloca no resumo como venda bruta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aResumo[_VendaBruta][2] := aResumo[_VendaLiq][2] + aResumo[_Trocas][2] + aResumo[_Bonus][2]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula a media de venda dividindo o valor de venda liquida pela qtd de venda liq + qtd de trocas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  		aResumo[_MediaVenda][2]	:= aResumo[_VendaLiq][2] / (aResumo[_VendaLiq][3] + aResumo[_Trocas][3] + aResumo[_Bonus][2])

		If lGeral
		   aAux	                  := CancelRet()
	       aResumo[_CancelRet][2] := aAux[1]
	       aResumo[_CancelRet][3] := aAux[2]
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a impressao do resumo do caixa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  	@nLin,35 PSAY " RESUMO "

	  	For j := 1 to Len(aResumo)
		    AddLinha(@nLin)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se for '-' pula pois foi colocado apenas para esse fim, pular a linha³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	     	If aResumo[j][1] == '-'
				loop
			Endif

	    	@nLin,12 PSAY aResumo[j][1]											     //DESCRICAO DO RESUMO
			@nLin,50 PSAY Transform(aResumo[j][2], "@E 999,999,999.99")              //VALOR

			If J == _RioCenter .AND. lGeral
				@nLin,71 PSAY Transform(aResumo[j][2]/aResumo[j][3], "@E 9,999.99")  //VALOR
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso o resumo tenha quantidade entao imprime³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aResumo[j][3] > 0
				@nLin,66 PSAY "(" + StrZero(aResumo[j][3], 5) + ")"
			Endif

			If j == _CCredito .AND. lGeral
				nPosCart	:=	aScan(aCartoes,{|x| x[1] == 'CC'})
				If nPosCart <> 0
					For nX := 1 to Len(aCartoes[nPosCart][2])
		                AddLinha(@nLin)
	                    SAE->(DbSetOrder(1))
						SAE->(DbSeek(xFilial('SAE') + aCartoes[nPosCart][2][nX][1]))
    				   	@nLin,14 PSAY SAE->AE_DESC
						@nLin,50 PSAY Transform(aCartoes[nPosCart][2][nX][2], "@E 999,999,999.99")  //VALOR
						@nLin,64 PSAY "(" + StrZero(aCartoes[nPosCart][2][nX][3],5) + ")"  //VALOR
						@nLin,71 PSAY Transform(aCartoes[nPosCart][2][nX][2]/aCartoes[nPosCart][2][nX][3], "@E 9,999.99")  //VALOR
					Next
				Endif
			Endif

			If j == _CDebito .AND. lGeral
				nPosCart	:=	aScan(aCartoes,{|x| x[1] == 'CD'})
				If nPosCart <> 0
					For nX := 1 to Len(aCartoes[nPosCart][2])
					    AddLinha(@nLin)
	                    SAE->(DbSetOrder(1))
						SAE->(DbSeek(xFilial('SAE') + aCartoes[nPosCart][2][nX][1]))
				     	@nLin,14 PSAY SAE->AE_DESC
						@nLin,50 PSAY Transform(aCartoes[nPosCart][2][nX][2], "@E 999,999,999.99")  //VALOR
						@nLin,64 PSAY "(" + StrZero(aCartoes[nPosCart][2][nX][3],5) + ")" //VALOR
						@nLin,71 PSAY Transform(aCartoes[nPosCart][2][nX][2] / aCartoes[nPosCart][2][nX][3], "@E 9,999.99")

					Next
				Endif
			Endif

	  	Next

	   AddLinha(@nLin)
	  	@nLin,00 PSAY Replicate("-",limite)

	Next

   If lGeral
		LstCaixas()
		lImprimiu := .F.

		For nI := 1 To Len(aCaixas)
			nValor := SldInicial(aCaixas[nI][1], MV_PAR04, .T.)
			If nValor > 0 .OR. TemTitulos(aCaixas[nI][1])
				If ! lImprimiu
					@nLin,00 PSAY Replicate("-",limite)
				   AddLinha(@nLin)
					@nLin,05 PSAY 'CAIXAS EM ABERTO - Os seguintes caixas faltam realizar sangrias '
				   AddLinha(@nLin)
				  	@nLin,00 PSAY Replicate("-",limite)
					lImprimiu := .T.
				Endif

			   AddLinha(@nLin)
			  	@nLin,05 PSAY aCaixas[nI][1] + " " + aCaixas[nI][2]

			Endif
		Next
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function LstCaixas()
	Local cQuery
	aCaixas	:= {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciona os caixas(bancos) informados nos parametros³
	//³e coloca no arrau de caixas para impressao.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery	:= " SELECT * FROM " + RetSqlName("SA6") + " SA6 "
	cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND A6_COD BETWEEN 'C02' AND 'ZZZ' "
	cQuery	+= " AND A6_FILIAL BETWEEN '" + left(MV_PAR05,2) + "' AND '" + left(MV_PAR06,2) + "' "
	cQuery	+= " AND A6_COD NOT IN (" + cExcluiCxs + ") "

	If Select('QRYSA6') > 0
		QRYSA6->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYSA6'

	MemoWrit("c:\Query_QRYSA6",cQuery)

	While QRYSA6->(!Eof())
		aAdd(aCaixas,{QRYSA6->A6_COD, QRYSA6->A6_NOME})
		QRYSA6->(DbSkip())
	Enddo

Return


Static Function TemTitulos(cBanco)
	Local cQuery
   Local lRet
	Local cTipos := SuperGetMv("MS_SE1FORA", .F., "'NCC'")
    
	//cTipos	:= u_StrQryIn(cTipos,',')

	cQuery	:= " SELECT * FROM " + RetSqlName('SE1') + " SE1 "
	cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND E1_PORTADO = '" + cBanco + "' "
	cQuery	+= " AND E1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery 	+= " AND E1_TIPO NOT IN (" + cTipos + ") "

	If Select('QRYSE1') > 0
		QRYSE1->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYSE1'

	If QRYSE1->(!Eof())
		lRet := .T.
	Else
		lRet := .F.
	Endif

Return lRet


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³SldInicialºAutor  ³SIDNEY SALES        º Data ³  17/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Retorno o saldo do dia anterior, antes da data atual.       º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function SldInicial(cCaixa,dData,lFinal)

	Local cQuery
	Local nRet		:= 0
	Default lFinal := .F.

/*	cQuery	:= " SELECT TOP 1 E8_SALATUA AS TOTAL "
	cQuery	+= " FROM " + RetSqlName('SE8') + " SE8 "
	cQuery	+= " WHERE "

	If lFinal
		cQuery	+= " E8_DTSALAT <= '" + DtoS(dData) + "' "
	Else
		cQuery	+= " E8_DTSALAT < '" + DtoS(dData) + "' "
	EndIf

	cQUery	+= " AND E8_AGENCIA = '.    ' "
	cQuery	+= " AND E8_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND E8_CONTA = '.          ' "

	If !lGeral
		cQuery	+= " AND E8_BANCO = '" + cCaixa + "' "
	Else
		cQuery	+= " AND E8_BANCO = 'C01' "
	Endif

	cQuery	+= " ORDER BY E8_DTSALAT DESC "

	If Select('QRYSAL') > 0
		QRYSAL->(DbCloseArea())
	Endif
*/

    cQuery := " Select Sum(SE5.E5_VALOR) as TOTAL from " + RetSqlName("SE5") + " SE5"
    cQuery += "   where SE5.D_E_L_E_T_ = ' '"
	cQuery += "     and SE5.E5_DATA = '" + DtoS(dData) + "'"
	cQuery += "     and SE5.E5_FILIAL between '" + MV_PAR05 + "' and '" + MV_PAR06 + "' "

	If ! lGeral
		cQuery += " and SE5.E5_BANCO = '" + cCaixa + "'"
	 else
		cQuery += " and Substring(SE5.E5_BANCO,1,2) <> 'CG'"
	EndIf
	
	cQuery += " AND SE5.E5_MOEDA NOT IN ('TB') " //para não trazer troco
    cQuery += " and SE5.E5_TIPODOC = 'TR'"
	cQuery += " and SE5.E5_RECPAG  = 'R'"
	
	TcQuery cQuery New Alias 'QRYSAL'
	MemoWrit("c:\Query_QRYSAL",cQuery)

	If QRYSAL->(!Eof())
		nRet := QRYSAL->TOTAL
	Endif
	
	QRYSAL->(dbCloseArea())
Return nRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³Entradas  ºAutor  ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Monta o array com todas as entradas separando por caixa de  º±±
//±±º          ³acordo com os parametros informados.                        º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Entradas()
  Local cQuery    := ""
  Local nPosOpe   := 0
  Local nPosForma := 0

 // --- LISTA AS FORMAS DE PGTOS AGRUPADAS POR CAIXA E FORMA
 // --------------------------------------------------------
 // --- Faz o tratamento para que se for caixa geral somar todos os caixas
 // --- então muda em alguns pontos na query para nao separar por caixa.
 // ----------------------------------------------------------------------
  cQuery :=	"Select L4_NUM, L4_FORMA, L4_ADMINIS, COUNT(*) AS PARCELAS, SUM(L4_VALOR) AS TOTAL, L4_AUTORIZ "

  If ! lGeral
	 cQuery	+= " ,L1_OPERADO "
  Endif

  cQuery += "  From " + RetSqlName("SL4") + " SL4 "
  cQuery += "  Inner Join " + RetSqlName("SL1") + " SL1"
  cQuery += "          on L1_FILIAL + L1_NUM = L4_FILIAL + L4_NUM "

  If ! lGeral
	 cQuery	+= " and L1_OPERADO between '" + MV_PAR01 + "' and '" + MV_PAR02 + "' "
  Endif

  cQuery += "  and L1_EMISSAO between '" + DtoS(MV_PAR03) + "' and '" + DtoS(MV_PAR04) + "' "
  cQuery += "  and SL4.D_E_L_E_T_ <> '*'"
  cQuery += "  and SL1.D_E_L_E_T_ <> '*'"
  cQuery += "  and L1_DOC         <> ' '"
  cQuery += "  and L1_SERIE       <> ' '"
  cQuery += "  and L1_SITUA        = 'OK'"
  cQuery += "  and L1_STORC       <> 'C'"
  cQuery += "  and L1_FILIAL between '" + MV_PAR05 + "' and '" + MV_PAR06 + "' "
  cQuery += "  and L4_FILIAL between '" + MV_PAR05 + "' and '" + MV_PAR06 + "' "
  cQuery += " Group by L4_NUM,L4_FORMA, L4_ADMINIS, L4_AUTORIZ, L4_FILIAL"

  If ! lGeral
  	 cQuery += ", L1_OPERADO "
	 cQuery += " Order by L1_OPERADO, L4_ADMINIS, PARCELAS "
   else
     cQuery += " Order by L4_ADMINIS, PARCELAS"		
  Endif

  If Select("QRYENT") > 0
     QRYENT->(DbCloseArea())
  Endif

  TcQuery cQuery New Alias "QRYENT"

//  MemoWrit("c:\Query_QRYENT",cQuery)

 // --- Percorre todas as formas de pagamento, tive que agrupar por venda,
 // --- para saber quantas parcelas de cada forma de pagamento foi realizada.
 // -------------------------------------------------------------------------
  While QRYENT->(!Eof())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for relatorio de todos os caixas entao grava operador como geral³
		//³para assim somar em um unico lugar todos os caixas se nao coloca   ³
		//³o numero do caixa mesmo.                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lGeral
		   cOperador :=	"GERAL"
		 else
		   cOperador :=	QRYENT->L1_OPERADO
		EndIf

		nPosOpe	:=	aScan(aEntradas,{|x| x[1] == cOperador})

	   // --- Se a forma de pagamento for cheque então o indice sera so cheque
	   // --- se não, sera forma+administradora+parcelas.
	   // --------------------------------------------------------------------
		cIndice := QRYENT->L4_FORMA + QRYENT->L4_ADMINIS + cValToChar(QRYENT->PARCELAS)

		If Alltrim(QRYENT->L4_FORMA) == "CH"
		   cIndice := "CH"
		EndIf

	   // --- Verifica se é cartão de crédito ou débito para imprimir
	   // --- a administrador financeira.
	   // ------------------------------------------------------------
		If Alltrim(QRYENT->L4_FORMA) $ "CC,CD"
			cAdministradora := Upper(QRYENT->L4_ADMINIS)

			nPosCart	:=	aScan(aCartoes,{|x| x[1] == Alltrim(QRYENT->L4_FORMA)})

			If nPosCart	== 0
				aAdd(aCartoes, {Alltrim(QRYENT->L4_FORMA),{{Left(QRYENT->L4_ADMINIS,3), QRYENT->TOTAL,1 }}})
   		     else
				nPosAdm := aScan(aCartoes[nPosCart][2],{|x| Alltrim(x[1]) == Left(QRYENT->L4_ADMINIS,3)})
              
                If nPosAdm <> 0
					aCartoes[nPosCart][2][nPosAdm][2] += QRYENT->TOTAL
					aCartoes[nPosCart][2][nPosAdm][3] += 1
                 else
            	    aAdd(aCartoes[nPosCart][2], {Left(QRYENT->L4_ADMINIS,3), QRYENT->TOTAL,1})
                EndIf
			EndIf

		  Else
			cAdministradora := Space(Len(QRYENT->L4_ADMINIS))
   	    EndIf

		cParcelas := StrZero(QRYENT->PARCELAS,2)

	   // --- Caso nao tenha achado operador então, inclui pois é um novo caixa
	   // ----------------------------------------------------------------------
		If nPosOpe == 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona na posicao 1 o caixa e a forma de pagamento na posicao 2 sendo um array³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aEntradas, {cOperador,{{cIndice, QRYENT->L4_FORMA, cAdministradora, cParcelas, QRYENT->TOTAL,1,0}}})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona um totalizador so com a forma de pgto sem contar com parcela e administradora³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aSaldos,   {cOperador,{{QRYENT->L4_FORMA, QRYENT->TOTAL,0}}})
		 else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso ja exista o operador entao procura se no operado ja existe esse indice,³
			//³isso servira para somar as formas de pagamento iguais                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosForma := aScan(aEntradas[nPosOpe][2],{|x| Alltrim(x[1]) == cIndice})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Entao caso nao ache inclui, caso ache soma ao valor total³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nPosForma == 0
				aAdd(aEntradas[nPosOpe][2], {cIndice, QRYENT->L4_FORMA, cAdministradora, cParcelas, QRYENT->TOTAL,1,0 })
   		     else
				aEntradas[nPosOpe][2][nPosForma][5] += QRYENT->TOTAL
				aEntradas[nPosOpe][2][nPosForma][6] += 1
   		    Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
			//³Procura agora a forma de pgto no array de saldos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
			nPosForma := aScan(aSaldos[nPosOpe][2],{|x| Alltrim(x[1]) == Alltrim(QRYENT->L4_FORMA)})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso tenha nao tenha achado entao inclui a nova forma, se nao soma ao total³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nPosForma == 0
			   aAdd(aSaldos[nPosOpe][2], {QRYENT->L4_FORMA, QRYENT->TOTAL,0 })
   		     else
			   aSaldos[nPosOpe][2][nPosForma][2] += QRYENT->TOTAL
   		    EndIf
		EndIf

   	    QRYENT->(DbSkip())
	Enddo

  QRYENT->(dbCloseArea())	
Return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³BONUS     ºAutor  ³SIDNEY SALES        º Data ³  16/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Funcao que retorna o valor de bonus utilizado no periodo    º±±
//±±º          ³informado pelo caixa, o bonus sao ncc utilzadas nas vendas  º±±
//±±º          ³pelo caixa e que nao tenham nota de entrada vinculada.      º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Bonus(cCaixa)
	Local cQuery
  	Local aRet	:= {0,0}

	cQuery	:= " SELECT SUM(E5_VALOR) AS TOTAL, COUNT(*) AS QTD "
	cQuery	+= " FROM " + RetSqlName('SE5') + " SE5 "
	cQuery	+= " LEFT OUTER JOIN " + RetSqlName('SF1')
	cQuery	+= " ON F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA "
	cQuery	+= " = E5_FILORIG + E5_NUMERO + E5_PREFIXO + E5_CLIFOR + E5_LOJA "
	cQuery	+= " WHERE E5_TIPO = 'NCC' AND E5_RECPAG = 'R' "
	cQuery	+= " AND E5_DATA BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery	+= " AND E5_FILORIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "

	If !lGeral
		cQuery	+= " AND E5_BANCO = '" + cCaixa + "' "
	Endif

	cQuery	+= " AND E5_BANCO <> '   '"
	cQuery	+= " AND F1_DOC IS NULL "
	cQuery	+= " AND SE5.D_E_L_E_T_ <> '*' "

	If Select('QRYBON')  > 0
		QRYBON->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYBON'
	MemoWrit("c:\Query_QRYBON",cQuery)
	If QRYBON->(!Eof())
		aRet := {QRYBON->TOTAL, QRYBON->QTD}
	Endif

Return aRet


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³Recebimentos      ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Monta o array com os valores de recebimento, nesse caso serao±±
//±±º          ³os valores de pgto de fatura e acordo recebidos pelos caixasº±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Recebimentos()
  Local cQuery   := ""
  Local nPos     := 0
  Local nPosOper := 0
  Local aLanctos := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³LISTA PAGAMENTOS DE FATURA(RECEBIMENTOS)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz o tratamento para que se for caixa geral somar todos os caixas³
	//³entao muda em alguns pontos na query para nao separar por caixa   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*	cQuery	:= " SELECT E5_MOEDA, SUM(E5_VALOR) AS TOTAL, COUNT(*) QTD, E5_TIPODOC "

	If ! lGeral
		cQuery	+= " ,E5_BANCO"
	Endif

	cQuery	+= " FROM " + RetSqlName('SE5') + " SE5 "
	cQuery	+= " WHERE SE5.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND E5_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND E5_DATA BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery	+= " AND E5_TIPO NOT IN ('CH','R$','CC','NCC','CR') "
	cQuery	+= " AND E5_TIPODOC NOT IN ('TR') "
	cQuery	+= " AND E5_RECPAG = 'R' "
	cQuery	+=	" AND E5_SITUACA <> 'C' "
	//Adicionado por Raphael Nevs 05.04.2017
	cQuery += " AND E5_MOEDA NOT IN ('TC') " //para não trazer troco

	If ! lGeral
		cQuery	+= " AND E5_BANCO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
		cQuery	+= " GROUP BY E5_BANCO, E5_MOEDA, E5_TIPODOC "
	Else
		cQuery	+= " AND E5_BANCO NOT IN (" + cExcluiCxs + ")"
		cQuery	+= " AND E5_BANCO BETWEEN 'C02' AND 'ZZZ' "
		cQuery	+= " GROUP BY E5_MOEDA, E5_TIPODOC "
   Endif

	cQuery	+= " ORDER BY E5_TIPODOC, E5_MOEDA "*/
 
    cQuery := "Select TMP1.Z4_OPERADO, Count(*) as QTDE, Sum(TMP1.TOTAL) as TOTAL,"
//    cQuery += "       Sum(TMP1.Z4_DINHEIR) as DINHEIRO,  Sum(TMP1.Z4_DEBITO) as DEBITO, Sum(TMP1.Z4_CHEQUE) as CHEQUE"
    cQuery += "       TMP1.Z4_DINHEIR as DINHEIRO, TMP1.Z4_DEBITO as DEBITO, TMP1.Z4_CREDITO as CREDITO, TMP1.Z4_CHEQUE as CHEQUE"
    cQuery += "  from (Select TMP.Z4_OPERADO, TMP.Z4_SEQ, TMP.Z4_CHEQUE, TMP.Z4_DINHEIR, TMP.Z4_DEBITO, TMP.Z4_CREDITO, Sum(a.Z4_VLPAGTO) as TOTAL" 
    cQuery += "        	from (Select Distinct SZ4.Z4_FILIAL, SZ4.Z4_DATA, SZ4.Z4_OPERADO,"
    cQuery += "                       SZ4.Z4_SEQ, SZ4.Z4_CHEQUE, SZ4.Z4_DINHEIR, SZ4.Z4_DEBITO, SZ4.Z4_CREDITO"
    cQuery += "                   from " + RetSqlName("SZ4") + " SZ4" 
    cQuery += "                    Where SZ4.D_E_L_E_T_ = ' '"
    cQuery += "                      and SZ4.Z4_FILIAL between '" + mv_par05 + "' and '" + IIf(Empty(mv_par06),"ZZZZ",mv_par06) + "'"
    cQuery += "                      and SZ4.Z4_DATA between '" + DToS(mv_par03) + "' and '" + DToS(mv_par04) + "'"
    cQuery += "                      and SZ4.Z4_OPERADO between '" + mv_par01 + "' and '" + IIf(Empty(mv_par02),"ZZZ",mv_par02) + "'"
    cQuery += "   		     ) TMP"
    cQuery += "          Left join SZ4010 a" 
    cQuery += "                 on a.D_E_L_E_T_ = ' '"
    cQuery += "       		  and a.Z4_FILIAL  = TMP.Z4_FILIAL"
    cQuery += "       		  and a.Z4_DATA    = TMP.Z4_DATA"
    cQuery += "       		  and a.Z4_OPERADO = TMP.Z4_OPERADO"
    cQuery += "       		  and a.Z4_SEQ     = TMP.Z4_SEQ"
    cQuery += "          Group by TMP.Z4_OPERADO, TMP.Z4_SEQ, TMP.Z4_CHEQUE, TMP.Z4_DINHEIR, TMP.Z4_DEBITO, TMP.Z4_CREDITO) TMP1"
    cQuery += "  Group by TMP1.Z4_OPERADO, TMP1.Z4_SEQ, TMP1.Z4_DINHEIR, TMP1.Z4_DEBITO, TMP1.Z4_CREDITO, TMP1.Z4_CHEQUE"

	If Select("QRYREC") > 0
	   QRYREC->(dbCloseArea())
	Endif

	TcQuery cQuery New Alias "QRYREC"
	
	MemoWrit("c:\Query_QRYREC1",cQuery)

	While ! QRYREC->(Eof())
       // --- Se for caixa geral entao coloca o nome geral para juntar num lugar so
	   // -------------------------------------------------------------------------
		If lGeral
		   cBanco := "GERAL"
		 else
		   cBanco := AllTrim(QRYREC->Z4_OPERADO)
		EndIf

       // --- Dinheiro
	   // ------------
	    If QRYREC->DINHEIRO > 0	
           nPos := aScan(aLanctos,{|x| x[1] == AllTrim(QRYREC->Z4_OPERADO) .and. x[2] == "R$"})
     
           If nPos == 0
//              aAdd(aLanctos, {AllTrim(QRYREC->Z4_OPERADO),"R$",QRYREC->DINHEIRO,QRYREC->QTDE})
              aAdd(aLanctos, {AllTrim(QRYREC->Z4_OPERADO),"R$",QRYREC->DINHEIRO,1})
            else
              aLanctos[nPos][03] += QRYREC->DINHEIRO
              aLanctos[nPos][04]++
//              aLanctos[nPos][04] += QRYREC->QTDE
           EndIf
        EndIf
        
  	   // --- Débito
	   // ----------	
	    If QRYREC->DEBITO > 0
           nPos := aScan(aLanctos,{|x| x[1] == AllTrim(QRYREC->Z4_OPERADO) .and. x[2] == "CD"})
 
           If nPos == 0
//              aAdd(aLanctos, {AllTrim(QRYREC->Z4_OPERADO),"CD",QRYREC->DEBITO,QRYREC->QTDE})
              aAdd(aLanctos, {AllTrim(QRYREC->Z4_OPERADO),"CD",QRYREC->DEBITO,1})
            else
              aLanctos[nPos][03] += QRYREC->DEBITO
              aLanctos[nPos][04]++
//              aLanctos[nPos][04] += QRYREC->QTDE
            EndIf
        EndIf

  	   // --- Credito
	   // ----------	
	    If QRYREC->CREDITO > 0
           nPos := aScan(aLanctos,{|x| x[1] == AllTrim(QRYREC->Z4_OPERADO) .and. x[2] == "CC"})
 
           If nPos == 0
              aAdd(aLanctos, {AllTrim(QRYREC->Z4_OPERADO),"CC",QRYREC->CREDITO,1})
            else
              aLanctos[nPos][03] += QRYREC->CREDITO
              aLanctos[nPos][04]++
//              aLanctos[nPos][04] += QRYREC->QTDE
           EndIf
        EndIf

       // --- Cheque
	   // ----------
	    If QRYREC->CHEQUE > 0 
	       nPos := aScan(aLanctos,{|x| x[1] == AllTrim(QRYREC->Z4_OPERADO) .and. x[2] == "CH"})
	    	
           If nPos == 0
//              aAdd(aLanctos, {AllTrim(QRYREC->Z4_OPERADO),"CH",QRYREC->CHEQUE,QRYREC->QTDE})
              aAdd(aLanctos, {AllTrim(QRYREC->Z4_OPERADO),"CH",QRYREC->CHEQUE,1})
            else
              aLanctos[nPos][03] += QRYREC->CHEQUE
              aLanctos[nPos][04]++
//              aLanctos[nPos][04] += QRYREC->QTDE
           EndIf
        EndIf
        
	   // --- Adiciona um totalizador so com a forma de pgto
	   // --- sem contar com parcela e administradora.
	   // --------------------------------------------------
	    nPosOper :=	aScan(aSaldos,{|x| x[1] == cBanco})
	    
	    If nPosOper > 0
	   	   nPos := aScan(aSaldos[nPosOper][2],{|x| AllTrim(x[1]) == AllTrim("R$")})
	   	   
	   	   If nPos > 0
	   	      aSaldos[nPosOper][2][nPos][2] += QRYREC->DINHEIRO
	   	    else
	   	      aAdd(aSaldos, {cBanco,{{"R$", QRYREC->DINHEIRO,0}}})
	   	   EndIf
	   	   
	   	   nPos := aScan(aSaldos[nPosOper][2],{|x| AllTrim(x[1]) == AllTrim("CD")})
	   	   
	   	   If nPos > 0
	   	      aSaldos[nPosOper][2][nPos][2] += QRYREC->DEBITO
	   	    else
	   	      aAdd(aSaldos, {cBanco,{{"CD", QRYREC->DEBITO,0}}})
	   	   EndIf
	   	       
	   	   nPos := aScan(aSaldos[nPosOper][2],{|x| AllTrim(x[1]) == AllTrim("CC")})
	   	   
	   	   If nPos > 0
	   	      aSaldos[nPosOper][2][nPos][2] += QRYREC->CREDITO
	   	    else
	   	      aAdd(aSaldos, {cBanco,{{"CC", QRYREC->CREDITO,0}}})
	   	   EndIf

	   	   nPos := aScan(aSaldos[nPosOper][2],{|x| AllTrim(x[1]) == AllTrim("CH")})
	   	   
	   	   If nPos > 0
	   	      aSaldos[nPosOper][2][nPos][2] += QRYREC->CHEQUE
	   	    else
	   	      aAdd(aSaldos, {cBanco,{{"CH", QRYREC->CHEQUE,0}}})
	   	   EndIf
         else
           aAdd(aSaldos, {cBanco,{{"R$", QRYREC->DINHEIRO,0}}})
		   aAdd(aSaldos, {cBanco,{{"CD", QRYREC->DEBITO,0}}})
		   aAdd(aSaldos, {cBanco,{{"CC", QRYREC->CREDITO,0}}})
		   aAdd(aSaldos, {cBanco,{{"CH", QRYREC->CHEQUE,0}}})
        EndIf
		
		QRYREC->(DbSkip())
	Enddo
 
   // --- Alimentar a matriz de recebimento
   // -------------------------------------
    For nPos := 1 To Len(aLanctos)
        If Len(aRecebimentos) == 0
           aAdd(aRecebimentos, {IIf(lGeral,"GERAL",aLanctos[nPos][01]),{{aLanctos[nPos][02], aLanctos[nPos][03], aLanctos[nPos][04],''}}})
         else
           aAdd(aRecebimentos[1][2], {aLanctos[nPos][02], aLanctos[nPos][03], aLanctos[nPos][04],''})
        EndIf     
    Next
 
    QRYREC->(dbCloseArea())
    
/*		If lGeral
			cBanco	:=	"GERAL"
		Else
			cBanco	:= QRYREC->E5_BANCO
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Veriifca a posicao do banco no arrau³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos	:=	aScan(aRecebimentos,{|x| x[1] == cBanco})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se achou coloca na posicao do banco, se nao inclui o novo banco³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPos == 0
			aAdd(aRecebimentos, {cBanco,{{QRYREC->E5_MOEDA, QRYREC->TOTAL, QRYREC->QTD, QRYREC->E5_TIPODOC }} })
		Else
			aAdd(aRecebimentos[nPos][2], {QRYREC->E5_MOEDA, QRYREC->TOTAL, QRYREC->QTD, QRYREC->E5_TIPODOC})
		Endif


		nPos	:=	aScan(aSaldos,{|x| x[1] == cBanco})
		If nPos == 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona um totalizador so com a forma de pgto sem contar com parcela e administradora³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aSaldos,   {cBanco,{{QRYREC->E5_MOEDA, QRYREC->TOTAL,0}}})
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
			//³Procura agora a forma de pgto no array de saldos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
			nPosForma := aScan(aSaldos[nPos][2],{|x| Alltrim(x[1]) == Alltrim(QRYREC->E5_MOEDA)})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso tenha nao tenha achado entao inclui a nova forma, se nao soma ao total³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nPosForma == 0
				aAdd(aSaldos[nPos][2], {QRYREC->E5_MOEDA, QRYREC->TOTAL,0 })
			Else
				aSaldos[nPos][2][nPosForma][2] += QRYREC->TOTAL
			Endif
      Endif

		QRYREC->(DbSkip())

	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz novamente a consulta de recebimentoas para listar apenas ³
	//³os pagamentos de fatura realizados em cheque.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery	:= " SELECT "

	If ! lGeral
		cQuery 	+= " E1_YCXORIG,
	Endif

	cQuery	+= " E1_TIPO, SUM(EF_VALOR) AS TOTAL, COUNT(*) AS QTD "
	cQuery	+= " FROM " + RetSqlName('SEF') + " SEF "
	cQuery	+= " INNER JOIN " + RetSqlName('SE1') + " SE1  "
	cQuery	+= " ON EF_FILIAL + EF_PREFIXO + EF_TITULO + EF_PARCELA + EF_TIPO  "
	cQuery	+= "	=  E1_FILIAL + E1_PREFIXO + E1_NUM    + E1_PARCELA + E1_TIPO "

	cQuery	+= "  WHERE EF_ORIGEM = 'RIOA0001' "
	cQuery	+= " AND EF_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND E1_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "

	If ! lGeral
		cQuery	+= " AND E1_YCXORIG BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	Endif

	cQuery	+= "	AND SE1.D_E_L_E_T_ <> '*' AND SEF.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND E1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
   cQuery	+= " GROUP BY E1_TIPO"

	If ! lGeral
	   cQuery 	+= ", E1_YCXORIG "
   Endif

	If Select('QRYREC') > 0
		QRYREC->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYREC'
	MemoWrit("c:\Query_QRYREC2",cQuery)

	While QRYREC->(!Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for caixa geral entao coloca o nome geral para juntar num lugar so³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lGeral
			cBanco	:=	"GERAL"
		Else
			cBanco	:= QRYREC->E1_YCXORIG
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Veriifca a posicao do banco no arrau³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos	:=	aScan(aRecebimentos,{|x| x[1] == cBanco})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se achou coloca na posicao do banco, se nao inclui o novo banco³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPos == 0
			aAdd(aRecebimentos, {cBanco,{{QRYREC->E1_TIPO, QRYREC->TOTAL, QRYREC->QTD, '' }} })
		Else
			aAdd(aRecebimentos[nPos][2], {QRYREC->E1_TIPO, QRYREC->TOTAL, QRYREC->QTD,''})
		Endif


		nPos	:=	aScan(aSaldos,{|x| x[1] == cBanco})
		If nPos == 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona um totalizador so com a forma de pgto sem contar com parcela e administradora³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aSaldos,   {cBanco,{{QRYREC->E1_TIPO, QRYREC->TOTAL,0}}})
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
			//³Procura agora a forma de pgto no array de saldos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
			nPosForma := aScan(aSaldos[nPos][2],{|x| Alltrim(x[1]) == Alltrim(QRYREC->E1_TIPO)})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso tenha nao tenha achado entao inclui a nova forma, se nao soma ao total³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nPosForma == 0
				aAdd(aSaldos[nPos][2], {QRYREC->E1_TIPO, QRYREC->TOTAL,0 })
			Else
				aSaldos[nPos][2][nPosForma][2] += QRYREC->TOTAL
			Endif
      Endif

		QRYREC->(DbSkip())
	Enddo*/
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³Saidas    ºAutor  ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Monta o array com todas as saidas(sangrias) de todos os     º±±
//±±º          ³caixas do intervalo.                                        º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Saidas()
	Local cQuery
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³LISTA SANGRIAS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz o tratamento para que se for caixa geral somar todos os caixas³
	//³entao muda em alguns pontos na query para nao separar por caixa   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery	:= " SELECT E5_MOEDA, SUM(E5_VALOR) AS TOTAL, COUNT(*) QTD "

	If ! lGeral
		cQuery	+= ",E5_BANCO"
	Endif

	cQuery	+= " FROM " + RetSqlName('SE5') + " SE5 "

	cQuery	+= " WHERE SE5.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND E5_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND E5_DATA BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery	+= " AND E5_TIPODOC IN ('SG','TR','TE') AND E5_RECPAG = 'P' "

	//Comentado por Raphael Neves - 08.06.2017 - Solicitação de Verlange
	//cQuery	+= " AND E5_YCODZZS IN ( SELECT ZZS_CODIGO FROM " + RetSqlName('ZZS') + " ZZS "
	//cQuery	+= " WHERE ZZS_FILIAL = E5_FILIAL AND ZZS_CODIGO = E5_YCODZZS AND ZZS_OCXCOD = E5_BANCO"
	//cQuery	+= " AND ZZS.D_E_L_E_T_ <> '*' AND ZZS_STATUS = 'E' )"
	//Adicionado por Raphael Nevs 05.04.2017
	cQuery += " AND E5_MOEDA NOT IN ('TC', 'TB') " //para não trazer troco

	If !lGeral
		cQuery	+= " AND E5_BANCO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	Endif

	cQuery	+= " GROUP BY E5_MOEDA "

	If !lGeral
		cQuery	+= ", E5_BANCO"
	Endif

	If Select("QRYSAI") > 0
		QRYSAI->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias "QRYSAI"

	MemoWrit("c:\Query_QRYSAI",cQuery)
	
	While QRYSAI->(!EOF())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for caixa geral entao coloca o nome geral para juntar num lugar so³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   If lGeral
	   	cBanco := "GERAL"
		Else
			cBanco := QRYSAI->E5_BANCO
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa a posicao do banco no array³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos	:=	aScan(aSaidas,{|x| x[1] == cBanco})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se encontra o banco, se encontrar entao coloca na posicao do banco³
		//³se nao inclui o novo banco                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPos == 0
			aAdd(aSaidas, {cBanco,{{QRYSAI->E5_MOEDA, QRYSAI->TOTAL, QRYSAI->QTD }} })
		Else
			aAdd(aSaidas[nPos][2], {QRYSAI->E5_MOEDA, QRYSAI->TOTAL, QRYSAI->QTD})
		Endif

		QRYSAI->(DbSkip())
	Enddo


Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³Resumo    ºAutor  ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Monta o array com as informacoes que serao impressas no resuº±±
//±±º          ³mo de caixa.                                                º±±
//±±º          ³O array e' formado por descricao, valor total e quantidade  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Resumo()

	aResumo	:= {}

	Aadd(aResumo, {"VALOR INICIAL"		    	,0,0})       // 01     
	Aadd(aResumo, {"DINHEIRO"			    	,0,0})       // 02 
	Aadd(aResumo, {"CARTAO RIO CENTER"	    	,0,0})       // 03
	Aadd(aResumo, {"RIO CENTER VOUCHER"         ,0,0})       // 04
	Aadd(aResumo, {"CARTÃO PRESENTE RIO CENTER"	,0,0})       // 05
	Aadd(aResumo, {"PEGGY"                  	,0,0})       // 06

	Aadd(aResumo, {"CARTÃO DE CRÉDITO"	    	,0,0})       // 07
	Aadd(aResumo, {"CARTÃO DE DÉBITO"	    	,0,0})       // 08

	Aadd(aResumo, {"SANGRIA DE DINHEIRO"    	,0,0})       // 09
	Aadd(aResumo, {"VALOR FINAL"  		    	,0,0})       // 10

	Aadd(aResumo, {"-"					    	,0,0})       // 11

	Aadd(aResumo, {"CUPONS CANCELADOS"	    	,0,0})       // 12
	Aadd(aResumo, {"ITENS CANCELADOS"	    	,0,0})       // 13
	Aadd(aResumo, {"BONUS RIO CENTER"	    	,0,0})       // 14
	Aadd(aResumo, {"ABATIMENTOS"		    	,0,0})       // 15

	If lGeral
		Aadd(aResumo, {"CANC.RETAGUARDA"	,0,0})           // 16
     else
		Aadd(aResumo, {"-"					,0,0})           // 16
    EndIf

	Aadd(aResumo, {"-"						,0,0})           // 17

	Aadd(aResumo, {"MOVIMENTAÇÕES"			,0,0})           // 18

	Aadd(aResumo, {" VENDA BRUTA"			,0,0})           // 19
	Aadd(aResumo, {"  TROCAS"		    	,0,0})           // 20
	Aadd(aResumo, {"  BONUS"                ,0,0})           // 21 - Adicionado por Raphael Neves 08.05.2017
	Aadd(aResumo, {"  VENDA LIQUIDA"		,0,0})           // 22
	Aadd(aResumo, {" PGTO DE CONTA"			,0,0})           // 23

	aAdd(aResumo, {"   DINHEIRO"            ,0,0})           // 24
	aAdd(aResumo, {"   CARTÃO DÉBITO"       ,0,0})	         // 25

	Aadd(aResumo, {"-"						,0,0})           // 26

	Aadd(aResumo, {"MEDIA DE VENDA"			,0,0})           // 27
Return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³CupomCancel       ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Retorna o valor e quantidade total de cuponscancelados pelo º±±
//±±º          ³caixa informado no parametro. Por item ou por total.        º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function CupomCancel(cCaixa,cTipo)

	Local cQuery
	Local aRet		:= {0,0}
	Local nTotal	:= 0
	Local nQtd		:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz a consulta na tabela SLX que e' onde grava as informacoes dos³
	//³itens cancelados                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery	:= " SELECT LX_CUPOM, LX_VALOR FROM " + RetSqlName('SLX') + " SLX "
	cQuery	+= " WHERE SLX.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND LX_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND LX_TPCANC = '"+cTipo+"' "

	If ! lGeral
		cQuery 	+= " AND LX_OPERADO = '" + cCaixa + "' " "
	Endif

	cQuery	+= " AND LX_DTMOVTO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "

	If Select("QRYITE") > 0
		QRYITE->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYITE'
	MemoWrit("c:\Query_QRYITE",cQuery)
	While QRYITE->(!Eof())
		nTotal	+=	QRYITE->LX_VALOR
		nQtd		+= 1
		QRYITE->(DbSkip())
	Enddo

	aRet	:= {nTotal, nQtd}

Return aRet

Static Function CartaoPresente(cCaixa)

	Local cQuery
	Local aRet := {0,0}

/*	cQuery := " SELECT SUM(ZTS_VALOR) TOTAL , COUNT(*) QTD FROM " + RetSqlName("ZTS")
	cQuery += " WHERE D_E_L_E_T_ = ' '  "
	cQuery += " AND ZTS_FILIAL  BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND ZTS_DATA  BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery += " AND ZTS_TIPORC = 'R4' "

	If ! lGeral
		cQuery	+= " AND ZTS_CAIXA = '" + cCaixa +"'"
	Endif

	If Select('QRYR4') > 0
		QRYR4->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYr4'
	MemoWrit("c:\Query_QRYR4",cQuery)
	If QRYR4->(!Eof())
		aRet	:= {QRYR4->TOTAL, QRYR4->QTD}
	Endif*/

Return aRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³AbatimentosAutor  ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Retorna o valor total de abatimentos(descontos) e quantidadeº±±
//±±º          ³de descontos realizados pelo caixa informado no parametro.  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Abatimentos(cCaixa)
   Local cQuery
   Local aRet	:= {0,0}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica na SL1 se tem algum com valor mercadoria seja diferente do liquido³
	//³poir o campo de deconto so e' preenchido no desconto dado no total da venda³
	//³quando da no item ele nao preenche o campo desconto                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery	:= " SELECT SUM(L1_VALMERC - L1_VLRLIQ) AS TOTALDESC, COUNT(*) AS QTD "
	cQuery	+= " FROM " + RetSqlName('SL1') + " SL1 "
	cQuery	+= " WHERE SL1.D_E_L_E_T_ <> '*'  "
	cQuery	+= " AND L1_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND L1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery	+= " AND L1_VALMERC <> L1_VLRLIQ "

	If ! lGeral
		cQuery	+= " AND L1_OPERADO = '" + cCaixa +"'"
   Endif

	If Select('QRYDESC') > 0
		QRYDESC->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYDESC'
	MemoWrit("c:\Query_QRYDESC",cQuery)
	If QRYDESC->(!Eof())
		aRet	:= {QRYDESC->TOTALDESC, QRYDESC->QTD}
	Endif

Return aRet


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³Trocas    ºAutor  ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Soma o valor total de trocas e quantidade de itens trocados.º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Trocas(cCaixa)
	Local cQuery
	Local aRet	:= {0,0}

	cQuery	:= " SELECT SUM(E5_VALOR) AS VLRTOTAL , COUNT(*) AS QTDTOTAL "
	cQuery	+= " FROM " + RetSqlName('SE5') + " SE5 "
	cQuery	+= " INNER JOIN " + RetSqlName('SF1') + " ON F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA "
	cQuery	+= " = E5_FILORIG + E5_NUMERO + E5_PREFIXO + E5_CLIFOR + E5_LOJA "
	cQuery	+= " WHERE E5_TIPO = 'NCC' AND E5_RECPAG = 'R' "
	cQuery	+= " AND E5_FILORIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND E5_DATA BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "

	If !lGeral
		cQuery	+= " AND E5_BANCO = '" + cCaixa + "' "
	Endif

	If Select('QRYTRO') > 0
		QRYTRO->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYTRO'
	MemoWrit("c:\Query_QRYTRO",cQuery)
	If QRYTRO->(!EOF())
		aRet	:= {QRYTRO->VLRTOTAL, QRYTRO->QTDTOTAL}
	Endif

Return aRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³CancelRet ºAutor  ³SIDNEY SALES        º Data ³  17/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Retorna o valor e a quantidade de cancelementos(estornos)   º±±
//±±º          ³Realizados na retaguarda sem considerar os caixas.          º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function CancelRet()
	Local cQuery
	Local aRet	:=	{0,0}

	cQuery	:=	" SELECT SUM(L1_VLRLIQ) AS TOTAL, COUNT(*) AS QTD "
	cQuery	+= " FROM " + RetSqlName('SL1') + " SL1 "
	cQuery	+= " WHERE L1_STATUES <> ' ' "
	cQuery	+= " AND L1_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery	+= " AND L1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery	+= " AND SL1.D_E_L_E_T_ <> '*' "

	If Select('QRYCAN') > 0
		QRYCAN->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYCAN'
	MemoWrit("c:\Query_QRYCAN",cQuery)
	If QRYCAN->(!EOF())
		aRet	:=	{QRYCAN->TOTAL, QRYCAN->QTD}
	Endif

Return aRet



//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³SomaEntra ºAutor  ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Percorre o arry de entrada para calcular o valor total de   º±±
//±±º          ³entrada, isso para calcular o percentual de cada forma ao   º±±
//±±º          ³imprimir cada forma de pagamento.                           º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function SomaEntra(aEntraAtu)
	Local	i
   Local nRet	:= 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Percorreo o array e soma a quantidade total³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i := 1 To Len(aEntraAtu)
		nRet	+= aEntraAtu[i][5]
	Next
Return nRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³AddLinha  ºAutor  ³SIDNEY SALES        º Data ³  12/04/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Funcao criada para adicionar linha no relatorio e imprimir  º±±
//±±º          ³o cabec do relatorio se necessario.                         º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function AddLinha(nLin)

	If nLin > 55
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 8
	Else
		nLin += 1
	Endif

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºFuncao      ³VALIDPERG º Autor ³ Deus sabe!!!       º Data ³      /  /   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao   ³ Cria as perguntas                                          º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºRetorno     ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºParametros  ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function ValidPerg()
	Local aRegs := {}, i, j
	SX1->(dbSetOrder(1))

	// 01 -> X1_GRUPO   02 -> X1_ORDEM    03 -> X1_PERGUNT  04 -> X1_PERSPA  05 -> X1_PERENG
	// 06 -> X1_VARIAVL 07 -> X1_TIPO     08 -> X1_TAMANHO  09 -> X1_DECIMAL 10 -> X1_PRESEL
	// 11 -> X1_GSC     12 -> X1_VALID    13 -> X1_VAR01    14 -> X1_DEF01   15 -> X1_DEFSPA1
	// 16 -> X1_DEFENG1 17 -> X1_CNT01    18 -> X1_VAR02    19 -> X1_DEF02   20 -> X1_DEFSPA2
	// 21 -> X1_DEFENG2 22 -> X1_CNT02    23 -> X1_VAR03    24 -> X1_DEF03   25 -> X1_DEFSPA3
	// 26 -> X1_DEFENG3 27 -> X1_CNT03    28 -> X1_VAR04    29 -> X1_DEF04   30 -> X1_DEFSPA4
	// 31 -> X1_DEFENG4 32 -> X1_CNT04    33 -> X1_VAR05    34 -> X1_DEF05   35 -> X1_DEFSPA5
	// 36 -> X1_DEFENG5 37 -> X1_CNT05    38 -> X1_F3       39 -> X1_GRPSXG

				//01     02    03                  04  05  06        07   08 09  10  11   12  13          14   		15  16  17  18  19   			20  21  22  23  24   				25  26  27  28  29  				30  31  32  33  34  	 			35  36  37  38   	  39
	aAdd(aRegs, {cPerg, "01", "Caixa de: "	, "", "", "mv_ch1", "C", 3, 0, 00, "G", ""			, "mv_par01", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "SA6"		, ""})
	aAdd(aRegs, {cPerg, "02", "Caixa Ate:"	, "", "", "mv_ch2", "C", 3, 0, 00, "G", ""			, "mv_par02", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "SA6"		, ""})
	aAdd(aRegs, {cPerg, "03", "Data de?  "	, "", "", "mv_ch3", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par03", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "04", "Data ate? "	, "", "", "mv_ch4", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par04", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "05", "Filial de?  ", "", "", "mv_ch5", "C", 4, 0, 00, "G", ""			, "mv_par05", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "06", "Filial ate? ", "", "", "mv_ch6", "C", 4, 0, 00, "G", ""			, "mv_par06", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})

	For i := 1 To Len(aRegs)
	    If ! SX1->(dbSeek(cPerg+aRegs[i,2]))
	        SX1->(RecLock("SX1", .T.))
	        For j :=1 to SX1->(FCount())
	            If j <= Len(aRegs[i])
	                SX1->(FieldPut(j,aRegs[i,j]))
	            Endif
	        Next
	        SX1->(MsUnlock())
	    Endif
	next
Return

Static Function VendasNaoProcessadas()
	Local cQuery
//	Local cSituas := u_NyxGetMV("MS_L1SITUA", "'RX','ER'", "Situacoes de erros no processamento de vendas")
	Local cSituas := "'RX','ER'"

	cQuery := " SELECT L1_FILIAL, L1_SITUA, COUNT(*) AS QTD "
	cQuery += " FROM " + RetSqlName('SL1') + " SL1 "
	cQuery += " WHERE SL1.D_E_L_E_T_ <> '*' AND L1_SITUA IN (" + cSituas + ") "
	cQuery += " AND L1_FILIAL  BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND L1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery += " GROUP BY L1_FILIAL, L1_SITUA"
	cQuery += " ORDER BY 1"

	If Select('QRYERR') > 0
		QRYERR->(DbCloseArea())
	EndIf

	TcQuery cQuery New Alias 'QRYERR'

	If QRYERR->(!Eof())
	  	@nLin,02 PSAY "ATENÇÃO! EXISTEM VENDAS NÃO PROCESSADAS OU COM ERRO NO PROCESSAMENTO "
	  	AddLinha(@nLin)
	EndIf

	While QRYERR->(!EOF())
	  	@nLin,02 PSAY 'Filial: ' + QRYERR->L1_FILIAL + ' | Situação: ' + QRYERR->L1_SITUA + ' | Quantidade: ' + StrZero(QRYERR->QTD,5)
	  	AddLinha(@nLin)
		QRYERR->(DBSKIP())
	EndDo

Return
