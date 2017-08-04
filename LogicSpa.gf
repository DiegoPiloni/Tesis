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
  APred1 p x = case p.t of {
                 (PA Position) => mkCl x (E.UseComp_estar (mkComp p.s)) ;
                 _ => mkCl x p.s
               } ;

  -- Predicados binarios como proposicies atómicas
  APred2 p x y = case p.t of {
                   Position => mkCl x (E.UseComp_estar (mkComp (mkAP p.s y))) ;
                   _ => mkCl x p.s y
                 } ;
 
  -- no se parsean frases de la forma "para todo x, x es rojo".
  -- PUniv v p = mkS (mkAdv for_Prep (mkNP all_Predet (mkNP (SymbPN v)))) p ;
  -- PExist v p = 
  --  mkS (mkCl (mkNP a_Quant (mkCN (mkCN element_N (mkNP (SymbPN v))) 
  --    (mkAP (mkAP such_A) p)))) ;

  IVar x = mkNP (SymbPN x) ;

  Equal = { t = Equality ; s = P.mkA2 (P.mkA "igual") to_Prep } ;
  Different = { t = Inequality ; s = P.mkA2 (P.mkA ("diferente" | "distinto")) part_Prep } ;


  IFun1 f = app f ; 
  IFun2 f = app f ; 

  VString s = mkSymb s.s ;

  CAnd = and_Conj ;
  COr = or_Conj ;

-- extension con Kind

lin
  -- AKind k x = mkCl x k ;
  PNegAtom = mkS negativePol ;
  PartPred p i = {t = PA p.t ; s = mkAP p.s i } ;
  APredRefl p i = case p.t of {
                    Position => mkCl i (E.UseComp_estar (mkComp (reflAP p.s))) ;
                    _ => mkCl i (reflAP p.s)
                  } ;
  
  APred2Distr p _ inds = mkCl (mkNP and_Conj inds) (mkAP p.s) ;  

  UnivIS v k p = case p.t of {
                   (PA Position) => mkS (mkCl (mkNP every_Det k) (E.UseComp_estar (mkComp p.s))) ;
                   _ => mkS (mkCl (mkNP every_Det k) p.s)
                 } ;
  ExistIS v k p = case p.t of {
                    (PA Position) => mkS (mkCl (mkNP someSg_Det k) (E.UseComp_estar (mkComp p.s))) ;
                    _ => mkS (mkCl (mkNP someSg_Det k) p.s)
                  } ; 

  ModKind k m = mkCN m.s k ;
  
-- extension conjunción polimórfica
lin

  PConjs = mkS ;
  
  BaseProp = mkListS ;
  ConsProp = mkListS ;

  -- BaseVar x = mkNP (SymbPN x) ;
  -- ConsVar x xs = mkNP and_Conj (mkListNP (mkNP (SymbPN x)) xs) ;

  BaseInd = mkListNP ;
  ConsInd = mkListNP ;

  BasePred1 p1 p2 = mkListAP p1.s p2.s ;
  ConsPred1 p lp = mkListAP p.s lp ;

  ConjPred1 c lp = { t = Original ; s = mkAP c lp } ;
  ConjInd = mkNP ;


oper
  mkFun1, mkFun2 : Str -> N2 = \s -> P.mkN2 (P.mkN s) part_Prep ;

-- structural words

oper
  case_N = P.mkN "caso" ;
  such_A = P.mkA "tal" ;
  then_Adv = P.mkAdv "entonces" ;
  element_N = P.mkN "elemento" ;
}
