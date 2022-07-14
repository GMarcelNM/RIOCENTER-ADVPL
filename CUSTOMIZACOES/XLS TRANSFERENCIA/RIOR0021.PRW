#Include "TOTVS.CH"
#Include "PROTHEUS.CH" 
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"

/*/{Protheus.doc} RIOR0021
  Função RIOR0021
  @param não tem
  @return Não retorna nada
  @author YURY ROGENS 
  @owner RIO CENTER
  @version Protheus 11 e V12
  @since 30/08/2021 
  @sample
  Return
  @obs Rotina de Geração de Relatorio que mostra saldo por marca
  @history
  30/08/2021 - Desenvolvimento da Rotina.
/*/
User Function RIOR0021

Local aVetor := {} 
Local aCorpo := {}
Local aCabecalho:= {}  
Local oDlg 
Local oLbx 
Local cTitulo := "Geração de Arquivo em XLS" 
Local cQuery := ""
Local nTotal := 0
Local cTotal := ""
Local aItems := {}


Private aReturn := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nRadio  := 1
Private cMarca    := ""
Private cArmazem  := ""



Pergunte("U_RIOR0021", .T.) 


cMarca    := MV_PAR01
cArmazem  := MV_PAR02
AY2CUS

cQuery := "SELECT FILIAL = B2_FILIAL,DESCRICAO = B1_DESC,CODIGO = B2_COD,ARMAZEM = B2_LOCAL,QUANTIDADE = B2_QATU,RESERVADO = B2_RESERVA,PEDVEN = B2_QPEDVEN,MARCA = AY2_CODIGO,DESCRICAOMARCA = AY2_DESCR "
cQuery += "FROM " + RetSQLName ("SB1") + " A, " + RetSQLName ("SB2") + " B, " + RetSQLName ("AY2") + " C "
cQuery += "WHERE " 
cQuery += "B1_COD = B2_COD " 
cQuery += "AND B1_01CODMA = AY2_CODIGO "
cQuery += "AND B2_QATU <> 0 "
cQuery += "AND A.D_E_L_E_T_ = '' "
cQuery += "AND B.D_E_L_E_T_ = '' "
cQuery += "AND C.D_E_L_E_T_ = '' "
cQuery += "AND AY2_CODIGO= '" + cMarca + "' " 
cQuery += "AND B2_LOCAL = '" + cArmazem + "' "
cQuery += "ORDER BY B2_COD "

cQuery = ChangeQuery(cQuery) 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrestoque", .F., .T.)
aCabecalho := {"FILIAL", "CODIGO", "DESCRICAO", "ARMAZEM", "QUANTIDADE", "RESERVADO", "PEDVEN", "MARCA", "DESCRICAOMARCA"}   
   
// Carrega o vetor conforme a condição. 
While !Eof() 
  AADD( aVetor, { FILIAL, CODIGO, DESCRICAO, ARMAZEM, QUANTIDADE, RESERVADO, PEDVEN, MARCA, DESCRICAOMARCA} )
  AADD( aCorpo, { FILIAL, CODIGO, DESCRICAO, ARMAZEM, QUANTIDADE, RESERVADO, PEDVEN, MARCA, DESCRICAOMARCA} )    

     nTotal += QUANTIDADE
  dbSkip() 
End  

// Se não houver dados no vetor, avisar usuário e abandonar rotina. 
If Len( aVetor ) == 0    
  Aviso( cMarca, "Não existe dados a consultar", {"Ok"} )   
  DBCloseArea() 
  Return 
Endif  



  DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 640,1160 PIXEL     
       
  // Primeira opção para montar o listbox.    
  @ 10,10 LISTBOX oLbx FIELDS HEADER "FILIAL", "CODIGO", "DESCRICAO", "ARMAZEM", "QUANTIDADE", "RESERVADO", "PEDVEN", "MARCA", "DESCRICAOMARCA";   
  SIZE 560,270 OF oDlg PIXEL       
            
  oLbx:SetArray( aVetor )   
  oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;                       
                     aVetor[oLbx:nAt,2],;                       
                     aVetor[oLbx:nAt,3],;                       
                     aVetor[oLbx:nAt,4],;
                     aVetor[oLbx:nAt,5],;   
                     aVetor[oLbx:nAt,6],;                                                            
                     aVetor[oLbx:nAt,7],;
                     aVetor[oLbx:nAt,8],;  
                     aVetor[oLbx:nAt,9]}}    
     
  cTotal := STR(nTotal) 
  @ 280,10 SAY "Número de Registros:  " + cTotal SIZE 140, 07 OF oDlg PIXEL  // 280
  @ 290,10  BUTTON oBtn0 PROMPT "GERAR EXCEL " SIZE 120,15 ; 
            ACTION {|| u_CriaXLS(cTitulo, aCabecalho, aCorpo)} OF oDlg PIXEL
  @ 290,260  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ;   // 290
            ACTION  oDlg:End() OF oDlg PIXEL  
  ACTIVATE MSDIALOG oDlg CENTER  
      

   DBCloseArea()
Return



 
    Static function CriaXLS(cTitulo, aCabeca, aLinhas)
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

	// 01 -> X1_GRUPO   02 -> X1_ORDEM    03 -> X1_PERGUNT  04 -> X1_PERSPA  05 -> X1_PERENG
	// 06 -> X1_VARIAVL 07 -> X1_TIPO     08 -> X1_TAMANHO  09 -> X1_DECIMAL 10 -> X1_PRESEL
	// 11 -> X1_GSC     12 -> X1_VALID    13 -> X1_VAR01    14 -> X1_DEF01   15 -> X1_DEFSPA1
	// 16 -> X1_DEFENG1 17 -> X1_CNT01    18 -> X1_VAR02    19 -> X1_DEF02   20 -> X1_DEFSPA2
	// 21 -> X1_DEFENG2 22 -> X1_CNT02    23 -> X1_VAR03    24 -> X1_DEF03   25 -> X1_DEFSPA3
	// 26 -> X1_DEFENG3 27 -> X1_CNT03    28 -> X1_VAR04    29 -> X1_DEF04   30 -> X1_DEFSPA4
	// 31 -> X1_DEFENG4 32 -> X1_CNT04    33 -> X1_VAR05    34 -> X1_DEF05   35 -> X1_DEFSPA5
	// 36 -> X1_DEFENG5 37 -> X1_CNT05    38 -> X1_F3       39 -> X1_GRPSXG

				//01     02    03                  04  05  06        07   08 09  10  11   12  13          14   		15  16  17  18  19   			20  21  22  23  24   				25  26  27  28  29  				30  31  32  33  34  	 			35  36  37  38   	  39

	aAdd(aRegs, {cPerg, "01", "Marca"	, "", "", "mv_ch1", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par01", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "AY2CUS"		, ""})
	aAdd(aRegs, {cPerg, "02", "Armazem "	, "", "", "mv_ch2", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par02", "","", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "AY2CUS"		, ""})
	

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


