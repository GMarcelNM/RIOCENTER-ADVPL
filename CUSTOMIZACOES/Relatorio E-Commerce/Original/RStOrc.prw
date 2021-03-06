#include 'protheus.ch'
#include 'parmtype.ch'

user function RStOrc()
	
	Local aCombo	:= {"","Faturados","Abertos"}
	Private aRet		:= {}
	Private aParam	:= {}
	Private cTitulo	:= "Status por Or?amento"
	Private oProcess
	Private cTab	:= GetNextAlias()
	Private cTabDesc := 'TRB'// Ponteiro para arquivo tempor?rio


	CriaTRB()

	aAdd(aParam,{1,"Data de"  ,Ctod(Space(8)),"","","","",50,.F.})
	aAdd(aParam,{1,"Data at?" ,Ctod(Space(8)),"","","","",50,.F.})
	aAdd(aParam,{1,"Vendedor" ,Space(TamSx3('L1_VEND')[1]),"","","SA3","",0,.F.})
	aAdd(aParam,{2,"Status" ,"1",aCombo,50,"",.F.})
	aAdd(aParam,{1,"Filial" ,Space(TamSx3('L1_FILIAL')[1]),"","","SM0","",50,.F.})

	If ParamBox(aParam,cTitulo,@aRet)
		oReport	:= MontDados(aRet)
		oreport:lparampage 	:= .F.							// Define para n?o imprimir a p?gina de par?metros
		oReport:PrintDialog()
	Endif

return

Static function MontDados(aParm)

	Local oReport

	oReport 	:= TReport():New("RSTORC",cTitulo,,{|oReport| PrintReport(oReport, aParm)},"Relat?rio de status por or?amento!")

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
	oReport:PrintText("*** Per?odo ...: " + aParam[1] + " a " + aParam[2] + " - " + cValtoChar(TRB->(RecCount())))
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
	Local cQuery	:= " "
//	Local cTabQry	:= GetNextAlias()
	Local nQtdReg	:= 0
//	Local cTab		:= 'TRB'// Ponteiro para arquivo tempor?rio
	Local cOperado	:= SuperGetMV("RC_OPERADO",.F.,"")
	
    Aviso( dTos(aRet[1]), "N?o existe dados a  consultar", {"Ok"} ) 
    Aviso( dTos(aRet[2]), "N?o existe dados a  consultar", {"Ok"} ) 
    Aviso( aRet[3], "N?o existe dados a  consultar", {"Ok"} ) 
    Aviso( cvaltochar(aRet[4]), " testando", {"Ok"} ) 
    Aviso( aRet[5], " testando", {"Ok"} ) 

	cQuery	:= " SELECT L1_NUM, L1_EMISSAO, L1_DTLIM, L1_SITUA, L1_VEND, A3_NOME, L1_CLIENTE, L1_LOJA, A1_NOME,L1_VLRTOT, L1_DESCONT, L1_VLRLIQ, L1_FORMPG,L1_XVENDA FROM " + RETSQLNAME("SL1") + " L1 "
	cQuery	+= " INNER JOIN " + RETSQLNAME("SA3") + " A3 ON A3.D_E_L_E_T_ <> '*' AND A3_COD = L1_VEND AND A3_FILIAL = L1.L1_FILIAL"
	cQuery	+= " INNER JOIN " + RETSQLNAME("SA1") + " A1 ON A1.D_E_L_E_T_ <> '*' AND A1_COD = L1_CLIENTE AND A1_LOJA = L1_LOJA "
	cQuery	+= " WHERE L1.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND L1_EMISSAO BETWEEN '" + dTos(aRet[1]) + "' AND '" + dTos(aRet[2]) + "' "
//	cQuery	+= " AND L1_OPERADO IN " + FormatIn(cOperado,",") + " "

    Aviso( "teste 1", "N?o existe dados a  consultar", {"Ok"} ) 

	If !Empty(aRet[3])
		cQuery	+= " AND L1_VEND = '" + aRet[3] + "' "
	ENDIF
    Aviso( "teste 2", "N?o existe dados a  consultar", {"Ok"} ) 
	If !Empty(aRet[4])
    Aviso( cvaltochar(aRet[4]), " testando", {"Ok"} ) 
