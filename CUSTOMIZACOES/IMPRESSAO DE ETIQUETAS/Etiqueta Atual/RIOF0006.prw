#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"
//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
//╠╠╨Programa  |RIOF0006  ╨ Autor Ё Sidney Sales       ╨ Data Ё  18/03/13   ╨╠╠
//╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
//╠╠╨Descricao Ё Funcao para realizar a impressao das etiquetas na impressora╠╠
//╠╠╨          Ёtermica datamax.                                            ╨╠╠
//╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
//╠╠╨Uso       Ё                                                            ╨╠╠
//╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
User Function RIOF0006(aItens, nTipo, cPorta, cModelo)

	//+-------------------------------------+
	//| DeclaraГЦo de variАveis             |
	//+-------------------------------------+
	Local nTamanho := 100 
	Local lStatus  := .F.
	Local i, j
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁA variavel nImp conta a quantidade de impressoes realizadas,  Ё
	//Ёsera no max 3 pois e' a quantidade de etiquetas possiveis paraЁ
	//Ёo padra atual                                                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Private	nImp	:= 0	

	Private cCodProd	
	Private cDtUltCom
	Private cColecao
	Private cCodBar
	Private nQtd	         
	Private cTipoBar  
	Private cRotacao := "N"
	Private _nTipo := nTipo     
	Private cDescri1, cDescri2, cDescri3   	
	Private cTpFonte := ''		
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁVariaveis do 'LEFT' para saber de onde inicia a impressaoЁ
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Private nLPadrao1
	Private nLPadrao2
	Private cReferencia := ""	      
	Private nValor
   Private cPerg	 := "U_RIOF0006"
	Private lPromocao	:= .F.
	
	Default cPorta	 := "LPT1"
	Default cModelo := "ZEBRA"       
	
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAs variaveis variam de acordo com o tipo de etiqueta pode ser 1 a etiquetaЁ
	//Ёadesiva ou a 2 etiqueta maior                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If nTipo	== 1
		nLPadrao1	:= 004
		nLPadrao2	:= 010    
		nQuebra		:= 26
	Else
		nLPadrao1	:= 002
		nLPadrao2	:= 004
		nQuebra		:= 20
	Endif      
	
	If cModelo == "ZEBRA"
		cTpFonte := "0"
		nTamanho	:= 100
	ElseIf cModelo == "ALLEGRO"
		cTpFonte := "9"
		If nTipo == 1 
			nTamanho	:= 27
			nLPadrao1	:= 002
			nLPadrao2	:= 004    
		Else
			nTamanho	:= 65
		Endif
	Else
		cTpFonte	:= "1"
	Endif		

	//здддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAbre a comunicacao com a impressora de etiquetasЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддды
	MSCBPRINTER(cModelo,cPorta,,nTamanho,.f.,,,,)
	MSCBCHKStatus(lStatus)	

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁVarre o array dos itens fazendo a impressao das etiquetasЁ
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	For i := 1 To Len(aItens)		
		
	  	cCodProd	:= AllTrim(aItens[i][1]) //CODIGO DO PRODUTO
	   nQtd		:= aItens[i][2] //QUANTIDADE DE ETIQUETAS		
		cDtUltCom:= StrTran(dtUltCompra(cCodProd),'/','')      
		cColecao	:= 'XXX'		      

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSeta o produto para pegar a descricao e o preco de vendaЁ
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		SB1->(DBSETORDER(1))
		SB1->(DBSEEK(xFilial('SB1') + Padr(Alltrim(cCodProd),Len(SB1->B1_COD))))						

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCaso o campo YCODBAR esteja em branco preenche o campo Ё
		//Ёcom o conteudo do codigo de barras.                    Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If Empty(SB1->B1_YCODBAR)
			RecLock('SB1', .F.)
				SB1->B1_YCODBAR := SB1->B1_CODBAR				   
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁCaso o campo codigo de barras comece com '0' eu removo o zero do codigo de barras              Ё
				//ЁIsso e' feito pq na hora leitura o leitor despreza o zero. Entao nos removemos ele e utilziamosЁ
				//Ёsempre o campo ycodbar para impressao das etiquetas que e' o campo completo                    Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If Left(SB1->B1_CODBAR,1) == '0'
					SB1->B1_CODBAR := SubStr(SB1->B1_CODBAR, 2)
				EndIf			
			SB1->(MsUnLock())			
		EndIf						
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁA impressao do codigo de barras sera baseado sempre no YCODBARЁ
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cCodBar	:=	Alltrim(SB1->B1_YCODBAR)
        cReferencia := Alltrim(SB1->B1_01DREF)

		SB4->(DbSetOrder(1))
		SB4->(DbSeek(xFilial('SB4') + SB1->B1_01PRODP))
		
		AYH->(DbSetOrder(1))

		If AYH->(DbSeek(xFilial('AYH') + SB4->B4_01COLEC))
			cColecao := AYH->AYH_YABREV
		EndIf

		//зддддддддддддддддддддддддддддддддддддд©
		//ЁDescricao do produto e preco de vendaЁ
		//юддддддддддддддддддддддддддддддддддддды
		cTexto    := aItens[i][3]  				
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддH©
		//ЁVerifica se esta utilizando o cenario de vendas, caso estejaЁ
		//Ёpega da tabela definida no parametro de tabela padrao       Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддHы
		If GetMV('MV_LJCNVDA') 
		//	DA1->(DBSETORDER(1))
		//	if DA1->(DBSEEK(xFilial('DA1') + PADR(GetMv('MV_TABPAD'),3) + Padr(Alltrim(cCodProd),Len(SB1->B1_COD))))
		//		nValor := DA1->DA1_PRCVEN
		//	Endif	

			
			cQuery := "Select Min(DA1.DA1_PRCVEN)  as PRECO from " + RetSqlName("DA1") + " DA1, " + RetSqlName("DA0") + " DA0"
            cQuery += "  where DA1.D_E_L_E_T_ = ' '"
            cQuery += "    and DA1.DA1_CODPRO = '" + Padr(Alltrim(cCodProd),Len(SB1->B1_COD)) + "'"
            cQuery += "    and DA1.DA1_DATVIG <= '" + DToS(dDataBase) + "'"
            cQuery += "    and DA0.D_E_L_E_T_ = ' '"
            cQuery += "    and DA0.DA0_FILIAL = DA1.DA1_FILIAL"
            cQuery += "    and DA0.DA0_CODTAB = DA1.DA1_CODTAB"
            cQuery += "    and DA0.DA0_DATDE <= '" + DToS(dDataBase) + "'"
            cQuery += "    and (DA0.DA0_DATATE >= '" + DToS(dDataBase) + "' or DA0.DA0_DATATE = ' ')"
		
		    cQuery := ChangeQuery(cQuery)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QDA1",.F.,.T.)
            
            If ! QDA1->(Eof())
               nValor := QDA1->PRECO
            EndIf
            
            QDA1->(dbCloseArea())					
		Else
			nValor := StaticCall(RIOA0002,PrecoSemPromocao, SB1->B1_COD)
			If nValor == 0
				lPromocao := .F.
				SB0->(DbSetOrder(1))
				SB0->(DbSeek(xFilial('SB0') + SB1->B1_COD))
				nValor	 := SB0->B0_PRV1		
			Else
				lPromocao :=  .T.	
			EndIf
		Endif			

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁVerfica qual tipo de codigo de barras imprimir, foi necessario fazer issoЁ
		//Ёpois o cadastro migrado da Rio center, tem 2 tipos de tamanhos,          Ё
		//Ёe o cadastro do protheus ter um terceiro tamanho.                        Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
		If Len(cCodBar) >= 14
			cTipoBar	:= 'MB01'
		ElseIf Len(cCodBar) <= 7
			cTipoBar	:=	'MB07'
		ElseIf Len(cCodBar) <= 13 .AND. Len(cCodBar) > 7
			cTipoBar	:=	'MB04'			
		Endif		
      
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSe o texto for maior que a quebra, quebra em pedacos a stringЁ
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If len(Alltrim(cTexto)) > nQuebra
			cDescri1	:=	SubStr(cTexto, 1,nQuebra)
			cDescri2	:= SubStr(cTexto, nQuebra+1,nQuebra)  
			cDescri3	:= SubStr(cTexto, nQuebra*2+1,nQuebra)  			
		Else
			cDescri1	:=	Alltrim(cTexto)
			cDescri2	:=	''				
		Endif		     

		//здддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSe nao tiver impresso nada ainda, inicia a impressaoЁ
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддды
		If nImp == 0
			MSCBBEGIN(1,3,nTamanho)		
			nLeft1 := nLPadrao1
			nLeft2 := nLPadrao2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSe a quantidade de impressoes for 3, entao encerra e abre uma nova impressaoЁ
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		ElseIf nImp == 3
			nImp	:= 0
			MSCBEND()
			MSCBBEGIN(1,3,nTamanho)		
			nLeft1 := nLPadrao1
			nLeft2 := nLPadrao2
		Endif		       	

		//зддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁImprime a quantidade total de etiquetas solicitadasЁ
		//юддддддддддддддддддддддддддддддддддддддддддддддддддды
      For J := 1 To nQtd						
			//зддддддддддддддддддддддддд©
			//ЁChama rotina de impressaoЁ
			//юддддддддддддддддддддддддды
			If cModelo == "ZEBRA"
				Imprime1()									
			Else
				Imprime2()
			Endif
			//здддддддддддддддддддддддддддд©
			//ЁAdiciona a qtd de impressoesЁ
			//юдддддддддддддддддддддддддддды
			nImp++						
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁVerifica se e' a terceira impressao, caso seja entao fecha e abre novamenteЁ
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If nImp == 3
				nImp	:= 0
				MSCBEND()
				nLeft1 := nLPadrao1
				nLeft2 := nLPadrao2
				If J < nQtd 
					MSCBBEGIN(1,3,nTamanho)		
				Endif
			Endif
		Next
    Next	

	//здддддддддддддддддддддддддддддддддддддддддд©
	//ЁSe nao tiver tido a ultima impressao fechaЁ
	//юдддддддддддддддддддддддддддддддддддддддддды
   If nImp <> 3
	   MSCBEND()	
   Endif

   MSCBCLOSEPRINTER()

