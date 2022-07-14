#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'fileio.ch'


/*/{Protheus.doc} ImpPc
descriptiontttp120.rpo
@type function
@version  
@author diego.mendonca
@since 22/07/2021
@return variant, return_description
/*/
user function ImpPc()

    Local aParam 	 := {}
    Local aRet		 := {}
    Local xPlanilha  := PadR("",300)

	/* Definicao dos parâmetros */
    aAdd( aParam ,{6,"Planilha:  ", xPlanilha ,"","","",80, .T.,"Arquivos .CSV |*.CSV",,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})

    If ParamBox(aParam, "Importação de Pedidos de Compras", aRet)

        //-------------------------------------------------------------------//
        // Efetua a carga dos clientes encontrados de acordo com a planilha  //
        //-------------------------------------------------------------------//
        Processa( {|| xProcPainel(MV_PAR01)}, "Aguarde...",  "Efetuando leitura da Planilha!")

    Endif

return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+----------+------------+-------+---------------------+------+----------+¦¦
¦¦¦ Programa ¦ xProcPainel¦ Autor ¦ Diego Bruno         ¦ Data ¦ 01/09/21 ¦¦¦
¦¦+----------+------------+-------+---------------------+------+----------+¦¦
¦¦¦Descrição ¦ Função para efetuar leitura dos dados da planilha          ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function xProcPainel(_cPlaniha)

    Local aDados    := {}
    Local cMsg      := ""

    // Abre o arquivo e verifica se ele existe.
    If !Empty(_cPlaniha) .And. File(_cPlaniha)

        nHandle := FT_FUse(_cPlaniha) // Abre o arquivo e salva o Handle nessa propriedade.

        If nHandle == -1 // Se problema na leitura do arquivo
            MsgAlert('Problemas na Leitura do arquivo, favor verificar se o caminho esta correto ou o arquivo não esta aberto em outro processo.','Atencao!')
        Else

            FT_FGoTop() // vai para primeira linha do registro

            nCont := 1 // Inicializa Contador

            ProcRegua(1)

            While !FT_FEOF()

                IncProc("Lendo linhas da Planilha..."+Alltrim(Str(nCont)))

                If nCont = 1 //Pula o Cabeçalho
                    nCont := nCont + 2
                    FT_FSKIP()
                    FT_FSKIP()
                    loop
                End

                cBuffer  := AllTrim(FT_FReadLn()) // Retorna a linha corrente

                aLinha := Separa(cBuffer,";",.T.)
                
                aAdd(aDados,aLinha)
                nCont++

                FT_FSKIP()

            EndDo

            
            /*
                aDados[x][1] -> Dado não utilizado
                aDados[x][2] -> Fornecedor
                aDados[x][3] -> Loja
                aDados[x][4] -> Cond pagamento
                aDados[x][5] -> TP. Frete
                aDados[x][6] -> Vlr. Frete
                aDados[x][7] -> Produto
                aDados[x][8] -> Quantidade
                aDados[x][9] -> Valor FS
                aDados[x][10] -> Centro de custo
                aDados[x][11] -> TES
                aDados[x][12] -> Aliq IPI
                aDados[x][13] -> Cod Cliente
                aDados[x][14] -> Loja Cliente
                aDados[x][15] -> TES Venda
                aDados[x][16] -> Quantidade Matriz
                aDados[x][17] -> Centro de custo
                aDados[x][18] -> TES Compra
                aDados[x][19] -> Filial
                aDados[x][20] -> Valor
                aDados[x][21] -> Cod Cliente
                aDados[x][22] -> Loja Cliente
                aDados[x][23] -> TES Venda
                aDados[x][24] -> Quantidade Mega
                aDados[x][25] -> Centro de custo
                aDados[x][26] -> TES
                aDados[x][27] -> Filial
                aDados[x][28] -> Valor
                aDados[x][29] -> Cod Cliente
                aDados[x][30] -> Loja Cliente
                aDados[x][31] -> TES Venda
                aDados[x][32] -> Quantidade Shopping
                aDados[x][33] -> Centro de custo
                aDados[x][34] -> TES
                aDados[x][35] -> Filial
                aDados[x][36] -> Valor
            */
            
            // Fecha o Arquivo
            FT_FUSE()

            aCriticas   := ValidDados(aDados)

            If Empty(aCriticas)
                If Len(aDados) > 0
                    Processa( {|| ProcAlt(aDados)}, "Aguarde...",  "Gerando Pedidos de compras!")
                Else
                    MsgInfo("Não foi possível processar o arquivo de Pedidos!","Dados incorretos")
                Endif
            Else
                GerRErro(aCriticas)
                //SendErro(aCriticas)

            EndIf

        EndIf
    Else
        MsgAlert('Não foi possível abrir o arquivo!')
    EndIf

