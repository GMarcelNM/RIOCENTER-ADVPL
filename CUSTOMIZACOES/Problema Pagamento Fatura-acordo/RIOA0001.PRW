#Include "PROTHEUS.CH"
#Include "LOJXTEF.CH" 
#Include "autodef.ch"
#Include "TBICONN.CH"
#Include "POSCSS.CH"
#Include "FWPRINTSETUP.CH"
#Include "RPTDEF.CH"

/*/{Protheus.doc} RIOA0001
Função RIOA0001
@param Recebe parâmetros
@return Confirmação
@author Totvs Nordeste
@owner Totvs S/A
@version Protheus 11 e V12
@since 30/05/2018 
@sample
// RIOA0001 - Função pra pagamento de fatura cartão Rio Center
U_RIOA0001()
Return
@obs Rotina Pagamento Fatura
@project 
@history
30/05/2018 - Desenvolvimento da Rotina.
/*/
User Function RIOA0001()
  Local oFWLayer, oFWLayTop, oFWLayBot
   
  Private cResult    := Space(300)
  Private lConsultou := .F.
  Private nPosCPF    := 0
  Private nPosVlr    := 0
  Private nPosFPg    := 0
  Private nPosNEm    := 0
  Private nPosTEm    := 0
  Private nPosBco    := 0
  Private nPosDBc    := 0
  Private nPosAge    := 0
  Private nPosCta    := 0
  Private nPosDCt    := 0
  Private nPosNCq    := 0
  Private nPosCom    := 0
  Private nPosNSU    := 0
  Private nVlaRec    := 0
  Private nVlReci    := 0
  Private nVlEsp     := 0
  Private cCartao    := Space(19)
  Private cCliente   := ""
  Private dVencto    := CToD("  /  /  ")
  Private nVlrMin    := 0
  Private nVlrCartao := 0
  Private cEnvSoap   := ""
  Private aAux       := {}
  Private aHeadCad	:= {}
  Private aHeadRec   := {}
  Private aColsRec   := {}
  Private aDados     := {}
  Private oDlg, oResult	

 // ---- Definição Grid de Cartões
 // ------------------------------ 
  aAdd(aHeadCad,{"Cartão"	 ,"Cartao"  ,""			    ,13,0,"","û","C","","V",,,".F."})
  aAdd(aHeadCad,{"Vencimento","vencto"  ,""		        ,10,0,"","û","C","","V",,,".F."})
  aAdd(aHeadCad,{"Vlr Cartão","vlCartao","@E 999,999.99",10,2,"","û","N","","V",,,".F."})
  aAdd(aHeadCad,{"Vlr Mínimo","vlMinimo","@E 999,999.99",10,2,"","û","N","","V",,,".F."})
  aAdd(aHeadCad,{"Vlr Pago"  ,"vlPago"  ,"@E 999,999.99",10,2,"U_fn001Tot(1)","û","N","","V",,,".T."})
  aAdd(aHeadCad,{"Cliente"   ,"cliente" ,"@!"           ,30,0,"","û","C","","V",,,".F."})
	
  aDados := {{Space(20),Space(10),0,0,0,Space(30),.F.}}

 // ---- Definição Grid Contas de Recebimento
 // -----------------------------------------  
  aAdd(aHeadRec,{"Seq"         ,"R_SEQ"   ,"@!",02,0,"","","C","",""})
  aAdd(aHeadRec,{"Valor"       ,"R_VALREC","@E 9,999,999.99",10,2,"U_fn001Tot(2)","","N","",""})
  aAdd(aHeadRec,{"Forma PG"    ,"R_FORMPG","@!",01,0,"U_fn01Tro(1)","","C","","","1=Dinheiro;2=Cheque;3=Débito;4=C. Crédito"})
  aAdd(aHeadRec,{"CPF Emitente","R_CPFEMI","@!",15,0,"Vazio() .or. CGC(AllTrim(R_CPFEMI))","","C","",""})
  aAdd(aHeadRec,{"Emitente"    ,"R_NMEMI" ,"@!",40,0,"","","C","",""})
  aAdd(aHeadRec,{"Telefone"    ,"R_TELEMI","@!",10,0,"","","C","",""})
  aAdd(aHeadRec,{"Banco"       ,"R_BANCO" ,"@!",03,0,"U_fn001Bco()","","C","",""})
  aAdd(aHeadRec,{"Descrição"   ,"R_DESBCO","@!",15,0,"","","C","","",,,".F."})
  aAdd(aHeadRec,{"Agência"     ,"R_AGENC" ,"@!",05,0,"","","C","",""})
  aAdd(aHeadRec,{"Conta"       ,"R_CONTA" ,"@!",10,0,"","","C","",""})
  aAdd(aHeadRec,{"DV Cta"      ,"R_DVCTA" ,"@!",02,0,"","","C","",""})
  aAdd(aHeadRec,{"Nr Cheque"   ,"R_NRCHEQ","@!",15,0,"","","C","",""})
  aAdd(aHeadRec,{"Compensação" ,"R_COMPEN","@!",08,0,"","","D","","",,,".F."})
  aAdd(aHeadRec,{"Autorização" ,"R_CODAUT","@!",06,0,"","","C","","",,,".F."})

  aAux := {"01",;                          // 01 = Sequencia
		     0,;                             // 02 = Valor
		     Space(10),;                     // 03 = Forma de Pagamento
		     Space(15),;                     // 04 = CPF Emitente
		     Space(40),;                     // 05 = Nome Emitente
		     Space(10),;                     // 06 = Telefone Emitente
		     Space(03),;                     // 07 = Código do Banco
		     Space(15),;                     // 08 = Descriçao do Banco
		     Space(05),;                     // 09 = Código da Agência
		     Space(10),;                     // 10 = Número da Conta                    
		     Space(02),;                     // 11 = Digito da Conta
		     Space(15),;                     // 12 = Número do Cheque
		     dDataBase,;                     // 13 = Compensação de Cheque
		     Space(20),;                     // 14 = Autorização
		     .F.}

  aAdd(aColsRec, aAux)

  nPosCPF := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_CPFEMI"})
  nPosVlr := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_VALREC"})
  nPosFPg := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_FORMPG"})
  nPosNEm := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_NMEMI"})
  nPosTEm := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_TELEMI"})
  nPosBco := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_BANCO"})
  nPosDBc := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_DESBCO"})
  nPosAge := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_AGENC"})
  nPosCta := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_CONTA"})
  nPosDCt := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_DVCTA"})
  nPosNCq := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_NRCHEQ"})
  nPosCom := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_COMPEN"})
  nPosNSU := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_CODAUT"})
  
  Define Font oFont    Name "Lucida Console" Size 0,-12 Bold
  Define Font oFCartao Name "Lucida Console" Size 0,-18 Bold

  Define MsDialog oDlg Title "CARTÃO RIO CENTER" From 180,180 To 705,865 Pixel STYLE DS_MODALFRAME
    oFWLayer := FWLayer():New()

	oFWLayer:Init(oDlg, .F., .T. )
	oFWLayer:AddLine("TOP",40,.F.) 
	oFWLayer:AddCollumn("ALL",100,.T.,"TOP")

	oFWLayTop := oFWLayer:GetColPanel("ALL","TOP")

	@ 005,005 To 48,120 Label "Numero do Cartão / CPF" Pixel Of oDlg
	@ 021,013 MsGet oCartao	Var cCartao Size 100,015 ;
	          Valid MsgRun("Aguarde, Administradora sendo consultada...","CARTÃO RIO CENTER",{|| aRet := fnOpcao()});
	          Color CLR_BLACK Pixel Of oDlg Font oFCartao

	@ 005,125 To 48,340 Label "Resultado da Consulta" Pixel Of oDlg
	@ 015,130 Say oResult Var cResult Size 175,50 Of oDlg Pixel Font oFont 
	@ 034,293 Button "Add. Fatura" Size 045,012 Pixel Of oDlg Action fnAddFat() When lConsultou

	@ 050,005 To 120,340 Label "Cartões" Pixel Of oDlg

	oBroFat := MsNewGetDados():New(060,07,118,338,GD_INSERT + GD_UPDATE + GD_DELETE,,,,,,,,,,oDlg,aHeadCad,aDados) 
	oBroFat:oBrowse:Refresh()

	@ 125,005 To 210,340 Label "Pagamentos" Pixel Of oDlg

	oBroRec:= MsNewGetDados():New(135,07,205,338,GD_INSERT + GD_UPDATE + GD_DELETE,"U_fn001LRc(oBroRec:oBrowse:nAt)",,;
	                              "+R_SEQ",,1,,,,,oDlg,aHeadRec,aColsRec) 

	@ 215,005 To 260,255 Label "" Pixel Of oDlg

    oLblRPg := TSay():New(220,10, {|| "Saldo a Pagar"}, oDlg,,,,,,.T.,,,100,9)
    oLblRPg:SetCSS( POSCSS (GetClassName(oLblRPg),CSS_BREADCUMB))

    oLblVlRPg := TSay():New(222,70,{||Str(0,10,2)},oDlg,,,,,,.T.,,,60,8)
    oLblVlRPg:SetCSS( POSCSS (GetClassName(oLblVlRPg),CSS_LABEL_FOCAL)) 

    oLblRec := TSay():New(232,10, {|| "Recebido"}, oDlg,,,,,,.T.,,,100,9)
    oLblRec:SetCSS( POSCSS (GetClassName(oLblRec),CSS_BREADCUMB))

    oLblVlRec := TSay():New(234,70,{||Str(0,10,2)},oDlg,,,,,,.T.,,,60,8)
    oLblVlRec:SetCSS( POSCSS (GetClassName(oLblVlRec),CSS_LABEL_FOCAL)) 

    oLblARc := TSay():New(244,10, {|| "A Receber"}, oDlg,,,,,,.T.,,,100,9)
    oLblARc:SetCSS( POSCSS (GetClassName(oLblARc),CSS_BREADCUMB))

    oLblVlARc := TSay():New(246,70,{||Str(0,10,2)},oDlg,,,,,,.T.,,,60,8)
    oLblVlARc:SetCSS( POSCSS (GetClassName(oLblVlARc),CSS_LABEL_FOCAL)) 

   // --- Troco
   // --------- 
    oLblEsp := TSay():New(220,140, {|| "Espécie"}, oDlg,,,,,,.T.,,,100,9)
    oLblEsp:SetCSS( POSCSS (GetClassName(oLblRPg),CSS_BREADCUMB))

	@ 218,180 MsGet onVlEsp Var nVlEsp Size 60,010 Picture "@E 999,999.99" Valid U_fn01Tro(2) Color CLR_BLACK Pixel Of oDlg Font oFont 

    oLblTro := TSay():New(244,140, {|| "TROCO"}, oDlg,,,,,,.T.,,,100,9)
    oLblTro:SetCSS( POSCSS (GetClassName(oLblTro),CSS_BREADCUMB))

    oLblVlTro := TSay():New(246,180,{||Str(0,10,2)},oDlg,,,,,,.T.,,,60,8)
    oLblVlTro:SetCSS( POSCSS (GetClassName(oLblVlTro),CSS_LABEL_FOCAL)) 

   // --- Botões
   // ----------    
    oButRPg := TButton():New(215,270,"Pagamento",oDlg,{|| fn001Grv()},55,14,,,,.T.,,,,{||})
    oButRPg:SetCSS( POSCSS (GetClassName(oButRPg),CSS_BTN_FOCAL)) 

    oButNPg := TButton():New(232,270,"Novo Pgto",oDlg,{|| fnZeraVar()},55,14,,,,.T.,,,,{||})
    oButNPg:SetCSS( POSCSS (GetClassName(oButNPg),CSS_BTN_FOCAL)) 

    oButFec := TButton():New(249,270,"Fechar",oDlg,{|| oDlg:End()},55,14,,,,.T.,,,,{||})
    oButFec:SetCSS( POSCSS (GetClassName(oButFec),CSS_BTN_FOCAL)) 
  Activate MsDialog oDlg Centered 
