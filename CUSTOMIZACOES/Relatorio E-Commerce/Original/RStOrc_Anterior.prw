#include 'protheus.ch'
#include 'parmtype.ch'

user function RStOrc()
	
	Local aCombo	:= {"","Faturados","Abertos"}
	Private aRet		:= {}
	Private aParam	:= {}
	Private cTitulo	:= "Status por Orçamento"
	Private oProcess
	Private cTab	:= GetNextAlias()

	CriaTRB()

	aAdd(aParam,{1,"Data de"  ,Ctod(Space(8)),"","","","",50,.F.})
	aAdd(aParam,{1,"Data até" ,Ctod(Space(8)),"","","","",50,.F.})
	aAdd(aParam,{1,"Vendedor" ,Space(TamSx3('L1_VEND')[1]),"","","SA3","",0,.F.})
	aAdd(aParam,{2,"Status" ,1,aCombo,50,"",.F.})
	aAdd(aParam,{1,"Filial" ,Space(TamSx3('L1_FILIAL')[1]),"","","SM0","",50,.F.})

	If ParamBox(aParam,cTitulo,@aRet)
		oReport	:= MontDados(aRet)
		oreport:lparampage 	:= .F.							// Define para não imprimir a página de parâmetros
		oReport:PrintDialog()
	Endif

return

Static function MontDados(aParm)

	Local oReport

	oReport 	:= TReport():New("RSTORC",cTitulo,,{|oReport| PrintReport(oReport, aParm)},"Relatório de status por orçamento!")

	oSection1 	:= TRSection():New(oReport,'Orcamento',{"TRB"},)
	oSection1:SetTotalInLine(.F.)

	TRCell():New( oSection1, 'L1_NUM'		,'',GetSx3Cache("L1_NUM","X3_TITULO"),PesqPict('SL1','L1_NUM'),TamSx3('L1_NUM')[1],,)
	TRCell():New( oSection1, 'L1_XVENDA'	,'',GetSx3Cache("L1_XVENDA","X3_TITULO"),PesqPict('SL1','L1_XVENDA'),TamSx3('L1_XVENDA')[1],,)
	TRCell():New( oSection1, 'L1_EMISSAO'	,'',GetSx3Cache("L1_EMISSAO","X3_TITULO"),PesqPict('SL1','L1_EMISSAO'),TamSx3('L1_EMISSAO')[1],,)
	TRCell():New( oSection1, 'L1_DTLIM'		,'',GetSx3Cache("L1_DTLIM","X3_TITULO"),PesqPict('SL1','L1_DTLIM'),TamSx3('L1_DTLIM')[1],,)
	TRCell():New( oSection1, 'L1_SITUA'		,'',GetSx3Cache("L1_SITUA","X3_TITULO"),PesqPict('SL1','L1_SITUA'),TamSx3('L1_SITUA')[1],,)
	TRCell():New( oSection1, 'L1_VEND'		,'',GetSx3Cache("L1_VEND","X3_TITULO"),PesqPict('SL1','L1_VEND'),TamSx3('L1_VEND')[1],,)
	TRCell():New( oSection1, 'A3_NOME'		,'',GetSx3Cache("A3_NOME","X3_TITULO"),PesqPict('SA3','A3_NOME'),TamSx3('A3_NOME')[1],,)
	TRCell():New( oSection1, 'L1_CLIENTE'	,'',GetSx3Cache("L1_CLIENTE","X3_TITULO"),PesqPict('SL1','L1_CLIENTE'),TamSx3('L1_CLIENTE')[1],,)
	TRCell():New( oSection1, 'L1_LOJA'		,'',GetSx3Cache("L1_LOJA","X3_TITULO"),PesqPict('SL1','L1_LOJA'),TamSx3('L1_LOJA')[1],,)
	TRCell():New( oSection1, 'A1_NOME'		,'',GetSx3Cache("A1_NOME","X3_TITULO"),PesqPict('SA1','A1_NOME'),TamSx3('A1_NOME')[1],,)
	TRCell():New( oSection1, 'L1_VLRTOT'	,'',GetSx3Cache("L1_VLRTOT","X3_TITULO"),PesqPict('SL1','L1_VLRTOT'),TamSx3('L1_VLRTOT')[1],,)
	TRCell():New( oSection1, 'L1_DESCONT'	,'',GetSx3Cache("L1_DESCONT","X3_TITULO"),PesqPict('SL1','L1_DESCONT'),TamSx3('L1_DESCONT')[1],,)
	TRCell():New( oSection1, 'L1_VLRLIQ'	,'',GetSx3Cache("L1_VLRLIQ","X3_TITULO"),PesqPict('SL1','L1_VLRLIQ'),TamSx3('L1_VLRLIQ')[1],,)
	TRCell():New( oSection1, 'L1_FORMPG'	,'',GetSx3Cache("L1_FORMPG","X3_TITULO"),PesqPict('SL1','L1_FORMPG'),TamSx3('L1_FORMPG')[1],,)

	oSection1:SetColSpace(3)
	oReport:SetLandscape()
	oReport:oPage:SetPaperSize(9)
	oReport:HideHeader()


