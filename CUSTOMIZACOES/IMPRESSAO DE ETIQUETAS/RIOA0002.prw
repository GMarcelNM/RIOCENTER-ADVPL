#Include "Protheus.Ch"
#Include "TopConn.Ch"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA0002  � Autor � Sidney Sales       � Data �  13/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � MarkBrowse para impressao de etiquetas de produtos.        ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA0002()
Local _astru		:= {}
Local _afields		:= {}
Local _carq
local i
Private oMark
Private arotina 	:= {}
Private cMark		:= GetMark()
Private cCadastro
Private cPerg		:= ''

aRotina   			:= { 	{ "&Incluir produto"	,"U_RIOA002f(3)" , 0, 3},;
							{ "Importar Nota"		,"U_RIOA002g" , 0, 3},;
							{ "Marcar Todos" 		,"U_RIOA002b" , 0, 4},;
							{ "Desmarcar Todos"		,"U_RIOA002c" , 0, 4},;
							{ "Inverter Todos"		,"U_RIOA002d" , 0, 4},;
							{ "Confirmar" 		  	,"U_RIOA002a" , 0, 4}}

//�����������������������������������������������������������������������������������������Ŀ
//�Estrutura da tabela temporaria que sera utilizada para realizar a impressao das etiquetas�
//�������������������������������������������������������������������������������������������
AADD(_astru,{"Z1_OK"	 ,"C",02	,0})
AADD(_astru,{"Z1_COD"	 ,"C",15	,0})
AADD(_astru,{"Z1_LOCAL"	 ,"C",02	,0})
AADD(_astru,{"Z1_QTD"	 ,"N",10	,0})
AADD(_astru,{"Z1_DESC"	 ,"C",80	,0})
AADD(_astru,{"Z1_COLEC"	 ,"C",30	,0})
AADD(_astru,{"Z1_VUNIT"	 ,"N",14	,2})
AADD(_astru,{"Z1_COR"	 ,"C",15	,0})
AADD(_astru,{"Z1_TAMANHO","C",08	,0})

//_cArq:="T_"+Criatrab(,.F.)
//MsCreate(_carq,_astru,"DBFCDX")

 // --- Criar tabela tempor�ria
 // ---------------------------
  oTempTable := FWTemporaryTable():New("TRB")
  oTemptable:SetFields(_astru)
  oTempTable:AddIndex("01",{"Z1_COD","Z1_LOCAL"})
  oTempTable:Create()

DBSELECTAREA("TRB")

//���������������������������������������Ŀ
//�Monta os fields da tabela e a descricao�
//�����������������������������������������
AADD(_afields,{"Z1_OK"		,"",""				})
AADD(_afields,{"Z1_COD"		,"","C�d. Produto"	})
AADD(_afields,{"Z1_LOCAL" 	,"","Local"			})
AADD(_afields,{"Z1_QTD"	   ,"","Quantidade"	})
AADD(_afields,{"Z1_DESC"	,"","Descri��o"		})
AADD(_afields,{"Z1_COLEC"	,"","Cole��o"		})
AADD(_afields,{"Z1_VUNIT"	,"","Valor","@e 999,999,999.99"			})
AADD(_afields,{"Z1_COR"	    ,"","Cor"			})
AADD(_afields,{"Z1_TAMANHO"	,"","Tamanho",		})

DbSelectArea("TRB")
DbGotop()

//������������������������������Ŀ
//�Monta a tela com o MarkBrowser�
//��������������������������������
MarkBrow( 'TRB', 'Z1_OK',,_afields,, cMark,'u_RIOA002d()',,,,'u_RIOA002f(4)',{|| u_RIOA002d()},,,,,,,.F.)

//�������������������Ŀ
//�Fecha a area criada�
//���������������������
DbCloseArea()

//���������������������������������Ŀ
//�Apaga o arquivo temporario criado�
//�����������������������������������
//MsErase(_carq+GetDBExtension(),,"DBFCDX")
//FWTemporaryTable():Delete()
oTempTable:Delete()
Return

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA002b  � Autor � Sidney Sales       � Data �  19/07/12   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Marca todos os registros.                                  ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002b()
Local oMark := GetMarkBrow()
DbSelectArea("TRB")
DbGotop()
While !Eof()
	IF RecLock( 'TRB', .F. )
		TRB->Z1_OK := cMark
		MsUnLock()
	EndIf
	dbSkip()
Enddo
MarkBRefresh( )
// for�a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
return

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA002c   � Autor � Sidney Sales       � Data �  19/07/12   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Desmarcar todos os itens.                                  ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002c()
Local oMark := GetMarkBrow()
DbSelectArea("TRB")
DbGotop()
While !Eof()
	IF RecLock( 'TRB', .F. )
		TRB->Z1_OK := SPACE(2)
		MsUnLock()
	EndIf
	dbSkip()
Enddo

MarkBRefresh( )

// for�a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return
// Grava marca no campo

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |DESMAR    � Autor � Sidney Sales       � Data �  19/07/12   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Marca o registro como selecionado ou nao.                  ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002e()
	If IsMark( 'Z1_OK', cMark )
		RecLock( 'TRB', .F. )
		Replace Z1_OK With Space(2)
		MsUnLock()
	Else
		RecLock( 'TRB', .F. )
		Replace Z1_OK With cMark
		MsUnLock()
	EndIf
Return