return (aDados)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+----------+------------+-------+---------------------+------+----------+¦¦
¦¦¦ Programa ¦ ProcAlt    ¦ Autor ¦ Diego Bruno         ¦ Data ¦ 01/09/21 ¦¦¦
¦¦+----------+------------+-------+---------------------+------+----------+¦¦
¦¦¦Descrição ¦ Função para processamento dos Pedidos                      ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function ProcAlt(_aDados)

    Local aPedComFs    := {}
    Local aPedComMeg   := {}
    Local aPedComMat   := {}
    Local aPedComShp   := {}
    Local aPedVenMeg   := {}
    Local aPedVenMat   := {}
    Local aPedVenShp   := {}
    Local aPedido       := {}
    Local nZ        := 0
    Local nY        := 0
    Local aEmps     := FwLoadSM0()
    Local cMsg      := ""
    Local aCab
    Local aItens
    Local aLinha

    nPosEmp := Ascan(aEmps, {|x| Alltrim(x[1]) == cEmpAnt .And. Alltrim(x[2]) == cFilAnt})

    /*
                aDados[x][1] -> Dado não utilizado
                aDados[x][2] -> Fornecedor
                aDados[x][3] -> Loja
                aDados[x][4] -> Cond pagamento
                aDados[x][5] -> TP. Frete
                aDados[x][6] -> Vlr. Frete
                aDados[x][7] -> Produto
                aDados[x][8] -> Quantidade
                aDados[x][9] -> Valor FS
                aDados[x][10] -> Centro de custo
                aDados[x][11] -> TES
                aDados[x][12] -> Aliq IPI

                aDados[x][13] -> Cod Cliente
                aDados[x][14] -> Loja Cliente
                aDados[x][15] -> TES Venda
                aDados[x][16] -> Quantidade Matriz
                aDados[x][17] -> Centro de custo
                aDados[x][18] -> TES Compra
                aDados[x][19] -> Filial
                aDados[x][20] -> Valor

                aDados[x][21] -> Cod Cliente
                aDados[x][22] -> Loja Cliente
                aDados[x][23] -> TES Venda
                aDados[x][24] -> Quantidade Mega
                aDados[x][25] -> Centro de custo
                aDados[x][26] -> TES
                aDados[x][27] -> Filial
                aDados[x][28] -> Valor

                aDados[x][29] -> Cod Cliente
                aDados[x][30] -> Loja Cliente
                aDados[x][31] -> TES Venda
                aDados[x][32] -> Quantidade Shopping
                aDados[x][33] -> Centro de custo
                aDados[x][34] -> TES
                aDados[x][35] -> Filial
                aDados[x][36] -> Valor
            */

    cCodFornec  := POSICIONE("SA2",3,xFilial("SA2") + aEmps[nPosEmp][18], "A2_COD")
    cLojFornec  := POSICIONE("SA2",3,xFilial("SA2") + aEmps[nPosEmp][18], "A2_LOJA")
    
    For nZ := 1 To Len(_aDados)
        
        aAdd(aPedComFs,{_aDados[nZ][2],_aDados[nZ][3],_aDados[nZ][4],_aDados[nZ][7],_aDados[nZ][8],_aDados[nZ][9],_aDados[nZ][10],_aDados[nZ][11],_aDados[nZ][12],_aDados[nZ][5],_aDados[nZ][6]})
        
        If !Empty(_aDados[nZ][13])
            aAdd(aPedVenMat,{_aDados[nZ][13], _aDados[nZ][14], _aDados[nZ][15], _aDados[nZ][7], _aDados[nZ][16], _aDados[nZ][20]})
            aAdd(aPedComMat,{_aDados[nZ][7],_aDados[nZ][16],_aDados[nZ][17],_aDados[nZ][18],_aDados[nZ][19],_aDados[nZ][20],"009",cCodFornec,cLojFornec})
        EndIf

        If !Empty(_aDados[nZ][21])
            aAdd(aPedVenMeg,{_aDados[nZ][21], _aDados[nZ][22], _aDados[nZ][23], _aDados[nZ][7], _aDados[nZ][24], _aDados[nZ][28]})
            aAdd(aPedComMeg,{_aDados[nZ][7],_aDados[nZ][24],_aDados[nZ][25],_aDados[nZ][26],_aDados[nZ][27],_aDados[nZ][28],"009",cCodFornec,cLojFornec})
        EndIf

        If !Empty(_aDados[nZ][29])
            /*
                aPedVenMShp[x][1] -> Cod Cliente
                aPedVenMShp[x][2] -> Loja Cliente
                aPedVenMShp[x][3] -> TES Venda
                aPedVenMShp[x][4] -> Produto
                aPedVenMShp[x][5] -> Quantidade
                aPedVenMShp[x][6] -> Preço
            */

            /*
                aPedComMShp[x][1] -> Produto
                aPedComMShp[x][2] -> Quantidade
                aPedComMShp[x][3] -> CC
                aPedComMShp[x][4] -> TES Compra
                aPedComMShp[x][5] -> Emp/Filial
                aPedComMShp[x][6] -> Preço
                aPedComMShp[x][7] -> Cond Pagamento
                aPedComMShp[x][8] -> Cod Fornecedor
                aPedComMShp[x][9] -> Loja Fornecedor
            */
            aAdd(aPedVenShp,{_aDados[nZ][29], _aDados[nZ][30], _aDados[nZ][31], _aDados[nZ][7], _aDados[nZ][32], _aDados[nZ][36]})
            aAdd(aPedComShp,{_aDados[nZ][7],_aDados[nZ][32],_aDados[nZ][33],_aDados[nZ][34],_aDados[nZ][35],_aDados[nZ][36],"009",cCodFornec,cLojFornec})
        EndIf

    Next nZ

    aCab    := {}
    aItens  := {}
    aLinha   := {}

    If !Empty(aPedComFs)

        AADD(aCab,{"C7_NUM",""})
        AADD(aCab,{"C7_EMISSAO",dDataBase})
        AADD(aCab,{"C7_FORNECE",PadR(aPedComFs[1][1],TamSX3("C7_FORNECE")[1])})
        AADD(aCab,{"C7_LOJA",aPedComFs[1][2]})
        AADD(aCab,{"C7_COND",aPedComFs[1][3]})
        AADD(aCab,{"C7_TXMOEDA",0.00})
        AADD(aCab,{"C7_CONTATO",""})
        AADD(aCab,{"C7_MOEDA",01})
        If !Empty(aPedComFs[1][10])
            AADD(aCab,{"C7_TPFRETE",IIF(AllTrim(aPedComFs[1][10]) == "F","F","C")})
            AADD(aCab,{IIF(AllTrim(aPedComFs[1][10])  == "F","C7_FRETCON","C7_FRETE"),Val(StrTran(aPedComFs[1][11],',','.'))})
        EndIf

        For nY := 1 to Len(aPedComFs)
            
            If nY == 1
                cItem   := "001"
            EndIf

            nQuant  := Val(StrTran(aPedComFs[nY][5],',','.'))
            nPreco  := Val(StrTran(aPedComFs[nY][6],',','.'))

            aadd(aLinha,{"C7_ITEM"    ,cItem                                                           ,Nil})
            aadd(aLinha,{"C7_UM"      ,POSICIONE("SB1",1,FWxFilial("SB1")+aPedComFs[nY][4],"B1_UM")    ,Nil})
            aadd(aLinha,{"C7_PRODUTO" ,aPedComFs[nY][4]                                                ,Nil})
            aadd(aLinha,{"C7_QUANT"   ,nQuant                                                          ,Nil})
            aadd(aLinha,{"C7_PRECO"   ,nPreco                                                          ,Nil})
            aadd(aLinha,{"C7_TOTAL"   ,nQuant * nPreco                                                 ,Nil})
            aadd(aLinha,{"C7_LOCAL"   ,POSICIONE("SB1",1,FWxFilial("SB1")+aPedComFs[nY][4],"B1_LOCPAD"),Nil})
            aadd(aLinha,{"C7_CC"      ,aPedComFs[nY][7]                                                ,Nil})
            aadd(aLinha,{"C7_TES"     ,aPedComFs[nY][8]                                                ,Nil})
            aadd(aLinha,{"C7_IPI"     ,Val(StrTran(aPedComFs[nY][9],',','.'))                          ,Nil})

            aadd(aItens,aLinha)
            aLinha := {}
            cItem  := Soma1(cItem)
        Next nY

        cNumPed := GetSXENum("SC7", "C7_NUM", "C7_NUM" + xFilial("SC7"))
        IncProc("Gerando Pedido de Compra " + cNumPed + "!")

        aCab[1][2] := cNumPed

        ConfirmSX8()
        lMsErroAuto := .F.
        MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,aCab,aItens,3)

        If lMsErroAuto
            ROLLBACKsX8()
            FwLogMsg("INFO", /*cTransactionId*/,"IMPPDCOM", FunName(), "", "01", "Erro na Geração do Pedido de Compra - Empresa: " + cEmpAnt +" Filial: " + cFilAnt + " - Erro")
            MostraErro()
            MsgInfo("Importação do pedido da Empresa: " + cEmpAnt + " Filial: " + cFilAnt + " ocorreu erro, favor verificar cada item do arquivo!!")
            Return
        Else
            aAdd(aPedido,{"Compra","FS",cNumPed})
            cMsg    +="Pedido FS Gerado: " + cNumPed + Chr(10) + Chr (13)
        EndIf


    EnDif

    If !Empty(aPedComMat)
        aRet := {}
        aRet := GerPv(aPedVenMat)
        
        If !aRet[1]

            aAdd(aPedido,{"Venda","FS",aRet[2]})
            cMsg    += " Pedido Venda Matriz: " + aRet[2] + Chr(10) + Chr (13)
            aRet := {}
            aRet := StartJob("U_GerPed",GetEnvServer(),.T.,aPedComMat)
            //GerPed(aPedMat)
            If aRet[1]
                MsgInfo(" Erro ao gerar pedido na filial Matriz!")
            Else
                aAdd(aPedido,{"Compra","Matriz",aRet[2]})
                cMsg    += " Pedido Gerado Na filial Matriz: " + aRet[2] + Chr(10) + Chr (13)
            EndIf
        Else
            cMsg    += " Erro ao gerar Pedido de venda na filial Matriz!" + Chr(10) + Chr (13) + " A ação será abortada!"
        EndIf
    EndIf

    If !Empty(aPedComMeg)
        aRet := {}
        aRet    := GerPv(aPedVenMeg)
        If !aRet[1]
        
            aAdd(aPedido,{"Venda","FS",aRet[2]})
            cMsg    += " Pedido Venda Mega: " + aRet[2] + Chr(10) + Chr (13)
            aRet := {}
            aRet := StartJob("U_GerPed",GetEnvServer(),.T.,aPedComMeg)
            //GerPed(aPedMeg)
            If aRet[1]
                MsgInfo("Erro ao gerar pedido na filial Mega!")
            Else
                aAdd(aPedido,{"Compra","Mega",aRet[2]})
                cMsg    += "Pedido Gerado Na filial Mega: " + aRet[2] + Chr(10) + Chr (13)
            EndIf
        Else
            cMsg    += " Erro ao gerar Pedido de venda na filial Mega!" + Chr(10) + Chr (13) + " A ação será abortada!"
        EndIf
    EndIf
    
    If !Empty(aPedComShp)
        aRet := {}
        aRet    := GerPv(aPedVenShp)
        If !aRet[1]
        
            aAdd(aPedido,{"Venda","FS",aRet[2]})
            cMsg    += " Pedido Venda Shopping: " + aRet[2] + Chr(10) + Chr (13)
            aRet := {}
            aRet := StartJob("U_GerPed",GetEnvServer(),.T.,aPedComShp)
            //GerPed(aPedShp)
            If aRet[1]
                MsgInfo("Erro ao gerar pedido na filial Shopping!")
            Else
                cMsg    += " Pedido Gerado Na filial Shopping: " + aRet[2] 
                aAdd(aPedido,{"Compra","Shopping",aRet[2]})
            EndIf
        Else
            cMsg    += " Erro ao gerar Pedido de venda na filial Shopping!" + Chr(10) + Chr (13) + " A ação será abortada!"
        EndIf
    EndIf

    If Len(aPedido) > 01
        GerRPed(aPedido)
        //SendPedido(aPedido)
    EndIf

    cMsg    += Chr(10) + Chr (13)
    cMsg    += Chr(10) + Chr (13)
    cMsg    += Chr(10) + Chr (13)

    FWAlertSuccess(cMsg, "Pedidos Gerados")
    
