#Include "Protheus.ch"
#Include "APWEBSRV.ch"
#Include "TBICONN.ch"
#Include "TOPCONN.ch"
#Include "XMLXFUN.CH"

/*/{Protheus.doc} WSPDVRET
Função WSPDVRET
@param Recebe parâmetros
@return Confirmação
@author Totvs Nordeste
@owner Totvs S/A
@version Protheus 11 e V12
@since 14/06/2018 
@sample
// WSPDVRET - Web Service para cadastrar: Título, Cheque e Pagamento de Cartão
Return
@obs Rotina de cadastro Clientes
@project 
@history
09/09/2015 - Desenvolvimento da Rotina.
/*/

//======= Estrutura do Título a Receber =========
WSStruct STREC
  WSData Filial    as String   // Filial para transação 
  WSData Prefixo   as String   // E1_PREFIXO
  WSData NTitulo   as String   // E1_NUM
  WSData Tipo      as String   // E1_TIPO
  WSData Portador  as String   // E1_PORTADO
  WSData Natureza  as String   // E1_NATUREZ
  WSData Cliente   as String   // E1_CLIENTE
  WSData Loja      as String   // E1_LOJA
  WSData Emissao   as String   // E1_EMISSAO
  WSData Vencto    as String   // E1_VENCTO
  WSData Origem    as String   // E1_ORIGEM
  WSData Valor     as Float    // E1_VALOR
  WSData Historico as String   // E1_HIST
  WSData NmCartao  as String   // E1_NUMCART
  WSData NNNSU     as String   // E1_DOCTEF
  WSData NSUSITEF  as String   // E1_NSUTEF
  WSData Baixar    as String   // 'S' = Sim ou 'N' = Não 
  WSData Banco     as String   // Banco pra baixa 
  WSData Agencia   as String   // Agência pra baixa
  WSData Conta     as String   // Conta pra baixa
EndWSStruct         

//====== Formulario do Titulo Receber =========
WSStruct STRegSE1
  WSData stSE1 as STREC
EndWSStruct 

//======= Estrutura do Título a Receber COM PARCELA =========
WSStruct STREC2
  WSData Filial    as String   // Filial para transação 
  WSData Prefixo   as String   // E1_PREFIXO
  WSData NTitulo   as String   // E1_NUM
  WSData Parcela   as String   // E1_PARCELA
  WSData Tipo      as String   // E1_TIPO
  WSData Portador  as String   // E1_PORTADO
  WSData Natureza  as String   // E1_NATUREZ
  WSData Cliente   as String   // E1_CLIENTE
  WSData Loja      as String   // E1_LOJA
  WSData Emissao   as String   // E1_EMISSAO
  WSData Vencto    as String   // E1_VENCTO
  WSData Origem    as String   // E1_ORIGEM
  WSData Valor     as Float    // E1_VALOR
  WSData VlrReal   as Float    // E1_VLRREAL
  WSData Historico as String   // E1_HIST
  WSData NmCartao  as String   // E1_NUMCART
  WSData NNNSU     as String   // E1_DOCTEF
  WSData NSUSITEF  as String   // E1_NSUTEF
  WSData Baixar    as String   // 'S' = Sim ou 'N' = Não 
  WSData Banco     as String   // Banco pra baixa 
  WSData Agencia   as String   // Agência pra baixa
  WSData Conta     as String   // Conta pra baixa
EndWSStruct         

//====== Formulario do Titulo Receber COM PARCELA =========
WSStruct STRegSE12
  WSData stSE12 as STREC2
EndWSStruct 

//======= Estrutura do Cheque =========
//=====================================
WSStruct STCHQ
  WSData Filial    as String   // Filial para transação 
  WSData Banco     as String  // EF_BANCO
  WSData Agencia   as String  // EF_AGENCIA
  WSData Conta     as String  // EF_CONTA
  WSData NmCheque  as String  // EF_NUM
  WSData Valor     as Float   // EF_VALOR
  WSData DtCheque  as String  // EF_DATA 
  WSData Vencto    as String  // EF_VENCTO  
  WSData Prefixo   as String  // EF_PREFIXO
  WSData Titulo    as String  // EF_TITULO
  WSData Cliente   as String  // EF_CLIENTE
  WSData Loja      as String  // EF_LOJACLI
  WSData CPFCNPJ   as String  // EF_CPFCNPJ
  WSData Emitente  as String  // EF_EMITENT
  WSData Historico as String  // EF_HIST
EndWSStruct         

//====== Formulario do Cheque ===========
WSStruct STRegSEF
	WSData stSEF as STCHQ
EndWSStruct

//======= Estrutura do Pagamento Cartão =======
WSStruct STCAD
  WSData Filial    as String   // Filial para transação 
  WSData Cartao    as String   // Cartao Rio Center
  WSData Nome      as String   // Nome do cliente
  WSData DtOpera   as String   // Data da Operação
  WSData Hora      as String   // Hora da Operação
  WSData Operador  as String   // Código do Operador
  WSData PDV       as String   // PDV
  WSData Valor     as Float    // Valor
  WSData Pagto     as Float    // Valor do pagamento
  WSData Dinheiro  as Float    // Total em Dinheiro
  WSData Cheque    as Float    // Total em Cheque
  WSData Debito    as Float    // Total em Debito
  WSData Sequencia as String   // Sequencial da transação
