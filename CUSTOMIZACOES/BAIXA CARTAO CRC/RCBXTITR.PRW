# include 'PROTHEUS.CH'
# include "TOPCONN.CH"
# include "TbiConn.ch"

// Movimentos de titulos
// nOpcao 3 Baixar 5 Cancelar Baixa
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFUNCTION  ณFCBAITIT  บAutor  ณJackson Santos             ณ  28/12/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Baixa/Cancelamento de baixa de titulos.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rio Center                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RCBXTITR(cEmpJob,cFilJob)
Local oDlg
Local oBtn1, oBtn2
Private lRet         := .F.         
Private aTitulos     := {}
Private aDadosBaixa  := {}
Private nLin         := 0
Private nOpcao       := 3   // opcao de baixa de titulo no financeiro.
Private lBegin       := .F. // Desarma a transacao.    
Private lCompensacao := .F. // executa baixa por dacao.
Private cQuery       := ""
Private lJobJob      := IsBlind()
Private nOpcx        := 0

Private oCbx,oGet1,oGet2,oGet3
Private dDtEmissao   := CTOD("  /  /  /") 
Default cEmpJob      := "01"
Default cFilJob      := "0101"


If lJobJob
    PREPARE ENVIRONMENT EMPRESA cEmpJob FILIAL cFilJob
    nOpcx := 1
else  
   dDtEmissao := DDataBase
   DEFINE MSDIALOG oDlg TITLE "Baixa de Tํtulos a Receber Rio Center" FROM C(0),C(0) TO C(220),C(450) PIXEL

   @ C(015),C(010) Say "Data Emissใo:" Size C(024),C(015) COLOR CLR_BLACK PIXEL OF oDlg
   @ C(016),C(040) MsGet oGet1 Var dDtEmissao  Size C(35),C(015) COLOR CLR_BLACK PIXEL OF oDlg

   oBtn1:=tButton():New(C(092),C(015),'Iniciar Processo',oDlg,{|| nOpcx:= 1,oDlg:End()},50,20,,,,.T.)
   oBtn2:=tButton():New(C(092),C(085),'Fechar',oDlg,{||oDlg:End()},50,20,,,,.T.)

   ACTIVATE MSDIALOG oDlg CENTERED

EndIf

If nOpcx == 1
   dDataRef := IIF(lJobJob,DDATABASE - 1,dDtEmissao)
   cQuery := " SELECT "
   cQuery += " E1_FILIAL, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_SALDO,R_E_C_N_O_ RECNOSE1 " 
   cQuery += " FROM " + RetSqlName("SE1")  + " SE1 " 
   cQuery += " WHERE SE1.D_E_L_E_T_ = '' AND SE1.E1_FILIAL  ='" + xFilial("SE1") + "' 
   cQuery += " AND SE1.E1_CLIENTE  = '010' AND SE1.E1_SALDO > 0 "
   cQuery += " AND SE1.E1_EMISSAO = '" + DTOS(dDataRef) + "' "

   IF Select("TRB") > 0
      TRB->(DbCloseArea())
   ENDIF
   TCQUERY cQuery NEW ALIAS "TRB"
   DbSelectArea("SE1")
   SE1->(DbSetOrder(1))


   // Baixa dos titulos ZRF.
   While TRB->(!Eof()) 
      SE1->(DbGoTo(TRB->RECNOSE1))
      If SE1->E1_PREFIXO + SE1->E1_NUM +SE1->E1_PARCELA  == TRB->E1_PREFIXO + TRB->E1_NUM +TRB->E1_PARCELA
         nLin++
         
         aTitulos    := {}
         aDadosBaixa := {}
         
         Aadd(aTitulos,SE1->E1_FILIAL)
         Aadd(aTitulos,SE1->E1_PREFIXO)
         Aadd(aTitulos,SE1->E1_NUM)
         Aadd(aTitulos,SE1->E1_PARCELA)
         Aadd(aTitulos,SE1->E1_TIPO)
         Aadd(aTitulos,SE1->E1_CLIENTE)
         Aadd(aTitulos,SE1->E1_LOJA)
         
         Aadd(aDadosBaixa,'CRC')
         Aadd(aDadosBaixa,'COBR')
         Aadd(aDadosBaixa,'COBRANCACR')
         Aadd(aDadosBaixa,dDataRef)
         Aadd(aDadosBaixa,'Tํtulo baixado pelo Job')
         Aadd(aDadosBaixa,SE1->E1_SALDO)
         //7
            If lJobJob
               conout("Baixa de tํutos")
               lRet := U_RCBAITIT( aTitulos, aDadosBaixa, nOpcao , lBegin, lCompensacao )
            Else
               
               Processa( {|| lRet := U_RCBAITIT( aTitulos, aDadosBaixa, nOpcao , lBegin, lCompensacao ) } ,;
                     "Aguarde, Processando as informa็๕es...Pode demorar") 
            EndIf
      EndIf
      TRB->(DbSkip())
   End