Return oReport


Static Function PrintReport(oReport,aParam)
    Local i := 0
	Local oSection := oReport:Section(1)
	Local nCont    := 0
	Local nPos     := 0
	Local aImpEmp  := {}
	Local lFirst   := .T.
	 
	nOrdem := oSection:GetOrder()

	Processa( {|| LeDados()},'Buscando dados...')
	oReport:SetMeter(TRB->(RecCount()))
	oReport:SkipLine()
	oReport:PrintText(AllTrim(FWFilName (cEmpAnt,cFilAnt)))
	oReport:SkipLine()
	
	oReport:SkipLine()
	oReport:PrintText("*** Período ...: " + aParam[1] + " a " + aParam[2])
	oReport:SkipLine()
	oSection:Init()

	TRB->(dbGoTop())
	While TRB->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf

		For i := 1 To Len(oSection:aCell)
			oSection:aCell[i]:SetBlock(&("{|| TRB->" + oSection:aCell[i]:CNAME + " }") )
		Next

		oSection:PrintLine()
		TRB->(dbSkip())

		If lFirst
			lFirst := .F.
		Else
			oSection:SetHeaderSection(.F.)
		EndIf

		oReport:IncMeter()
	EndDo

	oSection:Finish()

Return

Static Function LeDados()
	Local cQuery	:= ""
	Local cTabQry	:= GetNextAlias()
	Local nQtdReg	:= 0
	Local cTab		:= 'TRB'// Ponteiro para arquivo temporário
	Local cOperado	:= SuperGetMV("RC_OPERADO",.F.,"")
	
	cQuery	:= " SELECT L1_NUM, L1_EMISSAO, L1_DTLIM, L1_SITUA, L1_VEND, A3_NOME, L1_CLIENTE, L1_LOJA, A1_NOME,L1_VLRTOT, L1_DESCONT, L1_VLRLIQ, L1_FORMPG,L1_XVENDA FROM " + RETSQLNAME("SL1") + " L1 "
	cQuery	+= " INNER JOIN " + RETSQLNAME("SA3") + " A3 ON A3.D_E_L_E_T_ <> '*' AND A3_COD = L1_VEND AND A3_FILIAL = L1.L1_FILIAL"
	cQuery	+= " INNER JOIN " + RETSQLNAME("SA1") + " A1 ON A1.D_E_L_E_T_ <> '*' AND A1_COD = L1_CLIENTE AND A1_LOJA = L1_LOJA "
	cQuery	+= " WHERE L1.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND L1_EMISSAO BETWEEN '" + dTos(aRet[1]) + "' AND '" + dTos(aRet[2]) + "' "