EndWSStruct         

//====== Formulario do Pagamento Cartão =======
WSStruct STRegSZ4
  WSData stSZ4 as STCAD
EndWSStruct

//======= Estrutura do Pagamento Cartão =======
WSStruct STCAD2
  WSData Filial    as String   // Filial para transação 
  WSData Cartao    as String   // Cartao Rio Center
  WSData Nome      as String   // Nome do cliente
  WSData DtOpera   as String   // Data da Operação
  WSData Hora      as String   // Hora da Operação
  WSData Operador  as String   // Código do Operador
  WSData PDV       as String   // PDV
  WSData Valor     as Float    // Valor
  WSData Pagto     as Float    // Valor do pagamento
  WSData Dinheiro  as Float    // Total em Dinheiro
  WSData Cheque    as Float    // Total em Cheque
  WSData Debito    as Float    // Total em Debito
  WsData Credito   as FLoat    // Total em Credito / yury rogens 09/07
  WSData Sequencia as String   // Sequencial da transação
EndWSStruct         

//====== Formulario do Pagamento Cartão =======
WSStruct STRegSZ42
  WSData stSZ42 as STCAD2
EndWSStruct

//======= Estrutura do Pagamento Cartão x Cheque =======
WSStruct STCCH
  WSData Filial    as String   // Filial para transação
  WSData Tipo      as String   // Tipo da transação "CH" - Cheque ou "CD" - Cartão de débito
  WSData Sequencia as String   // Sequencial da transação
  WSData Banco     as String   // Banco
  WSData Agencia   as String   // Agencia
  WSData Conta     as String   // Conta 
  WSData Digito    as String   // Digito da Conta
  WSData Cheque    as String   // Numero do Cheque
  WSData Cartao    as String   // Numero do Cartão Rio Center
  WSData CPFCNPJ   as String   // CPF / CNPJ
  WSData Emitente  as String   // Emitente
  WSData NSU       as String   // Código de autorização do débito
  WSData Valor     as Float    // Valor do cheque
  WSData DtOpera   as String   // Data da operação
  WSData Hora      as String   // Hora da operação
  WSData Operador  as String   // Código do operador
  WSData PDV       as String   // PDV
EndWsStruct              	

//====== Formulario do Pagamento Cartão x Cheque ======
WSStruct STRegSZ5
  WSData stSZ5 as STCCH
EndWSStruct
  
//======= Definição WebService ==========
//=======================================
WSService WSPDVRET Description "Geração Título/Cheque/Pagamento Cartão"
   // --- Encapsulamento das estruturas do serviço
	WSData FormRec As STRegSE1
	WSData FormRec2 As STRegSE12
	WSData FormChq As STRegSEF
	WSData FormCad As STRegSZ4
	WSData FormCad2 As STRegSZ42
	WSData FormCCh As STRegSZ5
 
   // --- Declaração dos parâmetros
	WSData cOk  as String
	
   // --- Declaração do metodo
	WSMethod InclSE1 Description "Método para Inclusão/Baixa de Receber"
	WSMethod InclSE12 Description "Método para Inclusão/Baixa de Receber parcelado"
	WSMethod InclSEF Description "Método para Inclusão de Cheque"
	WSMethod InclSZ4 Description "Método para Inclusão Pagamento Cartão"
	WSMethod InclSZ42 Description "Método para Inclusão Pagamento Cartão no Credito"
	WSMethod InclSZ5 Description "Método para Inclusão Pagto Cartão x Cheque"
EndWSService