//		If aRet[4] == "Faturados"
		If aRet[4] == "1"
			cQuery += " "
		elseif aRet[4] == "Faturados"
			cQuery += " AND L1_SITUA = 'OK'"
		else
			cQuery += " AND L1_SITUA = ''"
		EndIf
	ENDIF
    Aviso( "passou", "N?o existe dados a  consultar", {"Ok"} ) 
	If !Empty(aRet[5])
	    Aviso( aRet[5], "N?o existe dados a  consultar", {"Ok"} ) 
		cQuery	+= " AND L1_FILIAL = '" + aRet[5] + "' "
	ENDIF
		    Aviso( "antes antes", "N?o existe dados a  consultar", {"Ok"} ) 
	
	// Se j? existir a tabela da query entao fecha
//	If Select(cTabQry) > 0
//		dbSelectArea(cTabQry)
//		dbCloseArea()
//	EndIf
		    Aviso( "antes", "N?o existe dados a  consultar", {"Ok"} ) 

	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "cTabQry", .F., .T.)
		    Aviso( "depois", "N?o existe dados a  consultar", {"Ok"} ) 
	
	Count to nQtdReg
	ProcRegua(nQtdReg)
	
	Aviso( cValToChar(nQtdReg), "N?o existe dados a  consultar", {"Ok"} ) 

	dbGoTop()
	While !EOF()
		RecLock(TRB,.T.)
		(TRB)->L1_NUM 	:= L1_NUM
		(TRB)->L1_XVENDA 	:= L1_XVENDA
		(TRB)->L1_EMISSAO 	:= StoD(L1_EMISSAO)
		(TRB)->L1_DTLIM 	:= StoD(L1_DTLIM)
		(TRB)->L1_SITUA 	:= L1_SITUA
		(TRB)->L1_VEND 	:= L1_VEND
		(TRB)->A3_NOME 	:= A3_NOME
		(TRB)->L1_CLIENTE 	:= L1_CLIENTE
		(TRB)->L1_LOJA 	:= L1_LOJA
		(TRB)->A1_NOME 	:= A1_NOME
		(TRB)->L1_VLRTOT 	:= L1_VLRTOT
		(TRB)->L1_DESCONT 	:= L1_DESCONT
		(TRB)->L1_VLRLIQ 	:= L1_VLRLIQ
		(TRB)->L1_FORMPG 	:= L1_FORMPG
		MsUnLock(TRB)
		dbSkip()
		
		IncProc("Carregando Informa??es")
	EndDo
	
	nQtdReg := 0

	dbCloseArea()

/*	
	(cTabQry)->(dbGoTop())
	While !(cTabQry)->(EOF())
		RecLock(TRB,.T.)
		(TRB)->L1_NUM 	:= (cTabQry)->L1_NUM
		(TRB)->L1_XVENDA 	:= (cTabQry)->L1_XVENDA
		(TRB)->L1_EMISSAO 	:= StoD((cTabQry)->L1_EMISSAO)
		(TRB)->L1_DTLIM 	:= StoD((cTabQry)->L1_DTLIM)
		(TRB)->L1_SITUA 	:= (cTabQry)->L1_SITUA
		(TRB)->L1_VEND 	:= (cTabQry)->L1_VEND
		(TRB)->A3_NOME 	:= (cTabQry)->A3_NOME
		(TRB)->L1_CLIENTE 	:= (cTabQry)->L1_CLIENTE
		(TRB)->L1_LOJA 	:= (cTabQry)->L1_LOJA
		(TRB)->A1_NOME 	:= (cTabQry)->A1_NOME
		(TRB)->L1_VLRTOT 	:= (cTabQry)->L1_VLRTOT
		(TRB)->L1_DESCONT 	:= (cTabQry)->L1_DESCONT
		(TRB)->L1_VLRLIQ 	:= (cTabQry)->L1_VLRLIQ
		(TRB)->L1_FORMPG 	:= (cTabQry)->L1_FORMPG
		MsUnLock(TRB)
		(cTabQry)->(dbSkip())
		
		IncProc("Carregando Informa??es")
	EndDo
	
	nQtdReg := 0

	(cTabQry)->(dbCloseArea())
*/	
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

   // --- Criar tabela tempor?ria
   // ---------------------------
    oTempTable := FWTemporaryTable():New(cTabDesc)
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
