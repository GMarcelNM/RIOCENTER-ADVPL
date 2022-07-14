#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOF0006  � Autor � Sidney Sales       � Data �  18/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Funcao para realizar a impressao das etiquetas na impressora��
//���          �termica datamax.                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOF0006(aItens, nTipo, cPorta, cModelo)

	//+-------------------------------------+
	//| Declara��o de vari�veis             |
	//+-------------------------------------+
	Local nTamanho := 100 
	Local lStatus  := .F.
	Local i, j
	//��������������������������������������������������������������Ŀ
	//�A variavel nImp conta a quantidade de impressoes realizadas,  �
	//�sera no max 3 pois e' a quantidade de etiquetas possiveis para�
	//�o padra atual                                                 �
	//����������������������������������������������������������������
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
	//���������������������������������������������������������Ŀ
	//�Variaveis do 'LEFT' para saber de onde inicia a impressao�
	//�����������������������������������������������������������
	Private nLPadrao1
	Private nLPadrao2
	Private cReferencia := ""	      
	Private nValor
   Private cPerg	 := "U_RIOF0006"
	Private lPromocao	:= .F.
	
	Default cPorta	 := "LPT1"
	Default cModelo := "ZEBRA"       
	
	
	//��������������������������������������������������������������������������Ŀ
	//�As variaveis variam de acordo com o tipo de etiqueta pode ser 1 a etiqueta�
	//�adesiva ou a 2 etiqueta maior                                             �
	//����������������������������������������������������������������������������
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

	//������������������������������������������������Ŀ
	//�Abre a comunicacao com a impressora de etiquetas�
	//��������������������������������������������������
	MSCBPRINTER(cModelo,cPorta,,nTamanho,.f.,,,,)
	MSCBCHKStatus(lStatus)	

	//���������������������������������������������������������Ŀ
	//�Varre o array dos itens fazendo a impressao das etiquetas�
	//�����������������������������������������������������������
	For i := 1 To Len(aItens)		
		
	  	cCodProd	:= AllTrim(aItens[i][1]) //CODIGO DO PRODUTO
	   nQtd		:= aItens[i][2] //QUANTIDADE DE ETIQUETAS		
		cDtUltCom:= StrTran(dtUltCompra(cCodProd),'/','')      
		cColecao	:= 'XXX'		      

		//��������������������������������������������������������Ŀ
		//�Seta o produto para pegar a descricao e o preco de venda�
		//����������������������������������������������������������
		SB1->(DBSETORDER(1))
		SB1->(DBSEEK(xFilial('SB1') + Padr(Alltrim(cCodProd),Len(SB1->B1_COD))))						

		//�������������������������������������������������������Ŀ
		//�Caso o campo YCODBAR esteja em branco preenche o campo �
		//�com o conteudo do codigo de barras.                    �
		//���������������������������������������������������������
		If Empty(SB1->B1_YCODBAR)
			RecLock('SB1', .F.)
				SB1->B1_YCODBAR := SB1->B1_CODBAR				   
				//�����������������������������������������������������������������������������������������������Ŀ
				//�Caso o campo codigo de barras comece com '0' eu removo o zero do codigo de barras              �
				//�Isso e' feito pq na hora leitura o leitor despreza o zero. Entao nos removemos ele e utilziamos�
				//�sempre o campo ycodbar para impressao das etiquetas que e' o campo completo                    �
				//�������������������������������������������������������������������������������������������������
				If Left(SB1->B1_CODBAR,1) == '0'
					SB1->B1_CODBAR := SubStr(SB1->B1_CODBAR, 2)
				EndIf			
			SB1->(MsUnLock())			
		EndIf						
		
		//��������������������������������������������������������������Ŀ
		//�A impressao do codigo de barras sera baseado sempre no YCODBAR�
		//����������������������������������������������������������������
		cCodBar	:=	Alltrim(SB1->B1_YCODBAR)
        cReferencia := Alltrim(SB1->B1_01DREF)

		SB4->(DbSetOrder(1))
		SB4->(DbSeek(xFilial('SB4') + SB1->B1_01PRODP))
		
		AYH->(DbSetOrder(1))

		If AYH->(DbSeek(xFilial('AYH') + SB4->B4_01COLEC))
			cColecao := AYH->AYH_YABREV
		EndIf

		//�������������������������������������Ŀ
		//�Descricao do produto e preco de venda�
		//���������������������������������������
		cTexto    := aItens[i][3]  				
		//�������������������������������������������������������������H�
		//�Verifica se esta utilizando o cenario de vendas, caso esteja�
		//�pega da tabela definida no parametro de tabela padrao       �
		//�������������������������������������������������������������H�
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

		//�������������������������������������������������������������������������Ŀ
		//�Verfica qual tipo de codigo de barras imprimir, foi necessario fazer isso�
		//�pois o cadastro migrado da Rio center, tem 2 tipos de tamanhos,          �
		//�e o cadastro do protheus ter um terceiro tamanho.                        �
		//���������������������������������������������������������������������������		
		If Len(cCodBar) >= 14
			cTipoBar	:= 'MB01'
		ElseIf Len(cCodBar) <= 7
			cTipoBar	:=	'MB07'
		ElseIf Len(cCodBar) <= 13 .AND. Len(cCodBar) > 7
			cTipoBar	:=	'MB04'			
		Endif		
      
		//�������������������������������������������������������������Ŀ
		//�Se o texto for maior que a quebra, quebra em pedacos a string�
		//���������������������������������������������������������������
		If len(Alltrim(cTexto)) > nQuebra
			cDescri1	:=	SubStr(cTexto, 1,nQuebra)
			cDescri2	:= SubStr(cTexto, nQuebra+1,nQuebra)  
			cDescri3	:= SubStr(cTexto, nQuebra*2+1,nQuebra)  			
		Else
			cDescri1	:=	Alltrim(cTexto)
			cDescri2	:=	''				
		Endif		     

		//����������������������������������������������������Ŀ
		//�Se nao tiver impresso nada ainda, inicia a impressao�
		//������������������������������������������������������
		If nImp == 0
			MSCBBEGIN(1,3,nTamanho)		
			nLeft1 := nLPadrao1
			nLeft2 := nLPadrao2
		//����������������������������������������������������������������������������Ŀ
		//�Se a quantidade de impressoes for 3, entao encerra e abre uma nova impressao�
		//������������������������������������������������������������������������������
		ElseIf nImp == 3
			nImp	:= 0
			MSCBEND()
			MSCBBEGIN(1,3,nTamanho)		
			nLeft1 := nLPadrao1
			nLeft2 := nLPadrao2
		Endif		       	

		//���������������������������������������������������Ŀ
		//�Imprime a quantidade total de etiquetas solicitadas�
		//�����������������������������������������������������
      For J := 1 To nQtd						
			//���������������������������
			//�Chama rotina de impressao�
			//���������������������������
			If cModelo == "ZEBRA"
				Imprime1()									
			Else
				Imprime2()
			Endif
			//������������������������������
			//�Adiciona a qtd de impressoes�
			//������������������������������
			nImp++						
			//���������������������������������������������������������������������������Ŀ
			//�Verifica se e' a terceira impressao, caso seja entao fecha e abre novamente�
			//�����������������������������������������������������������������������������
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

	//������������������������������������������Ŀ
	//�Se nao tiver tido a ultima impressao fecha�
	//��������������������������������������������
   If nImp <> 3
	   MSCBEND()	
   Endif

   MSCBCLOSEPRINTER()

