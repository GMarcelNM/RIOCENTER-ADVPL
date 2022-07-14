#Include "TOTVS.CH"
#INCLUDE 'Protheus.ch'

/*
// FUNCAO PRA VERIFICAR CODIGOS DE BARRAS DIFERENTES ENTRE RIOCENTER x FS
*/
User Function ChkBar()
  Local oDlg 
  Local oLbx 
  Local cTitulo := "Produtos com Códigos de Barras Divergentes " 
  Local cQuery := ""

  Local nTotal := 0
  Local cTotal := ""
  Local aCabecalho := {}
  Local aCorpo := {}
  Private aVetor := {} 


  cQuery := "SELECT " 
  cQuery += "     Rio_Codigo = a.B1_COD, Rio_Descricao = a.B1_DESC, Rio_Barra = a.B1_CODBAR, "
  cQuery += "     FS_Codigo = b.B1_COD, FS_Descricao = b.B1_DESC, FS_Barra = b.B1_CODBAR  "
  cQuery += "   FROM " 
  cQuery += "     SB1010 a, SB1020 b "
  cQuery += "   WHERE " 
  cQuery += "         a.B1_COD = b.B1_COD "
  cQuery += "     AND SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) "
  cQuery += "     AND a.R_E_C_D_E_L_ = 0 "
  cQuery += "     AND b.R_E_C_D_E_L_ = 0 AND a.B1_MSBLQL <> 1 AND b.B1_MSBLQL <> 1"
  //  cQuery += "     AND a.B1_COD LIKE '04021576%'"

  cQuery := ChangeQuery(cQuery) 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrVendas", .F., .T.)
          
  nTotal := 0
  // Carrega o vetor conforme a condição. 
  While !Eof()  
    AADD( aVetor, { Rio_Codigo, Rio_Descricao, Rio_Barra, FS_Codigo, FS_Descricao, FS_Barra} )  
    AADD( aCorpo, { Rio_Codigo, Rio_Descricao, Rio_Barra, FS_Codigo, FS_Descricao, FS_Barra} )  
    nTotal += 1
    dbSkip() 
  End  
         
  // Se não houver dados no vetor, avisar usuário e abandonar rotina. 
  If Len( aVetor ) == 0    
    Aviso( cTitulo, "Não existe dados a  consultar", {"Ok"} )   
    DBCloseArea() 
    Return 
  Endif  

  aCabecalho := {"Código RC", "Descrição RC", "Cód. Barras RC", "Código FS", "Descrição FS", "Cód. Barras FS"} 

  // Monta a tela para usuário visualizar consulta. 
  DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 640,1600 PIXEL     
       
  // Primeira opção para montar o listbox.    
  @ 10,10 LISTBOX oLbx FIELDS HEADER "Código RC", "Descrição RC", "Cód. Barras RC", "Código FS", "Descrição FS", "Cód. Barras FS" ;   
  SIZE 785,270 OF oDlg PIXEL       
            
  oLbx:SetArray( aVetor )   
  oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;                       
                     aVetor[oLbx:nAt,2],;                       
                     aVetor[oLbx:nAt,3],;                       
                     aVetor[oLbx:nAt,4],;
                     aVetor[oLbx:nAt,5],;                                          
                     aVetor[oLbx:nAt,6]}}  
     
  cTotal := STR(nTotal) 
  @ 280,10 SAY "Número de Registros:  " + cTotal SIZE 140, 07 OF oDlg PIXEL  // 280
  @ 290,10  BUTTON oBtn0 PROMPT "GERAR EXCEL " SIZE 120,15 ; 
            ACTION {|| u_CriaXLS(cTitulo, aCabecalho, aCorpo)} OF oDlg PIXEL  
  @ 290,380  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ;   // 290
            ACTION  oDlg:End() OF oDlg PIXEL  
  ACTIVATE MSDIALOG oDlg CENTER  
      
  DBCloseArea()

Return Nil


