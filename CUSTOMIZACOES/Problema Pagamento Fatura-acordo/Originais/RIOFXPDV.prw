#Include "TOTVS.CH"
#Include "PROTHEUS.CH" 

/*/{Protheus.doc} RIOF9001
  Função RIOF9001
  @param Retorno do SOAP
         pSoap  = Requisição do SOAP
         pTipo  = Tipo da operação: 'CUPOM' - Envio de XML, 
                                    '0102/0196' - Consulta sem retorno ou
                                    '0103' - Confirmar preciso retorno
         pTpRet = 'N' - Nenhum,
                  'D' - Valor Desconto ou
                  'R' - Resultado de pesquisa
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 10, Protheus 11 e V12
  @since 24/05/2018 
  @sample
// RIOF9001 - Função de integração Administradora do Cartão Rio Center x Protheus via SOAP.
  U_RIOF9001()
  Return
  @project 
  @history
  24/05/2018 - Desenvolvimento da Rotina.
/*/
User Function RIOF9001(pSoap,pTipo,pTpRet)
  Local nPos     := 0
  Local aRet     := {.T.,""}
  Local cURLCad  := SuperGetMv("MV_XURLCAD",.F.,"")
  Local cEnvSoap := pSoap
  Local cTpOper  := pTipo                   // 0102/0196 - Consulta sem retorno ou 0103 - Confirmar preciso retorno
  Local cTpRet   := pTpRet
  Local cRegClie := ""
    
  Local oWsdl 
 
 // --- Acessar WebService (Soap) 
  oWsdl := TWsdlManager():New()
  oWsdl:nTimeout := 120
  oWsdl:lSSLInsecure := .T.
   
  aRet[01] := oWsdl:ParseURL(cURLCad)
  
  If ! aRet[01]
     MsgInfo("Administradora fora - " + cURLCad + ", Erro - " + oWsdl:cError,"CARTÃO RIO CENTER")
     Return aRet  
  EndIf
           
 // --- Evento pra Consulta Dados Clientes 
 // --------------------------------------
  If cTpOper == "CUPOM" 
     aRet[01] := oWsdl:SetOperation("FidelizAcesso")
   else
     aRet[01] := oWsdl:SetOperation("ConsultaMessage")
  EndIf 

  If ! aRet[01]
     MsgInfo("Erro (Metodo - '" + IIf(cTpOper == "CUPOM","FidelizAcesso_MessageIn","ConsultaMessage") +;
             "'): " + oWsdl:cError,"CARTÃO RIO CENTER")
     Return aRet 
  EndIf

  aRet[01] := oWsdl:SendSoapMsg(cEnvSoap)
 
  If ! aRet[01]
     If cTpOper == "0103"
        cRegClie := AllTrim(oWsdl:GetSoapResponse())
        nPos     := At("</ConsultaMessageResult>",cRegClie) - At("<ConsultaMessageResult>",cRegClie) - 24 
        cRegClie := Substr(cRegClie,At("<ConsultaMessageResult>",cRegClie) + 23,nPos)

        If SubStr(cRegClie,1,5) == "00053"
           aRet[01] := .T.
           
           MsgInfo("ATENCAO: (Enviar a Requisicao): TRANS. EXISTENTE","RIO CENTER") 
        //else
        //MsgInfo("Erro: (Enviar a Requisicao): " + oWsdl:cError,"RIO CENTER")
        EndIf
            
        Return aRet
     EndIf
  EndIf
 
 // --- Pega a mensagem de resposta e converter em string
  cRegClie := AllTrim(oWsdl:GetSoapResponse())

  If cTpOper == "CUPOM"
     If cTpRet == "N"                           // Verificar recebimento do envio do XML
        nPos     := At("&lt;/mensagem_resultado&gt;",cRegClie) - At("&lt;mensagem_resultado&gt;",cRegClie) - 26 
        cRegClie := Substr(cRegClie,At("&lt;mensagem_resultado&gt;",cRegClie) + 26,nPos)
     
        aRet[01] := .T.
     
        If AllTrim(cRegClie) <> "OK"
           aRet[01] := .F.
        EndIf

        aRet[02] := Substr(cRegClie,nPos,(Len(cRegClie) - nPos))

      elseIf cTpRet == "D"                     // Retorno de desconto de venda
             nPos     := At("&lt;/desconto_geral&gt;",cRegClie) - At("&lt;desconto_geral&gt;",cRegClie) - 22 
             cRegClie := Substr(cRegClie,At("&lt;desconto_geral&gt;",cRegClie) + 22,nPos)
             aRet[01] := .T.
             aRet[02] := Val(cRegClie)
     EndIf   
   else
     nPos     := At("</ConsultaMessageResult>",cRegClie) - At("<ConsultaMessageResult>",cRegClie) - 24 
     cRegClie := Substr(cRegClie,At("<ConsultaMessageResult>",cRegClie) + 23,nPos)
     nPos     := At("Z",cRegClie)
     aRet[01] := .T.
     aRet[02] := Substr(cRegClie,nPos,(Len(cRegClie) - nPos))
  EndIf