Return

/*======================================================
-- Descrição: Função para incluir a fatura na grid.   --
--                                                    --
========================================================*/ 
Static Function fnAddFat()
  Local nId := 0
  
  If Empty(cCartao)
     Return
  EndIf
     	
  If Empty(oBroFat:aCols[1][1])
     aDados := {}
	
	 aAdd(aDados, {cCartao,;
                   dVencto,;
	 	             nVlrCartao,;
	 	             nVlrMin,;
	 	             nVlrCartao,;
                   cCliente,;
                   .F.})
	
	 oBroFat:aCols := aDados
	 oBroFat:Refresh()
	 
   elseIf aScan(oBroFat:aCols,{|x| AllTrim(x[1]) == AllTrim(cCartao)}) == 0
		    aAdd(oBroFat:aCols,{cCartao,;
                              dVencto,;
		  		                  nVlrCartao,;
		  		                  nVlrMin,;
		  		                  nVlrCartao,;
                              cCliente,;
                              .F.})
		  oBroFat:Refresh()
  EndIf 
  
  U_fn001Tot(3)     // Calcular totais
  
  lConsultou := .F.
  cCartao    := Space(19)
  cResult    := ""
  
  oDlg:Refresh()
Return

/*==============================================================
--  Descrição: Monta a string e chame a chama de comunicação  --
--             com a Administradora.                          --
================================================================*/
Static Function fnOpcao()
  Local cEnvSoap := ""
  Local aRet     := {.T.,""}
  Local aAux     :=	{}

  cResult    := ""
  lConsultou := .F.

  If Empty(cCartao)
     Return .T.
  EndIf      

  If aScan(oBroFat:aCols,{|x| AllTrim(x[1]) == AllTrim(cCartao)}) == 1
	 MsgInfo("Cartão já incluido para pagamento.","Pagamento Fatura")
	 Return .T.
  EndIf	 
  
 // --- Chama a rotina que fara a consulta na Administradora do Cartão RIO CENTER
 // --- Acessar WebService (Soap) 
 // --- Cria Tag de Envio (Consulta Dados Cliente)
  cCliente := ""
  
