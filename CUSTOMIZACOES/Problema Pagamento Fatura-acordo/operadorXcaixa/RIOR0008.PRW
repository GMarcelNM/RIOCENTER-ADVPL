#INCLUDE "rwmake.ch" 
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRIOR0008  บ Autor ณ Gilson Silva       บ Data ณ  21/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio listando cupons por caixa                        บฑฑ
ฑฑบ          ณ Saidas: Cupons de venda / Recebimentos em Dinheiro/Cheque  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RIOR0008


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Cupons Por Caixa"
Local cPict          := ""
Local titulo         := "Relatorio de Cupons Por Caixa"
Local Cabec1         := "   Documento - Serie     Forma                       Valor" 
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 		     := {}
Private nLin         := 80
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RIOR0008" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RIOR0008" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString    := "SL1"       
Private cPerg      := "U_RIOR0008"       
Private lGeral	   := .F.    
Private subTot     := 0
Private subTotRec  := 0
Private nCont      := 0
Private nContRec   := 0
Private aRecebimentos := {}
Private aRecebChe  := {}
Private aRecebDeb  := {}
Private aRecebCre  := {}
Private aVendas    := {}
Private aCaixas	   := {}  

dbSelectArea("SL1")
dbSetOrder(1)

ValidPerg()
If !(Pergunte(cPerg,.T.))
	Return
EndIf 

SelCaixas()  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
  Local i,j := 0
  
Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho do relatorio. . .                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    nLin := 7
Endif
               
For j := 1 to Len(aCaixas)

	Vendas(aCaixas[j][1])
	Recebimentos(aCaixas[j][1])
//	RecebChe(aCaixas[j][1])

	if Len(aVendas) > 1
		For i := 1 to Len(aVendas)
   			If nLin > 55
	      		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    			nLin := 7
	   		Endif
			@++nLin,05 PSAY aVendas[i]
		Next
		nLin++
	endif 

	if Len(aRecebimentos) > 0
		@++nLin,05 PSAY "Recebimentos em Dinheiro "                                   
		For i := 1 to Len(aRecebimentos)
   			If nLin > 55
	   			Cabec1 := "     Historico                                       Valor"  
	      		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    			nLin := 7
   			Endif
			@++nLin,05 PSAY aRecebimentos[i]
		Next
   		nLin++
	endif

	if Len(aRecebChe) > 0 
		@++nLin,05 PSAY "Recebimentos em Cheque"
		For i := 1 to Len(aRecebChe)
   			If nLin > 55
	   			Cabec1 := "     Historico                                       Valor"  
      			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    			nLin := 7
   			Endif
			@++nLin,05 PSAY aRecebChe[i]
		Next
		nLin++
	endif

    if Len(aRecebDeb) > 0
		@++nLin,05 PSAY "Recebimentos em D้bito "                                   
		For i := 1 to Len(aRecebDeb)
   			If nLin > 55
	   			Cabec1 := "     Historico                                       Valor"  
	      		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    			nLin := 7
   			Endif
			@++nLin,05 PSAY aRecebDeb[i]
		Next
   		nLin++
	endif

    if Len(aRecebCre) > 0
		@++nLin,05 PSAY "Recebimentos em Cr้dito "                                   
		For i := 1 to Len(aRecebCre)
   			If nLin > 55
	   			Cabec1 := "     Historico                                       Valor"  
	      		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    			nLin := 7
   			Endif
			@++nLin,05 PSAY aRecebCre[i]
		Next
   		nLin++
	endif
