#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "Tbiconn.ch"

#DEFINE ENTER CHAR(13) + CHAR(10) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINA910F  บAutor  ณMicrosiga           บ Data ณ  03/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Ponto de Entrada para corrigiar a conta bancแrio e banco  บฑฑ
ฑฑบ          ณ  Na Concilia็ใo CliSITEF                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function FINA910F()
Local aParms1 := PARAMIXB
Local cCodBcoP := PARAMIXB[1]
Local aRetConta := {}
Local cCdBancoMV  := PADR(ALLTRIM(SuperGetMV("FK_BCOCONC",.f.,"237")),TamSx3("A6_COD")[1])
Local cCdAgencMV  := PADR(ALLTRIM(SuperGetMV("FK_AGECONC",.f.,"2632")),TamSx3("A6_AGENCIA")[1])
Local cCdContaMV  := PADR(ALLTRIM(SuperGetMV("FK_CTACONC",.f.,"10658")),TamSx3("A6_NUMCON")[1])
Local nOpcAv      := 0
Local cCodBanco   := ""
Local cCodAgencia := ""
Local cCodConta   := ""
/*
cCodBanco   := cCdBancoMV
cCodAgencia := cCdAgencMV
cCodConta   := cCdContaMV

If Alltrim(cCdBancoMV) <> Alltrim(aParms1[1])
    
    nOpcAv:= Aviso("Coontas Banแrias","Qual Banco deverแ ser considerado?",{"Bradesco","Safra"})

    If nOpcAv == 2 //Safra
        cCodBanco   := "422"
        cCodAgencia := "0161"
        cCodConta   := "873076"
    else
        //Bradesco
        cCodBanco   := "237"
        cCodAgencia := "2632"
        cCodConta   := "10658"        
    Endif

    PUTMV("FK_BCOCONC", cCodBanco)
    PUTMV("FK_AGECONC", cCodAgencia)
    PUTMV("FK_CTACONC", cCodConta)
EndIf
*/
If Alltrim(cCodBcoP) =="422" //Safra
    cCodBanco   := "422"
    cCodAgencia := "0161"
    cCodConta   := "873076"
else
    //Bradesco
    cCodBanco   := "237"
    cCodAgencia := "2632"
    cCodConta   := "10658"        
Endif

aRetConta := {cCodBanco,cCodAgencia,cCodConta}


Return aRetConta 
