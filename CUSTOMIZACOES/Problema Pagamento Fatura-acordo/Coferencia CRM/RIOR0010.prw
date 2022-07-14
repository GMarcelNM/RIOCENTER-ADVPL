#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.ch"
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ RIOR0010 บAutor  ณSIDNEY SALES        บ Data ณ  11/04/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณRELATORIO DE VENDAS E PAGAMENTOS NO CARTAO RIO CENTER       บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RIOR0010

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Relat๓rio de Confer๊ncia CRM"
Private cPict          := ""
Private titulo       := "Relat๓rio de Confer๊ncia CRM"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""

Private imprime      := .T.
Private aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "RIOR0010" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RIOR0010" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SL4"
Private cPerg := "U_RIOR0010"       

Private dDataDe
Private dDataAte
Private cFilDe
Private cFilAte
Private lAgpFil
//Private cExcluiCxs:= u_StrQryIn(SuperGetMv('MS_CXFORAS',.F.,'COF,CTR,CX1' ),',')
Private cExcluiCxs := SuperGetMv('MS_CXFORAS',.F.,'COF,CTR,CX1')
dbSelectArea("SL4")
dbSetOrder(1)

ValidPerg()

If !(Pergunte(cPerg,.T.))
	Return
EndIf 

dDataDe	 := MV_PAR01
dDataAte := MV_PAR02
cFilDe	 := MV_PAR03
cFilAte	 := MV_PAR04
lAgpFil	 := IIf(MV_PAR05 == 1, .T., .F.)

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
RptStatus({|| RunReport() },Titulo)
Return

Static Function RunReport()		

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se agrupa por Filial. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAgpFil 
   	cFilAteDe := cFilAte 
   	dDataDeDe := dDataDe

	  	While cFilDe <= cFilAteDe
			AddLinha(@nLin)
			
			@nLin,00 PSAY 'FILIAL DO MOVIMENTO: ' + cFilDe + ' - ' + FWFilialName(cEmpAnt, cFilDe, 2) 
			AddLinha(@nLin)
			
			@nLin,02 PSAY __PrtThinline()
			AddLinha(@nLin)
		
   		cFilAte := cFilDe
   		AgpData() 
  	
   		cFilDe := Soma1(cFilDe)            
 		  	dDataDe := dDataDeDe
 		EndDo 
 		
 		cFilAte := cFilAteDe
   Else
		AgpData()
 	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
             

Static Function AgpData
  Local nPos   := 0
  Local nVlDeb := 0
  Local nVlChq := 0
  Local nVLDin := 0
  Local nVlCre := 0

	Local aVendas 	:= {}
	Local aPgtos 	:= {}
	Local aPgDebito := Debito()
	
	While dDataDe <= dDataAte
	
		aVendas := Vendas()
	//	aPgtos 	:= Pagamentos()

		AddLinha(@nLin)
      
		@nLin,00 PSAY 'DATA DO MOVIMENTO: ' + DtoC(dDataDe)
		AddLinha(@nLin)
		
		@nLin,02 PSAY __PrtThinline()
		AddLinha(@nLin)
	
		@nLin,02 PSAY " TIPO              BRUTO                ESTORNOS                  LIQUIDO"  
		AddLinha(@nLin)
	
		@nLin,02 PSAY __PrtThinline()
		AddLinha(@nLin)
	
		@nLin,02 PSAY " VENDAS" + Space(3) + Transform(aVendas[1] + aVendas[2], "@e 999,999,999.99") + Space(10) + Transform(aVendas[2], "@e 999,999,999.99") +Space(11) + Transform(aVendas[1] , "@e 999,999,999.99")	
		AddLinha(@nLin)
	
        nVlDeb := 0
        nVlChq := 0
        nVLDin := 0
		nVlCre := 0
	    nPos   := aScan(aPgDebito, {|x| x[1] == DtoC(dDataDe)})

	    If nPos > 0
	       nVlDin := aPgDebito[nPos][02]
	       nVlChq := aPgDebito[nPos][03]
	       nVlDeb := aPgDebito[nPos][04]
	       nVlCre := aPgDebito[nPos][05]
	    EndIf
		
