#Include "Protheus.Ch"
#Include "TopConn.Ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  |RIOCO001  º Autor ³ Glaudson Marcel    º Data ³  18/10/21   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ MarkBrowse para conferencia de produtos nos ped. compras   º±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function RIOCO001()
    Local _astru		:= {}
    Local _afields		:= {}
    Private oMark
    Private arotina 	:= {}
    Private cMark		:= GetMark()
    Private cCadastro

    aRotina   			:= { 	{ "&Incluir Pedido de Compras"	,"U_RIOCO01f(3)" , 0, 3},;
    							{ "Marcar Todos" 		,"U_RIOCO01b(1)" , 0, 4},;
    							{ "Desmarcar Todos"		,"U_RIOCO01b(2)" , 0, 4},;
    							{ "Inverter Todos"		,"U_RIOCO01b(3)" , 0, 4},;
    							{ "Confirmar" 		  	,"U_RIOCO01a" , 0, 4}}

    //³Estrutura da tabela temporaria que sera armazenar os pedidos
    AADD(_astru,{"Z1_OK"	 ,"C",02	,0})
    AADD(_astru,{"Z1_NUM"	 ,"C",15	,0})

     // --- Criar tabela temporária
      oTempTable := FWTemporaryTable():New("TRB")
      oTemptable:SetFields(_astru)
      oTempTable:AddIndex("01",{"Z1_NUM"})
      oTempTable:Create()

    DBSELECTAREA("TRB")

    //³Monta os fields da tabela e a descricao³
    AADD(_afields,{"Z1_OK"		,"",""				})
    AADD(_afields,{"Z1_NUM"		,"","Num. Pedido"	})

    DbSelectArea("TRB")
    DbGotop()

    //³Monta a tela com o MarkBrowser³
    MarkBrow( 'TRB', 'Z1_OK',,_afields,, cMark,'u_RIOCO01b(3)',,,,'u_RIOCO01f(4)',{|| u_RIOCO01b(3)},,,,,,,.F.)

    DbCloseArea()

    //³Apaga o arquivo temporario criado³
    oTempTable:Delete()
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºDescricao ³ Marca todos os registros.                                  º±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function RIOCO01b(nTipo)
    Local oMark := GetMarkBrow()
    DbSelectArea("TRB")
    DbGotop()
    While !Eof()
	IF RecLock( 'TRB', .F. )
		Do Case
            Case nTipo == 1
                TRB->Z1_OK := cMark
            Case nTipo == 2
                TRB->Z1_OK := SPACE(2)
            Case nTipo == 3
            	If IsMark( 'Z1_OK', cMark )
		            Replace Z1_OK With Space(2)
	            Else
		            Replace Z1_OK With cMark
	            EndIf
        EndCase
		MsUnLock()
	EndIf
	dbSkip()
    Enddo
    MarkBRefresh( )
    // força o posicionamento do browse no primeiro registro
    oMark:oBrowse:Gotop()
return



//  Confirmar a verificação dos pedidos de compra.
User Function RIOCO01a()
  Local aRet	:= {}

  dbSelectArea("TRB")
  TRB->(dbGoTop())

  While !Eof()
	If IsMark("Z1_OK",cMark)
	   aAdd(aRet, {TRB->Z1_NUM})
	EndIf

	TRB->(dbSkip())
  EndDo

  If Len(aRet) == 0
     Alert("Selecione pelo menos um pedido de compra para a verificação.","ATENÇÃO")
	 Return
  EndIf

  U_RIOCO01i(aRet)

Return

//±±ºDescricao ³ Funcao que abre uma tela para incluir novos produtos ou    º±±
//±±º          ³editar a quantidade dos produtos do browser                 º±±
User Function RIOCO01f(nTipo)
    Private oDlg
    Private _oPedido
    Private _cPedido	:= Space(Len(SC7->C7_NUM))
    Private _lCheck	:= .T.
    Private oCheck

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄeL¿
    //³Caso seja alteracao, entao preenche as variaveis com o conteudo³
    //³da tabela temporaria no item atual                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄeLÙ
    If nTipo == 4
    	_cPedido	:= TRB->Z1_NUM
    	_lCheck		:= ! Empty(TRB->Z1_OK)
    Endif

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Monta a tela para inclusao/alteracao³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DEFINE DIALOG oDlg TITLE "            ESCOLHA DE PEDIDO            " FROM 180,180 TO 350,400 PIXEL STYLE DS_MODALFRAME

    @ 010,005 Say "PEDIDO:" Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg
    @ 005,040 MsGet _oPedido Var _cPedido Size 50,015  COLOR CLR_BLACK PIXEL OF oDlg F3 "SC7" VALID VerPed(_cPedido, nTipo)

    @ 060,005 checkbox _oCheck Var _lCheck PROMPT "Consulta?" Size 50,015 OF oDlg PIXEL 
    @ 070,030 Button 	 "Confirmar" Size 050,12 PIXEL OF oDlg Action Grava(_cPedido, _lCheck, nTipo)

    ACTIVATE DIALOG oDlg CENTERED