/*/{Protheus.doc} WSPDVRET
  Função InclSE1
  @param Retorno do SOAP
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 14/08/2018 
  @sample
// InclSE1 - Função integração do PDV x Retaguarda via SOAP - Inclusão Título Contas a Receber.
  Return
  @project 
  @history
  14/08/2018 - Desenvolvimento da Rotina.
/*/
WSMethod InclSE1 WSReceive FormRec WSSend cOk WSService WSPDVRET
  Local lRet    := .T.
  Local aRegSE1 := {}                                    
             
  Private lMsErroAuto    := .F.                                 
  Private lAutoErrNoFile := .T.
  Private lMSHelpAuto    := .T.   
  
  ::cOk := ""

  RpcClearEnv()
  RpcSetType(3)

  If ! RpcSetEnv(Substr(::FormRec:stSE1:Filial,1,2),AllTrim(::FormRec:stSE1:Filial),,,"FAT")
     ::cOk := "400 - Usuario sem acesso ou Empresa/Filial nao existe."
     RpcClearEnv()
	 SetSoapFault(ProcName(), ::cOk)
     Return .F.
  EndIf
  
 // --- Gravar o Titulo do Contas a Receber
 // ---------------------------------------
 // --- Verificar se título já existe
 // ---------------------------------
  dbSelectArea("SE1")
  SE1->(dbSetOrder(1))
  
  If SE1->(dbSeek(xFilial("SE1") + PadR(::FormRec:stSE1:Prefixo, TamSX3("E1_PREFIXO")[1]) +;
                  PadR(::FormRec:stSE1:NTitulo, TamSX3("E1_NUM")[1]) + StrZero(1, TamSX3("E1_PARCELA")[01]) +;
                  PadR(::FormRec:stSE1:Tipo, TamSX3("E1_TIPO")[1])))
     ::cOk := "200 - Titulo ja cadastrado - " + xFilial("SE1") + PadR(::FormRec:stSE1:Prefixo, TamSX3("E1_PREFIXO")[1]) +;
                  PadR(::FormRec:stSE1:NTitulo, TamSX3("E1_NUM")[1]) + StrZero(1, TamSX3("E1_PARCELA")[01]) +;
                  PadR(::FormRec:stSE1:Tipo, TamSX3("E1_TIPO")[1])
     RpcClearEnv()
     Return lRet
  EndIf                
 
 // --- Verificar se é Cliente Padrão
 // ---------------------------------
  If AllTrim(::FormRec:stSE1:Cliente) == '000000001'
     dbSelectArea("SA1")
     SA1->(dbSetOrder(1))
     
     If SA1->(dbSeek(xFilial("SA1") + PadR(AllTrim(::FormRec:stSE1:Cliente),TamSX3("A1_COD")[1]) +;
                     PadR(AllTrim(::FormRec:stSE1:Loja),TamSX3("A1_LOJA")[1])))
        Reclock("SA1",.F.)
          Replace SA1->A1_NROPAG with 0
        SA1->(MsUnlock())            
     EndIf
  EndIf
 // ---------------------------------                    
            
  aRegSE1 := {{"E1_FILIAL" , xFilial("SE1")                     , Nil},;
      	      {"E1_PREFIXO", ::FormRec:stSE1:Prefixo            , Nil},;
              {"E1_NUM"    , ::FormRec:stSE1:NTitulo            , Nil},;
              {"E1_PARCELA", StrZero(1,TamSX3("E1_PARCELA")[01]), Nil},;
              {"E1_TIPO"   , ::FormRec:stSE1:Tipo               , Nil},;
              {"E1_CLIENTE", ::FormRec:stSE1:Cliente            , Nil},;
              {"E1_LOJA"   , ::FormRec:stSE1:Loja               , Nil},;
              {"E1_VALOR"  , ::FormRec:stSE1:Valor              , Nil},;
              {"E1_VLRREAL", ::FormRec:stSE1:Valor              , Nil},;
              {"E1_NOMCLI" , Posicione("SA1",1,xFilial("SA1") + AllTrim(::FormRec:stSE1:Cliente) +;
                                               ::FormRec:stSE1:Loja,"A1_NOME"), Nil},;
              {"E1_PORTADO", ::FormRec:stSE1:Portador           , Nil},;
              {"E1_NATUREZ", ::FormRec:stSE1:Natureza           , Nil},;
              {"E1_EMISSAO", SToD(::FormRec:stSE1:Emissao)      , Nil},;
              {"E1_VENCTO" , SToD(::FormRec:stSE1:Vencto)       , Nil},;
              {"E1_VENCREA", SToD(::FormRec:stSE1:Vencto)       , Nil},;
              {"E1_VENCORI", SToD(::FormRec:stSE1:Vencto)       , Nil},;
              {"E1_SITUACA", "0"                                , Nil},;
              {"E1_VALLIQ" , ::FormRec:stSE1:Valor              , Nil},;
              {"E1_MOEDA"  , 1                                  , Nil},;
              {"E1_VLCRUZ" , ::FormRec:stSE1:Valor              , Nil},;
              {"E1_HIST"   , ::FormRec:stSE1:Historico          , Nil},;
              {"E1_STATUS" , "A"                                , Nil},;
              {"E1_ORIGEM" , "FINA040"                          , Nil},;
              {"E1_FLUXO"  , "S"                                , Nil},;
              {"E1_NUMCART", ::FormRec:stSE1:NmCartao           , Nil},; 
              {"E1_DOCTEF" , ::FormRec:stSE1:NNNSU              , Nil},;
              {"E1_NSUTEF" , ::FormRec:stSE1:NSUSITEF           , Nil}}
                  
  lMsErroAuto := .F.
      
  Begin Transaction
    MsAguarde({|| MSExecAuto({|x,y| Fina040(x,y)},aRegSE1,3)},"Processando - Gravando Receber...")

    If lMsErroAuto
       aAutoErro := GETAUTOGRLOG()
       ::cOk     := "400 - ERRO: Inclusao Titulo Contas a Receber - " + fnPgInv(aAutoErro)
    
       DisarmTransaction()
       
       lRet := .F.
     elseIf ::FormRec:stSE1:Baixar == "S"
            aRegSE1 := {{"E1_PREFIXO"  , ::FormRec:stSE1:Prefixo            , Nil},;
                        {"E1_NUM"      , ::FormRec:stSE1:NTitulo            , Nil},;
                        {"E1_PARCELA"  , StrZero(1,TamSX3("E1_PARCELA")[01]), Nil},;
                        {"E1_TIPO"     , ::FormRec:stSE1:Tipo               , Nil},;
                        {"AUTMOTBX"    , "NOR"                              , Nil},;
                        {"AUTBANCO"    , ::FormRec:stSE1:Banco              , Nil},; 
                        {"AUTAGENCIA"  , ::FormRec:stSE1:Agencia            , Nil},;
                        {"AUTCONTA"    , ::FormRec:stSE1:Conta              , Nil},;
                        {"AUTDTBAIXA"  , dDataBase                          , Nil},; 
                        {"AUTDTCREDITO", dDataBase                          , Nil},;
                        {"AUTHIST"     , ::FormRec:stSE1:Historico          , Nil},;
                        {"AUTJUROS"    , 0                                  , Nil},;
                        {"AUTMULTA"    , 0                                  , Nil},;
                        {"AUTDESCONT"  , 0                                  , Nil},;
                        {"AUTVALREC"   , ::FormRec:stSE1:Valor              , Nil}}

            lMsErroAuto := .F.
    
            MSExecAuto({|x,y| Fina070(x,y)},aRegSE1,3)  

            If lMsErroAuto
               aAutoErro := GETAUTOGRLOG()
               ::cOk     := "400 - ERRO: Baixar Titulo Contas a Receber - " + fnPgInv(aAutoErro)
    
               DisarmTransaction()
       
               lRet := .F.
             else 
               ::cOk := "100 - Titulo/Baixado cadastrado com sucesso."
            EndIf
          else  
            ::cOk := "100 - Titulo cadastrado com sucesso."
    EndIf
  End Transaction
  
  RpcClearEnv()
