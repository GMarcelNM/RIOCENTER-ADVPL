#INCLUDE "Protheus.ch"
#Include "Rwmake.ch"

User Function FINFIF()

Local aFIF     :=  Paramixb // Array de Dados
Local nPCodFil := 0
//Local nP       := 0 

nPFilial := aScan(aFIF[Len(aFIF)],{|x| x[1]=="FIF_FILIAL"})
nPCodFil := aScan(aFIF[Len(aFIF)],{|x| x[1]=="FIF_CODFIL"})

If nPCodFil > 0
    //For nP:= 1 To Len(aFIF)
        //Altera a Filial com as informa��oes do campo filial
        aFIF[Len(aFIF)][nPCodFil][2] :=  aFIF[Len(aFIF)][nPFilial][2] 
    
    //Next nP     
EndIf
//aAdd(aFIF[Len(aFIF)], {"FIF_XTESTE" ,"Conte�do do campo customizado",Nil}) //  Utiliza��o do Len(aFIF) � para garantir que a grava��o ocorra na ultima posi��o do Array. 

Return aFIF