//	cQuery	+= " AND L1_OPERADO IN " + FormatIn(cOperado,",") + " "
	If !Empty(aRet[3])
		cQuery	+= " AND L1_VEND = '" + aRet[3] + "' "
	ENDIF
	If !Empty(aRet[4])
		If aRet[4] == "Faturados"
			cQuery += " AND L1_SITUA = 'OK'"
		else
			cQuery += " AND L1_SITUA = ''"
		EndIf
	ENDIF
	If !Empty(aRet[5])
		cQuery	+= " AND L1_FILIAL = '" + aRet[5] + "' "
	ENDIF
	
	// Se já existir a tabela da query entao fecha
	If Select(cTabQry) > 0
		dbSelectArea(cTabQry)
		dbCloseArea()
	EndIf
	
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cTabQry, .F., .T.)
	
	Count to nQtdReg
	ProcRegua(nQtdReg)
	
	(cTabQry)->(dbGoTop())
	While !(cTabQry)->(EOF())
		RecLock(cTab,.T.)
		(cTab)->L1_NUM 	:= (cTabQry)->L1_NUM
		(cTab)->L1_XVENDA 	:= (cTabQry)->L1_XVENDA
		(cTab)->L1_EMISSAO 	:= StoD((cTabQry)->L1_EMISSAO)
		(cTab)->L1_DTLIM 	:= StoD((cTabQry)->L1_DTLIM)
		(cTab)->L1_SITUA 	:= (cTabQry)->L1_SITUA
		(cTab)->L1_VEND 	:= (cTabQry)->L1_VEND
		(cTab)->A3_NOME 	:= (cTabQry)->A3_NOME
		(cTab)->L1_CLIENTE 	:= (cTabQry)->L1_CLIENTE
		(cTab)->L1_LOJA 	:= (cTabQry)->L1_LOJA
		(cTab)->A1_NOME 	:= (cTabQry)->A1_NOME
		(cTab)->L1_VLRTOT 	:= (cTabQry)->L1_VLRTOT
		(cTab)->L1_DESCONT 	:= (cTabQry)->L1_DESCONT
		(cTab)->L1_VLRLIQ 	:= (cTabQry)->L1_VLRLIQ
		(cTab)->L1_FORMPG 	:= (cTabQry)->L1_FORMPG
		MsUnLock(cTab)
		(cTabQry)->(dbSkip())
		
		IncProc("Carregando Informações")
	EndDo
	
	nQtdReg := 0

	(cTabQry)->(dbCloseArea())
	
Return

Static Function CriaTRB()
    Local cArqTRB
	aCampos := {}

	aAdd(aCampos,{'L1_NUM'		,'C',TamSx3('L1_NUM')[1],0})
	aAdd(aCampos,{'L1_XVENDA'	,'C',TamSx3('L1_XVENDA')[1],0})
	aAdd(aCampos,{'L1_EMISSAO'	,'D',8,0})
	aAdd(aCampos,{'L1_DTLIM'	,'D',8,0})
	aAdd(aCampos,{'L1_SITUA'	,'C',12,0})
	aAdd(aCampos,{'L1_VEND'		,'C',TamSx3('L1_VEND')[1],0})
	aAdd(aCampos,{'A3_NOME'		,'C',TamSx3('A3_NOME')[1],0})
	aAdd(aCampos,{'L1_CLIENTE'	,'C',TamSx3('L1_CLIENTE')[1],0})
	aAdd(aCampos,{'L1_LOJA'		,'C',TamSx3('L1_LOJA')[1],0})
	aAdd(aCampos,{'A1_NOME'		,'C',TamSx3('A1_NOME')[1],0})
	aAdd(aCampos,{'L1_VLRTOT'	,'N',TamSx3('L1_VLRTOT')[1],TamSx3('L1_VLRTOT')[2]})
	aAdd(aCampos,{'L1_DESCONT'	,'N',TamSx3('L1_DESCONT')[1],TamSx3('L1_DESCONT')[2]})
	aAdd(aCampos,{'L1_VLRLIQ'	,'N',TamSx3('L1_VLRLIQ')[1],TamSx3('L1_VLRLIQ')[2]})
	aAdd(aCampos,{'L1_FORMPG'	,'C',TamSx3('L1_FORMPG')[1],0})

   // --- Criar tabela temporária
   // ---------------------------
    oTempTable := FWTemporaryTable():New('TRB')
    oTemptable:SetFields(aCampos)
    oTempTable:AddIndex("01",{"L1_NUM"})
    oTempTable:Create()
	
/*	If Select('TRB') > 0
		TRB->(dbCloseArea())
	EndIf

	cArqTRB := CriaTrab(aCampos,.T.)
	Use (cArqTRB) Alias TRB New Exclusive

	Index On L1_NUM To (cArqTRB)
*/
Return