Return lRet 

/*/{Protheus.doc} WSPDVRET
  Função InclSE1
  @param Retorno do SOAP
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 03/08/2021
  @sample
// InclSE12 - Função integração do PDV x Retaguarda via SOAP - Inclusão Título Contas a Receber parcelado.
  Return
  @project 
  @history
  14/08/2018 - Desenvolvimento da Rotina.
/*/
WSMethod InclSE12 WSReceive FormRec2 WSSend cOk WSService WSPDVRET
  Local lRet    := .T.
  Local aRegSE1 := {}                                    
             
  Private lMsErroAuto    := .F.                                 
  Private lAutoErrNoFile := .T.
  Private lMSHelpAuto    := .T.   
  
  ::cOk := ""

  RpcClearEnv()
  RpcSetType(3)

  If ! RpcSetEnv(Substr(::FormRec2:stSE12:Filial,1,2),AllTrim(::FormRec2:stSE12:Filial),,,"FAT")
     ::cOk := "400 - Usuario sem acesso ou Empresa/Filial nao existe. "
     RpcClearEnv()
	 SetSoapFault(ProcName(), ::cOk)
     Return .F.
  EndIf
  
 // --- Gravar o Titulo do Contas a Receber
 // ---------------------------------------
 // --- Verificar se título já existe
 // ---------------------------------
  dbSelectArea("SE1")
  SE1->(dbSetOrder(1))
  
  If SE1->(dbSeek(xFilial("SE1") + PadR(::FormRec2:stSE12:Prefixo, TamSX3("E1_PREFIXO")[1]) +;
                  PadR(::FormRec2:stSE12:NTitulo, TamSX3("E1_NUM")[1]) + StrZero(1, TamSX3("E1_PARCELA")[01]) +;
                  PadR(::FormRec2:stSE12:Tipo, TamSX3("E1_TIPO")[1])))
     ::cOk := "200 - Titulo ja cadastrado - " + xFilial("SE1") + PadR(::FormRec2:stSE12:Prefixo, TamSX3("E1_PREFIXO")[1]) +;
                  PadR(::FormRec2:stSE12:NTitulo, TamSX3("E1_NUM")[1]) + StrZero(1, TamSX3("E1_PARCELA")[01]) +;
                  PadR(::FormRec2:stSE12:Tipo, TamSX3("E1_TIPO")[1])
     RpcClearEnv()
     Return lRet
  EndIf                
 
 // --- Verificar se é Cliente Padrão
 // ---------------------------------
  If AllTrim(::FormRec2:stSE12:Cliente) == '000000001'
     dbSelectArea("SA1")
     SA1->(dbSetOrder(1))
     
     If SA1->(dbSeek(xFilial("SA1") + PadR(AllTrim(::FormRec2:stSE12:Cliente),TamSX3("A1_COD")[1]) +;
                     PadR(AllTrim(::FormRec2:stSE12:Loja),TamSX3("A1_LOJA")[1])))
        Reclock("SA1",.F.)
          Replace SA1->A1_NROPAG with 0
        SA1->(MsUnlock())            
     EndIf
  EndIf
 // ---------------------------------                    
            
  aRegSE1 := {{"E1_FILIAL" , xFilial("SE1")                     , Nil},;
      	      {"E1_PREFIXO", ::FormRec2:stSE12:Prefixo            , Nil},;
              {"E1_NUM"    , ::FormRec2:stSE12:NTitulo            , Nil},;
              {"E1_PARCELA", StrZero(1,TamSX3("E1_PARCELA")[01]), Nil},;
              {"E1_TIPO"   , ::FormRec2:stSE12:Tipo               , Nil},;
              {"E1_CLIENTE", ::FormRec2:stSE12:Cliente            , Nil},;
              {"E1_LOJA"   , ::FormRec2:stSE12:Loja               , Nil},;
              {"E1_VALOR"  , ::FormRec2:stSE12:Valor              , Nil},;
              {"E1_VLRREAL", ::FormRec2:stSE12:VlrReal            , Nil},;
              {"E1_NOMCLI" , Posicione("SA1",1,xFilial("SA1") + AllTrim(::FormRec2:stSE12:Cliente) +;
                                               ::FormRec2:stSE12:Loja,"A1_NOME"), Nil},;
              {"E1_PORTADO", ::FormRec2:stSE12:Portador           , Nil},;
              {"E1_NATUREZ", ::FormRec2:stSE12:Natureza           , Nil},;
              {"E1_EMISSAO", SToD(::FormRec2:stSE12:Emissao)      , Nil},;
              {"E1_VENCTO" , SToD(::FormRec2:stSE12:Vencto)       , Nil},;
              {"E1_VENCREA", SToD(::FormRec2:stSE12:Vencto)       , Nil},;
              {"E1_VENCORI", SToD(::FormRec2:stSE12:Vencto)       , Nil},;
              {"E1_SITUACA", "0"                                , Nil},;
              {"E1_VALLIQ" , ::FormRec2:stSE12:Valor              , Nil},;
              {"E1_MOEDA"  , 1                                  , Nil},;
              {"E1_VLCRUZ" , ::FormRec2:stSE12:Valor              , Nil},;
              {"E1_HIST"   , ::FormRec2:stSE12:Historico          , Nil},;
              {"E1_STATUS" , "A"                                , Nil},;
              {"E1_ORIGEM" , "FINA040"                          , Nil},;
              {"E1_FLUXO"  , "S"                                , Nil},;
              {"E1_NUMCART", ::FormRec2:stSE12:NmCartao           , Nil},; 
              {"E1_DOCTEF" , ::FormRec2:stSE12:NNNSU              , Nil},;
              {"E1_NSUTEF" , ::FormRec2:stSE12:NSUSITEF           , Nil}}
                  
  lMsErroAuto := .F.
      
  Begin Transaction
    MsAguarde({|| MSExecAuto({|x,y| Fina040(x,y)},aRegSE1,3)},"Processando - Gravando Receber...")

    If lMsErroAuto
       aAutoErro := GETAUTOGRLOG()
       ::cOk     := "400 - ERRO: Inclusao Titulo Contas a Receber - " + fnPgInv(aAutoErro)
    
       DisarmTransaction()
       
       lRet := .F.
     elseIf ::FormRec2:stSE12:Baixar == "S"
            aRegSE1 := {{"E1_PREFIXO"  , ::FormRec2:stSE12:Prefixo            , Nil},;
                        {"E1_NUM"      , ::FormRec2:stSE12:NTitulo            , Nil},;
                        {"E1_PARCELA"  , StrZero(1,TamSX3("E1_PARCELA")[01]), Nil},;
                        {"E1_TIPO"     , ::FormRec2:stSE12:Tipo               , Nil},;
                        {"AUTMOTBX"    , "NOR"                              , Nil},;
                        {"AUTBANCO"    , ::FormRec2:stSE12:Banco              , Nil},; 
                        {"AUTAGENCIA"  , ::FormRec2:stSE12:Agencia            , Nil},;
                        {"AUTCONTA"    , ::FormRec2:stSE12:Conta              , Nil},;
                        {"AUTDTBAIXA"  , dDataBase                          , Nil},; 
                        {"AUTDTCREDITO", dDataBase                          , Nil},;
                        {"AUTHIST"     , ::FormRec2:stSE12:Historico          , Nil},;
                        {"AUTJUROS"    , 0                                  , Nil},;
                        {"AUTMULTA"    , 0                                  , Nil},;
                        {"AUTDESCONT"  , 0                                  , Nil},;
                        {"AUTVALREC"   , ::FormRec2:stSE12:Valor              , Nil}}

            lMsErroAuto := .F.
    
            MSExecAuto({|x,y| Fina070(x,y)},aRegSE1,3)  

            If lMsErroAuto
               aAutoErro := GETAUTOGRLOG()
               ::cOk     := "400 - ERRO: Baixar Titulo Contas a Receber - " + fnPgInv(aAutoErro)
    
               DisarmTransaction()
       
               lRet := .F.
             else 
               ::cOk := "100 - Titulo/Baixado cadastrado com sucesso."
            EndIf
          else  
            ::cOk := "100 - Titulo cadastrado com sucesso."
    EndIf
  End Transaction
  
  RpcClearEnv()