Return



User Function GerPed (aPed)

	
    Local aCab      := {}
    Local aLinha    := {}
    Local aItens    := {}
    Private lMsErroAuto := .T.

	FwLogMsg("INFO", , "GerPed", FunName(), "", "01", "GerPed - Empresa: " + aPed[1][5])


	RpcClearEnv()
	//RpcSetType(3)
	RPCSetEnv(Substr(aPed[1][5],1,2),aPed[1][5])

	AADD(aCab,{"C7_NUM",""})
    AADD(aCab,{"C7_EMISSAO",dDataBase})
    AADD(aCab,{"C7_FORNECE",PADR(aPed[1][8],TamSX3("C7_FORNECE")[1])})
    AADD(aCab,{"C7_LOJA",aPed[1][9]})
    AADD(aCab,{"C7_COND",aPed[1][7]})
    AADD(aCab,{"C7_TXMOEDA",0.00})
    AADD(aCab,{"C7_CONTATO",""})
    AADD(aCab,{"C7_MOEDA",01})

    For nY := 1 to Len(aPed)
        
        If nY == 1
            cItem   := "001"
        EndIf

        nQuant  := Val(StrTran(aPed[nY][2],',','.'))
        nPreco  := Val(StrTran(aPed[nY][6],',','.'))

        aadd(aLinha,{"C7_ITEM"    ,cItem                                                        ,Nil})
        aadd(aLinha,{"C7_UM"      ,POSICIONE("SB1",1,FWxFilial("SB1")+aPed[nY][1],"B1_UM")    ,Nil})
        aadd(aLinha,{"C7_PRODUTO" ,aPed[nY][1]                                                ,Nil})
        aadd(aLinha,{"C7_QUANT"   ,nQuant                                                     ,Nil})
        aadd(aLinha,{"C7_PRECO"   ,nPreco                                                     ,Nil})
        aadd(aLinha,{"C7_TOTAL"   ,nQuant * nPreco                                            ,Nil})
        aadd(aLinha,{"C7_LOCAL"   ,POSICIONE("SB1",1,FWxFilial("SB1")+aPed[nY][1],"B1_LOCPAD"),Nil})
        aadd(aLinha,{"C7_CC"      ,aPed[nY][3]                                                ,Nil})
        aadd(aLinha,{"C7_TES"     ,aPed[nY][4]                                                ,Nil})

        aadd(aItens,aLinha)
        aLinha := {}
        cItem  := Soma1(cItem)
    Next nY

    cNumPed := GetSXENum("SC7", "C7_NUM", "C7_NUM" + xFilial("SC7"))

    aCab[1][2] := cNumPed
    
    lMsErroAuto := .f.
	lMsHelpAuto := .f.

	/*	cQuery01 := " SELECT DISTINCT TOP 8 SUBSTRING(ZY8_DTFIM,1,6) AS ZY8_DTFIM2,ZY8_CODPRO,ZY8_VLRFEC "
	cQuery01 += " FROM "+RetSqlName("ZY8")
	cQuery01 += " WHERE ZY8_CODPRO = '"+mv_par01+"' "
	cQuery01 += " AND D_E_L_E_T_ = '' "
	cQuery01 += " ORDER BY SUBSTRING(ZY8_DTFIM,1,6) DESC "*/

	FwLogMsg("INFO", , "GerPed", FunName(), "", "01", "GerPed - Empresa: " + aPed[1][5] + " - Pedido: " + cNumPed)
	MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,aCab,aItens,3)

	If lMsErroAuto
		FwLogMsg("INFO", , "GerPed", FunName(), "", "01", "GerPed - Empresa: " + aPed[1][5] + " - Pedido: " + cNumPed + " - Erro")
		mostraerro()
		DisarmTransaction()
		break
    Else
        ConfirmSX8()
	Endif

	//RpcClearEnv()
	//RpcSetEnv(cEmpBkp,cFilBkp)