Next

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบFuncao      ณVALIDPERG บ Autor ณ Deus sabe!!!       บ Data ณ      /  /   บฑฑ
//ฑฑฬออออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao   ณ Cria as perguntas                                          บฑฑ
//ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบRetorno     ณ                                                            บฑฑ
//ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบParametros  ณ                                                            บฑฑ
//ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function ValidPerg()
	Local aRegs := {}, i, j
	SX1->(dbSetOrder(1))

	// 01 -> X1_GRUPO   02 -> X1_ORDEM    03 -> X1_PERGUNT  04 -> X1_PERSPA  05 -> X1_PERENG
	// 06 -> X1_VARIAVL 07 -> X1_TIPO     08 -> X1_TAMANHO  09 -> X1_DECIMAL 10 -> X1_PRESEL
	// 11 -> X1_GSC     12 -> X1_VALID    13 -> X1_VAR01    14 -> X1_DEF01   15 -> X1_DEFSPA1
	// 16 -> X1_DEFENG1 17 -> X1_CNT01    18 -> X1_VAR02    19 -> X1_DEF02   20 -> X1_DEFSPA2
	// 21 -> X1_DEFENG2 22 -> X1_CNT02    23 -> X1_VAR03    24 -> X1_DEF03   25 -> X1_DEFSPA3
	// 26 -> X1_DEFENG3 27 -> X1_CNT03    28 -> X1_VAR04    29 -> X1_DEF04   30 -> X1_DEFSPA4
	// 31 -> X1_DEFENG4 32 -> X1_CNT04    33 -> X1_VAR05    34 -> X1_DEF05   35 -> X1_DEFSPA5
	// 36 -> X1_DEFENG5 37 -> X1_CNT05    38 -> X1_F3       39 -> X1_GRPSXG

				//01     02    03                  04  05  06        07   08 09  10  11   12  13          14   		15  16  17  18  19   			20  21  22  23  24   				25  26  27  28  29  				30  31  32  33  34  	 			35  36  37  38   	  39
	aAdd(aRegs, {cPerg, "01", "Caixa de: "		, "", "", "mv_ch1", "C", 3, 0, 00, "G", ""			 , "mv_par01", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "SA6"		, ""})
	aAdd(aRegs, {cPerg, "02", "Caixa Ate:"		, "", "", "mv_ch2", "C", 3, 0, 00, "G", ""			 , "mv_par02", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "SA6"		, ""})
	aAdd(aRegs, {cPerg, "03", "Data de?  "		, "", "", "mv_ch3", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par03", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "04", "Data ate? "		, "", "", "mv_ch4", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par04", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "05", "Filial de?  "	, "", "", "mv_ch5", "C", 4, 0, 00, "G", ""			 , "mv_par05", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "06", "Filial ate? "	, "", "", "mv_ch6", "C", 4, 0, 00, "G", ""			 , "mv_par06", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})

	For i := 1 To Len(aRegs)
	    If ! SX1->(dbSeek(cPerg+aRegs[i,2]))
	        SX1->(RecLock("SX1", .T.))
	        For j :=1 to SX1->(FCount())
	            If j <= Len(aRegs[i])
	                SX1->(FieldPut(j,aRegs[i,j]))
	            Endif
	        Next
	        SX1->(MsUnlock())
	    Endif
	next