Return aRet

/*/{Protheus.doc} RIOF9002
  Função RIOF9002
  @param Retorno do SOAP
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 13/07/2018 
  @sample
// RIOF9002 - Função integração do PDV x Retaguarda via SOAP.
  U_RIOF9002()
  Return
  @project 
  @history
  13/07/2018 - Desenvolvimento da Rotina.
/*/
User Function RIOF9002(pFuncao,pSoap)
  Local nPos     := 0
  Local aRet     := {.T.,""}
  Local cFuncao  := pFuncao
  Local cURLTit  := SuperGetMv("MV_XURLWS",.F.,"") + "/WSPDVRET.apw?WSDL"
  Local cEnvSoap := pSoap
  Local cResult  := ""
  Local oWsdl 
 
 // --- Acessar WebService (Soap)
 // ----------------------------- 
  oWsdl := TWsdlManager():New()
  oWsdl:nTimeout := 120
  oWsdl:lSSLInsecure := .T.
	    
  aRet[01] := oWsdl:ParseURL(cURLTit)
  
  If ! aRet[01]
     MsgInfo("Servidor Web Service fora  - " + cURLTIT,"RIO CENTER")
     Return aRet  
  EndIf
           
 // --- Eventos
 // -----------
  Do Case
     Case cFuncao == "SE1"
          aRet[01] := oWsdl:SetOperation("INCLSE1")

     Case cFuncao == "SE12"
          aRet[01] := oWsdl:SetOperation("INCLSE12")
     
     Case cFuncao == "SEF"
          aRet[01] := oWsdl:SetOperation("INCLSEF")

     Case cFuncao == "SZ4"
          aRet[01] := oWsdl:SetOperation("INCLSZ4")

     Case cFuncao == "SZ42"
          aRet[01] := oWsdl:SetOperation("INCLSZ42")

     Case cFuncao == "SZ5"
          aRet[01] := oWsdl:SetOperation("INCLSZ5")
  EndCase  

  If ! aRet[01]
     MsgInfo("Erro (Metodo - 'INCL" + cFuncao + "'): " + oWsdl:cError,"RIO CENTER")
     Return aRet 
  EndIf

  aRet[01] := oWsdl:SendSoapMsg(cEnvSoap)

  If ! aRet[01]
    MsgInfo("Erro: (Enviar a Requisição): " + oWsdl:cError,"RIO CENTER")
    Return aRet
  EndIf
   
 // --- Pega a mensagem de resposta e converter em string
  cResult  := AllTrim(oWsdl:GetSoapResponse())

  nPos     := At("<INCL" + cFuncao + "RESULT>",cResult)
  if len(cFuncao) == 3
    cResult  := Substr(cResult,(nPos + 15),Len(cResult))
  else
    cResult  := Substr(cResult,(nPos + 16),Len(cResult))
  ENDIF
  aRet[01] := .T.
  aRet[02] := Substr(cResult,1,(At("<",cResult) - 1))
Return aRet