/*  If Len(AllTrim(cCartao)) > 11
     cEnvSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
     cEnvSoap += '  <soapenv:Header/>'
     cEnvSoap += '  <soapenv:Body>'
     cEnvSoap += '    <sAxml_envio>'
     cEnvSoap += 'Z0000010102'                                                    // Cabeçalho
     cEnvSoap += '0'
     cEnvSoap += Replicate("0",19 - Len(AllTrim(cCartao))) + AllTrim(cCartao))    // Numero do Cartão / CPF
     cEnvSoap += StrZero(Val(Substr(cFilAnt,3,2)),4)                              // Codigo loja
     cEnvSoap += Padr(AllTrim(SLG->LG_PDV),3)                                     // Codigo do PDV
     cEnvSoap += '000000'                                                         // Numero do Cupom
     cEnvSoap += '007'                                                            // Codigo Finalizadora
     cEnvSoap += Replicate("0",12)
     cEnvSoap += Replicate("0",12)                                                // Valor
     cEnvSoap += Replicate("0",81)
     cEnvSoap += Replicate(" ",16)
     cEnvSoap += Replicate("0",12)
     cEnvSoap += Replicate("0",03)                                                // Quantidade de parcelas
     cEnvSoap += Replicate("0",05)
     cEnvSoap += Replicate(" ",26)
     cEnvSoap += Replicate("0",34)
     cEnvSoap += '   </sAxml_envio>'
     cEnvSoap += '  </soapenv:Body>'
     cEnvSoap += '</soapenv:Envelope>'
 
     aRet := U_RIOF9001(cEnvSoap)

     If ! aRet[01] 		    
        cResult := aRet[02]
        Return aRet[01]
      elseIf Substr(aRet[02],10,4) <> "0000" 
             cResult := "CARTÃO INVÁLIDO"
             oResult:Refresh()	
             Return aRet[01]
           else
             cCliente := Substr(aRet[02],145,48)
             cResult  := cCliente + Chr(13) + chr(10)		
             cResult  += "Saldo Disponível: " + Alltrim(TransForm((Val(Substr(aRet[02],70,12)) / 100), "@E 999,999,999.99")) + Chr(13) + chr(10)	
     EndIf	
  EndIf*/
          
 // --- Chama a rotina que fara a consulta na Administradora do Cartão RIO CENTER
 // --- Acessar WebService (Soap) 
 // --- Cria Tag de Envio (Consulta Fatura Cliente)
  cEnvSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
  cEnvSoap += '  <soapenv:Header/>'
  cEnvSoap += '  <soapenv:Body>'
  cEnvSoap += '    <sAxml_envio>'
  cEnvSoap += 'Z0000010107'                                                   // Cabeçalho
  cEnvSoap += '04'
  cEnvSoap += Replicate("0",19 - Len(AllTrim(cCartao))) + AllTrim(cCartao)    // Número do Cartão / CPF
  cEnvSoap += Replicate("0",06)                                               // Número do Cupom
  cEnvSoap += Replicate("0",26)                                               // Docto2
  cEnvSoap += Replicate("0",16)                                               // Docto3
  cEnvSoap += Replicate("0",05)                                               // CodFuncao
  cEnvSoap += '   </sAxml_envio>'
  cEnvSoap += '  </soapenv:Body>'
  cEnvSoap += '</soapenv:Envelope>'

  aRet := U_RIOF9001(cEnvSoap,"0107","")
   
  If ! aRet[01] 		    
     cResult := aRet[02]
   elseIf Substr(aRet[02],10,4) <> "0000" 
          cResult := AllTrim(Substr(aRet[02],18,20))
        else
          dVencto    := CToD(Substr(aRet[02],85,2) + "/" + Substr(aRet[02],87,2) + "/" + Substr(aRet[02],89,4))
          nVlrCartao := Val(Substr(aRet[02],106,12)) / 100
          nVlrMin    := Val(Substr(aRet[02],94,12)) / 100
     
          If Empty(cCliente)
             cCliente := Substr(aRet[02],37,48)
             cResult  := cCliente + Chr(13) + chr(10)
          EndIf
        
          cResult    += "Vencimento:  " + DToC(dVencto) + Chr(13) + chr(10)
          cResult    += "Pagto Mínimo:  " + Alltrim(TransForm(nVlrMin, "@E 999,999,999.99")) + Chr(13) + chr(10)	
          cResult    += "Valor Total:   " + Alltrim(TransForm(nVlrCartao, "@E 999,999,999.99")) + Chr(13) + chr(10)
          lConsultou := .T.	
  EndIf
  
  oResult:Refresh()	
