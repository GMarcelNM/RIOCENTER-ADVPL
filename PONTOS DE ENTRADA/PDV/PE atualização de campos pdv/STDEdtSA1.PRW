#Include "Protheus.ch"
#Include "TOPCONN.CH"


User Function STDEdtSA1(PARAMIXB)
//Local lExistCli := PARAMIXB[1]
Local aFieldSA1 := {"A1_FILIAL", "A1_COD", "A1_LOJA", "A1_NOME", "A1_NREDUZ", "A1_CGC", "A1_END", "A1_EST", "A1_MUN", "A1_TIPO","A1_PESSOA"} //Campos atualizados no cadastro de clientes

/*
If lExistCli
EndIf

Reclock("SA1",.F.)
    SA1->A1_CODPAIS := "01058"
    SA1->A1_PAIS := "105"
    SA1->A1_CONTRIB := "2"
    SA1->A1_CONTA := '11201001'
    SA1->A1_END:= 'TESTEMARCEL'
SA1->(MsUnlock())

conout("PE LOJA TESTE")
//Adiciona mais campos a serem editados.
*/
/*
AaDd(aFieldSA1,"A1_CODPAIS")
AaDd(aFieldSA1,"A1_PAIS")
AaDd(aFieldSA1,"A1_CONTA")
AaDd(aFieldSA1,"A1_CONTRIB")
*/
  

Return aFieldSA1