Return lRet 

/*/{Protheus.doc} WSPDVRET
  Função InclSEF
  @param Retorno do SOAP
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 14/08/2018 
  @sample
// InclSEF - Função integração do PDV x Retaguarda via SOAP - Inclusão de Cheque.
  Return
  @project 
  @history
  14/08/2018 - Desenvolvimento da Rotina.
/*/
WSMethod InclSEF WSReceive FormChq WSSend cOk WSService WSPDVRET
  Local lRet    := .T.
  
  ::cOk := ""

  RpcClearEnv()
  RpcSetType(3)

  If ! RpcSetEnv(Substr(::FormChq:stSEF:Filial,1,2),AllTrim(::FormChq:stSEF:Filial),,,"FAT")
     ::cOk := "400 - ERRO: Usuario sem acesso ou Empresa/Filial nao existe."
     RpcClearEnv()
	 SetSoapFault(ProcName(), ::cOk)
     Return .F.
  EndIf
 
 // --- Validar se título existe no
 // --- Contas a Receber 
 // -------------------------------
  dbSelectArea("SE1")
  SE1->(dbSetOrder(1))

  If ! SE1->(dbSeek(xFilial("SE1") + PadR(AllTrim(::FormChq:stSEF:Prefixo), TamSX3("E1_PREFIXO")[1]) +;
                    PadR(AllTrim(::FormChq:stSEF:Titulo), TamSX3("E1_NUM")[1]) +;
                    StrZero(1, TamSX3("E1_PARCELA")[01]) + "CH"))
     ::cOk := "400 - ERRO: Inclusão de cheque nao pode ser realizada, falta cadastrar o título."
     RpcClearEnv()
     SetSoapFault(ProcName(), ::cOk)
     Return .F.
  EndIf
                    
 // --- Gravar o Cheque
 // -------------------
  Reclock("SEF",.T.)
    Replace SEF->EF_FILIAL  with xFilial("SEF")
    Replace SEF->EF_BANCO   with ::FormChq:stSEF:Banco
    Replace SEF->EF_AGENCIA with ::FormChq:stSEF:Agencia
    Replace SEF->EF_CONTA   with ::FormChq:stSEF:Conta
    Replace SEF->EF_NUM     with ::FormChq:stSEF:NmCheque
    Replace SEF->EF_VALOR   with ::FormChq:stSEF:Valor
    Replace SEF->EF_DATA    with SToD(::FormChq:stSEF:DtCheque)
    Replace SEF->EF_VENCTO  with SToD(::FormChq:stSEF:Vencto)
    Replace SEF->EF_CLIENTE with ::FormChq:stSEF:Cliente
    Replace SEF->EF_LOJACLI with ::FormChq:stSEF:Loja
    Replace SEF->EF_PREFIXO with ::FormChq:stSEF:Prefixo
    Replace SEF->EF_TITULO  with ::FormChq:stSEF:Titulo
    Replace SEF->EF_PARCELA with StrZero(1,TamSX3("EF_PARCELA")[1])
    Replace SEF->EF_TIPO    with "CH"
    Replace SEF->EF_CPFCNPJ with ::FormChq:stSEF:CPFCNPJ
    Replace SEF->EF_EMITENT with ::FormChq:stSEF:Emitente
    Replace SEF->EF_HIST    with ::FormChq:stSEF:Historico
    Replace SEF->EF_ORIGEM  with "FINA191"
  SEF->(MsUnlock())  

  ::cOk := "100 - Cheque gravado com sucesso."
  
  RpcClearEnv()
