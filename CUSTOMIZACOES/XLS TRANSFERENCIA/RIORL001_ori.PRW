#Include "rwmake.ch"
#Include "topconn.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ RIORL001 บAutor  ณGLAUDSON MARCEL     บ Data ณ  31/08/21   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณRELATORIO DE TRANSFERENCIA DE ARMAZEM                       บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RIORL001()
  Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2  := "de acordo com os parametros informados pelo usuario."
  Local cDesc3  := "Relat๓rio de Transfer๊ncia entre Armazens"
  Local cPict   := ""
  Local titulo  := "Relat๓rio de Transfer๊ncia entre Armazens"
  Local nLin    := 80
  Local Cabec1  := " C๓digo         Descri็ใo do Produto" + Space(61) + "Nome do Fornecedor                           Ent.          Vend.    %     ML      Estoq.   Custo     R$ Ven.  Mes/Ano"
  Local Cabec2  := ""
  Local imprime := .T.
  Local aOrd    := {}

  Private lEnd        := .F.
  Private lAbortPrint := .F.
  Private CbTxt       := ""
  Private limite      := 220
  Private tamanho     := "G"
  Private nomeprog    := "RIORL001" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo       := 18
  Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey    := 0
  Private cbtxt       := Space(10)
  Private cbcont      := 00
  Private CONTFL      := 01
  Private m_pag       := 01
  Private wnrel       := "RIORL001" // Coloque aqui o nome do arquivo usado para impressao em disco
  Private cString     := "SB1"     
  Private dDataDe 	  := CtoD("01/09/13")
  Private dDataAte	  := CtoD("03/09/13")   
  Private dDtVendAte  := CtoD("03/09/13")
  Private nPercent	  := 0    
  Private cFilDe	  := Space(04)
  Private cFilaAte 	  := "0102"      
  Private cCategDe	  := ""
  Private cCategAte	  := ""
  Private cPerg 	  := "U_RIORL001"        
  Private cTess		  := SuperGetMv("MS_TESENTR",.F.,"'008','009','010','017','030'")    
  Private nLinhas	  := 65
	
//cTess	:= u_StrQryIn(cTess,',')

  dbSelectArea("SB1")
  SB1->(dbSetOrder(1))
             
  ValidPerg()

  If ! (Pergunte(cPerg,.T.))
	 Return
  EndIf

  dDataDe 	 := MV_PAR01
  dDataAte	 := MV_PAR02
  cFilDe	 := MV_PAR03
  cFilAte	 := MV_PAR04   
  dDtVendAte := MV_PAR05
  cFornecDe	 := MV_PAR06
  cFornecAte := MV_PAR07
  cMarcade	 := MV_PAR08
  cMarcaAte	 := MV_PAR09
  cFilEntra	 := MV_PAR10 
  cCategDe   := MV_PAR11  
  cCategAte	 := MV_PAR12
  lQuebra	 := MV_PAR13 == 1  

  titulo += " de " + DtoC(dDataDe) + " a " + DtoC(dDataAte) + " c/ vendas at้ " + DtoC(dDtVendAte)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

  If nLastKey == 27
	 Return
  Endif

  SetDefault(aReturn,cString)

  If nLastKey == 27
     Return
  Endif

  nTipo := If(aReturn[4]==1,15,18)

 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/{Protheus.doc} RIORL001
  Fun็ใo RunReport
  @author Totvs Nordeste
  @owner Totvs S/A
  @sample
// RunReport - Impressใo
   RunReport()
  @history
  02/09/2019 - Desenvolvimento da Rotina.
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
  Local nOrdem    
  Local nX

  dbSelectArea(cString)
  dbSetOrder(1)

  cQuery := "SELECT B4_01CAT1,B4_01CAT2,B4_01CAT3, AY0_DESC, B1_COD, B1_DESC, "
  cQuery += " (SELECT Sum(D1_QUANT) AS QTDENT FROM " + RetSqlName('SD1') + " SD1 "
  cQuery += "	WHERE SD1.D_E_L_E_T_ <> '*' " 
  cQuery += "	AND D1_DTDIGIT BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
  cQuery += " AND D1_TIPO <> 'D' "
  cQuery += " AND D1_COD = B1_COD "
  cQuery += " AND D1_FILIAL = '" + cFilEntra +  "' AND D1_TES IN ("+ cTess + ") ) AS QTDENTRA, "