Return   


//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |Imprime1  � Autor � Sidney Sales       � Data �  18/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Realiza realmente a impressao dos dados na etiqueta.        ��
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
Static Function Imprime1()   	
	//����������������������������������������������
	//�Caso seja do tipo 1 etiqueta colante e menor�
	//����������������������������������������������
	If _nTipo == 1		
		//������������������������������Ŀ
		//�Imprime a descricao do produto�
		//��������������������������������
		/*
		//  ALTERACAO PARA INCLUSAO DA LINHA DE REFERENCIA 2021-06-07

		MSCBSay(nLeft1,003,cDescri1,cRotacao,cTpFonte,"18")					
		//���������������������������������������������
		//�Caso tenha continuacao da descricao imprime�
		//���������������������������������������������
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,006,cDescri2,cRotacao,cTpFonte,"18")
		Endif			

		//�������������������������������������Ŀ
		//�Imprime o codigo de barras do produto�
		//���������������������������������������
		MSCBSAYBAR(nLeft2,008,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)		
		*/

     	MSCBSay(nLeft1,002,cDescri1,cRotacao,cTpFonte,"18")					
		//���������������������������������������������
		//�Caso tenha continuacao da descricao imprime�
		//���������������������������������������������
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,005,cDescri2,cRotacao,cTpFonte,"18")
		Endif			
		MSCBSay(nLeft1,008,cReferencia,cRotacao,cTpFonte,"18")
		//�������������������������������������Ŀ
		//�Imprime o codigo de barras do produto�
		//���������������������������������������
		MSCBSAYBAR(nLeft2,010,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)		

		//���������������Ŀ
		//�Imprime o valor�
		//�����������������
		MSCBSay(nLeft2,020,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"40")		
		//���������������������������������������������Ŀ
		//�Soma aos Lefts para imprimir a etique ao lado�
		//�����������������������������������������������
		nLeft1 += 035
		nLeft2 += 035
	Else		
		//����������������������������������������������
		//�Caso seja o tipo 2, a etiqueta maior de furo�
		//����������������������������������������������		

		MSCBSay(nLeft1,003,Space(3) + cColecao + Space(15) + cDtUltCom,cRotacao,cTpFonte,"21")

		//�������������������������������Ŀ
		//�Imprime o codigo do produto.   �
		//���������������������������������
		MSCBSay(nLeft1,008,cCodProd,cRotacao,cTpFonte,"32")		

		//��������������������������������
		//�Imprime a mensagem na etiqueta�
		//��������������������������������
		cMsg	:=	SuperGetMV('MS_MSGETIQ',.F.,"EM CASO DE TROCA NAO RETIRAR A ETIQUETA")
		
		//��������������������������������������������������������Ŀ
		//�Se o produto estiver em promocao imprime msg de promocao�
		//����������������������������������������������������������
		If lPromocao		
			cMsg := SuperGetMV('MS_MSGPROM',.F.,"NAO EFETUAMOS TROCA EM PRODUTO PROMOCIONAL")
		EndIf

		//���������������������������Ŀ
		//�Quebra a mensagem em partes�
		//�����������������������������
      cMsg1	:= Substr(cMsg, 1, nQuebra)
		cMsg2	:= Substr(cMsg,nQuebra+1,nQuebra)							

		//��������������������������������
		//�Imprime a mensagem na etiqueta�
		//��������������������������������
		MSCBSay(nLeft1,014,cMsg1,cRotacao,cTpFonte,"21")
		If !Empty(cMsg2)
			MSCBSay(nLeft1+2,017,cMsg2,cRotacao,cTpFonte,"21")
		Endif

		//����������������������������������������������Ŀ
		//�Imprime a descricao do produto em ate 3 linhas�
		//������������������������������������������������
		MSCBSay(nLeft1,022,cDescri1,cRotacao,cTpFonte,"21")
	
		If ! Empty(cDescri2)
			MSCBSay(nLeft1,025,cDescri2,cRotacao,cTpFonte,"21")
		Endif

		If ! Empty(cDescri3)
			MSCBSay(nLeft1,028,cDescri3,cRotacao,cTpFonte,"21")
		Endif			

		//��������������������������Ŀ
		//�Imprime o codigo de barras�
		//����������������������������
		MSCBSAYBAR(nLeft2,035,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)
