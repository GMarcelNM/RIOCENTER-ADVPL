#Include "TOTVS.CH"
#Include "PROTHEUS.CH" 

/*/{Protheus.doc} RIOEQL01
  Fun��o RIOEQL01
  @param n�o tem
  @return N�o retorna nada
  @author Glaudson Marcel
  @owner RIO CENTER
  @version Protheus 11 e V12
  @since 23/11/2020 
  @sample
  Return
  @obs Rotina de tela para gera��o de arquivo equals
  @history
  23/11/2020 - Desenvolvimento da Rotina.
/*/
User Function RIOEQL01()

Local aVetor := {} 
Local oDlg 
Local oLbx 
Local cTitulo := "Gera��o de arquivo de integra��o Equals " 
Local cQuery := ""
Local nTotal := 0
Local cTotal := ""
Local aItems := {}
Local cCodEmp := ""

Private nRadio := 1
Private cData := ""

//dbSelectArea("ZZ2")
//DBCloseArea()
cCodEmp := FWGrpCompany()

Pergunte("EQUALS", .T.) 
cData := DToS(MV_PAR01)

cQuery := "SELECT a.L1_FILIAL, a.L1_EMISSAO, a.L1_NUM, a.L1_CGCCLI, a.L1_MENNOTA, "
cQuery += "       b.L4_OBS, b.L4_AUTORIZ, b.L4_NSUTEF, b.L4_NUMCART, b.L4_FORMA, b.L4_FORMPG, ValorTotal = SUM(L4_VALOR), "
cQuery += "       c.A1_NOME, d.AE_BNDEQUA, d.AE_DESC, Parcelas = COUNT(*) "
cQuery += "FROM  "
cQuery += "   " + RetSQLName("SL1") + " a " // SL1010 a "
cQuery += "   LEFT OUTER JOIN " + RetSQLName("SA1") + " c ON a.L1_CLIENTE = c.A1_COD AND a.L1_LOJA = c.A1_LOJA, "
cQuery += "   " + RetSQLName("SL4") + " b "
cQuery += "   LEFT OUTER JOIN SAE010 d ON b.L4_FILIAL = d.AE_FILIAL AND SUBSTRING(b.L4_ADMINIS, 1, 3) = d.AE_COD "
cQuery += "WHERE "
cQuery += "     a.L1_FILIAL = b.L4_FILIAL "
cQuery += " AND a.L1_NUM = b.L4_NUM "
cQuery += " AND a.R_E_C_D_E_L_ = 0 "
cQuery += " AND b.R_E_C_D_E_L_ = 0 "
cQuery += " AND c.R_E_C_D_E_L_ = 0 "
cQuery += " AND d.R_E_C_D_E_L_ = 0 "
cQuery += " AND a.L1_EMISSAO = '" + cData + "'"   //  MV_PAR01 
cQuery += " AND b.L4_FORMA NOT LIKE 'R%' "
cQuery += "GROUP BY "
cQuery += "       a.L1_FILIAL, a.L1_EMISSAO, a.L1_NUM, a.L1_CGCCLI, a.L1_MENNOTA, b.L4_OBS, b.L4_AUTORIZ, b.L4_NSUTEF, "
cQuery += "	   b.L4_NUMCART, b.L4_FORMA, b.L4_FORMPG, c.A1_NOME, d.AE_BNDEQUA, d.AE_DESC"
cQuery += " "
cQuery += " UNION ALL  "
cQuery += " "
cQuery += "SELECT DISTINCT  L1_FILIAL = Z4_FILIAL, L1_EMISSAO = Z4_DATA, L1_NUM = Z4_SEQ, L1_CGCCLI = '', L1_MENNOTA = '', "
cQuery += "       L4_OBS = 'PAGTO FATURA', L4_AUTORIZ = '', L4_NSUTEF = ISNULL(Z5_NSU, ''), L4_NUMCART = '', L4_FORMA = 'CD',  "
cQuery += "	   L4_FORMPG = '', ValorTotal = Z4_DEBITO, A1_NOME = '', AE_BNDEQUA = 0, AE_DESC = '', Parcelas = 1  "
cQuery += "FROM " + RetSQLName("SZ4") + " a LEFT OUTER JOIN " + RetSQLName("SZ5") + " b ON a.Z4_PDV = b.Z5_PDV and a.Z4_SEQ = b.Z5_SEQ and a.Z4_DATA = b.Z5_DATA "
cQuery += "WHERE Z4_DATA = '" + cData + "' "
cQuery += "  AND Z4_DEBITO <> 0 "
cQuery += "  AND a.R_E_C_D_E_L_ = 0 "
cQuery += "  AND b.R_E_C_D_E_L_ = 0 "
cQuery += " "
cQuery += " UNION ALL "
cQuery += " "
cQuery += "SELECT L1_FILIAL = F2_FILIAL , L1_EMISSAO = F2_EMISSAO, L1_NUM = F2_DOC, L1_CGCCLI = A1_CGC, L1_MENNOTA = F2_MENNOTA, L4_OBS = '', L4_AUTORIZ = C5_XALTTEF, L4_NSUTEF = C5_XNSUTEF, L4_NUMCART = '',  "
cQuery += "       L4_FORMA = E4_FORMA, L4_FORMPG = '', ValorTotal = F2_VALBRUT, A1_NOME,   "
cQuery += "	   AE_BNDEQUA = E4_BNDEQU, E4_DESCRI,  "
cQuery += "	   Parcelas = CASE E4_TIPO WHEN 1 THEN LEN(E4_COND) - LEN(REPLACE(E4_COND, ',', '')) + 1  "
cQuery += "                               WHEN 5 THEN SUBSTRING(E4_COND, 4, charindex(',', SUBSTRING(E4_COND, 4, LEN(E4_COND) - 3)) - 1)   "
cQuery += "							   ELSE 1 END  "
cQuery += "FROM " + RetSQLName("SF2") + " SF2, " + RetSQLName("SA1") + " SA1, SE4010 SE4, " + RetSQLName("SC5") + " SC5 "
cQuery += "WHERE F2_DOC = C5_NOTA "
cQuery += "  AND F2_SERIE = C5_SERIE "
cQuery += "  AND F2_CLIENTE = A1_COD  "
cQuery += "  AND F2_COND = E4_CODIGO "
cQuery += "  AND E4_FORMA <> 'R$' "
cQuery += "  AND F2_EMISSAO = '" + cData + "' "
if cCodEmp = '01'
  cQuery += "  AND F2_SERIE = '2' "