Return aRet[01]

/*----------------------------------------------
--  Função: Realizar pagamento dos cartões.   --
--                                            --
------------------------------------------------*/
Static Function fn001Grv()
  Local nId      := 0
  Local nVlDin   := 0
  Local nVlChq   := 0
  Local nVlDeb   := 0
  Local nVlCre   := 0
  Local cEnvSoap := ""
  Local cCtaChq  := ""
  Local cNatRec  := StrTran(SuperGetMv("MV_NATRECE",.F.,""),'"','')
  Local cSeqSZ5  := StrZero(Val(Posicione("SX5",1,xFilial("SX5") + "Z5" + "01","X5_DESCRI")),10) 
  Local cHrOpera := Time()
  Local aImpCar  := {}
  Local aRet     := {.T.,""}

  If (nVlaRec - nVlReci) <> 0
     MsgInfo("Ainda existe saldo a receber, por favor informe.")
     Return
  EndIf   

 // --- Validar Débito em Conta
 // ---------------------------   
  For nId := 1 To Len(oBroRec:aCols)
      If ! U_fn001LRc(nId)
         Return
      EndIf

     // --- Verificar se é venda com Cartão de Débito
     // --------------------------------------------- 
      If oBroRec:aCols[nId][nPosFPg] $ "34" 
        If ! U_fn001TEF({oBroRec:aCols[nId][nPosVlr], nId},IIf(oBroRec:aCols[nId][nPosFPg] == "3","CD","CC"))
           Return
        EndIf
      EndIf
     // ---------------------------------------------
  Next
  
  For nId := 1 To Len(oBroRec:aCols)
      Do Case
         Case oBroRec:aCols[nId][nPosFPg] == "1"     // Dinheiro
              nVlDin += oBroRec:aCols[nId][nPosVlr]
         
         Case oBroRec:aCols[nId][nPosFPg] == "2"     // Cheque
              cCtaChq := StrTran(oBroRec:aCols[nId][nPosCta],".","")
              cCtaChq := StrTran(cCtaChq,"-","")
              cCtaChq := StrTran(cCtaChq,"/","")
              cCtaChq := StrTran(cCtaChq,";","")
              cCtaChq := StrTran(cCtaChq,",","")
              nVlChq  += oBroRec:aCols[nId][nPosVlr]
             
              Reclock("SZ5",.T.)
                Replace SZ5->Z5_FILIAL  with xFilial("SZ5")
                Replace SZ5->Z5_TIPO    with "CH"
                Replace SZ5->Z5_SEQ     with cSeqSZ5
                Replace SZ5->Z5_BANCO   with oBroRec:aCols[nId][nPosBco]
                Replace SZ5->Z5_AGENCIA with oBroRec:aCols[nId][nPosAge]
                Replace SZ5->Z5_CONTA   with cCtaChq
                Replace SZ5->Z5_DVCTA   with oBroRec:aCols[nId][nPosDCt]
                Replace SZ5->Z5_NUMCHQ  with oBroRec:aCols[nId][nPosNCq]
                Replace SZ5->Z5_CPFCNPJ with oBroRec:aCols[nId][nPosCPF]
                Replace SZ5->Z5_EMITENT with oBroRec:aCols[nId][nPosNEm]
                Replace SZ5->Z5_VALOR   with oBroRec:aCols[nId][nPosVlr]
                Replace SZ5->Z5_DATA    with oBroRec:aCols[nId][nPosCom]
                Replace SZ5->Z5_HORA    with cHrOpera
                Replace SZ5->Z5_OPERADO with SA6->A6_COD
                Replace SZ5->Z5_PDV     with SLG->LG_PDV
                Replace SZ5->Z5_TRANSMI with "N"
              SZ5->(MsUnlock())

              fn01GSE5("CH", cNatRec, oBroRec:aCols[nId][nPosVlr])

         Case oBroRec:aCols[nId][nPosFPg] == "3"     // Débito em Conta
              nVlDeb += oBroRec:aCols[nId][nPosVlr]

              Reclock("SZ5",.T.)
                Replace SZ5->Z5_FILIAL  with xFilial("SZ5")
                Replace SZ5->Z5_TIPO    with "CD"
                Replace SZ5->Z5_SEQ     with cSeqSZ5
                Replace SZ5->Z5_NSU     with oBroRec:aCols[nId][nPosNSU]
                Replace SZ5->Z5_VALOR   with oBroRec:aCols[nId][nPosVlr]
                Replace SZ5->Z5_DATA    with dDataBase
                Replace SZ5->Z5_HORA    with cHrOpera
                Replace SZ5->Z5_OPERADO with SA6->A6_COD
                Replace SZ5->Z5_PDV     with SLG->LG_PDV
                Replace SZ5->Z5_TRANSMI with "N"
              SZ5->(MsUnlock())
              
              fn01GSE5("CD", cNatRec, oBroRec:aCols[nId][nPosVlr])

         Case oBroRec:aCols[nId][nPosFPg] == "4"     // CARTAO DE CREDITO
              nVlCre += oBroRec:aCols[nId][nPosVlr]

              Reclock("SZ5",.T.)
                Replace SZ5->Z5_FILIAL  with xFilial("SZ5")
                Replace SZ5->Z5_TIPO    with "CC"
                Replace SZ5->Z5_SEQ     with cSeqSZ5
                Replace SZ5->Z5_NSU     with oBroRec:aCols[nId][nPosNSU]
                Replace SZ5->Z5_VALOR   with oBroRec:aCols[nId][nPosVlr]
                Replace SZ5->Z5_DATA    with dDataBase
                Replace SZ5->Z5_HORA    with cHrOpera
                Replace SZ5->Z5_OPERADO with SA6->A6_COD
                Replace SZ5->Z5_PDV     with SLG->LG_PDV
                Replace SZ5->Z5_TRANSMI with "N"
              SZ5->(MsUnlock())
              
              fn01GSE5("CC", cNatRec, oBroRec:aCols[nId][nPosVlr])
      EndCase
  Next    
      
 // --- Gravar o Titulo do Contas a Receber
 // ---------------------------------------
  For nId := 1 To Len(oBroFat:aCols)
      If Empty(oBroFat:aCols[nId][01])
         Loop
      EndIf
      
     // --- Gravar Pagamento Cartão 
     // ---------------------------
      Reclock("SZ4",.T.)
        Replace SZ4->Z4_FILIAL  with xFilial("SZ4")
        Replace SZ4->Z4_CARTAO  with oBroFat:aCols[nId][01]
        Replace SZ4->Z4_NOMECLI with oBroFat:aCols[nId][06]
        Replace SZ4->Z4_DATA    with DToS(dDataBase)
        Replace SZ4->Z4_HORA    with cHrOpera
        Replace SZ4->Z4_OPERADO with SA6->A6_COD
        Replace SZ4->Z4_PDV     with SLG->LG_PDV
        Replace SZ4->Z4_VALOR   with oBroFat:aCols[nId][03]
        Replace SZ4->Z4_VLPAGTO with oBroFat:aCols[nId][05]
        Replace SZ4->Z4_DINHEIR with nVlDin
        Replace SZ4->Z4_CHEQUE  with nVlChq
        Replace SZ4->Z4_DEBITO  with nVlDeb
        Replace SZ4->Z4_CREDITO with nVlCre
        Replace SZ4->Z4_SEQ     with cSeqSZ5
        Replace SZ4->Z4_TRANSMI with "N"
        Replace SZ4->Z4_TRANRET with "N"
      SZ4->(MsUnlock())
      
     // --- Enviar os registros de pagamento de Fatura
     // --- Administradora do Cartão
     // ----------------------------------------------
      cEnvSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
      cEnvSoap += '  <soapenv:Header/>'
      cEnvSoap += '  <soapenv:Body>'
      cEnvSoap += '    <sAxml_envio>'
      cEnvSoap += 'Z0000010171'                                                                   // Cabeçalho
      cEnvSoap += '04'                                                                            // Tipo de Consulta
      cEnvSoap += Replicate("0",19 - Len(AllTrim(SZ4->Z4_CARTAO))) + AllTrim(SZ4->Z4_CARTAO)      // Numero do Cartão
      cEnvSoap += Strzero(Val(StrTran(Str(SZ4->Z4_VLPAGTO,16,2),".","")),16)                      // Valor da Venda
      cEnvSoap += Replicate(" ",32)                                                               // Documento
      cEnvSoap += Replicate(" ",6)                                                                // Código da função
      cEnvSoap += StrZero(Val(Substr(cFilAnt,3,2)),3)                                             // Codigo loja
      cEnvSoap += PadR(AllTrim(SZ4->Z4_PDV),3)                                                    // Codigo do PDV
      cEnvSoap += Substr(SZ4->Z4_SEQ,5,6)                                                         // Numero do Cupom
      cEnvSoap += Substr(SZ4->Z4_DATA,7,2) + Substr(SZ4->Z4_DATA,5,2) + Substr(SZ4->Z4_DATA,1,4)  // Data do Pagamento da fatura 
      cEnvSoap += '   </sAxml_envio>'
      cEnvSoap += '  </soapenv:Body>'
      cEnvSoap += '</soapenv:Envelope>'
 
      aRet := U_RIOF9001(cEnvSoap,"0171","")
       
      If ! aRet[01] 
         MsgInfo("Pagamento Fatura não foi enviada para Administradora, problema técnico, será enviada no próximo processamento.")
       else
         Reclock("SZ4",.F.)
            Replace SZ4->Z4_TRANSMI with "S"
         SZ4->(MsUnlock())  
      EndIf
     // -----------------------------------   

      aAdd(aImpCar, {oBroFat:aCols[nId][01],;
      	            oBroFat:aCols[nId][06],;
      	            oBroFat:aCols[nId][05]})
  Next

 // --- Atualizar o sequencial da sequencial
 // --- Cartão x Pagamento.
 // ----------------------------------------
  FwPutSX5("","Z5","01", StrZero(Val(cSeqSZ5) + 1,10), StrZero(Val(cSeqSZ5) + 1,10), StrZero(Val(cSeqSZ5) + 1,10))

 // --- Pagamento com Dinheiro (SE5)
 // --------------------------------
  If nVlDin > 0
     fn01GSE5("R$", cNatRec, nVlDin)
  EndIf     
 
 // --- Impressão de comprovante de pagamento 
 // --- de fatura Rio Center
 // -----------------------------------------         
  U_RIOF9004(aImpCar,1,"V I A  C L I E N T E")          
  U_RIOF9004(aImpCar,1,"V I A  O P E R A D O R")
 // -----------------------------------------
            
  fnZeraVar()