Return   


//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
//╠╠╨Programa  |Imprime1  ╨ Autor Ё Sidney Sales       ╨ Data Ё  18/03/13   ╨╠╠
//╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
//╠╠╨Descricao Ё Realiza realmente a impressao dos dados na etiqueta.        ╠╠
//╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
//╠╠╨Uso       Ё                                                            ╨╠╠
//╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
Static Function Imprime1()   	
	//здддддддддддддддддддддддддддддддддддддддддддд©
	//ЁCaso seja do tipo 1 etiqueta colante e menorЁ
	//юдддддддддддддддддддддддддддддддддддддддддддды
	If _nTipo == 1		
		//здддддддддддддддддддддддддддддд©
		//ЁImprime a descricao do produtoЁ
		//юдддддддддддддддддддддддддддддды
		/*
		//  ALTERACAO PARA INCLUSAO DA LINHA DE REFERENCIA 2021-06-07

		MSCBSay(nLeft1,003,cDescri1,cRotacao,cTpFonte,"18")					
		//зддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCaso tenha continuacao da descricao imprimeЁ
		//юддддддддддддддддддддддддддддддддддддддддддды
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,006,cDescri2,cRotacao,cTpFonte,"18")
		Endif			

		//зддддддддддддддддддддддддддддддддддддд©
		//ЁImprime o codigo de barras do produtoЁ
		//юддддддддддддддддддддддддддддддддддддды
		MSCBSAYBAR(nLeft2,008,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)		
		*/

     	MSCBSay(nLeft1,002,cDescri1,cRotacao,cTpFonte,"18")					
		//зддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCaso tenha continuacao da descricao imprimeЁ
		//юддддддддддддддддддддддддддддддддддддддддддды
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,005,cDescri2,cRotacao,cTpFonte,"18")
		Endif			
		MSCBSay(nLeft1,008,cReferencia,cRotacao,cTpFonte,"18")
		//зддддддддддддддддддддддддддддддддддддд©
		//ЁImprime o codigo de barras do produtoЁ
		//юддддддддддддддддддддддддддддддддддддды
		MSCBSAYBAR(nLeft2,010,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)		

		//зддддддддддддддд©
		//ЁImprime o valorЁ
		//юддддддддддддддды
		MSCBSay(nLeft2,020,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"40")		
		//зддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSoma aos Lefts para imprimir a etique ao ladoЁ
		//юддддддддддддддддддддддддддддддддддддддддддддды
		nLeft1 += 035
		nLeft2 += 035
	Else		
		//здддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCaso seja o tipo 2, a etiqueta maior de furoЁ
		//юдддддддддддддддддддддддддддддддддддддддддддды		

		MSCBSay(nLeft1,003,Space(3) + cColecao + Space(15) + cDtUltCom,cRotacao,cTpFonte,"21")

		//зддддддддддддддддддддддддддддддд©
		//ЁImprime o codigo do produto.   Ё
		//юддддддддддддддддддддддддддддддды
		MSCBSay(nLeft1,008,cCodProd,cRotacao,cTpFonte,"32")		

		//здддддддддддддддддддддддддддддд©
		//ЁImprime a mensagem na etiquetaЁ
		//юдддддддддддддддддддддддддддддды
		cMsg	:=	SuperGetMV('MS_MSGETIQ',.F.,"EM CASO DE TROCA NAO RETIRAR A ETIQUETA")
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSe o produto estiver em promocao imprime msg de promocaoЁ
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lPromocao		
			cMsg := SuperGetMV('MS_MSGPROM',.F.,"NAO EFETUAMOS TROCA EM PRODUTO PROMOCIONAL")
		EndIf

		//зддддддддддддддддддддддддддд©
		//ЁQuebra a mensagem em partesЁ
		//юддддддддддддддддддддддддддды
      cMsg1	:= Substr(cMsg, 1, nQuebra)
		cMsg2	:= Substr(cMsg,nQuebra+1,nQuebra)							

		//здддддддддддддддддддддддддддддд©
		//ЁImprime a mensagem na etiquetaЁ
		//юдддддддддддддддддддддддддддддды
		MSCBSay(nLeft1,014,cMsg1,cRotacao,cTpFonte,"21")
		If !Empty(cMsg2)
			MSCBSay(nLeft1+2,017,cMsg2,cRotacao,cTpFonte,"21")
		Endif

		//здддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁImprime a descricao do produto em ate 3 linhasЁ
		//юдддддддддддддддддддддддддддддддддддддддддддддды
		MSCBSay(nLeft1,022,cDescri1,cRotacao,cTpFonte,"21")
	
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,025,cDescri2,cRotacao,cTpFonte,"21")
		Endif

		If ! Empty(cDescri3)
			MSCBSay(nLeft1,028,cDescri3,cRotacao,cTpFonte,"21")
		Endif			

		//здддддддддддддддддддддддддд©
		//ЁImprime o codigo de barrasЁ
		//юдддддддддддддддддддддддддды
		MSCBSAYBAR(nLeft2,035,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)
