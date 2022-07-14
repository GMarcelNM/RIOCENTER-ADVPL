#INCLUDE "PROTHEUS.ch"
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³BrGetDDB  º Autor ³ Guilherme Maia     º Data ³  25/08/10   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Funcao que monta o objeto de listbox do tipo getdados. Uti-º±±
//±±º          ³liza o objeto BrGetDb.                                      º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±º   DATA   ³ Programador   ³Manutencao Efetuada                         º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±º          ³               ³                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function BrGetdB2(cAlias, oDlg, aColunas, nX, nY, nWX, nHY, aCampoLeg, oFont, aLarCols)
  Local oSXS     := CLASSXS():New()       // Definição da Classe - Tabelas SX
  Local aCpoSX3  := {}
  Local nId      := 0

Default aLarCols := {}
Default aColunas	:= {}
Default nX			:= 1
Default nY			:= 1
Default nWX			:= 1
Default nHY			:= 1
Default aCampoLeg := {}
Default oFont			:= tFont():New("Arial",,20,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Selectiona tabela e ordena³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
DbSetOrder(1)
             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria objeto grade de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObj := BrGetDDB():New(nX, nY, nWX, nHY, , , , oDlg, , , , , , , oFont, , , , , .F., cAlias, .T., , .F., , , )
oObj:nLinhas := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso as colunas nao tenham sido informadas, preenche com os campos do alias³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		If  aCpoSX3[nId][18] == "S"             // SX3->X3_BROWSE
			nTam := aCpoSX3[nId][04] + 10       // SX3->X3_TAMANHO
			
			If aCpoSX3[nId][11] == "R"         // SX3->X3_CONTEXT
			   oObj:AddColumn(TCColumn():New(aCpoSX3[nId][01], &("{|| Padr(" + cAlias + "->" + aCpoSX3[nId][02] + "," + Str(nTam) + ", ' ') }") , , , , , , .F., .F., , , , .F.,))
			 elseIf aCpoSX3[nId][11] == "V"
				    oObj:AddColumn(TCColumn():New(aCpoSX3[nId][01], &("{|| Padr(" + aCpoSX3[nId][19] + "," + Str(nTam) + ", ' ') }"), , , , , , .F., .F., , , , .F.,))
			EndIf
		EndIf
	Next

/*	While !SX3->(EOF()) .And. SX3->X3_ARQUIVO == cAlias
		
		If SX3->X3_BROWSE == "S"
			nTam := SX3->X3_TAMANHO + 10
			
			If SX3->X3_CONTEXT == "R"
				oObj:AddColumn(TCColumn():New(SX3->X3_TITULO, &("{|| Padr(" + cAlias + "->" + SX3->X3_CAMPO + "," + Str(nTam) + ", ' ') }") , , , , , , .F., .F., , , , .F.,))
			Elseif SX3->X3_CONTEXT == "V"
				oObj:AddColumn(TCColumn():New(SX3->X3_TITULO, &("{|| Padr(" + SX3->X3_INIBRW + "," + Str(nTam) + ", ' ') }")                , , , , , , .F., .F., , , , .F.,))
			Endif
		Endif
			
		SX3->(DbSkip())
	EndDo
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso seja especificado as colunas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	For i := 1 To Len(aColunas)
		If Len(aColunas[i]) > 2
			nTam := aColunas[i][3]
		elseif valType(aColunas[i][2]) == "B"
			nTam := 100
		else
			nTam := Len(aColunas[i][2]) + 10
		Endif

		if len(aColunas[i]) == 4
			cPic	:= aColunas[i][4]
		else
			cPic	:= ""
		endif
		
		if valType(aColunas[i][2]) <> "B"		
			oObj:AddColumn(TCColumn():New(aColunas[i][1], &("{|| Padr(" + cAlias + "->" + aColunas[i][2] + "," + Str(nTam) + ", ' ') }"), cPic, , , ,  aLarCols[i] , .F., .F., , , , .F.,))
		else
			oObj:AddColumn(TCColumn():New(aColunas[i][1], aColunas[i][2], cPic, , , ,  aLarCols[i], .F., .F., , , , .F.,))
		endif
	Next	
Endif

oObj:Refresh()

Return oObj
