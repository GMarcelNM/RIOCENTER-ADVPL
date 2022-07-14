#Include "PROTHEUS.CH"
#INCLUDE "LOJXTEF.CH" 
#INCLUDE "AUTODEF.CH"
#Include "TBICONN.CH"
#INCLUDE "POSCSS.CH"
#Include "FWPRINTSETUP.CH"
#Include "RPTDEF.CH"

/*/{Protheus.doc} RIOPDV03
  Função RIOPDV03
  @param não tem
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 19/07/2018 
  @sample
// RIOPDV02 - User Function para reimpressão de comprovante de venda / pagamento fatura
  U_RIOPDV02()
  Return
  @obs Rotina de tela para reimpressão
  @history
  19/07/2018 - Desenvolvimento da Rotina.
/*/
User Function RIOPDV03()
  Local cNomeArq := ""
  Local cChave   := ""
  Private cUltimo := ""
  Private cFiltro := ""
  
  Private cCartao  := Space(13)
  Private aCpoTmp  := {}
  Private lInverte := .F.
  Private cMark    := GetMark()
  Private oDlgFor, oMark
  
 // --- Criação de tabela temporária
 // --------------------------------

  aAdd(aCpoTmp,{"F_MARCA"  ,"C",02,0})
  aAdd(aCpoTmp,{"F_NUM" ,"C",06,0})
  aAdd(aCpoTmp,{"F_FILIAL" ,"C",04,0})
  aAdd(aCpoTmp,{"F_ITEM" ,"C",02,0})
  aAdd(aCpoTmp,{"F_PRODUTO"   ,"C",30,0})
  aAdd(aCpoTmp,{"F_DESCRI"   ,"C",100,0})
  aAdd(aCpoTmp,{"F_SAIDA"   ,"C",10,0})
  aAdd(aCpoTmp,{"F_RECNO"  ,"N",14,0})

  cNomeArq := CriaTrab(aCpoTmp, .T.)
  cChave   := "F_ITEM"
  
  If Select("TMP") > 0
	 TMP->(DbCloseArea())
  EndIf

  dbUseArea(.T.,, cNomeArq,"TMP",.F.,)
  aCpoTmp := {}

  aAdd(aCpoTmp,{"F_MARCA"  ,"", " "})
  aAdd(aCpoTmp,{"F_ITEM" ,"","Item"})
  aAdd(aCpoTmp,{"F_PRODUTO" , "" ,"Código"})
  aAdd(aCpoTmp,{"F_DESCRI", "" ,"Descrição"})
  aAdd(aCpoTmp,{"F_SAIDA", "" ,"Saída"})

 // --- Montar grid
 // --- Venda com Cartão Rio Center
 // -------------------------------
  dbSelectArea("SL2")
  SL2->(dbSetOrder(1))
  cUltimo := L1UltSeq()
 // DbSeek(xFilial("SL2")+cUltimo)
 // cFiltro := 'L2_NUM = "' + cUltimo + '"'
 // SL2->(dbSetFilter({|| &cFiltro}, cFiltro))
 // SL2->(dbGoTop())
  
 //  While ! SL2->(Eof())
  dbSelectArea("SL2")
  SL2->(dbGoTop())
  SL2->(dbSetOrder(1))

  aCupons := {}
 
  If SL2->(dbSeek(xFilial("SL2") + cUltimo)) 
  While ! SL2->(Eof()) .and. SL2->L2_FILIAL == xFilial("SL1") .and. SL2->L2_NUM == cUltimo
     DbSelectArea("TMP")
     RecLock("TMP",.T.)
     Replace TMP->F_FILIAL  with SL2->L2_FILIAL
     Replace TMP->F_NUM  with SL2->L2_NUM
     Replace TMP->F_ITEM  with SL2->L2_ITEM
     Replace TMP->F_PRODUTO    with SL2->L2_PRODUTO
     Replace TMP->F_DESCRI    with SL2->L2_DESCRI
     Replace TMP->F_SAIDA    with dtoc(SL2->L2_EMISSAO)
     Replace TMP->F_RECNO   with SL2->(Recno())
     TMP->(MsUnlock())
       
     SL2->(dbSkip())
  EndDo
  ENDIF
  
  dbSelectArea("SL1")
  SL1->(dbSetOrder(1))
  DbSeek(xFilial("SL1")+cUltimo)
 
  dbSelectArea("TMP")
  TMP->(dbGoTop())
  

  Define Font oFont    Name "Lucida Console" Size 0,-12 Bold
  Define Font oFCartao Name "Lucida Console" Size 0,-18 Bold

  Define MsDialog oDlg Title "REIMPRESSÃO DE CUPONS DE TROCA" From 180,180 To 590,865 Pixel STYLE DS_MODALFRAME
  @ 005,005 To 48,340 Label "ÚLTIMO NFCe EMITIDO - " + SL1->L1_DOC Pixel Of oDlg
    oMrkImp := MsSelect():New("TMP","F_MARCA","",aCpoTmp,@lInverte,@cMark,{20,5,180,340})

    ObjectMethod(oMrkImp:oBrowse,"Refresh()")
    
    oMrkImp:bMark := {|| fn001Mk()}
    oMrkImp:oBrowse:lhasMark    := .T.
    oMrkImp:oBrowse:lCanAllmark := .T.
    oMrkImp:oBrowse:bAllMark    := {|| fn001MTd(cMark,oDlgFor)}

  // --- Botões
  // ----------    
    oButRPg := TButton():New(185,215,"Reimpressão",oDlg,{|| RIOCupTr(),oDlg:End()},55,14,,,,.T.,,,,{||})
    oButRPg:SetCSS( POSCSS (GetClassName(oButRPg),CSS_BTN_FOCAL)) 

    oButFec := TButton():New(185,275,"Fechar",oDlg,{|| oDlg:End()},55,14,,,,.T.,,,,{||})
    oButFec:SetCSS( POSCSS (GetClassName(oButFec),CSS_BTN_FOCAL)) 
  Activate MsDialog oDlg Centered 

