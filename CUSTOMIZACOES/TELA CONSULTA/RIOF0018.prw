#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE MAXSAVERESULT 99999

//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????ͻ??
//???Programa  ? RIOF0018 ? Autor ? GLAUDSON       ? Data ?  10/12/2020     ???
//?????????????????????????????????????????????????????????????????????????͹??
//???Descricao ? Funcao que monta tela customizada que simula consulta pa-  ???
//???          ?drao em uma tabela.                                         ???
//???          ?                             				                ???
//???          ? Deve ser criada consulta padrao do tipo "Especifica", onde ???
//???          ?no campo "Expressao" deve ser colocado ExecBlock("MARF009") ???
//???          ?                             						        ???
//???          ? Baseada na rotina MARF009*   						        ???
//???          ?                             						        ???
//?????????????????????????????????????????????????????????????????????????ͼ??
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????

//  C:\smartclient\SmartClient.exe -m -e=riocenter -p=u_riof0017 -c=tcp
user function RIOF0018(cAlias_, cFiltro_, aColunas)
local oFont			:= tFont():New("Arial",,40,.T.)
local oFontGrid  	:= tFont():New("Arial",,30,.T.)
local lRet 			:= .F.
local aArea			:= GetArea()
local nRecNo		:= 0
local aCombo		:= {}
local cColsnFiltro:= ""
local oBusca, oCombo, nLBtn
local oAlias
local aLarCols := {}
local aLarCols2 := {}

default aColunas	:= {}
default cAlias_	:= "SB1"
default cFiltro_	:= ""

private cBusca		:= Space(50)
private cAlias 	:= cAlias_
private oFnt		:= tFont():New("Arial",,20,.T.)
private cDescPro	:= Space(200)
private _oDlg, oBrw, cBuscaTmp, nCombo, cFiliais 
private aCombo

Static cFiltro  

if Empty(ProcName(1)) 
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0102" MODULO 'LOJA'
	SA1->(dbGoTo(2))
endif

//oAlias		:= TCtrlAlias():GetAlias({'SA1'})

cFiltro	 := cFiltro_
cFiliais := SuperGetMv("MS_FILIAIS",.F.,"0101,0102,0103")

//Define colunas que ir?o aparecer no broswer
aColunas := {{"Produto", "B1_COD", ,.F.}, {"Descri??o", "B1_DESC", ,.T.},{"Cole??o", {|| u_RIOF017a()} , ,.F.}, {"Pre?o", {|| u_RIOF016Z()} , ,.F.}}
aLarCols := {80, 650, 70, 50}
cColsnFiltro += '1,2,3,4'

//Pega os indices do alias para ordenacao
aCombo := MARF009b()

// Ordena a tabela no indice 1
dbSelectArea(cAlias)
set filter to &(cFiltro)
dbSetOrder(1)
dbGoTop()

//DEFINE MSDIALOG _oDlg TITLE "Consulta" FROM 334,319 TO 850,850+200 PIXEL
//DEFINE MSDIALOG _oDlg TITLE "Consulta" FROM 10,10 TO 700,1350 PIXEL
DEFINE MSDIALOG _oDlg TITLE "Consulta" FROM 1,1 TO 1000,1800 PIXEL

@ 001, 001 MSPANEL oPanel1 PROMPT "" size (001),(015) OF _oDlg
@ 015, 001 MsGet oBusca Var cBusca Size 1,030 COLOR CLR_BLACK font oFont PIXEL OF _oDlg on Change (msAguarde({||u_FilGdBrw(@oBrw, cBusca, cFiltro, cColsnFiltro), "Buscando produtos..." }))

// Monta o browse de Produtos 
//oBrw 	:= u_TwBrowse(cAlias, @_oDlg, aColunas, 001, 001, 001, 045,)
oBrw 	:= u_TwBrows2(cAlias, @_oDlg, aColunas, 1, 1, 200, 300,, oFontGrid, aLarCols)

oBrw:alHeader := {"B1_COD", "B1_DESC","B1_CODBAR" }

nLBtn := (_oDlg:nClientWidth/2) - 040

@ 002, nLBtn Button "&Pesquisar" Size 037,011 PIXEL OF _oDlg Action msAguarde({||u_FilGdBrw(@oBrw, cBusca, cFiltro, cColsnFiltro), "Buscando produtos..." })