Return {lMsErroAuto,cNumPed}



Static function GerPv(aDados)

    Local lRet          := .F.
    //Local aCab1         := {}
    Local aCabec         := {}
    Local aProds        := {}
    Local aItem         := {}

    
    cNumPv	:= GetSXENum ("SC5", "C5_NUM")
    cTipo   := Posicione("SA1", 1, FWxFilial("SA1") + PADR(aDados[1][1], TamSX3("C5_CLIENTE")[1]) + adados[1][2], "A1_TIPO")

    cMsg    := "MERCADORIA DE REVENDA ROM " + cNumPv + " / " + IIF(adados[1][2] == "0001","MATRIZ",IIF(adados[1][2] == "0002","MEGA","SHOPPING")) + " / " + UsrRetName(__cUserID)

    aAdd(aCabec,{"C5_NUM"     , cNumPv            ,Nil})
    aAdd(aCabec,{"C5_TIPO"    , "N"               ,Nil})
    aAdd(aCabec,{"C5_CLIENTE" , PADR(aDados[1][1], TamSX3("C5_CLIENTE")[1])      ,Nil})
    aAdd(aCabec,{"C5_LOJACLI" , adados[1][2]     ,Nil})
    aAdd(aCabec,{"C5_CLIENT"  , PADR(aDados[1][1], TamSX3("C5_CLIENTE")[1])       ,Nil})
    aAdd(aCabec,{"C5_LOJAENT" , adados[1][2]     ,Nil})
    aAdd(aCabec,{"C5_TIPOCLI" , cTipo             ,Nil})
    aAdd(aCabec,{"C5_CONDPAG" , "009"             ,Nil})
    aAdd(aCabec,{"C5_EMISSAO" , dDataBase         ,Nil})
    //aAdd(aCab,{"C5_MOEDA"   , 1                 ,Nil})
    //aAdd(aCab,{"C5_TABELA"  , "1"             ,Nil})
    aAdd(aCabec,{"C5_MENNOTA" , cMsg              ,Nil})
    aAdd(aCabec,{"C5_TIPLIB"  , "1"               ,Nil})
    //aAdd(aCab,{"C5_XTES"  , aDados[1][3]        ,Nil})

    //aAdd(aCab,aCab1)

    For Nx := 1 to Len(aDados)


        /*
            aDados[x][1] -> Cod Cliente
            aDados[x][2] -> Loja Cliente
            aDados[x][3] -> TES Venda
            aDados[x][4] -> Produto
            aDados[x][5] -> Quantidade
            aDados[x][6] -> Preço
        */
        cItem   := StrZero(Len(aProds)+1,TamSX3("C6_ITEM")[1])
        aItem   := {}
        cUM     := Posicione("SB1", 1, FWxFilial("SB1") + aDados[Nx][4], "B1_UM")
        cArm    := Posicione("SB1", 1, FWxFilial("SB1") + aDados[Nx][4], "B1_LOCPAD")
        nQtdVen := Val(StrTran(aDados[Nx][5],',','.'))
        nPrcVen := Val(StrTran(aDados[Nx][6],',','.'))

        aAdd(aProds,{{"C6_ITEM"   , cItem								,Nil},;
                    {"C6_PRODUTO", aDados[Nx][4]                        ,Nil},;
                    {"C6_QTDVEN" , nQtdVen                              ,Nil},;
                    {"C6_PRCVEN" , nPrcVen                              ,Nil},;
                    {"C6_LOCAL"  , "01"                                 ,Nil},;
                    {"C6_VALOR"  , Round(nQtdVen * nPrcVen,TamSx3("C6_VALOR")[2])	,Nil},;
                    {"C6_TES"    , aDados[Nx][3]                        ,Nil},;
                    {"C6_PRUNIT" , nPrcVen                              ,Nil}})


        //aAdd(aItem,{"C6_ITEM"   , cItem									,Nil})
        //aAdd(aItem,{"C6_PRODUTO", aDados[Nx][4]                         ,Nil})
        //aAdd(aItem,{"C6_QTDVEN" , Val(aDados[Nx][5])                         ,Nil})
        //aAdd(aItem,{"C6_PRCVEN" , Val(aDados[Nx][6])                        ,Nil})
        //aAdd(aItem,{"C6_VALOR"  , Round(Val(aDados[Nx][5]) * Val(aDados[Nx][6]),TamSx3("C6_VALOR")[2])	,Nil})
        //aAdd(aItem,{"C6_TES"    , aDados[Nx][3]                         ,Nil})
        //aAdd(aItem,{"C6_LOCAL"  , "02"                                  ,Nil})
        //aAdd(aItem,{"C6_PRUNIT" , Val(aDados[Nx][6])                         ,Nil})

        //aAdd(aItens,aItem)

    Next Nx

    lMsErroAuto := .f.
	lMsHelpAuto := .f.

    MsExecAuto ( {|x,y,z| MATA410(x,y,z) },aCabec,aProds,3)

    If lMsErroAuto
        mostraerro()
        DisarmTransaction()
        break
    Else
        ConfirmSX8()
    EndIf