cQuery += " (SELECT Sum(D2_QUANT) AS QTDDEV FROM " + RetSqlName('SD2') + " SD2 "
cQuery += "	WHERE SD2.D_E_L_E_T_ <> '*' "
cQuery += "	AND D2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
cQuery += " AND D2_TIPO = 'D' "
cQuery += " AND D2_COD = B1_COD "
cQuery += " AND D2_CLIENTE BETWEEN '" + cFornecDe + "' AND '" + cFornecAte + "' "
cQuery += " AND D2_FILIAL = '" + cFilEntra +  "' ) AS QTDDEVOL, "

cQuery += " (SELECT Sum(L2_QUANT) AS QTDVEND FROM " + RetSqlName('SL2') + " SL2 "
cQuery += "	WHERE SL2.D_E_L_E_T_ <> '*' "
cQuery += " AND L2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDtVendAte) + "' "
cQuery += " AND L2_PRODUTO = B1_COD " 
cQuery += " AND L2_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' ) AS QTDSAIDA "  

cQuery += " FROM " 		 + RetSqlName('SB1') + " SB1 "
cQuery += " INNER JOIN " + RetSqlName('SB4') + " SB4 ON B1_FILIAL = B4_FILIAL AND LEFT(B1_CODANT,8) = LEFT(B4_COD,8) "
cQuery += " INNER JOIN " + RetSqlName('AY0') + " AY0 "
cQuery += " ON AY0_FILIAL = B4_FILIAL " 

If Len(Alltrim(cCategDe)) == 2
	cQuery += " AND AY0_CODIGO = B4_01CAT1 "
ElseIf Len(Alltrim(cCategDe)) == 4
	cQuery += " AND AY0_CODIGO = B4_01CAT2 "
ElseIf Len(Alltrim(cCategDe)) == 6
	cQuery += " AND AY0_CODIGO = B4_01CAT3 "
Else
	ApMsgInfo('O c๓digo da Se็ใo s๓ pode ter os tamanhos, 2,4 ou 6. Por favor, ajuste os parโmetros.')
	Return
EndiF

cQuery += " WHERE SB1.D_E_L_E_T_ <> '*' AND SB4.D_E_L_E_T_ <> '*' "
cQuery += " AND B1_01CODMA BETWEEN '" + cMarcaDe + "' AND '" + cMarcaAte + "' "
cQuery += " AND AY0_CODIGO BETWEEN '" + cCategDe + "' AND '" + cCategAte + "' "

cQuery += " AND ( SB1.B1_COD IN ( "
cQuery += "							SELECT D1_COD FROM SD1010 SD1 "
cQuery += "							WHERE SD1.D_E_L_E_T_ <> '*'  AND D1_DTDIGIT BETWEEN '"+ DtoS(dDataDe) +"' AND '" + DtoS(dDataAte) + "' "
cQuery += "                   AND D1_FILIAL = '" + cFilEntra + "' "										
cQuery += "                   AND D1_TIPO <> 'D'  AND D1_TES IN ("+ cTess + " )
cQuery += " 						AND D1_FORNECE BETWEEN '" + cFornecDe + "' AND '" + cFornecAte + "' )"
cQuery += "	) 

                       
If Len(Alltrim(cCategDe)) == 2
	cQuery += "ORDER BY B4_01CAT1, AY0_DESC"
ElseIf Len(Alltrim(cCategDe)) == 4
	cQuery += "ORDER BY B4_01CAT2, AY0_DESC"
ElseIf Len(Alltrim(cCategDe)) == 6
	cQuery += "ORDER BY B4_01CAT3, AY0_DESC"
EndiF


