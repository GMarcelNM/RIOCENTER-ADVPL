#Include "TOTVS.CH"
#INCLUDE 'Protheus.ch'

/*
// FUNCAO PARA EXPORTAR TRANSFERENCIAS ENTRE ARMAZENS PARA EXCEL
*/

User Function RIORL001()
  Local oDlg 
  Local oLbx 
  Local cTitulo := "Relatório de Transferência entre Armazens " 
  Local cQuery := ""
   
  Local nTotal := 0
  Local cTotal := ""
  Local aCabecalho := {}
  Local aCorpo := {}
  Private aVetor := {} 
  Private cPerg := 'U_RIORL001'
  
  Private dDataDe 	  := CtoD("01/09/21")
  Private dDataAte	  := CtoD("03/09/21")   

  Private cFil   	  := Space(04)
  Private cArmazem	  := ""
  Private cDocumento  := ""
  
  ValidPerg()
  
  If ! (Pergunte(cPerg,.T.))
    Return
  EndIf
    
  dDataDe 	 := MV_PAR01
  dDataAte	 := MV_PAR02
  cFil	     := MV_PAR03
  cArmazemO	 := MV_PAR04   
  cArmazemD	 := MV_PAR05   
  cDocumento := MV_PAR06

  cQuery := "SELECT EMISSAO = AO.D3_EMISSAO, DOC = AO.D3_DOC, "
  cQuery += "       COD_ORI = AO.D3_COD, DESC_ORI = BO.B1_DESC, UND_ORI = AO.D3_UM, ARM_ORI = AO.D3_LOCAL, QTDE_ORI = AD.D3_QUANT,  "
  cQuery += "	      COD_DEST = AD.D3_COD, DESC_DEST = BD.B1_DESC, UND_DEST = AD.D3_UM, ARM_DEST = AD.D3_LOCAL  "
  cQuery += " FROM SD3020 AO, SB1020 BO, SD3020 AD, SB1020 BD   "
  cQuery += " WHERE AO.D3_NUMSEQ = AD.D3_NUMSEQ  "
  cQuery += " AND AO.D3_CF = 'RE4'   "
  cQuery += " AND AD.D3_CF = 'DE4'   "
  IF cFil <> ""
    cQuery += " AND AO.D3_FILIAL = '" + cFil + "'   "
  ENDIF
  IF RTRIM(cDocumento) <> ""
    cQuery += " AND AO.D3_DOC = '" + RTRIM(cDocumento) + "' " 
  ENDIF
  IF cArmazemO <> ""
    cQuery += " AND AO.D3_LOCAL = '" + cArmazemO + "'  "
  ENDIF
  IF cArmazemD <> ""
    cQuery += " AND AD.D3_LOCAL = '" + cArmazemD + "'  "
  ENDIF
  cQuery += " AND AO.D3_EMISSAO BETWEEN '" + Dtos(dDataDe) + "' AND '" + Dtos(dDataAte) + "'  "
  cQuery += " AND AO.D3_COD = BO.B1_COD  "
  cQuery += " AND AD.D3_COD = BD.B1_COD  "
  cQuery += " AND AO.D_E_L_E_T_ = ''
  cQuery += " AND BO.D_E_L_E_T_ = ''
  cQuery += " AND AD.D_E_L_E_T_ = ''
  cQuery += " AND BD.D_E_L_E_T_ = ''
  cQuery += " ORDER BY   "
  cQuery += "   AO.D3_EMISSAO, AO.D3_DOC, AO.D3_NUMSEQ "


  cQuery := ChangeQuery(cQuery) 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrVendas", .F., .T.)
          
  nTotal := 0
  // Carrega o vetor conforme a condição. 
  While !Eof()  
    AADD( aVetor, { EMISSAO, DOC, COD_ORI, DESC_ORI, UND_ORI, ARM_ORI, QTDE_ORI, COD_DEST, DESC_DEST, UND_DEST, ARM_DEST} )  
    AADD( aCorpo, { EMISSAO, DOC, COD_ORI, DESC_ORI, UND_ORI, ARM_ORI, QTDE_ORI, COD_DEST, DESC_DEST, UND_DEST, ARM_DEST} )  
    nTotal += 1
    dbSkip() 
  End  
         
  // Se não houver dados no vetor, avisar usuário e abandonar rotina. 
  If Len( aVetor ) == 0    
    Aviso( cTitulo, "Não existe dados a  consultar", {"Ok"} )   
    DBCloseArea() 
    Return 
  Endif  

  aCabecalho := {"Emissão", "Documento", "Cód. Origem", "Descrição", "Und", "Local Origem", "Quantidade", "Cód. Destino", "Descrição", "Und", "Local Destino"} 

  // Monta a tela para usuário visualizar con0sulta. 
  DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 640,1600 PIXEL     
       
  // Primeira opção para montar o listbox.    
  @ 10,10 LISTBOX oLbx FIELDS HEADER "Emissão", "Documento", "Cód. Origem", "Descrição", "Und", "Local Origem", "Quantidade", "Cód. Destino", "Descrição", "Und", "Local Destino" ;   
  SIZE 785,270 OF oDlg PIXEL       
            
  oLbx:SetArray( aVetor )   
  oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;                       
                     aVetor[oLbx:nAt,2],;                       
                     aVetor[oLbx:nAt,3],;                       
                     aVetor[oLbx:nAt,4],;
                     aVetor[oLbx:nAt,5],; 
                     aVetor[oLbx:nAt,6],;                       
                     aVetor[oLbx:nAt,7],;                       
                     aVetor[oLbx:nAt,8],;                       
                     aVetor[oLbx:nAt,9],;
                     aVetor[oLbx:nAt,10],;                                                              
                     aVetor[oLbx:nAt,11]}}  
     
  cTotal := STR(nTotal) 
  @ 280,10 SAY "Número de Registros:  " + cTotal SIZE 140, 07 OF oDlg PIXEL  // 280
  @ 290,10  BUTTON oBtn0 PROMPT "GERAR EXCEL " SIZE 120,15 ; 
            ACTION {|| u_CriaXLS(cTitulo, aCabecalho, aCorpo)} OF oDlg PIXEL  
  @ 290,380  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ;   // 290
            ACTION  oDlg:End() OF oDlg PIXEL  
  ACTIVATE MSDIALOG oDlg CENTER  
      
  DBCloseArea()

