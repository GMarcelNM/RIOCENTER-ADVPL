#Include "Protheus.ch"
#Include "totvs.ch"

User Function MATA311

    Local aParam     := PARAMIXB
    Local xRet       := .T.
    Local oObj       := ''
    Local cIdPonto   := ''
    Local cIdModel   := ''
    Local lIsGrid    := .F.


    If aParam <> NIL

        oObj       := aParam[1]
        cIdPonto   := aParam[2]
        cIdModel   := aParam[3]
        lIsGrid    := ( Len( aParam ) > 3 )

        If     cIdPonto == 'MODELPOS'

        ElseIf cIdPonto == 'FORMPOS'

        ElseIf cIdPonto == 'FORMLINEPRE'

        ElseIf cIdPonto == 'FORMLINEPOS'

        ElseIf cIdPonto == 'MODELCOMMITTTS'

        ElseIf cIdPonto == 'MODELCOMMITNTTS'

        ElseIf cIdPonto == 'FORMCOMMITTTSPRE'

        ElseIf cIdPonto == 'FORMCOMMITTTSPOS'

        ElseIf cIdPonto == 'MODELCANCEL'

        ElseIf cIdPonto == 'BUTTONBAR'

            xRet := { {'Inserir Produto', 'Inserir produto', { || IncProd() }, 'Inserir Produto' } }

        EndIf

    EndIf

Return xRet

Static Function IncProd()

    Private cOrigem  := M->NNS_XLOCOR
    Private cDestino := M->NNS_XLOCDE
    Private cCodBar  := Space(14)
    Private cProd    := Space(100)
    Private nQuant   := 1
    Private cObs := ""
    Private _oDlg := Nil

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Define as fontes utilizadas³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DEFINE FONT oFont1 NAME "Lucida Console" SIZE 0,-18 BOLD
    DEFINE FONT oFont2 NAME "Lucida Console" SIZE 0,-40 BOLD
    DEFINE FONT oFont3 NAME "Lucida Console" SIZE 0,-14 BOLD


    DEFINE MSDIALOG _oDlg TITLE " TRANSFERENCIA ENTRE ARMAZÉNS " FROM 180,180 TO 450,600 PIXEL STYLE DS_MODALFRAME

    @ 002,002 TO 30,70 LABEL "Origem       /    Destino" PIXEL OF _oDlg

    @ 010,010 MsGet oOrigem	 Var cOrigem  Size 22,015 F3 "NNR" COLOR CLR_BLACK PIXEL OF _oDlg  FONT oFont1
    @ 010,040 MsGet oDestino Var cDestino Size 22,015 F3 "NNR" COLOR CLR_BLACK PIXEL OF _oDlg  FONT oFont1

    @ 002,80 TO 30,200 LABEL "Produto" PIXEL OF _oDlg
    @ 010,90 MsGet oCodBar Var cCodBar Size 100,015  COLOR CLR_BLACK PIXEL OF _oDlg  FONT oFont1  valid AddQtd()

    @ 040,010 SAY oProd Var cProd Size 175,50 OF _oDlg PIXEL FONT oFont1

    @ 070,40 MsGet oQuant Var nQuant Size 130,030  COLOR CLR_RED PIXEL OF _oDlg  FONT oFont2 WHEN .T. PICTURE "@e 9999999999"

    @ 110,010 SAY oObs Var cObs Size 175,50 OF _oDlg COLOR CLR_RED PIXEL FONT oFont3

    oCodBar:SetFocus()

    ACTIVATE DIALOG _oDlg CENTERED


Return