If Select('QRY') > 0
	QRY->(DbCloseArea())
Endif

TcQuery cQuery New Alias 'QRY'

cSecao := ''   
   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTotal de Entradasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotEnt	:= 0
nTotSai	:= 0
nTotEst	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTotal geral de entradasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  nTotGEnt	:= 0
  nTotGSai := 0
  nTotGEst	:= 0    

  nQtdSai  := 0
  nQtdEnt	:= 0      
  aRetFor	:= {}  
  aOrdena	:= {} 

  nTotVlrEn := 0
  nTotVlrVe := 0 
  nTotVlrEs := 0

  nToGVleEn := 0
  nToGVlrVe := 0
  nToGVlrEs := 0

  If lQuebra
	 nLin := 8
  EndIf

  aImprime := {}

  While QRY->(!EOF())                                                                      
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama funcao de quantidade de entradaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nQtdEnt	:= QRY->QTDENTRA - QRY->QTDDEVOL//QtdEntrada(QRY->B1_COD)	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama funcao de quantidade de saidaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nQtdSai	:= QRY->QTDSAIDA//QtdSaida(QRY->B1_COD)    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCalcula o percentual, caso esteja dentro coloca no array para impressaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nPercent := ((nQtdSai / nQtdEnt) * 100) 
      
	If Len(Alltrim(cCategDe)) == 2
		cCodCat := QRY->B4_01CAT1 
	ElseIf Len(Alltrim(cCategDe)) == 4
		cCodCat := QRY->B4_01CAT2 
	ElseIf Len(Alltrim(cCategDe)) == 6
		cCodCat := QRY->B4_01CAT3 
	EndiF

	aAdd(aImprime, {QRY->B1_COD, nQtdEnt, nQtdSai, nPercent, cCodCat, QRY->AY0_DESC, QRY->B1_DESC })

	QRY->(DbSkip())

EndDo

 // --- Gerar planilha em Excel
 // ---------------------------
  If MV_PAR14 == 1
	 fn100Exl(aImprime)
     MsgInfo("Planilha COMPRAS14.xml gerado com sucesso na pasta 'C:\Temp'")
	 Return
  EndIf     
 // ---------------------------

