#INCLUDE "PROTHEUS.CH"


User Function ManArray()

  Local aFormPg := {}
  Local aFormPg2 := {}
  Local aPagtos := {}
  Local nPos := 0
  Local zZ := 0
  Local cFormaPgto := ""
  Local cVlrFormPg := ""
  Local nCredito := 179.8
  Local nX := 0


		//             aAdd(aFormPg, {SL4->L4_FORMA,SL4->L4_ADMINIS,SL4->L4_VALOR})
		//
		// aFormpg[zZ][1]  FORMA
		// aFormpg[zZ][2]  ADMINIS
		// aFormpg[zZ][3]  VALOR

  aAdd(aFormPg, {"R$", "", 100.0})
  aAdd(aFormPg, {"R$", "", 79.8})
  aAdd(aFormPg, {"R1", "010 - R1 - RIO CENTE", 35.96})
  aAdd(aFormPg, {"R1", "010 - R1 - RIO CENTE", 35.96})
  aAdd(aFormPg, {"R1", "010 - R1 - RIO CENTE", 35.96})
  aAdd(aFormPg, {"R1", "010 - R1 - RIO CENTE", 35.96})
 // aAdd(aFormPg, {"R1", "010 - R1 - RIO CENTE", 35.96})
           
  aAdd(aPagtos, {"Dinheiro", 179.8})
  aAdd(aPagtos, {"Cartão", 143.84})
  aAdd(aPagtos, {"Credito", 179.8})

  //nPosField := AScan(aVetor, {|x| AllTrim(x[2]) == "Campo2_3"})
     
	aFormPg2 := {}
	For zZ := 1 to Len(aFormPg)
		IF Alltrim(aFormpg[zZ][1]) $ "R1,R2,R3,R4,R5" 
		  nPos := AScan(aFormPg2, {|x| AllTrim(x[1]) == "Cartão RIO CENTER"}) 
			If (nPos <> 0)
        aFormPg2[nPos][2] += aFormpg[zZ][3]
        aFormPg2[nPos][3] += 1
      else
        aAdd(aFormPg2, {"Cartão RIO CENTER", aFormpg[zZ][3], 1, .F.})
      Endif      
	  Elseif Alltrim(aFormpg[zZ][1]) $ "PY" 
		  nPos := AScan(aFormPg2, {|x| AllTrim(x[1]) == "PEGGY"}) 
			If (nPos <> 0)
        aFormPg2[nPos][2] += aFormpg[zZ][3]
        aFormPg2[nPos][3] += 1
      else
        aAdd(aFormPg2, {"PEGGY", aFormpg[zZ][3], 1, .F.})
      Endif      
		Elseif Alltrim(aFormpg[zZ][1]) $ "B2" 
		  nPos := AScan(aFormPg2, {|x| AllTrim(x[1]) == "B2W"}) 
			If (nPos <> 0)
        aFormPg2[nPos][2] += aFormpg[zZ][3]
        aFormPg2[nPos][3] += 1
      else
        aAdd(aFormPg2, {"B2W", aFormpg[zZ][3], 1, .F.})
      Endif      
    Elseif Alltrim(aFormpg[zZ][1]) $ "R$" 
			nPos := AScan(aFormPg2, {|x| AllTrim(x[1]) == "Dinheiro"}) 
			If (nPos <> 0)
        aFormPg2[nPos][2] += aFormpg[zZ][3]
        aFormPg2[nPos][3] += 1
      else
        aAdd(aFormPg2, {"Dinheiro", aFormpg[zZ][3], 1, .F.})
      Endif
		Else
      nPos := AScan(aFormPg2, {|x| AllTrim(x[1]) == "Outros"}) 
			If (nPos <> 0)
        aFormPg2[nPos][2] += aFormpg[zZ][3]
        aFormPg2[nPos][3] += 1
      else
        aAdd(aFormPg2, {"Outros", aFormpg[zZ][3], 1, .F.})
      Endif
		Endif
	Next zZ

  alert("entrei")
  
	For zZ := 1 to Len(aFormPg2)
    alert( aFormPg2[zZ][1])
    alert(aFormPg2[zZ][2])
    alert(aFormPg2[zZ][3])
  next
  

	For nX := 1 to Len(aPagtos)
    cFormaPgto := ""
		For zZ := 1 to Len(aFormPg2)
			IF aFormPg2[zZ][2] == aPagtos[nX][2] .and. !aFormPg2[zZ][4]
				If aFormPg2[zZ][3] > 1 .and. aFormPg2[zZ][1] == "Cartão RIO CENTER"
          cFormaPgto := aFormPg2[zZ][1] + ' / ' + cvaltochar(aFormPg2[zZ][3]) + 'X'
        else  
          cFormaPgto := aFormPg2[zZ][1]
        endif  
				aFormPg2[zZ][4] := .T.
				exit
			Endif
    Next zZ
    if cFormaPgto = "" 
      if nCredito == aPagtos[nX][2]
        cFormaPgto := "Crédito Troca"
      Else 
        cFormaPgto := "Outros"
      endif  
    endif  
  	cVlrFormPg := AllTrim( Transform(aPagtos[nX][2], '@E 999,999,999,999,999.99') )

		Alert(cFormaPgto + " - " + cVlrFormPg)
		