Return

/*======================================
--  Função: Gravação da Movimentação  --
--          Bancária.                 --
========================================*/
Static Function fn01GSE5(pTipo, pNatureza, pValor)
  Local cNumTit := ""

  cNumTit := StrZero(Val(Posicione("SX5",1,xFilial("SX5") + "01" + SLG->LG_SERNFIS,"X5_DESCRI")),TamSX3("E1_NUM")[1])            

  Reclock("SE5",.T.)
    Replace SE5->E5_FILIAL  with xFilial("SE5")
    Replace SE5->E5_DATA    with dDataBase
    Replace SE5->E5_TIPO    with "FI"
    Replace SE5->E5_TIPODOC with "VL"
    Replace SE5->E5_PREFIXO with "F" + Substr(SLG->LG_PDV,2,2)
    Replace SE5->E5_NUMERO  with cNumTit
    Replace SE5->E5_BANCO   with SA6->A6_COD
    Replace SE5->E5_AGENCIA with SA6->A6_AGENCIA
    Replace SE5->E5_CONTA   with SA6->A6_NUMCON
    Replace SE5->E5_RECPAG  with "R"
    Replace SE5->E5_DTDIGIT with dDataBase
    Replace SE5->E5_DTDISPO with dDataBase
    Replace SE5->E5_VALOR   with pValor
    Replace SE5->E5_NATUREZ with pNatureza
    Replace SE5->E5_ORIGEM  with "LOJXREC"
    Replace SE5->E5_NUMMOV  with SLW->LW_NUMMOV
    Replace SE5->E5_FORMAPG with pTipo
    Replace SE5->E5_HISTOR  with "Recebimento Fatura Rio Center"
    Replace SE5->E5_SEQ     with "01"
    Replace SE5->E5_XTRANSM with "N"
  SE5->(MsUnlock())

 // --- Atualizar o sequencial da série não fiscal
 // ----------------------------------------------
  FwPutSX5("","01",SLG->LG_SERNFIS, StrZero(Val(cNumTit) + 1,TamSX3("E1_NUM")[1]),;
                                    StrZero(Val(cNumTit) + 1,TamSX3("E1_NUM")[1]),;
                                    StrZero(Val(cNumTit) + 1,TamSX3("E1_NUM")[1]))