Return lRet

/*/{Protheus.doc} WSPDVRET
  Função InclSZ4
  @param Retorno do SOAP
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 14/08/2018 
  @sample
// InclSZ4 - Função integração do PDV x Retaguarda via SOAP - Inclusão Pagamento de Cartão.
  Return
  @project 
  @history
  14/08/2018 - Desenvolvimento da Rotina.
/*/
WSMethod InclSZ4 WSReceive FormCad WSSend cOk WSService WSPDVRET
  Local lRet := .T.

  ::cOk := ""

  RpcClearEnv()
  RpcSetType(3)

  If ! RpcSetEnv(Substr(::FormCad:stSZ4:Filial,1,2),AllTrim(::FormCad:stSZ4:Filial),,,"FAT")
     ::cOk := "400 - Usuario sem acesso ou Empresa/Filial nao existe."
     
	 SetSoapFault(ProcName(), ::cOk)
     Return .F.
  EndIf

 // --- Verificar se já existe
 // --------------------------
  dbSelectArea("SZ4")
  SZ4->(dbSetOrder(1))
  
  If ! SZ4->(dbSeek(xFilial("SZ4") + PadR(::FormCad:stSZ4:Cartao, TamSX3("Z4_CARTAO")[1]) +;
                    PadR(::FormCad:stSZ4:DtOpera, TamSX3("Z4_DATA")[1]) +;
                    PadR(::FormCad:stSZ4:Hora, TamSX3("Z4_HORA")[1])))
     Reclock("SZ4",.T.)
       Replace SZ4->Z4_FILIAL  with xFilial("SZ4")
       Replace SZ4->Z4_CARTAO  with ::FormCad:stSZ4:Cartao
       Replace SZ4->Z4_NOMECLI with ::FormCad:stSZ4:Nome
       Replace SZ4->Z4_DATA    with ::FormCad:stSZ4:DtOpera
       Replace SZ4->Z4_HORA    with ::FormCad:stSZ4:Hora
       Replace SZ4->Z4_OPERADO with ::FormCad:stSZ4:Operador
       Replace SZ4->Z4_PDV     with ::FormCad:stSZ4:PDV
       Replace SZ4->Z4_VALOR   with ::FormCad:stSZ4:Valor
       Replace SZ4->Z4_VLPAGTO with ::FormCad:stSZ4:Pagto
       Replace SZ4->Z4_DINHEIR with ::FormCad:stSZ4:Dinheiro
       Replace SZ4->Z4_CHEQUE  with ::FormCad:stSZ4:Cheque
       Replace SZ4->Z4_DEBITO  with ::FormCad:stSZ4:Debito
       Replace SZ4->Z4_SEQ     with ::FormCad:stSZ4:Sequencia
       Replace SZ4->Z4_TRANSMI with "S"
     SZ4->(MsUnlock())
     
     ::cOk := "100 - Pagamento de Fatura gravado com sucesso."
   else
     ::cOk := "200 - Ja existe o registro - Chave: " + xFilial("SZ4") + "-" + PadR(::FormCad:stSZ4:Cartao, TamSX3("Z4_CARTAO")[1]) +;
              "-" + PadR(::FormCad:stSZ4:DtOpera, TamSX3("Z4_DATA")[1]) + "-" + PadR(::FormCad:stSZ4:Hora, TamSX3("Z4_HORA")[1])
  EndIf
  
  RpcClearEnv()