Return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ Recebimentos  Gilson Silva            บ Data ณ  23/08/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณMonta o array com os valores de recebimento, nesse caso seraoฑฑ
//ฑฑบ          ณos valores de pgto de fatura e acordo recebidos pelos caixasบฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function Recebimentos(cCaixa)
    
    Local cQuery := "" 
    Local nPos   := 0
    
  Local aVlDin := {}
  Local aVlChq := {}
  Local aVlDeb := {}
  Local cSeq   := ""
  Local lUlDeb := .F.
  Local lUlCre := .F.
      
    nContRec  := 0
	subTotRec := 0
	aRecebimentos := {}
	
 /*  cQuery	:= " SELECT E5_HISTOR,E5_VALOR "
	cQuery	+= " FROM " + RetSqlName('SE5') + " SE5 "
	cQuery	+= " WHERE SE5.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND E5_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
	cQuery	+= " AND E5_DATA BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "	
	cQuery	+= " AND E5_TIPO NOT IN ('CH','R$','CC','NCC','CR') "
	cQuery	+= " AND E5_RECPAG = 'R' "
 	cQuery	+= " AND E5_BANCO = '" + cCaixa + "'"
// 	cQuery	+= " AND LEN(E5_NCARTAO)>1 "                                                       // linha adicionada pq estava vindo no select, as sangrias 
 	cQuery	+= " AND E5_TIPODOC <> 'TR'"                                                       // linha adicionada pq estava vindo no select, as sangrias 
	cQuery	+=	" AND E5_SITUACA <> 'C' "

	QRYREC->(dbGoTop())                          

	While ! QRYREC->(Eof())

		If lAbortPrint
    		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      		Exit
	   	Endif
                      
		aAdd(aRecebimentos,QRYREC->E5_HISTOR + "   " + Transform(QRYREC->E5_VALOR,"@e 999,999.99"))
	
	    subTotRec += QRYREC->E5_VALOR
	    nContRec++ 

		QRYREC->(DbSkip())		
	EndDo
*/

  // --- Pagamento Fatura com DINHEIRO
  // ---------------------------------
	cQuery := "Select Z4_SEQ, Z4_CARTAO, Z4_NOMECLI, Z4_DINHEIR"
	cQuery += "  from " + RetSqlName("SZ4")
	cQuery += "   Where D_E_L_E_T_ = ' '"
	cQuery += "     and Z4_FILIAL between '" + mv_par05 + "' and '" + mv_par06 + "'" 
	cQuery += "     and Z4_DATA between '" + DtoS(mv_par03) + "' and '" + DtoS(mv_par04) + "'"
	cQuery += "     and Z4_OPERADO between '" + mv_par01 + "' and '" + mv_par02 + "'"
    cQuery += "     and Z4_DINHEIR > 0"
     
	If Select("QRYREC") > 0 
		QRYREC->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "QRYREC"	
	
	While ! QRYREC->(Eof())

		If lAbortPrint
    		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      		Exit
	   	Endif
        
        If cSeq <> QRYREC->Z4_SEQ
           aAdd(aRecebimentos,PadR("CARTรO: " + AllTrim(QRYREC->Z4_CARTAO) + " - " + AllTrim(QRYREC->Z4_NOMECLI),43) +;
		                      Transform(QRYREC->Z4_DINHEIR,"@e 999,999.99"))
		  
		   cSeq := QRYREC->Z4_SEQ
           subTotRec += QRYREC->Z4_DINHEIR
		 else                      
           aAdd(aRecebimentos,PadR("CARTรO: " + AllTrim(QRYREC->Z4_CARTAO) + " - " + AllTrim(QRYREC->Z4_NOMECLI),43) + Space(06) + "---")
        EndIf
                  	
	    nContRec++ 

		QRYREC->(DbSkip())		
	EndDo
	
	If Len(aRecebimentos) > 0
	   aAdd(aRecebimentos, "Total (" +  Transform(nContRec,"@9,999") +"):"+ Transform(subTotRec,"@e 999,999.99") )
    EndIf

  // --- Pagamento Fatura com CHEQUE / DษBITO / CREDITO
  // ----------------------------------------
	cQuery := "Select SZ5.Z5_TIPO, SZ5.Z5_NUMCHQ, SZ5.Z5_VALOR, SZ5.Z5_NSU"
    cQuery += "  from " + RetSqlName("SZ5") + " SZ5"
    cQuery += "   Where SZ5.D_E_L_E_T_ = ' '"
    cQuery += "     and SZ5.Z5_FILIAL between '" + mv_par05 + "' and '" + mv_par06 + "'"  
	cQuery += "     and SZ5.Z5_DATA between '" + DtoS(mv_par03) + "' and '" + DtoS(mv_par04) + "'"
    cQuery += "     and SZ5.Z5_OPERADO between '" + mv_par01 + "' and '" + mv_par02 + "'"
    cQuery += "   Order by SZ5.Z5_TIPO"
    
	If Select("QRYREC1") > 0 
		QRYREC1->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "QRYREC1"	

    aRecebChe := {}
    aRecebDeb := {}
    aRecebCre := {}
    subTotRec := 0
    nContRec  := 0 
	
	While ! QRYREC1->(Eof())
		If lAbortPrint
    		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      		Exit
	   	Endif
        
        If QRYREC1->Z5_TIPO == "CD" .and. ! lUlCre
           If Len(aRecebCre) > 0
              aAdd(aRecebCre, "Total (" +  Transform(nContRec,"@9,999") +"):"+ Transform(subTotRec,"@e 999,999.99") )
           EndIf
	
           subTotRec := 0
           nContRec  := 0
           lUlCre    := .T. 
        EndIf

        If QRYREC1->Z5_TIPO == "CH" .and. ! lUlDeb
	       IF Len(aRecebCre) > 0 .and. (!lUlCre)
              aAdd(aRecebCre, "Total (" +  Transform(nContRec,"@9,999") +"):"+ Transform(subTotRec,"@e 999,999.99") )
			  lUlCre    := .T.	  
           Endif	

           If Len(aRecebDeb) > 0
              aAdd(aRecebDeb, "Total (" +  Transform(nContRec,"@9,999") +"):"+ Transform(subTotRec,"@e 999,999.99") )
           EndIf
	
           subTotRec := 0
           nContRec  := 0
           lUlDeb    := .T. 
        EndIf
                  
		IF QRYREC1->Z5_TIPO == "CC"
           aAdd(aRecebCre,PadR("NSU: " + AllTrim(QRYREC1->Z5_NSU),43) + Transform(QRYREC1->Z5_VALOR,"@e 999,999.99"))
		elseIf QRYREC1->Z5_TIPO == "CD"
           aAdd(aRecebDeb,PadR("NSU: " + AllTrim(QRYREC1->Z5_NSU),43) + Transform(QRYREC1->Z5_VALOR,"@e 999,999.99"))
         else
           aAdd(aRecebChe,PadR("CHEQUE : " + AllTrim(QRYREC1->Z5_NUMCHQ),43) + Transform(QRYREC1->Z5_VALOR,"@e 999,999.99"))
        EndIf
          	      
	    subTotRec += QRYREC1->Z5_VALOR
	    nContRec++ 
              
		QRYREC1->(DbSkip())		
	EndDo
    IF Len(aRecebCre) > 0 .and. (!lUlCre)
       aAdd(aRecebCre, "Total (" +  Transform(nContRec,"@9,999") +"):"+ Transform(subTotRec,"@e 999,999.99") )
       lUlCre    := .T.	  
    Endif	

    IF Len(aRecebDeb) > 0 .and. (!lUlDeb)
       aAdd(aRecebDeb, "Total (" +  Transform(nContRec,"@9,999") +"):"+ Transform(subTotRec,"@e 999,999.99") )
       lUlDeb    := .T.	  
    Endif	

    If Len(aRecebChe) > 0
       aAdd(aRecebChe, "Total (" +  Transform(nContRec,"@9,999") +"):"+ Transform(subTotRec,"@e 999,999.99") )
    EndIf
	
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ RecebChe    Gilson Silva              บ Data ณ  22/08/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณMonta o array com os valores de recebimento, em cheque       ฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function RecebChe(cCaixa)

	Local cQuery, nPos, nSubTot, nCont
	nSubTot := 0
	nCont := 0
	aRecebChe := {}
	
	cQuery	:= " SELECT EF_HIST, EF_TITULO,EF_CLIENTE,EF_VALOR "
	cQuery	+= " FROM " + RetSqlName('SEF') + " SEF "
	cQuery	+= " INNER JOIN " + RetSqlName('SE1') + " SE1  "
	cQuery	+= " ON EF_FILIAL + EF_PREFIXO + EF_TITULO + EF_PARCELA + EF_TIPO  "
	cQuery	+= "	=  E1_FILIAL + E1_PREFIXO + E1_NUM    + E1_PARCELA + E1_TIPO "

	cQuery	+= " WHERE EF_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
	cQuery	+= " AND E1_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
    cQuery  += " AND E1_