Return

/*================================================
--  Função: Marcar registro no MarkBrowser.     --
--                                              --
==================================================*/
Static Function fn001Mk()
  RecLock("TMP",.F.)
    If Marked("F_MARCA")
       TMP->F_MARCA := cMark
     else
       TMP->F_MARCA := ""
    Endif 
  (MsUnLock())

  oMrkImp:oBrowse:Refresh()
Return

/*==================================
--  Função: Marca/Desmarca tudo.  --
--                                --
====================================*/
Static Function fn001MTd(cMark,oDlg)
  Local nRecno := Recno()

  TMP->(dbGotop())
  
  While ! TMP->(Eof())
    RecLock("TMP",.F.)   
      TMP->F_MARCA := cMark
    MsUnlock()                   

    TMP->(dbSkip())
  EndDo

  dbGoto(nRecno)

  oDlg:Refresh()
Return .T.

/*=========================================
--  Função: Reimpressão de conprovante.  --
--                                       --
===========================================*/
//Static Function fn001Rei(cMark)
// TMP->(dbGotop())
//  While ! TMP->(Eof())
//    If IsMark("F_MARCA", cMark)
//      U_RIOF9003("V I A  O P E R A D O R","P")
//    EndIf      
//
//    TMP->(dbSkip())
//  EndDo
//Return


static function L1UltSeq()
   dbSelectArea("SL1")
   dbSetOrder(1)
   dbGoBottom()

   cSeq := SL1->L1_Num
    
   dbCloseArea()
return cSeq



static Function RIOCupTr()
//ALERT(cFiltro)
//ALERT(SL1->L1_CLIENTE)
//ALERT(SL1->L1_NUM)
//ALERT(STDGPBasket( "SL2" , "L2_NUM" ))
//ALERT(Posicione("SA1",1,xFilial("SL1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"SA1->A1_NOME"))
//ALERT(AllTrim(SM0->M0_BAIRENT))

Local aArea       := GetArea()													// Salva a area corrente
Local cCupomTroca := ""															// Codigo do cupom de troca
Local cSerie      := ""	// Serie da impressora
Local cSerieCVT   := ""															// Serie codificada que sera impressa no cupom de troca
Local nCount      := 1															// Contador
Local nX          := 0															// Contador
Local aCVTs       := {}															// Array contendo os codigos de barras que serao impressos no Cupom de Vale Troca
Local cNumCupom   := ""						// Nï¿½mero do Cupom Fiscal
Local cL1Num      := ""							// Nï¿½mero do Orï¿½amento
Local cCabecalho  := ""															// Cabeï¿½alho para impressï¿½o
Local cRodape     := ""															// Rodapï¿½ para impressï¿½o
Local nHdlECF     := 0															// Handle para ECF
Local cWhile      := ""															// Variï¿½vel While
Local lValTroca   := SuperGetMV( "MV_VLTROCA",,.F. )							// Imprime vale-troca    
Local cTabela     := ""                                                         // Tabela promocional
Local cAtiva      := ""															// Tabela Ativa
Local aImpItens   := STIGetCVTs()												// Imprime vale-trocas selecionados
Local aRet		  := {}
//Local CRLF	      := Chr(10)
Local cTexto		:= ""
Local cDescFilial := ""

#DEFINE TAG_CENTER_INI	"<ce>"	//centralizado
#DEFINE TAG_CENTER_FIM	"</ce>"//centralizado
#DEFINE TAG_CONDEN_INI	"<c>"	//condensado
#DEFINE TAG_CONDEN_FIM	"</c>"	//condensado
#DEFINE TAG_CODABAR_INI	"<codabar>"//codigo de barras CODABAR
#DEFINE TAG_CODABAR_FIM	"</codabar>"

