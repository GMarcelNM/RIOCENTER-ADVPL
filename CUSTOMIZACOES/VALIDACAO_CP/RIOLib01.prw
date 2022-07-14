#Include "TOTVS.CH"
#INCLUDE 'Protheus.ch'
#Include "TopConn.ch"

/******************************************************************************************************************
* Programa: RCLIB001.prw                     Data: 14/04/2021     Auto: Glaudson Marcel                            *
* Objetivo: Funções genéricas utilizadas em diversos pontos do Protheus                                           *
*                                                                                                                 *
/******************************************************************************************************************/

// função para calcular o código de barras partindo da linha digitável
USER FUNCTION ConvLD()
  SETPRVT("cStr")
  //
  cStr := LTRIM(RTRIM(M->E2_LINDIG))
  IF VALTYPE(M->E2_LINDIG) == NIL .OR. EMPTY(M->E2_LINDIG)
    cStr := ""
  ELSE
     // Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
     // necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
     cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
  ENDIF
  DO CASE
    CASE LEN(cStr) == 47
     	cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
    CASE LEN(cStr) == 48
        cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
  OTHERWISE
    cStr := cStr+SPACE(48-LEN(cStr))
  ENDCASE
RETURN(cStr)


// função para calcular a linha digitável partindo do código de barras
// AINDA EM DESENVOLVIMENTO
User Function ConvCB()
/*
Local cCampo1 := ""
Local cCampo2 := ""
Local cCampo3 := ""
Local cCampo4 := ""
Local cCampo5 := ""
*/

  SETPRVT("cStr2")

  cStr2 := LTRIM(RTRIM(M->E2_CODBAR))
  IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
    cStr2 := ""
  ELSE
     // Se o Tamanho do String for diferente dee 44 não realiza a conversão  
     cStr2 := IF(LEN(cStr2)<>44,"",cStr2)
  ENDIF

Return(cStr2)

 
/*/{Protheus.doc} zNumPecas
Função que retorna quantidade de peças do pedido de venda
@Autor - Glaudson Marcel
@Criada em - 01/06/2021
@Parametro1 - cNumPed, caracter, Número do Pedido
@Parametro2 - nTipo, numérico, 1 == Browse da SC5, 2 == Dentro da tela do Pedido
/*/
User Function zNumPecas(cNumPed, nTipo)
    Local aArea     := GetArea()
    Local aAreaC5   := SC5->(GetArea())
    Local aAreaB1   := SC6->(GetArea())
    Local cQryIte   := ""
    Local nNumPecas := 0
    Local nNritem   := 0
    Default cNumPed := SC5->C5_NUM
    Default nTipo   := 1
     
    //Se for no Browse, já traz o valor total
    If nTipo == 1
        //Seleciona agora os itens do pedido
        cQryIte := " SELECT "
        cQryIte += "    Total = SUM(ISNULL(C6_QTDVEN, 0)) "
        cQryIte += " FROM "
        cQryIte += "    "+RetSQLName('SC6')+" SC6 "
        cQryIte += " WHERE "
//        cQryIte += "    C6_FILIAL = '"+FWxFilial('SC6')+"' "
        cQryIte += "    C6_FILIAL = '"+  alltrim(SC5->C5_FILIAL) +"' "
        cQryIte += "    AND C6_NUM = '"+cNumPed+"' "
        cQryIte += "    AND SC6.D_E_L_E_T_ = ' ' "
        cQryIte := ChangeQuery(cQryIte)
        TCQuery cQryIte New Alias "QRY_ITE"
         
        //Pega o total de itens
        QRY_ITE->(DbGoTop())
        While ! QRY_ITE->(EoF())
            nNumPecas := QRY_ITE->Total
            QRY_ITE->(DbSkip())
        EndDo
        
        QRY_ITE->(DbCloseArea())
    Else
        nNritem := Len(aCols)
        nNumPecas := 0 
        For nAtu := 1 To Len(aCols)
            nNumPecas += aCols[nAtu][GDFieldPos("C6_QTDVEN")] 
        Next
    EndIf
     
    RestArea(aAreaB1)
    RestArea(aAreaC5)
    RestArea(aArea)
Return nNumPecas 


/*/{Protheus.doc} zNomCaixa
Função que retorna nome do caixa
@Autor - Glaudson Marcel
@Criada em - 18/06/2021
@Parametro1 - cCaixa, caracter, codigo do caixa
/*/
User Function zNomCaixa(cCaixa)
    Local aArea     := GetArea()
    Local cQryIte   := ""
    Local cNomeCaixa := ""
     
        cQryIte := " SELECT "
        cQryIte += "    Nome = SA6.A6_NOME "
        cQryIte += " FROM "
        cQryIte += "    "+RetSQLName('SA6')+" SA6 "
        cQryIte += " WHERE "
//        cQryIte += "    C6_FILIAL = '"+FWxFilial('SC6')+"' "
        cQryIte += "        A6_COD = '"+  alltrim(cCaixa) +"' "
        cQryIte := ChangeQuery(cQryIte)
        TCQuery cQryIte New Alias "QRY_ITE"
         
        //Pega o total de itens
        QRY_ITE->(DbGoTop())
        While ! QRY_ITE->(EoF())
            cNomeCaixa := QRY_ITE->Nome
            QRY_ITE->(DbSkip())
        EndDo
        
        QRY_ITE->(DbCloseArea())

    RestArea(aArea)
Return cNomeCaixa 