//		MSCBSAYBAR(nLeft2,035,cCodBar,'R',cTipoBar,7,.F.,.T.,.F.,,2,)


		//здддддддддддддддддддддддддд©
		//ЁImprime o preco do produtoЁ
		//юдддддддддддддддддддддддддды
		MSCBSay(nLeft2,047,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"45")   		

		//зддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSoma aos Lefts para imprimir a etique ao ladoЁ
		//юддддддддддддддддддддддддддддддддддддддддддддды
		nLeft1 += 031
		nLeft2 += 031
	Endif

Return                       



//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
//╠╠╨Programa  |Imprime2  ╨ Autor Ё Sidney Sales       ╨ Data Ё  18/03/13   ╨╠╠
//╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
//╠╠╨Descricao Ё Realiza realmente a impressao dos dados na etiqueta.        ╠╠
//╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
//╠╠╨Uso       Ё                                                            ╨╠╠
//╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
Static Function Imprime2()   	
	//здддддддддддддддддддддддддддддддддддддддддддд©
	//ЁCaso seja do tipo 1 etiqueta colante e menorЁ
	//юдддддддддддддддддддддддддддддддддддддддддддды
	If _nTipo == 1
		//здддддддддддддддддддддддддддддд©
		//ЁImprime a descricao do produtoЁ
		//юдддддддддддддддддддддддддддддды
		MSCBSay(nLeft1,022,cDescri1,cRotacao,cTpFonte,"001,001,001")					
		//MSCBSay(nLeft1,020,cDescri1,cRotacao,cTpFonte,"001,001,001")					
		//зддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCaso tenha continuacao da descricao imprimeЁ
		//юддддддддддддддддддддддддддддддддддддддддддды
		If ! Empty(cDescri2)
			//MSCBSay(nLeft1,018,cDescri2,cRotacao,cTpFonte,"001,001,001")
			MSCBSay(nLeft1,020,cDescri2,cRotacao,cTpFonte,"001,001,001")
		Endif			
     	MSCBSay(nLeft1,018,cReferencia,cRotacao,cTpFonte,"001,001,001")

		//зддддддддддддддддддддддддддддддддддддд©
		//ЁImprime o codigo de barras do produtoЁ
		//юддддддддддддддддддддддддддддддддддддды
		MSCBSAYBAR(nLeft2,008,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)		

		//зддддддддддддддд©
		//ЁImprime o valorЁ
		//юддддддддддддддды
		MSCBSay(nLeft2,002,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"001,001,004")		
		//зддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSoma aos Lefts para imprimir a etique ao ladoЁ
		//юддддддддддддддддддддддддддддддддддддддддддддды
		nLeft1 += 035
		nLeft2 += 035
	Else		
		
		If cFilAnt == '0103'
			//здддддддддддддддддддддддддддддддддддддддддддд©
			//ЁCaso seja o tipo 2, a etiqueta maior de furoЁ
			//юдддддддддддддддддддддддддддддддддддддддддддды		
			MSCBSay(nLeft1+2,039,Space(3) + cColecao + ' - ' + cDtUltCom,cRotacao,cTpFonte,"001,001,003")					

			//зддддддддддддддддддддддддддддддд©
			//ЁImprime o codigo do produto.   Ё
			//юддддддддддддддддддддддддддддддды
			MSCBSay(nLeft1+2,036,cCodProd,cRotacao,cTpFonte,"001,001,003")		
	
			//здддддддддддддддддддддддддддддд©
			//ЁImprime a mensagem na etiquetaЁ
			//юдддддддддддддддддддддддддддддды
			cMsg	:=	SuperGetMV('MS_MSGETIQ',.F.,"EM CASO DE TROCA NAO RETIRAR A ETIQUETA")
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁSe o produto estiver em promocao imprime msg de promocaoЁ
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lPromocao		
				cMsg := SuperGetMV('MS_MSGPROM',.F.,"NAO EFETUAMOS TROCA EM PRODUTO PROMOCIONAL")
			EndIf
			
			//зддддддддддддддддддддддддддд©
			//ЁQuebra a mensagem em partesЁ
			//юддддддддддддддддддддддддддды
	      cMsg1	:= Substr(cMsg, 1, nQuebra)
			cMsg2	:= Substr(cMsg,nQuebra+1,nQuebra)							
	
			//здддддддддддддддддддддддддддддд©
			//ЁImprime a mensagem na etiquetaЁ
			//юдддддддддддддддддддддддддддддды
			MSCBSay(nLeft1+2,030,cMsg1,cRotacao,cTpFonte,"001,001,001")
			If !Empty(cMsg2)
				MSCBSay(nLeft1+2,028,cMsg2,cRotacao,cTpFonte,"001,001,001")
			Endif
	
			//здддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁImprime a descricao do produto em ate 3 linhasЁ
			//юдддддддддддддддддддддддддддддддддддддддддддддды
			MSCBSay(nLeft1+3,022,cDescri1,cRotacao,cTpFonte,"001,001,001")
		
			If ! Empty(cDescri2)
				MSCBSay(nLeft1+3,020,cDescri2,cRotacao,cTpFonte,"001,001,001")
	 		Endif
	
			If ! Empty(cDescri3)
				MSCBSay(nLeft1+3,018,cDescri3,cRotacao,cTpFonte,"001,001,001")
			Endif			

			//здддддддддддддддддддддддддд©
			//ЁImprime o codigo de barrasЁ
			//юдддддддддддддддддддддддддды
			MSCBSAYBAR(nLeft2,010,cCodBar,cRotacao,cTipoBar,5,.F.,.T.,.F.,,2,)
	
			//здддддддддддддддддддддддддд©
			//ЁImprime o preco do produtoЁ
			//юдддддддддддддддддддддддддды
			MSCBSay(nLeft2+2,004,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"001,001,004")   		
	
			//зддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁSoma aos Lefts para imprimir a etique ao ladoЁ
			//юддддддддддддддддддддддддддддддддддддддддддддды
			nLeft1 += 032
			nLeft2 += 032

		Else

			//здддддддддддддддддддддддддддддддддддддддддддд©
			//ЁCaso seja o tipo 2, a etiqueta maior de furoЁ
			//юдддддддддддддддддддддддддддддддддддддддддддды		

			MSCBSay(nLeft1+2,052,Space(3) + cColecao + ' - ' + cDtUltCom,cRotacao,cTpFonte,"001,001,003")					

			//зддддддддддддддддддддддддддддддд©
			//ЁImprime o codigo do produto.   Ё
			//юддддддддддддддддддддддддддддддды
			MSCBSay(nLeft1+2,045,cCodProd,cRotacao,cTpFonte,"001,001,003")		
	
			//здддддддддддддддддддддддддддддд©
			//ЁImprime a mensagem na etiquetaЁ
			//юдддддддддддддддддддддддддддддды
			cMsg	:=	SuperGetMV('MS_MSGETIQ',.F.,"EM CASO DE TROCA NAO RETIRAR A ETIQUETA")

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁSe o produto estiver em promocao imprime msg de promocaoЁ
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lPromocao		
				cMsg := SuperGetMV('MS_MSGPROM',.F.,"NAO EFETUAMOS TROCA EM PRODUTO PROMOCIONAL")
			EndIf		
			
			//зддддддддддддддддддддддддддд©
			//ЁQuebra a mensagem em partesЁ
			//юддддддддддддддддддддддддддды
	      cMsg1	:= Substr(cMsg, 1, nQuebra)
			cMsg2	:= Substr(cMsg,nQuebra+1,nQuebra)							
	
			//здддддддддддддддддддддддддддддд©
			//ЁImprime a mensagem na etiquetaЁ
			//юдддддддддддддддддддддддддддддды
			  //MSCBSay(nLeft1+2,037,cMsg1,cRotacao,cTpFonte,"001,001,001")
			  //If !Empty(cMsg2)
			  //	MSCBSay(nLeft1+2,034,cMsg2,cRotacao,cTpFonte,"001,001,001")
			  //Endif

			// ALTERADO PARA INCLUSAO DA REFERENCIA EM LINHA UNICA  2021-06-07
			MSCBSay(nLeft1+2,040,cMsg1,cRotacao,cTpFonte,"001,001,001")
			If !Empty(cMsg2)
				MSCBSay(nLeft1+2,037,cMsg2,cRotacao,cTpFonte,"001,001,001")
			Endif
	
			//здддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁImprime a descricao do produto em ate 3 linhasЁ
			//юдддддддддддддддддддддддддддддддддддддддддддддды
			/*  
			// ALTERADO PARA INCLUSAO DA REFERENCIA EM LINHA UNICA  2021-06-07
			MSCBSay(nLeft1+3,028,cDescri1,cRotacao,cTpFonte,"001,001,001")
		
			If ! Empty(cDescri2)
				MSCBSay(nLeft1+3,025,cDescri2,cRotacao,cTpFonte,"001,001,001")
	 		Endif
	
			If ! Empty(cDescri3)
				MSCBSay(nLeft1+3,022,cDescri3,cRotacao,cTpFonte,"001,001,001")
			Endif			
            */	
			MSCBSay(nLeft1+3,031,cDescri1,cRotacao,cTpFonte,"001,001,001")
		
			If ! Empty(cDescri2)
				MSCBSay(nLeft1+3,028,cDescri2,cRotacao,cTpFonte,"001,001,001")
	 		Endif
	
			If ! Empty(cDescri3)
				MSCBSay(nLeft1+3,025,cDescri3,cRotacao,cTpFonte,"001,001,001")
			Endif			
         	MSCBSay(nLeft1+3,022,cReferencia,cRotacao,cTpFonte,"001,001,001")
	   		
			//здддддддддддддддддддддддддд©
			//ЁImprime o codigo de barrasЁ
			//юдддддддддддддддддддддддддды
			MSCBSAYBAR(nLeft2,012,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)

			//здддддддддддддддддддддддддд©
			//ЁImprime o preco do produtoЁ
			//юдддддддддддддддддддддддддды
			MSCBSay(nLeft2+2,001,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"001,001,004")
	
			//зддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁSoma aos Lefts para imprimir a etique ao ladoЁ
			//юддддддддддддддддддддддддддддддддддддддддддддды
			nLeft1 += 031
			nLeft2 += 031

		EndIf

	Endif