//  cUltimo := L1UltSeq()
//  cFiltro := 'L1_NUM = "' + cUltimo + '"'
//  SL1->(dbSetFilter({|| &cFiltro}, cFiltro))
 //  SL1->(dbGoTop())

cSerie      := PadR(LjGetStation("SERIE"),TamSX3("L1_SERIE")[1])	// Serie da impressora
cNumCupom   := SL1->L1_DOC							// Nï¿½mero do Cupom Fiscal
cL1Num      := SL1->L1_NUM							// Nï¿½mero do Orï¿½amento

cRodape := CRLF
cRodape += "Cupom Fiscal      : "+cNumCupom+CRLF
cRodape += "Serie             : "+cSerie+CRLF
//cRodape += "Cliente           : "+SL1->L1_CLIENTE+"/"+SL1->L1_LOJA+CRLF
//cRodape += "Nome do Cliente   : "+Posicione("SA1",1,xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"SA1->A1_NOME")+CRLF


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
SL2->(DbSetOrder(1))

If DbSeek(xFilial("SL2")+cL1Num)
  TMP->(dbGotop())
  While !TMP->(Eof())
 //   If IsMark("F_MARCA", cMark)
    IF TMP->F_MARCA == cMark
      DbSeek(xFilial("SL2")+TMP->F_NUM+TMP->F_ITEM+TMP->F_PRODUTO)
  		For nX := 1 To SL2->L2_QUANT
//	  		cCabecalho := "        C U P O M  D E  T R O C A         " +CRLF
	  		cCabecalho := ""
        cCabecalho += "        =========================         " +CRLF //+CRLF  
  			cCabecalho += "            R I O  C E N T E R            " +CRLF
        cCAbecalho += cDescFilial + CRLF
 // 			cCabecalho += AllTrim(SM0->M0_NOMECOM)                 +CRLF
 // 			cCabecalho += AllTrim(SM0->M0_ENDENT)                 +CRLF
 // 			cCabecalho += AllTrim(SM0->M0_BAIRENT)                +CRLF
 // 			cCabecalho += AllTrim(Substr(SM0->M0_CGC,1,2)+"."+SubStr(SM0->M0_CGC,3,3)+"."+SubStr(SM0->M0_CGC,4,3)+"/"+SubStr(SM0->M0_CGC,9,4)+"-"+SubStr(SM0->M0_CGC,13,2))+CRLF+CRLF
 // 			cCabecalho += "==========================================" +CRLF
 // 			cCabecalho += "Item   : "+SL2->L2_ITEM+CRLF
 // 			cCabecalho += "Codigo : "+SL2->L2_PRODUTO+CRLF
 // 			cCabecalho += "Produto: "+AllTrim(SL2->L2_DESCRI)+CRLF
 // 			cCabecalho += "Saida  : "+DtoC(SL2->L2_EMISSAO)+CRLF
 // 			cCabecalho += "Emissao: "+DtoC(SL2->L2_EMISSAO)+"   - Via Consumidor"+CRLF
  			cCabecalho += "==========================================" +CRLF//+CRLF   

     		cCabecalho += " AS TROCAS SERAO REALIZADAS MEDIANTE"+CRLF
  			cCabecalho += " APRESENTACAO DESTE TICKET E DENTRO"+CRLF
  			cCabecalho += " DO PRAZO MAXIMO DE TRINTA DIAS, "+CRLF
  			cCabecalho += " SEU PRAZO DE TROCA"+CRLF
  			cCabecalho += " EXPIRA NO DIA  "+DtoC(SL2->L2_EMISSAO+30)+CRLF//+CRLF  
  
  			Aadd(aCVTs,{cCabecalho,cCupomTroca+SL2->L2_ITEM})

  		Next nX
      
    EndIf      
    TMP->(dbSkip())
  EndDo
EndIf

For nX := 1 To Len( aCVTs )
	aAdd(aRet,{aCVTs[nX,1],aCVTs[nX,2],cRodape})
Next nX


If Len(aRet) > 0
        		    		cTexto += TAG_CENTER_INI + "  " + TAG_CENTER_FIM
			    	For nR := 1 To Len(aRet)
	  		      cTexto += TAG_CENTER_INI + "        C U P O M  D E  T R O C A         " + CRLF + TAG_CENTER_FIM
			    		cTexto += TAG_CENTER_INI + aRet[nR][1]+ TAG_CENTER_FIM
				    	cTexto += TAG_CENTER_INI + TAG_CONDEN_INI +TAG_CODABAR_INI +AllTrim(aRet[nR][2])+ TAG_CODABAR_FIM + TAG_CONDEN_FIM + TAG_CENTER_FIM
			    		cTexto += TAG_CENTER_INI + AllTrim(aRet[nR][2])+ TAG_CENTER_FIM
			    		cTexto += aRet[nR][3]
			    		cTexto += (TAG_GUIL_INI + TAG_GUIL_FIM)	//aciona a guilhotina
					
			     	Next
            STWPrintTextNotFiscal(cTexto)
	EndIf


RestArea( aArea )

return 