Return {lMsErroAuto,cNumPv}


Static Function ValidDados(_aDados)
    
    Local aRet      := {}

    //Validação do Layout do arquivo
    If Len(_aDados) > 0

        If Len(_aDados[1]) > 36 .OR. Len(_aDados[1]) < 36
            aAdd(aRet,{"ELAY","Layout Enviado é inválido"})
        EndIf

        //Validações de fornecedor

        
        dbSelectArea("SA2")
        dbSetOrder(1)
        If !DbSeek(xFilial("SA2")+PADR(_aDados[1][2],TamSX3("A2_COD")[1])+_aDados[1][3])
            aAdd(aRet,{"EFOR","Fornecedor informado no pedido não encontrado"})
        Else
            If SA2->A2_MSBLQL == "1"
                aAdd(aRet,{"EFOR","Fornecedor informado encontra-se bloqueado"})
            EndIf
        EndIf
        

        //Validações de condicão de Pagamento

        dbSelectArea("SE4")
        dbSetOrder(1)
        If !DbSeek(xFilial("SE4")+_aDados[1][4])
            aAdd(aRet,{"EFOR","A condição de pagamento " + _aDados[1][4] + " Não está cadastrada!"})
        Else
            If SE4->E4_MSBLQL == "1"
                aAdd(aRet,{"EFOR","A condição de pagamento " + _aDados[1][4] + " encontra-se bloqueada!"})
            EndIf
        EndIf

        //Validações de Clientes
        dbSelectArea("SA1")
        dbSetOrder(1)
        If !Empty(_aDados[1][13])
            If !DbSeek(xFilial("SA1")+PADR(_aDados[1][13],TamSX3("A1_COD")[1])+_aDados[1][14])
                aAdd(aRet,{"ECLI","O Cliente Informado " +_aDados[1][13] + "/" +_aDados[1][14] + " não está cadastrado!"})
            Else
                If SA1->A1_MSBLQL == "1"
                    aAdd(aRet,{"ECLI","O Cliente Informado " +_aDados[1][13] + "/" +_aDados[1][14] + " encontra-se bloqueado!"})
                EndIf
            EndIf
        EndIf

        If !Empty(_aDados[1][21])
            If !DbSeek(xFilial("SA1")+PADR(_aDados[1][21],TamSX3("A1_COD")[1])+_aDados[1][22])
                aAdd(aRet,{"ECLI","O Cliente Informado " +_aDados[1][21] + "/" +_aDados[1][22] + " não está cadastrado!"})
            Else
                If SA1->A1_MSBLQL == "1"
                    aAdd(aRet,{"ECLI","O Cliente Informado " +_aDados[1][21] + "/" +_aDados[1][22] + " encontra-se bloqueado!"})
                EndIf
            EndIf
        EndIf

        If !Empty(_aDados[1][29])
            If !DbSeek(xFilial("SA1")+PADR(_aDados[1][29],TamSX3("A1_COD")[1])+_aDados[1][30])
                aAdd(aRet,{"ECLI","O Cliente Informado " +_aDados[1][29] + "/" +_aDados[1][30] + " não está cadastrado!"})
            Else
                If SA1->A1_MSBLQL == "1"
                    aAdd(aRet,{"ECLI","O Cliente Informado " +_aDados[1][29] + "/" +_aDados[1][30] + " encontra-se bloqueado!"})
                EndIf
            EndIf
        EndIf

        //Validações de dados do produto/TES compra/TES venda

        For nZ := 1 To Len(_aDados)

            If !Empty(_aDados[nZ][1])
                //Validação de produto
                dbSelectArea("SB1")
                dbSetOrder(1)
                If !DbSeek(xFilial("SB1")+_aDados[nZ][7])
                    aAdd(aRet,{"EPRD","O produto " +_aDados[nZ][7] + " não encontra-se cadastrado na base!"})
                Else
                    If SB1->B1_MSBLQL == "1"
                        aAdd(aRet,{"EPRD","O produto " +_aDados[nZ][7] + " encontra-se bloqueado!"})
                    EndIf
                EndIf

                //Validações de TES
                dbSelectArea("SF4")
                dbSetOrder(1)
                If !Empty(_aDados[nZ][11])
                    If !DbSeek(xFilial("SF4")+_aDados[nZ][11])
                        aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][11] + " não encontra-se cadastrado na base!"})
                    Else
                        If SF4->F4_MSBLQL == "1"
                            aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][11] + " encontra-se bloqueado!"})
                        EndIf
                    EndIf
                EndIf

                If !Empty(_aDados[nZ][13])
                    If !DbSeek(xFilial("SF4")+_aDados[nZ][15])
                        aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][15] + " não encontra-se cadastrado na base!"})
                    Else
                        If SF4->F4_MSBLQL == "1"
                            aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][15] + " encontra-se bloqueado!"})
                        EndIf
                    EndIf
                EndIf

                If !Empty(_aDados[nZ][21])
                    If !DbSeek(xFilial("SF4")+_aDados[nZ][23])
                        aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][23] + " não encontra-se cadastrado na base!"})
                    Else
                        If SF4->F4_MSBLQL == "1"
                            aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][23] + " encontra-se bloqueado!"})
                        EndIf
                    EndIf
                EndIf

                If !Empty(_aDados[nZ][29])
                    If !DbSeek(xFilial("SF4")+_aDados[nZ][31])
                        aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][31] + " não encontra-se cadastrado na base!"})
                    Else
                        If SF4->F4_MSBLQL == "1"
                            aAdd(aRet,{"ETES","O TES de compra " +_aDados[nZ][31] + " encontra-se bloqueado!"})
                        EndIf
                    EndIf
                EndIf
            EndIf

        Next nZ
    Else
        aAdd(aRet,{"ELAY","Planilha em branco ou Layout Errado!"})
    EndIf

