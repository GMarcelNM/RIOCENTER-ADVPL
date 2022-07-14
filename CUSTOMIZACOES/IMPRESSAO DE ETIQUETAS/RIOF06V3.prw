#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  |RIOF06V2  º Autor ³ Sidney Sales       º Data ³  27/05/21   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Funcao para realizar a impressao das etiquetas na impressora±±
//±±º          ³termica datamax  permitindo etiquetas diferentes            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function RIOF06V3(aItens, nTipo, cPorta, cModelo)

	//+-------------------------------------+
	//| Declaração de variáveis             |
	//+-------------------------------------+
	Local cQuery   := ""
	Local nTamanho := 100
	Local lStatus  := .F.
	Local cLJCNVDA := GetMV("MV_LJCNVDA") 
	Local i, j
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A variavel nImp conta a quantidade de impressoes realizadas,  ³
	//³sera no max 3 pois e' a quantidade de etiquetas possiveis para³
	//³o padra atual                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private	nImp	:= 0	

	Private cCodProd	
	Private cDtUltCom
	Private cColecao
	Private cCodBar
	Private nQtd	         
	Private cTipoBar  
	Private cTamanho := ""
	Private cCor     := ""
	Private cRotacao := "N"
	Private _nTipo := nTipo     
	Private cDescri1, cDescri2, cDescri3   	
	Private cTpFonte := ''		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variaveis do 'LEFT' para saber de onde inicia a impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cReferencia := ""
	Private nLPadrao1
	Private nLPadrao2	      
	Private nValor
    Private cPerg	 := "U_RIOF0006"
	Private lPromocao	:= .F.
	Private cLifeStyle
	Private cColecLSty
	
	Default cPorta	 := "LPT1"
	Default cModelo := "ZEBRA"       
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³As variaveis variam de acordo com o tipo de etiqueta pode ser 1 a etiqueta³
	//³adesiva ou a 2 etiqueta maior                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo	== 1
		nLPadrao1	:= 004
		nLPadrao2	:= 010    
		nQuebra		:= 26
//		nQuebra		:= 18
	Else
		nLPadrao1	:= 001
//		nLPadrao2	:= 055
//  20220420
//		nQuebra		:= 40
		nQuebra		:= 26
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
			nTamanho	:= 59
		Endif
	Else
		cTpFonte	:= "1"
	Endif		
    
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Abre a comunicacao com a impressora de etiquetas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MSCBPRINTER(cModelo,cPorta,,nTamanho,.f.,,,,)
    MSCBLOADGRF("LOGO.GRF") //Carrega o logotipo para impressora

	MSCBCHKStatus(lStatus)	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Varre o array dos itens fazendo a impressao das etiquetas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i := 1 To Len(aItens)		
		
	  	cCodProd	:= AllTrim(aItens[i][1]) //CODIGO DO PRODUTO
	    nQtd		:= aItens[i][2] //QUANTIDADE DE ETIQUETAS		
//		cDtUltCom   := StrTran(dtUltCompra2(cCodProd),'/','')      
		cDtUltCom   := dtUltCompra2(cCodProd)      
		cColecao	:= 'XXX'		      

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seta o produto para pegar a descricao e o preco de venda³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(DBSETORDER(1))
		SB1->(DBSEEK(xFilial('SB1') + Padr(Alltrim(cCodProd),Len(SB1->B1_COD))))						

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso o campo YCODBAR esteja em branco preenche o campo ³
		//³com o conteudo do codigo de barras.                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(SB1->B1_YCODBAR)
			RecLock('SB1', .F.)
				SB1->B1_YCODBAR := SB1->B1_CODBAR				   
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso o campo codigo de barras comece com '0' eu removo o zero do codigo de barras              ³
				//³Isso e' feito pq na hora leitura o leitor despreza o zero. Entao nos removemos ele e utilziamos³
				//³sempre o campo ycodbar para impressao das etiquetas que e' o campo completo                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Left(SB1->B1_CODBAR,1) == '0'
					SB1->B1_CODBAR := SubStr(SB1->B1_CODBAR, 2)
				EndIf			
			SB1->(MsUnLock())			
		EndIf						
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A impressao do codigo de barras sera baseado sempre no YCODBAR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCodBar	:=	Alltrim(SB1->B1_YCODBAR)
        cReferencia := Alltrim(SB1->B1_01DREF)

		SB4->(DbSetOrder(1))
		SB4->(DbSeek(xFilial('SB4') + SB1->B1_01PRODP))
		cLifeStyle := Alltrim(SB4->B4_XCODLS) 
		
		AYH->(DbSetOrder(1))

		If AYH->(DbSeek(xFilial('AYH') + SB4->B4_01COLEC))
			cColecao := AYH->AYH_YABREV
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Descricao do produto e preco de venda³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTexto   := AllTrim(aItens[i][3]) 
		cCor     := AllTrim(aItens[i][4])
		cTamanho := AllTrim(aItens[i][5])
				 				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
		//³Verifica se esta utilizando o cenario de vendas, caso esteja³
		//³pega da tabela definida no parametro de tabela padrao       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
		If cLJCNVDA 
