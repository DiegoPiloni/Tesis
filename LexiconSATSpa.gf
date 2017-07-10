concrete LexiconSATSpa of LexiconSAT = CategoriesSpa ** open 
  SyntaxSpa, 
  (P = ParadigmsSpa) in {

-- test lexicon

lin

  -- Pred1
  Rojo = mkAP (P.mkA "rojo") ;
  Azul = mkAP (P.mkA "azul") ;
  Verde = mkAP (P.mkA "verde") ;
  
  Chico = mkAP (P.mkA "chico") ;
  Mediano = mkAP (P.mkA "mediano") ;
  Grande = mkAP (P.mkA "grande") ;

  Triangulo = mkAP (P.mkA "triangular") ;
  Cuadrado = mkAP (P.mkA "cuadrado") ;
  Circulo = mkAP (P.mkA "circular") ;

  -- Kind
  Figura = mkCN (P.mkN "figura") ;

  -- Pred2
  Izquierda = P.mkA2 (P.mkA "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda") part_Prep ;
  Derecha = P.mkA2 (P.mkA "a la derecha" "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda") part_Prep ;
  Abajo = P.mkA2 (P.mkA "abajo" "abajo" "abajo" "abajo" "abajo") part_Prep ;
  Arriba = P.mkA2 (P.mkA "arriba" "arriba" "arriba" "arriba" "arriba") part_Prep ;


}