Return

/*============================================================
--  Descrição : Função para zerar as variaveis utilizadas   --
--              quando mudar o tipo de consulta utilizada.  --
==============================================================*/
Static Function fnZeraVar()
  lConsultou := .F.
  cCartao    := Space(19)
  cResult    := ""
  aDados     := {}
  aColsRec   := {}
  
 // --- Grid dos Cartões
 // --------------------
  aAux := {Space(13),;
  	       Space(10),;
  	       0,;
  	       0,;
  	       0,;
  	       Space(30),;
  	       .F.}
 
  aAdd(aDados, aAux)
  
  oBroFat:aCols := aDados

 // --- Grid dos Pagamentos
 //--- --------------------
  aAux := {"01",;                          // 01 = Sequencia
		   0,;                             // 02 = Valor
		   Space(10),;                     // 03 = Forma de Pagamento
		   Space(15),;                     // 04 = CPF Emitente
		   Space(40),;                     // 05 = Nome Emitente
		   Space(10),;                     // 06 = Telefone Emitente
		   Space(03),;                     // 07 = Código do Banco
		   Space(15),;                     // 08 = Descriçao do Banco
		   Space(05),;                     // 09 = Código da Agência
		   Space(10),;                     // 10 = Número da Conta                    
		   Space(02),;                     // 11 = Digito da Conta
		   Space(15),;                     // 12 = Número do Cheque
		   dDataBase,;                     // 13 = Compensação de Cheque
		   Space(20),;                     // 14 = Autorização
		   .F.}

  aAdd(aColsRec, aAux)

  oBroRec:aCols := aColsRec
  nVlEsp        := 0
  
  ObjectMethod(oLblVlRPg,"SetText('" + Transform(0,"@E 999,999.99") + "')")
  ObjectMethod(oLblVlRec,"SetText('" + Transform(0,"@E 999,999.99") + "')")
  ObjectMethod(oLblVlARc,"SetText('" + Transform(0,"@E 999,999.99") + "')")
  ObjectMethod(oLblVlTro,"SetText('" + Transform(0,"@E 999,999.99") + "')")

  oResult:Refresh()	
  oDlg:Refresh()