//  	cVlrFormPg := AllTrim( Transform(Val(aPagNfce[nX]:_VPAG:TEXT), '@E 999,999,999,999,999.99') )

//		cTexto += (TAG_CENTER_INI + cTagCondIni + cFormaPgto + PadL( cVlrFormPg, nColunas-Len(cFormaPgto) ) + cTagCondFim + TAG_CENTER_FIM)
	Next nX


	For nX := 1 to Len(aPagNFCe)
    cTexto += cCRLF
    cFormaPgto := ""
		For zZ := 1 to Len(aFormPg2)
			IF aFormPg2[zZ][2] == Val(aPagNfce[nX]:_VPAG:TEXT) .and. !aFormPg2[zZ][4]
				If aFormPg2[zZ][3] > 1 .and. aFormPg2[zZ][1] == "Cartão RIO CENTER"
          cFormaPgto := aFormPg2[zZ][1] + ' / ' + cvaltochar(aFormPg2[zZ][3]) + 'X'
        else  
          cFormaPgto := aFormPg2[zZ][1]
        endif  
				aFormPg2[zZ][4] := .T.
				exit
			Endif
    Next zZ
    if cFormaPgto = "" 
      if nCredito == Val(aPagNfce[nX]:_VPAG:TEXT)
        cFormaPgto := "Crédito Troca"
      Else 
        cFormaPgto := "Outros"
      endif  
    endif  
  	    
    cVlrFormPg := AllTrim( Transform(Val(aPagNfce[nX]:_VPAG:TEXT), '@E 999,999,999,999,999.99') )
          
		cTexto += (TAG_CENTER_INI + cTagCondIni + cFormaPgto + PadL( cVlrFormPg, nColunas-Len(cFormaPgto) ) + cTagCondFim + TAG_CENTER_FIM)
	Next nX


/*
	For nX := 1 to Len(aPagNFCe)
		cTexto += cCRLF

		For zZ := 1 to Len(aFormPg)
			IF aFormpg[zZ][3] == Val(aPagNfce[nX]:_VPAG:TEXT)
				IF Alltrim(aFormpg[zZ][1]) $ "R1,R2,R3,R4,R5"  .and. !lR1
					cFormaPgto := "Cartão RIO CENTER"
					lR1 := .T.
					exit
				Elseif Alltrim(aFormpg[zZ][1]) $ "PY" .and. !lPy
					cFormaPgto := "PEGGY"
					lPy := .T.
					exit
				Elseif Alltrim(aFormpg[zZ][1]) $ "B2" .and. !lB2
					cFormaPgto := "B2W"
					lB2 := .T.
					exit
				Elseif Alltrim(aFormpg[zZ][1]) $ "R$" .and. !lRS
					cFormaPgto := "Dinheiro"
					lRS := .T.
					exit
				Else
					cFormaPgto := "Outros"
  			Endif
			Endif
    Next zZ
		
  	cVlrFormPg := AllTrim( Transform(Val(aPagNfce[nX]:_VPAG:TEXT), '@E 999,999,999,999,999.99') )

		cTexto += (TAG_CENTER_INI + cTagCondIni + cFormaPgto + PadL( cVlrFormPg, nColunas-Len(cFormaPgto) ) + cTagCondFim + TAG_CENTER_FIM)
	Next nX
*/

return       