//	cQuery	+= " AND E1_YCXORIG = '" + cCaixa + "'"							

	cQuery	+= "	AND SE1.D_E_L_E_T_ <> '*' AND SEF.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND E1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	
	If Select("QRYREC2") > 0 
		QRYREC2->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "QRYREC2"	

	QRYREC2->(dbGoTop())

	While QRYREC2->(!EOF())

		If lAbortPrint
    		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      		Exit
	   	Endif                      
		aAdd(aRecebChe,substr(QRYREC2->EF_HIST,1,30) + QRYREC2->EF_TITULO + "    " + Transform(QRYREC2->EF_VALOR,"@e 999,999.99")) // QRYREC2->EF_CLIENTE
	    nSubTot += QRYREC2->EF_VALOR
	    nCont++

		QRYREC2->(DbSkip())		
	EndDo
	if len(aRecebChe)>0
	  aAdd(aRecebChe, "Total (" +  Transform(nCont,"@9,999") +"):"+ Transform(nSubTot,"@e 999,999.99") )
    endif
return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ Vendas - Gilson Silva                 บ Data ณ  22/08/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณMonta o array com os valores de recebimento, nesse caso seraoฑฑ
//ฑฑบ          ณos valores de pgto de fatura e acordo recebidos pelos caixasบฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function Vendas(cCaixa)

	Local cQuery, nPos, nSubTot, nCont
	nSubTot := 0
	nCont := 0
	aVendas := {} 

	cQuery := " SELECT DISTINCT A6_NOME,L1_DOC,L1_SERIE,L1_OPERADO,L4_FORMA,SUM(L4_VALOR-L4_TROCO) AS TOTAL,L1_DINHEIR, L1_TROCO1"
	cQuery += ",CASE WHEN LEN(L4_ADMINIS)<1 THEN CASE WHEN L4_FORMA = 'CR' THEN 'TROCA' ELSE 'DINHEIRO' END ELSE UPPER(L4_ADMINIS) END AS L4_ADMINIS "
	cQuery += " FROM " + RetSqlName('SL1') + " SL1 INNER JOIN " + RetSqlName('SL4') + " SL4 ON SL1.L1_FILIAL=SL4.L4_FILIAL AND SL1.L1_NUM=SL4.L4_NUM "
	cQuery += " INNER JOIN " + RetSqlName('SA6') + " SA6 ON L1_OPERADO = A6_COD "
	cQuery += " WHERE L1_OPERADO = '" + cCaixa + "' " 
	cQuery += " AND L1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "	
	cQuery += " AND SL4.D_E_L_E_T_ <> '*' AND SL1.D_E_L_E_T_ <> '*' AND SA6.D_E_L_E_T_ <> '*' "