Return

//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
//╠╠╨Programa  |dtUltCompra Autor Ё Sidney Sales       ╨ Data Ё  26/02/15   ╨╠╠
//╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
//╠╠╨Descricao Ё Retorna a ultima data de nota de entrada para o produto.   ╨╠╠
//╠╠╨          Ё                                                            ╨╠╠
//╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
//╠╠╨Uso       Ё                                                            ╨╠╠
//╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
Static Function dtUltCompra(cCodProd)
	Local cQuery
	Local cRet 	:= DtoC(dDataBase)
	Local cTess	:= SuperGetMv("MS_TESENTR",.F.,"008,009,010,017,030")    

	cQuery := " SELECT TOP 1 D1_DTDIGIT FROM " + RetSqlName('SD1') + " SD1 "
	cQuery += " WHERE SD1.D_E_L_E_T_ <> '*'"
	cQuery += " AND D1_COD = '" + cCodProd + "' "
	cQuery += " AND D1_TES IN (" + cTess + ")"  
	cQuery += " ORDER BY D1_DTDIGIT DESC "
	
	If Select("QRYD1") > 0
		QRYD1->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias 'QRYD1'
	
	If QRYD1->(!Eof())
		cRet := DtoC(StoD(QRYD1->D1_DTDIGIT))
	Endif

Return cRet