//			DA1->(DBSETORDER(1))
//			if DA1->(DBSEEK(xFilial('DA1') + PADR(GetMv('MV_TABPAD'),3) + Padr(Alltrim(cCodProd),Len(SB1->B1_COD))))
//				nValor := DA1->DA1_PRCVEN
//			Endif			
			
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
				lPromocao := .T.	
			EndIf
		Endif			

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verfica qual tipo de codigo de barras imprimir, foi necessario fazer isso³
		//³pois o cadastro migrado da Rio center, tem 2 tipos de tamanhos,          ³
		//³e o cadastro do protheus ter um terceiro tamanho.                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If Len(cCodBar) >= 14
			cTipoBar	:= 'MB01'
		ElseIf Len(cCodBar) <= 7
			cTipoBar	:=	'MB07'
		ElseIf Len(cCodBar) <= 13 .AND. Len(cCodBar) > 7
			cTipoBar	:=	'MB04'			
		Endif		
      
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o texto for maior que a quebra, quebra em pedacos a string³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If len(Alltrim(cTexto)) > nQuebra
			cDescri1 := SubStr(cTexto, 1,nQuebra)
			cDescri2 := SubStr(cTexto, nQuebra+1,nQuebra)  
			cDescri3 := SubStr(cTexto, nQuebra*2+1,nQuebra)  			
		Else
			cDescri1 :=	Alltrim(cTexto)
			cDescri2 :=	''				
		Endif		     

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se nao tiver impresso nada ainda, inicia a impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nImp == 0
			MSCBBEGIN(1,3,nTamanho)		
			nLeft1 := nLPadrao1
			nLeft2 := nLPadrao2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se a quantidade de impressoes for 3, entao encerra e abre uma nova impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf nImp == 3
//		ElseIf nImp == 2
			nImp	:= 0
			MSCBEND()
			MSCBBEGIN(1,3,nTamanho)		
			nLeft1 := nLPadrao1
			nLeft2 := nLPadrao2
		Endif		       	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime a quantidade total de etiquetas solicitadas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      For J := 1 To nQtd						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chama rotina de impressao³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cModelo == "ZEBRA"
				Print001()									
				if (nImp <> 2) && (_nTipo == 2) 
				  nImp++
				ENDIF  
			Else
				Print002()
				if (nImp <> 2) && (_nTipo == 2) 
				  nImp++
				ENDIF  
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona a qtd de impressoes³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nImp++	

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se e' a terceira impressao, caso seja entao fecha e abre novamente³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			If nImp == 2
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se nao tiver tido a ultima impressao fecha³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//   If nImp <> 2
   If nImp <> 3
	   MSCBEND()	
   Endif

   MSCBCLOSEPRINTER()