//	cQuery += " AND L1_STATUES = ' ' "
	cQuery += " AND L1_SITUA = 'OK' AND L1_DOC <> ' ' AND L1_SERIE <> ' ' "
	cQuery += " GROUP BY A6_NOME,L1_DOC,L1_SERIE,L1_OPERADO,L4_FORMA, L1_DINHEIR, L1_TROCO1, L4_ADMINIS "
 
	cQuery += " ORDER BY L4_FORMA "

	If Select("QRYCUP") > 0 
		QRYCUP->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias "QRYCUP"	

	QRYCUP->(dbGoTop())

	cForma := QRYCUP->L4_FORMA             
	subTotForma := 0
    
    if QRYCUP->(!EOF()) 
	  aAdd(aVendas,QRYCUP->L1_OPERADO + " - " + alltrim(QRYCUP->A6_NOME) + " | Data: " + DtoC(MV_PAR03) + " a " + DtoC(MV_PAR04)) 
    endif
    
	While QRYCUP->(!EOF())
		
		if QRYCUP->L4_FORMA != cForma
			aAdd(aVendas,space(43)+Transform(subTotForma,"@e 999,999.99"))
			cForma := QRYCUP->L4_FORMA
			subTotForma := 0
		endif

	    aAdd(aVendas,QRYCUP->L1_DOC +" - "+ QRYCUP->L1_SERIE + space(5) + rtrim(QRYCUP->L4_FORMA) +" "+ QRYCUP->L4_ADMINIS + Transform(  IIF(QRYCUP->L4_FORMA='R$',QRYCUP->L1_DINHEIR-QRYCUP->L1_TROCO1,QRYCUP->TOTAL)  ,"@e 999,999.99"))
	    subTotForma += IIF(QRYCUP->L4_FORMA='R$',QRYCUP->L1_DINHEIR-QRYCUP->L1_TROCO1,QRYCUP->TOTAL)
	    nSubTot += IIF(QRYCUP->L4_FORMA='R$',QRYCUP->L1_DINHEIR-QRYCUP->L1_TROCO1,QRYCUP->TOTAL)
	    nCont++
		nLin   := nLin + 1 // Avanca a linha de impressao

		QRYCUP->(DbSkip()) // Avanca o ponteiro do registro no arquivo
	
	EndDo
	if len(aVendas)>1
		aAdd(aVendas,space(43)+Transform(subTotForma,"@e 999,999.99"),70)
		aAdd(aVendas,"Total (" +  Transform(nCont,"@9,999") +"):"+ Transform(nSubTot,"@e 999,999.99"))
    endif
return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ SelCaixas  - Gilson Silva             บ Data ณ  23/08/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณMonta o array com os caixas selecionados nos parametros      ฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function SelCaixas()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSeleciona os caixas(bancos) informados nos parametrosณ
	//ณe coloca no array de caixas para impressao.          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery	:= " SELECT * FROM " + RetSqlName("SA6") + " SA6 "
	cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND A6_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery	+= " AND A6_FILIAL BETWEEN '" + left(MV_PAR05,2) + "' AND '" + left(MV_PAR06,2) + "' " 
	
	If Select('QRYSA6') > 0
		QRYSA6->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias 'QRYSA6'	

	While QRYSA6->(!Eof())
		aAdd(aCaixas,{QRYSA6->A6_COD, QRYSA6->A6_NOME})
		QRYSA6->(DbSkip())
	Enddo	

return 