Return aRet


Static function SendErro(_aCriticas)

	Local cHtml     := ""
	Local cAssunto  := "Erro encontrado ao ler arquivo"
	Local nPosCD    := 0
	Local aEmpresas := FWLoadSM0()
	Local nNI       := 0
	Local nNY       := 0
	Local nNT       := 0
	Local cMail     := "diego.bruno@outlook.com;gilmar.gilalves@gmail.com"
	Local oJsonAux  := Nil
	Local nPF       := 0
	Local nPrecoVen := 0
	Local cProd     := ""


    cHtml += "<!DOCTYPE html>"
    cHtml += "<head>"
    cHtml += "<title>WF Erro</title>"
    cHtml += "<meta charset='utf-8'>"
    cHtml += "<style type='text/css'>"
    cHtml += "table.customTable {"
    cHtml += "width: 100%; background-color: #FF7F50;"
    cHtml += "border-collapse: collapse; border-width: 2px;"
    cHtml += "border-color: #C55D00; border-style: solid;"
    cHtml += "color: #000000; margin-top: 30px; }"
    cHtml += "table.customTable td, table.customTable th {"
    cHtml += "border-width: 2px; border-color: #C55D00;"
    cHtml += "border-style: solid; padding: 5px; }"
    cHtml += "table.customTable thead {"
    cHtml += "background-color: #C55D00; }"
    cHtml += ".text { font:bold 20px 'Courier New', Courier, monospace;"
    cHtml += "font-style:normal; color:#FF7F50; background:#C55D00;"
    cHtml += "border:0px solid #ea326f; text-shadow:0px 0px 0px #FF7F50;"
    cHtml += "box-shadow:0px 0px 6px #454545; -moz-box-shadow:0px 0px 6px #454545;"
    cHtml += "-webkit-box-shadow:0px 0px 6px #454545; border-radius:90px 15px 90px 15px;"
    cHtml += "-moz-border-radius:90px 15px 90px 15px; -webkit-border-radius:90px 15px 90px 15px;"
    cHtml += "width:389px; padding:20px 40px; cursor:pointer; margin:0 auto; }"
    cHtml += ".text:active { cursor:pointer; position:relative; top:2px; }"
    cHtml += "th { color: #FF7F50; font:bold 16px 'Courier New', Courier, monospace; }"
    cHtml += "td { text-align: center; text-transform: uppercase; }"
    cHtml += "</style>"
    cHtml += "</head>"

    cHtml += "<body>"
    cHtml += "<div align='center'>"
    cHtml += "<img src='http://www.portal.riocenter.com.br/WEBCLIENTERIOCENTER_WEB/logo-laranja.svg'>"
    cHtml += "</div>"

    cHtml += "<hr />"

    cHtml += "<br />"

    cHtml += "<p align='center' class='text'>ERRO AO LER ARQUIVO DE PEDIDOS!</p>"

    cHtml += "<br  />"

    cHtml += "<table class='customTable'>"

    //--Inicio tabela de cliente
    cHtml += "<thead>"

    cHtml += "<tr>"
    cHtml += "<th>CÓDIGO DO ERRO</th>"
    cHtml += "<th>DESCRIÇÃO DO ERRO</th>"
    cHtml += "</tr>"

    cHtml += "</thead>"

    cHtml += "<tbody>"

    

    For Nx := 1 To Len(_aCriticas)
        cHtml += "<tr>"
        cHtml += "<td>" + _aCriticas[Nx][1] + "</td>"
        cHtml += "<td>" + _aCriticas[Nx][2] + "</td>"
        cHtml += "</tr>"
    Next Nx

    

    cHtml += "</tbody>"

    cHtml += "</table>"

    cHtml += "</body>"
    cHtml += "</html>"

    EnvWF(cAssunto, cHtml, cMail)