// Grava marca em todos os registros validos
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA002d   � Autor � Sidney Sales       � Data �  19/07/12   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Desmarcar todos os itens.                                  ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002d()
Local oMark := GetMarkBrow()
dbSelectArea('TRB')
dbGotop()
While !Eof()
	U_RIOA002e()
	dbSkip()
Enddo
MarkBRefresh( )
// for�a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} RIOA002a()
  Confirmar imprimindo as etiquetas dos itens marcados.
  						  
  @Parametro: oModel = Objeto pra pegar os dados
  @author Anderson Almeida (TOTVS NE)
  @version P12.1.17
  @since  13/01/2020	
/*/
//-------------------------------------------------------------------
User Function RIOA002a()
  Local oMark   := GetMarkBrow()
  Local aRet	:= {}
  Local cModelo	:= ""
  Local cVerDiverg := GETMV("MV_BLQDIV")
  Local cExcBloq := GETMV("MV_BLQETI")


  dbSelectArea("TRB")
  TRB->(dbGoTop())

  While !Eof()
	If IsMark("Z1_OK",cMark)
	   aAdd(aRet, {TRB->Z1_COD, TRB->Z1_QTD, TRB->Z1_DESC, TRB->Z1_COR, TRB->Z1_TAMANHO})
	EndIf

	TRB->(dbSkip())
  EndDo

  If Len(aRet) == 0
     Alert("Selecione pelo menos um produto para impress�o.","ATEN��O")
	 Return
  EndIf

  cPerg	:= "U_RIOA002a"

  ValidPerg()

  If !(Pergunte(cPerg,.T.))
	 Return
  EndIf
 
  If MV_PAR03 == 1
 	 cModelo := 'ZEBRA'

   elseIf MV_PAR03 == 2
	      cModelo := 'ALLEGRO'

     elseIf MV_PAR03 == 3
	        cModelo := 'ELTRON'
  EndIf


  	iF cVerDiverg == "SIM"
        If U_RIOA002h(aRet)
           return
        ENDIF
  	ENDIF

  	iF cExcBloq == "SIM"
        If U_RIOA002i(aRet)
           return
        ENDIF
  	ENDIF

  if MV_PAR04 == 1
    U_RIOF0006(aRet, MV_PAR01, 'LPT'+cValToChar(MV_PAR02), cModelo)    // Chama rotina que fara a impressao das etiquetas
  else
//    U_RIOF06V2(aRet, MV_PAR01, 'LPT'+cValToChar(MV_PAR02), cModelo)    // Chama rotina que fara a impressao das etiquetas novas
     U_RIOF06V3(aRet, MV_PAR01, 'LPT'+cValToChar(MV_PAR02), cModelo)    // Chama rotina que fara a impressao das etiquetas novas
  EndIf

Return

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA002f  � Autor � Sidney Sales       � Data �  13/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Funcao que abre uma tela para incluir novos produtos ou    ���
//���          �editar a quantidade dos produtos do browser                 ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002f(nTipo)
Private oDlg
Private _oProduto
Private _cProduto	:= Space(Len(SB1->B1_COD))
Private _oQtd
Private _nQtd		:=	0
Private _oLocal
Private _cLocal	:= Space(2)
Private _lCheck	:= .T.
Private oCheck

//����������������������������������������������������������������eL�
//�Caso seja alteracao, entao preenche as variaveis com o conteudo�
//�da tabela temporaria no item atual                             �
//����������������������������������������������������������������eL�
If nTipo == 4
	_cProduto	:= TRB->Z1_COD
	_nQtd			:= TRB->Z1_QTD
	_lCheck		:= ! Empty(TRB->Z1_OK)
	_cLocal		:=	TRB->Z1_LOCAL
Endif

//������������������������������������Ŀ
//�Monta a tela para inclusao/alteracao�
//��������������������������������������
DEFINE DIALOG oDlg TITLE "            ESCOLHA DE PRODUTO            " FROM 180,180 TO 350,400 PIXEL STYLE DS_MODALFRAME

@ 010,005 Say "PRODUTO:" Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 005,040 MsGet _oProduto Var _cProduto Size 50,015  COLOR CLR_BLACK PIXEL OF oDlg F3 "SB1" VALID VerProd(_cProduto, nTipo)

@ 030,005 Say "QUANTIDADE:" Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 025,040 MsGet _oQtd Var _nQtd Size 50,015  COLOR CLR_BLACK PIXEL OF oDlg  PICTURE "@E 9999999999" Valid IIf(_nQtd>0,.T.,.F.)

@ 050,005 Say "LOCAL:" Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 045,040 MsGet _oLocal Var _cLocal Size 50,015  COLOR CLR_BLACK PIXEL OF oDlg

@ 060,005 checkbox _oCheck Var _lCheck PROMPT "Imprime?" Size 50,015 OF oDlg PIXEL //On Change Alert(cValToChar(_lCheck))
@ 070,030 Button 	 "Confirmar" Size 050,12 PIXEL OF oDlg Action Grava(_cProduto, _nQtd, _lCheck, nTipo,_cLocal)

ACTIVATE DIALOG oDlg CENTERED

Return

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |Grava     � Autor � Sidney Sales       � Data �  13/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Funcao que fara a gravacao do produto no arquivo temporario���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
Static Function Grava(cCod, nQtd, _lCheck, nTipo, cLocal)
Local cColec
Local nValor := 0
  Local cQuery := ""

SB1->(DBSETORDER(1))
//��������������������������������������Ŀ
//�Verifica se digitou um produto correto�
//����������������������������������������
if SB1->(DBSEEK(xFilial('SB1') + Padr(Alltrim(cCod),Len(SB1->B1_COD))))

	//�������������������������������������������������Ŀ
	//�Procura na tabela temporaria se existe o registro�
	//���������������������������������������������������
	If TRB->(DBSEEK(SB1->B1_COD + cLocal))
		//������������������������������������������������������������������������Ŀ
		//�Se o tipo for 3(inclusao) entao verifica o saldo da quantidade digitada �
		//�digita mais a quantidade que ja existe na grade, caso tenha saldo entao �
		//�grava a quantidade que ja tem, mais a digititada                        �
		//��������������������������������������������������������������������������
		If nTipo == 3
			//���������������������������Ŀ
			//�Verifica o saldo do produto�
			//�����������������������������
			If ! VerSaldo(SB1->B1_COD, cLocal, nQtd + TRB->Z1_QTD)
				Return
			Endif
			RECLOCK("TRB",.F.)
			TRB->Z1_QTD	+= nQtd
			TRB->(MsUnLock())
			//��������������������������������������������������������������������������Ŀ
			//�Se nao for tipo 3 sera tipo 4, entao eh alteracao e inclui um novo produto�
			//����������������������������������������������������������������������������
		Else
			//���������������������������Ŀ
			//�Verifica o saldo do produto�
			//�����������������������������
			If ! VerSaldo(SB1->B1_COD, cLocal, nQtd)
				Return
			Endif
			RECLOCK("TRB",.F.)
			TRB->Z1_QTD	:= nQtd
			TRB->Z1_OK		:= Iif(_lCheck,cMark,Space(2))
			TRB->(MsUnLock())
		Endif

	Else

		//����������������������������������������������������������Ŀ
		//�Se nao tiver sido incluso ja, entao inclui um novo produto�
		//������������������������������������������������������������
		If ! VerSaldo(SB1->B1_COD, cLocal, nQtd)
			Return
		Endif

		//�������������������������������������������������������������H�
		//�Verifica se esta utilizando o cenario de vendas, caso esteja�
		//�pega da tabela definida no parametro de tabela padrao       �
		//�������������������������������������������������������������H�
		If GetMV('MV_LJCNVDA')
			DA1->(DBSETORDER(1))
			if DA1->(DBSEEK(xFilial('DA1') + PADR(GetMv('MV_TABPAD'),3) + Padr(Alltrim(cCod),Len(SB1->B1_COD))))
				nValor := DA1->DA1_PRCVEN
			Endif
			
			cQuery := "Select Min(DA1.DA1_PRCVEN) as PRECO from " + RetSqlName("DA1") + " DA1, " + RetSqlName("DA0") + " DA0"
            cQuery += "  where DA1.D_E_L_E_T_ = ' '"
            cQuery += "    and DA1.DA1_CODPRO = '" + Padr(Alltrim(cCod),Len(SB1->B1_COD)) + "'"
            cQuery += "    and DA1.DA1_DATVIG <= '" + DToS(dDataBase) + "'"
            cQuery += "    and DA0.D_E_L_E_T_ = ' '"
            cQuery += "    and DA0.DA0_FILIAL = DA1.DA1_FILIAL"
            cQuery += "    and DA0.DA0_CODTAB = DA1.DA1_CODTAB"
            cQuery += "    and DA0.DA0_DATDE <= '" + DToS(dDataBase) + "'"
            cQuery += "    and (DA0.DA0_DATATE >= '" + DToS(dDataBase) + "' or DA0.DA0_DATATE = ' ')"
		
		    cQuery := ChangeQuery(cQuery)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QDA1",.F.,.T.)
            
            If ! QDA1->(Eof())
               nValor := QDA1->PRECO
            EndIf
            
            QDA1->(dbCloseArea())		
		Else
			nValor := PrecoSemPromocao(SB1->B1_COD)
			If nValor == 0
				SB0->(DbSetOrder(1))
				SB0->(DbSeek(xFilial('SB0') + SB1->B1_COD))
				nValor	 := SB0->B0_PRV1
			EndIf
		Endif

		//�������������������������������������Ŀ
		//�Grava o registro na tabela temporaria�
		//���������������������������������������
		RECLOCK("TRB",Iif(nTipo == 3, .T.,.F.))
		TRB->Z1_COD		:= SB1->B1_COD
//		TRB->Z1_DESC	:= SB1->B1_DESC
		TRB->Z1_DESC	:= REPLACE(SB1->B1_DESC, ALLTRIM(SB1->B1_01DREF), "")
		TRB->Z1_QTD 	:= nQtd
		TRB->Z1_OK		:= Iif(_lCheck,cMark,Space(2))
		TRB->Z1_LOCAL	:= cLocal
		TRB->Z1_VUNIT	:= nValor


		SB4->(DbSetOrder(1))
		SB4->(DbSeek(xFilial('SB4') + SB1->B1_01PRODP))

		AYH->(DbSetOrder(1))

		If AYH->(DbSeek(xFilial('AYH') + SB4->B4_01COLEC))
			cColec := AYH->AYH_DESCRI
		Else
			cColec := 'NAO DEFINIDO'
		EndIf

		TRB->Z1_COLEC	:= cColec

       // --- Pegar a Cor
       // ---------------
        DbSelectArea("SBV")
        SBV->(dbSetOrder(1))
        
        If SBV->(dbSeek(xFilial("SBV") + SB4->B4_LINHA + SB1->B1_01LNGRD))
           TRB->Z1_COR := AllTrim(SBV->BV_DESCRI)
        EndIf

       // --- Pegar o Tamanho
       // -------------------
        DbSelectArea("SBV")
        SBV->(dbSetOrder(1))
        
        If SBV->(dbSeek(xFilial("SBV") + SB4->B4_COLUNA + SB1->B1_01CLGRD))
           TRB->Z1_TAMANHO := AllTrim(SBV->BV_DESCRI)
        EndIf

		TRB->(MSUNLOCK())
	Endif

	//�����������������Ŀ
	//�Zera as variaveis�
	//�������������������
	_cProduto	:= Space(Len(SB1->B1_COD))
	_nQtd			:= 0
	_cLocal		:= Space(2)

	//������������������Ŀ
	//�Atualiza os campos�
	//��������������������
	_oLocal:Refresh()
	_oQtd:Refresh()
	_oProduto:Refresh()

	//������������������������Ŀ
	//�Coloca o foco no produto�
	//��������������������������
	_oProduto:SetFocus()

	//������������������������������������������������Ŀ
	//�Se o tipo for 4(alteracao) entao fecha o dialogo�
	//��������������������������������������������������
	If nTipo == 4
		oDlg:End()
	Else
		DbSelectArea("TRB")
		DbGoTop()
	Endif
Else
	Alert('Produto n�a cadatrado no protheus.')
Endif

//������������������Ŀ
//�Atualiza o browser�
//��������������������
oMark:oBrowse:Refresh()

Return



//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |PrecoSemPromocao  � Sidney Sales       � Data �  05/04/16   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Retorna o preco antes da alteracao, se o produto estiver   ���
//���          � em alguma promocao efetivada, retorna o preco 'atual' dele ���
//���          � que e' o preco antes da alteracao.                         ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
Static Function PrecoSemPromocao(cCodProduto)
	Local cQuery
	Local nRet	:= 0

	cQuery := " SELECT ZA4_STATUS, ZA5_CODPRO, ZA5_DESPRO, ZA5_PRCATU, ZA5_PRCNEW "
	cQuery += " FROM " + RetSqlName('ZA5') + " ZA5 "
	cQuery += " INNER JOIN " + RetSqlName('ZA4') + " ZA4 ON ZA5_FILIAL = ZA4_FILIAL AND ZA5_CODZA4 = ZA4_CODIGO "
	cQuery += " WHERE ZA5.D_E_L_E_T_ <> '*' "
	cQuery += " AND ZA4.D_E_L_E_T_ <> '*' "
	cQuery += " AND ZA4_STATUS = 'E' "
	cQuery += " AND ZA5_CODPRO = '" + cCodProduto + "' "

	If Select('QRY1') > 0
		QRY1->(DbCloseArea())
	EndIf

	TcQuery cQuery New Alias 'QRY1'

	If QRY1->(!Eof())
		nRet := QRY1->ZA5_PRCATU
	EndIf

Return nRet

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA002g  � Autor � Sidney Sales       � Data �  14/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Faz importacao da nota de entrada escolhida no parametro.  ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002g()
  Local nValor   := 0
  Local cLJCNVDA := GetMV('MV_LJCNVDA')
  
cPerg	:= "U_RIOA002g"
//������������������������������������������������Ŀ
//�Chama as perguntas pra digitar a nota de entrada�
//��������������������������������������������������
ValidPerg()

If !(Pergunte(cPerg,.T.))
	Return
EndIf

SF1->(DBSETORDER(1))


//����������������������������������Ŀ
//�Seta a nota escolhida no parametro�
//������������������������������������
If	! SF1->(DBSEEK(xFilial('SF1') + MV_PAR01 + MV_PAR02 + MV_PAR03 + MV_PAR04))
	Alert('Nota n�o localizada com os par�metros informados.')
Else

	//��������������������������������Ŀ
	//�Seta os itens da nota de entrada�
	//����������������������������������
	SD1->(DBSETORDER(1))
	SD1->(DBSEEK(cSeek := xFilial('SD1') + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
	SB1->(DBSETORDER(1))

	//���������������������������������������������Ŀ
	//�Percorre a tabela procurando os itens da nota�
	//�����������������������������������������������
	While SD1->(!Eof()) .AND. cSeek == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
		//�����������������������Ŀ
		//�Seta o produto da nota �
		//�������������������������
		SB1->(DBSEEK(xFilial('SB1') + SD1->D1_COD))

		//�������������������������������������������������������������������Ŀ
		//�Verifica se ja existe o produto + almoxarifado na tabela temporaria�
		//���������������������������������������������������������������������
		If TRB->(DBSEEK(SB1->B1_COD + SD1->D1_LOCAL))
			//����������������������������������������������������������������Ŀ
			//�Verifica se possui estoque da quantidade que ja tem na tabela   �
			//�temporaria mais a quantidade que esta na nota, se nao tiver pula�
			//������������������������������������������������������������������
			If ! VerSaldo(SD1->D1_COD, SD1->D1_LOCAL, SD1->D1_QUANT + TRB->Z1_QTD)
				SD1->(DBSKIP())
				loop
			Endif
			//���������������������������������Ŀ
			//�Grava o registro caso tenha saldo�
			//�����������������������������������
			RECLOCK("TRB",.F.)
			TRB->Z1_QTD	+= SD1->D1_QUANT
			TRB->(MsUnLock())
		Else
			//�����������������������������������������������������������������������Ŀ
			//�Se nao tiver na tabela temporaria entao verifica se tem saldo o produto�
			//�no local na quantidade informada, se nao tiver pula, se tiver grava    �
			//�������������������������������������������������������������������������
			If ! VerSaldo(SD1->D1_COD, SD1->D1_LOCAL, SD1->D1_QUANT)
				SD1->(DBSKIP())
				loop
			Endif

			//�������������������������������������������������������������H�
			//�Verifica se esta utilizando o cenario de vendas, caso esteja�
			//�pega da tabela definida no parametro de tabela padrao       �
			//�������������������������������������������������������������H�
			If cLJCNVDA
			//	DA1->(DBSETORDER(1))
			//	if DA1->(DBSEEK(xFilial('DA1') + Alltrim(GetMv('MV_TABPAD')) + Padr(Alltrim(SB1->B1_COD),Len(SB1->B1_COD))))
			//		nValor := DA1->DA1_PRCVEN
			//	Endif
               cQuery := "Select  Min(DA1.DA1_PRCVEN) as PRECO from " + RetSqlName("DA1") + " DA1, " + RetSqlName("DA0") + " DA0"
               cQuery += "  where DA1.D_E_L_E_T_ = ' '"
               cQuery += "    and DA1.DA1_CODPRO = '" + SB1->B1_COD + "'"
               cQuery += "    and DA1.DA1_DATVIG <= '" + DToS(dDataBase) + "'"
               cQuery += "    and DA0.D_E_L_E_T_ = ' '"
               cQuery += "    and DA0.DA0_FILIAL = DA1.DA1_FILIAL"
               cQuery += "    and DA0.DA0_CODTAB = DA1.DA1_CODTAB"
               cQuery += "    and DA0.DA0_DATDE <= '" + DToS(dDataBase) + "'"
               cQuery += "    and (DA0.DA0_DATATE >= '" + DToS(dDataBase) + "' or DA0.DA0_DATATE = ' ')"
    	
		       cQuery := ChangeQuery(cQuery)
               dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QDA1",.F.,.T.)
            
               If ! QDA1->(Eof())
                  nValor := QDA1->PRECO
               EndIf
            
               QDA1->(dbCloseArea())		
			Else
				nValor := PrecoSemPromocao(SB1->B1_COD)
				If nValor == 0
					SB0->(DbSetOrder(1))
					SB0->(DbSeek(xFilial('SB0') + SB1->B1_COD))
					nValor	 := SB0->B0_PRV1
				EndIf
			Endif

			RECLOCK("TRB",.T.)
			TRB->Z1_COD		:= SD1->D1_COD
            // TRB->Z1_DESC	:= SB1->B1_DESC
		    TRB->Z1_DESC    := REPLACE(SB1->B1_DESC, ALLTRIM(SB1->B1_01DREF), "")
			TRB->Z1_QTD 	:= SD1->D1_QUANT
			TRB->Z1_OK		:= cMark
			TRB->Z1_LOCAL	:= SD1->D1_LOCAL
			TRB->Z1_VUNIT	:= nValor
			SB4->(DbSetOrder(1))
			SB4->(DbSeek(xFilial('SB4') + SB1->B1_01PRODP))

			AYH->(DbSetOrder(1))

			If AYH->(DbSeek(xFilial('AYH') + SB4->B4_01COLEC))
				cColec := AYH->AYH_DESCRI
			Else
				cColec := 'NAO DEFINIDO'
			EndIf

			TRB->Z1_COLEC	:= cColec
 
           // --- Pegar a Cor
           // ---------------
            DbSelectArea("SBV")
            SBV->(dbSetOrder(1))
        
            If SBV->(dbSeek(xFilial("SBV") + SB4->B4_LINHA + SB1->B1_01LNGRD))
               TRB->Z1_COR := AllTrim(SBV->BV_DESCRI)
            EndIf

           // --- Pegar o Tamanho
           // -------------------
            DbSelectArea("SBV")
            SBV->(dbSetOrder(1))
        
            If SBV->(dbSeek(xFilial("SBV") + SB4->B4_COLUNA + SB1->B1_01CLGRD))
               TRB->Z1_TAMANHO := AllTrim(SBV->BV_DESCRI)
            EndIf

			TRB->(MSUNLOCK())
		Endif
		SD1->(DBSKIP())
	Enddo
Endif

//������������������Ŀ
//�Atualiza o browser�
//��������������������
DbSelectArea("TRB")
DbGoTop()
oMark:oBrowse:Refresh()
Return



//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA002h  � Autor � Glaudson Marcel    � Data �  29/09/21   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Funcao para verificar se h� diverg�ncia de codigos         ���
//���          �de barras ou codigo interno                                 ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002h(aItens)

    Local cQuery := ""
    Local cQuery2 := ""
	Local cTitulo := "Produtos com Diverg�ncia de Codifica��o "
	Local i := 0
    Local cCodEmp := ""
	Local cCodProd := ""	
    Local aDiverg := {} 
    Local aDuplic := {} 
	
	cCodEmp := FWGrpCompany()


	For i := 1 To Len(aItens)		
	 	cCodProd	:= cCodProd + "'" + AllTrim(aItens[i][1]) + "', "
    Next
          
	If cCodProd <> ""
	    cCodProd := SubStr( cCodProd, 1, len(cCodProd) - 2 )  
	Endif
    cQuery := "SELECT " 
    cQuery += "	     Legenda = CASE "
    cQuery += "		           WHEN (SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9)) THEN 'COD. BARRA DIFERENTE' "
    cQuery += "		           WHEN (SUBSTRING(b.B1_YCODBAR, LEN(b.B1_YCODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) AND (b.B1_YCODBAR <> '')) THEN 'INCONSISTENCIA EXTERNA' "
    cQuery += "		           WHEN (SUBSTRING(a.B1_YCODBAR, LEN(a.B1_YCODBAR) - 9, 9) <> SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) AND (a.B1_YCODBAR <> '')) THEN 'INCONSISTENCIA INTERNA' "
    cQuery += "		           WHEN (a.B1_DESC <> b.B1_DESC) THEN 'DIVERGENCIA DESCRICAO' "
    cQuery += "		           WHEN (b.B1_COD IS NULL) THEN 'PRODUTO INEXISTENTE' "
    cQuery += "                END, "
    cQuery += "     Codigo = a.B1_COD, Descricao = a.B1_DESC, CodBarra = a.B1_CODBAR "
    cQuery += " FROM "
	If cCodEmp = '01'
        cQuery += "     SB1010 a  LEFT OUTER JOIN SB1020 b "
	Else	
        cQuery += "     SB1020 a  LEFT OUTER JOIN SB1010 b "
	Endif	
	cQuery += "                                       ON a.B1_COD = b.B1_COD "
	cQuery += "                                       AND a.R_E_C_D_E_L_ = 0 "
    cQuery += "                                       AND b.R_E_C_D_E_L_ = 0 "
	cQuery += "    			                          AND a.B1_MSBLQL <> 1 "
	cQuery += "    								      AND b.B1_MSBLQL <> 1 "
    cQuery += " WHERE  "
    cQuery += "     (  "
	cQuery += "         (SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9))  "
    cQuery += "      OR (SUBSTRING(b.B1_YCODBAR, LEN(b.B1_YCODBAR) - 9, 9) <> SUBSTRING(b.B1_CODBAR, LEN(b.B1_CODBAR) - 9, 9) AND (b.B1_YCODBAR <> '')) "
    cQuery += "      OR (SUBSTRING(a.B1_YCODBAR, LEN(a.B1_YCODBAR) - 9, 9) <> SUBSTRING(a.B1_CODBAR, LEN(a.B1_CODBAR) - 9, 9) AND (a.B1_YCODBAR <> '')) "
	cQuery += "	     OR (a.B1_DESC <> b.B1_DESC) "
	cQuery += "	     OR (b.B1_COD IS NULL) "
    cQuery += "     ) "
    cQuery += "     AND a.B1_COD IN (" + cCodProd + ") "
    cQuery += "     AND a.R_E_C_D_E_L_ = 0 "
//	cQuery += " "
//	cQuery += " UNION ALL  "
//	cQuery += " "
//    cQuery += " SELECT Legenda = 'PRODUTO BLOQUEADO NA COMERCIAL ALCIDES', "
//    cQuery += "         Codigo = B1_COD, Descricao = B1_DESC, CodBarra = B1_CODBAR "
//    cQuery += " FROM SB1010 "
//    cQuery += " WHERE B1_COD in (" + cCodProd + ") AND D_E_L_E_T_ = '' AND B1_MSBLQL = 1 "
//	cQuery += " "
//	cQuery += " UNION ALL  "
//	cQuery += " "
//    cQuery += " SELECT Legenda = 'PRODUTO BLOQUEADO NA FS', "
//    cQuery += "         Codigo = B1_COD, Descricao = B1_DESC, CodBarra = B1_CODBAR "
//    cQuery += " FROM SB1020 "
//    cQuery += " WHERE B1_COD in (" + cCodProd + ") AND D_E_L_E_T_ = '' AND B1_MSBLQL = 1 "
             
    cQuery := ChangeQuery(cQuery) 
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrDivergencia", .F., .T.)
          
    While !Eof()  
        AADD( aDiverg, {Legenda, Codigo, Descricao, CodBarra} )  
        dbSkip() 
    End  
	DBCloseArea()         
    // Se n�o houver dados no vetor abandonar rotina. 
//    If Len( aDiverg ) == 0    
//        DBCloseArea() 
//        Return .F.
//    Endif  
//	DBCloseArea()


    cQuery2 := " SELECT Local = 'Rio Center', CodBarra = SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 11, 12), Produtos = 'ITENS REPETIDOS: ' +  CONVERT(VARCHAR, COUNT(*)) FROM SB1010 WHERE SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 9, 9) IN (SELECT SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 9, 9) FROM SB1010 "
    cQuery2 += " WHERE B1_COD in (" + cCodProd + ") AND D_E_L_E_T_ = '' AND B1_MSBLQL <> 1) "
	cQuery2 += " AND D_E_L_E_T_ = '' AND B1_MSBLQL <> 1 ""
	cQuery2 += " GROUP BY SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 11, 12) "
	cQuery2 += " HAVING COUNT(*) > 1 "
	cQuery2 += " "
	cQuery2 += " UNION ALL  "
	cQuery2 += " "
	cQuery2 += " SELECT Local = 'FS', CodBarra = SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 11, 12), Produtos = 'ITENS REPETIDOS: ' +  CONVERT(VARCHAR, COUNT(*)) FROM SB1020 WHERE SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 9, 9) IN (SELECT SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 9, 9) FROM SB1020 "
    cQuery2 += " WHERE B1_COD in (" + cCodProd + ") AND D_E_L_E_T_ = '' AND B1_MSBLQL <> 1) "
	cQuery2 += " AND D_E_L_E_T_ = '' AND B1_MSBLQL <> 1 ""
	cQuery2 += "	 GROUP BY SUBSTRING(B1_CODBAR, LEN(B1_CODBAR) - 11, 12) "
	cQuery2 += " HAVING COUNT(*) > 1 "

             
    cQuery2 := ChangeQuery(cQuery2) 
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery2), "qrDuplicidade", .F., .T.)
          
    While !Eof()  
        AADD( aDuplic, {Local, CodBarra, Produtos} )  
        dbSkip() 
    End  
    DBCloseArea()       

    // Se n�o houver dados no vetor abandonar rotina. 
    If Len( aDuplic ) == 0  .and. Len( aDiverg ) == 0   
        Return .F.
    Endif  

    AADD( aDiverg, {"", "", "", ""} )
	AADD( aDuplic, {"", "", ""} ) 
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 480,920 PIXEL     
    @ 15,10 SAY "Diverg�ncias de informa��es entre empresas" SIZE 140, 10 OF oDlg PIXEL  // 280   
  	// Primeira op��o para montar o listbox.    
    @ 25,10 LISTBOX oLbx FIELDS HEADER "Legenda", "C�digo", "Descri��o", "C�d. Barra";   
    SIZE 440,85 OF oDlg PIXEL       
               
    oLbx:SetArray( aDiverg )   
    oLbx:bLine := {|| {aDiverg[oLbx:nAt,1],;                       
                       aDiverg[oLbx:nAt,2],;
                       aDiverg[oLbx:nAt,3],;
                       aDiverg[oLbx:nAt,4]}}  
     
    @ 120,10 SAY "Duplicidade de c�digos de barras " SIZE 140, 10 OF oDlg PIXEL  // 280   
  	// Primeira op��o para montar o listbox.    
    @ 130,10 LISTBOX oLbx2 FIELDS HEADER "Local", "C�digo de Barras ", "Quantidade";   
    SIZE 440,85 OF oDlg PIXEL       
               
    oLbx2:SetArray( aDuplic )   
    oLbx2:bLine := {|| {aDuplic[oLbx2:nAt,1],; 
						aDuplic[oLbx2:nAt,2],;                      
                       aDuplic[oLbx2:nAt,3]}}  

    @ 220,220  BUTTON oBtn1 PROMPT "Fechar" SIZE 40,15 ; 
              ACTION  oDlg:End() OF oDlg PIXEL  
    ACTIVATE MSDIALOG oDlg CENTER  
    
Return .T.

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |RIOA002i  � Autor � Glaudson Marcel    � Data �  29/09/21   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Funcao para verificar se h� diverg�ncia de codigos         ���
//���          �de barras ou codigo interno                                 ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function RIOA002i(aItens)

    Local cQuery := ""
	Local cTitulo := "Produtos Bloqueados"
	Local i := 0
    Local cCodEmp := ""
	Local cCodProd := ""	
    Local aBloqueados := {} 
 	
	cCodEmp := FWGrpCompany()


	For i := 1 To Len(aItens)		
	 	cCodProd	:= cCodProd + "'" + AllTrim(aItens[i][1]) + "', "
    Next
          
	If cCodProd <> ""
	    cCodProd := SubStr( cCodProd, 1, len(cCodProd) - 2 )  
	Endif
    cQuery := "SELECT " 
    cQuery += "         Legenda = 'PRODUTO BLOQUEADO NA COMERCIAL ALCIDES', "
    cQuery += "         Codigo = B1_COD, Descricao = B1_DESC, CodBarra = B1_CODBAR "
    cQuery += " FROM SB1010 "
    cQuery += " WHERE B1_COD in (" + cCodProd + ") AND D_E_L_E_T_ = '' AND B1_MSBLQL = 1 "
	cQuery += " "
	cQuery += " UNION ALL  "
	cQuery += " "
    cQuery += " SELECT Legenda = 'PRODUTO BLOQUEADO NA FS', "
    cQuery += "         Codigo = B1_COD, Descricao = B1_DESC, CodBarra = B1_CODBAR "
    cQuery += " FROM SB1020 "
    cQuery += " WHERE B1_COD in (" + cCodProd + ") AND D_E_L_E_T_ = '' AND B1_MSBLQL = 1 "
             
    cQuery := ChangeQuery(cQuery) 
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrBloqueados", .F., .T.)
          
    While !Eof()  
        AADD( aBloqueados, {Legenda, Codigo, Descricao, CodBarra} )  
        dbSkip() 
    End  
	DBCloseArea()         
    // Se n�o houver dados no vetor abandonar rotina. 
    If Len( aBloqueados ) == 0    
        DBCloseArea() 
        Return .F.
    Endif  

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 480,920 PIXEL     
    @ 15,10 SAY "Produtos Bloqueados" SIZE 140, 10 OF oDlg PIXEL  // 280   
  	// Primeira op��o para montar o listbox.    
    @ 25,10 LISTBOX oLbx FIELDS HEADER "Legenda", "C�digo", "Descri��o", "C�d. Barra";   
    SIZE 440,85 OF oDlg PIXEL       
               
    oLbx:SetArray( aBloqueados )   
    oLbx:bLine := {|| {aBloqueados[oLbx:nAt,1],;                       
                       aBloqueados[oLbx:nAt,2],;
                       aBloqueados[oLbx:nAt,3],;
                       aBloqueados[oLbx:nAt,4]}}  
    @ 220,220  BUTTON oBtn1 PROMPT "Fechar" SIZE 40,15 ; 
              ACTION  oDlg:End() OF oDlg PIXEL  
    ACTIVATE MSDIALOG oDlg CENTER  
    DBCloseArea()
Return .T.


//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |VerSaldo  � Autor � Sidney Sales       � Data �  14/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Verifica o saldo do produto no armazem informado.          ���
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
Static Function VerSaldo(cProduto, cLocal,nQtd)
Local aRet
Local lRet	:=	.T.
/* COMENTADO PARA IMPRIMIR ETIQUETA MESMO SEM SALDO, POIS NAO ESTA
//��������������������������������������������������������������������������������������Ŀ
//�Chama a rotina para verificar o saldo, pega  a data atual + 1 pra ver o saldo hj, pois�
//�a funcao verifica a data pra atras                                                    �
//����������������������������������������������������������������������������������������
aRet	:=	CalcEst(cProduto,cLocal, dDataBase+1)

//������������������������������������������������������Ŀ
//�Verifica se o saldo e menor que a quantidade informada�
//��������������������������������������������������������
If aRet[1] < nQtd
	Alert('Saldo Insuficiente em estoque.' + CHR(13) + CHR(10) + 'Produto:' + SB1->B1_DESC + CHR(13) + CHR(10) + ;
	'A quantidade em estoque no armazem('+cLocal+') �: ' + cValToChar(aRet[1]) + ' e a quantidade solicitada �: ' + cValToChar(nQtd))
	lRet	:=	.F.
Endif
*/
Return lRet

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  |VerProd   � Autor � Sidney Sales       � Data �  14/03/13   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Valida o produto digitado e pega o armazem padrao do produto��
//�������������������������������������������������������������������������͹��
//���Uso       �                                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
Static Function VerProd(cProduto, nTipo)
Local lRet := .T.
Default nTipo	:= 1