/*/{Protheus.doc} RIOF9003
  Função RIOF9003
  @param pMensag = Qual a via a ser impressão
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 20/07/2018 
  @sample
// RIOF9003 - Função impressão de comprovante de compra cartão Rio Center.
  U_RIOF9003()
  Return
  20/07/2018 - Desenvolvimento da Rotina.
/*/
User Function RIOF9003(pMensag,pTpImp)
  Local nIdP    := 0
  Local cLogoD  := GetSrvProfString("Startpath","") + "lgrl" + Substr(cFilAnt,1,2) + ".bmp"
  Local cMsg    := ""
  Local cMsg1   := ""
  Local cEOL    := Chr(10)
  Local cCadMas := ""
  
  If Substr(SZ1->Z1_CARTAO,1,3) == "000"
     cCadMas := Substr(SZ1->Z1_CARTAO,4,4) + "." + Substr(SZ1->Z1_CARTAO,8,4) + "." +;
                Substr(SZ1->Z1_CARTAO,12,2) + "." + Substr(SZ1->Z1_CARTAO,14,3)
   else
     cCadMas := Substr(SZ1->Z1_CARTAO,1,4) + "." + Substr(SZ1->Z1_CARTAO,5,4) + "." +;
                Substr(SZ1->Z1_CARTAO,9,4) + "." + Substr(SZ1->Z1_CARTAO,13,4)
  EndIf
   
  If AllTrim(SZ1->Z1_AUTORI) == "GERENTE"
     cMsg1 := IIf(pTpImp == "O"," - AUT. GERENTE","")
  EndIf   
    
//  cMsg := "<ibmp>" + cLogoD + "</ibmp>"
  cMsg := "<ce>"
  cMsg += "<ce><b>" + AllTrim(SM0->M0_NOMECOM) + "</b></ce>" + cEOL
  cMsg += "CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + cEOL
  cMsg += AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + "/" + SM0->M0_ESTCOB + cEOL
  cMsg += "Emissão: " + DToC(Date()) + " - " + Time() + cEOL
  cMsg += cEOL
  cMsg += "<ce><b>COMPROVANTE DE COMPRA</b></ce>" + cEOL     
  cMsg += "<ce><b>" + pMensag + "</b></ce>" + cEOL     
  cMSg += "</ce>"
  cMsg += cEOL
  cMsg += "Cartão..: <b>" + cCadMas + "</b>" + cEOL
  cMsg += "Cliente.: " + AllTrim(SZ1->Z1_NOMECLI) + cEOL
  cMsg += "OP/DOC..: " + SL1->L1_OPERADO + " / " + SZ1->Z1_NUM + "-" + cFilAnt + IIf(Empty(cMsg1),"",AllTrim(cMsg1)) + cEOL 
  cMsg += "Valor...: <b>" + Transform(SZ1->Z1_VALOR,"@E 99,999,999.99") + "</b>" + cEOL
  cMsg += " " + cEOL
  
  If Val(SZ1->Z1_PARCELA) == 1
     cMsg += "      VENDA NO ROTATIVO" + cEOL
   else  
     cMsg += "VENDA EM " + Strzero(Val(SZ1->Z1_PARCELA),2) + " PARCELAS DE R$ " +;
             Transform((SZ1->Z1_VALOR / Val(SZ1->Z1_PARCELA)),"@E 99,999,999.99") + cEOL
  EndIf           

  cMsg += "  " + cEOL
  cMsg += "   RECONHECO E PAGAREI A IMPORTANCIA ACIMA" + cEOL
  cMsg += "  " + cEOL
  cMsg += "  " + Replicate("_",40) + cEOL
  cMsg += "  " + AllTrim(SZ1->Z1_NOMECLI) + cEOL
 
  For nIdP := 1 To 1
      STWManagReportPrint(cMsg,nIdP)
  Next 
Return

/*/{Protheus.doc} RIOF9004
  Função RIOF9004
  @param pCartao = Matriz com os dados do cartão
         pVia    = Quantidade de vias
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 20/07/2018 
  @sample
// RIOF9004 - Função impressão de comprovante de pagamento de fatura cartão Rio Center.
  U_RIOF9004()
  Return
  20/07/2018 - Desenvolvimento da Rotina.
/*/
User Function RIOF9004(pCartao, pVia, pMensag)
  Local nId     := 0
  Local cLogoD  := GetSrvProfString("Startpath","") + "lgrl" + Substr(cFilAnt,1,2) + ".bmp"
  Local aCartao := pCartao
  Local cMsg    := ""
  Local cEOL    := Chr(10)
  Local cCadMas := ""
  