Return

/*/{Protheus.doc} fn001LRc
Função fn001LRc
@param Recebe parâmetros
@return Confirmação
@author Totvs Nordeste
@owner Totvs S/A
@version Protheus 11 e V12
@since 07/06/2018 
@sample
// fn0001LRc - Função pra chamar testar a linha do grid de Pagamento
U_fn0001LRc()
Return
07/06/2018 - Desenvolvimento da Rotina.
/*/
User Function fn001LRc(pPos)
  Local lRet    := .T.

  Do Case
     Case oBroRec:aCols[pPos][nPosVlr] == 0
          MsgInfo("Valor do pagamento está zerado, é obrigatório.")
          lRet := .F.
         
     Case Empty(oBroRec:aCols[pPos][nPosFPg])
          MsgInfo("Forma de pagamento está branco, é obrigatório.")
          lRet := .F.

     Case oBroRec:aCols[pPos][nPosFPg] == "2"
        // --- Validar se forma de pagamento é Cheque para 
        // --- obrigar a digitação da informação do banco.
        // -----------------------------------------------
          oBroRec:aCols[pPos][nPosCom] := dDataBase
          
          If Empty(oBroRec:aCols[pPos][nPosCPF])
             MsgInfo("CNPJ/CPF é obrigatório para essa forma de pagamento.")
             lRet := .F.
          EndIf
                  
          If Empty(oBroRec:aCols[pPos][nPosBco])
             MsgInfo("Código do BANCO é obrigatório para essa forma de pagamento.")
             lRet := .F.
             
           elseIf Empty(oBroRec:aCols[pPos][nPosAge])  
                  MsgInfo("Código da AGÊNCIA é obrigatório para essa forma de pagamento.")
                  lRet := .F.
                  
                elseIf Empty(oBroRec:aCols[pPos][nPosCta])
                       MsgInfo("Número da CONTA é obrigatório para essa forma de pagamento.")
                       lRet := .F.
                       
                 elseIf Empty(oBroRec:aCols[pPos][nPosCPF])
                        MsgInfo("CPF do EMITENTE é obrigatório para essa forma de pagamento.")
                        lRet := .F.
                        
                  elseIf Empty(oBroRec:aCols[pPos][nPosNCq])
                         MsgInfo("Número do CHEQUE é obrigatório para essa forma de pagamento.")
                         lRet := .F.
          EndIf
  EndCase
  
  If lRet
     U_fn001Tot(3)
  EndIf   
Return lRet

/*/{Protheus.doc} fn001Tot
Função fn001Tot
@param pTipo : 1 - Digitação valor - grid Cartão
               2 - Digitação valor recebido - grid Recebimento 
               3 - Calculo de total
@return Confirmação
@author Totvs Nordeste
@owner Totvs S/A
@version Protheus 11 e V12
@since 12/06/2018 
@sample
// fn001Tot - Função pra calcular os totais
U_fn001Tot()
Return
12/06/2018 - Desenvolvimento da Rotina.
/*/
User Function fn001Tot(pTipo)
  Local nId     := 0
  Local nPosFat := aScan(aHeadCad,{|x| AllTrim(x[2]) == "vlPago"})
  Local nPosRec := aScan(aHeadRec,{|x| AllTrim(Upper(x[2])) == "R_VALREC"})

  nVlaRec := 0
  nVlReci := 0
  
 // --- Validar se existe cartão selecionado
 // ---------------------------------------- 
  If pTipo == 1
     If Empty(oBroFat:aCols[oBroFat:oBrowse:nAt][01]) .and. M->vlPago > 0
        MsgInfo("Cartão não selecionado.")
        
        M->vlPago := 0
        
        Return .T.
     EndIf    
  EndIf
  
 // --- Total a receber dos cartões selecionados 
  For nId := 1 To Len(oBroFat:aCols)
      If pTipo == 1
         If nId == oBroFat:oBrowse:nAt
            nVlaRec += M->vlPago
            Loop
          EndIf
      EndIf
               
      nVlaRec += oBroFat:aCols[nId][nPosFat]
  Next
  
 // --- Total recebido
  nVlEsp := 0
  
  For nId := 1 To Len(oBroRec:aCols)
      If pTipo == 2
         If nId == oBroRec:oBrowse:nAt
            nVlReci += M->R_VALREC
            Loop
         EndIf
      EndIf
            
      nVlReci += oBroRec:aCols[nId][nPosRec]
  Next

  ObjectMethod(oLblVlRPg,"SetText('" + Transform(nVlaRec,"@E 999,999.99") + "')")
  ObjectMethod(oLblVlRec,"SetText('" + Transform(nVlReci,"@E 999,999.99") + "')")
  ObjectMethod(oLblVlARc,"SetText('" + Transform((nVlaRec - nVlReci),"@E 999,999.99") + "')")
Return .T.