Return   


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  |Imprime1  º Autor ³ Sidney Sales       º Data ³  18/03/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Realiza realmente a impressao dos dados na etiqueta.        ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Print001()   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso seja do tipo 1 etiqueta colante e menor³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nTipo == 1		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime a descricao do produto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		MSCBSay(nLeft1,003,cDescri1,cRotacao,cTpFonte,"18")					
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,005,cDescri2,cRotacao,cTpFonte,"18")
		Endif			
		If ! Empty(cDescri3)
			MSCBSay(nLeft1,007,cDescri3,cRotacao,cTpFonte,"18")
	     	MSCBSay(nLeft1,009,cReferencia,cRotacao,cTpFonte,"18")
		else
	     	MSCBSay(nLeft1,007,cReferencia,cRotacao,cTpFonte,"18")
		Endif	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o codigo de barras do produto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MSCBSAYBAR(nLeft1 + 2,011,cCodBar,cRotacao,cTipoBar,5,.F.,.T.,.F.,,2,)		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o valor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        ntam := len(' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')))
		ntam := round(ntam * 2, 0)
        ntam := round((35 - ntam)/ 2, 2)

		MSCBSay(nLeft1 - 6 + ntam,020, ' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"40")		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma aos Lefts para imprimir a etique ao lado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLeft1 += 035
		nLeft2 += 035

	Else		

       //Seta Impressora (Zebra)
	   cColecLSty := ""
		if ! Empty(cLifeStyle)
		  cColecLSty := cLifeStyle
		ENDif

		if (!Empty(cColecao))
			if (!Empty(cColecLSty)) 
		  		 cColecLSty := cColecLSty + ' - ' + cColecao
 			else
		  		 cColecLSty := cColecao
			endif 	 
		ENDIF

		MSCBSay(nLeft1 + (40 - (len(Alltrim(cColecLSty)) - 2)), 10, Alltrim(cColecLSty),cRotacao,cTpFonte,"18")
        MSCBSay(nLeft1 + 40, 12, Substr(cDtUltCom,9,2) + RetSem(Ctod(cDtUltCom)),cRotacao,cTpFonte,"18")

/*
		MSCBSay(nLeft1 + (40 - (len(Alltrim(cColecLSty)) - 3)), 45, Alltrim(cColecLSty),cRotacao,cTpFonte,"24")
        MSCBSay(nLeft1 + 40, 43, Substr(cDtUltCom,9,2) + RetSem(Ctod(cDtUltCom)),cRotacao,cTpFonte,"24")
*/
        MSCBSay(nLeft1 + 8, 3,"RIO CENTER",cRotacao,cTpFonte,"55") 

        MSCBSay(nLeft1 + 1,17,cDescri1,cRotacao,cTpFonte,"22")
	    If ! Empty(cDescri2)
		   MSCBSay(nLeft1 + 1,20,cDescri2,cRotacao,cTpFonte,"22")
	    Endif

        MSCBSay(nLeft1 + 2,23,cReferencia,cRotacao, cTpFonte,"22")	
        MSCBSay(nLeft1 + 15, 26,cCodProd,cRotacao, cTpFonte,"22")	
        MSCBSay(nLeft1 + 10, 29,cCodBar,cRotacao,cTpFonte,"22")	

        MSCBSAYBAR(nLeft1 + 42, 20,cCodBar,"R",cTipoBar,6,.F.,.T.,.F.,,2,)
        MSCBSAY(nLeft1 + 17, 33, "TAMANHO",cRotacao,cTpFonte,"22") //Imprime Texto

        ntam := len(Alltrim(cTamanho))
		ntam := round(ntam * 3, 0)
        ntam := round((40 - ntam)/ 2, 2)
        MSCBSay(nLeft1 + ntam, 36,Alltrim(cTamanho), cRotacao,cTpFonte,"45") 
//        MSCBSay(nLeft1, 36,"01234567890123456789", cRotacao,cTpFonte,"45") 

        MSCBSAY(nLeft1 + 1, 42,"COR: ",cRotacao,cTpFonte,"22") //Imprime Texto
        MSCBSAY(nLeft1 + 10, 42,cCor,cRotacao,cTpFonte,"24") //Imprime Texto
        
        ntam := len(Alltrim(Transform(nValor, '@E 999,999.99')))
		ntam := round(ntam * 3, 0)
        ntam := round((46 - ntam)/ 2, 2)
        MSCBSay(nLeft1 + ntam, 46," R$ " + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"55") 
/*
        MSCBSay(nLeft1 + 3,40,cDescri1,cRotacao,cTpFonte,"18")
	    If ! Empty(cDescri2)
		   MSCBSay(nLeft1 + 3,38,cDescri2,cRotacao,cTpFonte,"18")
	    Endif

        MSCBSay(nLeft1 + 2,35,cReferencia,cRotacao, "2","22")	
        MSCBSay(nLeft1 + 15, 32,cCodProd,cRotacao, "2","22")	
        MSCBSay(nLeft1 + 10, 29,cCodBar,cRotacao,"2","22")	
        
        MSCBSAYBAR(nLeft1 + 40,40,cCodBar,"R",cTipoBar,6,.F.,.T.,.F.,,2,)
        MSCBSAY(nLeft1 + 15, 25, "TAMANHO",cRotacao,cTpFonte,"24") //Imprime Texto

        ntam := len(Alltrim(cTamanho)) + 3
		ntam := round(ntam * 3.83, 0)
        ntam := round((50 - ntam)/ 2, 2)
        MSCBSay(nLeft1 + ntam,20,Alltrim(cTamanho),cRotacao,"3","2") 

        MSCBSAY(nLeft1 + 3, 14,"COR: ",cRotacao,cTpFonte,"22") //Imprime Texto
        MSCBSAY(nLeft1 + 10, 14,cCor,cRotacao,"2","22") //Imprime Texto
        

        ntam := len(Alltrim(Transform(nValor, '@E 999,999.99'))) + 3
		ntam := round(ntam * 3.83, 0)
        ntam := round((46 - ntam)/ 2, 2)
        MSCBSay(nLeft1 + ntam,7," R$ " + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,"3","2") 
*/
		nLeft1 += 054

	Endif

Return                       



//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  |Imprime2  º Autor ³ Sidney Sales       º Data ³  18/03/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Realiza realmente a impressao dos dados na etiqueta.        ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Print002()  
    static ntam := 0

	//³Caso seja do tipo 1 etiqueta colante e menor³
	If _nTipo == 1		
		MSCBSay(nLeft1,022,cDescri1,cRotacao,cTpFonte,"001,001,001")					
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,020,cDescri2,cRotacao,cTpFonte,"001,001,001")
		Endif			
		If ! Empty(cDescri3)
			MSCBSay(nLeft1,018,cDescri3,cRotacao,cTpFonte,"001,001,001")
	     	MSCBSay(nLeft1,016,cReferencia,cRotacao,cTpFonte,"001,001,001")
		else
	     	MSCBSay(nLeft1,018,cReferencia,cRotacao,cTpFonte,"001,001,001")
		Endif			

		MSCBSAYBAR(nLeft2 + 22,026,cCodBar,cRotacao,cTipoBar,5,.F.,.T.,.F.,,1,)		

		MSCBSay(nLeft1,002,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"001,001,004")		

		nLeft1 += 035
		nLeft2 += 035
	Else