@ 001, 001 MSCOMBOBOX oCombo VAR nCombo ITEMS aCombo SIZE 1, 010 OF _oDlg COLORS 0, 16777215 PIXEL VALID(MARF009c(oCombo:nAt))

oDescPro := tMultiget():create( _oDlg, {|u| if( pCount() > 0, cDescPro := u, cDescPro ) }, 001, 001, 001, 030, oFont, , , , , .T. )
                                                              
// Monta o browse de estoque
aColEst :=  {{"Filial","B2_FILIAL",10},{"Almox.","B2_LOCAL",10}, {"Descri??o", {|| Padr(getFilDesc(), 80, " ")}}, {"Saldo em estoque",{|| getCalcEst()}}}
aLarCols2 := {40, 40, 650, 120}
oBrwEst := u_BrGetdb2("SB2", @_oDlg, aColEst, , , , , , oFontGrid, aLarCols2)

// Define alinhamento dos objetos
oBusca:Align		:= CONTROL_ALIGN_TOP
oCombo:Align		:= CONTROL_ALIGN_TOP
oBrw:Align			:= CONTROL_ALIGN_TOP
oDescPro:Align		:= CONTROL_ALIGN_TOP
oBrwEst:Align		:= CONTROL_ALIGN_ALLCLIENT
oPanel1:Align		:= CONTROL_ALIGN_BOTTOM
//oBrw:bLDblClick	:= {|| lRet := .T., _oDlg:End() }
oBrw:bChange		:= {|| FiltraEst(), cDescPro := SB1->B1_DESC, oDescPro:refresh() }

dbGoTop()

//@ 002,005 Button "&Fotos" Size 037,012 PIXEL OF oPanel1 Action (T_SYfotoproduto("10100001", "11005"))
@ 002,nLBtn -40 Button "Ok" Size 037,012 PIXEL OF oPanel1 Action (lRet := .T.,_oDlg:End())
@ 002,nLBtn Button "Cancelar" Size 037,012 PIXEL OF oPanel1 Action (_oDlg:End())

ACTIVATE MSDIALOG _oDlg CENTERED

nRecNo := (cAlias)->(RecNo())

SB1->(dbClearFilter())
SB2->(dbClearFilter())

(cAlias)->(DbGoTo(nRecNo))

RestArea(aArea)
//oAlias:RestAlias()

return lRet


//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????ͻ??
//???Programa  ?MARF009b  ? Autor ? Guilherme Maia     ? Data ?  04/09/12   ???
//?????????????????????????????????????????????????????????????????????????͹??
//???Descricao ? Funcao funcao que retorna um array com os indices da tabela???
//???          ?                                                            ???
//?????????????????????????????????????????????????????????????????????????ͼ??
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????
Static Function MARF009b()
local aIndices := {}

SIX->(DbSeek(cAlias))

While !SIX->(EOF()) .And. cAlias == SIX->INDICE
	aAdd(aIndices, SIX->DESCRICAO)
	SIX->(DbSkip())
EndDo

Return aIndices



//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????ͻ??
//???Programa  ?MARF009c  ? Autor ? Guilherme Maia     ? Data ?  04/09/12   ???
//?????????????????????????????????????????????????????????????????????????͹??
//???Descricao ? Funcao que e' chamada apos mudanca do botao de indice, reor???
//???          ?denando a exibicao do browse (lstbox1).                     ???
//???          ?                                                            ???
//?????????????????????????????????????????????????????????????????????????ͼ??
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????
Static Function MARF009c(nIndice)

DbSetOrder(nIndice)

oBrw:Refresh()

Return .T.


// -- Retorna a descri??o da filial
static function getFilDesc()
local aArea	:= SM0->(getArea())
local cDesc := ""

if SM0->(dbSeek(cEmpAnt + SB2->B2_FILIAL))
	cDesc := allTrim(SM0->M0_FILIAL)
endif

SM0->(restArea(aArea))

return cDesc


// -- Retorna o saldo em estoque do produto setado
static function getCalcEst()
local nSaldo := 0
local cFilTmp:= cFilAnt

cFilAnt 	:= SB2->B2_FILIAL
nSaldo	:= SaldoSB2() 
cFilant	:= cFilTmp

return nSaldo


// -- Filtra estoque do sb2
static function FiltraEst(lNotAtu)
local cFiltro 
default lNotAtu := .F.

dbSelectArea("SB2")
cFiltro := "B2_FILIAL IN (" + cFiliais + ") AND B2_COD = '" + SB1->B1_COD + "'"
set filter to &("@" +cFiltro)
dbSelectArea("SB1")