//  cMsg := "<ibmp>" + cLogoD + "</ibmp>"
  cMsg := "<ce>"
  cMsg += "<ce><b>" + AllTrim(SM0->M0_NOMECOM) + "</b></ce>" + cEOL
  cMsg += "CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + cEOL
  cMsg += AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + "/" + SM0->M0_ESTCOB + cEOL
  cMsg += "Emissão: " + DToC(Date()) + " - " + Time() + cEOL
  cMsg += cEOL
  cMsg += "<ce><b>RECEBIMENTO DE CONTA</b></ce>" + cEOL     
  cMsg += "<b>CREDITO ROTATIVO</b>" + cEOL
  cMsg += "<ce><b>" + pMensag + "</b></ce>" + cEOL     
  cMSg += "</ce>"
  cMsg += cEOL
  
  For nId := 1 To Len(aCartao)
      If Substr(AllTrim(aCartao[nId][01]),1,3) == "000"
         cCadMas := Substr(aCartao[nId][01],4,4) + "." + Substr(aCartao[nId][01],8,4) + "." +;
                    Substr(aCartao[nId][01],12,2) + "." + Substr(aCartao[nId][01],14,3)
       else
         cCadMas := Substr(aCartao[nId][01],1,4) + "." + Substr(aCartao[nId][01],5,4) + "." +;
                    Substr(aCartao[nId][01],9,4) + "." + Substr(aCartao[nId][01],13,4)
      EndIf
      
      cMsg += "Cartão: <b>" + cCadMas + "</b>" + cEOL
      cMsg += "Cliente: " + AllTrim(aCartao[nId][02]) + cEOL
      cMsg += "VALOR: <b>" + Transform(aCartao[nId][03],"@E 99,999,999.99") + "</b>" + cEOL
      cMsg += cEOL 
  Next

  cMsg += " " + cEOL
  cMsg += "Operador: " + SA6->A6_COD + " - " + AllTrim(SA6->A6_NOME) + cEOL
  cMsg += "PDV: " + SLG->LG_PDV
 
  For nId := 1 To pVia
      STWManagReportPrint(cMsg,nId)
  Next 
Return

/*/{Protheus.doc} RIOF9005
  Função RIOF9005
  @param pTpReg = Tipo do registro = ' ' - Venda
                                     'C' - Cancelamento
  @return Não retorna nada
  @author Totvs Nordeste
  @version V12 e V25
  @sample
// RIOF9005 - Função gerar arquivo com extensão csv para integração com equals.
  U_RIOF9005()
  Return
  04/03/2020 - Desenvolvimento da Rotina.
/*/
User Function RIOF9005(pTpReg)
  Local nSeq     := 0
  Local cBuffer  := ""
  Local cArquivo := "" 
  Local cCodAdq  := ""           
  Local cEOL     := "CHR(13)+CHR(10)"
  Local cDirRec  := "C:\equals\"
  Local aaSX5    := {}
  Local nHdl1
  
  cArquivo := DToS(dDataBase) + "-000000001.csv"
  
 // --- Criar/Abrir arquivo de integração - Vendas
 // ----------------------------------------------
  If File(cDirRec + cArquivo)
     nHdl := FT_FUse(cDirRec + cArquivo)
   else
     nHdl := fCreate(cDirRec + cArquivo)
     
     nSeq := FT_FLastRec()                                      // Pegar a quantidade de registro no arquivo
     
     FT_FGoto(nSeq)                                             // Posicionar no último registro

     cBuffer := FT_FREADLN()
     nSeq    := Val(Substr(cBuffer,1,(At(";",cBuffer) - 1)))    // Pegar o número da última sequencia 
  EndIf

  dbSelectArea("SL4")
  SL4->(dbSetOrder(1)) 
  SL4->(dbSeek(xFilial("SL4") + SL1->L1_NUM))

  While ! SL4->(Eof()) .and. SL4->L4_FILIAL == SL1->L1_FILIAL .and. SL4->L4_NUM == SL1->L1_NUM
   // --- Verificar se é cartão de Crédito ou Débito
   // --- Não pode se cartão Rio Center
   // ----------------------------------------------
    If Substr(SL4->L4_FORMA,1,1) == "R"
       SL4->(dbSkip())

       Loop
    EndIf

   // --- Pegar o código da Rede Autorizadora
   // ---------------------------------------
    cCodAdq := ""
    aaSX5   := FWGetSX5('Z1',SL4->L4_REDEAUT,'pt-br') 

    If Len(aaSX5) > 0
       cCodAdq := AllTrim(aaSX5[1][4])
    EndIf