Return

//±±ºDescricao ³ Funcao que fara a gravacao do produto no arquivo temporarioº±±
Static Function Grava(cPed, _lCheck, nTipo)

    SC7->(DBSETORDER(1))
    //³Verifica se digitou um produto correto³
    if SC7->(DBSEEK(xFilial('SC7') + Padr(Alltrim(cPed),Len(SC7->C7_NUM))))
		RECLOCK("TRB",Iif(nTipo == 3, .T.,.F.))
		TRB->Z1_NUM		:= SC7->C7_NUM
		TRB->Z1_OK		:= Iif(_lCheck,cMark,Space(2))

		TRB->(MSUNLOCK())

    	//³Zera as variaveis³
    	_cPedido	:= Space(Len(SC7->C7_NUM))

	    _oPedido:Refresh()
    	_oPedido:SetFocus()

    	If nTipo == 4
	    	oDlg:End()
	    Else
	    	DbSelectArea("TRB")
	    	DbGoTop()
	    Endif
    Else
	    Alert('Pedido de compras naõ cadatrado no protheus.')
    Endif

    oMark:oBrowse:Refresh()

Return



//±±ºDescricao ³ Funcao para verificar se há divergência de codigos de barras ou codigo interno 
User Function RIOCO01i(aItens)

    Local cQuery := ""
	Local cTitulo := "Pedidos de Compras com Produtos Divergentes "
	Local i := 0
    Local cCodEmp := ""
    Local cNomEmp := ""
	Local cPedidos := ""	
    Local aBloqueados := {} 
    Local aCorpo := {}
    Local aCabecalho := {}
 	
	cCodEmp := FWGrpCompany()
    cNomEmp := FWGrpName()
    If cCodEmp <> '02'
      alert( "Esse relatório verifica pedidos da FS")
      return
    ENDIF

	For i := 1 To Len(aItens)		
	 	cPedidos	:= cPedidos + "'" + AllTrim(aItens[i][1]) + "', "
    Next
          
	If cPedidos <> ""
	    cPedidos := SubStr( cPedidos, 1, len(cPedidos) - 2 )  
	Endif
    cQuery := "SELECT "
    cQuery += "   Legenda = CASE "
    cQuery += "            WHEN (SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) <> SUBSTRING(c.B1_CODBAR, LEN(c.B1_CODBAR) - 9, 9)) THEN 'COD. BARRA DIFERENTE' "
    cQuery += "            WHEN (SUBSTRING(c.B1_YCODBAR, LEN(c.B1_YCODBAR) - 9, 9) <> SUBSTRING(c.B1_CODBAR, LEN(c.B1_CODBAR) - 9, 9) AND (c.B1_YCODBAR <> '')) THEN 'INCONSISTENCIA FS' "
    cQuery += "            WHEN (SUBSTRING(b.B1_YCODBAR, LEN(b.B1_YCODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) AND (b.B1_YCODBAR <> '')) THEN 'INCONSISTENCIA RC' "
    cQuery += "            WHEN (b.B1_DESC <> c.B1_DESC) THEN 'DIVERGENCIA DESCRICAO' "
    cQuery += "            WHEN (b.B1_COD IS NULL) THEN 'PRODUTO INEXISTENTE RC' "
    cQuery += "          END, "
    cQuery += "    Pedido = a.C7_NUM, Codigo = a.C7_PRODUTO, "
    cQuery += "	   Descricao_FS = c.B1_DESC, Consulta_FS = c.B1_CODBAR, Etiqueta_FS = c.B1_YCODBAR " 
    //    cQuery += "	   , Descricao_RC = b.B1_DESC, Consulta_RC = b.B1_CODBAR, Etiqueta_RC = b.B1_YCODBAR"
    cQuery += " FROM  "
    cQuery += "    SC7020 a "
    cQuery += "	LEFT OUTER JOIN SB1010 b ON a.C7_PRODUTO = b.B1_COD AND b.D_E_L_E_T_ = '' and b.B1_MSBLQL <> 1 "
    cQuery += "	LEFT OUTER JOIN SB1020 c ON a.C7_PRODUTO = c.B1_COD AND c.D_E_L_E_T_ = '' and c.B1_MSBLQL <> 1 "
    cQuery += " WHERE "
    cQuery += " ( "
    cQuery += "         (b.B1_COD IS NULL) "
    cQuery += "      OR (ISNULL(b.B1_DESC, '') <> ISNULL(c.B1_DESC, '')) "
    cQuery += "	  OR (SUBSTRING(b.B1_YCODBAR, LEN(b.B1_YCODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) AND (b.B1_YCODBAR <> '')) "
    cQuery += "	  OR (SUBSTRING(c.B1_YCODBAR, LEN(c.B1_YCODBAR) - 9, 9) <> SUBSTRING(c.B1_CODBAR, LEN(c.B1_CODBAR) - 9, 9) AND (c.B1_YCODBAR <> '')) "
    cQuery += "	  OR (SUBSTRING(c.B1_CODBAR, LEN(c.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9)) "
    cQuery += "	 ) "
    cQuery += " AND C7_NUM in (" + cPedidos + ") "
             
    cQuery := ChangeQuery(cQuery) 
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrBloqueados", .F., .T.)

    While !Eof()  
        AADD( aBloqueados, {Legenda, Pedido, Codigo, Descricao_FS, Consulta_FS, Etiqueta_FS} )  
        AADD( aCorpo, {Legenda, Pedido, Codigo, Descricao_FS, Consulta_FS, Etiqueta_FS} )  

        dbSkip() 
    End  
	DBCloseArea()         
    // Se não houver dados no vetor abandonar rotina. 
    If Len( aBloqueados ) == 0    
        DBCloseArea() 
        Return .F.
    Endif  

    aCabecalho := {"Legenda", "Pedido", "Código", "Descrição", "Cód. Barra", "Etiqueta"}           

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 480,920 PIXEL     
    @ 15,10 SAY "Produtos Bloqueados" SIZE 140, 10 OF oDlg PIXEL  // 280   
  	// Primeira opção para montar o listbox.    
    @ 25,10 LISTBOX oLbx FIELDS HEADER "Legenda", "Pedido", "Código", "Descrição", "Cód. Barra", "Etiqueta";   
    SIZE 440,85 OF oDlg PIXEL       
               
    oLbx:SetArray( aBloqueados )   
    oLbx:bLine := {|| {aBloqueados[oLbx:nAt,1],;                       
                       aBloqueados[oLbx:nAt,2],;
                       aBloqueados[oLbx:nAt,3],;
                       aBloqueados[oLbx:nAt,4],;
                       aBloqueados[oLbx:nAt,5],;
                       aBloqueados[oLbx:nAt,6]}}
    @ 220,80  BUTTON oBtn0 PROMPT "GERAR EXCEL " SIZE 120,15 ; 
            ACTION {|| u_CriaXLS(cTitulo, aCabecalho, aCorpo)} OF oDlg PIXEL

    @ 220,280  BUTTON oBtn1 PROMPT "Fechar" SIZE 40,15 ; 
              ACTION  oDlg:End() OF oDlg PIXEL  
    ACTIVATE MSDIALOG oDlg CENTER  
    DBCloseArea()
