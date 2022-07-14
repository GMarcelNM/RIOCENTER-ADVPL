#Include "TOTVS.CH"
//#INCLUDE "RWMAKE.CH"
//#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'parmtype.ch'
//#INCLUDE 'FWMVCDef.ch'

User Function AltCBar()

Private lMsErroAuto := .F.

  alert("entrei")
      AxCadastro("ZZ4","CADASTRODEUSUARIO",".T.", ".T.")


alert("excluida")
/*
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1") + "10220001002021"))   // se o produto nao for de grade consigo alterar caso seja de grade a MATA010 nao o encontra!
   ALERT(SB1->B1_DESC)

 oModel := FwLoadModel ("MATA010")
 oModel:SetOperation(MODEL_OPERATION_UPDATE)
 oModel:Activate()
 oModel:LoadValue("SB1MASTER","B1_CODBAR","109978")

If oModel:VldData()
 oModel:CommitData()
 MsgInfo("Registro ALTERADO!", "Atenção")
 Else
 VarInfo("",oModel:GetErrorMessage())
 EndIf

 oModel:DeActivate()
Else
 MsgInfo("Registro NAO LOCALIZADO!", "Atenção")
EndIf
*/
Return 


User Function AltCBar2()

  Local oDlg 
  Local oLbx 
  Local cTitulo := "Alteracao Barras Erradas " 
  Local cQuery := ""
  Local cCodEmp := ""
  Local nTotal := 0
  Local cTotal := ""
  Private aVetor := {} 


  //cCodEmp := FWCodEmp()
  cCodEmp := FWGrpCompany()
//  cCodEmp := FWGrpName()
  alert(cCodEmp)


  cQuery := "SELECT   " 
  cQuery += "     Rio_Codigo = a.B1_COD, Rio_Descricao = a.B1_DESC, Rio_Barra = a.B1_CODBAR, "
  cQuery += "     FS_Codigo = b.B1_COD,  FS_Descricao = b.B1_DESC, FS_Barra = b.B1_CODBAR  "
  cQuery += "   FROM " 
  cQuery += "     SB1010 a, SB1020 b "
  cQuery += "   WHERE " 
  cQuery += "         a.B1_COD = b.B1_COD  "
  cQuery += "     AND SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) "
  cQuery += "     AND a.R_E_C_D_E_L_ = 0 "
  cQuery += "     AND b.R_E_C_D_E_L_ = 0 "
  cQuery += "	   AND a.B1_MSBLQL <> 1 "
	cQuery += "   AND b.B1_MSBLQL <> 1 "
//  cQuery += "     AND (a.B1_COD LIKE '09510017%')"
  cQuery += "ORDER BY a.B1_COD "

  cQuery := ChangeQuery(cQuery) 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrVendas", .F., .T.)
          
  nTotal := 0
  // Carrega o vetor conforme a condição. 
  While !Eof()  
    AADD( aVetor, { Rio_Codigo, Rio_Descricao, Rio_Barra, FS_Codigo, FS_Descricao, FS_Barra} )  
    nTotal += 1
    dbSkip() 
  End  
         
  // Se não houver dados no vetor, avisar usuário e abandonar rotina. 
  If Len( aVetor ) == 0    
    Aviso( cTitulo, "Não existe dados a  consultar", {"Ok"} )   
    DBCloseArea() 
    Return 
  Endif  
              
  // Monta a tela para usuário visualizar consulta. 
  DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 480,920 PIXEL     
       
  // Primeira opção para montar o listbox.    
  @ 35,10 LISTBOX oLbx FIELDS HEADER "Rio_Codigo", "Rio_Descricao", "Rio_Barra", "FS_Codigo", "FS_Descricao", "FS_Barra" ;   
  SIZE 440,170 OF oDlg PIXEL       
            
  oLbx:SetArray( aVetor )   
  oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;                       
                     aVetor[oLbx:nAt,2],;                       
                     aVetor[oLbx:nAt,3],;                       
                     aVetor[oLbx:nAt,4],;
                     aVetor[oLbx:nAt,5],;                                          
                     aVetor[oLbx:nAt,6]}}  
     
  cTotal := STR(nTotal) 
  @ 210,350 SAY "Número de Registros:  " + cTotal SIZE 140, 07 OF oDlg PIXEL
  @ 220,10  BUTTON oBtn1 PROMPT "Gerar Arquivo" SIZE 40,15 ; 
            ACTION {|| u_AltCBar3()} OF oDlg PIXEL 
  @ 220,60  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ; 
            ACTION  oDlg:End() OF oDlg PIXEL  
  ACTIVATE MSDIALOG oDlg CENTER  
      
  DBCloseArea()
Return Nil