Return

Static Function EnvWF(_cAssunto, _cHTML, _cMail)

	Local oServer, oMessage
	Local cUser     := AllTrim(GetMV("MV_RELACNT"))
	Local cPass     := AllTrim(GetMV("MV_RELPSW"))
	Local cServer   := AllTrim(GetMV("MV_RELSERV"))//"smtp.office365.com"
	Local lRet      := .T.
	Local xRet      := ""
	Local cMsg      := ""

	oMessage := TMailMessage():New()
	oMessage:Clear()

	oMessage:cDate    := cValToChar(Date())
	oMessage:cFrom    := cUser
	oMessage:cTo      := _cMail
	oMessage:cSubject := _cAssunto
	oMessage:cBody    := _cHTML

	oServer := tMailManager():New()
	oServer:SetUseTLS( .T. )
    //oServer:SetUseSSL( .T. )

	xRet := oServer:Init( "", cServer, cUser, cPass,0, 587 )
	If xRet != 0
		cMsg := "Houve um erro ao tentar iniciar ao servidor SMTP " + oServer:GetErrorString(xRet)
		FwLogMsg("INFO", /*cTransactionId*/, "IMPPC", FunName(), "", "01", cMsg,)

		lRet := .F.
		Return
	Endif

	xRet := oServer:SMTPConnect()
	If xRet <> 0
		cMsg := "Houve um erro ao tentar se conectar ao servidor SMTP: " + oServer:GetErrorString(xRet)
		FwLogMsg("INFO", /*cTransactionId*/, "IMPPC", FunName(), "", "01", cMsg,)

		lRet := .F.
		Return
	Endif

	xRet := oServer:SmtpAuth(cUser, cPass)
	If xRet <> 0
		cMsg := "Houve um erro ao tentar se autenticar no serivodr SMTP!: " + oServer:GetErrorString(xRet)
		FwLogMsg("INFO", /*cTransactionId*/, "IMPPC", FunName(), "", "01", cMsg,)
		oServer:SMTPDisconnect()

		Return
	Endif 

	xRet := oMessage:Send(oServer)
	If xRet <> 0
		cMsg := "Houve um erro ao tentar enviar o email: " + oServer:GetErrorString(xRet)
		FwLogMsg("INFO", /*cTransactionId*/, "IMPPC", FunName(), "", "01", cMsg,)

		lRet := .F.
		Return
	Endif

	xRet := oServer:SMTPDisconnect()
	If xRet <> 0
		cMsg := "Houve um erro ao tentar desconectar do servidor SMTP: " + oServer:GetErrorString(xRet)
		FwLogMsg("INFO", /*cTransactionId*/, "IMPPC", FunName(), "", "01", cMsg,)
	Endif

Return lRet