For nY := 1 To Len(aImprime)
    cB1_COD   := aImprime[nY][1]
	nQtdEnt	  := aImprime[nY][2]
	nQtdSai	  := aImprime[nY][3]
	nPercent  := aImprime[nY][4]
	cB4_01CAT := Alltrim(aImprime[nY][5])
	cAY0_DESC := aImprime[nY][6]
	cB1_DESC  := aImprime[nY][7]

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
           
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso mude a secao entao imprime a descricao de secaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cSecao <> Alltrim(cB4_01CAT) + " - " + cAY0_DESC
      If lQuebra .OR. nLin > nLinhas
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
		EndIf
		cSecao := Alltrim(cB4_01CAT) + " - " + cAY0_DESC
		@nLin++,00 PSAY cSecao
		@nLin++,00 PSAY __PrtThinLine() 
		aOrdena := {}
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama funcao que pega os dados do produtoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aDados	:= DadosProd(cB1_COD)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSoma ao total por secaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nTotEnt	+= nQtdEnt
	nTotSai	+= nQtdSai
	nTotEst	+= aDados[2]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSoma ao valor total geralณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nTotGEnt	+= nQtdEnt
	nTotGSai += nQtdSai
	nTotGEst	+= aDados[2]     
	
	aRetFor	:= NomeFornece(cB1_COD)
	
	
	cNomeFor := aRetFor[1]
	dUltim	:= StoD(aRetFor[2])
	nDias 	:= DateDiffDay(dUltim,dDtVendAte) 

	aAdd(aOrdena, {PADR(Alltrim(cB1_COD),14),; 								//CODIGO DO PRODUTO
						cB1_DESC,;														//DESCRICAO
						PADR(cNomeFor,Len(SA2->A2_NOME)),;															//NOME DO FORNECEDOR
						Transform(nQtdEnt, "@e 9999999"),; 							//QUANTIDADE DE ENTRADA
						Transform(nQtdSai, "@e 9999999"),;							//QUANTIDADE DE SAIDAS
						Transform((nQtdSai / nQtdEnt) * 100, "@e 999999"),; 	//PERCENTUAL
						Transform(aDados[1],"@e 999.99"),;							//MARGEM DE LUCRO
						Transform(aDados[2],"@e 9999,999"),;						//ESTOQUE ATUAL
						Transform(aDados[4],"@e 999,999.99"),;						//PRECO DE CUSTO
						Transform(aDados[3],"@e 999,999.99"),;						//PRECO DE VENDA
						StrZero(Month(dUltim),2) + '/' + RIght(cValToChar(Year(dUltim)),2) ,;
						Transform(nDias, "@e 99999") + Transform((nQtdSai / nQtdEnt) * 100, "@e 9999999") + cB1_DESC 	})  								//QTD DIAS ULTIMA COMPRA


   nTotVlrEn += nQtdEnt  	* aDados[4] //pelo custo
   nTotVlrVe += nQtdSai 	* aDados[3] //pela preco de venda
   nTotVlrEs += aDados[2] 	* aDados[4] //pelo custo

   nToGVleEn += nQtdEnt  	* aDados[4] //pelo custo
	nToGVlrVe += nQtdSai 	* aDados[3] //pelo preco de venda
   nToGVlrEs += aDados[2] 	* aDados[4] //pelo custo

	lImpTotal := .F.

	If Len(aImprime) == nY 
		lImpTotal := .T.
	EndIf

	If !lImpTotal
		If cSecao <> Alltrim(aImprime[nY+1][5]) + " - " +  aImprime[nY+1][6]
			lImpTotal := .T.
		EndIf
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe pular a secao ou for o final entao imprime o total da secaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lImpTotal
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณOrdena pelo maior percentualณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ASort(aOrdena,,,{|x,y|x[3] + x[2] < y[3] + y[2]})

//		aOrdena := Reorderna(aOrdena)
	
		For nX := 1 to Len(aOrdena)      

			@nLin++,01 PSAY	aOrdena[nX][1] + Space(1) + ;
									aOrdena[nX][2] + Space(1) + ;
									aOrdena[nX][3] + ;
									aOrdena[nX][4]	+ Space(8) + ;
									aOrdena[nX][5] + Space(1) + ;
									aOrdena[nX][6] + Space(1) + ;
									aOrdena[nX][7] + Space(1) + ;
									aOrdena[nX][8] + Space(1) + ;
									aOrdena[nX][9] + Space(1) + ;
									aOrdena[nX][10]+ Space(3) + ;
									aOrdena[nX][11]

		   If nLin > nLinhas // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
				@nLin++,00 PSAY cSecao + "(continua็ใo)"
				@nLin++,00 PSAY __PrtThinLine() 
		   Endif
		Next


		@nLin++,00 PSAY Replicate("-",limite)

		@nLin++,00 PSAY "Total da Se็ใo - " + cSecao + Space(90 - Len(cB4_01CAT) + 2) +  ;    		
					Transform(nTotEnt, "@e 9999999") + Space(7) + ;
					Transform(nTotSai, "@e 9999999") + Space(1) + ;						
				  	Transform(nTotSai / nTotEnt * 100, "@e 9999999") + Space(8) + ;
					Transform(nTotEst, "@e 9999,999") 

		@nLin++,00 PSAY Space(128) + ;    		
					Transform(nTotVlrEn, "@e 99,999,999,999.99") + Space(1) + ;
					Transform(nTotVlrVe, "@e 99,999,999,999.99") + Space(1) + ;						
				  	Transform(nTotVlrVe / nTotVlrEn * 100, "@e 9999999") + Space(5) + ;
					Transform(nTotVlrEs, "@e 999,999,999.99") 

		nTotVlrEn:= 0
		nTotVlrVe:= 0
		nTotVlrEs:= 0
		nTotEnt	:= 0
		nTotSai	:= 0
		nTotEst	:= 0			
		aOrdena	:= {}
		@nLin++,00 PSAY Replicate("-",limite)
		nLin++
	Endif
