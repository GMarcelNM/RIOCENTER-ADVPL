#include "protheus.ch"
#include "tbiconn.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณModeloAba บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao da lib que serve para montar uma tela, mestre detalheบฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function ModeloAba(nOpc, cFunVars, aFieldsCopia, lAuto, aDados)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEste aPrivates eh utilizado para inicializar as variaveis private antes ณ
	//ณda primeira chamada do modelo aba                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local	aPrivates	:= {{"aTela"	 		," Array(0, 0)"	 			},;
								 {"aGets"     		,"	Array(0)"					},;
								 {"aFilhas"	 		,"	{}"							},;
								 {"aOrdem"	 		," {}"							},;
								 {"_aSeek"	 		," {}"							},;
								 {"aPK"		 		," {}"							},;
								 {"aWhile"	 		," {}"							},;
								 {"aNomes"	 		," {}"							},;
								 {"_aChaveOrd"		,"	{}"							},;
								 {"_aChave"			,"	{}"							},;
								 {"aIniPos"			,"	{}"							},;
								 {"cCabec"			," ''"							},;
								 {"aOrdItem"		," {}"							},;
								 {"_aChave"			,"	{}"							},;
								 {"aPe"	  			," {}"							},;
								 {"cTitulo"			," ''"							},;								 
								 {"cRepCabec"		," ''"							},;								 
								 {"aRepFilhas"		," {}"							},;
								 {"aTFolder"  		," {}"							},;								 
								 {"aFiltro"	  		," {}"							},;								 
 								 {"nAux"		  		," 1"								},;
 								 {"cArquivo"  		,"nil"							},; 								 
 								 {"nAbaAtu"	  		," 1"								},;
 								 {"aButtons"  		," {}"							},;
 								 {"aReadOnly"		," {}"							},; 								 
 								 {"lAutoDel"		," .F."							},;
 								 {'nRecNoCabec'	,"''"								}}

	local cPrivates	:= ''
	local i
	local nI, nX, nT
	local nFreeze, aAlter, aAddAction
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicializei as variaveis assim porque nao consegui inicializa-lasณ
	//ณcom funcoes automaticas, depois olho melhor                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณOu seja,  o modelo aba so serve para ate 20 abasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	local aHeader01		:= {} ;local aHeader02	:= {} ;local aHeader03	:= {} ;local aHeader04	:= {} ;local aHeader05	:= {} ;local aHeader06	:= {} ;local aHeader07	:= {} ;local aHeader08	:= {} ;local aHeader09	:= {} ;local aHeader10 	:= {}
	local aHeader11		:= {} ;local aHeader12	:= {} ;local aHeader13	:= {} ;local aHeader14	:= {} ;local aHeader15	:= {} ;local aHeader16	:= {} ;local aHeader17	:= {} ;local aHeader18	:= {} ;local aHeader19	:= {} ;local aHeader20 	:= {}
	local aCols01			:= {} ;local aCols02		:= {} ;local aCols03		:= {} ;local aCols04		:= {} ;local aCols05		:= {} ;local aCols06		:= {} ;local aCols07		:= {} ;local aCols08		:= {} ;local aCols09		:= {} ;local aCols10 	:= {}
	local aCols11			:= {} ;local aCols12		:= {} ;local aCols13		:= {} ;local aCols14		:= {} ;local aCols15		:= {} ;local aCols16		:= {} ;local aCols17		:= {} ;local aCols18		:= {} ;local aCols19		:= {} ;local aCols20 	:= {}
	local oGet02		:= {} ;local oGet03		:= {} ;local oGet04		:= {} ;local oGet05		:= {} ;local oGet06		:= {} ;local oGet07		:= {} ;local oGet08		:= {} ;local oGet09		:= {} ;local oGet10 		:= {}
	local oGet11			:= {} ;local oGet12		:= {} ;local oGet13		:= {} ;local oGet14		:= {} ;local oGet15		:= {} ;local oGet16		:= {} ;local oGet17		:= {} ;local oGet18		:= {} ;local oGet19		:= {} ;local oGet20 		:= {}
	local aNoFields		:= nil
	local aYesFields		:= nil
	local lOnlyYes			:= nil
	local lUserFields		:= nil
	local aYesUsado		:= nil 
	local aAcho				:= nil
	local aField			:= nil
	local aFolder			:= nil
    Local nMaxLinhas 		:= 9999
    local cFiltroQuery	:= ''
    local z
   
    Private oSXS         := CLASSXS():New()       // Defini็ใo da Classe - Tabelas SX
    Private aCpoEnchoice := {}
	Private nId          := 0

    Private oGet01			:= {} 
	Private aColsAux01	:= {} ;Private aColsAux02	:= {} ;Private aColsAux03	:= {} ;Private aColsAux04	:= {} ;Private aColsAux05	:= {} ;Private aColsAux06	:= {} ;Private aColsAux07	:= {} ;Private aColsAux08	:= {} ;Private aColsAux09	:= {} ;Private aColsAux10	:= {}	
	Private aColsAux11	:= {} ;Private aColsAux12	:= {} ;Private aColsAux13	:= {} ;Private aColsAux14	:= {} ;Private aColsAux15	:= {} ;Private aColsAux16	:= {} ;Private aColsAux17	:= {} ;Private aColsAux18	:= {} ;Private aColsAux19	:= {} ;Private aColsAux20	:= {}	
	Private aLimpo01		:= {} ;Private aLimpo02	:= {} ;Private aLimpo03	:= {} ;Private aLimpo04	:= {} ;Private aLimpo05	:= {} ;Private aLimpo06	:= {} ;Private aLimpo07	:= {} ;Private aLimpo08	:= {} ;Private aLimpo09	:= {} ;Private aLimpo10	:= {}
	Private aLimpo11		:= {} ;Private aLimpo12	:= {} ;Private aLimpo13	:= {} ;Private aLimpo14	:= {} ;Private aLimpo15	:= {} ;Private aLimpo16	:= {} ;Private aLimpo17	:= {} ;Private aLimpo18	:= {} ;Private aLimpo19	:= {} ;Private aLimpo20	:= {}
	Private lReplica		:= .F.
	aColsAux01				:= {} ;aColsAux02	:= {} ;aColsAux03	:= {} ;aColsAux04	:= {} ;aColsAux05	:= {} ;aColsAux06	:= {} ;aColsAux07	:= {} ;aColsAux08	:= {} ;aColsAux09	:= {} ;aColsAux10	:= {}	
	aColsAux11				:= {} ;aColsAux12	:= {} ;aColsAux13	:= {} ;aColsAux14	:= {} ;aColsAux15	:= {} ;aColsAux16	:= {} ;aColsAux17	:= {} ;aColsAux18	:= {} ;aColsAux19	:= {} ;aColsAux20	:= {}	
	SetPrvt('_cTabela,nPosFil,nPosFiltro,aAux,cDom,nPosDom,cGetDom,cHeaderDom,cColsDom,cCdom,nPosCdom,cGetCdom,cHeaderCdom,cColsCdom,cColsAux,n')
	Private cArquivo,nHdlPrv

   default lAuto	:= .F. 
	default aDados := {}
   
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณJoga variaveis privates numa string, esta string sera utilizada no SetPrvtณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if nOpc  == 0
		for i:= 1 to len(aPrivates)
			cPrivates	+= aPrivates[i][1] + ','
		next
		alert("Fonte 2021-03-29 09:31 - modeloaba")          
		return cPrivates
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe o modeloaba for chamado com o nOpc = 1, significa que eh para       ณ
	//ณiniciar as variaveis, entao retorna o array com as variaveis que devem ณ
	//ณser private fora do modeloaba (na funcao chamadora)                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if nOpc	== 1      
		return aPrivates
	endif 

	Default nOpc			:= 2								
	default aFieldsCopia	:= {}
	Private VISUAL			:= nOpc == 2	
	Private INCLUI			:= nOpc == 3
	Private ALTERA			:= nOpc == 4
	Private DELETA			:= nOpc == 5
	Private EXCLUI			:= nOpc == 5	
    Private nOpc			:= nOpc

    if Type('aCabecAuto') <> 'U' .AND. INCLUI
       lAuto	:= .T.
    endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicializa as variaveis, estas variaveis indicarao quais tabelas ณ
	//ณserao demonstradas                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEh rodada a funcao de inicializacao das variaveis do modeloaba,    ณ
	//ณeh necessario esta 'reinicializacao' a cada chamada do modeloaba   ณ
	//ณpois havia casos em que abriamos um modelo aba e depois abriamos   ณ
	//ณum novo mbrowse, este por sua vez com outro modelo aba, dai        ณ
	//ณquando voltavamos para o primeiro as variaveis haviam sido perdidasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if Upper(Left(cFunVars,2)) == 'U_'
		cFunVars	:= SubStr(cFunVars, 3, len(cFunction) - 2)
	endif
	if ExistBlock(cFunVars)
		aPrivates	:= u_modeloaba(1)
		for i:= 1 to len(aPrivates)
			&(aPrivates[i][1])	:= &(aPrivates[i][2])
		next
		ExecBlock(cFunVars,.F.,.F.)
	else 
		MsgInfo("Fun็ใo de inicializa็ใo de variแveis nใo encontrada","Aviso")
	endif
   
	nRecNoCabec		:= (cCabec)->(RecNo())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณO nOpc = 9 significa que deve ser rodada a funcao de replica das    ณ
	//ณtabelas constantes no modeloaba, para a replica funcionar devem ser ณ
	//ณcorretamente configuradas as variaveis e criadas as tabelas de copiaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if nOpc == 9
		if ReplicaCampos()
			Return .T.
		else
			Return .F.
		endif
	endif                                  
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz validacoes simples nos arrays do modeloaba, validacoes de estrutura/preenchimento dos arrays ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if !VldArray()
		Return
	endif


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonto de entrada executado 'antes de tudo', serve como validacaoณ
	//ณde pre entrada, requer retorno logico                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if ExistPe('AntesDeTudo')
		lAntesDeTudo	:= ExecPe('AntesDeTudo', 'L')
		if !lAntesDeTudo
			Return .F.		
		endif
	endif
	lResult		:= .F.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณnOpc          ณ
	//ณ2 - Visualizarณ
	//ณ3 - Incluir   ณ
	//ณ4 - Alterar   ณ
	//ณ5 - Excluir   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณJa exisitia a chamada aqui porem nao era utilizada, entao coloquei no ณ
	//ณdialog para pegar do array, para ficar o tamanho completo da tela     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aSize := MsAdvSize()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria o dialogoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if !lAuto
		oDlg	:= MSDialog():New(aSize[1],aSize[1],aSize[6],aSize[5],cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.t.)
	
	//Necessแrio pois a dialog deve ser ativada (quando nใo, e ocorre vแrias chamadas do modeloAba, ocorre overflow)
	//Deixa o tamanho 1,1,1,1 para a tela nใo ficar visํvel ap๓s a ativa็ใo
	else
		oDlg	:= tDialog():New(1,1,1,1,'Gravando...',,,,,CLR_BLACK,CLR_WHITE,,,.t.)	
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria o Splitterณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSplitter := tSplitter():New( 30,30,oDlg,01,01,1)
	oSplitter:Align	:= CONTROL_ALIGN_ALLCLIENT


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonto de entrada executado 'antes de tudo', serve como validacaoณ
	//ณde pre entrada, requer retorno logico                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if ExistPe('TamanhoCabec')
		nTamCabec	:= ExecPe('TamanhoCabec', 'N')
	Else
		nTamCabec	:= 100
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonto de entrada executado 'antes de tudo', serve para mostrar  ณ
	//ณapenas os campos passado por parametro e nใo mais do SX3.       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if ExistPe('YesFieldsCabec')
		aField	:= ExecPe('YesFieldsCabec', 'A')
	endif

	lCreate	:= .F.
	if ExistPe('YesFolderCabec')
		aFolder	:= ExecPe('YesFolderCabec', 'A')
		lCreate	:= .T.
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria os dois Panelsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPanelCabec	:= tPanel():New(30,30,"",oSplitter,,,,,CLR_BLUE,100,nTamCabec) // cria o painel
	oPanelCabec:Align := CONTROL_ALIGN_TOP        

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤธ
	//ณCria a Enchoiceณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RegToMemory(cCabec,INCLUI)

	oEnchoice	:= Msmget():New(cCabec, (cCabec)->(RecNo()), nOpc,,,,aAcho			 ,{(20),(1),(120),(400)}	, aAcho, 3,,,,oPanelCabec,, .T., , , , ,aField,aFolder,)

	oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDa o foco no primeiro dos campos 'focaveis' do enchoiceณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	SX3->(dbSetOrder(2))
 
    oSXS:cEmpresa := cEmpAnt              // Montar a empresa
    oSXS:cSXS     := "SX3"                // Tabela da SXS

	for i:= 1 to len(aGets)                            
		cCampo	     := SubStr(aGets[i],9,10) 
        oSXS:cTabela := Substr(cCampo,1,3)   // Tabela que quer pegar a estrutura
        aCpoEnchoice := oSXS:Montar()

        For nId := 1 To Len(aCpoEnchoice)
            If AllTrim(aCpoEnchoice[nId][02]) == AllTrim(cCampo) .and.;
			   aCpoEnchoice[nId][15] == 'A' .and. X3USO(aCpoEnchoice[nId][07]) .and.;
			   aCpoEnchoice[nId][11] == 'R' .and. Empty(aCpoEnchoice[nId][12])
   			   If Type("oEnchoice:aEntryCtrls[i]:oGet") <> 'U'
				  oEnchoice:aEntryCtrls[i]:oGet:SetFocus()							
				  Exit
			   EndIf
			EndIf   
        Next