/*  dbSelectArea("SX5")
    SX5->(dbSetOrder(1))
    
    If SX5->(dbSeek(xFilial("SX5") + "Z1" + SL4->L4_REDEAUT)) 
       cCodAdq := AllTrim(SX5->X5_DESCRI)
    EndIf   
*/
   // --- Pegar informação do cartão
   // ------------------------------
    dbSelectArea("SAE")
    SAE->(dbSetOrder(1))
    
    If ! SAE->(dbSeek(xFilial("SAE") + SL4->L4_ADMINIS))
       MSGALERT("Administradora não encontrada.","ATENÇÃO")
       
       SL4->(dbSkip())
       Loop
    EndIf

    nSeq++

    cBuffer := Str(nSeq)                                   // 1 - NSR - Número sequencial do registro
    cBuffer += ";"
    cBuffer += cFilial                                     // 2 - Código que identifica a loja/filial onde a venda foi registrada
    cBuffer += ";"
    cBuffer += DToS(SL1->L1_EMISSAO)                       // 3 - Data da venda/transação
    cBuffer += ";"
    cBuffer += SL1->L1_NUM                                 // 4 - Identificador da venda no PROTHEUS
    cBuffer += ";"
    cBuffer += cFilial + SL1->L1_NUM                       // 5 - Código utilizado para pesquisar facilmente a venda no Equals
    cBuffer += ";"
    cBuffer += AllTrim(Posicione("SA1",1,xFilial("SA1") + SL1->L1_CLIENTE + SL1->L1_LOJA,"A1_NOME")) // 6 - Nome do Cliente
    cBuffer += ";"
    cBuffer += AllTrim(SL1->L1_CGCCLI)                     // 7 - CNPJ / CPF do Cliente 
    cBuffer += ";"
    cBuffer += AllTrim(SL1->L1_MENNOTA)                    // 8 - Observação da venda
    cBuffer += ";"
    cBuffer += AllTrim(SL4->L4_OBS)                        // 9 - Informação adicional 1 - Venda
    cBuffer += ";" 
    cBuffer += ""                                          // 10 - Informação adicional 2 - Venda
    cBuffer += ";"
    cBuffer += pTpReg                                      // 11 - "C" para indicar cancelamento, qualquer outro é venda
    cBuffer += ";"
    cBuffer += cFilial + SL1->L1_NUM                       // 12 - Identificador da transação no PROTHEUS
    cBuffer += ";"
    cBuffer += SL4->L4_AUTORIZ                             // 13 - Código de autorização gerado pela adquirente
    cBuffer += ";"
    cBuffer += SL4->L4_NSUTEF                              // 14 - NSU gerado pela adquirente ou Nosso Número gerado pelo banco para boletos
    cBuffer += ";"
    cBuffer += ""                                          // 15 - TID (Transaction ID) gerado pela adquirente para transação e-commerce
    cBuffer += ";"
    cBuffer += SL4->L4_NUMCART                             // 16 - Número do Cartão
    cBuffer += ";"
    cBuffer += SL4->L4_FORMA                               // 17 - Total de parcelas da transação
    cBuffer += ";"
    cBuffer += cCodAdq                                     // 18 - Código da adquirente na Equals
    cBuffer += ";"
    cBuffer += SAE->AE_XBDEQUA                             // 19 - Bandeira do cartão na Equals
    cBuffer += ";"
    cBuffer += SL4->L4_FORMPG                              // 20 - Formas de pagamento na Equals
    cBuffer += ";"
    cBuffer += "9"                                         // 21 - ID Meio de Captura - '9' = Outros
    cBuffer += ";"
    cBuffer += ""                                          // 22 - Observação - Transação
    cBuffer += ";"
    cBuffer += ""                                          // 23 - Informação adicional da transação de pagamento
    cBuffer += ";"
    cBuffer += ""                                          // 24 - Informação adicional da transação de pagamento
    cBuffer += ";"
    cBuffer += AllTrim(StrTran(Str(SL4->L4_VALOR),".",",")) // 25 - Números não inteiros devem ser informados com vírgula    

    fWrite(nHdl,cBuffer + cEOL)
   
    SL4->(dbSkip())
  EndDo      
  
  fClose(nHdl)
Return