Next
	nLin++
	nLin++
	@nLin++,00 PSAY __PrtThinLine()
	@nLin++,00 PSAY "Total Geral   " + Space(129) + ;
					Transform(nTotGEnt, "@e 9999999") + Space(7) + ;
					Transform(nTotGSai, "@e 9999999") + Space(1) + ;						
				  	Transform(nTotGSai / nTotGEnt * 100, "@e 9999999") + Space(8) + ;
					Transform(nTotGEst, "@e 9999,999") 

	@nLin++,00 PSAY "Total Geral(Valor)   " + Space(108) + ;
					Transform(nToGVleEn, "@e 99,999,999,999.99") + Space(1) + ;
					Transform(nToGVlrVe, "@e 99,999,999,999.99") + Space(1) + ;						
				  	Transform(nToGVlrVe / nToGVleEn * 100, "@e 9999999") + Space(5) + ;
					Transform(nToGVlrEs, "@e 999,999,999.99") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return     

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณReoderna  บAutor  ณSIDNEY SALES        บ Data ณ  28/01/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณRealiza a ordenacao do array reordenando por dia.           บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function Reorderna(aOrdena)

	Local aAux 	:= {}
	Local i     := 0
	Local cDias := aOrdena[1][11]   
	Local aRet 	:= {}
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPercorre o array passado por parametro quebrando por dia            ณ
	//ณquando o dia for diferente entao faz a ordenacao e coloca no retornoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   For i := 1 to Len(aOrdena)
		If cDias == aOrdena[i][11]   
			Aadd(aAux, aOrdena[i])
		Else
			ASort(aAux,,,{|x,y|x[6] + x[2] < y[6] + y[2]  })
			For j := 1 to Len(aAux)
				aAdd(aRet,aAux[j])
			Next
			aAux := {} 
			Aadd(aAux, aOrdena[i])
			cDias:= aOrdena[i][11]									
		EndIf		
   Next
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe tiver algo no aAux e' pq ou foi o ultimo ou nao quebrou por diaณ
	//ณpois era o mesmo dia, entao executa a ordenacao e coloca no array ณ
	//ณde retorno                                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ! Empty(aAux)
		ASort(aAux,,,{|x,y|x[6] + x[2] < y[6] + y[2]  })
		For j := 1 to Len(aAux)
			aAdd(aRet,aAux[j])
		Next
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe o array de retorno estiver em branco o final e' o proprio aAuxณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(aRet)
		aRet := aAux
	EndIf

Return aRet
              
Static Function NomeFornece(cCodProd)
	Local cQuery
	Local aRet 	:= {Space(15), DtoS(dDataBase)}

	cQuery := " SELECT TOP 1 SA2.A2_NOME, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT FROM " + RetSqlName('SD1') + " SD1 "
	cQuery += "   INNER JOIN " + RetSqlName('SA2') + " SA2"
	cQuery += "           ON SA2.D_E_L_E_T_ = ' '"
	cQuery += "          and SA2.A2_COD     = SD1.D1_FORNECE"
	cQuery += "          and SA2.A2_LOJA    = SD1.D1_LOJA"
	cQuery += "   WHERE SD1.D_E_L_E_T_ = ' '"
	cQuery += " AND SD1.D1_COD = '" + cCodProd + "' "
	cQuery += " AND SD1.D1_DTDIGIT BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
	cQuery += " AND SD1.D1_TES IN (" + cTess + ")"  
	cQuery += " ORDER BY SD1.D1_DTDIGIT DESC "
	
	If Select("QRYD1") > 0
		QRYD1->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias 'QRYD1'
	
	If QRYD1->(!Eof())
		aRet := {QRYD1->A2_NOME, QRYD1->D1_DTDIGIT}
	Endif