/*
// FUNCAO PRA VERIFICAR ESTOQUES NEGATIVOS NA SB2
*/
User Function ChkEstN()
  Local oDlg 
  Local oLbx 
  Local cTitulo := "Produtos com Estoque Negativo no Protheus " 
  Local cQuery := ""

  Local nTotal := 0
  Local cTotal := ""
  Local aCabecalho := {}
  Local aCorpo := {} 
  Private aVetor := {} 
  


  cQuery := " SELECT  "
  cQuery += "     Empresa ='RIO CENTER', Codigo = a.B1_COD, Descricao = a.B1_DESC, CodBarra = a.B1_CODBAR, Filial = b.B2_FILIAL, Local = b.B2_LOCAL, Quantidade = b.B2_QATU "
  cQuery += " FROM SB1010 a, SB2010 b "
  cQuery += " WHERE a.B1_COD = b.B2_COD "
  cQuery += "   AND b.B2_QATU < 0 "
  cQuery += "  AND a.R_E_C_D_E_L_ = 0 "
  cQuery += "   AND b.R_E_C_D_E_L_ = 0 "
  cQuery += "   AND a.B1_MSBLQL <> 1 "
  cQuery += "  "
  cQuery += " UNION  "
  cQuery += "  "
  cQuery += " SELECT  "
  cQuery += "      Empresa ='FS', Codigo = a.B1_COD, Descricao = a.B1_DESC, CodBarra = a.B1_CODBAR, Filial = b.B2_FILIAL, Local = b.B2_LOCAL, Quantidade = b.B2_QATU "
  cQuery += " FROM SB1020 a, SB2020 b "
  cQuery += " WHERE a.B1_COD = b.B2_COD "
  cQuery += "   AND b.B2_QATU < 0 "
  cQuery += "   AND a.R_E_C_D_E_L_ = 0 "
  cQuery += "   AND b.R_E_C_D_E_L_ = 0 "
  cQuery += "   AND a.B1_MSBLQL <> 1 "
  cQuery += " ORDER BY Empresa, B2_FILIAL, B2_LOCAL "

  cQuery := ChangeQuery(cQuery) 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrVendas", .F., .T.)
          
  nTotal := 0
  // Carrega o vetor conforme a condição. 
  While !Eof()  
    AADD( aVetor, { Empresa, Codigo, Descricao, CodBarra, Filial, Local, Quantidade} )  

    AADD( aCorpo, { Empresa, Codigo, Descricao, CodBarra, Filial, Local, Quantidade} )  
    nTotal += 1
    dbSkip() 
  End  
         
  // Se não houver dados no vetor, avisar usuário e abandonar rotina. 
  If Len( aVetor ) == 0    
    Aviso( cTitulo, "Não existe dados a  consultar", {"Ok"} )   
    DBCloseArea() 
    Return 
  Endif  

  aCabecalho := {"Empresa", "Código", "Descrição", "Cód. Barra", "Filial", "Armazém", "Quantidade"}           
  // Monta a tela para usuário visualizar consulta. 
  DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 640,1160 PIXEL     
       
  // Primeira opção para montar o listbox.    
  @ 10,10 LISTBOX oLbx FIELDS HEADER "Empresa", "Código", "Descrição", "Cód. Barra", "Filial", "Armazém", "Quantidade" ;   
  SIZE 560,270 OF oDlg PIXEL       
            
  oLbx:SetArray( aVetor )   
  oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;                       
                     aVetor[oLbx:nAt,2],;                       
                     aVetor[oLbx:nAt,3],;                       
                     aVetor[oLbx:nAt,4],;
                     aVetor[oLbx:nAt,5],;   
                     aVetor[oLbx:nAt,6],;                                                            
                     aVetor[oLbx:nAt,7]}}  
     
  cTotal := STR(nTotal) 
  @ 280,10 SAY "Número de Registros:  " + cTotal SIZE 140, 07 OF oDlg PIXEL  // 280
  @ 290,10  BUTTON oBtn0 PROMPT "GERAR EXCEL " SIZE 120,15 ; 
            ACTION {|| u_CriaXLS(cTitulo, aCabecalho, aCorpo)} OF oDlg PIXEL
  @ 290,260  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ;   // 290
            ACTION  oDlg:End() OF oDlg PIXEL  
  ACTIVATE MSDIALOG oDlg CENTER  
      
  DBCloseArea()

Return Nil

user function CriaXLS(cTitulo, aCabeca, aLinhas)
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