if !lNotAtu
	oBrwEst:goTop()
	oBrwEst:refresh()
endif 

return


/*

//  UTILIZADAS AS USER FUNCTIONS DO FONTE TWBROWSE ORIGINAL 


//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????ͻ??
//???Programa  ?RIOF016Z  ? Autor ? Sidney Sales       ? Data ?  12/08/13   ???
//?????????????????????????????????????????????????????????????????????????͹??
//???Descricao ? Funcao que retorna o preco do produto.                     ???
//?????????????????????????????????????????????????????????????????????????ͼ??
//?????????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????????
User Function RIOF016Z(cCodProduto)
  Local cQuery := ""
  
	local nPreco			:= 0
	local aAreaSB1			:= SB1->(GetArea())

	default cCodProduto	:= SB1->B1_COD

	SB1->(dbSetOrder(1)) // filial cod

	if ! SB1->(dbSeek(xFilial('SB1')+cCodProduto))
		return nPreco
	endif

	//?????????????????????????????????????????????????????????????H?
	//?Verifica se esta utilizando o cenario de vendas, caso esteja?
	//?pega da tabela definida no par/ametro de tabela padrao       ?
	//?????????????????????????????????????????????????????????????H?
	If GetMV('MV_LJCNVDA')
	   cQuery := "Select b.DA1_PRCVEN, b.DA1_CODTAB"
	   cQuery += "  from " + RetSqlName("DA1") + " b, " + RetSqlName("DA0") + " a"
       cQuery += "   where b.D_E_L_E_T_ = ' '"
       cQuery += "     and b.DA1_CODPRO = '" + Alltrim(cCodProduto) + "'"
       cQuery += "     and b.DA1_DATVIG <= '" + DToS(dDataBase) + "'"
       cQuery += "     and a.D_E_L_E_T_ = ' '"
       cQuery += "     and a.DA0_CODTAB = b.DA1_CODTAB"
       cQuery += "     and a.DA0_DATDE <= '" + DToS(dDataBase) + "'"
       cQuery += "     and (a.DA0_DATATE >= '" + DToS(dDataBase) + "' or a.DA0_DATATE = ' ')"
       cQuery += "     and a.DA0_ATIVO = '1'"
       cQuery += "  Order by b.DA1_PRCVEN"
       cQuery := ChangeQuery(cQuery)
	   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPRC",.T.,.F.)  
 
       If ! TMPRC->(Eof())
		  nPreco := Transform(TMPRC->DA1_PRCVEN,"@E 999,999.99")
       EndIf
       
       TMPRC->(dbCloseArea())
	Else
		SB0->(DbSetOrder(1))
		SB0->(DbSeek(xFilial('SB0') + SB1->B1_COD))
		nPreco	 := SB0->B0_PRV1		
	Endif			

	RestArea(aAreaSB1)

return nPreco

User Function RIOF017a
	Local cRet := ''

	SB4->(DbSetOrder(1))
	SB4->(DbSeek(xFilial('SB4') + SB1->B1_01PRODP))
		
	AYH->(DbSetOrder(1))

	If AYH->(DbSeek(xFilial('AYH') + SB4->B4_01COLEC))
		cRet := AYH->AYH_YABREV
	EndIf

Return cRet

User Function RIOF17b
//	Local cRet := AllTrim(SB1->B1_DESC)
	Local cRet := Space(80)
	Local nId := 0
	Local Eu := ""
 Local cQuery := "Select B1_DESC as TESTE from " + RetSqlName("SB1") + " where D_E_L_E_T_ = ' ' and B1_COD = '" + SB1->B1_COD + "'"
 	  cQuery := ChangeQuery(cQuery)
  dbUseArea(.T.,"TopConn",TCGenQry(,,cQuery),"QSB1",.F.,.T.)
 	
	If AllTrim(SB1->B1_COD) == '80320020001012'
	   Alert(QSB1->TESTE)
	   Alert(Len(QSB1->TESTE))
	   For nId := 1 To Len(QSB1->TESTE)
Alert(Substr(QSB1->TESTE,nId,1))
Alert(nId)	   
	   Eu += Substr(QSB1->TESTE,nId,1)
	   Next
	   MsgInfo(Eu)
	   cRet := Eu
  else
	cRet := "TESTE"
EndIf
QSB1->(dbCloseArea())

Return cRet
*/
