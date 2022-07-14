#INCLUDE "PROTHEUS.CH"
#Include "rwmake.ch"
#Include "colors.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		 	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4
#Define ENTER CHAR(13) + CHAR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RCIMPCTG ºAutor  ³Jackson Santos         Data ³  13/10/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para Ajustar Custo na SB9                         º±±
±±º          ³ 	 a partir de uma planilha em excel
Layout - Coluna A Filial
		 Coluna B Código do Produto / Sku 				
		 Coluna C Armzaem		  	                                    º±±
         Coluna D Valor do Custo        
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCAJCUST()
Local oDlg
Local oBtn1, oBtn2
Private cNomArq := "", cCmpArq := "", oSayTrN		// Variáveis do arquivo a ser importado
Private cNumDocum := PADR("Plan1",20)
//Private _aOpcao	  := {"1-Gravar SB1/SB4","2-Grv SB1/SB4/ZZ3"}
Private _cTipoImp := "1-Gravar SB1/SB4" 

Private oCbx,oGet1,oGet2,oGet3

DEFINE MSDIALOG oDlg TITLE "Importação-Ajusta Custo SB9" FROM C(0),C(0) TO C(220),C(450) PIXEL

@ C(015),C(010) Say "Nome Aba:" Size C(024),C(015) COLOR CLR_BLACK PIXEL OF oDlg
@ C(016),C(040) MsGet oGet1 Var cNumDocum Picture "@!" Size C(180),C(010) COLOR CLR_BLACK PIXEL OF oDlg

//@ C(031),C(010) Say "Tipo Imp." Size C(024),C(015) COLOR CLR_BLACK PIXEL OF oDlg
//@ C(035),C(040) COMBOBOX oCbx Var _cTipoImp ITEMS _aOpcao When .F. Size C(080),C(027) PIXEL //Of oDlg


@ C(075),C(010) Say "Layout: Col.A = Filial Col.B=Cod. Produto, Col.C = Armazem Col.D = Valor " Size C(180),C(008) COLOR CLR_HBLUE PIXEL OF oDlg

oBtn1:=tButton():New(C(092),C(015),'Iniciar Processo',oDlg,{||Valida(oDlg)},50,20,,,,.T.)
oBtn2:=tButton():New(C(092),C(085),'Fechar',oDlg,{||oDlg:End()},50,20,,,,.T.)

ACTIVATE MSDIALOG oDlg CENTERED
Return Nil


/*
 Validação se o arquivo foi selecionado antes de iniciar a  
 importação dos dados                                       
*/
Static Function Valida(oDlg)

Local 	nI		 :=0
Private nImports := 0
Private nLin     := 0
Private aTotal   := {}
Private nQtdOk	 := 0
Private aErros 	 := {}
Private aGrvDados:= {} 
Private cPatch	 := "C:\LOGIMPORT\"
Private cArq	 := ""
Private _ArqTemp1		
Private aStru	 := {}

IF !fVincArq()
	Alert("Arquivo não encontrado!")
	Return
EndIf

//MsgRun("Importando verbas...","Processando Importação",{|| Importa() })  
Processa({|| Importa(), "Importando registros "})

If Len(aErros) > 0
   	aadd(aStru,{"FILIAL"	,"C",04,0})
	aadd(aStru,{"PRODUTO"	,"C",15,0})
	aadd(aStru,{"ARMAZEM"	,"C",02,0})	
	aadd(aStru,{"VALORC"	,"N",10,2})
	aadd(aStru,{"MENSAGEM" 	,"C",100,0})
	
	_ArqTemp1 := CriaTrab( aStru, .T. )
	If Select("TMPEXC") > 0 
		TMPEXC->(DbCloseArea())
	EndIf
	DbUseArea( .T. ,, _ArqTemp1 , "TMPEXC", .F. , .F. )
    
	For nI := 1 To Len(aErros)
		RecLock("TMPEXC",.T.)	
          TMPEXC->FILIAL   := aErros[ni][1] 
		  TMPEXC->PRODUTO  := aErros[ni][2]
		  TMPEXC->ARMAZEM  := aErros[ni][3] 
		  TMPEXC->VALORC   := aErros[ni][4]		  
		TMPEXC->(MSUNLOCK())
	Next nI
	
	cArq  := _ArqTemp1+".DTC"
	lExistDir := ExistDir(cPatch) 

	If !lExistDir
		nRet := makeDir( cPatch )
    	If nRet != 0
    		MsgAlert("Não Foi Possivel Criar o Diretório '" + cPatch + " , o Arquivo Será Gravado no Temp do Usuário","Alerta Diretório")
    		cPatch := AllTrim(GetTempPath())
   		EndIf
	EndIf
	TMPEXC->(DbCloseArea())

	If ApOleClient("MsExcel")
	   
	   __CopyFIle(cArq , cPatch +"LOGIMP" + DTOS(DDATABASE) + ".CSV")
	   
	   oExcelApp:= MsExcel():New()
	   oExcelApp:WorkBooks:Open(cPatch+"LOGIMP" + DTOS(DDATABASE) + ".CSV")
	   oExcelApp:SetVisible(.T.)
	EndIf

