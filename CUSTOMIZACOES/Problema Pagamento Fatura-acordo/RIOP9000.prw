#Include "TOTVS.ch"
#Include "PROTHEUS.CH"
#Include "PARMTYPE.CH"

/*/{Protheus.doc} RIOP9000
  Função RIOP9000
  @param cEmp = Empresa
         cFil = Filial
         cPDV = Código do PDV
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 10, Protheus 11 e V12
  @since 29/05/2018 
  @sample
// RIOP9000 - User Function para execução em JOB processamento de vendas, enviar pra Administradora.
  U_RIOP9000()
  Return
  @obs Rotina de ponto de entrada 
  @project 
  @history
  29/05/2018 - Desenvolvimento da Rotina.
/*/
User Function RIOP9000(cEmp,cFil,cPDV)
	Local LRet      := .T.
	Local lPrepEnv  := .F.
	Local lWebSrv   := .T.                                // Retorno Web Service
	Local cURLCad   := ""
	Local cEnvSoap  := ""
	Local cRegClie  := ""
	Local cDtSZ5    := ""
	Local cHrSZ5    := ""
	Local cNumTit   := ""
	Local cNatDin   := ""
	Local cNatChq   := ""
	Local cNatDeb   := ""
	Local cNatCre   := ""
	Local cNumTitX5 := ""
	Local aRet      := {}
	Local aCupons   := {}
	Local aPagtos   := {}
	Local nPos      := 0
	Local nConte    := 0
    Local cTipoServico := ""
	Local nTaxaCD     := 0
	Private nStart := 0

	Default cEmp := ""							// Empresa para processamento
	Default cFil := ""							// Filial para processamento
	Default cPDV := ""    				   // Conteudo do terceiro parametro (Parm3 do mp8srv.ini)

	ParamType 0 Var cEmp As Character	Default ""
	ParamType 1 Var cFil As Character	Default ""
	ParamType 2 Var cPDV As Character	Default ""

	// --- Aguarda para evitar erro de __CInternet
	Sleep(5000)
  //	FwLogMsg("INFO",,"INTEGRATION","","","01","**********   teste   ***********************",0,10,{})

	lPrepEnv := ! Empty(cEmp) .and. ! Empty(cFil)

	If lPrepEnv
		RpcClearEnv()
		RPCSetType(3)
		RpcSetEnv(cEmp,cFil,,,"FRT")

	elseIf Empty(cEmp) .and. Empty(cFil)
		FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
			"Nao foram informados os parametros do processo no arquivo INI ",0,(nStart - Seconds()),{})
		RpcClearEnv()
		Return
	EndIf

	cURLCad := StrTran(SuperGetMv("MV_XURLCAD",.F.,""),'"','')
	cNatDin := StrTran(SuperGetMv("MV_NATDINH",.F.,""),'"','')
	cNatChq := StrTran(SuperGetMv("MV_NATCHEQ",.F.,""),'"','')
	cNatDeb := StrTran(SuperGetMv("MV_NATTEF" ,.F.,""),'"','')
	cNatCre := StrTran(SuperGetMv("MV_NATTEFC" ,.F.,""),'"','')
    nTaxaCD := SuperGetMv("MV_TXFATCD" ,.F.,0)

	dbSelectArea("SZ1")
	SZ1->(dbSetOrder(5))
	SZ1->(dbGoTop())

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** INICIO ENVIO VENDAS (SZ1) ***",0,(nStart - Seconds()),{})

	nConte := 0

	While ! SZ1->(Eof()) .and. SZ1->Z1_FILIAL == xFilial("SZ1") .and. AllTrim(SZ1->Z1_PDV) == cPDV .and.;
			SZ1->Z1_TRAMITE == "N"
		If SZ1->Z1_TRAMITE == "S"
			Exit
		EndIf

		If Len(AllTrim(SZ1->Z1_HORA)) == 5
			cHora := Alltrim(SZ1->Z1_HORA) + ":00"
		else
			cHora := Alltrim(SZ1->Z1_HORA)
		Endif

		If Elaptime(cHora, Time()) < "00:05:00"
			SZ1->(dbSkip())

			Loop
		EndIf

		If AllTrim(SZ1->Z1_PDV) == AllTrim(cPDV) .and. SZ1->Z1_TRAMITE == "N" .and. SZ1->Z1_VENDA == "S"
			// --- Cria Tag de Envio
			// ---------------------
			cEnvSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
			cEnvSoap += '  <soapenv:Header/>'
			cEnvSoap += '  <soapenv:Body>'
			cEnvSoap += '    <sAxml_envio>'
			cEnvSoap += 'Z0000010103'                                                                            // Cabeï¿½alho
			cEnvSoap += '0'
			cEnvSoap += Replicate("0",19 - Len(AllTrim(SZ1->Z1_CARTAO))) + AllTrim(SZ1->Z1_CARTAO)               // Numero do Cartï¿½o
			cEnvSoap += StrZero(Val(Substr(cFilAnt,3,2)),4)                                                      // Codigo loja
			cEnvSoap += PadR(AllTrim(SZ1->Z1_PDV),3)                                                             // Codigo do PDV
			cEnvSoap += PadR(SZ1->Z1_NUM,6)                                                                      // Numero do Cupom
			cEnvSoap += '007'                                                                                    // Codigo Finalizadora
			cEnvSoap += Substr(SZ1->Z1_EMISSAO,7,2) + Substr(SZ1->Z1_EMISSAO,5,2) + Substr(SZ1->Z1_EMISSAO,1,4)  // Data de venda
			cEnvSoap += Replicate("0",4)
			cEnvSoap += Strzero(Val(StrTran(Str(SZ1->Z1_VALOR,12,2),".","")),12)                                 // Valor da Venda
			cEnvSoap += Replicate("0",81)
			cEnvSoap += SZ1->Z1_AUTORI
			cEnvSoap += Replicate("0",12)
			cEnvSoap += Strzero(Val(SZ1->Z1_PARCELA),3)                                                         // Quantidade de parcelas
			cEnvSoap += Replicate("0",05)
			cEnvSoap += Replicate(" ",26)
			cEnvSoap += Replicate("0",34)
			cEnvSoap += '   </sAxml_envio>'
			cEnvSoap += '  </soapenv:Body>'
			cEnvSoap += '</soapenv:Envelope>'

			aRet := U_RIOF9001(cEnvSoap,"0103","")

			If ! aRet[01]
				FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
					"Venda nao foi enviada para Administradora, problema tecnico, sera enviada no proximo processamento.",;
					0,(nStart - Seconds()),{})
			else
				nConte++

				dbSelectArea("SZ1")

				Reclock("SZ1",.F.)
				Replace SZ1->Z1_TRAMITE with "S"
				SZ1->(MsUnlock())
			EndIf
		EndIf

		SZ1->(dbSkip())
	EndDo

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
		"(SZ1) - Vendas enviadas para Administradora - Qtde : " + AllTrim(Str(nConte)),0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","02","*** FIM ENVIO VENDAS (SZ1) ***",0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","03","******************************",0,(nStart - Seconds()),{})

	// --- Enviar os registros Cancelamento de Venda
	// --- Administradora do Cartão
	// ---------------------------------------------
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** INICIO ENVIO CANCELAMENTO DE VENDAS (SZ1) ***",0,(nStart - Seconds()),{})

	dbSelectArea("SZ1")
	SZ1->(dbSetOrder(7))
	SZ1->(dbGoTop())

	nConte := 0

	If SZ1->(dbSeek(xFilial("SZ1") + "N"))
		While ! SZ1->(Eof()) .and. SZ1->Z1_TRANCAN == "N"
			If ! Empty(DToS(SZ1->Z1_DATCANC))
				If Len(AllTrim(SZ1->Z1_HORA)) == 5
					cHora := Alltrim(SZ1->Z1_HORA) + ":00"
				else
					cHora := Alltrim(SZ1->Z1_HORA)
				Endif

				If Elaptime(cHORA, Time()) < "00:05:00"
					SZ1->(dbSkip())

					Loop
				EndIf

				// --- Enviar os registros Cancelamento de Venda
				// --- Administradora do Cartão
				// ---------------------------------------------
				cEnvSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
				cEnvSoap += '  <soapenv:Header/>'
				cEnvSoap += '  <soapenv:Body>'
				cEnvSoap += '    <sAxml_envio>'
				cEnvSoap += 'Z0000010196'                                                                // Cabeçalho - Serviço = 96
				cEnvSoap += Replicate("0",19 - Len(AllTrim(SZ1->Z1_CARTAO))) + AllTrim(SZ1->Z1_CARTAO)   // Numero do Cartão
				cEnvSoap += StrZero(Val(Substr(cFilAnt,3,2)),4)                                          // Codigo loja
				cEnvSoap += PadR(AllTrim(SZ1->Z1_PDV),3)                                                 // Codigo do PDV
				cEnvSoap += PadR(SZ1->Z1_NUM,6)                                                          // Numero do Cupom
				cEnvSoap += Strzero(Val(StrTran(Str(SZ1->Z1_VALOR,12,2),".","")),12)                     // Valor da Venda
				cEnvSoap += PadR(SZ1->Z1_AUTORI,16)                                                      // Código da Autorização
				cEnvSoap += '   </sAxml_envio>'
				cEnvSoap += '  </soapenv:Body>'
				cEnvSoap += '</soapenv:Envelope>'

				aRet := U_RIOF9001(cEnvSoap,"0196","")

				If aRet[01]
					nConte++

					Reclock("SZ1",.F.)
					Replace SZ1->Z1_TRANCAN with "S"
					SZ1->(MsUnlock())

				EndIf
				// -----------------------------------
			EndIf

			SZ1->(dbSkip())
		EndDo
	EndIf

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
		"(SZ1) - Cancelamento de Vendas enviadas para Administradora - Qtde : " + AllTrim(Str(nConte)),0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** FIM ENVIO CANCELAMENTO DE VENDAS (SZ1) ***",0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","**********************************************",0,(nStart - Seconds()),{})

	// --- Enviar os registros de pagamento de Fatura
	// --- RETAGUARDA
	// ----------------------------------------------
	dbSelectArea("SZ4")
	SZ4->(dbSetOrder(5))
	SZ4->(dbGoTop())

	nConte := 0

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** (1) INICIO ENVIO PAGAMENTO DE FATURA - RETAGUARDA (SZ44) ***",0,(nStart - Seconds()),{})

	While ! SZ4->(Eof()) .and. SZ4->Z4_TRANRET == "N"
		If SZ4->Z4_TRANRET == "S"
			FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** (1) REGISTRO ENVIADO PARA RETAGUARDA ANTERIORMENTE (SZ4) ***",0,(nStart - Seconds()),{})
			Exit
		EndIf

		If Len(AllTrim(SZ4->Z4_HORA)) == 5
			cHora := Alltrim(SZ4->Z4_HORA) + ":00"
		else
			cHora := Alltrim(SZ4->Z4_HORA)
		Endif

		If Elaptime(cHORA, Time()) < "00:05:00"
			SZ4->(dbSkip())

			Loop
		EndIf

		nConte++
        if (SZ4->Z4_CREDITO <> 0)
			cEnvSoap := '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
			cEnvSoap += '  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
			cEnvSoap += ' <soapenv:Header/>'
			cEnvSoap += ' <soap:Body>'
			cEnvSoap += '  <INCLSZ42>'
			cEnvSoap += '    <FORMCAD2>'
			cEnvSoap += '      <STSZ42>'
			cEnvSoap += '        <CARTAO>' + SZ4->Z4_CARTAO + '</CARTAO>'
			cEnvSoap += '        <CHEQUE>' + Str(SZ4->Z4_CHEQUE) + '</CHEQUE>'
			cEnvSoap += '        <DEBITO>' + Str(SZ4->Z4_DEBITO) + '</DEBITO>'
			cEnvSoap += '        <CREDITO>' + Str(SZ4->Z4_CREDITO) + '</CREDITO>'
			cEnvSoap += '        <DINHEIRO>' + Str(SZ4->Z4_DINHEIR) + '</DINHEIRO>'
			cEnvSoap += '        <DTOPERA>' + IIf(Len(SZ4->Z4_DATA) < 8,"20" + SZ4->Z4_DATA,SZ4->Z4_DATA) + '</DTOPERA>'
			cEnvSoap += '        <FILIAL>' + SZ4->Z4_FILIAL + '</FILIAL>'
			cEnvSoap += '        <HORA>' + SZ4->Z4_HORA + '</HORA>'
			cEnvSoap += '        <NOME>' + SZ4->Z4_NOMECLI + '</NOME>'
			cEnvSoap += '        <OPERADOR>' + SZ4->Z4_OPERADO + '</OPERADOR>'
			cEnvSoap += '        <PAGTO>' + Str(SZ4->Z4_VLPAGTO) + '</PAGTO>'
			cEnvSoap += '        <PDV>' + SZ4->Z4_PDV + '</PDV>'
			cEnvSoap += '        <VALOR>' + Str(SZ4->Z4_VALOR) + '</VALOR>'
			cEnvSoap += '        <SEQUENCIA>' + SZ4->Z4_SEQ + '</SEQUENCIA>'
			cEnvSoap += '      </STSZ42>'
			cEnvSoap += '    </FORMCAD2>'
			cEnvSoap += '  </INCLSZ42>'
			cEnvSoap += ' </soap:Body>'
			cEnvSoap += '</soap:Envelope>'
	
			aRet := U_RIOF9002("SZ42",cEnvSoap)    // Levar o Pagamento Cartão pra retaguarda CC
		else
			cEnvSoap := '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
			cEnvSoap += '  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
			cEnvSoap += ' <soapenv:Header/>'
			cEnvSoap += ' <soap:Body>'
			cEnvSoap += '  <INCLSZ4>'
			cEnvSoap += '    <FORMCAD>'
			cEnvSoap += '      <STSZ4>'
			cEnvSoap += '        <CARTAO>' + SZ4->Z4_CARTAO + '</CARTAO>'
			cEnvSoap += '        <CHEQUE>' + Str(SZ4->Z4_CHEQUE) + '</CHEQUE>'
			cEnvSoap += '        <DEBITO>' + Str(SZ4->Z4_DEBITO) + '</DEBITO>'
			cEnvSoap += '        <DINHEIRO>' + Str(SZ4->Z4_DINHEIR) + '</DINHEIRO>'
			cEnvSoap += '        <DTOPERA>' + IIf(Len(SZ4->Z4_DATA) < 8,"20" + SZ4->Z4_DATA,SZ4->Z4_DATA) + '</DTOPERA>'
			cEnvSoap += '        <FILIAL>' + SZ4->Z4_FILIAL + '</FILIAL>'
			cEnvSoap += '        <HORA>' + SZ4->Z4_HORA + '</HORA>'
			cEnvSoap += '        <NOME>' + SZ4->Z4_NOMECLI + '</NOME>'
			cEnvSoap += '        <OPERADOR>' + SZ4->Z4_OPERADO + '</OPERADOR>'
			cEnvSoap += '        <PAGTO>' + Str(SZ4->Z4_VLPAGTO) + '</PAGTO>'
			cEnvSoap += '        <PDV>' + SZ4->Z4_PDV + '</PDV>'
			cEnvSoap += '        <VALOR>' + Str(SZ4->Z4_VALOR) + '</VALOR>'
			cEnvSoap += '        <SEQUENCIA>' + SZ4->Z4_SEQ + '</SEQUENCIA>'
			cEnvSoap += '      </STSZ4>'
			cEnvSoap += '    </FORMCAD>'
			cEnvSoap += '  </INCLSZ4>'
			cEnvSoap += ' </soap:Body>'
			cEnvSoap += '</soap:Envelope>'
	
			aRet := U_RIOF9002("SZ4",cEnvSoap)    // Levar o Pagamento Cartão pra retaguarda CD
		ENDIF

		If aRet[01]
			Reclock("SZ4",.F.)
			Replace SZ4->Z4_TRANRET with "S"
			SZ4->(MsUnlock())
			nConte++
		EndIf

		FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","====== (SZ4) - " + aRet[02] + "=====",0,(nStart - Seconds()),{})

		SZ4->(dbSkip())
	EndDo

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
		"(1) (SZ4) - Pagamento de Fatura enviadas para Retaguarda - Qtde : " + AllTrim(Str(nConte)),0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** (1) FIM ENVIO PAGAMENTO DE FATURA - RETAGUARDA (SZ4) ***",0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","********************************************************",0,(nStart - Seconds()),{})

	// --- Enviar os registros de pagamento de Fatura
	// --- Administradora do Cartão
	// ----------------------------------------------
	dbSelectArea("SZ4")
	SZ4->(dbSetOrder(2))
	SZ4->(dbGoTop())

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** (2) INICIO ENVIO PAGAMENTO DE FATURA - ADMINISTRADORA (SZ4) ***",0,(nStart - Seconds()),{})

	nConte := 0

	While ! SZ4->(Eof()) .and. SZ4->Z4_TRANSMI == "N"
		If SZ4->Z4_TRANSMI == "S"
			Exit
		EndIf

		If Len(AllTrim(SZ4->Z4_HORA)) == 5
			cHora := Alltrim(SZ4->Z4_HORA) + ":00"
		else
			cHora := Alltrim(SZ4->Z4_HORA)
		Endif

		If Elaptime(cHORA, Time()) < "00:05:00"
			SZ4->(dbSkip())

			Loop
		EndIf

		// --- Acessar WebService (Soap)
		// ----------------------------
		oWsdl := TWsdlManager():New()
		oWsdl:nTimeout := 120
        oWsdl:lSSLInsecure := .T.

		lWebSrv := oWsdl:ParseURL(cURLCad)

		If ! lWebSrv
			FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
				"Administradora fora do ar, venda sera enviada no proximo processamento.",0,(nStart - Seconds()),{})

			Exit
		EndIf

		// --- Evento enviar Pagamento de Fatura Administrador
		// ---------------------------------------------------
		lWebSrv := oWsdl:SetOperation("ConsultaMessage")

		If ! lWebSrv
			FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","Erro (Metodo - 'ConsultaMessage'): " + oWsdl:cError,0,(nStart - Seconds()),{})
			Exit
		EndIf

		// --- Cria Tag de Envio
		// ---------------------
		cEnvSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
		cEnvSoap += '  <soapenv:Header/>'
		cEnvSoap += '  <soapenv:Body>'
		cEnvSoap += '    <sAxml_envio>'
		cEnvSoap += 'Z0000010171'                                                                   // Cabeï¿½alho
		cEnvSoap += '04'                                                                            // Tipo de Consulta
		cEnvSoap += Replicate("0",19 - Len(AllTrim(SZ4->Z4_CARTAO))) + AllTrim(SZ4->Z4_CARTAO)      // Numero do Cartï¿½o
		cEnvSoap += Strzero(Val(StrTran(Str(SZ4->Z4_VLPAGTO,16,2),".","")),16)                      // Valor da Venda
		cEnvSoap += Replicate(" ",32)                                                               // Documento
		cEnvSoap += Replicate(" ",6)                                                                // Cï¿½digo da funï¿½ï¿½o
		cEnvSoap += StrZero(Val(Substr(cFilAnt,3,2)),3)                                             // Codigo loja
		cEnvSoap += PadR(AllTrim(SZ4->Z4_PDV),3)                                                    // Codigo do PDV
		cEnvSoap += Substr(SZ4->Z4_SEQ,5,6)                                                         // Numero do Cupom
		cEnvSoap += Substr(SZ4->Z4_DATA,7,2) + Substr(SZ4->Z4_DATA,5,2) + Substr(SZ4->Z4_DATA,1,4)  // Data do Pagamento da fatura
		cEnvSoap += '   </sAxml_envio>'
		cEnvSoap += '  </soapenv:Body>'
		cEnvSoap += '</soapenv:Envelope>'

		lWebSrv := oWsdl:SendSoapMsg(cEnvSoap)

		// Pega a mensagem de resposta e converter em string
		aRet := U_RIOF9001(AllTrim(oWsdl:GetSoapResponse()),"0171","")

		If ! aRet[01]
			FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
				"Pagamento Fatura nao foi enviada para Administradora, problema tecnico, serao enviada no proximo processamento.",;
				0,(nStart - Seconds()),{})
		else
			nConte++

			Reclock("SZ4",.F.)
			Replace SZ4->Z4_TRANSMI with "S"
			SZ4->(MsUnlock())
		EndIf

		SZ4->(dbSkip())
	EndDo

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
		"(2) (SZ4) - Pagamento de Fatura enviadas para Administradora - Qtde : " + AllTrim(Str(nConte)),0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** (2) FIM ENVIO PAGAMENTO DE FATURA - ADMINISTRADORA (SZ4) ***",0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","************************************************************",0,(nStart - Seconds()),{})

	// --- Enviar os registros de pagamento Cartão x Cheque
	// ----------------------------------------------------
	dbSelectArea("SZ5")
	SZ5->(dbSetOrder(2))
	SZ5->(dbGoTop())

	cEnvSoap := ""

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** INICIO ENVIO PAGAMENTO CARTAO x CHEQUE (SZ5) ***",0,(nStart - Seconds()),{})

	nConte := 0
	While ! SZ5->(Eof()) .and. SZ5->Z5_TRANSMI == "N"
		If SZ5->Z5_TRANSMI == "S"
			Exit
		EndIf

		If Len(AllTrim(SZ5->Z5_HORA)) == 5
			cHora := Alltrim(SZ5->Z5_HORA) + ":00"
		else
			cHora := Alltrim(SZ5->Z5_HORA)
		Endif

		If Elaptime(cHORA, Time()) < "00:05:00"
			SZ5->(dbSkip())

			Loop
		EndIf

		// --- Gravar tabela Cheque x Fatura
		// ---------------------------------
		cEnvSoap := '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
		cEnvSoap += '  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
		cEnvSoap += ' <soapenv:Header/>'
		cEnvSoap += ' <soap:Body>'
		cEnvSoap += '  <INCLSZ5>'
		cEnvSoap += '    <FORMCCH>'
		cEnvSoap += '      <STSZ5>'
		cEnvSoap += '        <AGENCIA>' + SZ5->Z5_AGENCIA + '</AGENCIA>'
		cEnvSoap += '        <BANCO>' + SZ5->Z5_BANCO + '</BANCO>'
		cEnvSoap += '        <CARTAO>' + SZ5->Z5_CARTAO + '</CARTAO>'
		cEnvSoap += '        <CHEQUE>' + SZ5->Z5_NUMCHQ + '</CHEQUE>'
		cEnvSoap += '        <CPFCNPJ>' + SZ5->Z5_CPFCNPJ + '</CPFCNPJ>'
		cEnvSoap += '        <CONTA>' + SZ5->Z5_CONTA + '</CONTA>'
		cEnvSoap += '        <DIGITO>' + SZ5->Z5_DVCTA + '</DIGITO>'
		cEnvSoap += '        <DTOPERA>' + DToS(SZ5->Z5_DATA) + '</DTOPERA>'
		cEnvSoap += '        <EMITENTE>' + SZ5->Z5_EMITENT + '</EMITENTE>'
		cEnvSoap += '        <FILIAL>' + cFilAnt + '</FILIAL>'
		cEnvSoap += '        <HORA>' + SZ5->Z5_HORA + '</HORA>'
		cEnvSoap += '        <NSU>' + SZ5->Z5_NSU + '</NSU>'
		cEnvSoap += '        <OPERADOR>' + SZ5->Z5_OPERADO + '</OPERADOR>'
		cEnvSoap += '        <PDV>' + SZ5->Z5_PDV + '</PDV>'
		cEnvSoap += '        <TIPO>' + SZ5->Z5_TIPO + '</TIPO>'
		cEnvSoap += '        <SEQUENCIA>' + SZ5->Z5_SEQ + '</SEQUENCIA>'
		cEnvSoap += '        <VALOR>' + Str(SZ5->Z5_VALOR) + '</VALOR>'
		cEnvSoap += '      </STSZ5>'
		cEnvSoap += '    </FORMCCH>'
		cEnvSoap += '  </INCLSZ5>'
		cEnvSoap += ' </soap:Body>'
		cEnvSoap += '</soap:Envelope>'

		aRet := U_RIOF9002("SZ5",cEnvSoap)    // Levar recebimento pra retaguarda

		FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","====== (SZ5) - " + aRet[02] + "=====",0,(nStart - Seconds()),{})

		If aRet[01] .and. Substr(aRet[02],1,3) == "100"
			nConte++

			Reclock("SZ5",.F.)
			Replace SZ5->Z5_TRANSMI with "S"
			SZ5->(MsUnlock())

			// --- Enviar gravar tï¿½tulo do Cheque
			// ----------------------------------
			cNumTit := StrZero(Val(Posicione("SX5",1,xFilial("SX5") + "01" + SLG->LG_SERNFIS,"X5_DESCRI")),TamSX3("E1_NUM")[1])
