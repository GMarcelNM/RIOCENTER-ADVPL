#Include "PROTHEUS.CH"

/*/{Protheus.doc} StMenEdt
Este ponto de entrada � executado na inicializa��o da rotina TotvsPDV para edi��o dos itens no menu.
Possui como par�metro de entrada, o array referente ao menu do TotvsPDV e retorna os itens de menu que ser�o exibidos na janela do TotvsPDV.
@author jerfferson.silva
@since 	27/04/2017
@param 	ParamIXB, ${Array}, Array contendo os itens de Menu do TotvPdv.
@return aRetor, ${Array}, Array(array_of_record) Retorno do ponto de entrada, contendo a mesma estrutura que o par�metro de entrada.
@see 	(http://tdn.totvs.com/display/public/PROT/STMenEdt+-+Montagem+de+itens+de+menu+do+TotvsPDV)
@obs	Estrutura do Array de Retorno. 
		aRetor - Array contendo os itens de Menu do TotvPdv onde. 
		cCol1 - Sequ�ncia do Menu 
		cCol2 - T�tulo do Menu 
		cCol3 - Fun��o a ser executada 
		cCol4 - Flag do Menu, onde "M" indica que o mesmo ser� exibido, mesmo o ECF estando off-line na modalidade PAF-ECF, padr�o "".
/*/
User Function STMenEdt()
  Local aRetor 	:= {}
  Local nJ    	:= 0
  Local nH	  	:=  0
//  Local cExMenu	:= "Vale Presente/Cr�dito/Vale Troca/Recebimento de Titulo/Estorno de titulos/Cancelar Recebimento"
  Local cExMenu	:= ""
  Local cMenu	:= ""
  Local cSqMenu := ""
  	
  For nJ := 1 to Len(ParamIXB)
	For nH := 1 to Len(ParamIXB[1])
	    cMenu := ParamIXB[nJ,nH,2]
		
		If !(cMenu $ cExMenu)
		   aAdd(aRetor,{ParamIXB[nJ,nH,1],ParamIXB[nJ,nH,2],ParamIXB[nJ,nH,3],ParamIXB[nJ,nH,4]})
		EndIf
       
        cSqMenu := ParamIXB[nJ,nH,1]
	Next	
  Next

  aAdd(aRetor,{Str((Val(cSqMenu) + 1)),"Pagamento Fatura"      ,"U_RIOA0001()","M"})
  aAdd(aRetor,{Str((Val(cSqMenu) + 1)),"Reimpress�o Rio Center","U_RIOPDV02()","M"})
  aAdd(aRetor,{Str((Val(cSqMenu) + 1)),"Reimpress�o Cupom de Troca","U_RIOPDV03()","M"})

Return(aRetor)
