concrete LogicSpa of Logic = CategoriesSpa, LexiconSATSpa ** open 
  SyntaxSpa, 
  (P = ParadigmsSpa), 
  (E = ExtraSpa),
  SymbolicSpa, 
  SymbolSpa,
  Prelude in {

flags coding = utf8 ;

lin
  -- Proposiciones atómicas
  PAtom = mkS ;

  -- Negación de un proposición
  PNeg p =  
    mkS negativePol (mkCl 
      (mkVP (mkNP the_Quant (mkCN case_N (mkAdv that_Subj p))))) ; 

  -- Conjunción de dos proposiciones
  PConj = mkS ;

  -- Implicación de dos proposiciones
  PImpl p q = mkS (mkAdv if_Subj p) (mkS then_Adv q) ;

  -- Predicado unario como proposición atómica
  APred1 f x = mkCl x f ;

  -- Predicados binarios como proposicies atómicas
  APred2 f x y = mkCl x (E.UseComp_estar (mkComp (mkAP f y))) ;  -- no está bueno si quiero hacerlo parametrico en la signatura
  AEqual x y = mkCl x equal_A2 y ;
 
  -- ya no se puede pueden parsear frases de la forma "para todo x, x es rojo".
  -- PUniv v p = mkS (mkAdv for_Prep (mkNP all_Predet (mkNP (SymbPN v)))) p ;
  -- PExist v p = 
  --  mkS (mkCl (mkNP a_Quant (mkCN (mkCN element_N (mkNP (SymbPN v))) 
  --    (mkAP (mkAP such_A) p)))) ;

  IVar x = mkNP (SymbPN x) ;

  IFun1 f = app f ; 
  IFun2 f = app f ; 

  VString s = mkSymb s.s ;

  CAnd = and_Conj ;
  COr = or_Conj ;

-- extension con Kind

lin
  -- AKind k x = mkCl x k ;
  PNegAtom = mkS negativePol ;
  PNegEqual x y = mkS (mkCl x diff_A2 y) ;
  UnivIS v k p = mkS (mkCl (mkNP every_Det k) p) ;
  ExistIS v k p = mkS (mkCl (mkNP someSg_Det k) p) ;
  ModKind k m = mkCN m k ;

-- extension conjunción polimórfica
lin
  -- PConjs = mkS ;

  -- BaseProp = mkListS ;
  -- ConsProp = mkListS ;

  -- BaseVar x = mkNP (SymbPN x) ;
  -- ConsVar x xs = mkNP and_Conj (mkListNP (mkNP (SymbPN x)) xs) ;

  BaseInd = mkListNP ;
  ConsInd = mkListNP ;

  BasePred1 = mkListAP ;
  ConsPred1 = mkListAP ;

  ConjPred1 = mkAP ;
  ConjInd = mkNP ;


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

}