Return Nil

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


Static Function ValidPerg()
	Local aRegs := {}, i, j
	SX1->(dbSetOrder(1))

					//01     02    03                 	  04  05   06       07   08 09 10  11   	12  			  13          14   		15  16  17  18  19   			20  21  22  23  24   				25  26  27  28  29  				30  31  32  33  34  	 			35  36  37  38   	  	  39
	aAdd(aRegs, {cPerg, "01", "Dt emissao de?"		, "", "", "mv_ch1", "D", 8, 0, 00, "G", "NAOVAZIO()"	, "mv_par01", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "02", "Dt emissao ate?"		, "", "", "mv_ch2", "D", 8, 0, 00, "G", "NAOVAZIO()"	, "mv_par02", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "03", "Filial ?"				, "", "", "mv_ch3", "C", 4, 0, 00, "G", ""			 	, "mv_par03", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""			, ""})
	aAdd(aRegs, {cPerg, "04", "Armazem Origem?"				, "", "", "mv_ch4", "C", 2, 2, 00, "G", ""			 	, "mv_par04", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "NNR"			, ""})
	aAdd(aRegs, {cPerg, "05", "Armazem Destino?"			, "", "", "mv_ch5", "C", 2, 2, 00, "G", ""			 	, "mv_par05", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "NNR"			, ""})
	aAdd(aRegs, {cPerg, "06", "Documento ?"				, "", "", "mv_ch6", "C", 9, 0, 00, "G", ""			 	, "mv_par06", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""			, ""})

//	aAdd(aRegs, {cPerg, "06", "Fornec de?"				, "", "", "mv_ch6", "C", 6, 2, 00, "G", ""			 	, "mv_par06", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "SA2"			, ""})
//	aAdd(aRegs, {cPerg, "07", "Fornec Ate?"			, "", "", "mv_ch8", "C", 6, 2, 00, "G", ""			 	, "mv_par07", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "SA2"			, ""})
                                                                                                                    
//	aAdd(aRegs, {cPerg, "08", "Marca de?"				, "", "", "mv_ch6", "C", 6, 2, 00, "G", ""			 	, "mv_par08", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY2CUS"			, ""})
//	aAdd(aRegs, {cPerg, "09", "Marca Ate?"				, "", "", "mv_ch8", "C", 6, 2, 00, "G", ""			 	, "mv_par09", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY2CUS"			, ""})


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