Return aRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ DadosProdบAutor  ณSIDNEY SALES        บ Data ณ  04/09/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณRetorna a quantidade em estoque, o custo, o preco de venda  บฑฑ
//ฑฑบ          ณe a margem de lucro do produto do parametro.                บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function DadosProd(cProd)
   Local aRet := {0,0,0,0}

  cQuery := "SELECT B2_COD, SUM(B2_QATU) as Estoque," 
  cQuery += "       Sum(B2_VATU1) / (Case When Sum(B2_QATU) <= 0 Then 1 else Sum(B2_QATU) end ) as Custo, DA1.DA1_PRCVEN"
  cQuery += "  From " + RetSqlName("SB2") + " SB2"
  cQuery += "   Inner Join " + RetSqlName("DA0") + " DA0"
  cQuery += "           on DA0.D_E_L_E_T_ = ' '"
  cQuery += "          and DA0.DA0_FILIAL = '" + xFilial("DA0") + "'"
  cQuery += "          and (DA0.DA0_DATATE >= '" + DtoS(dDataAte) + "'"
  cQuery += "            or (DA0.DA0_DATDE <= '" + DtoS(dDataAte) + "' and DA0.DA0_DATATE = ''))"
  cQuery += "   Inner Join " + RetSqlName("DA1") + " DA1"
  cQuery += "           on DA1.D_E_L_E_T_ = ' '"
  cQuery += "	       and DA1.DA1_FILIAL = DA0.DA0_FILIAL"
  cQuery += "          and DA1.DA1_CODTAB = DA0.DA0_CODTAB"
  cQuery += "          and DA1.DA1_CODPRO = SB2.B2_COD"
  cQuery += "   Where SB2.D_E_L_E_T_ <> '*'"
  cQuery += "     and SB2.B2_COD = '" + cProd + "'"
  cQuery += "   Group by SB2.B2_COD, DA1.DA1_PRCVEN" 
     
/*
	cQuery := " SELECT B2_COD, SUM(B2_QATU) AS Estoque, "
	cQuery += " Sum(B2_VATU1) / (Case When Sum(B2_QATU) <= 0 Then 1 else Sum(B2_QATU) end ) as Custo, B0_PRV1 "
	cQuery += " FROM " + RetSqlName('SB2') + " SB2 "
	cQuery += " INNER JOIN " + RetSqlName('SB0') + " SB1 ON B0_COD = B2_COD "
	cQuery += " WHERE SB2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += " AND B2_COD = '" + cProd + "'"
	cQuery += " GROUP BY B2_COD, B0_PRV1 "
*/

	If Select("QRYSB2") > 0
		QRYSB2->(DbCloseArea())
	EndIf
   
	TcQuery cQuery New Alias 'QRYSB2'

	If QRYSB2->(!Eof())		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCalcula a margem de lucroณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nML	 := (QRYSB2->DA1_PRCVEN / QRYSB2->Custo) 
		aRet := {nML, QRYSB2->Estoque, QRYSB2->DA1_PRCVEN, QRYSB2->Custo}
	EndIf   
	
Return aRet

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณQtdEntradaบAutor  ณSIDNEY SALES        บ Data ณ  04/09/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณRetorna a quantidade de entrada do produto no periodo infor บฑฑ
//ฑฑบ          ณmado nos parametros.                                        บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function QtdEntrada(cCodProd)

	Local nRet := 0
	Local cQuery

	cQuery := " SELECT Sum(D1_QUANT) AS QTDENT FROM " + RetSqlName('SD1') + " SD1 "
	cQuery += "	WHERE SD1.D_E_L_E_T_ <> '*' "
	cQuery += "	AND D1_DTDIGIT BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
	cQuery += " AND D1_TIPO <> 'D' "
	cQuery += " AND D1_COD = '" + cCodProd + "' "
	cQuery += " AND D1_FILIAL = '" + cFilEntra +  "' AND D1_TES IN ("+ cTess + ")"

	If Select("QRYSD1") > 0
		QRYSD1->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias 'QRYSD1'
			
	If QRYSD1->(!Eof())
		nRet := QRYSD1->QTDENT
	EndIf