Return lRet


/*/{Protheus.doc} WSPDVRET
  Função InclSZ42
  @param Retorno do SOAP
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 03/08/2021 
  @sample
// InclSZ4 - Função integração do PDV x Retaguarda via SOAP - Inclusão Pagamento de Cartão.
  Return
  @project 
  @history
  14/08/2018 - Desenvolvimento da Rotina.
/*/
WSMethod InclSZ42 WSReceive FormCad2 WSSend cOk WSService WSPDVRET
  Local lRet := .T.

  ::cOk := ""

  RpcClearEnv()
  RpcSetType(3)

  If ! RpcSetEnv(Substr(::FormCad2:stSZ42:Filial,1,2),AllTrim(::FormCad2:stSZ42:Filial),,,"FAT")
     ::cOk := "400 - Usuario sem acesso ou Empresa/Filial nao existe."
     
	 SetSoapFault(ProcName(), ::cOk)
     Return .F.
  EndIf

 // --- Verificar se já existe
 // --------------------------
  dbSelectArea("SZ4")
  SZ4->(dbSetOrder(1))
  
  If ! SZ4->(dbSeek(xFilial("SZ4") + PadR(::FormCad2:stSZ42:Cartao, TamSX3("Z4_CARTAO")[1]) +;
                    PadR(::FormCad2:stSZ42:DtOpera, TamSX3("Z4_DATA")[1]) +;
                    PadR(::FormCad2:stSZ42:Hora, TamSX3("Z4_HORA")[1])))
     Reclock("SZ4",.T.)
       Replace SZ4->Z4_FILIAL  with xFilial("SZ4")
       Replace SZ4->Z4_CARTAO  with ::FormCad2:stSZ42:Cartao
       Replace SZ4->Z4_NOMECLI with ::FormCad2:stSZ42:Nome
       Replace SZ4->Z4_DATA    with ::FormCad2:stSZ42:DtOpera
       Replace SZ4->Z4_HORA    with ::FormCad2:stSZ42:Hora
       Replace SZ4->Z4_OPERADO with ::FormCad2:stSZ42:Operador
       Replace SZ4->Z4_PDV     with ::FormCad2:stSZ42:PDV
       Replace SZ4->Z4_VALOR   with ::FormCad2:stSZ42:Valor
       Replace SZ4->Z4_VLPAGTO with ::FormCad2:stSZ42:Pagto
       Replace SZ4->Z4_DINHEIR with ::FormCad2:stSZ42:Dinheiro
       Replace SZ4->Z4_CHEQUE  with ::FormCad2:stSZ42:Cheque
       Replace SZ4->Z4_DEBITO  with ::FormCad2:stSZ42:Debito
       Replace SZ4->Z4_CREDITO with ::FormCad2:stSZ42:Credito //yury rogens 09/07
       Replace SZ4->Z4_SEQ     with ::FormCad2:stSZ42:Sequencia
       Replace SZ4->Z4_TRANSMI with "S"
     SZ4->(MsUnlock())
     
     ::cOk := "100 - Pagamento de Fatura gravado com sucesso."
   else
     ::cOk := "200 - Ja existe o registro - Chave: " + xFilial("SZ4") + "-" + PadR(::FormCad2:stSZ42:Cartao, TamSX3("Z4_CARTAO")[1]) +;
              "-" + PadR(::FormCad2:stSZ42:DtOpera, TamSX3("Z4_DATA")[1]) + "-" + PadR(::FormCad2:stSZ42:Hora, TamSX3("Z4_HORA")[1])
  EndIf
  
  RpcClearEnv()
