concrete LexiconSATSym of LexiconSAT = CategoriesSym ** {

-- test lexicon

lin

  -- Pred1
  Chico = pred1_original "Chico" ;
  Mediano = pred1_original "Mediano" ;
  Grande = pred1_original "Grande" ;

  Rojo = pred1_original "Rojo" ;
  Verde = pred1_original "Verde" ;
  Azul = pred1_original "Azul" ;

  Circulo = pred1_original "Circ" ;
  Triangulo = pred1_original "Tr" ;
  Cuadrado = pred1_original "Cuad" ;
  
  -- Pred2
  Izquierda = pred2_position "izq" ;
  Derecha = pred2_position "der" ;
  Arriba = pred2_position "arriba" ;
  Abajo = pred2_position "abajo" ;

  -- ind vacio, solo se usa si es aplicacion parcial. Mejor solución?
  oper pred1_original : Str -> { t : Pred1Type ; symb : Str ; ind : Str } = 
       \symbol -> { t = Original ; symb = symbol ; ind = "" } ;

  oper pred2_position : Str -> { t : Pred2Type ; s : Str } = 
       \symbol -> {t = Position ; s = symbol } ;

  -- Kind
  -- No se linealizan los Kinds.

}