if !Empty(cProduto)
	SB1->(DBSETORDER(1))
	lRet	:= SB1->(DBSEEK(xFilial('SB1') + cProduto))

	If ! lRet
		Alert('Produto n�o localizado.')
	ElseIf nTipo <> 4
		_cLocal	:= SB1->B1_LOCPAD
	Endif
EndIf

Return lRet

//�������������������������������������������������������������������������������
//�������������������������������������������������������������������������������
//���������������������������������������������������������������������������ͻ��
//���Funcao      �VALIDPERG � Autor � Deus sabe!!!       � Data �      /  /   ���
//���������������������������������������������������������������������������͹��
//���Descricao   � Cria as perguntas                                          ���
//���������������������������������������������������������������������������͹��
//���Retorno     �                                                            ���
//���������������������������������������������������������������������������͹��
//���Parametros  �                                                            ���
//���������������������������������������������������������������������������ͼ��
//�������������������������������������������������������������������������������
//�������������������������������������������������������������������������������

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

//01     02    03                 04  05  06        07   08 09  10  11   12  13          14   		15  16  17  18  19   			20  21  22  23  24   				25  26  27  28  29  				30  31  32  33  34  	 			35  36  37  38   	  39
If cPerg == 'U_RIOA002g'
	aAdd(aRegs, {cPerg, "01", "Nota?  "		, "", "", "mv_ch1", "C", 09, 0, 00, "G", "NAOVAZIO()", "mv_par01", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", "SF1VEI"	, ""})
	aAdd(aRegs, {cPerg, "02", "Serie? "	  	, "", "", "mv_ch2", "C", 03, 0, 00, "G", "NAOVAZIO()", "mv_par02", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "03", "Fornecedor?"	, "", "", "mv_ch3", "C", 09, 0, 00, "G", "NAOVAZIO()", "mv_par03", "",  		"", "", "", "", "",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "04", "Loja?"		, "", "", "mv_ch4", "C", 04, 0, 01, "G", "NAOVAZIO()", "mv_par04", "",			"", "", "", "", "",           "", "", "", "", "", 					"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
Else
	aAdd(aRegs, {cPerg, "01", "Tipo de Etiqueta?", "", "", "mv_ch1", "C", 01, 0, 00,"C", "", "mv_par01", "Tipo 1(Colante)",  		"", "", "", "", "Tipo 2(Pino)",  			"", "", "", "", "",  				"", "", "", "", "", 				"", "", "", "", "", 	 			"", "", "", ""	, ""})
	aAdd(aRegs, {cPerg, "02", "Porta?"           , "", "", "mv_ch2", "C", 01, 0, 00,"C", "", "mv_par02", "LPT1",  		"", "", "", "", "LPT2",  			"", "", "", "", "LPT3",  				"", "", "", "", "LPT4", 				"", "", "", "", "", 	 			"", "", "", ""	, ""})
	aAdd(aRegs, {cPerg, "03", "Tipo Impressora? ", "", "", "mv_ch3", "N",  1, 0, 01,"C", "", "mv_par03", "ZEBRA",       "", "", "", "", "ALLEGRO",          "", "", "", "", "ELTRON", 				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", ""		, ""})
	aAdd(aRegs, {cPerg, "04", "Etiqueta Nova? ", "", "", "mv_ch4", "N",  1, 0, 01,"C", "", "mv_par04", "NAO",           "", "", "", "", "SIM",              "", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "", "", 				"", "", "", "", ""})
Endif

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