Static function SendPedido(_aPedido)

	Local cHtml     := ""
	Local cAssunto  := "Pedidos gerados com sucesso!"
	Local nPosCD    := 0
	Local aEmpresas := FWLoadSM0()
	Local nNI       := 0
	Local nNY       := 0
	Local nNT       := 0
	Local cMail     := "diego.bruno@outlook.com;gilmar.gilalves@gmail.com"
	Local oJsonAux  := Nil
	Local nPF       := 0
	Local nPrecoVen := 0
	Local cProd     := ""


    cHtml += "<!DOCTYPE html>"
    cHtml += "<head>"
    cHtml += "<title>WF Sucesso</title>"
    cHtml += "<meta charset='utf-8'>"
    cHtml += "<style type='text/css'>"
    cHtml += "table.customTable {"
    cHtml += "width: 100%; background-color: #FF7F50;"
    cHtml += "border-collapse: collapse; border-width: 2px;"
    cHtml += "border-color: #C55D00; border-style: solid;"
    cHtml += "color: #000000; margin-top: 30px; }"
    cHtml += "table.customTable td, table.customTable th {"
    cHtml += "border-width: 2px; border-color: #C55D00;"
    cHtml += "border-style: solid; padding: 5px; }"
    cHtml += "table.customTable thead {"
    cHtml += "background-color: #C55D00; }"
    cHtml += ".text { font:bold 20px 'Courier New', Courier, monospace;"
    cHtml += "font-style:normal; color:#FF7F50; background:#C55D00;"
    cHtml += "border:0px solid #ea326f; text-shadow:0px 0px 0px #FF7F50;"
    cHtml += "box-shadow:0px 0px 6px #454545; -moz-box-shadow:0px 0px 6px #454545;"
    cHtml += "-webkit-box-shadow:0px 0px 6px #454545; border-radius:90px 15px 90px 15px;"
    cHtml += "-moz-border-radius:90px 15px 90px 15px; -webkit-border-radius:90px 15px 90px 15px;"
    cHtml += "width:389px; padding:20px 40px; cursor:pointer; margin:0 auto; }"
    cHtml += ".text:active { cursor:pointer; position:relative; top:2px; }"
    cHtml += "th { color: #FF7F50; font:bold 16px 'Courier New', Courier, monospace; }"
    cHtml += "td { text-align: center; text-transform: uppercase; }"
    cHtml += "</style>"
    cHtml += "</head>"

    cHtml += "<body>"
    cHtml += "<div align='center'>"
    cHtml += "<img src='http://www.portal.riocenter.com.br/WEBCLIENTERIOCENTER_WEB/logo-laranja.svg'>"
    cHtml += "</div>"

    cHtml += "<hr />"

    cHtml += "<br />"

    cHtml += "<p align='center' class='text'>Pedidos gerados com sucesso!</p>"

    cHtml += "<br  />"

    cHtml += "<table class='customTable'>"

    //--Inicio tabela de cliente
    cHtml += "<thead>"

    cHtml += "<tr>"
    cHtml += "<th>Tipo Pedido</th>"
    cHtml += "<th>Empresa</th>"
    cHtml += "<th>Num. Pedido</th>"
    cHtml += "</tr>"

    cHtml += "</thead>"

    cHtml += "<tbody>"

    

    For Nx := 1 To Len(_aPedido)
        cHtml += "<tr>"
        cHtml += "<td>" + _aPedido[Nx][1] + "</td>"
        cHtml += "<td>" + _aPedido[Nx][2] + "</td>"
        cHtml += "<td>" + _aPedido[Nx][3] + "</td>"
        cHtml += "</tr>"
    Next Nx

    

    cHtml += "</tbody>"

    cHtml += "</table>"

    cHtml += "</body>"
    cHtml += "</html>"

    EnvWF(cAssunto, cHtml, cMail)

Return

static function GerRErro(aDados)
    Local nX
    Local cDirTmp    := GetTempPath()
    Private lMsErroAuto := .F.

    oFwMsEx := FWMsExcelEx():New()

    cWorkSheet := "LOG DE PROCESSAMENTO"
    cTable     := "Log de erro do pedido ( "+DTOC(Date())+" - "+Time()+" ) "

    oFwMsEx:AddWorkSheet( cWorkSheet )
    oFwMsEx:AddTable( cWorkSheet, cTable )

    oFwMsEx:AddColumn( cWorkSheet, cTable , "Cod. Erro"			, 1,1)
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição do Erro"	    , 1,1)

    For nX := 1 to Len(aDados)
        oFwMsEx:AddRow( cWorkSheet, cTable,{aDados[nX][1],aDados[nX][2]})
    Next

    oFwMsEx:Activate()

    cArq := CriaTrab( NIL, .F. ) + ".xml"

    MsgRun( "Gerando relatório de erro, aguarde...", "STATUS DE RELATÓRIO", {|| oFwMsEx:GetXMLFile( cArq ) } )
    If __CopyFile( cArq, cDirTmp + cArq )
        oExcelApp := MsExcel():New()
        oExcelApp:WorkBooks:Open( cDirTmp + cArq )
        oExcelApp:SetVisible(.T.)
    Else
        MsgInfo( "Arquivo não copiado para temporário do usuário." )
    Endif
Return


static function GerRPed(aDados)
    Local nX
    Local cDirTmp    := GetTempPath()
    Private lMsErroAuto := .F.

    oFwMsEx := FWMsExcelEx():New()

    cWorkSheet := "LOG DE PROCESSAMENTO"
    cTable     := "Log de pedido(s) incluído(s) ( "+DTOC(Date())+" - "+Time()+" ) "

    oFwMsEx:AddWorkSheet( cWorkSheet )
    oFwMsEx:AddTable( cWorkSheet, cTable )

    oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo Pedido"			, 1,1)
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Empresa"	    , 1,1)
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Num Pedido"	    , 1,1)

    For nX := 1 to Len(aDados)
        oFwMsEx:AddRow( cWorkSheet, cTable,{aDados[nX][1],aDados[nX][2],aDados[nX][3]})
    Next

    oFwMsEx:Activate()

    cArq := CriaTrab( NIL, .F. ) + ".xml"

    MsgRun( "Gerando relatório de pedidos incluídos, aguarde...", "STATUS DE RELATÓRIO", {|| oFwMsEx:GetXMLFile( cArq ) } )
    If __CopyFile( cArq, cDirTmp + cArq )
        oExcelApp := MsExcel():New()
        oExcelApp:WorkBooks:Open( cDirTmp + cArq )
        oExcelApp:SetVisible(.T.)
    Else
        MsgInfo( "Arquivo não copiado para temporário do usuário." )
    Endif
Return