Else  
  cQuery += "  AND F2_SERIE = '3' "
ENDIF
cQuery += "  AND SF2.R_E_C_D_E_L_ = 0 "
cQuery += "  AND SA1.R_E_C_D_E_L_ = 0 "
cQuery += "  AND SE4.R_E_C_D_E_L_ = 0 "
cQuery += "  AND SC5.R_E_C_D_E_L_ = 0 "
cQuery += "ORDER BY  "
cQuery += "   a.L1_FILIAL, a.L1_NUM "

cQuery := ChangeQuery(cQuery) 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrVendas", .F., .T.)


// Carrega o vetor conforme a condi��o. 
While !Eof()  
  AADD( aVetor, { L1_FILIAL, L1_NUM, A1_NOME, AE_DESC, Parcelas, ValorTotal} )  
  nTotal += ValorTotal
  dbSkip() 
End  

// Se n�o houver dados no vetor, avisar usu�rio e abandonar rotina. 
If Len( aVetor ) == 0    
  Aviso( cTitulo, "N�o existe dados a consultar", {"Ok"} )   
  DBCloseArea() 
  Return 
Endif  

cTitulo += " - " + DToC(MV_PAR01)

// Monta a tela para usu�rio visualizar consulta. 
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 480,920 PIXEL     

// Primeira op��o para montar o listbox.    
@ 35,10 LISTBOX oLbx FIELDS HEADER "Filial", "N�mero", "Nome", "Pagamento", "N� Parcelas", "Valor Total" ;   
SIZE 440,170 OF oDlg PIXEL       