//		if SX3->(dbSeek(cCampo)) .and. SX3->X3_VISUAL == 'A' .AND. X3USO(SX3->X3_USADO) .AND. SX3->X3_CONTEXT == 'R' .AND. EMPTY(SX3->X3_CBOX)
//			If Type("oEnchoice:aEntryCtrls[i]:oGet") <> 'U'
//				oEnchoice:aEntryCtrls[i]:oGet:SetFocus()							
//				Exit
//			EndIf
//		endif
	next

 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria Foldersณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤู	
	aTFolder	:= {}
	for i:= 1 to len(aNomes)
		if !'&' $ aNomes[i]
			aNomes[i]	:= '&' + aNomes[i]
		endif
		aAdd(aTFolder,aNomes[i])
	next
	
	oTFolder := TFolder():New( 0,0,aTFolder,,/*oPanelItens*/oSplitter,,,,.T.,,260,184 )
	oTFolder:Align			:= CONTROL_ALIGN_ALLCLIENT

	oTFolder:bChange		:= {|| OnChangeAba() }


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria a  grid dentro dos foldersณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for i:= 1 to len(aFilhas)

		cLinOk	:= nil
		if ExistPe('LinOk'+StrZero(i,2))
			cLinOk	:= ExecPe('LinOk'+StrZero(i,2), 'C')
		endif

		if ExistPe('LinOk'+aFilhas[i])
			cLinOk	:= ExecPe('LinOk'+aFilhas[i], 'C')
		endif

		cDelOk	:= "iif(lAutoDel, .t., u_DelCDom())"
		if ExistPe('DelOk'+StrZero(i,2))
			cDelOk	+= iif(!Empty(cDelOk),' .AND. ','') + ExecPe('DelOk'+StrZero(i,2), 'C')
		endif	
		if ExistPe('DelOk'+aFilhas[i])
			cDelOk	+= iif(!Empty(cDelOk),' .AND. ','') + ExecPe('DelOk'+aFilhas[i], 'C')
		endif			                                                 
		
		cTudoOk	:= nil
		if ExistPe('TudoOk'+StrZero(i,2))
			cTudoOk	:= ExecPe('TudoOk'+StrZero(i,2), 'C')
		endif
		
		//ฺฤฤฤฤฤฤฤฤฤฟ
		//ณVariaveisณ
		//ภฤฤฤฤฤฤฤฤฤู
		cHeader			:= 'aHeader' 	+ StrZero(i,2)
		cCols				:= 'aCols' 		+ StrZero(i,2)
		cGetDados		:= 'oGet' 		+ StrZero(i,2)
		cLimpo			:= 'aLimpo'		+ StrZero(i,2)
		aHeader			:= {}
		aCols				:= {}
		nPosCampoIni	:= 0
		cSeekAux			:= &(_aSeek[i])
		aNoFields		:= nil
		aYesFields		:= nil
		cAliasCampo		:= iif(Left(aFilhas[i],1)=='S', Right(aFilhas[i],2), aFilhas[i])

 		if ExistPe('NoFields'+StrZero(i,2)) 
 			aNoFields	:= ExecPe('NoFields' +StrZero(i,2), 'A')
  		endif

 		if ExistPe('NoFields'+aFilhas[i]) 
 			aNoFields	:= ExecPe('NoFields' +  aFilhas[i], 'A')
  		endif

 		if ExistPe('YesFields'+StrZero(i,2)) 
 			aYesFields	:= ExecPe('YesFields'+StrZero(i,2), 'A')
  		endif  

 		if ExistPe('YesFields'+aFilhas[i]) 
 			aYesFields	:= ExecPe('YesFields'+  aFilhas[i], 'A')
  		endif    

 		if ExistPe('OnlyYes'+StrZero(i,2)) 
 			lOnlyYes		:= ExecPe('OnlyYes'  +StrZero(i,2), 'L')
  		endif  

 		if ExistPe('OnlyYes'+aFilhas[i]) 
 			lOnlyYes		:= ExecPe('OnlyYes'		+ aFilhas[i], 'L')
  		endif    

 		if ExistPe('UserFields'+StrZero(i,2)) 
 			lUserFields	:= ExecPe('UserFields'	+ StrZero(i,2), 'L')
  		endif

		if ExistPe('UserFields'+aFilhas[i]) 
 			lUserFields	:= ExecPe('UserFields'	+ aFilhas[i], 'L')
  		endif
  		
 		if ExistPe('YesUsado'+StrZero(i,2)) 
 			aYesFields	:= ExecPe('YesUsado'		+ StrZero(i,2), 'A')
  		endif  

 		if ExistPe('YesUsado'+aFilhas[i]) 
 			aYesFields	:= ExecPe('YesUsado'		+ aFilhas[i], 'A')
  		endif    

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPonto de entrada utilizado para preencher o aCols com os dadosณ
		//ณde uma query ao inves de utilizar os dados da tabela.         ณ
		//ณEsta query tem de ter os campos do alias, sem 'inners'.       ณ		
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  		cFiltroQuery	:= ''
 		if ExistPe('FiltroQuery'+StrZero(i,2))
 			cFiltroQuery:= ExecPe('FiltroQuery'+StrZero(i,2), 'C')
  		endif

 		if ExistPe('FiltroQuery'+aFilhas[i])
 			cFiltroQuery:= ExecPe('FiltroQuery'+aFilhas[i], 'C')
  		endif  		

   	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria o aHeader e o aCols ja com os dadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		FillGetDados(nOpc,aFilhas[i],aOrdem[i],cSeekAux,aWhile[i],/*{{bCond,bAction1,bAction2}}*/,aNoFields,aYesFields,lOnlyYes,cFiltroQuery,/*bMontCols*/,INCLUI,/*aHeaderAux*/,/*aColsAux*/,/*bafterCols*/,/*bBeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,iif(aReadOnly[i],{|| ''},nil), lUserFields, aYesUsado)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPonto de entrada chamado imediatamente apos o preenchimento do aHeader e aCols.ณ
		//ณServe para fazer quaisquer modificacoes no aHeader e no aCols                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if ExistPe('AfterFillGetDados'+StrZero(i,2)) 
			ExecPe('AfterFillGetDados'+StrZero(i,2), 'N')
		endif

		if ExistPe('AfterFillGetDados') 
			ExecPe('AfterFillGetDados', 'N')
		endif		
		aAuxAHeader	:= {}
 		if ExistPe('ChangeDescAHeader'+StrZero(i,2)) 
 			aAuxAHeader	:= ExecPe('ChangeDescAHeader'+StrZero(i,2), 'A')
 		endif

 		if ExistPe('ChangeDescAHeader'+aFilhas[i]) 
 			aAuxAHeader	:= ExecPe('ChangeDescAHeader'+aFilhas[i], 'A')
 		endif 		

 		if len(aAuxAHeader) > 0
 			for a:= 1 to len(aAuxAHeader)
 				nPosAux	:= aScan(aHeader, {|aX| AllTrim(Upper(aX[2])) == AllTrim(Upper(aAuxAHeader[a][2]))})
 				if nPosAux <> 0
 					aHeader[nPosAux][1]	:= aAuxAHeader[a][1]
 				endif
 			next
  		endif
  		
  		

		_cTabela	:= aFilhas[i]                     
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se a tabela eh contradominio de alguma outra tabelaณ
		//ณSe for, preenche inicializador padrao, normalmente eh o     ณ
		//ณcampo XX_SEQ, mas podem ser outros, este campo tera inicialiณ				
		//ณzador padrao o XX_SEQ da tabela dominio.                    ณ		
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*		nPosFil	:= aScan(aFiltro, {|aX| Upper(aX[2]) == Upper(_cTabela)})
		nPosIniPad	:= 9
		if nPosFil > 0
			aCamposFil	:= aClone(aFiltro[nPosFil][3])
			for y := 1 to len(aCamposFil)	
				cCampoDom	 := aCamposFil[y][1]
				nPosFilDom	 := aScan(aFilhas, {|aX| Upper(aX) == Upper(aFiltro[nPosFil][1])})
   			    cHeaderDom	 := 'aHeader' + StrZero(nPosFilDom,2)
				cGetDom		 := 'oGet'+StrZero(nPosFilDom,2)
				nPosCampoDom := GdFieldPos(cCampoDom, &(cHeaderDom))
				cCampoCdom	 := aCamposFil[y][2]
				cInicPad	 := "GDFieldGet('" + cCampoDom 	+ "'," 
				cInicPad	 += "" + cGetDom + ":nAt" + ",,"
				cInicPad	 += "" + cGetDom + ":aHeader" + ","
				cInicPad	 += "" + cGetDom + ":aCols)"
				SX3->(dbSetOrder(2))
				if SX3->(dbSeek(cCampoCdom))
					if aReadOnly[i] == .F.
						RecLock('SX3', .F.)
							SX3->X3_RELACAO	:= cInicPad//"u_InicPad(cInicPad)"
							SX3->X3_VISUAL	:= 'V'
						SX3->(msUnLock())
					endif
				endif
			next
		endif
*/
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe houver campo sequencial no get (tipo o campo 'sequencial' dos itensณ
		//ณdo venda assistida) entao inicializa este campo                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if Len(aIniPos) <> 0 .and. aIniPos[i] <> nil .and. !Empty(aIniPos[i])
			nPosCampoIni	:= GdFieldPos(Right(aIniPos[i],len(aIniPos[i])-1))
			if nPosCampoIni > 0 .and. Empty(aCols[1][nPosCampoIni]) .AND. !aReadOnly[i]
				aCols[1][nPosCampoIni]	:= StrZero(1,len(aCols[1][nPosCampoIni]))
			endif
		endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณClona o aHeader e o aCols que foi gerado pelo FillGetDados        ณ
		//ณDai teremos o aHeader01, 02... tem de clonar porque tem mais de umณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		&(cHeader)		:= aClone(aHeader)
		&(cCols)			:= aClone(aCols)
		n           	:= len(&(cCols))
		nOperacao 		:= Iif(INCLUI .Or. ALTERA, GD_INSERT+GD_UPDATE+GD_DELETE, 0)

		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe a filha for definida como read only, esta filha nao podera ser editadaณ
		//ณe nem sera gravada no OK da tela, ou seja, serao so demonstrados os dadosณ
		//ณe nao serao gravados                                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if aReadOnly[i]
			nOperacao 		:= 0
  		endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPonto de entrada para manipular  a operacao, fiz pois necessiteiณ
		//ณque fossse apenas GD_UPDATE na grid, entao se deseja usar       ณ
		//ณso um tipo de operacao ou manipula o tipo use esse PE           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if ExistPe('TipoOperacao'+StrZero(i,2))
			nOperacao := ExecPe('TipoOperacao'+StrZero(i,2), 'N')
		endif
		
		if ExistPe('TipoOperacao'+aFilhas[i])
			nOperacao := ExecPe('TipoOperacao'+aFilhas[i], 'N')
		endif		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria a funcao de change de item dos grids ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		bChange			:= {||OnChange()}

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria um texto padrao que ficara atras das grids, quando as mesmas ณ
		//ณnao aparecerem apararecera o texto 'nao ha itens'                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oFont 			:= TFont():New('Courier new',,-18,.T.)
      oSay				:= TSay():New(01,01,{||'Nใo hแ itens'},oTFolder:aDialogs[i],,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria a quantidade maxima de registros que uma grid pode terณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nMaxLinhas	:= 9999
		if ExistPe('MaxLinhas'+StrZero(i,2))
			nMaxLinhas	:= ExecPe('MaxLinhas'+StrZero(i,2), 'N')
		endif
		
		if ExistPe('MaxLinhas'+aFilhas[i])
			nMaxLinhas	:= ExecPe('MaxLinhas'+aFilhas[i], 'N')
		endif		

		nFreeze	:= 0
		if ExistPe('Freeze'+StrZero(i,2))
			nFreeze	:= ExecPe('Freeze'+StrZero(i,2), 'N')
		endif
		
		aAlter	:= nil
		if ExistPe('CamposAlteraveis'+StrZero(i,2))
			aAlter	:= ExecPe('CamposAlteraveis'+StrZero(i,2), 'A')
		endif		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria o newgetdadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		&(cGetDados) 	:= MsNewGetDados():New(15,1,20,40,nOperacao,cLinOK,cTudoOk,aIniPos[i],aAlter,nFreeze,nMaxLinhas,,,cDelOK,oTFolder:aDialogs[i], &(cHeader), &(cCols), bChange)
		         
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPonto de entrada que adiciona acoes em campos da grid.   ณ
		//ณhttp://tdn.totvs.com/display/softwaregestao/MsNewGetDadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aAddAction	:= {}
		if ExistPe('AddAction'+StrZero(i,2))
			aAddAction	:= ExecPe('AddAction'+StrZero(i,2), 'A')
		endif			 
		
		for z:= 1 to len(aAddAction)
			&(cGetDados):AddAction(aAddAction[z][1], aAddAction[z][2])
		next
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPonto de entrada para setar a funcao que muda as linhas de uma grid ณ
		//ณse baseando em alguma condicao                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nPosFil	:= aScan(aFiltro, {|aX| Upper(aX[2]) == Upper(aFilhas[i])}) 

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณso tera cores se nao for uma grid filtrada, a filtrada estava dando errro. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if ExistPE('CorLinhasAba'+StrZero(i, 2)) .AND. nPosFil == 0
			/*
			#define CLR_BLACK             0               // RGB(   0,   0,   0 )
			#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
			#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
			#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
			#define CLR_RED             128               // RGB( 128,   0,   0 )
			#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
			#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
			#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
			#define CLR_LIGHTGRAY  CLR_HGRAY
			
			//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ//
			//                       High Intensity Colors
			//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ//
			
			#define CLR_GRAY        8421504               // RGB( 128, 128, 128 )
			#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 )
			#define CLR_HGREEN        65280               // RGB(   0, 255,   0 )
			#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 )
			#define CLR_HRED            255               // RGB( 255,   0,   0 )
			#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 )
			#define CLR_YELLOW        65535               // RGB( 255, 255,   0 )
			#define CLR_WHITE      16777215               // RGB( 255, 255, 255 )
			*/
			&(cGetDados):oBrowse:lUseDefaultColors := .F.
			bColorsAux	:= ExecPE('CorLinhasAba'+StrZero(i, 2), 'B')
			&(cGetDados):oBrowse:SetBlkBackColor(bColorsAux)
		endif		                               
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAlinha o get dados para preencher o panel todoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		&(cGetDados):oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		&(cGetDados):ForceRefresh()                               
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se esta incluindo, e o get tem Dominio, apaga a linha, para evitar validacoesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nPosREC := aScan(&(cGetDados):aHeader, {|x| x[1] == "Recno WT" })
		
		if (INCLUI .AND. TemDomCdom(&(cGetDados):aHeader[1][2], 2) > 0) .OR. (ALTERA .AND. nPosRec > 0 .AND. Len(&(cGetDados):aCols) == 1 .AND. &(cGetDados):aCols[1][nPosRec] == 0) 
			lAutoDel	:= .T.
			&(cGetDados):DelLine(1)
			lAutoDel	:= .F.
		endif
	next
	lResult		:= .F.
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonto de entrada para incluir botoes no modelo aba, nao eh permitido                                                ณ
	//ณchamar novos browses que tenham modeloaba a partir destes botoes                                                    ณ
	//ณAadd( aButtons, {"HISTORIC", {|| ApMsgInfo('Colocar Botao (AddButton)')}, "Hist๓rico...", "Hist๓rico" , {|| .T.}} ) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if ExistPE('AddButton')
		aButtons	:= ExecPe('AddButton', 'A')
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe for copia, inicializa os campos que devem ser 'refreshados' como normalmente eh o campo codigo.ณ
	//ณE altera as variaveis de controle de alteracao, e inclusao                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lCopia
		for u:= 1 to len(aFieldsCopia)
			&(aFieldsCopia[u][1])	:= &(aFieldsCopia[u][2])
		next
		INCLUI			:= .T.
		ALTERA			:= .F.
		nRecNoCabec		:= 0
		GetDRefresh()
	endif     
	
	if ExistPE('AntesAtvDlg')
		ExecPe('AntesAtvDlg', 'L')
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtiva o Dialogoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if !lAuto
		oDlg:bInit := {|| EnchoiceBar(oDlg, {||lResult := TudoOk(), iif(lResult, oDlg:End(), lResult := .F.)},{||lResult:=.F.,oDlg:End()},,@aButtons)}	
		oDlg:lCentered := .T.	
		oDlg:Activate()
	endif

	begin sequence

	//ExecAuto do modeloAba	
	if lAuto .and. len(aDados) >= 1

		lResult		:= .T.
		
		//Grava o cabe็alho (enchoice)
		aCabecAuto	:= aClone(aDados[1])
		
		for i := 1 to len(aCabecAuto)

			//preenche os campos em mem๓ria para compatabiliza็ใo 		
			cCampo		:= aCabecAuto[i][1]
			__ReadVar	:= 'M->' + cCampo
			M->&(cCampo):= aCabecAuto[i][2]

			oSXS:cEmpresa := cEmpAnt              // Montar a empresa
            oSXS:cSXS     := "SX3"                // Tabela da SXS
            oSXS:cTabela  := Substr(cCampo,1,3)   // Tabela que quer pegar a estrutura
    
	        aCpoEnchoice := oSXS:Montar()

            For nId := 1 To Len(aCpoEnchoice)
			   // Executa valida็๕es do sistema
				If ! Empty(aCpoEnchoice[nId][06]) .and. !&(allTrim(aCpoEnchoice[nId][06]))  // SX3->X3_VALID
				   MsgInfo("Campo nใo foi validado: " + aCpoEnchoice[nId][02] + ": " +;
				           M->&(aCpoEnchoice[nId][02]),"ExecAuto ModeloAba")
		  		   break
			 	EndIf

			   // Executa valida็๕es de usuแrio			 
			 	If ! Empty(aCpoEnchoice[nId][16]) .and. !&(allTrim(aCpoEnchoice[nId][16]))
					MsgInfo("Campo nใo foi validado: " + aCpoEnchoice[nId][02] + ": " +;
					        M->&(aCpoEnchoice[nId][02]),"ExecAuto ModeloAba")
			 		break
			 	EndIf				 
            Next

/*			if SX3->(dbSeek(cCampo)) 
				//executa valida็๕es do sistema
				if !empty(SX3->X3_VALID) .and. !&(allTrim(SX3->X3_VALID))
					MsgInfo("Campo nใo foi validado: " + SX3->X3_CAMPO + ": " + M->&(cCampo),"ExecAuto ModeloAba")
		  			break
			 	endif
			 	
				//executa valida็๕es de usuแrio			 
			 	if !empty(SX3->X3_VLDUSER) .and. !&(allTrim(SX3->X3_VLDUSER))
					MsgInfo("Campo nใo foi validado: " + SX3->X3_CAMPO + ": " + M->&(cCampo),"ExecAuto ModeloAba")
			 		break
			 	endif
			endif
*/
			//executa trigger do campo (tipo 1-enchoice)
			if existTrigger(cCampo)
				runTrigger(1, , , , allTrim(cCampo))
			endif    			
		next
		
		//Grava as tabelas filhas (GetDados) 
		for j := 2 to len(aDados)
		
			aItensAuto := aClone(aDados[j])
			
			for i := 1 to len(aItensAuto)
				
				if i <> 1
					oGetTemp:AddLine(.T.)
				endif
			
				oGetTemp	:= &('oGet' + strZero(j-1,2))
				aCols			:= oGetTemp:aCols
				aHeader		:= oGetTemp:aHeader
							
				for t := 1 to len(aItensAuto[i])
					
					//preenche os campos em mem๓ria para compatabiliza็ใo 
					cCampo		:= aItensAuto[i][t][1]
					__ReadVar	:= 'M->' + cCampo																			
					GdFieldPut(aItensAuto[i][t][1], aItensAuto[i][t][2], i, oGetTemp:aHeader, oGetTemp:aCols)
					M->&(cCampo) := GdFieldGet(cCampo, i, .F., oGetTemp:aHeader, oGetTemp:aCols)
                    oSXS:cTabela := Substr(cCampo,1,3)   // Tabela que quer pegar a estrutura
    
                    aCpoEnchoice := oSXS:Montar()

                    For nId := 1 To Len(aCpoEnchoice)
			          // Executa valida็๕es do sistema
			           If ! Empty(aCpoEnchoice[nId][06]) .and. !&(allTrim(aCpoEnchoice[nId][06]))  // SX3->X3_VALID
				          MsgInfo("Campo nใo foi validado: " + aCpoEnchoice[nId][02] + ": " +;
				                   M->&(aCpoEnchoice[nId][02]),"ExecAuto ModeloAba")
		  		          break
			 	       EndIf

			          // Executa valida็๕es de usuแrio			 
			 	       If ! Empty(aCpoEnchoice[nId][16]) .and. !&(allTrim(aCpoEnchoice[nId][16]))
					      MsgInfo("Campo nใo foi validado: " + aCpoEnchoice[nId][02] + ": " +;
					               M->&(aCpoEnchoice[nId][02]),"ExecAuto ModeloAba")
			 		      break
			 	       EndIf				 
                    Next

/*					if SX3->(dbSeek(cCampo)) 
						//executa as valida็๕es do sistema
						if !empty(SX3->X3_VALID) .and. !&(allTrim(SX3->X3_VALID))
							MsgInfo("Campo nใo foi validado: " + SX3->X3_CAMPO + ": " + M->&(cCampo),"ExecAuto ModeloAba")
							break
					 	endif
					 	
					 	//executa as valida็๕es de usuแrio
					 	if !empty(SX3->X3_VLDUSER) .and. !&(allTrim(SX3->X3_VLDUSER))
							MsgInfo("Campo nใo foi validado: " + SX3->X3_CAMPO + ": " + M->&(cCampo),"ExecAuto ModeloAba")
					 		break
					 	endif
					endif
*/					       
					//Executa gatilho (tipo 2-getdados)
					//[ nTipo: 1 - Enchoice; 2 - getDados ] [ nLin - linha do getDados ] [ cMacro - n usado ] [ oObj - objeto do Get] [ cField ]
					runTrigger(2, I, , , allTrim(cCampo))
				next
			next
		next
		
		//Valida็ใo do tudoOk						
		if !TudoOk()
			break
		endif
	endif
	
	recover 
	
	lResult := .F.
	
   end sequence

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGravacao dos dados    ณ
	//ณDa enchoice e das abasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lResult .AND. !VISUAL
		begin Transaction

			if ExistPe('BeforePost')
				lResult	:= ExecPe('BeforePost', 'L')
				if !lResult
					DisarmTransaction()
				endif
			endif

			if lResult .AND. INCLUI
				ConfirmSX8()
			else 
				RollBackSX8()
			endif           
			
			if lResult    
				GrvCabec()     

				if ExistPe('AfterPostCabec')
					ExecPe('AfterPostCabec', 'L')
				endif
	
				for i:= 1 to len(aFilhas)
					if aReadOnly[i] == .F.
						u_GrvItens(i)
					endif
				next
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPonto de entrada executado apos a gravacao de tudo, ณ
				//ณe antes do commit da transacao, se retornar false a ณ
				//ณtransacao eh rollbackada                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if ExistPe('AfterPost')
					if !ExecPe('AfterPost', 'L')
						DisarmTransaction()
					endif
				endif
			endif

		end Transaction
	else
		if INCLUI
			if ExistPe('ConfirmSX8NoCancelamento') .and. ExecPe('ConfirmSX8NoCancelamento', 'L')
				ConfirmSX8()
			else
				RollBackSX8()
			endif
		endif
	endif
	
 	if lAuto .AND. !lResult
		for nI:= 1 to len(aDados)
			u_Aviso('', Replicate('-', 40))
			u_Aviso('', iif(nI==1, 'Cabe็alho', aNomes[nI]))
			u_Aviso('', Replicate('-', 40))
			for nX:= 1 to len(aDados[nI])
				if nI == 1
					u_Aviso('', aDados[nI][nX][1] + ' := ' + cValToChar(aDados[nI][nX][2]))
				else
					for nT := 1 to len(aDados[nI][nX])
						u_Aviso('', aDados[nI][nX][nT][1] + ' := ' + cValToChar(aDados[nI][nX][nT][2]))
					next
				endif
			next
		next
		u_Aviso('', '')
		u_Aviso('', '')		
		u_Aviso('', '')		
	endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonto de entrada executado apos as gravacoes, depois do commitณ
	//ณda transacao. Sera normalmente utilizado para contabilizacoes ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if ExistPe('DepoisDeTudo')
		ExecPe('DepoisDeTudo', 'L')
	endif      

	//Necessแrio para compatibiliza็ใo - a Dialog aberta sem ser ativada e devidamente fechada ocasionava overflow
	if lAuto  		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAbre e fecha a tela, tiramos o freeobj pois so dando o freeobj ele trava o rpoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oDlg:Activate(,,,.T.,{|| oDlg:End(),.T.},,{|| oDlg:End()} )
//		freeObj(oDlg)
	endif

Return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณGrvCabec  บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que grava o conteudo do cabecalho do modeloaba       บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function GrvCabec()
	local i   
	local lResult
	local nTamAlias
	if !INCLUI
		(cCabec)->(dbGoTo(nRecNoCabec))
	endif

	RecLock((cCabec),INCLUI)	
		If DELETA
			(cCabec)->(dbDelete())
		Else           
			nTamAlias	:= iif(left(cCabec,1)<> 'S',3,2)
			(cCabec)->&(Right(cCabec,nTamAlias)+'_FILIAL')	:= xFilial(cCabec)
			for i:= 1 to len(aGets)
				cCampo	:= SubStr(aGets[i],9,10)
				(cCabec)->&(cCampo)	:= M->&(cCampo)
			next
		EndIf

	(cCabec)->(MsUnLock())

Return
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณGrvItens  บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao de gravacao das tabelas itens do modeloaba           บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function GrvItens(nItem)
	local i, j
	local lResult   	           
	local cItem
	local cAlias		:= aFilhas[nItem]
	local _aSeekItens	:= _aChave[nItem]
	local cCols			:= 'aCols'	+ StrZero(nItem,02)
	local cHeader		:= 'aHeader'+ StrZero(nItem,02)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPreenche o aHeader e o aCols pois o GDGetField funciona so           ณ
	//ณse eles estiverem preenchidos, tipo, nao tem como chamar o GDGetFieldณ
	//ณse estivermos utilizando um array aHeader01 ou aCols01               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cGetDados 			:= "oGet" + StrZero(nItem, 2)
	cGet		 			:= "oGet" + StrZero(nItem, 2)	
	aHeader 				:= aClone(&(cGetDados):aHeader)
	aCols   				:= aClone(&(cGetDados):aCols)
	n 						:= &(cGetDados):nAt

	(cAlias)->(dbSetOrder(aOrdItem[nItem]))
	if ExistPe('BeforePostItem')
		ExecPe('BeforePostItem', 'L')
	endif                     
	aHeader 				:= aClone(&(cGetDados):aHeader)
	aCols   				:= aClone(&(cGetDados):aCols)

	for i:= 1 to len(aCols)
		n 					:= i
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta a chave de pesquisa de existenciaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cSeek	:= ''
//		oError := ErrorBlock({|e|MsgAlert("(" + cAlias + ") PREENCHA CORRETAMENTE O ARRAY aLinha e o ARRAY aOrdItem" +chr(10)+ e:Description)}) 

		for j:= 1 to len(_aSeekItens)
			cSeek	+= &(_aSeekItens[j][2])
		next

  //		ErrorBlock(oErro)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe nao encontrar o registro e estiver deletado no aColsณ
		//ณBasta ignorar a linha                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if !(cAlias)->(dbSeek(cSeek)) .and. aCols[i][Len(aHeader) + 1]
			LOOP
		endif
		RecLock(cAlias,!(cAlias)->(Found()))

			if (cAlias)->(Found()) .And. (aCols[i][Len(aHeader) + 1] .OR. DELETA )
				(cAlias)->(dbDelete())
			else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณGrava os campos que estao na grid (aCols)ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				for j:= 1 to len(aHeader)
					(cAlias)->&(aHeader[j][2])	:= GDFieldGet(aHeader[j][2],i)
				next
				//# ver virtual, gravacao, pau
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณGrava os campos que sao chave, e podem nao estar no aColsณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				for j:= 1 to len(_aSeekItens)                                    
			  /*		cCampo1		:= _aSeekItens[j][1]
					cCampo2		:= _aSeekItens[j][1]
					cTamCampo1	:= StrZero(len(&(cCampo1)),3)
					cTamCampo2	:= StrZero(len(&(cCampo1)),3)
					if cTamCampo1 <> cTamCampo2
						ApMsgInfo('O campo ' + cCampo1 + ' tem tamanho diferente de '  + cCampo2 + chr(13) + chr(10);
									+	' ajuste os campos para a gravacao ficar correta.' + chr(13) + chr(10);
									+ cCampo1 + ' Tamanho: ' + cTamCampo1 + chr(13) + chr(10);
									+ cCampo2 + ' Tamanho: ' + cTamCampo2 )
					endif*/
					&(_aSeekItens[j][1])	:= &(_aSeekItens[j][2])
				next                                                         
			endIf
		(cAlias)->(MsUnLock())
		if ExistPe('AfterPostItem')
			ExecPe('AfterPostItem', 'L')
		endif
	next
Return

                             
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณExistPe   บAutor  ณGeorge Allan        บ Data ณ  13/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que verifica se existe o ponto de entrada passado    บฑฑ
//ฑฑบ          ณpelo parametro                                              บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function ExistPe(cPe)
	local lResult	:= .F.
	nPos		:= aScan(aPE, {|aX| Upper(aX[1]) == Upper(cPe)})
	if nPos	> 0
		lResult	:= .T.
	endif
Return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณExecPe    บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que executa o ponto de entrada, so deve ser chamada  บฑฑ
//ฑฑบ          ณse o ExistPe tambem retornar .t.                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function ExecPe(cPe, cTipo)
	local xResult	:= ''
	nPos		:= aScan(aPE, {|aX| Upper(aX[1]) == Upper(cPe)})
	if nPos	> 0
		xResult	:= aPE[nPos][2]
	endif      

	xResult	:= &(xResult)

	if Upper(ValType(xResult)) <> Upper(cTipo)
       MsgInfo("PE: " + cPe + " com retorno ou tipo invแlido. Retorno: " + ValType(xResult) + ". retorno esperado" + cTipo,"Aviso")
	endif                                                     
	
Return xResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณTudoOk    บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao de validacao geral da tela                           บฑฑ
//ฑฑบ          ณValida campos obrigadorios do enchoice, dos gets e executa  บฑฑ
//ฑฑบ          ณpontos de entrada, eh executado antes da gravacao dos dados บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function TudoOk()
	local i    
	local lResult := .T.
	local _aColsAux	:= {}
	local _aColsAux	:= {}
	local oGetTmp
	
	if ExistPe('BeforeTudoOk')
		lBeforeTudoOk	:= ExecPe('BeforeTudoOk', 'L')
		lResult			:= lBeforeTudoOk
	endif	

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida os campos obrigatoriosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lResult
		for i:= 1 to len(aGets)                            
			cCampo	:= SubStr(aGets[i],9,10) 
			cConteudo:= &('M->'+ cCampo)
			dbSelectArea('SX3')
			if lResult .AND. X3Obrigat(SubStr(aGets[i],9,10)) .AND. Empty(cConteudo)
				// antes de dar o foco eh para verificar se o campo pode ser focado, tipo... se ele esta bulํvel
				oEnchoice:aEntryCtrls[i]:SetFocus()
//				Help(" ",1,"OBRIGAT",,Padr(RetTitle(cCampo),40),3)
				MsgInfo("Campo obrigat๓rio nใo preenchido " + AllTrim(RetTitle(cCampo)) + "(" + AllTrim(cCampo) + ")","Aviso")
				lResult	:= .F.
			endif
		next
	endif
	
	if lResult

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณvalida campos de cada pasta: se der erro mostra a pasta onde esta o erroณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		for i := 1 To Len(oTFolder:aDialogs)
		    alert("entrei")
			cGetDados	:= "oGet" + StrZero(i, 2)
			oGetTmp		:= &(cGetDados)
			oGetTmp:OnChange() 
			aAdd(_aColsAux, aClone(oGetTmp:aCols))
			if !oGetTmp:ChkObrigat(oGetTmp:nAt)
				oTFolder:nOption 	:= i //oTFolder:SetOption(2)
				lResult				:= .F.
				exit
			endif
			if !eval(oGetTmp:bTudoOk) //!oGetTmp:TudoOK() //se chamar pela segunda vez, retorna true, se usar eval no btudook, retorna true
				oTFolder:nOption 	:= i //oTFolder:SetOption(i)
				lResult				:= .F.
				exit
			endif
		next
	endif

	if lResult         
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVarre todas as abas, colocando no aCols o aColsAux, caso existaณ
		//ณo aColsAux sera o array que tem todos os dados do aCols, inde- ณ		
		//ณpendente do filtro que haja nesta aba.                         ณ
		//ณTem abas que sao 'filhas' de outras abas, entao o conteudo de- ณ
		//ณlas sera demonstrado de forma filtrada, mas no aColsAux tera   ณ
		//ณsempre ela completa.                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		for i:= 1 to len(oTFolder:aDialogs)
			cColsAux	:= 'aColsAux' 	+ StrZero(i, 2)
			cCols		:= 'aCols' 		+ StrZero(i, 2)
			cHeader	:= 'aHeader'	+ StrZero(i, 2)
			cGet		:= 'oGet'		+ StrZero(i, 2)

			if len(&(cColsAux)) > 0
				&(cCols)			:= aClone(&(cColsAux))
				&(cGet):aCols	:= aClone(&(cColsAux))
			endif
		next
	endif

	if lResult

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecuta o ponto de entrada TudoOk, apos todas as validacoes 'padroes'  ณ
		//ณse retornar false isto invalida o tudook anterior, e a tela nao fecharaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if ExistPe('TudoOk')
			lTudoOk	:= ExecPe('TudoOk', 'L')
			if !lTudoOk
				lResult	:= .F.
			endif
		endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEste trecho serve para filtrar novamente as abas que sao filhas, pois antes do tudookณ
		//ณeste filtro eh retirado e caso de algum problema no tudook (PE) o filtro tem de ser  ณ
		//ณnovamente posto                                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if !lResult
			for i:= 1 to len(oTFolder:aDialogs)
				cCols				:= 'aCols' 		+ StrZero(i, 2)
				cGet				:= 'oGet'		+ StrZero(i, 2)
				&(cCols)			:= aClone(_aColsAux[i])
				&(cGet):aCols 	:= aClone(_aColsAux[i])
				GetDRefresh()
			next
		endif
	endif
	

Return lResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณReplicaCamบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que faz a copia dos dados das tabelas do modeloaba   บฑฑ
//ฑฑบ          ณpara as tabelas de destino, isto eh usado em raras ocasioes บฑฑ
//ฑฑบ          ณonde o cliente quer ter o historico completo das alteracoes บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function ReplicaCampos() 
	local cHora				:= Time()
	local cData				:= DTOS(Date())
	local lResult			:= .T.
	local aOrigem			:= {}
	local aDestino			:= {}
	local aPk				:= _aSeek
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz validacoes gerais de estrutura, comparando as estruturas entre as ณ
	//ณtabelas de origem e destino, para evitar erros em tempo de aplicacao  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if u_VldEstrut(@aOrigem, @aDestino) == .F.
		MsgInfo("Impossivel continuar, a estutura das tabelas de c๓pia esta invแlida","Aviso")
		Return .F.
	endif             

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta a chave que fara o vinculo entre o cabecalho e as tabelas filhas ณ
	//ณEh necessaria esta nova chave pois um mesmo registro pode ser duplicadoณ
	//ณvarias vezes, entao temos de diferenciar cada uma das copias           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cChave	:= __cUserId + ' ' + cUserName + ' ' + cHora + ' ' + cData + ' ' + StrZero(Randomize(1, 1000), 4)

	if len(aOrigem)==0
		Return .F.
	endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdiciona o recno do cabecalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aOrigem[1][2],(aOrigem[1][1])->(RecNo()))

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdiciona o recno dos itens no item 3 do array aOrigem            ณ
	//ณNesta posicao havera um array com os recno dos filhos            ณ
	//ณIsto servira de base para a rotina saber quais registros deverao ณ
	//ณser copiados                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for i:= 1 to len(aFilhas)
		cTabFilha	:= aFilhas[i]
		(cTabFilha)->(dbSetOrder(aOrdem[i]))
		cSeek			:= &(aPK[i])
		(cTabFilha)->(dbSeek(cSeek))
		dbSelectArea(cTabFilha)
		while !(cTabFilha)->(EOF()) .AND. &(aPK[i]) == Eval(aWhile[i])
			aAdd(aOrigem[i+1][2], (cTabFilha)->(RecNo()))
			(cTabFilha)->(dbSkip())
		enddo
	next
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVarre todas as tabelas que serao duplicadas, iniciando com a de ณ
	//ณcabecalho                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for i := 1 to len(aOrigem)                    
		cTabOrigem		:= aOrigem[i][1]
		cTabDestino		:= aDestino[i]
		cAliasCampo		:= iif(Left(cTabDestino,1)=='S', Right(cTabDestino,2), cTabDestino)

		aRecNo			:= aOrigem[i][2]
		for t := 1 to len(aRecNo)
			(cTabOrigem)->(dbGoTo(aRecNo[t]))
			RecLock(cTabDestino, .T.)
				for j :=1 to (cTabOrigem)->(FCount())                     
					cCampoOrigem	:= (cTabOrigem)->(Field(j))
					nPosicao_		:= At('_',cCampoOrigem)	
					cCampoDestino	:= cAliasCampo + SubStr(cCampoOrigem, nPosicao_, len(cCampoOrigem) - nPosicao_+1)
		
					(cTabDestino)->&(cCampoDestino)	:= (cTabOrigem)->&(cCampoOrigem)
				next
				(cTabDestino)->&(cAliasCampo + '_YCHAVE')	:= cChave
			(cTabDestino)->(msUnLock())
		next      
		if len(AllTrim(cChave)) >  len((cTabDestino)->&(cAliasCampo + '_YCHAVE'))
			lResult	:= .F.
			MsgInfo("Tamanho do " + cAliasCampo + "_YCHAVE insuficiente, aumente para pelo menos o tamanho " +;
			        StrZero(len(AllTrim(cChave)), 3),"Aviso")
		endif
	next

Return lResult
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณVldEstrut บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que valida se a estrutura das tabelas que serao      บฑฑ
//ฑฑบ          ณcopiadas esta de acordo com as tabelas de origem            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function VldEstrut(aOrigem, aDestino)
	local lResult		:= .T. 
	local aOrigem
	local aDestino
   Default aOrigem	:= {}
   Default aDestino	:= {}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe nao foi passado o cRepCabec, eh porque nao eh pra fazer copiaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if Empty(cRepCabec)
		Return .T.
	endif

	aAdd(aOrigem, {cCabec, {}})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdiciona a tabela de cabecalho no array aOrigem, este array indicaraณ
	//ณquais tabelas terao seus dados duplicados                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for i:= 1 to len(aFilhas)
		aAdd(aOrigem, {aFilhas[i], {}})
	next                                                                   
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณO array aDestino eh um array paralelo ao aOrigem, ele servira para indicarณ
	//ณpara quais tabelas o conteudo do aOrigem sera duplicado                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aDestino, cRepCabec)
	for i:= 1 to len(aRepFilhas)
		aAdd(aDestino, aRepFilhas[i])
	next                 
	
	if len(aOrigem) <> len(aDestino)
		lResult	:= .F.
		MsgInfo("Informa็๕es passadas para o modelo aba estao invแlidas, veja as variaveis cCabec, cRepCabec, aFilhas, aRepFilhas","Aviso")
		return lResult
	endif                          
	
	for i	:= 1 to len(aOrigem)                                                                   
		cTabOrigem		:= aOrigem[i][1]
		cTabDestino		:= aDestino[i]
		cAliasCampo		:= iif(Left(cTabDestino,1)=='S', Right(cTabDestino,2), cTabDestino)        

		cCampoChave	:= iif(Left(cTabDestino,1)=='S', Right(cTabDestino,2), cTabDestino) + '_YCHAVE'

/*		if Empty(Left(InfoSX3(cCampoChave),1)) .or. SX3->X3_TIPO <> 'C'
			MsgInfo("Crie o campo _YCHAVE no " + cTabDestino + " como caracter","Aviso")   
			lResult	:= .F.
		endif                                                                            
*/		
		for j :=1 to (cTabOrigem)->(FCount())
			cCampoOrigem	:= (cTabOrigem)->(Field(j))
			nPosicao_		:= At('_',cCampoOrigem)	
			cCampoDestino	:= cAliasCampo + SubStr(cCampoOrigem, nPosicao_, len(cCampoOrigem) - nPosicao_ + 1)
			if InfoSX3(cCampoOrigem) <> InfoSX3(cCampoDestino)
				cMensagem	:= 'Campo ' + cCampoOrigem + ' diferente (ou inexistente) em a estrutura do ' + cTabDestino + '<br>' 
				cMensagem	+= InfoSX3(cCampoOrigem) + '<br>'
				cMensagem	+= InfoSX3(cCampoDestino) + '<br>'				
				MsgInfo(cMensagem,"Aviso")
				lResult	:= .F.
			endif
		next
	next
Return lResult
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณInfoSX3   บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao auxiliar utilizada para verificar se o campo da tabe-บฑฑ
//ฑฑบ          ณla de origem esta definido da mesma forma que o campo da    บฑฑ
//ฑฑบ          ณtabela destino (copia)                                      บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function InfoSX3(cCampo)
	cResult	:= ''
	SX3->(dbSetOrder(2)) // campo
	SX3->(dbSeek(cCampo))
	cResult	:= SX3->X3_TIPO + STR(SX3->X3_TAMANHO) + STR(SX3->X3_DECIMAL) + UPPER(SX3->X3_TITULO)

    oSXS:cTabela := Substr(cCampo,1,3)   // Tabela que quer pegar a estrutura
    aCpoEnchoice := oSXS:Montar()

    For nId := 1 To Len(aCpoEnchoice)
	    If AllTrim(aCpoEnchoice[nId][02]) == AllTrim(cCampo)
           cResult	:= aCpoEnchoice[nId][08] + STR(aCpoEnchoice[nId][04]) + STR(aCpoEnchoice[nId][05]) + UPPER(aCpoEnchoice[nId][01])
  		   break
	 	EndIf
    Next
Return cResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณOnChange  บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao chamada a cada mudanca de linha de cada get          บฑฑ
//ฑฑบ          ณTem o objetivo de filtrar registro das grids 'contra dominioบฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function OnChange()
	Local aPosFil	:= {}
	Local i			
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se a tabela do aHeader tem filtro vinculado, antes eu estava ณ
	//ณfazendo esta verificacao baseando-me na aba escolhida, mas estava     ณ
	//ณdando errado na primeira (primeiras) chamada                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_nPosFil	:= 0

	While (_nPosFil	:= TemDomCdom(aHeader[1][2], 1, _nPosFil + 1)) > 0
		Aadd(aPosFil, _nPosFil)
	Enddo
	
	if Len(aPosFil) > 0
		For i := 1 to Len(aPosFil)
			nPosFil	:= aPosFil[i]
			PreencheVars()
	      AtuAcols()
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณLimpa o aAuxiliar, tirando os dados do aColsCdom atualณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			LimpaAuxiliar()
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe for primeira vez, preenche o array completo na matriz auxiliarณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			if PrimeiraVez()
				&(cColsAux)		:= aClone(&(cGetCdom):aCols)
			else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAgrega dados do contra dominio na matriz aColsAuxXX              ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู					
				AgregaCdom()
			endif        
			cCDom	:= aFiltro[nPosFil][2]
	      AtuAcols()
			nPosFil	:= aPosFil[i]
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPreenche o contradominio, com os dados do aColsAux referentes a seu getณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	      PreencheCdom(cCdom)
	
			&(cGetCdom):Refresh(.T.)
			cTabCdom	:= aFiltro[nPosFil][2] // tabela contra dominio
			nPosFil	:= TemDomCdom(cTabCdom+"_FILIAL", 1)
			if nPosFil > 0 // o contradominio tambem eh dominio neste caso
				nPosFilha	:= aScan(aFilhas, {|aX| Upper(aX) == Upper(aFiltro[nPosFil][1])})
				&('oGet' + StrZero(nPosFilha, 2)):OnChange()
			endif
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica se o contradominio tem contradominio, se tiver chamaณ
			//ณo onchage do contradominio1                                  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Next
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonto de entrada chamado no ato da mudanca de linha da abaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if ExistPe('onChangeLine'+StrZero(nAbaAtu,2))
		ExecPe('onChangeLine'+StrZero(nAbaAtu,2), 'L')
	endif

	if ExistPe('onChangeLine'+aFilhas[nAbaAtu])
		ExecPe('onChangeLine'+aFilhas[nAbaAtu], 'L')
	endif
	
Return 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณTemDomCdomบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que indica se a tabela tem dominio ou contra dominio บฑฑ
//ฑฑบ          ณDeve ser passado o nome do campo da tabela, e o tipo, o tipoบฑฑ
//ฑฑบ          ณpode ser 1 para dominio e 2 para contra dominio             บฑฑ
//ฑฑบ          ณEste numero indica a posicao do campo no array a Filtros    บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function TemDomCdom(cCampo, nTipo, nStart)
	Default nStart := 1
	nPos_ := at('_',cCampo)
	_cTabela	:= Left(cCampo,nPos_-1)
	if len(_cTabela) == 2
		_cTabela := 'S' + _cTabela
	endif
	nPosFil			:= aScan(aFiltro, {|aX| Upper(aX[nTipo]) == Upper(_cTabela)}, nStart)
return nPosFil

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณAtuaCols  บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que atualiza os aCols a partir dos oGet:aCols        บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function AtuAcols()
	local i
	local cCols
	local cGet
	for i:= 1 to len(aFilhas)
		cGet	:= 'oGet' 	+ StrZero(i,2)
		cCols	:= 'aCols'  + StrZero(i,2)
		&(cCols)	:= aClone(&(cGet):aCols)
	next
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณMontaFiltrบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que monta o filtro referente aos parametros passados บฑฑ
//ฑฑบ          ณTem-se de ser passado o aheader do filtro, o aCols, a       บฑฑ
//ฑฑบ          ณvariavel (que pode ser o 'i' do for por exemplo, ou o nAux  บฑฑ
//ฑฑบ          ณque eh um valor fixo (1) e o tipo de campo, se eh 1 dominio บฑฑ
//ฑฑบ          ณe o 2 eh contra dominio                                     บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function MontaFiltro(cHeaderFil, cColsFil, cVarFil, nTipoCampoFil)
	local cFiltro	:= ''
	
	for j:= 1 to len(aCamposFil)
		cCampoFil	:= aFiltro[nPosFil][3][j][nTipoCampoFil]
		nPosCampo	:= GDFieldPos(cCampoFil,&(cHeaderFil))
		cFiltro		+= "+" + cColsFil +"[("+ cVarFil+")][("+StrZero(nPosCampo,3)+")]"
	next
Return cFiltro

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณLimpaAuxilบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que limpa da matriz auxiliar (aColsAuxXX) os         บฑฑ
//ฑฑบ          ณregistros referentes ao contra dominio atual, estes dados   บฑฑ
//ฑฑบ          ณserao recolocados depois, mas antes disso t๊m de ser limpos บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function LimpaAuxiliar()
	local aAjuda	:= {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe estiver excluindo ou visualizando, nao eh pra limparณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if EXCLUI .OR. VISUAL
		Return
	endif
	for i:= 1 to len(&(cColsAux))
		cFiltroCdom	:= MontaFiltro(cHeaderCDom, cColsCDom	, 'nAux'	, 2)
		cFiltroAux	:= MontaFiltro(cHeaderCDom, cColsAux	, 'i'		, 2)

		if &(cFiltroAux) == &(cFiltroCdom)
			&(cColsAux)[i] := nil
		endif
	next
	           
	aAjuda			:= aClone(&(cColsAux))
	&(cColsAux)		:= {}
	for i:= 1 to len(aAjuda)
		if aAjuda[i] <> nil
			aAdd(&(cColsAux), aAjuda[i])
		endif
	next
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณPrimeiraVeบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que verifica se o aColsAuxXX ainda nao existe, para  บฑฑ
//ฑฑบ          ณfazer a carga inicial dele.                                 บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function PrimeiraVez()
	nPos_ := at('_',aHeader[1][2])
	_cTabela	:= Left(aHeader[1][2],nPos_-1)
	if len(_cTabela) == 2
		_cTabela := 'S' + _cTabela
	endif
	nPosFil			:= aScan(aFiltro, {|aX| Upper(aX[1]) == Upper(_cTabela)})	 
Return len(&(cColsAux)) == 0         

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณAgregaCdomบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que joga os dados do contradominio no aColsXX        บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function AgregaCdom()
	if !EXCLUI .AND. !VISUAL
		for i:= 1 to len(&(cGetCdom):aCols)
			aAdd(&(cColsAux), &(cGetCdom):aCols[i])
		next
	endif
Return
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณPreencheCDบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que joga no aCols do contra dominio os dados do      บฑฑ
//ฑฑบ          ณaColsAuxXX referentes a ele.                                บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function PreencheCdom(cCdom)
	local aRetorno
	cFiltroDom	:= MontaFiltro(cHeaderDom	, cColsDom	, '&(cGetDom):nAt', 1)
	cFiltroAux	:= MontaFiltro(cHeaderCDom	, cColsAux	, 'i'					, 2)
	nPosCdom		:= aScan(aFilhas, {|aX| Upper(aX) == Upper(cCdom)})	 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณlimpa o array do contra dominioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	&(cGetCdom):aCols	:= {}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdicao simples das informacoes do ContraDominio no aColsAuxXXณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(&cColsDom) > 0
		for i:= 1 to len(&(cColsAux))
			if &(cFiltroDom) == &(cFiltroAux)
	 			aAdd(&(cGetCdom):aCols, &(cColsAux)[i])
			endif
		next
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณse nใo tiver nenhum item, tem de iniciar o aCols com um item vazioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if len(&(cGetCdom):aCols)==0
		&(cGetCdom):AddLine(.T.)
		lAutoDel	:= .T.
		&(cGetCdom):DelLine(1)
		lAutoDel	:= .F.
	endif
	&(cColsCdom)	:= aClone(&(cGetCdom):aCols)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe tiver excluindo ou visualizando, e nao houver itens no contra dominio, entao esconde a gridณ
	//ณpara nao mostra-la totalmente vazia (ao dar dois cliques dava erro)                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if (EXCLUI .OR. VISUAL) .AND. len(&(cColsCdom)) == 0
		&(cGetCdom):Hide()
	else
		&(cGetCdom):Show()	
	endif	
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณPreencheVaบAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que inicializa variaveis que serao utilizadas pelas  บฑฑ
//ฑฑบ          ณoutras funcoes                                              บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function PreencheVars()
		cDom			:= aFiltro[nPosFil][1]
		nPosDom		:= aScan(aFilhas, {|aX| Upper(aX) == Upper(cDom)})
		cGetDom		:= 'oGet' 		+ StrZero(nPosDom, 2)
		cHeaderDom	:= 'aHeader' 	+ StrZero(nPosDom, 2)
		cColsDom		:= 'aCols'		+ StrZero(nPosDom, 2)
		cCdom			:= aFiltro[nPosFil][2]
		nPosCdom		:= aScan(aFilhas, {|aX| Upper(aX) == Upper(cCdom)})
		cGetCdom		:= 'oGet' 		+ StrZero(nPosCdom, 2)
		cHeaderCdom	:= 'aHeader' 	+ StrZero(nPosCdom, 2)
		cColsCdom	:= 'aCols'		+ StrZero(nPosCdom, 2)
		cColsAux		:= 'aColsAux'	+ StrZero(nPosCdom, 2)
		n:= &(cGetDom):nAt
		aCamposFil	:= aClone(aFiltro[nPosFil][3])
return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณfCampoUnq บAutor  ณGeorge Allan        บ Data ณ  01/09/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que verifica se existe o mesmo conteudo no aCols.    บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ Normalmente usada em ponto de entrada que valida a linha.  บฑฑ
//ฑฑบ          ณ Ex. para chamar a funcao:                                  บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณaCampoUnico	:= {}                                         บฑฑ
//ฑฑบ          ณaAdd(aCampoUnico,{'ZC6_ITEM',gdFieldGet('ZC6_ITEM',n)})     บฑฑ
//ฑฑบ          ณIf !U_fCampoUnq(aCampoUnico)                                บฑฑ
//ฑฑบ          ณ	Alert('Jแ existe esse item na grid.')                     บฑฑ
//ฑฑบ          ณ	Return .F.                                                บฑฑ
//ฑฑบ          ณEndIf                                                       บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณExiste um exemplo desse no POTA0105.prw                     บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function fCampoUnq(aCampoUnico, _aHeader, _aCols)
	Local aHeadertemp		:= aHeader
	Local aColsTemp		:= aCols	

	Default aCampoUnico	:= {}
	Default _aHeader		:= aHeader
	Default _aCols			:= aCols	

	If Empty(aCampoUnico)
		Return .T.
	EndIf

	aHeader	:= aClone(_aHeader)
	aCols 	:= aClone(_aCols)
	
	// Forma as variaveis de compara็ใo
	cCampos	:= ''
	cValores	:= ''
	For i:=1 to Len(aCampoUnico)
		cCampos	+= Iif(Empty(cCampos) ,"gdFieldGet('"+aCampoUnico[i][1]+"',i)",'+'+"gdFieldGet('"+aCampoUnico[i][1]+"',i)")
		cValores	+= aCampoUnico[i][2]
	Next
	
	// Precorre todo o aColse comparo se tem o mesmo conteudo em quantas linhas.
	nCont	:= 0
	for i:=1 to Len(aCols)         
		if aCols[i][Len(aHeader)+1]
			loop
		endif
		if &(cCampos) == cValores
			nCont++
		endIf
	next
	
	aHeader	:= aClone(aHeadertemp)
	aCols 	:= aClone(aColsTemp)

	If nCont > 1 // Comparo com maior que 1 porque 1 e a propria linha.
		Return .F.
	EndIf

Return .T.
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณLenArray  บAutor  ณGeorge Allan        บ Data ณ  04/10/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณRetorna o tamanho do array passado, desconsiderando as      บฑฑ
//ฑฑบ          ณlinhas jah deletadas                                        บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function LenArray(aArray, nPosDel)
	local nResult	:= 0
	local i               
	local aArray      
	for i:=1 to len(aArray)
		if !aArray[i][nPosDel]
			nResult++
			exit
		endif
	next
return nResult
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณOnChangeAbบAutor  ณGeorge Allan        บ Data ณ  05/10/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao que sera executada a cada mudanca de aba, esta funcaoบฑฑ
//ฑฑบ          ณatualiza a variavel nAbaAtu, que indica qual eh a aba atual บฑฑ
//ฑฑบ          ณOu seja, o nAbaAtu sera sempre igual ao oTFolder:nOption,   บฑฑ
//ฑฑบ          ณMas no caso de querermos utilizar o ponto de entrada        บฑฑ
//ฑฑบ          ณOnChangeAba sera util esta variavel pois ela indicara a aba บฑฑ
//ฑฑบ          ณ'anterior', ou seja, a aba que perdeu o foco                บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function onChangeAba()
	local lOnChangeAba	:= .T.
	cGet	:= 'oGet' + StrZero(nAbaAtu, 2)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSo chama o tudo ok se estiver tentando mudar de abaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if oTFolder:nOption <> nAbaAtu
		lOnChangeAba			:=&cGet:TudoOk()
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe mudou de aba, chama o PE de mudanca de linha, este PE naoณ
	//ณestava sendo chamado quando se mudava a aba                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lOnChangeAba
		if ExistPe('onChangeLine'+StrZero(nAbaAtu,2))
			ExecPe('onChangeLine'+StrZero(nAbaAtu,2), 'L')
		endif
	
		if ExistPe('onChangeLine'+aFilhas[nAbaAtu])
			ExecPe('onChangeLine'+aFilhas[nAbaAtu], 'L')
		endif		
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama o ponto de entrada de mudanca de aba, so chama se o 'tudook'ณ
	//ณdo get retornar true                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lOnChangeAba .AND. ExistPe('onChangeAba') .AND. oTFolder:nOption <> nAbaAtu
		lOnChangeAba	:= ExecPe('onChangeAba', 'L')
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe permitir mudar de aba, atualiza o nAbaAtu com a nova abaณ
	//ณSe nao permitir, retorna para a aba anterior               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if !lOnChangeAba
		oTFolder:nOption	:= nAbaAtu
	else
		nAbaAtu	:= oTFolder:nOption
	endif
Return .T.

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณVldArray  บAutor  ณGeorge Allan        บ Data ณ  05/10/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFaz validacoes basicas nos arrays passados para o modeloaba บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function VldArray()
	local i, j, y, z, cIndice, cCampoAux
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se ha alguma inconsistencia entre o aOrdem e o _aChaveณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for i:= 1 to len(aFilhas)
		cIndice	:= ''    
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe for passado o nickname do indice, modifico para o numero deleณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		if ValType(aOrdem[i]) == 'C'
			if ! (aFilhas[i])->(dbOrderNickName(aOrdem[i]))
				MsgInfo("Indice " + aOrdem[i] + " nใo existe","Aviso")
				Return
			endif
			aOrdem[i] := (aFilhas[i])->(IndexOrd())
		endif
		if ValType(aOrdItem[i]) == 'C'
			if !(aFilhas[i])->(dbOrderNickName(aOrdItem[i]))
				MsgInfo("Indice " + aOrdItem[i] + " nใo existe","Aviso")
				Return
			endif
			aOrdItem[i]	:= (aFilhas[i])->(IndexOrd())
		endif		
		if _aChave[i] <> nil
			for j:= 1 to len(_aChave[i])
				cIndice	+= iif(j<>1,'+','') + _aChave[i][j][1]
			next
			nOrdemAux	:= &(aFilhas[i])->(IndexOrd())
			&(aFilhas[i])->(dbSetOrder(aOrdItem[i]))

			cIndiceTMP	:= &(aFilhas[i])->(IndexKey())
			cIndiceTMP:=StrTran(cIndiceTMP,'DTOS(','')
			cIndiceTMP:=StrTran(cIndiceTMP,')','')
			if ! (cIndice $ cIndiceTMP)
//			if ! (cIndice $ &(aFilhas[i])->(IndexKey()))
				MsgInfo("Ajuste o _aChave do " + aFilhas[i] + ", nใo estแ batendo com o indice escolhido no aOrdItem " + chr(13) + chr(10);
						+ " indice informado no _aChave: " + cIndice + chr(13) + chr(10);
						+ " indice escolhido no aOrdem: " + AllTrim(Str(aOrdItem[i])) + chr(13) + chr(10);
						+ " com conteudo: " + cIndiceTMP,"Aviso")
				Return .F.
			endif                                 
		endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณOs campos sequenciais sao obrigatorios, tem de haver ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if !aReadOnly[i] .AND. (aIniPos[i] == nil .or. Empty(aIniPos[i]))
			MsgInfo("ษ obrigat๓rio a aba ter um campo 'sequencial', preencha no aIniPos com a sintaxe similar a "+  chr(13) + chr(10);
					+ " aAdd(aIniPos , ZCE_SEQ )","Aviso")
			Return
		endif    

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida se os campos de filtro entre abas estao marcados como ณ
		//ณusados e sao reais                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*		for j:= 1 to len(aFiltro)
			for y:= 1 to len(aFiltro[j][3])
				for z:= 1 to 2
					cCampoAux	:= aFiltro[j][3][y][z]
					InfoSX3(cCampoAux)
					if ! X3USO(SX3->X3_USADO) .OR. SX3->X3_CONTEXT $ ('rR') 
						MsgInfo("Campo " + cCampoAux + " tem de ser marcado como usado e ser contexto real","Aviso")
						Return .F.
					endif
				next
			next
		next
*/		
		&(aFilhas[i])->(dbSetOrder(nOrdemAux))
	next
Return .T.
                                                 
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณCalcTotal บAutor  ณGeorge Allan        บ Data ณ  21/10/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao auxiliar que atualiza no cabecalho um campo totali-  บฑฑ
//ฑฑบ          ณzador que depende dos itens.                                บฑฑ
//ฑฑบ          ณPara utiliza-la coloque como um gatilho do campo que esta   บฑฑ
//ฑฑบ          ณsendo alterado para o campo que esta sendo alterado         บฑฑ
//ฑฑบ          ณExemplo, o campo total do SC6 (C6_TOTAL) deve ir para o     บฑฑ
//ฑฑบ          ณC5_TOTALC6. Entao, no campo C5_QTD devemos criar um gatilho บฑฑ
//ฑฑบ          ณapontando para ele mesmo com a funcao u_calctotal('C5_TOTAL'บฑฑ
//ฑฑบ          ณ,'C6_TOTAL), teriamos de fazer isso para o C6_VLRUNIT tambemบฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function CalcTotal(cCampoDestino, cCampoOrigem, _aAuxHeader, _aAuxCols, cCondicao)
	private y                       
	private nTotal			:= 0
	Default _aAuxHeader	:= aHeader
	Default _aAuxCols		:= aCols
	Default cCondicao		:= '.T.'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExemplo do parametro cCondicao:                                        ณ
//ณAllTrim(gdFieldGet('ZZT_TIPO',y,,oGet01:aHeader, oGet01:aCols)) == 'FI'ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For y := 1 to Len(_aAuxCols)           
		 // Se nใo estiver deletado soma.
		if !_aAuxCols[y][Len(_aAuxHeader)+1] .AND. &(cCondicao)
			nTotal += gdFieldGet(cCampoOrigem,y,.F., _aAuxHeader, _aAuxCols)
		EndIf
	Next  

	M->&(cCampoDestino)	:= nTotal
	oEnchoice:Refresh()
//	GetDRefresh()
Return M->&(ReadVar())

Static Function Ref
	
Return .t.
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณDelCDom   บAutor  ณGeorge Allan        บ Data ณ  25/10/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao auxiliar chamada a cada tentativa de delecao de uma  บฑฑ
//ฑฑบ          ณlinha do array                                              บฑฑ
//ฑฑบ          ณEsta funcao verifica se o item do get que esta sendo deleta-บฑฑ
//ฑฑบ          ณdo tem filhos, e se algum dos filhos estiver 'desdeletado'  บฑฑ
//ฑฑบ          ณa funcao nao deixa deletar a linha.                         บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function DelCDom()
	local cGetAtu	:= 'oGet' + StrZero(nAbaAtu, 2)
	local nCDom		:= 0
	local cGetCDom
	local i          
	local lPodeApagar	:= .T. 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe for uma delecao (eh que pode haver a desdelecao tb) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	local lEstaDeletando := !(&cGetAtu:aCols[&cGetAtu:nAt][len(&cGetAtu:aHeader)+1])

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se tem contra dominioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nCDom		:= TemDomCdom(&(cGetAtu):aHeader[1][2], 1)
	if nCDom == 0
		Return .T.
	endif
	cCDom		:= aFiltro[nCDom][2]
	nPosCDom	:= aScan(aFilhas, {|aX| Upper(aX) == Upper(cCDom)})
	cGetCDom	:= 'oGet' + StrZero(nPosCDom, 2)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVarre a tabela filha verificando se tem algum item nao deletado (vivo)ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for i:= 1 to len(&cGetCDom:aCols)
		if !&cGetCDom:aCols[i][len(&cGetCDom:aHeader)+1]
			lPodeApagar	:= .F.
		endif
	next                                                                      
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe houver pelo menos um item nao deletado nos filhos, entao nao permite        ณ
	//ณdeletar o pai                                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if !lPodeApagar
		MsgAlert("Nใo ้ possํvel apagar, item tem filhos","Aviso")
	endif
Return lPodeApagar

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณInicGrid  บAutor  ณGeorge Allan        บ Data ณ  26/10/10   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณFuncao auxiliar utilizada em inicializador padrao de grid   บฑฑ
//ฑฑบ          ณNormalmente ela eh utilizada quando o inicializador do campoบฑฑ
//ฑฑบ          ณdepende da linha superior da grid.                          บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function InicGrid(cGet, cCampo)
	local nLinhaAtual
	local cResult		:= ''
	if oDlg:lCentered // se o dialogo estiver ativo (tenho de procurar a propriedade que indica isso, por enquanto uso o centered
		nLinhaAtual	:= len(&cGet:aCols)
  		if nLinhaAtual > 1
			cResult	:= GdFieldGet(cCampo)
		endif
	endif                   
Return cResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ COPIAABA บ Autor ณ George Allan       บ Data ณ  10/08/12   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Fun็ใo fazer a copia                                       บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function COPIAABA(cFunction, lQuestion, aFieldsCopia)
	Static lCopia			:= .F.
	default lQuestion		:= .T.
	default aFieldsCopia	:= {}
	
	if lQuestion .AND. !MsgYesNo('Deseja fazer uma copia?')
		Return .F.
	endIf
	
	lCopia	:= .T.
	U_modeloaba(4, cFunction, aFieldsCopia)
	lCopia	:= .F.
Return .T.    

User Function ModeAbaExe(cComando)

&(cComando)

Return