//		@nLin,02 PSAY " PGTOS(R$)" + Transform(aPgtos[1] + aPgtos[2], "@e 999,999,999.99") + Space(10) + Transform(aPgtos[2], "@e 999,999,999.99") + Space(11) + Transform(aPgtos[1], "@e 999,999,999.99")    
		@nLin,02 PSAY " PGTOS(R$)" + Transform(nVlDin, "@e 999,999,999.99") + Space(10) + Transform(0, "@e 999,999,999.99")  + Space(11) + Transform(nVlDin, "@e 999,999,999.99")      
		AddLinha(@nLin)
	
//		@nLin,02 PSAY " PGTOS(CH)" + Transform(aPgtos[3] + aPgtos[4], "@e 999,999,999.99") + Space(10) + Transform(aPgtos[4], "@e 999,999,999.99")  + Space(11) + Transform(aPgtos[3], "@e 999,999,999.99")      
		@nLin,02 PSAY " PGTOS(CH)" + Transform(nVlChq, "@e 999,999,999.99") + Space(10) + Transform(0, "@e 999,999,999.99")  + Space(11) + Transform(nVlChq, "@e 999,999,999.99")      
		AddLinha(@nLin)
		    
		@nLin,02 PSAY " PGTOS(CD)" + Transform(nVlDeb, "@e 999,999,999.99") + Space(10) + Transform(0, "@e 999,999,999.99")  + Space(11) + Transform(nVlDeb, "@e 999,999,999.99")      
		AddLinha(@nLin)
	
		@nLin,02 PSAY " PGTOS(CC)" + Transform(nVlCre, "@e 999,999,999.99") + Space(10) + Transform(0, "@e 999,999,999.99")  + Space(11) + Transform(nVlCre, "@e 999,999,999.99")      
		AddLinha(@nLin)

		@nLin,00 PSAY Replicate("-",limite)
		AddLinha(@nLin)
	
		@nLin,02 PSAY "TOTAL VENDAS: " + Space(45) + Transform(aVendas[1], "@e 999,999,999.99")	
		AddLinha(@nLin)
	
//		@nLin,02 PSAY "TOTAL PGTOS:  " + Space(45) + Transform(aPgtos[1] + aPgtos[3] + nVlDeb, "@e 999,999,999.99")	
		@nLin,02 PSAY "TOTAL PGTOS:  " + Space(45) + Transform(nVlDin + nVlChq + nVlDeb + nVlCre, "@e 999,999,999.99")	

		AddLinha(@nLin)
		@nLin,02 PSAY __PrtThinline()  

		AddLinha(@nLin)

		dDataDe += 1
	
	EndDo	

Return  

Static Function Vendas()
	Local cQuery
	Local nPosOpe       
	Local nTotalVen := 0
	Local nTotalEst := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLISTA AS FORMAS DE PGTOS AGRUPADAS POR CAIXA E FORMAณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	cQuery	:=	" SELECT SUM(L4_VALOR) AS TOTALVEN, SL1.L1_SITUA "
	cQuery	+= " FROM " + RetSqlName('SL4') + " SL4 "
	cQuery	+= " INNER JOIN " + RetSqlName('SL1') + " SL1 ON L1_FILIAL = L4_FILIAL AND  L1_NUM = L4_NUM "
	cQuery	+= " AND L1_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataDe) + "' "	
	cQuery	+= " AND SL4.D_E_L_E_T_ <> '*' AND SL1.D_E_L_E_T_ <> '*' "
//	cQuery	+= " AND L4_DOC <> ' ' "
//	cQuery 	+= " AND L1_DOC <> ' ' AND L1_SERIE <> ' ' AND L1_SITUA = 'OK' AND L1_STORC <> 'C' "
	cQuery	+= " AND L1_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' "
	cQuery  += " AND L1_OPERADO not in (" + cExcluiCxs + ")"
//	cQuery	+= " AND L4_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' "
	cQuery	+= " AND L4_FILIAL = L1_FILIAL "
	cQuery  += " AND L4_NUM    = L1_NUM"
	cQuery	+= " AND L4_FORMA IN ('R1','R2','R3') " 
	cQuery	+= " GROUP BY SL1.L1_SITUA "
	
	If Select("QRYVEN") > 0
		QRYVEN->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias 'QRYVEN'

	MEMOWRIT("C:\QUERYVEN.txt",cQuery)
	
	While QRYVEN->(!Eof())
		If  QRYVEN->L1_SITUA == "OK"
			nTotalVen := QRYVEN->TOTALVEN
		Else
			nTotalEst += QRYVEN->TOTALVEN
		Endif
		QRYVEN->(DbSkip())
	EndDo