Return lRet

/*/{Protheus.doc} WSPDVRET
  Função InclSZ5
  @param Retorno do SOAP
  @return Não retorna nada 
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 14/08/2018 
  @sample
// InclSZ5 - Função integração do PDV x Retaguarda via SOAP - Inclusão Pagamento de Cartão x Cheque.
  Return
  @project 
  @history
  14/08/2018 - Desenvolvimento da Rotina.
/*/
WSMethod InclSZ5 WSReceive FormCCh WSSend cOk WSService WSPDVRET
  Local lRet := .T.

  ::cOk := ""

  RpcClearEnv()
  RpcSetType(3)

  If ! RpcSetEnv(Substr(::FormCCh:stSZ5:Filial,1,2),AllTrim(::FormCCh:stSZ5:Filial),,,"FAT")
	 ::cOk := "400 - Usuario sem acesso ou Empresa/Filial nao existe."
	 
	 SetSoapFault(ProcName(), ::cOk)
     Return .F.
  EndIf

 // --- Verificar se existe 
 // -----------------------
  dbSelectArea("SZ5")
  SZ5->(dbSetOrder(1))
  
  If ! SZ5->(dbSeek(xFilial("SZ5") + PadR(::FormCCh:stSZ5:PDV, TamSX3("Z5_PDV")[1]) +;
                    PadR(::FormCCh:stSZ5:Sequencia, TamSX3("Z5_SEQ")[1]) +;
                    PadR(::FormCCh:stSZ5:Tipo, TamSX3("Z5_TIPO")[1])))
     Reclock("SZ5",.T.)
       Replace SZ5->Z5_FILIAL  with xFilial("SZ5")
       Replace SZ5->Z5_TIPO    with ::FormCCh:stSZ5:Tipo
       Replace SZ5->Z5_SEQ     with ::FormCCh:stSZ5:Sequencia
       Replace SZ5->Z5_BANCO   with ::FormCCh:stSZ5:Banco
       Replace SZ5->Z5_AGENCIA with ::FormCCh:stSZ5:Agencia
       Replace SZ5->Z5_CONTA   with ::FormCCh:stSZ5:Conta
       Replace SZ5->Z5_DVCTA   with ::FormCCh:stSZ5:Digito
       Replace SZ5->Z5_NUMCHQ  with ::FormCCh:stSZ5:Cheque
       Replace SZ5->Z5_CARTAO  with ::FormCCh:stSZ5:Cartao
       Replace SZ5->Z5_CPFCNPJ with ::FormCCh:stSZ5:CPFCNPJ
       Replace SZ5->Z5_EMITENT with ::FormCCh:stSZ5:Emitente
       Replace SZ5->Z5_NSU     with ::FormCCh:stSZ5:NSU
       Replace SZ5->Z5_DATA    with SToD(::FormCCh:stSZ5:DtOpera)
       Replace SZ5->Z5_HORA    with ::FormCCh:stSZ5:Hora
       Replace SZ5->Z5_VALOR   with ::FormCCh:stSZ5:Valor
       Replace SZ5->Z5_OPERADO with ::FormCCh:stSZ5:Operador
       Replace SZ5->Z5_PDV     with ::FormCCh:stSZ5:PDV
       Replace SZ5->Z5_TRANSMI with "S"
     SZ5->(MsUnlock())
     
     ::cOk := "100 - Pagamento de Fatura x Cheque gravado com sucesso."
   else
     ::cOk := "200 - Ja existe o registro - Chave: " + xFilial("SZ5") + "-" + PadR(::FormCCh:stSZ5:PDV, TamSX3("Z5_PDV")[1]) +;
              "-" + PadR(::FormCCh:stSZ5:Sequencia, TamSX3("Z5_SEQ")[1]) + "-" + PadR(::FormCCh:stSZ5:Tipo, TamSX3("Z5_TIPO")[1])
  EndIf    

  RpcClearEnv()
Return lRet

/*/{Protheus.doc} WSPDVRET
  Função fnPgInv
  @param Retorno do SOAP
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 14/08/2018 
  @sample
// fnPgInv - Função integração do PDV x Retaguarda via SOAP - Pegar o campo com erro no MsExecAuto.
  Return
  @project 
  @history
  14/08/2018 - Desenvolvimento da Rotina.
/*/
Static Function fnPgInv(aAutoErro)
  Local cRet := ""
  Local nX   := 1                        

  For nX := 1 To Len(aAutoErro) 
    //  If (At("HELP: ",aAutoErro[nX]) > 0) .or. (At("Invalido",aAutoErro[nX]) > 0) 
         cRet += StrTran(aAutoErro[nX],Chr(13) + Chr(10)," ")
    //  EndIf   
  Next            
Return cRet
