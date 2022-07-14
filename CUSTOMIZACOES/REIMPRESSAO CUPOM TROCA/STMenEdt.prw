#Include "PROTHEUS.CH"

/*/{Protheus.doc} StMenEdt
Este ponto de entrada é executado na inicialização da rotina TotvsPDV para edição dos itens no menu.
Possui como parâmetro de entrada, o array referente ao menu do TotvsPDV e retorna os itens de menu que serão exibidos na janela do TotvsPDV.
@author jerfferson.silva
@since 	27/04/2017
@param 	ParamIXB, ${Array}, Array contendo os itens de Menu do TotvPdv.
@return aRetor, ${Array}, Array(array_of_record) Retorno do ponto de entrada, contendo a mesma estrutura que o parâmetro de entrada.
@see 	(http://tdn.totvs.com/display/public/PROT/STMenEdt+-+Montagem+de+itens+de+menu+do+TotvsPDV)
@obs	Estrutura do Array de Retorno. 
		aRetor - Array contendo os itens de Menu do TotvPdv onde. 
		cCol1 - Sequência do Menu 
		cCol2 - Título do Menu 
		cCol3 - Função a ser executada 
		cCol4 - Flag do Menu, onde "M" indica que o mesmo será exibido, mesmo o ECF estando off-line na modalidade PAF-ECF, padrão "".
/*/
User Function STMenEdt()
  Local aRetor 	:= {}
  Local nJ    	:= 0
  Local nH	  	:=  0
//  Local cExMenu	:= "Vale Presente/Crédito/Vale Troca/Recebimento de Titulo/Estorno de titulos/Cancelar Recebimento"
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
  aAdd(aRetor,{Str((Val(cSqMenu) + 1)),"Reimpressão Rio Center","U_RIOPDV02()","M"})
  aAdd(aRetor,{Str((Val(cSqMenu) + 1)),"Reimpressão Cupom de Troca","U_RIOPDV03()","M"})

Return(aRetor)