Return nRet                     

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณQtdSaida  บAutor  ณSIDNEY SALES        บ Data ณ  04/09/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณRetorna a quantidade de Saidas do produto informado no para-บฑฑ
//ฑฑบ          ณmetro no periodo informado nos parametros.                  บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function QtdSaida(cCodProd)
  Local nRet := 0
  Local cQuery

  cQuery := " SELECT Sum(L2_QUANT) AS QTDVEND FROM " + RetSqlName('SL2') + " SL2 "
  cQuery += "	WHERE SL2.D_E_L_E_T_ <> '*' "
  cQuery += " AND L2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDtVendAte) + "' "
  cQuery += " AND L2_PRODUTO = '" + cCodProd + "' " 
  cQuery += " AND L2_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' "  
	
  If Select('QRYSL2') > 0
     QRYSL2->(DbCloseArea())
  EndIf

  TcQuery cQuery New Alias 'QRYSL2'

  If ! QRYSL2->(Eof())
     nRet := QRYSL2->QTDVEND
  Endif
Return nRet

/*/{Protheus.doc} RIORL001
  Fun็ใo RunReport
  @author TOTVS Nordeste
  @owner TOTVS S/A
  @sample
// fnImpExl - Impressใo
   fnImpExl()
  @history
  02/09/2019 - Desenvolvimento da Rotina.
/*/
Static Function fn100Exl(aImprime)
  Local nId := 0
  Local oFWMsExcel

  oFWMsExcel := FWMSExcel():New()
   
 // ---- Aba 01 - Compras
 // ---------------------
  oFWMsExcel:AddworkSheet("Compras")                   // Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
 
  oFWMsExcel:AddTable("Compras","Analise")             // Criando a Tabela
  oFWMsExcel:AddColumn("Compras","Analise","Codigo"      ,1,1)  // 1 = Modo Texto
  oFWMsExcel:AddColumn("Compras","Analise","Descri็ใo"   ,1,1)  // 1 = Modo Texto
  oFWMsExcel:AddColumn("Compras","Analise","Fornecedor"  ,1,1)  // 1 = Modo Texto
  oFWMsExcel:AddColumn("Compras","Analise","Qtde Entrada",2,2)  // 2 = Valor sem R$ ou 3 = Valor com R$
  oFWMsExcel:AddColumn("Compras","Analise","Qtde Saida"  ,2,2)  // 2 = Valor sem R$ ou 3 = Valor com R$
  oFWMsExcel:AddColumn("Compras","Analise","Percentual"  ,2,2)  // 2 = Valor sem R$ ou 3 = Valor com R$
  oFWMsExcel:AddColumn("Compras","Analise","Margem Lucro",2,2)  // 2 = Valor sem R$ ou 3 = Valor com R$
  oFWMsExcel:AddColumn("Compras","Analise","Estoque"     ,2,2)  // 2 = Valor sem R$ ou 3 = Valor com R$
  oFWMsExcel:AddColumn("Compras","Analise","Custo"       ,2,2)  // 2 = Valor sem R$ ou 3 = Valor com R$
  oFWMsExcel:AddColumn("Compras","Analise","Pre็o"       ,2,2)  // 2 = Valor sem R$ ou 3 = Valor com R$
  oFWMsExcel:AddColumn("Compras","Analise","M๊s/Ano"     ,1,1)  // 1 = Modo Texto
  
 // --- Criando as Linhas
 // ---------------------
  For nId := 1 To Len(aImprime)
	  oFWMsExcel:AddRow("Compras","Analise",{aImprime[nId][01],;
											 aImprime[nId][07],;
											 aImprime[nId][02],;
											 aImprime[nId][03],;
											 aImprime[nId][04],;
											 aImprime[nId][05],;
											 aIMprime[nId][06],;
											 aImprime[nId][07],;
											 aImprime[nId][08],;
											 aImprime[nId][09],;
											 aIMprime[nId][10],;
											 aIMprime[nId][11]})
  Next 

 // --- Ativando o arquivo e gerando o xls
 // --------------------------------------
  oFWMsExcel:Activate()
  oFWMsExcel:GetXMLFile("C:\Temp\Compras14.xml")
   
 // --- Abrindo o excel e abrindo o arquivo xls
 //--------------------------------------------
  oExcel := MsExcel():New()                  // Abre uma nova conexใo com Excel
  
  oExcel:WorkBooks:Open("C:\Temp\Compras14.xml")     // Abre uma planilha
  oExcel:SetVisible(.T.)                     // Visualiza a planilha
  oExcel:Destroy()                           // Encerra o processo do gerenciador de tarefas
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบFuncao      ณVALIDPERG บ Autor ณ Deus sabe!!!       บ Data ณ      /  /   บฑฑ
//ฑฑฬออออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao   ณ Cria as perguntas                                          บฑฑ
//ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบRetorno     ณ                                                            บฑฑ
//ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบParametros  ณ                                                            บฑฑ
//ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

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

					//01     02    03                 	  04  05   06       07   08 09 10  11   	12  			  13          14   		15  16  17  18  19   			20  21  22  23  24   				25  26  27  28  29  				30  31  32  33  34  	 			35  36  37  38   	  	  39
	aAdd(aRegs, {cPerg, "01", "Dt entrada de?"		, "", "", "mv_ch1", "D", 8, 0, 00, "G", "NAOVAZIO()"	, "mv_par01", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "02", "Dt entrada ate?"		, "", "", "mv_ch2", "D", 8, 0, 00, "G", "NAOVAZIO()"	, "mv_par02", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "03", "Filial de?"				, "", "", "mv_ch3", "C", 4, 0, 00, "G", ""			 	, "mv_par03", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "04", "Filial ate?"			, "", "", "mv_ch4", "C", 4, 0, 00, "G", ""			 	, "mv_par04", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "05", "Venda ate?"				, "", "", "mv_ch5", "D", 8, 0, 00, "G", "NAOVAZIO()"	, "mv_par05", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""			, ""})

	aAdd(aRegs, {cPerg, "06", "Fornec de?"				, "", "", "mv_ch6", "C", 6, 2, 00, "G", ""			 	, "mv_par06", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "SA2"			, ""})
	aAdd(aRegs, {cPerg, "07", "Fornec Ate?"			, "", "", "mv_ch8", "C", 6, 2, 00, "G", ""			 	, "mv_par07", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "SA2"			, ""})
                                                                                                                    
	aAdd(aRegs, {cPerg, "08", "Marca de?"				, "", "", "mv_ch6", "C", 6, 2, 00, "G", ""			 	, "mv_par08", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY2CUS"			, ""})
	aAdd(aRegs, {cPerg, "09", "Marca Ate?"				, "", "", "mv_ch8", "C", 6, 2, 00, "G", ""			 	, "mv_par09", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY2CUS"			, ""})

	aAdd(aRegs, {cPerg, "10", "Filial de Entrada?"	, "", "", "mv_chA", "C", 4, 0, 00, "G", ""			 	, "mv_par10", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "11", "Secao de?  "			, "", "", "mv_chB", "C", 4, 0, 00, "G", ""			 	, "mv_par11", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY0"		, ""})
	aAdd(aRegs, {cPerg, "12", "Secao ate? "			, "", "", "mv_chC", "C", 4, 0, 00, "G", ""			 	, "mv_par12", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "AY0"		, ""})
	aAdd(aRegs, {cPerg, "13", "Quebrar por secao?"	, "", "", "mv_chD", "C", 1, 0, 00, "C", ""			 	, "mv_par13", "Sim",		"", "", "", "", "Nใo", 			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY0"		, ""})
	aAdd(aRegs, {cPerg, "14", "Gerar Excel?"	    , "", "", "mv_chE", "C", 1, 0, 00, "C", ""			 	, "mv_par14", "Sim",		"", "", "", "", "Nใo", 			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY0"		, ""})

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