oLbx:SetArray( aVetor )   
oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;                       
                   aVetor[oLbx:nAt,2],;                       
                   aVetor[oLbx:nAt,3],;                       
                   aVetor[oLbx:nAt,4],;
                   aVetor[oLbx:nAt,5],;                                          
                   aVetor[oLbx:nAt,6]}}  
  

   cTotal := Transform(nTotal, "@E 999,999.99")      // STR(nTotal, 12, 2)            

   nRadio := 1
   aItems := {'Cielo', 'Rede'}

   @ 210,350 SAY "Total das Vendas Internas: " + cTotal SIZE 140, 07 OF oDlg PIXEL
   @ 220,10  BUTTON oBtn1 PROMPT "Gerar Arquivo" SIZE 40,15 ; 
         ACTION {|| u_RIOEQL02()} OF oDlg PIXEL 
   @ 220,60  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ; 
         ACTION  oDlg:End() OF oDlg PIXEL  

   oGroup1:= TGroup():New(02,10,30,450,'Sele��o de Adquirente ',oDlg,,,.T.)         
   oRadio := TRadMenu():New (10,10,aItems,,oDlg,,,,,,,,200,10,,,.T.,.T.)
   oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

   ACTIVATE MSDIALOG oDlg CENTER  

   DBCloseArea()
Return