/*/{Protheus.doc} fn001Bco
Função fn001Bco
@param Recebe parâmetros
@return Confirmação
@author Totvs Nordeste
@owner Totvs S/A
@version Protheus 11 e V12
@since 07/06/2018 
@sample
// fn001Bco - Função pra chamar pegar o nome do Banco
U_fn001Bco()
Return
07/06/2018 - Desenvolvimento da Rotina.
/*/
User Function fn001Bco()
  Local lRet := .T.
  
  oBroRec:aCols[oBroRec:oBrowse:nAt][nPosDBc] := Posicione("SX5",1,xFilial("SX5") + "Z0" + M->R_BANCO,"X5_DESCRI")

  If Empty(oBroRec:aCols[oBroRec:oBrowse:nAt][nPosDBc]) 
     MsgInfo("BANCO não cadastrado na tabela do sistema.")
     lRet := .F.
  EndIf
     
  oBroRec:Refresh()
Return .T.

/*/{Protheus.doc} RIOA0001
Função fn0001FPg
@param pTipo = 'CD' - Débito em conta
             = 'CC' - Cartão de crédito
@return Confirmação
@author Totvs Nordeste
@owner Totvs S/A
@version Protheus 11 e V12
@since 01/06/2018 
@sample
// fn0001FPg - Função pra chamar rotina do SITEF quando pagamento com débito
U_fn0001FPg()
Return
01/06/2018 - Desenvolvimento da Rotina.
/*/
User Function fn001TEF(pRegTEF,pTipo)
  Local oNewTEF  := Nil
  Local aRegTEF  := pRegTEF
  Local lRet     := .F.
  Local cEmpresa := AllTrim(SM0->M0_NOMECOM) + Chr(13) + Chr(10);
                  + "CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + Chr(13) + Chr(10);
                  + AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + "/" + SM0->M0_ESTCOB + Chr(13) + Chr(10);
                  + "Emissão: " + DToC(Date()) + " - " + Time() + Chr(13) + Chr(10);
                  + " " + Chr(13) + Chr(10) 

 // --- Conectar com SITEF
 // ----------------------
  oNewTEF := LJC_TEF():New(STFGetStat("CODIGO") , .F.)
  oNewTEF:oConfig:AtivaSitef()

  If oNewTef:oConfig:ISCCCD()
     oTipoVend	 := oNewTef:Cartao()
     
     If pTipo == "CD"
        oDadosTran := LJCDadosTransacaoDebito():New(aRegTEF[01],111,Date(),Time(),"CD","","",.F.,1,.T.)												
	//                                          (nValor,nCupom,dData,cHora,cFormaPagto,cDescPagto,cAdmFin,lCarManual,nIdCartao,_DEBITO, lUltimaTrn, cRede)
        oTipoVend:Debito(oDadosTran)
      elseIf pTipo == "CC"
             oDadosTran	:= LJCDadosTransacaoCredito():New(aRegTEF[01],111,Date(),Time(),"CC","","",.F.,1)
   //                                          (nValor,nCupom,dData,cHora,cFormaPagto,cDescPagto,cAdmFin,lCarManual,nIdCartao)
//oDadosTran:cUserName := cUserName												
             oTipoVend:Credito(oDadosTran)
     EndIf

     lRet := oTipoVend:oTrans:aColecao[1][2]:oRetorno:lTRANSOK

	  If lRet
	     STWManagReportPrint(cEmpresa + oTipoVend:oTrans:aColecao[1][2]:oRetorno:cViaCaixa,1)
	     STWManagReportPrint(cEmpresa + oTipoVend:oTrans:aColecao[1][2]:oRetorno:cViaCliente,1)
	   
	     oBroRec:aCols[aRegTEF[02]][nPosNSU] := oTipoVend:oTrans:aColecao[1][2]:oRetorno:CNSU
	   
	     oNewTEF:Confirmar()
	  EndIf
  EndIf

  oNewTEF:Fechar()
Return lRet

/*/{Protheus.doc} RIOA0001
Função fn0001Tro
@param Parametro: 1 - Grid
                  2 - Campo Espécie.
@return Confirmação
@author Totvs Nordeste
@owner Totvs S/A
@version Protheus 11 e V12
@since 04/08/2018 
@sample
// fn0001FPg - Função pra Calcular Troco.
U_fn0001FPg()
Return
04/08/2018 - Desenvolvimento da Rotina.
/*/ 
User Function fn01Tro(pTipo)
  Local lRet    := .T.
  Local nId     := 0
  Local nVlPaga := 0
  
  For nId := 1 To Len(oBroRec:aCols)
      If pTipo == 1
         If nId == oBroRec:oBrowse:nAt
           If M->R_FORMPG == "1" 
              nVlPaga += oBroRec:aCols[nId][nPosVlr]                 // Dinheiro
           EndIf 
          elseIf oBroRec:aCols[nId][nPosFPg] == "1"
                 nVlPaga += oBroRec:aCols[nId][nPosVlr]              // Dinheiro
         EndIf
       elseIf oBroRec:aCols[nId][nPosFPg] == "1" 
              nVlPaga += oBroRec:aCols[nId][nPosVlr]                 // Dinheiro
      EndIf
  Next

  If pTipo == 1
     nVlEsp := nVlPaga 

     ObjectMethod(oLblVlTro,"SetText('" + Transform(0,"@E 999,999.99") + "')")
     
   elseIf pTipo == 2
          If nVlEsp < nVlPaga
             MsgInfo("Valor em espécie menor que o valor informado em dinheiro.")
             
             lRet := .F.
           else  
             ObjectMethod(oLblVlTro,"SetText('" + Transform((nVlEsp - nVlPaga),"@E 999,999.99") + "')")
          EndIf   
  EndIf   
  
  onVlEsp:Refresh()
Return lRet 