Return {nTotalVen, nTotalEst}

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณPagamentosบ Autor ณSIDNEY SALES        บ Data ณ  21/10/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณMonta o array com o valor todas os pgtos de fatura/acordo.  บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*Static Function Pagamentos()
   Local cQuery
   Local nPos   
	Local nTotPgDin 	:= 0	
	Local nTotEstDin	:= 0    
	Local	nTotPgCH		:= 0
	Local	nTotEstCH	:= 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ	
	//ณLISTA PAGAMENTOS DE FATURA(RECEBIMENTOS)ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	             
	cQuery	:= " SELECT SUM(E5_VALOR) AS TOTAL, E5_SITUACA "
	cQuery	+= " FROM " + RetSqlName('SE5') + " SE5 "
	cQuery	+= " WHERE SE5.D_E_L_E_T_ <> '*' "
	cQuery	+= " AND E5_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' " 
	cQuery	+= " AND E5_DATA BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataDe) + "' "	
	cQuery	+= " AND E5_TIPO NOT IN ('CH','R$','CC','NCC','CR') "
	cQuery	+= " AND E5_TIPODOC NOT IN ('TR') "
	cQuery	+= " AND E5_RECPAG = 'R' "
	cQuery	+= " AND E5_BANCO NOT IN (" + cExcluiCxs + ")" 
//	cQuery	+= " AND E5_BANCO BETWEEN 'C02' AND 'ZZZ' "
	cQuery	+= " GROUP BY E5_SITUACA "

	cQuery	+= " ORDER BY E5_SITUACA "

	If Select("QRYPAG") > 0 
		QRYPAG->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "QRYPAG"	

	MEMOWRIT("C:\QUERYPG1.txt",cQuery)

	While QRYPAG->(!Eof())		
		If Empty(QRYPAG->E5_SITUACA)
			nTotPgDin += QRYPAG->TOTAL
		Else
			nTotEstDin += QRYPAG->TOTAL
		EndIf
		QRYPAG->(DbSkip())
	EndDo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz novamente a consulta de recebimentoas para listar apenas ณ
	//ณos pagamentos de fatura realizados em cheque.                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	cQuery	:= "Select Sum(EF_VALOR) as TOTALCH, SEF.D_E_L_E_T_ as DELETADO"
	cQuery	+= "  From " + RetSqlName('SEF') + " SEF "
	cQuery	+= "   Inner Join " + RetSqlName("SE1") + " SE1"
	cQuery	+= "           On SEF.EF_FILIAL  = SE1.E1_FILIAL"
	cQuery  += "          and SEF.EF_PREFIXO = SE1.E1_PREFIXO"
	cQuery 	+= "          and SEF.EF_TITULO  = SE1.E1_NUM"
	cQuery  += "          and SEF.EF_PARCELA = SE1.E1_PARCELA"
	cQuery  += "          and SEF.EF_TIPO    = SE1.E1_TIPO"
//	cQuery	+= "  WHERE EF_ORIGEM = 'RIOA0001' "
	cQuery	+= "  Where SEF.D_E_L_E_T_ = ' '"
	cQuery	+= "    and SEF.EF_FILIAL between '" + cFilDe + "' and '" + cFilAte + "'" 
	cQuery	+= "    and SEF.EF_DATA Between '" + DtoS(dDataDe) + "' and '" + DtoS(dDataDe) + "'"	
    cQuery	+= "  Group By SEF.D_E_L_E_T_"

	If Select('QRYPAG') > 0
		QRYPAG->(DbCloseArea())		
	Endif

	MEMOWRIT("C:\QUERYPG2.txt",cQuery)

	TcQuery cQuery New Alias 'QRYPAG'
	
	While QRYPAG->(!Eof())
		If Empty(QRYPAG->DELETADO)
			nTotPgCH  := QRYPAG->TOTALCH
		Else
			nTotEstCH := QRYPAG->TOTALCH
		EndIf
		QRYPAG->(DbSkip())
	EndDo