//	    MSCBBOX(nLeft1,3,nLeft1 + 49,56) //Monta BOX

        MSCBGRAFIC(3,48,"LOGO") //Posiciona o logotio 

//        MSCBSay(nLeft1 + 25, 49,cColecao + Space(12) + Substr(cDtUltCom,7,4) + '/' +;
//                                RetSem(Ctod(cDtUltCom)),cRotacao,cTpFonte,"24")
        
		if ! Empty(cLifeStyle)
		  cColecLSty := cLifeStyle
		ENDif

		if (!Empty(cColecao))
			if (!Empty(cColecLSty)) 
		  		 cColecLSty := cColecLSty + ' - ' + cColecao
 			else
		  		 cColecLSty := cColecao
			endif 	 
		ENDIF

		MSCBSay(nLeft1 + (40 - (len(Alltrim(cColecLSty)) - 3)), 45, Alltrim(cColecLSty),cRotacao,cTpFonte,"24")
//		MSCBSay(nLeft1 + 40, 45, cColecao,cRotacao,cTpFonte,"24")
			   
        MSCBSay(nLeft1 + 40, 43, Substr(cDtUltCom,9,2) + RetSem(Ctod(cDtUltCom)),cRotacao,cTpFonte,"24")

//        MSCBSAY(nLeft1 + 7,51,"LOJA ",cRotacao,"2","18,10",.T.) //Imprime Texto
//        MSCBSAY(nLeft1 + 2,46,"RIO CENTER","N","2","01,01",.T.) //Imprime Texto
        MSCBSAY(nLeft1 + 5,50,"RIO CENTER","N","3","2",.T.) //Imprime Texto

//		MSCBLineH(nLeft1 + 1, 44, nLeft1 + 48, 2, "B")
//        MSCBLineH(nLeft1 + 1, 44, nLeft1 + 38, 2, "B")
        
//        MSCBLineV(nLeft1 + 38, 15,55,2,"B")
        
//        MSCBSay(nLeft1 + 3,41,cDescri1,cRotacao,cTpFonte,"18")
        MSCBSay(nLeft1 + 3,40,cDescri1,cRotacao,cTpFonte,"18")
	    If ! Empty(cDescri2)
//		   MSCBSay(nLeft1 + 3,39,cDescri2,cRotacao,cTpFonte,"18")
		   MSCBSay(nLeft1 + 3,38,cDescri2,cRotacao,cTpFonte,"18")
	    Endif

