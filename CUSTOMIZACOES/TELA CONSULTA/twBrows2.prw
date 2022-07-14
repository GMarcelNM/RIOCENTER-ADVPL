#INCLUDE "PROTHEUS.ch"
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �uTwBrowse � Autor � Guilherme Maia     � Data �  04/09/12   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Funcao que monta grid utilizando Classe TWBroswe.          ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���   DATA   � Programador   �Manutencao Efetuada                         ���
//�������������������������������������������������������������������������͹��
//���          �               �                                            ���
//�������������������������������������������������������������������������ͼ��nY
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function TwBrows2(cAlias, oDlg, aColunas, nX, nY, nWX, nHY, aCampoLeg, oFont, aLarCols)
  Local oSXS     := CLASSXS():New()       // Defini��o da Classe - Tabelas SX
  Local aCpoSX3  := {}
  Local nId      := 0
 
  Default aLarCols := {}
  Default aColunas	:= {}
  Default nX		:= 1
  Default nY		:= 1
  Default nWX		:= 1
  Default nHY		:= 1
  Default aCampoLeg := {}
  Default oFont			:= tFont():New("Arial",,20,.T.)


//��������������������������Ŀ
//�Selectiona tabela e ordena�
//����������������������������
DbSelectArea(cAlias)
DbSetOrder(1)
             

//����������������������������
//�Cria objeto grade de dados�
//����������������������������
oObj := TWBrowse():New(nX, nY, nWX, nHY,,,,oDlg,,,,,,,oFont,,,,,,cAlias,,,,,,)
oObj:nLinhas := 2
//���������������������������������������������������������������������������Ŀ
//�Caso as colunas nao tenham sido informadas, preenche com os campos do alias�
//�����������������������������������������������������������������������������
If Empty(aColunas)
    oSXS:cEmpresa := cEmpAnt              // Montar a empresa
    oSXS:cSXS     := "SX3"                // Tabela da SXS
    oSXS:cTabela  := cAlias               // Tabela que quer pegar a estrutura
        
    aCpoSX3 := oSXS:Montar()
	
//	SX3->(DbSetOrder(1))
//	SX3->(DbSeek(cAlias))
	
	// Adiciona a coluna de legenda
	If Len(aCampoLeg) > 0
		oObj:AddColumn(TCColumn():New(aCampoLeg[1], &(aCampoLeg[2]), , , , , , .T., .F., , , , .F.,))
	Endif

    For nId := 1 To Len(aCpoSX3)
		If aCpoSX3[nId][18] == "S"          // SX3->X3_BROWSE
			nTam := aCpoSX3[nId][04] + 10   // SX3->X3_TAMANHO

			If '(' $ aCpoSX3[nId][01] .OR. ')' $ aCpoSX3[nId][01]       // SX3->X3_TITULO          
				apMsgInfo('N�o � permitido parentese na descricao do campo, altere isto para a consulta funcionar')
			EndIf

			If aCpoSX3[nId][11] == "R"     // SX3->X3_CONTEXT
				oObj:AddColumn(TCColumn():New(AllTrim(aCpoSX3[nId][01]), &("{|| Padr(" + cAlias + "->" + aCpoSX3[nId][02] + "," + Str(nTam) + ", ' ') }") , , , , , , .F., .F., , , , .F.,))
				oObj:ACOLUMNS[LEN(oObj:aColumns)]:CMSG := AllTrim(aCpoSX3[nId][02])				
			  elseIf aCpoSX3[nId][11] == "V"
				     oObj:AddColumn(TCColumn():New(AllTrim(aCpoSX3[nId][01]), &("{|| Padr(" + aCpoSX3[nId][19] + "," + Str(nTam) + ", ' ') }"), , , , , , .F., .F., , , , .F.,))
				     oObj:ACOLUMNS[LEN(oObj:aColumns)]:CMSG := AllTrim(aCpoSX3[nId][02])
			EndIf
		Endif
	Next
Else
	For i := 1 To Len(aColunas)
		if Len(aColunas[i]) > 2 .and.valtype(aColunas[i][3]) == "N"
			nTam := aColunas[i][3]
		elseif valType(aColunas[i][2]) == "B"
			nTam := 100
		else
			nTam := Len(&(aColunas[i][2])) + 10
		endif
		
		if valType(aColunas[i][2]) <> "B"		
			oObj:AddColumn(TCColumn():New(aColunas[i][1], &("{|| " + cAlias + "->" + aColunas[i][2] + " }"), , , , , aLarCols[i] , .F., .F., , , , .F.,))
			oObj:ACOLUMNS[LEN(oObj:aColumns)]:CMSG := AllTrim(aColunas[i][2])
		else
			oObj:AddColumn(TCColumn():New(aColunas[i][1], aColunas[i][2], , , , , aLarCols[i] , .F., .F., , , , .F.,))
			oObj:ACOLUMNS[LEN(oObj:aColumns)]:CMSG := AllTrim(aColunas[i][2])
		endif
	Next	
Endif

Return oObj	