/*
			cEnvSoap := '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
			cEnvSoap += '  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
			cEnvSoap += ' <soapenv:Header/>'
			cEnvSoap += ' <soap:Body>'
			cEnvSoap += '  <INCLSE1>'
			cEnvSoap += '    <FORMREC>'
			cEnvSoap += '      <STSE1>'
			cEnvSoap += '        <AGENCIA></AGENCIA>'
			cEnvSoap += '        <BANCO></BANCO>'
			cEnvSoap += '        <BAIXAR>N</BAIXAR>'
			cEnvSoap += '        <CLIENTE>000000001</CLIENTE>'
			cEnvSoap += '        <CONTA></CONTA>'
			cEnvSoap += '        <EMISSAO>' + DToS(SZ5->Z5_DATA) + '</EMISSAO>'
			cEnvSoap += '        <FILIAL>' + cFilAnt + '</FILIAL>'
			cEnvSoap += '        <HISTORICO>REC. FATURA RIO CENTER</HISTORICO>'
			cEnvSoap += '        <LOJA>0001</LOJA>'
            //			cEnvSoap += '        <NATUREZA>' + IIf(SZ5->Z5_TIPO == 'CD',cNatDeb,cNatChq) + '</NATUREZA>'
			If (SZ5->Z5_TIPO == 'CD')
     			cEnvSoap += '        <NATUREZA>' + cNatDeb + '</NATUREZA>'
			elseif  (SZ5->Z5_TIPO == 'CC')      
     			cEnvSoap += '        <NATUREZA>' + cNatCre + '</NATUREZA>'
			else
     			cEnvSoap += '        <NATUREZA>' + cNatChq + '</NATUREZA>'
			endif	 	 
			cEnvSoap += '        <NMCARTAO></NMCARTAO>'
			cEnvSoap += '        <NNNSU>'+ SZ5->Z5_NSU + '</NNNSU>'
			cEnvSoap += '        <NTITULO>' + cNumTit + '</NTITULO>'
			cEnvSoap += '        <NSUSITEF></NSUSITEF>'
			cEnvSoap += '        <PORTADOR>' + SZ5->Z5_OPERADO + '</PORTADOR>'
			cEnvSoap += '        <PREFIXO>F' + Substr(SLG->LG_PDV,2,2) + '</PREFIXO>'
			cEnvSoap += '        <ORIGEM>FINA040</ORIGEM>'
			cEnvSoap += '        <TIPO>' + SZ5->Z5_TIPO + '</TIPO>'
			cEnvSoap += '        <VALOR>' + Str(SZ5->Z5_VALOR) + '</VALOR>'
			If (SZ5->Z5_TIPO == 'CD')
		    	cEnvSoap += '        <VENCTO>' + DToS(SZ5->Z5_DATA + 1) + '</VENCTO>'
            ELSE
		    	cEnvSoap += '        <VENCTO>' + DToS(SZ5->Z5_DATA) + '</VENCTO>'
			ENDIF	
			cEnvSoap += '      </STSE1>'
			cEnvSoap += '    </FORMREC>'
			cEnvSoap += '  </INCLSE1>'
			cEnvSoap += ' </soap:Body>'
			cEnvSoap += '</soap:Envelope>'

			aRet := U_RIOF9002("SE1",cEnvSoap)    // Gravar título na retaguarda
*/

			cEnvSoap := '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
			cEnvSoap += '  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
			cEnvSoap += ' <soapenv:Header/>'
			cEnvSoap += ' <soap:Body>'
			cEnvSoap += '  <INCLSE12>'
			cEnvSoap += '    <FORMREC2>'
			cEnvSoap += '      <STSE12>'
			cEnvSoap += '        <AGENCIA></AGENCIA>'
			cEnvSoap += '        <BANCO></BANCO>'
			cEnvSoap += '        <BAIXAR>N</BAIXAR>'
			cEnvSoap += '        <CLIENTE>000000001</CLIENTE>'
			cEnvSoap += '        <CONTA></CONTA>'
			cEnvSoap += '        <PARCELA>1</PARCELA>'
			cEnvSoap += '        <EMISSAO>' + DToS(SZ5->Z5_DATA) + '</EMISSAO>'
			cEnvSoap += '        <FILIAL>' + cFilAnt + '</FILIAL>'
			cEnvSoap += '        <HISTORICO>REC. FATURA RIO CENTER</HISTORICO>'
			cEnvSoap += '        <LOJA>0001</LOJA>'
            //			cEnvSoap += '        <NATUREZA>' + IIf(SZ5->Z5_TIPO == 'CD',cNatDeb,cNatChq) + '</NATUREZA>'
			If (SZ5->Z5_TIPO == 'CD')
     			cEnvSoap += '        <NATUREZA>' + cNatDeb + '</NATUREZA>'
			elseif  (SZ5->Z5_TIPO == 'CC')      
     			cEnvSoap += '        <NATUREZA>' + cNatCre + '</NATUREZA>'
			else
     			cEnvSoap += '        <NATUREZA>' + cNatChq + '</NATUREZA>'
			endif	 	 
			cEnvSoap += '        <NMCARTAO></NMCARTAO>'
			cEnvSoap += '        <NNNSU>'+ SZ5->Z5_NSU + '</NNNSU>'
			cEnvSoap += '        <NTITULO>' + cNumTit + '</NTITULO>'
			cEnvSoap += '        <NSUSITEF>'+ SZ5->Z5_NSU + '</NSUSITEF>'
			cEnvSoap += '        <PORTADOR>' + SZ5->Z5_OPERADO + '</PORTADOR>'
			cEnvSoap += '        <PREFIXO>F' + Substr(SLG->LG_PDV,2,2) + '</PREFIXO>'
			cEnvSoap += '        <ORIGEM>FINA040</ORIGEM>'
			cEnvSoap += '        <TIPO>' + SZ5->Z5_TIPO + '</TIPO>'

			If (SZ5->Z5_TIPO == 'CD')      
			  cEnvSoap += '        <VALOR>' + Str(SZ5->Z5_VALOR * (100 - nTaxaCD) / 100) + '</VALOR>'
			ELSE  
			  cEnvSoap += '        <VALOR>' + Str(SZ5->Z5_VALOR) + '</VALOR>'
			END  

			cEnvSoap += '        <VLRREAL>' + Str(SZ5->Z5_VALOR) + '</VLRREAL>'
			If (SZ5->Z5_TIPO == 'CD')
		    	cEnvSoap += '        <VENCTO>' + DToS(SZ5->Z5_DATA + 1) + '</VENCTO>'
            ELSE
		    	cEnvSoap += '        <VENCTO>' + DToS(SZ5->Z5_DATA) + '</VENCTO>'
			ENDIF	
			cEnvSoap += '      </STSE12>'
			cEnvSoap += '    </FORMREC2>'
			cEnvSoap += '  </INCLSE12>'
			cEnvSoap += ' </soap:Body>'
			cEnvSoap += '</soap:Envelope>'

			aRet := U_RIOF9002("SE12",cEnvSoap)    // Gravar título na retaguarda

			FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","====== (SE1) - " + aRet[02] + "=====",0,(nStart - Seconds()),{})

			If aRet[01] .and. Substr(aRet[02],1,3) == "100"
				cNumTitX5 := StrZero(Val(cNumTit) + 1,TamSX3("E1_NUM")[1])

				FwPutSX5("", "01", SLG->LG_SERNFIS, cNumTitX5, cNumTitX5, cNumTitX5)

				If SZ5->Z5_TIPO == "CH"
					// --- Gravar tabela de Cheque (SEF)
					// ---------------------------------
					cEnvSoap := '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
					cEnvSoap += '  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
					cEnvSoap += ' <soapenv:Header/>'
					cEnvSoap += ' <soap:Body>'
					cEnvSoap += '  <INCLSEF>'
					cEnvSoap += '    <FORMCHQ>'
					cEnvSoap += '      <STSEF>'
					cEnvSoap += '        <AGENCIA>' + SZ5->Z5_AGENCIA + '</AGENCIA>'
					cEnvSoap += '        <BANCO>' + SZ5->Z5_BANCO + '</BANCO>'
					cEnvSoap += '        <CLIENTE>000000001</CLIENTE>'
					cEnvSoap += '        <CPFCNPJ>' + SZ5->Z5_CPFCNPJ + '</CPFCNPJ>'
					cEnvSoap += '        <CONTA>' + SZ5->Z5_CONTA + '</CONTA>'
					cEnvSoap += '        <DTCHEQUE>' + DToS(SZ5->Z5_DATA) + '</DTCHEQUE>'
					cEnvSoap += '        <EMITENTE>' + SZ5->Z5_EMITENT + '</EMITENTE>'
					cEnvSoap += '        <FILIAL>' + SZ5->Z5_FILIAL + '</FILIAL>'
					cEnvSoap += '        <HISTORICO>REC. FATURA RIO CENTER</HISTORICO>'
					cEnvSoap += '        <LOJA>0001</LOJA>'
					cEnvSoap += '        <NMCHEQUE>' + SZ5->Z5_NUMCHQ + '</NMCHEQUE>'
					cEnvSoap += '        <PREFIXO>F' + Substr(SLG->LG_PDV,2,2) + '</PREFIXO>'
					cEnvSoap += '        <TITULO>' + cNumTit + '</TITULO>'
					cEnvSoap += '        <VALOR>' + Str(SZ5->Z5_VALOR) + '</VALOR>'
					cEnvSoap += '        <VENCTO>' + DToS(SZ5->Z5_DATA) + '</VENCTO>'
					cEnvSoap += '      </STSEF>'
					cEnvSoap += '    </FORMCHQ>'
					cEnvSoap += '  </INCLSEF>'
					cEnvSoap += ' </soap:Body>'
					cEnvSoap += '</soap:Envelope>'

					aRet := U_RIOF9002("SEF",cEnvSoap)    // Levar os cheques pra retaguarda

					FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","====== (SEF) - " + aRet[02] + "=====",0,(nStart - Seconds()),{})
				EndIf
			EndIf
		EndIf

		SZ5->(dbSkip())
	EndDo

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
		"(SZ5) - Pagamento de Fatura - Cartao x Cheque enviados para Retaguarda - Qtde : " + AllTrim(Str(nConte)),0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** FIM ENVIO PAGAMENTO CARTAO x CHEQUE (SZ5) ***",0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*************************************************",0,(nStart - Seconds()),{})

	// --- Enviar os registros de pagamento fatura (Tï¿½tulo)
	// ----------------------------------------------------
	dbSelectArea("SE5")
	SE5->(dbOrderNickName("RETRANSE5"))
	SE5->(dbGoTop())

	cEnvSoap := ""

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** INICIO ENVIO PAGAMENTO FATURA - MOVIMENTACAO (SE5) ***",0,(nStart - Seconds()),{})

	nConte := 0

	While ! SE5->(Eof()) .and. SE5->E5_XTRANSM == "N"
		If SE5->E5_XTRANSM == "S"
			Exit
		EndIf

		cEnvSoap := '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
		cEnvSoap += '  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
		cEnvSoap += ' <soapenv:Header/>'
		cEnvSoap += ' <soap:Body>'
		cEnvSoap += '  <INCLSE1>'
		cEnvSoap += '    <FORMREC>'
		cEnvSoap += '      <STSE1>'
		cEnvSoap += '        <AGENCIA></AGENCIA>'
		cEnvSoap += '        <BANCO>' + SE5->E5_BANCO + '</BANCO>'
		cEnvSoap += '        <BAIXAR>S</BAIXAR>'
		cEnvSoap += '        <CLIENTE>000000001</CLIENTE>'
		cEnvSoap += '        <CONTA></CONTA>'
		cEnvSoap += '        <EMISSAO>' + DToS(SE5->E5_DATA) + '</EMISSAO>'
		cEnvSoap += '        <FILIAL>' + cFilAnt + '</FILIAL>'
		cEnvSoap += '        <HISTORICO>REC. FATURA RIO CENTER</HISTORICO>'
		cEnvSoap += '        <LOJA>0001</LOJA>'
		cEnvSoap += '        <NATUREZA>' + cNatDin + '</NATUREZA>'
		cEnvSoap += '        <NMCARTAO></NMCARTAO>'
		cEnvSoap += '        <NNNSU></NNNSU>'
		cEnvSoap += '        <NTITULO>' + SE5->E5_NUMERO + '</NTITULO>'
		cEnvSoap += '        <NSUSITEF></NSUSITEF>'
		cEnvSoap += '        <PORTADOR>' + SE5->E5_BANCO + '</PORTADOR>'
		cEnvSoap += '        <PREFIXO>' + SE5->E5_PREFIXO + '</PREFIXO>'
		cEnvSoap += '        <ORIGEM>FINA040</ORIGEM>'
		cEnvSoap += '        <TIPO>FI</TIPO>'
		cEnvSoap += '        <VALOR>' + Str(SE5->E5_VALOR) + '</VALOR>'
		cEnvSoap += '        <VENCTO>' + DToS(SE5->E5_DATA) + '</VENCTO>'
		cEnvSoap += '      </STSE1>'
		cEnvSoap += '    </FORMREC>'
		cEnvSoap += '   </INCLSE1>'
		cEnvSoap += ' </soap:Body>'
		cEnvSoap += '</soap:Envelope>'

		aRet := U_RIOF9002("SE1",cEnvSoap)    // gravar titulo e baixar na retaguarda recebimento em dinheiro Rio Center

		If aRet[01] .and. Substr(aRet[02],1,3) == "100"
			nConte++

			Reclock("SE5",.F.)
			Replace SE5->E5_XTRANSM with "S"
			SE5->(MsUnlock())
		EndIf

		FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","====== (SE5) - " + aRet[02] + "=====",0,(nStart - Seconds()),{})

		SE5->(dbSkip())
	EndDo

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
		"(SE5) - Pagamento - Movimentacao enviadas para Retaguarda - Qtde : " + AllTrim(Str(nConte)),0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** FIM ENVIO PAGAMENTO FATURA - MOVIMENTACAO (SE5) ***",0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*******************************************************",0,(nStart - Seconds()),{})

	// --- Enviar os registros de pagamento fatura (Título)
	// ----------------------------------------------------
	dbSelectArea("SL1")
	SL1->(dbOrderNickName("RETRAXML"))
	SL1->(dbGoTop())

	cEnvSoap := ""

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** INICIO ENVIO XML CUPOM (SL1) ***",0,(nStart - Seconds()),{})

	nConte := 0

	While ! SL1->(Eof()) .and. SL1->L1_XTRAXML == "N"
		If SL1->L1_XTRAXML == "S"
			Exit
		EndIf

		If Len(AllTrim(SL1->L1_HORA)) == 5
			cHora := Alltrim(SL1->L1_HORA) + ":00"
		else
			cHora := Alltrim(SL1->L1_HORA)
		Endif

		If Elaptime(cHORA, Time()) < "00:05:00"
			SL1->(dbSkip())

			Loop
		EndIf

		dbSelectArea("SL2")
		SL2->(dbGoTop())
		SL2->(dbSetOrder(1))

		aCupons := {}

		If SL2->(dbSeek(xFilial("SL2") + SL1->L1_NUM))
			While ! SL2->(Eof()) .and. SL2->L2_FILIAL == xFilial("SL1") .and. SL2->L2_NUM == SL1->L1_NUM
				aAdd(aCupons,{StrZero(Val(Substr(cFilAnt,3,2)),4),     /* 01 = Filial - codigo da loja */;
					SL1->L1_PDV,                             /* 02 = PDV */;
					SL1->L1_CGCCLI,                          /* 03 = CPF informado no cupom */;
					SL1->L1_OPERADO,                         /* 04 = Operador */;
					SL2->L2_ITEM,                            /* 05 = Número do ítem */;
					SL2->L2_PRODUTO,                         /* 06 = Código do porduto */;
					SL2->L2_QUANT,                           /* 07 = Quantidade do item */;
					SL2->L2_VRUNIT,                          /* 08 = Valor unitário */;
					SL2->L2_VALDESC,                         /* 09 = Valor do desconto */;
					SL2->L2_VLRITEM})                        /* 10 = Valor total do item */

				SL2->(dbSkip())
			EndDo

			// --- Forma de Pagamentos
			// -----------------------
			dbSelectArea("SL4")
			SL4->(dbGoTop())
			SL4->(dbSetOrder(1))

			aPagtos := {}

			If SL4->(dbSeek(xFilial("SL4") + SL1->L1_NUM))
				While ! SL4->(Eof()) .and. SL4->L4_FILIAL == xFilial("SL1") .and. SL4->L4_NUM == SL1->L1_NUM
					nPos := aScan(aPagtos, {|x| x[1] == SL4->L4_FORMA .and. x[2] == Substr(SL4->L4_ADMINIS,1,3)})

					If nPos > 0
						aPagtos[nPos][03] += SL4->L4_VALOR
						aPagtos[nPos][04]++
					else
						aAdd(aPagtos, {SL4->L4_FORMA,                     /* 01 = Forma de Pagamento */;
							Substr(SL4->L4_ADMINIS,1,3),       /* 02 = Administradora do Cartï¿½o */;
							SL4->L4_VALOR,                     /* 03 = Valor pago */;
							IIf(SL4->L4_FORMA == "R$",0,1)})   /* 04 = Quantidade de parcelas */
					EndIf

					SL4->(dbSkip())
				EndDo
			EndIf

			If Len(aCupons) > 0 .and. Len(aPagtos) > 0
				cEnvSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
				cEnvSoap += '  <soapenv:Header/>'
				cEnvSoap += '  <soapenv:Body>'
				cEnvSoap += '   <ns1:sAxml_envio xmlns:ns1="urn:nsfideliz">'
				cEnvSoap += '    &lt;Fideliz&gt;'
				cEnvSoap += '      &lt;tipo_acesso&gt;1&lt;/tipo_acesso&gt;'
				cEnvSoap += '      &lt;id_acesso&gt;1&lt;/id_acesso&gt;'
				cEnvSoap += '      &lt;dados&gt;'
				cEnvSoap += '        &lt;cod_loja&gt;' + aCupons[01][01] + '&lt;/cod_loja&gt;'
				cEnvSoap += '        &lt;num_pdv&gt;' + aCupons[01][02] + '&lt;/num_pdv&gt;'
				cEnvSoap += '        &lt;num_docum&gt;' + SL1->L1_NUM + '&lt;/num_docum&gt;'
				cEnvSoap += '        &lt;tipo_venda&gt;2&lt;/tipo_venda&gt;'
				cEnvSoap += '        &lt;id_cliente&gt;' + aCupons[01][03] + '&lt;/id_cliente&gt;'
				cEnvSoap += '        &lt;num_itens&gt;' + AllTrim(Str(Len(aCupons))) + '&lt;/num_itens&gt;'
				cEnvSoap += '        &lt;retornapontos&gt;1&lt;/retornapontos&gt;'
				cEnvSoap += '        &lt;dddcel&gt;&lt;/dddcel&gt;'
				cEnvSoap += '        &lt;nrocel&gt;&lt;/nrocel&gt;'
				cEnvSoap += '        &lt;operador&gt;' + aCupons[01][04] + '&lt;/operador&gt;'
				cEnvSoap += '        &lt;itens&gt;'

				For nPos := 1 To Len(aCupons)
					cEnvSoap += '          &lt;item&gt;'
					cEnvSoap += '            &lt;posicao&gt;' + AllTrim(Str(nPos)) + '&lt;/posicao&gt;'
					cEnvSoap += '            &lt;codigo&gt;' + aCupons[nPos][06] + '&lt;/codigo&gt;'
					cEnvSoap += '            &lt;quantidade&gt;' + Str(aCupons[nPos][07]) + '&lt;/quantidade&gt;'
					cEnvSoap += '            &lt;valor_unitario&gt;' + Str(aCupons[nPos][08]) + '&lt;/valor_unitario&gt;'
					cEnvSoap += '            &lt;valor_acrescimo&gt;0.00&lt;/valor_acrescimo&gt;'
					cEnvSoap += '            &lt;valor_desconto&gt;' + Str(aCupons[nPos][09]) + '&lt;/valor_desconto&gt;'
					cEnvSoap += '            &lt;valor_total&gt;' + Str(aCupons[nPos][10]) + '&lt;/valor_total&gt;'
					cEnvSoap += '            &lt;pmz&gt;0.00&lt;/pmz&gt;'
					cEnvSoap += '          &lt;/item&gt;'
				Next

				cEnvSoap += '        &lt;/itens&gt;'
				cEnvSoap += '        &lt;finalizadoras&gt;'

				For nPos := 1 To Len(aPagtos)
					cEnvSoap += '       &lt;finalizadora&gt;'
					cEnvSoap += '          &lt;posicao&gt;' + AllTrim(Str(nPos)) + '&lt;/posicao&gt;'
					cEnvSoap += '          &lt;codigo&gt;' + aPagtos[nPos][02] + '&lt;/codigo&gt;'
					cEnvSoap += '          &lt;valor&gt;' + Str(aPagtos[nPos][03]) + '&lt;/valor&gt;'
					cEnvSoap += '          &lt;bin&gt;&lt;/bin&gt;'

					If aPagtos[nPos][01] == "R$"
						cEnvSoap += '       &lt;qtdparcelas&gt;&lt;/qtdparcelas&gt;'
						cEnvSoap += '       &lt;cartao&gt;&lt;/cartao&gt;'
					else
						cEnvSoap += '       &lt;qtdparcelas&gt;' + Str(aPagtos[nPos][04]) + '&lt;/qtdparcelas&gt;'
						cEnvSoap += '       &lt;cartao&gt;&lt;/cartao&gt;'
					EndIf

					cEnvSoap += '       &lt;/finalizadora&gt;'
				Next

				cEnvSoap += '         &lt;/finalizadoras&gt;'
				cEnvSoap += '       &lt;/dados&gt;'
				cEnvSoap += '     &lt;/Fideliz&gt;'
				cEnvSoap += '   </ns1:sAxml_envio>'
				cEnvSoap += '   <nsl:nACodLojaTrans xmlns:nsl="urn:nsfideliz">1</nsl:nACodLojaTrans>'
				cEnvSoap += '   <nsl:nACodPDVTrans xmlns:nsl="urn:nsfideliz">1</nsl:nACodPDVTrans>'
				cEnvSoap += '  </soapenv:Body>'
				cEnvSoap += '</soapenv:Envelope>'

				aRet := U_RIOF9001(cEnvSoap,"CUPOM","N")

				If ! aRet[01]
					FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
						"CUPOM nao foi enviada para Administradora, problema tecnico, serao enviada no proximo processamento.",;
						0,(nStart - Seconds()),{})
					FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","Mensagem Administradora: " + aRet[02],0,(nStart - Seconds()),{})
				else
					nConte++

					Reclock("SL1",.F.)
					Replace SL1->L1_XTRAXML with "S"
					SL1->(MsUnlock())
				EndIf
			EndIf
		EndIf

		SL1->(dbSkip())
	EndDo

	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01",;
		"(SL1) - XML Cupom enviados para Administradora - Qtde : " + AllTrim(Str(nConte)),0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*** FIM ENVIO XML CUPOM (SL1) ***",0,(nStart - Seconds()),{})
	FwLogMsg("INFO",,"INTEGRATION",FunName(),"","01","*********************************",0,(nStart - Seconds()),{})

	If lPrepEnv
		RpcClearEnv()
	EndIf
Return
