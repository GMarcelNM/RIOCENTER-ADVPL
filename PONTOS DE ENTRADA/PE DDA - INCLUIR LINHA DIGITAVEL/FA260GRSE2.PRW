#include "rwmake.ch"
/*

Ponto de entrada para tratar campos no momento 
da conciliação do DDA.
*/
User Function FA260GRSE2()


SE2->E2_LINDIG  :=  FinCBLD(SE2->E2_CODBAR)


Return Nil
