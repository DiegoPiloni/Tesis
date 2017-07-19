concrete LexiconSATSpa of LexiconSAT = CategoriesSpa ** open 
  SyntaxSpa, 
  (P = ParadigmsSpa) in {

-- test lexicon (SAT)

lin

  -- Pred1
  Rojo = pred1_original (mkAP (P.mkA "rojo")) ;
  Azul = pred1_original (mkAP (P.mkA "azul")) ;
  Verde = pred1_original (mkAP (P.mkA "verde")) ;
  
  Chico = pred1_original (mkAP (P.mkA "chico")) ;
  Mediano = pred1_original (mkAP (P.mkA "mediano")) ;
  Grande = pred1_original (mkAP (P.mkA "grande")) ;

  Triangulo = pred1_original (mkAP (P.mkA "triangular")) ;
  Cuadrado = pred1_original (mkAP (P.mkA "cuadrado")) ;
  Circulo = pred1_original (mkAP (P.mkA "circular")) ;


  -- Kind
  Figura = mkCN (P.mkN "figura") ;

  -- Pred2
  Izquierda = pred2_position (P.mkA2 (P.mkA "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda") part_Prep) ;
  Derecha = pred2_position (P.mkA2 (P.mkA "a la derecha" "a la derecha" "a la derecha" "a la derecha" "a la derecha" ) part_Prep) ;
  Abajo = pred2_position (P.mkA2 (P.mkA "abajo" "abajo" "abajo" "abajo" "abajo") part_Prep) ;
  Arriba = pred2_position (P.mkA2 (P.mkA "arriba" "arriba" "arriba" "arriba" "arriba") part_Prep) ;

  oper pred1_original : AP -> {t : Pred1Type ; s : AP } = 
       \ap -> { t = Original ; s = ap } ;

  oper pred2_position : A2 -> {t : Pred2Type ; s : A2 } = 
       \a2 -> {t = Position ; s = a2 } ;
       
}