//		MSCBSAYBAR(nLeft2,035,cCodBar,'R',cTipoBar,7,.F.,.T.,.F.,,2,)


		//��������������������������Ŀ
		//�Imprime o preco do produto�
		//����������������������������
		MSCBSay(nLeft2,047,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"45")   		

		//���������������������������������������������Ŀ
		//�Soma aos Lefts para imprimir a etique ao lado�
		//�����������������������������������������������
		nLeft1 += 031
		nLeft2 += 031
	Endif

Return                       



//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |Imprime2  � Autor � Sidney Sales       � Data �  18/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Realiza realmente a impressao dos dados na etiqueta.        ��
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
Static Function Imprime2()   	
	//����������������������������������������������
	//�Caso seja do tipo 1 etiqueta colante e menor�
	//����������������������������������������������
	If _nTipo == 1
		//������������������������������Ŀ
		//�Imprime a descricao do produto�
		//��������������������������������
		MSCBSay(nLeft1,022,cDescri1,cRotacao,cTpFonte,"001,001,001")					
		//MSCBSay(nLeft1,020,cDescri1,cRotacao,cTpFonte,"001,001,001")					
		//���������������������������������������������
		//�Caso tenha continuacao da descricao imprime�
		//���������������������������������������������
		If ! Empty(cDescri2)
			//MSCBSay(nLeft1,018,cDescri2,cRotacao,cTpFonte,"001,001,001")
			MSCBSay(nLeft1,020,cDescri2,cRotacao,cTpFonte,"001,001,001")
		Endif			
     	MSCBSay(nLeft1,018,cReferencia,cRotacao,cTpFonte,"001,001,001")

		//�������������������������������������Ŀ
		//�Imprime o codigo de barras do produto�
		//���������������������������������������
		MSCBSAYBAR(nLeft2,008,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)		

		//���������������Ŀ
		//�Imprime o valor�
		//�����������������
		MSCBSay(nLeft2,002,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"001,001,004")		
		//���������������������������������������������Ŀ
		//�Soma aos Lefts para imprimir a etique ao lado�
		//�����������������������������������������������
		nLeft1 += 035
		nLeft2 += 035
	Else		
		
		If cFilAnt == '0103'
			//����������������������������������������������
			//�Caso seja o tipo 2, a etiqueta maior de furo�
			//����������������������������������������������		
			MSCBSay(nLeft1+2,039,Space(3) + cColecao + ' - ' + cDtUltCom,cRotacao,cTpFonte,"001,001,003")					

			//�������������������������������Ŀ
			//�Imprime o codigo do produto.   �
			//���������������������������������
			MSCBSay(nLeft1+2,036,cCodProd,cRotacao,cTpFonte,"001,001,003")		
	
			//��������������������������������
			//�Imprime a mensagem na etiqueta�
			//��������������������������������
			cMsg	:=	SuperGetMV('MS_MSGETIQ',.F.,"EM CASO DE TROCA NAO RETIRAR A ETIQUETA")
			
			//��������������������������������������������������������Ŀ
			//�Se o produto estiver em promocao imprime msg de promocao�
			//����������������������������������������������������������
			If lPromocao		
				cMsg := SuperGetMV('MS_MSGPROM',.F.,"NAO EFETUAMOS TROCA EM PRODUTO PROMOCIONAL")
			EndIf
			
			//���������������������������Ŀ
			//�Quebra a mensagem em partes�
			//�����������������������������
	      cMsg1	:= Substr(cMsg, 1, nQuebra)
			cMsg2	:= Substr(cMsg,nQuebra+1,nQuebra)							
	
			//��������������������������������
			//�Imprime a mensagem na etiqueta�
			//��������������������������������
			MSCBSay(nLeft1+2,030,cMsg1,cRotacao,cTpFonte,"001,001,001")
			If !Empty(cMsg2)
				MSCBSay(nLeft1+2,028,cMsg2,cRotacao,cTpFonte,"001,001,001")
			Endif
	
			//����������������������������������������������Ŀ
			//�Imprime a descricao do produto em ate 3 linhas�
			//������������������������������������������������
			MSCBSay(nLeft1+3,022,cDescri1,cRotacao,cTpFonte,"001,001,001")
		
			If ! Empty(cDescri2)
				MSCBSay(nLeft1+3,020,cDescri2,cRotacao,cTpFonte,"001,001,001")
	 		Endif
	
			If ! Empty(cDescri3)
				MSCBSay(nLeft1+3,018,cDescri3,cRotacao,cTpFonte,"001,001,001")
			Endif			

			//��������������������������Ŀ
			//�Imprime o codigo de barras�
			//����������������������������
			MSCBSAYBAR(nLeft2,010,cCodBar,cRotacao,cTipoBar,5,.F.,.T.,.F.,,2,)
	
			//��������������������������Ŀ
			//�Imprime o preco do produto�
			//����������������������������
			MSCBSay(nLeft2+2,004,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"001,001,004")   		
	
			//���������������������������������������������Ŀ
			//�Soma aos Lefts para imprimir a etique ao lado�
			//�����������������������������������������������
			nLeft1 += 032
			nLeft2 += 032

		Else

			//����������������������������������������������
			//�Caso seja o tipo 2, a etiqueta maior de furo�
			//����������������������������������������������		

			MSCBSay(nLeft1+2,052,Space(3) + cColecao + ' - ' + cDtUltCom,cRotacao,cTpFonte,"001,001,003")					

			//�������������������������������Ŀ
			//�Imprime o codigo do produto.   �
			//���������������������������������
			MSCBSay(nLeft1+2,045,cCodProd,cRotacao,cTpFonte,"001,001,003")		
	
			//��������������������������������
			//�Imprime a mensagem na etiqueta�
			//��������������������������������
			cMsg	:=	SuperGetMV('MS_MSGETIQ',.F.,"EM CASO DE TROCA NAO RETIRAR A ETIQUETA")

			//��������������������������������������������������������Ŀ
			//�Se o produto estiver em promocao imprime msg de promocao�
			//����������������������������������������������������������
			If lPromocao		
				cMsg := SuperGetMV('MS_MSGPROM',.F.,"NAO EFETUAMOS TROCA EM PRODUTO PROMOCIONAL")
			EndIf		
			
			//���������������������������Ŀ
			//�Quebra a mensagem em partes�
			//�����������������������������
	      cMsg1	:= Substr(cMsg, 1, nQuebra)
			cMsg2	:= Substr(cMsg,nQuebra+1,nQuebra)							
	
			//��������������������������������
			//�Imprime a mensagem na etiqueta�
			//��������������������������������
			  //MSCBSay(nLeft1+2,037,cMsg1,cRotacao,cTpFonte,"001,001,001")
			  //If !Empty(cMsg2)
			  //	MSCBSay(nLeft1+2,034,cMsg2,cRotacao,cTpFonte,"001,001,001")
			  //Endif

			// ALTERADO PARA INCLUSAO DA REFERENCIA EM LINHA UNICA  2021-06-07
			MSCBSay(nLeft1+2,040,cMsg1,cRotacao,cTpFonte,"001,001,001")
			If !Empty(cMsg2)
				MSCBSay(nLeft1+2,037,cMsg2,cRotacao,cTpFonte,"001,001,001")
			Endif
	
			//����������������������������������������������Ŀ
			//�Imprime a descricao do produto em ate 3 linhas�
			//������������������������������������������������
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
	   		
			//��������������������������Ŀ
			//�Imprime o codigo de barras�
			//����������������������������
			MSCBSAYBAR(nLeft2,012,cCodBar,cRotacao,cTipoBar,7,.F.,.T.,.F.,,2,)

			//��������������������������Ŀ
			//�Imprime o preco do produto�
			//����������������������������
			MSCBSay(nLeft2+2,001,' R$ ' + Alltrim(Transform(nValor, '@E 999,999.99')),cRotacao,cTpFonte,"001,001,004")
	
			//���������������������������������������������Ŀ
			//�Soma aos Lefts para imprimir a etique ao lado�
			//�����������������������������������������������
			nLeft1 += 031
			nLeft2 += 031

		EndIf

	Endif

Return

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |dtUltCompra Autor � Sidney Sales       � Data �  26/02/15   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Retorna a ultima data de nota de entrada para o produto.   ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
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