User Function AltCBar3()
Local cBarra := ""
Local cData := Dtos(Date())
Local cHora := Time()
Local nI := 0
Local cQuery2 := ""

  cQuery2 := " select * fROM SB1020 WHERE B1_CODBAR IN (  SELECT a.B1_CODBAR  " 
  cQuery2 += "   FROM SB1010 a, SB1020 b WHERE a.B1_COD = b.B1_COD "
  cQuery2 += "     AND SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) "
  cQuery2 += "     AND a.R_E_C_D_E_L_ = 0 AND b.R_E_C_D_E_L_ = 0 AND a.B1_MSBLQL <> 1 AND b.B1_MSBLQL <> 1) "
	cQuery2 += "   AND B1_COD NOT IN (SELECT a.B1_COD FROM SB1010 a, SB1020 b WHERE a.B1_COD = b.B1_COD "
  cQuery2 += "     AND SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) "
  cQuery2 += "     AND a.R_E_C_D_E_L_ = 0 AND b.R_E_C_D_E_L_ = 0 AND a.B1_MSBLQL <> 1 AND b.B1_MSBLQL <> 1) "
  cQuery2 += " "
  cQuery2 += "      UNION	    "
  cQuery2 += " "
  cQuery2 += " select * fROM SB1010 WHERE B1_CODBAR IN (  SELECT a.B1_CODBAR  " 
  cQuery2 += "   FROM SB1010 a, SB1020 b WHERE a.B1_COD = b.B1_COD "
  cQuery2 += "     AND SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) "
  cQuery2 += "     AND a.R_E_C_D_E_L_ = 0 AND b.R_E_C_D_E_L_ = 0 AND a.B1_MSBLQL <> 1 AND b.B1_MSBLQL <> 1) "
	cQuery2 += "   AND B1_COD NOT IN (SELECT a.B1_COD FROM SB1010 a, SB1020 b WHERE a.B1_COD = b.B1_COD "
  cQuery2 += "     AND SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) "
  cQuery2 += "     AND a.R_E_C_D_E_L_ = 0 AND b.R_E_C_D_E_L_ = 0 AND a.B1_MSBLQL <> 1 AND b.B1_MSBLQL <> 1) "

  cQuery2 := ChangeQuery(cQuery2) 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery2), "qrVendas2", .F., .T.)
          
  nTotal := 0
  // Carrega o vetor conforme a condição. 
  if !Eof() 
    Aviso( cTitulo, "Existem códigos de barras duplicados!", {"Ok"} )   
    DBCloseArea() 
    Return 
  Endif      
  DBCloseArea() 

  alert("entrei")
  DbSelectArea("SB1")
  DbSetOrder(1)

  for nI := 1 to len(aVetor)  
    //alert(aVetor[nI][1])
    If DbSeek(xFilial("SB1") + aVetor[nI][1])
      RecLock("SB1", .F.)	
      cBarra := aVetor[nI][3]
     // alert(cBarra)
//      SB1->B1_CODBAR := SB1->B1_YCODBAR
      SB1->B1_CODBAR := cBarra
      SB1->B1_YCODBAR := cBarra
      SB1->B1_MSEXP := cData
      SB1->B1_HREXP := cHora
      MsUnLock() 
    EndIf
  next

   alert("passei")
Return Nil

user function gmnm()
  Local aRet     := {.T.,""}
  Local xRet
  Local oWsdl 
 
 // --- Acessar WebService (Soap) 
  oWsdl := TWsdlManager():New()
  oWsdl:nTimeout := 120

/* 
//  aRet[01] := oWsdl:ParseURL('http://192.168.102.186/WSFIDELIZPDV_WEB/awws/nsfideliz.awws?wsdl')
  aRet[01] := oWsdl:ParseURL('http://webservice.correios.com.br/service/rastro/Rastro.wsdl')
  
  If ! aRet[01]
     MsgInfo("Administradora fora - http://webservice.correios.com.br/service/rastro/Rastro.wsdl, Erro - " + oWsdl:cError,"CARTÃO RIO CENTER")
     Return aRet 
  else
     MsgInfo("deu certo ","CARTÃO RIO CENTER")
        
  EndIf
 */

  oWsdl:lSSLInsecure := .T.
  If xRet := ! oWsdl:ParseURL('http://webservice.correios.com.br/service/rastro/Rastro.wsdl')
     MsgInfo("Administradora fora - http://webservice.correios.com.br/service/rastro/Rastro.wsdl, Erro - " + oWsdl:cError,"CARTÃO RIO CENTER")
     Return xRet

  else
     MsgInfo("deu certo ","CARTÃO RIO CENTER")
        
  EndIf
 
Return Nil