/*/{Protheus.doc} RIOEQL02
  Fun��o RIOEQL02
  @param pTpReg = Tipo do registro = ' ' - Venda
                                     'C' - Cancelamento
  @return N�o retorna nada
  @author Glaudson Marcel
  @version V12 e V25
  @sample
  RIOEQL02 - Fun��o para gera��o de arquivo de integra��o com equals.
  Return
  23/11/2020 - Desenvolvimento da Rotina.
/*/
User Function RIOEQL02()
  Local nSeq     := 0
  Local cBuffer  := ""
  Local cArquivo := "" 
  Local cEOL     := CHR(13)+CHR(10)
  Local cDirRec  := "C:\equals"
  Local nHdl
  Local aArea := getArea()
  Local nAux := 1


  dbSelectArea("ZZ1")
  dbSetOrder(1)
  IF dbSeek(XFilial("ZZ1")+ "SEQEQUALS")  
    nAux := VAL(ZZ1->ZZ1_VALOR) + 1
    cArquivo := AllTrim(STR(nAux))
    RecLock("ZZ1", .F.)	
    ZZ1->ZZ1_VALOR := cArquivo
    MsUnLock()     
  Else
    RecLock("ZZ1", .T.)	
    ZZ1->ZZ1_FILIAL := xFilial("ZZ1")	
    ZZ1->ZZ1_CHAVE := "SEQEQUALS"
    ZZ1->ZZ1_DESCRI := "CONTROLE SEQUENCIAL ARQUIVOS EQUALS  "
    ZZ1->ZZ1_VALOR := "1"
    MsUnLock()     
  EndIf
  
  RestArea(aArea) 
  
  cArquivo := Replicate("0", 9 - LEN(cArquivo)) + cArquivo
  cArquivo := cData + "-" + cArquivo + ".csv"
  
  If !(ExistDir(cDirRec))
    MakeDir(cDirRec)
  EndIf  
  
  If File(cDirRec + "\" + cArquivo)
    FERASE(cDirRec + "\" + cArquivo)
    nHdl := fCreate(cDirRec + "\" + cArquivo)
  else
    nHdl := fCreate(cDirRec + "\" + cArquivo)
     
    nSeq := 0
  EndIf
     

  dbGOTOP()
  while !Eof()  
    nSeq++

    cBuffer := AllTrim(Str(nSeq))                                   // 1 - NSR - N�mero sequencial do registro
    cBuffer += ";"
    cBuffer += L1_FILIAL                                     // 2 - C�digo que identifica a loja/filial onde a venda foi registrada
    cBuffer += ";"
    cBuffer += L1_EMISSAO                       // 3 - Data da venda/transa��o   // DToS(L1_EMISSAO)
    cBuffer += ";"
    cBuffer += L1_FILIAL + AllTrim(L1_NUM)                                // 4 - Identificador da venda no PROTHEUS
    cBuffer += ";"
    cBuffer += L1_FILIAL + AllTrim(L1_NUM)                       // 5 - C�digo utilizado para pesquisar facilmente a venda no Equals
    cBuffer += ";"
    cBuffer += AllTrim(A1_NOME) // 6 - Nome do Cliente
    cBuffer += ";"
    cBuffer += AllTrim(L1_CGCCLI)                     // 7 - CNPJ / CPF do Cliente 
    cBuffer += ";"
    cBuffer += AllTrim(L1_MENNOTA)                    // 8 - Observa��o da venda
    cBuffer += ";"
    cBuffer += AllTrim(L4_OBS)                        // 9 - Informa��o adicional 1 - Venda
    cBuffer += ";" 
    cBuffer += ""                                          // 10 - Informa��o adicional 2 - Venda
    cBuffer += ";"
    cBuffer += "V"                                      // 11 - "C" para indicar cancelamento, qualquer outro � venda
    cBuffer += ";"
    cBuffer += AllTrim(L1_FILIAL) + AllTrim(L1_NUM) + AllTrim(L4_NSUTEF)                      // 12 - Identificador da transa��o no PROTHEUS
    cBuffer += ";"
    cBuffer += AllTrim(L4_AUTORIZ)                             // 13 - C�digo de autoriza��o gerado pela adquirente
    cBuffer += ";"
    cBuffer += AllTrim(L4_NSUTEF)                              // 14 - NSU gerado pela adquirente ou Nosso N�mero gerado pelo banco para boletos
    cBuffer += ";"
    cBuffer += ""                                          // 15 - TID (Transaction ID) gerado pela adquirente para transa��o e-commerce
    cBuffer += ";"
    cBuffer += AllTrim(L4_NUMCART)                             // 16 - N�mero do Cart�o
    cBuffer += ";"
    cBuffer += AllTrim(STR(Parcelas))                               // 17 - Total de parcelas da transa��o
    cBuffer += ";"
    cBuffer += AllTrim(Str(nRadio))                                     // 18 - C�digo da adquirente na Equals
    cBuffer += ";"
    cBuffer += AllTrim(AE_BNDEQUA)                             // 19 - Bandeira do cart�o na Equals
    cBuffer += ";"
    cBuffer += AllTrim(L4_FORMA)                             // 20 - Formas de pagamento na Equals
    cBuffer += ";"
    cBuffer += "9"                                         // 21 - ID Meio de Captura - '9' = Outros
    cBuffer += ";"
    cBuffer += ""                                          // 22 - Observa��o - Transa��o
    cBuffer += ";"
    cBuffer += ""                                          // 23 - Informa��o adicional da transa��o de pagamento
    cBuffer += ";"
    cBuffer += ""                                          // 24 - Informa��o adicional da transa��o de pagamento
    cBuffer += ";"
    cBuffer += AllTrim(StrTran(Str(ValorTotal),".",",")) // 25 - N�meros n�o inteiros devem ser informados com v�rgula    

    fWrite(nHdl,cBuffer + cEOL)
  
    dbSkip() 
     
  End
  fClose(nHdl)

  Alert("Arquivo gerado!")

  Return


/*
User Function TestTela()

Local aVetor := {} 
Local oDlg 
Local oLbx 
Local cTitulo := "Gera��o de arquivo de integra��o Equals" 
Local cQuery := ""
Local nTotal := 0
Local cTotal := ""
Local aItems := {}

Private nRadio := 1

Pergunte("EQUALS", .T.) 

cQuery := "SELECT a.L1_FILIAL, a.L1_EMISSAO, a.L1_NUM, a.L1_CGCCLI, a.L1_MENNOTA, "
cQuery += "       b.L4_OBS, b.L4_AUTORIZ, b.L4_NSUTEF, b.L4_NUMCART, b.L4_FORMA, b.L4_FORMPG, ValorTotal = SUM(L4_VALOR), "
cQuery += "       c.A1_NOME, d.AE_BNDEQUA, d.AE_DESC, Parcelas = COUNT(*) "
cQuery += "FROM  "
cQuery += "   SL1010 a "
cQuery += "   LEFT OUTER JOIN SA1010 c ON a.L1_CLIENTE = c.A1_COD AND a.L1_LOJA = c.A1_LOJA, "
cQuery += "   SL4010 b "
cQuery += "   LEFT OUTER JOIN SAE010 d ON b.L4_FILIAL = d.AE_FILIAL AND SUBSTRING(b.L4_ADMINIS, 1, 3) = d.AE_COD "
cQuery += "WHERE "
cQuery += "     a.L1_FILIAL = b.L4_FILIAL "
cQuery += " AND a.L1_NUM = b.L4_NUM "
cQuery += " AND a.R_E_C_D_E_L_ = 0 "
cQuery += " AND b.R_E_C_D_E_L_ = 0 "
cQuery += " AND a.L1_EMISSAO = '" + DToS(MV_PAR01) + "'"   //  MV_PAR01 
cQuery += " AND b.L4_FORMA NOT LIKE 'R%' "
cQuery += "GROUP BY "
cQuery += "       a.L1_FILIAL, a.L1_EMISSAO, a.L1_NUM, a.L1_CGCCLI, a.L1_MENNOTA, b.L4_OBS, b.L4_AUTORIZ, b.L4_NSUTEF, "
cQuery += "	   b.L4_NUMCART, b.L4_FORMA, b.L4_FORMPG, c.A1_NOME, d.AE_BNDEQUA, d.AE_DESC"
cQuery += "ORDER BY  "
cQuery += "   a.L1_FILIAL, a.L1_NUM "

cQuery := ChangeQuery(cQuery) 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrVendas", .F., .T.)


// Carrega o vetor conforme a condi��o. 
While !Eof()  
  AADD( aVetor, { L1_FILIAL, L1_NUM, A1_NOME, AE_DESC, Parcelas, ValorTotal} )  
  nTotal += ValorTotal
  dbSkip() 
End  

// Se n�o houver dados no vetor, avisar usu�rio e abandonar rotina. 
If Len( aVetor ) == 0    
  Aviso( cTitulo, "N�o existe dados a consultar", {"Ok"} )    
  Return 
Endif  

cTitulo += " - " + DToC(MV_PAR01)

// Monta a tela para usu�rio visualizar consulta. 
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 480,920 PIXEL     


oTFont := TFont():New('Courier new',,-20,.T.)
//aBrowse   := {{'CLIENTE 001','RUA CLIENTE 001','BAIRRO CLIENTE 001'}, {'CLIENTE 002','RUA CLIENTE 002','BAIRRO CLIENTE 002'}, {'CLIENTE 003','RUA CLIENTE 003','BAIRRO CLIENTE 003'} }    

oBrowse := TSBrowse():New(35,10,440,170,oDlg,,16,oTFont,2)    
oBrowse:AddColumn( TCColumn():New('Filial',,,{|| },{|| }) )    
oBrowse:AddColumn( TCColumn():New('N�mero',,,{|| },{|| }) )    
oBrowse:AddColumn( TCColumn():New('Nome',,,{|| },{|| }) )    
oBrowse:AddColumn( TCColumn():New('Pagamento',,,{|| },{|| }) )    
oBrowse:AddColumn( TCColumn():New('N� Parcelas',,,{|| },{|| }) )    
oBrowse:AddColumn( TCColumn():New('Valor Total',,,{|| },{|| }) )    
oBrowse:SetArray(aVetor)  

   cTotal := Transform(nTotal, "@E 999,999.99")      // STR(nTotal, 12, 2)            

   nRadio := 1
   aItems := {'Cielo', 'Rede'}

   @ 210,350 SAY "Total das Vendas Internas: " + cTotal SIZE 140, 07 OF oDlg PIXEL
   @ 220,10  BUTTON oBtn1 PROMPT "Gerar Arquivo" SIZE 40,15 ; 
         ACTION {|| u_RIOEQL02()} OF oDlg PIXEL 
   @ 220,60  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ; 
         ACTION  oDlg:End() OF oDlg PIXEL  

   oGroup1:= TGroup():New(02,10,30,450,'Sele��o de Adquirente ',oDlg,,,.T.)         
   oRadio := TRadMenu():New (10,10,aItems,,oDlg,,,,,,,,200,10,,,.T.,.T.)
   oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

   ACTIVATE MSDIALOG oDlg CENTER  

   DBCloseArea()
Return
*/
