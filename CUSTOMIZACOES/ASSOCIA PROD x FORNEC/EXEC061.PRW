#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"


#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"


User Function EXEC061()
  Local cCodForn := "37537128"
  Local cLojaFornec := "0001"
  lOCAL cNomFornec := "FS COMERCIAL ATACADISTA DE ROUPAS LTDA  "
  Local nI := 0
  Local nTotal := 0

  Private aVetor := {} 

  Alert("Aguarde consulta")    
  cQuery := "SELECT B1_COD, B1_DESC FROM "
  cQuery += "    (SELECT DISTINCT B1_COD, B1_DESC   "
  cQuery += "     FROM SD1010 , SB1010 "
  cQuery += "     WHERE D1_EMISSAO >= '20200101' "
  cQuery += "       AND D1_COD = B1_COD "
  cQuery += "         "
  cQuery += "     UNION "
  cQuery += "         "
  cQuery += "     SELECT DISTINCT B1_COD, B1_DESC   "
  cQuery += "     FROM SB2010, SB1010 "
  cQuery += "     WHERE B2_COD = B1_COD "
  cQuery += "       AND B2_QATU <> 0)X "
  cQuery += "    WHERE B1_COD NOT IN (SELECT A5_PRODUTO FROM SA5010 WHERE A5_FORNECE = '37537128')"
       
  cQuery := ChangeQuery(cQuery) 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qrVendas", .F., .T.)
          
  While !Eof()  
    AADD( aVetor, { B1_COD, B1_DESC} )  
    dbSkip() 
  End  

  If Len( aVetor ) == 0    
    Aviso( cTitulo, "Não existe dados a  consultar", {"Ok"} )   
    DBCloseArea() 
    Return 
  Endif  
  
  nTotal := len(aVetor)
  ProcRegua(nTotal)     
  for nI := 1 to len(aVetor)  
    u_EXE061a(aVetor[nI][1], aVetor[nI][2], cCodForn, cLojaFornec, cNomFornec)
    IncProc("Analisando registro " + cValToChar(nI) + " de " + cValToChar(nTotal) + "...")
  next

  alert("Concluído")
Return

User Function Call061()
  Processa( {|| U_EXEC061() }, "Aguarde...", "Associando Produtos ao Fornecedor...",.F.)
Return 


User Function EXE061a(cProd, cDesc, cCodForn, cLojaFornec, cNomFornec)

  Local nOpc := 3
  Local oModel := Nil
  Local cProd01 := cProd
  Local cDesc01 := cDesc

  Local cForn1 := cCodForn
  Local cLoja1 := cLojaFornec 
  Local cNomForn1 := cNomFornec

  oModel := FWLoadModel('MATA061')
  
  oModel:SetOperation(nOpc)
  oModel:Activate()
  
//Cabeçalho
  oModel:SetValue('MdFieldSA5','A5_PRODUTO', cProd01)
  oModel:SetValue('MdFieldSA5','A5_NOMPROD', cDesc01)

  //Grid
  oModel:SetValue('MdGridSA5','A5_FORNECE',cForn1)
  oModel:SetValue('MdGridSA5','A5_LOJA' ,cLoja1)
  oModel:SetValue('MdGridSA5','A5_NOMEFOR', cNomForn1)
  oModel:SetValue('MdGridSA5','A5_CODPRF', cProd01) 

  If oModel:VldData()
    oModel:CommitData()
  Endif

  oModel:DeActivate()

  oModel:Destroy()
Return



User Function EXE061T()

Local nOpc := 3
Local oModel := Nil
Local cProd01 := "00100001001201"
Local cDesc01 := 'POTE VIDRO REPOSICAO'
//Local cProd02 := "09509900066031"
//Local cDesc02 := 'POLO DUDALINA MC JACQUARD GOLA 8751099-15 AMARELO M'

//Local cForn1 := "37537128"
Local cForn1 := "08398455"
Local cLoja1 := "0001"
//Local cForn2 := "002"
//Local cLoja2 := "01"

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0102" MODULO "COM"


oModel := FWLoadModel('MATA061')

oModel:SetOperation(nOpc)
oModel:Activate()

//Cabeçalho
oModel:SetValue('MdFieldSA5','A5_PRODUTO', cProd01)
oModel:SetValue('MdFieldSA5','A5_NOMPROD', cDesc01)

//Grid
oModel:SetValue('MdGridSA5','A5_FORNECE',cForn1)
oModel:SetValue('MdGridSA5','A5_LOJA' ,cLoja1)
oModel:SetValue('MdGridSA5','A5_NOMEFOR', 'COMERCIAL ALCIDES ARAUJO LTDA (MATRIZ)')
oModel:SetValue('MdGridSA5','A5_CODPRF', cProd01) 

//Nova linha na Grid
//oModel:GetModel("MdGridSA5"):AddLine()
//oModel:SetValue('MdGridSA5','A5_FORNECE',cForn2)
//oModel:SetValue('MdGridSA5','A5_LOJA' ,cLoja2)
//oModel:SetValue('MdGridSA5','A5_NOMEFOR', 'FS COMERCIAL ATACADISTA DE ROUPAS LTDA ')

If oModel:VldData()
oModel:CommitData()
Endif

oModel:DeActivate()

oModel:Destroy()
alert("Terminando")

//RESET ENVIRONMENT

alert("Terminei")

Return

