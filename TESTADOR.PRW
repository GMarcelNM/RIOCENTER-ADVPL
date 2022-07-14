#Include "TOTVS.CH"
#Include "PROTHEUS.CH" 


User Function TESTADOR()

Local oDlg
Local cSenhaa := SPACE(20)
Local curl := ""
Local cCodEmp := ""
Local cNomEmp := ""

//Local oLbx 
Local cTitulo := "Tela para testes de Rotinas  " 

//DbSelectArea('ZZ1')
//dbSetOrder(1)

cCodEmp := FWGrpCompany()
cNomEmp := FWGrpName()
alert( "Você está na  empresa " + cCodEmp + " - " + cNomEmp)

// Monta a tela para usuário visualizar consulta. 
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 800,1800 PIXEL  
   @ 005,005 To 48,120 Label "Senha  " Pixel Of oDlg
   @ 021,013 MsGet oSenha Var cSenhaa Size 100,015 PASSWORD Of oDlg pixel //Font oFCartao
   @ 220,10  BUTTON oBtn1 PROMPT "TESTE DE FUNCIONALIDADE  " SIZE 120,15 ; 
                  ACTION {||iif(cSenhaa = "TesteTI", U_cadzz5(), Alert(cSenhaa))} OF oDlg PIXEL
//         ACTION {||iif(cSenhaa = "TesteTI", U_RIOCO001(), Alert(cSenhaa))} OF oDlg PIXEL
//         ACTION {||iif(cSenhaa = "TesteTI", U_RIORL001(), Alert(cSenhaa))} OF oDlg PIXEL
//            ACTION {||iif(cSenhaa = "TesteTI", U_Call061(), Alert(cSenhaa))} OF oDlg PIXEL
//         ACTION {||iif(cSenhaa = "TesteTI", U_ChkEstN(), Alert(cSenhaa))} OF oDlg PIXEL
//         ACTION {||iif(cSenhaa = "TesteTI", U_EXEC061(), Alert(cSenhaa))} OF oDlg PIXEL
//         ACTION {||iif(cSenhaa = "TesteTI", U_ChkBar(), Alert(cSenhaa))} OF oDlg PIXEL
//           ACTION {||alert(cCodEmp)} OF oDlg PIXEL
//         ACTION {|| U_TtM10()} OF oDlg PIXEL 
//         ACTION {|| U_ALTPROD()} OF oDlg PIXEL 
//         ACTION {|| U_RCCARGA1("D:\TEMP\teste.csv", "SB1", "B1_COD")} OF oDlg PIXEL 
//         ACTION {|| u_RCCARGA0} OF oDlg PIXEL 
//         ACTION {|| u_RC_AdCSV('', '', {})} OF oDlg PIXEL 
//         ACTION {|| u_RC_SB1('', '')} OF oDlg PIXEL 
         
   @ 220,200  BUTTON oBtn1 PROMPT "Cancelar" SIZE 40,15 ; 
         ACTION  oDlg:End() OF oDlg PIXEL  

ACTIVATE MSDIALOG oDlg CENTER  

//   DBCloseArea()
Return

user function cadzz5()
   AxCadastro("ZZ5", "Cadastro de Life Style", "VldAlt", "")
return

