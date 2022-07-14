#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} ImpTroc
//TODO Fun��o respons�vel por imprimir um cupom de troca para o Produto
@author gilmar.alves
@since 15/09/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User function ImpTroc()

Local aArea       := GetArea()													// Salva a area corrente
Local cCupomTroca := ""															// Codigo do cupom de troca
Local cSerie      := PadR(LjGetStation("SERIE"),TamSX3("L1_SERIE")[1])	// Serie da impressora
Local cSerieCVT   := ""															// Serie codificada que sera impressa no cupom de troca
Local nCount      := 1															// Contador
Local nX          := 0															// Contador
Local aCVTs       := {}															// Array contendo os codigos de barras que serao impressos no Cupom de Vale Troca
Local cNumCupom   := STDGPBasket( "SL1" , "L1_DOC" )							// N�mero do Cupom Fiscal
Local cL1Num      := STDGPBasket( "SL1" , "L1_NUM" )							// N�mero do Or�amento
Local cCabecalho  := ""															// Cabe�alho para impress�o
Local cRodape     := ""															// Rodap� para impress�o
Local nHdlECF     := 0															// Handle para ECF
Local cWhile      := ""															// Vari�vel While
Local lValTroca   := SuperGetMV( "MV_VLTROCA",,.F. )							// Imprime vale-troca    
Local cTabela     := ""                                                         // Tabela promocional
Local cAtiva      := ""															// Tabela Ativa
Local aImpItens   := STIGetCVTs()												// Imprime vale-trocas selecionados
Local aRet		  := {}
//Local CRLF	      := Chr(10)
Local cDescFilial := ""

cRodape := CRLF
cRodape += "Cupom Fiscal      : "+cNumCupom+CRLF
cRodape += "Serie             : "+cSerie+CRLF
//cRodape += "Cliente           : "+STDGPBasket( "SL1" , "L1_CLIENTE" )+"/"+STDGPBasket( "SL1", "L1_LOJA" )+CRLF
//cRodape += "Nome do Cliente   : "+Posicione("SA1",1,xFilial("SA1")+STDGPBasket( "SL1" , "L1_CLIENTE" )+STDGPBasket( "SL1", "L1_LOJA" ),"SA1->A1_NOME")+CRLF

iF xFilial("SL1") = '0102'
  cDescFilial := "            M E G A  S T O R E            "                                
ELSEIF xFilial("SL1") = '0101'  
  cDescFilial := "               C E N T R O                "                                
ELSE   
  cDescFilial := "        N A T A L  S H O P P I N G        "                                
EndIF

While nCount <= Len(cSerie)
	
	If IsDigit(SubStr(cSerie,nCount,1))
		cSerieCVT += "0"+SubStr(cSerie,nCount,1)
	ElseIf Empty(SubStr(cSerie,nCount,1))
		cSerieCVT += "99"
	Else
		cSerieCVT += AllTrim(Str(ASC(SubStr(cSerie,nCount,1))))
	EndIf
	
	nCount++
End

cCupomTroca := AllTrim(cNumCupom)+cSerieCVT

DbSelectArea("SL2")
SL2->(DbSetOrder())

If DbSeek(xFilial("SL2")+cL1Num)
	While xFilial('SL1')+cL1Num == xFilial('SL2')+SL2->L2_NUM
		
		//MV_VLTROCA = .F.: Aparece a op��o via F2 para selecionar itens para impress�o
		//MV_VLTROCA = .T.: N�o h� sele��o de vale-troca (op��o via F2 desabilitado),
		//                  mas s�o impressos vale-troca em todos os itens
		If lValTroca .AND. aScan(aImpItens,SL2->L2_ITEM) == 0
			SL2->(DbSkip())
			Loop
		EndIf
		
		For nX := 1 To SL2->L2_QUANT
			cCabecalho := "        C U P O M  D E  T R O C A         " +CRLF
			cCabecalho += "        =========================         " +CRLF  //+CRLF
			cCabecalho += "            R I O  C E N T E R            " +CRLF
			cCabecalho += cDescFilial + CRLF
//			cCabecalho += AllTrim(SM0->M0_NOMECOM)                 +CRLF
//			cCabecalho += AllTrim(SM0->M0_ENDENT)                 +CRLF
//			cCabecalho += AllTrim(SM0->M0_BAIRENT)                +CRLF
//			cCabecalho += AllTrim(Substr(SM0->M0_CGC,1,2)+"."+SubStr(SM0->M0_CGC,3,3)+"."+SubStr(SM0->M0_CGC,4,3)+"/"+SubStr(SM0->M0_CGC,9,4)+"-"+SubStr(SM0->M0_CGC,13,2))+CRLF+CRLF
//			cCabecalho += "==========================================" +CRLF
//			cCabecalho += "Item   : "+SL2->L2_ITEM+CRLF
//			cCabecalho += "Codigo : "+SL2->L2_PRODUTO+CRLF
//			cCabecalho += "Produto: "+AllTrim(SL2->L2_DESCRI)+CRLF
//			cCabecalho += "Saida  : "+DtoC(SL2->L2_EMISSAO)+CRLF
//			cCabecalho += "Emissao: "+DtoC(SL2->L2_EMISSAO)+"   - Via Consumidor"+CRLF
			cCabecalho += "==========================================" +CRLF//+CRLF   
			
			cTabela := Posicione("DA1",2,xFilial("DA1")+SL2->L2_PRODUTO,"DA1_CODTAB")
			cAtiva  := Posicione("DA0",1,xFilial("DA0")+cTabela,"DA0_ATIVO")
			
			//sessão comentado devido a solicitação da diretoria, incluir mensagem de este produto não podera ser trocado
			//If cAtiva == "1"
			//	cCabecalho += " ESTE PRODUTO NAO PODERA SER TROCADO"+CRLF
			//	cCabecalho += " POIS ESTA EM PROMOCAO"+CRLF
			//Else
				cCabecalho += " AS TROCAS SERAO REALIZADAS MEDIANTE"+CRLF
				cCabecalho += " APRESENTACAO DESTE TICKET E DENTRO"+CRLF
				cCabecalho += " DO PRAZO MAXIMO DE TRINTA DIAS, "+CRLF
				cCabecalho += " SEU PRAZO DE TROCA"+CRLF
				cCabecalho += " EXPIRA NO DIA  "+DtoC(SL2->L2_EMISSAO+30)+CRLF //+CRLF

			//EndIf
			Aadd(aCVTs,{cCabecalho,cCupomTroca+SL2->L2_ITEM})
		Next nX
		SL2->(DbSkip())
		
		//			cCabecalho += SubStr(SM0->M0_NOMECOM,1,38)                 +CRLF+CRLF
		//			cCabecalho += SubStr(SM0->M0_ENDENT ,1,38)                 +CRLF+CRLF
		//			cCabecalho += SubStr(SM0->M0_BAIRENT ,1,38)                +CRLF+CRLF
		
	End
EndIf

For nX := 1 To Len( aCVTs )
	/*STFFireEvent(	ProcName(0)						,;		// Nome do processo
	"STPrntBarCode"									,;		// Nome do evento
	{aCVTs[nX,1]									,;		// 01 - Cabecalho
	Replicate("0",6)+aCVTs[nX,2] 				    ,; 		// 02 - Codigo de barras
	cRodape					     					,;		// 03 - Rodape
	1												})		// 04 - Numero de vias*/
	aAdd(aRet,{aCVTs[nX,1],aCVTs[nX,2],cRodape})
Next nX

//Replicate("0",6)+

RestArea( aArea )

return aRet