EndIf
MsgInfo("O processo de ajuste foi concluído. Foram ajustados " + Alltrim(Str(nQtdOk)) + " de "  + Alltrim(Str(nImports))+ " registros.","Processo Concluído")
oDlg:End()

Return


/*
Funcao responsavel por manter o Layout independente da     
resolucao horizontal do Monitor do Usuario. 
*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf
Return Int(nTam)


/*
Vincula arquivo+localização completa do espelho da rota 
*/
Static Function fVincArq()
cCmpArq := cGetFile('Arquivos (*.*)|*.*' , 'Selecione o Arquivo a ser importado, formato XLS',1,'C:\',.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)

if Empty(cCmpArq)
	Return .F.
endif

cNomArq := fNomArq(cCmpArq, "\")	// Retorna o nome do arquivo

Return .T.


/*
Retorna parte do nome do arquivo digitalizado     
*/
Static Function fNomArq(cPar, cToken)
Local nPos  := 0
Local cFile := ""

if (nPos := RAT(cToken, StrTran(cPar,"/","\"))) != 0
	cFile := SubStr(cPar, nPos+1)
endif
Return cFile


/*
Visualiza arquivo da ser Importado para o Protheus       
*/
Static Function fVisualArq()
if !Empty(cCmpArq) .and. File(cCmpArq)	// Exibe arquivo não salvo
	ShellExecute("open",cCmpArq,"","",1)
	Return .T.
endif
Return Nil


/*
 Importação dos Registros...  abre arquivo EXCEL, trata e cadastrar nas tabelas                                       º±±
*/
Static Function Importa()


Local cBuffer	:= ''
Local cFile		:= ''
Local aCells	:= {} //array com as celulas a serem lidas
Local nI		:= 0
Local nCelini   := 2 //posicao da primeira celula com valor
Local cPasta    := cNumDocum //nome da pasta dentro da planilha
Local aplanilha :={}
Local nY		:= 0
Local nCont		:= 0
Private lGatilho := .F.
Private cMsg := ""
                   
cDir := substr(cCmpArq,1,RAT("\", StrTran(cCmpArq,"/","\")))   
cArqui := cNomArq  

cFile:= cDir + cArqui

nCont:=1
cMV_PLAN:=ALLTRIM(cArqui)
do while nCont<len(cMV_PLAN)
	nAt:=AT(";",SUBSTR(cMV_PLAN,nCont,len(cMV_PLAN)) )
	if nAt=0
		nAt:=len(cMV_PLAN)+1
	endif
	aAdd(aPlanilha,ALLTRIM(cDir)+substr(cMV_PLAN,nCont,nAt-1))
	nCont:=nAt+1
enddo

//Posiciona tabela de Produtos
SB1->(DbSetOrder(1))

FOR nCont:=1 to Len(aPlanilha)
	nHdl    := ExecInDLLOpen("C:\DLL\readexcel.dll")
	cBuffer := ''
	nCelini := 2  //posicao da primeira celula com valor
	
	cFile	:= aPlanilha[nCont]
	aCells	:= {}
	
	// Monta array das celulas que serao lidas
	Aadd(aCells,{  'A'+alltrim(str(nCelini)),'B'+alltrim(str(nCelini)),'C'+alltrim(str(nCelini)),'D'+alltrim(str(nCelini)),;
	'E'+alltrim(str(nCelini)),'F'+alltrim(str(nCelini)),'G'+alltrim(str(nCelini)),'H'+alltrim(str(nCelini)),'I'+alltrim(str(nCelini)),;
	'J'+alltrim(str(nCelini)),'K'+alltrim(str(nCelini)),'L'+alltrim(str(nCelini)),'M'+alltrim(str(nCelini))} )
                                                                                                                     
	If ( nHdl >= 0 )
		
		// Carrega o Excel e Abre o arquivo
		cBuffer := cFile + Space(512)
		nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
		
		If ( nBytes < 0 )
			// Erro critico na abertura do arquivo sem msg de erro
			MsgStop('Não foi possivel abrir o arquivo : ' + cFile)
		ElseIf ( nBytes > 0 )
			// Erro critico na abertura do arquivo com msg de erro
			MsgStop(Subs(cBuffer, 1, nBytes))
		EndIf
		
		// Seleciona a worksheet
		cBuffer := cPasta + Space(512)
		ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)
		
		nI := 2
		lContinua := .T.
		IncProc( "Lendo dados da planilha para importar...Aguarde..." )
		Do while lContinua
                                           
			lErro := .F.
            
            cBuffer := 'A'+ALLTRIM(STR(nI)) + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			cFilialA := Alltrim(Subs(cBuffer, 1, nBytes))			

			cBuffer := 'B'+ALLTRIM(STR(nI)) + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			cProduto := Alltrim(Subs(cBuffer, 1, nBytes))			

						
			If Empty(Alltrim(cProduto))	
				lContinua := .F.
				Loop
			EndIF			

			cBuffer := 'C'+ALLTRIM(STR(nI)) + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			cArmazem := Alltrim(Subs(cBuffer, 1, nBytes))
			
			
			cBuffer := 'D'+ALLTRIM(STR(nI)) + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			nValorc :=  Val(STRTRAN(Alltrim(Subs(cBuffer, 1, nBytes)),",","."))
		  	
		          	
			lProdOk := .F.
			//lCategOk:= .F.		
						
			SB1->(dbsetorder(1))
			IF !SB1->(dbseek(xFilial("SB1")+PADR(Alltrim(cProduto),TAMSX3("B1_COD")[1])))				    	
				lProdOk := .F.                     
			Else
				lProdOk := .T.								
    		EndIf 

			
    		
            If lProdOk        				
				AaDd(aGrvDados,{cFilialA,PADR(Alltrim(cProduto),TAMSX3("B1_COD")[1]),cArmazem,nValorc})
			   	nQtdOk ++
			Else           
				
				AaDd(aErros,{cFilialA,PADR(Alltrim(cProduto),TAMSX3("B1_COD")[1]),cArmazem,nValorc,"CODIGO DE PRODUTO NAO ENCONTRADO NA SB1"})					
				
			EndIf		
			
			nImports++
			nI++
		Enddo
		
		// Fecha o arquivo e remove o excel da memoria
		cBuffer := Space(512)
		ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
		
		ExecInDLLClose(nHdl)
		IncProc( "Iniando Importação para o sistema. Serão processados " + Alltrim(STR(nImports)) + " Registros ")

		If Len(aGrvDados)  >0 
			lOkTran	:= .T.                     
			
			//lOkCpoSB4 := (SB4->(FieldPos("B4_XBKCTG1")) > 0)
			
			//Abertura das tabelas com Indice já setado.
			SB1->(DbSetOrder(1))	
			
            //Abertura de transação para que seja consistido a gravação de todos os dados
			//validos.
			Begin Transaction 
			
			For nY := 1 to Len(aGrvDados)				           
				IncProc( "Importando  " + aGrvDados[ny][1] + "-" + aGrvDados[ny][2]  )
			
            	lAchouSB1 := SB1->(DbSeek(xFilial("SB1") + PADR(Alltrim(aGrvDados[nY][2]),TamSx3("B1_COD")[1])))
				lAchouSB9 := SB9->(DbSeek(aGrvDados[ny][1] + aGrvDados[ny][2] + aGrvDados[ny][3] + DTOS(DDATABASE)))
                lAchouSB2 := SB2->(DbSeek(aGrvDados[ny][1] + aGrvDados[ny][2] + aGrvDados[ny][3]))
                //Sempre posicionar nas 3 tabelas para fazer a movimentação.
                IF lAchouSB1 .And. lAchouSB9 .And. lAchouSB2
                    //Ajustar SB9 conforme data base do sistema.
                    RECLOCK("SB9",.F.)
                        SB9->B9_CM1     := aGrvDados[ny][4]
                        SB9->B9_VINI1   := SB9->B9_QINI * aGrvDados[ny][4]
                    SB9->(MsUnlock())
                    //Ajusta a SB2 para corrigir movimentações
                    RECLOCK("SB2",.F.)
                        SB2->B2_CMFIM1 := SB9->B9_CM1
                        SB2->B2_VFIM1  := SB2->B2_QFIM * aGrvDados[ny][4]
                     SB2->(MsUnlock())

                    lOkTran := .T. 	
                Else
                    lOkTran := .F.
                    DisarmTransaction()	
                EndIf		
				
				If !lOkTran
					MsgStop("Houve erro na transação, o movimento foi Desfeito","Erro de Gravação")
					EXIT
				EndIf
		   	Next nY   

		   	End Transaction        
		   	 
			If lOkTran		  
				DbCommitAll()
			EndIf	
		   	 
		Else
		    MsgStop("Não há dados válidos a serem processados, favor verificar","Sem Dados Validos") 
			EXIT
		EndIf

		If Len(aErros) > 0 
			MsgAlert("Foram encontrados erros nos dados da planilha, favor verificar o log.")
		EndIf
	Else
		MsgStop('Nao foi possivel carregar a DLL',"Erro Dll")
		EXIT
	EndIf
NEXT
       

Return Nil                                       


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCTION RETCHAR              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function RETCHAR(cString)
	Local cChar  	:= ""
	Local cTraco	:= "-"
	Local cPonto	:= "."
    Local nC		:= 0
    
	For nC := 1 To Len(cString)
		cChar := SubStr(cString, nC, 1)
		If cChar $ cTraco+cPonto
		
			nY := At(cChar,cTraco)
			If nY > 0
				cString := StrTran(cString,cChar,"")
			EndIf
	
			nY := At(cChar,cPonto)
			If nY > 0
				cString := StrTran(cString,cChar,"")
			EndIf
	    EndIf
	Next nC

Return cString


