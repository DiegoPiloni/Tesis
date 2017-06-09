concrete LogicSpa of Logic = open 
  SyntaxSpa, 
  (P = ParadigmsSpa), 
  (E = ExtraSpa),
  SymbolicSpa, 
  SymbolSpa,
  Prelude in {

flags coding = utf8 ;

lincat
  Prop = S ;
  Atom = Cl ;
  AtomEqual = Cl ;
  Pred1 = AP ;
  Pred2 = A2 ;
  Var = Symb ;
  Conj = SyntaxSpa.Conj ;
  Ind = NP ;
  Fun1 = N2 ;
  Fun2 = N2 ;

lin
  PAtom = mkS ;
  PNeg p =  
    mkS negativePol (mkCl 
      (mkVP (mkNP the_Quant (mkCN case_N (mkAdv that_Subj p))))) ; 
  PConj = mkS ;
  PImpl p q = mkS (mkAdv if_Subj p) (mkS then_Adv q) ;
  -- ya no se puede pueden parsear frases de la forma "para todo x, x es rojo".
  -- PUniv v p = mkS (mkAdv for_Prep (mkNP all_Predet (mkNP (SymbPN v)))) p ;
  -- PExist v p = 
  --  mkS (mkCl (mkNP a_Quant (mkCN (mkCN element_N (mkNP (SymbPN v))) 
  --    (mkAP (mkAP such_A) p)))) ;
  APred1 f x = mkCl x f ;
  AEqual x y = mkCl x equal_A2 y ;
  APred2 f x y = mkCl x (E.UseComp_estar (mkComp (mkAP f y))) ;  -- no está bueno si quiero hacerlo parametrico en la signatura

  IVar x = mkNP (SymbPN x) ;

  IFun1 f = app f ; 
  IFun2 f = app f ; 

  VString s = mkSymb s.s ;

  CAnd = and_Conj ;
  COr = or_Conj ;

-- supplementary

lincat
  Kind = CN ;
lin
  -- AKind k x = mkCl x k ;
  PNegAtom = mkS negativePol ;
  PNegEqual x y = mkS (mkCl x diff_A2 y) ;
  UnivIS v k p = mkS (mkCl (mkNP every_Det k) p) ;
  ExistIS v k p = mkS (mkCl (mkNP someSg_Det k) p) ;
  ModKind k m = mkCN m k ;


oper
  mkFun1, mkFun2 : Str -> N2 = \s -> P.mkN2 (P.mkN s) part_Prep ;

-- structural words

oper
  case_N = P.mkN "caso" ;
  such_A = P.mkA "tal" ;
  then_Adv = P.mkAdv "entonces" ;
  element_N = P.mkN "elemento" ;
  equal_A2 = P.mkA2 (P.mkA "igual") to_Prep ;
  diff_A2 = P.mkA2 (P.mkA ("diferente" | "distinto")) part_Prep ;


-- test lexicon

lin

  -- Pred1
  Rojo = mkAP (P.mkA "rojo" "roja") ;
  Azul = mkAP (P.mkA "azul") ;
  Verde = mkAP (P.mkA "verde") ;
  
  Chico = mkAP (P.mkA "chico" "chica") ;
  Mediano = mkAP (P.mkA "mediano" "mediana") ;
  Grande = mkAP (P.mkA "grande") ;

  Triangulo = mkAP (P.mkA "triangular") ;
  Cuadrado = mkAP (P.mkA "cuadrado" "cuadrada") ;
  Circulo = mkAP (P.mkA "circular") ;

  -- Kind
  Figura = mkCN (P.mkN "figura") ;

  -- Pred2
  Izquierda = P.mkA2 (P.mkA "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda") part_Prep ;
  Derecha = P.mkA2 (P.mkA "a la derecha" "a la izquierda" "a la izquierda" "a la izquierda" "a la izquierda") part_Prep ;
  Abajo = P.mkA2 (P.mkA "abajo" "abajo" "abajo" "abajo" "abajo") part_Prep ;
  Arriba = P.mkA2 (P.mkA "arriba" "arriba" "arriba" "arriba" "arriba") part_Prep ;
}