//        MSCBSay(nLeft1 + 2,37,cReferencia,cRotacao,cTpFonte,"24")	
//        MSCBSay(nLeft1 + 2,35,cReferencia,cRotacao,cTpFonte,"18")	
        MSCBSay(nLeft1 + 2,35,cReferencia,cRotacao, "2","22")	
//        MSCBSay(nLeft1 + 20, 37,cCodProd,cRotacao,cTpFonte,"24")	
        MSCBSay(nLeft1 + 15, 32,cCodProd,cRotacao, "2","22")	
        MSCBSay(nLeft1 + 10, 29,cCodBar,cRotacao,"2","22")	
        
//        MSCBLineH(nLeft1 + 1,36,nLeft1 + 48,2,"B") //Monta Linha Horizontal
 //       MSCBLineH(nLeft1 + 1,36,nLeft1 + 38,2,"B") //Monta Linha Horizontal

        MSCBSAYBAR(nLeft1 + 40,40,cCodBar,"R",cTipoBar,6,.F.,.T.,.F.,,2,)
//        MSCBSAYBAR(nLeft1 + 10,27,cCodBar,cRotacao,cTipoBar,6,.F.,.T.,.F.,,2,)

//        MSCBLineH(nLeft1 + 1,26,nLeft1 + 48,2,"B") //Monta Linha Horizontal
//        MSCBLineH(nLeft1 + 1,26,nLeft1 + 38,2,"B") //Monta Linha Horizontal

//        MSCBSAY(nLeft1 + 7, 23,"TAM",cRotacao,cTpFonte,"018") //Imprime Texto
        MSCBSAY(nLeft1 + 15, 25, "TAMANHO",cRotacao,cTpFonte,"24") //Imprime Texto
//        MSCBSAY(nLeft1 + 5, 19,cTamanho,cRotacao,"3","22") //Imprime Texto

        ntam := len(Alltrim(cTamanho)) + 3
		ntam := round(ntam * 3.83, 0)
        ntam := round((50 - ntam)/ 2, 2)
//        MSCBSay(nLeft1 + ntam,24,Alltrim(cTamanho),cRotacao,"3","2") 
        MSCBSay(nLeft1 + ntam,20,Alltrim(cTamanho),cRotacao,"3","2") 


//        MSCBSAY(nLeft1 + 27, 23,"COR",cRotacao,cTpFonte,"018") //Imprime Texto

//        MSCBLineH(nLeft1 + 1, 22,nLeft1 + 48,2,"B") //Monta Linha Horizontal
//        MSCBLineH(nLeft1 + 1, 22,nLeft1 + 38,2,"B") //Monta Linha Horizontal
        

//        MSCBSAY(nLeft1 + 27, 23,"COR",cRotacao,cTpFonte,"018") //Imprime Texto
        MSCBSAY(nLeft1 + 3, 14,"COR: ",cRotacao,cTpFonte,"22") //Imprime Texto
//        MSCBSAY(nLeft1 + 25, 18,cCor,cRotacao,cTpFonte,"24") //Imprime Texto
        MSCBSAY(nLeft1 + 10, 14,cCor,cRotacao,"2","22") //Imprime Texto
        
       // --- Monta Linha Horizontal
       // ---(X1,Y1,Y2,Cor) = X1 - Coluna, Y1 - Linha De, Y2 - Linha Até e Cor = 'W' Preto ou 'B' Branco
       //--------------------------- 
//        MSCBLineV(nLeft1 + 23, 15,26,2,"B")  

//        MSCBLineH(nLeft1 + 1,15,nLeft1 + 48,2,"B") //Monta Linha Horizontal

        ntam := len(Alltrim(Transform(nValor, '@E 999,999.99'))) + 3
		ntam := round(ntam * 3.83, 0)
        ntam := round((46 - ntam)/ 2, 2)
        MSCBSay(nLeft1 + ntam,7," R$ " + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,"3","2") 
        //MSCBSay(nLeft1 + 23,12," R$ " + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,"3","18") 
		//MSCBSay(nLeft1 + 1, 5,"012345678901",cRotacao, "3","2")

		nLeft1 += 054
		
	Endif

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  |dtUltCompra2 Autor ³ Sidney Sales       º Data ³  26/02/15   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Retorna a ultima data de nota de entrada para o produto.   º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function dtUltCompra2(cCodProd)
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
