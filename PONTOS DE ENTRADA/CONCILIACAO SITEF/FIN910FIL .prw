#include "Protheus.ch"
#Include "Rwmake.ch"
/*
Ponto de entrada para tratar a filial no momento da leitura do arquivo
*/

User Function FIN910FIL()
Local aLinhaArq := Paramixb//[1]
Local cRetorno := xFilial("SE1")

    //Estabelecimento é na posição 03
    If    Alltrim(aLinhaArq[3]) == "0004561804197"
        cRetorno := "0101"
    ElseIf Alltrim(aLinhaArq[3]) == "0001004716432"  
        cRetorno := "0102"
    ElseIf Alltrim(aLinhaArq[3]) == "0001130140510"
        cRetorno :=  "0102"
    ElseIf Alltrim( aLinhaArq[3]) == "0001003094276" //Shopping- Filial 0103
          cRetorno := "0103"
    Else
        cRetorno := xFilial("SE1")//Space(TamSX3("FIF_CODFIL")[1])
    EndIf
    
     //Mudar a filial para o campo FIF_CODFIL   
    cMsFil  := cRetorno

Return cRetorno