EndIf
//CLEARENV()

Return lRet


User Function RCBAITIT( aTitulos, aDadosBaixa, nOpcao , lBegin, lCompensacao )
Local lRetorno	:= .T.          
Local aFINA070	:= {}
local cLogPath          := SuperGetMV("MV_LOGPATH",.F.,"TEMP")  
Private lMsErroAuto := .F.             

Default lBegin 			:= .F.
Default lCompensacao	:= .F.

AADD(aFINA070 , {"E1_FILIAL"	,aTitulos[1]	,Nil})
AADD(aFINA070 , {"E1_PREFIXO"	,aTitulos[2]	,NIL})
AADD(aFINA070 , {"E1_NUM"    	,aTitulos[3]    ,NIL})
AADD(aFINA070 , {"E1_PARCELA"	,aTitulos[4]	,NIL})
AADD(aFINA070 , {"E1_TIPO"   	,aTitulos[5]   	,NIL})
AADD(aFINA070 , {"E1_CLIENTE"	,aTitulos[6]	,NIL})
AADD(aFINA070 , {"E1_LOJA"   	,aTitulos[7]   	,NIL})
If nOpcao == 3                                                
	If lCompensacao
		AADD(aFINA070 , {"AUTMOTBX"		, "DACAO"      	,Nil})
	Else
		AADD(aFINA070 , {"AUTMOTBX"		, "NORMAL"      	,Nil})	
		AADD(aFINA070 , {"AUTBANCO"		, aDadosBaixa[1]   	,Nil})
		AADD(aFINA070 , {"AUTAGENCIA"	, aDadosBaixa[2]   	,Nil})
		AADD(aFINA070 , {"AUTCONTA"		, aDadosBaixa[3]  	,Nil})
	EndIF		

	AADD(aFINA070 , {"AUTDTBAIXA"	, aDadosBaixa[4] 	,Nil})
	AADD(aFINA070 , {"AUTDTCREDITO"	, aDadosBaixa[4]	,Nil})
	AADD(aFINA070 , {"AUTHIST"	 	, aDadosBaixa[5]	,Nil})
	AADD(aFINA070 , {"AUTDESCONT"	, 0           		,Nil })
	AADD(aFINA070 , {"AUTACRESC"	, 0            		,Nil })
	AADD(aFINA070 , {"AUTDECRESC"	, 0            		,Nil })
	AADD(aFINA070 , {"AUTMULTA"	 	, 0            		,Nil })
	AADD(aFINA070 , {"AUTJUROS"	 	, 0            		,Nil })
	AADD(aFINA070 , {"AUTVALREC"	, aDadosBaixa[6]   	,Nil })
	AADD(aFINA070 , {"AUTTXMOEDA"	, 3	         		,Nil })		
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Baixa do Titulo                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

MSExecAuto({|x,y| FINA070(x,y)},aFINA070,nOpcao)
				
If lmsErroAuto
	If (!IsBlind()) // COM INTERFACE GRมFICA
    	MostraErro()
    Else // EM ESTADO DE JOB
		//Mensagem de erro do execauto
		cArqLog   := GetNextAlias()+".log"
		cMsgErro :=  MostraErro(cLogPath,cArqLog)
		
		//Apaga o arquivo de LOG.
		if file(cLogPath+"\"+cArqLog)
			FErase(cLogPath+"\"+cArqLog)
		endif
	endif

	lRetorno := .F.
	If lBegin						
		DisarmTransaction()
	EndIf						
EndIf

Return( lRetorno )                 