Return {nTotPgDin, nTotEstDin, nTotPgCh, nTotEstCH}
*/
/*=================================================
--  Fun็ใo: Pegar todas dos pagamento de cartใo  --
--          d้bito em conta.                     --
===================================================*/
Static Function Debito()
  Local cQuery
  Local aDados  := {}
  Local cFilSZ4 := ""
  Local cPDVSZ4 := ""
  Local cSEQSZ4 := ""
  Local cDatSZ4 := ""
  Local nPos    := 0
  
  cQuery := "Select Z4_FILIAL, Z4_DATA, Z4_PDV, Z4_SEQ, Z4_DINHEIR, Z4_CHEQUE, Z4_DEBITO, Z4_CREDITO"
  cQuery += "  from " + RetSqlName("SZ4") 
  cQuery += "    where D_E_L_E_T_ = ' '"
  cQuery += "     and Z4_FILIAL between '" + cFilDe + "' and '" + cFilAte + "'"
  cQuery += "     and Z4_DATA between '" + DtoS(dDataDe) + "' and '" + DtoS(dDataAte) + "'"	
  cQuery += "    Order by Z4_DATA, Z4_FILIAL, Z4_PDV, Z4_SEQ"

  If Select("QRYFAT") > 0
	 QRYFAT->(DbCloseArea())
  EndIf
	
  TcQuery cQuery New Alias 'QRYFAT'

  MemoWrit("C:\QUERYFAT.txt",cQuery)

  While ! QRYFAT->(Eof())
    If cFilSZ4 <> QRYFAT->Z4_FILIAL .or. cPDVSZ4 <> QRYFAT->Z4_PDV .or.;
       cSEQSZ4 <> QRYFAT->Z4_SEQ .or. cDatSZ4 <> QRYFAT->Z4_DATA
       cFilSZ4 := QRYFAT->Z4_FILIAL
       cPDVSZ4 := QRYFAT->Z4_PDV
       cSEQSZ4 := QRYFAT->Z4_SEQ
       cDatSZ4 := QRYFAT->Z4_DATA
       
       nPos := aScan(aDados, {|x| x[1] == DToC(SToD(QRYFAT->Z4_DATA))})
       
       If nPos > 0
          aDados[nPos][02] += QRYFAT->Z4_DINHEIR
          aDados[nPos][03] += QRYFAT->Z4_CHEQUE
          aDados[nPos][04] += QRYFAT->Z4_DEBITO
          aDados[nPos][05] += QRYFAT->Z4_CREDITO
        else          
          aAdd(aDados, {DToC(SToD(QRYFAT->Z4_DATA)),;
    	                QRYFAT->Z4_DINHEIR,;
    	                QRYFAT->Z4_CHEQUE,;
    	                QRYFAT->Z4_DEBITO,;
						QRYFAT->Z4_CREDITO})
       EndIf
    EndIf
        
	QRYFAT->(dbSkip())
  EndDo

Return aDados


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณAddLinha  บAutor  ณSIDNEY SALES        บ Data ณ  12/04/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao criada para adicionar linha no relatorio e imprimir  บฑฑ
//ฑฑบ          ณo cabec do relatorio se necessario.                         บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function AddLinha(nLin)

	If nLin > 55
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 8
	Else
		nLin += 1
	Endif

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

	// Campos: 	 01     02    03                   04  05  06        07   08 09  10  11   12  			13          14   			15  16  17  18  19   			20  21  22  23  24   				25  26  27  28  29  				30  31  32  33  34  	 			35  36  37  38   	  39
	aAdd(aRegs, {cPerg, "01", "Data de?  "		, "", "", "mv_ch1", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par01", "",  			"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "02", "Data ate? "		, "", "", "mv_ch2", "D", 8, 0, 00, "G", "NAOVAZIO()", "mv_par02", "",  			"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "03", "Filial de?  "	, "", "", "mv_ch3", "C", 4, 0, 00, "G", ""		    , "mv_par03", "",  			"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "04", "Filial ate? "	, "", "", "mv_ch4", "C", 4, 0, 00, "G", ""		    , "mv_par04", "",  			"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "05", "Agrupa Filial? "	, "", "", "mv_ch5", "C", 1, 0, 00, "C", ""		    , "mv_par05", "Sim",  		"", "", "", "", "Nใo",  		"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})

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