Return .T.


//±±ºDescricao ³ Valida o produto digitado e pega o armazem padrao do produto±±
Static Function VerPed(cPedido, nTipo)
    Local lRet := .T.
    Default nTipo	:= 1

    if !Empty(cPedido)  
    	SC7->(DBSETORDER(1))
    	lRet	:= SC7->(DBSEEK(xFilial('SC7') + cPedido))  

    	If ! lRet
	    	Alert('Pedido não localizado.')
	    Endif
    EndIf
Return lRet

static function CriaXLS(cTitulo, aCabeca, aLinhas)
    //   DlgtoExcel({{"ARRAY", cTitulo, aCabeca, aLinhas}})
    Local nI := 0
    Local oExcel
    Local cArquivo    := GetTempPath()+'Relatorio.xml'
 
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
     
    //Aba 02 - Produtos
    oFWMsExcel:AddworkSheet("Relatorio")
        //Criando a Tabela
        oFWMsExcel:AddTable("Relatorio", cTitulo)

        For nI := 1 to len(aCabeca)
          oFWMsExcel:AddColumn("Relatorio",cTitulo, aCabeca[nI],1)
        Next
       
        For nI := 1 to len(aLinhas)
            oFWMsExcel:AddRow("Relatorio", cTitulo, aLinhas[nI])
        Next
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy() 
return