Static Function AddQtd()
    Local nX
    Private oModel := FwModelACtivate()
    Private oView  := FWViewActive()
    Private aId    := oView:GetCurrentSelect()
    Private nId    := aScan(aId,{|x| "DETAIL" $ Alltrim(X)  })
    IF nId == 0
        MsgInfo("Problema ao carregar o objeto. Tente novamente.")
        Return
    Endif
    Private cId    := aId[nId]
    Private oGrid  := oModel:GetModel(cId)
    Private lRet   := .F.

    IF Empty(cOrigem) .or. Empty(cDestino)
        Help(NIL, NIL, "Campos obigatórios", NIL, "Faltando informação", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencher local de Origem e Destino."})
        lRet := .F.
    Else

        DbSelectArea("SB1")
        IF Len(Alltrim(cCodBar)) == 14
            SB1->(DbSetOrder(1)) //Codigo do produto
        Else
            SB1->(DbSetOrder(5)) //Codigo de barras
        Endif

        IF SB1->(MsSeek(xFilial("SB1") + cCodBar))
            cProd := SB1->B1_DESC

            //Valida se tem estoque no destino
            //Comentado, pois foi alterado o parâmetro MV_VLDALMO
            //Func01(M->NNS_XFILIA,SB1->B1_COD,cDestino)

            For nX := 1 to oGrid:Length()
                IF oGrid:GetValue("NNT_PROD",nX) == SB1->B1_COD .and. oGrid:GetValue("NNT_LOCAL",nX) == cOrigem .and. !oGrid:IsDeleted(nX)
                    //Valida se tem saldo na origem
                    IF FUNC02(SB1->B1_COD,cOrigem,oGrid:GetValue("NNT_QUANT",nX)+nQuant)
                        oGrid:GoLine(nX)
                        oGrid:LoadValue("NNT_QUANT",oGrid:GetValue("NNT_QUANT",nX)+nQuant)
                        Exit
                    Else
                        Help(NIL, NIL, "Erro saldo", NIL, "Sem saldo", 1, 0, NIL, NIL, NIL, NIL, NIL, {"[1] Não foi possível incluir quantidade"})
                        Exit
                    Endif
                Else
                     IF nX == oGrid:Length()
                        //Valida se tem saldo na origem
                        IF FUNC02(SB1->B1_COD,cOrigem,nQuant)
                            IF ((!Empty(oGrid:GetValue("NNT_PROD",nX)) .and. nX == 1) .or. nX > 1)
                                IF oGrid:AddLine() <= nX
                                    Help(NIL, NIL, "Erro linha", NIL, "Erro adicionar linha", 1, 0, NIL, NIL, NIL, NIL, NIL, {"[4] Não foi possível adicionar nova linha."})
                                    Exit
                                EndIf
                            Endif
                        Else
                            Help(NIL, NIL, "Erro saldo", NIL, "Sem saldo", 1, 0, NIL, NIL, NIL, NIL, NIL, {"[2] Não foi possível incluir quantidade"})
                            Exit
                        Endif

                        oGrid:LoadValue("NNT_PROD" ,SB1->B1_COD )
                        oGrid:LoadValue("NNT_DESC" ,SubStr(SB1->B1_DESC,1,TamSx3("NNT_DESC")[1]))
                        oGrid:LoadValue("NNT_UM"   ,SB1->B1_UM)
                        oGrid:LoadValue("NNT_LOCAL",cOrigem)
                        oGrid:LoadValue("NNT_QUANT",nQUant)
                        oGrid:LoadValue("NNT_FILDES",M->NNS_XFILIA)
                        oGrid:LoadValue("NNT_PRODD",SB1->B1_COD )
                        oGrid:LoadValue("NNT_DESCD",SubStr(SB1->B1_DESC,1,TamSx3("NNT_DESC")[1]))
                        oGrid:LoadValue("NNT_UMD"  ,SB1->B1_UM)
                        oGrid:LoadValue("NNT_LOCLD",cDestino)
                        oGrid:LoadValue("NNT_TS",'506')
                        oGrid:LoadValue("NNT_TE",'012')
                    ENdif
                Endif
            Next nX
            oGrid:GoLine(1)
            oView:Refresh()

        Else
            Help(NIL, NIL, "Produto Inválido", NIL, "Produto não encontrado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"[3] Escolha um produto válido."})

            lRet := .F.
        Endif
    Endif

    nQuant := 1
    oCodBar:SetFocus()
    _oDlg:Refresh()

Return

Static Function FUNC02(cProduto, cAlmox, nQtd)
    Local lRet
    DbSelectArea("SB2")
    SB2->(DbSetOrder(1))
    If SB2->(DBSEEK(xFilial('SB2') + cProduto + cAlmox))
        lRet := SaldoSB2() >= nQtd
    Else
        lRet := .F.
    EndIf
Return lRet
