concrete LogicSpa of Logic = CategoriesSpa, LexiconSATSpa ** open
  SyntaxSpa,
  (P = ParadigmsSpa),
  (E = ExtraSpa),
  (MS = MakeStructuralSpa),
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

  -- Equivalencia de dos proposiciones
  PEquiv = mkS sii_Conj ;

  -- Pred1 Negado
  NegatedPred1 _ p = { cl = p.cl ; pol = Neg ; s = p.s } ;

  -- Predicado unario como proposición atómica
  APred1 _ p x = appPred1 p x ;

  ANPred1 _ p x = mkS negativePol (appPred1 p x) ;

  -- Predicados binarios como proposicies atómicas
  APred2 _ p x y = appPred2 p x y ;

  -- no se parsean frases de la forma "para todo x, x es rojo".
  -- PUniv v p = mkS (mkAdv for_Prep (mkNP all_Predet (mkNP (SymbPN v)))) p ;
  -- PExist v p =
  --  mkS (mkCl (mkNP a_Quant (mkCN (mkCN element_N (mkNP (SymbPN v)))
  --    (mkAP (mkAP such_A) p)))) ;

  IVar x = mkNP (SymbPN x) ;

  Equal = { cl = SerC ; s = P.mkA2 (P.mkA "igual") to_Prep } ;
  Different = { cl = SerC ; s = P.mkA2 (P.mkA ("diferente" | "distinto")) part_Prep } ;


  IFun1 f = app f ;
  IFun2 f = app f ;

  VString s = mkSymb s.s ;

  -- Conjunciones
  CAnd = and_Conj ;
  COr = or_Conj ;

-- extension con Kind

lin
  PNegAtom = mkS negativePol ;
  PartPred _ p i = { cl = p.cl ; pol = Pos ; s = mkAP p.s i } ;

  APredRefl _ p i = case p.cl of {
    SerC => mkCl i (reflAP p.s) ;
    EstarC => mkCl i (E.UseComp_estar (mkComp (reflAP p.s)))
  } ;

  APred2Distr _ p _ inds = mkCl (mkNP and_Conj inds) (mkAP p.s) ;

  UnivIS _ _ k _ _ p = mkQuantIS ForAll k p ;

  ExistIS _ _ k _ _ p = mkQuantIS Exist k p ;

  NoneIS _ _ k _ _ p = mkQuantIS None k p ;

  ModKind k _ _ m _ _ = { cl = classCtoCK m.cl ; pol = m.pol ; n = k.n ; a = m.s } ;

-- extension conjunción polimórfica
lin

  PConjs = mkS ;

  BaseProp = mkListS ;
  ConsProp = mkListS ;

  -- BaseVar x = mkNP (SymbPN x) ;
  -- ConsVar x xs = mkNP and_Conj (mkListNP (mkNP (SymbPN x)) xs) ;

  BaseInd = mkListNP ;
  ConsInd = mkListNP ;

  BasePred1 _ _ p1 p2 = mkListAP p1.s p2.s ;
  ConsPred1 _ _ p lp = mkListAP p.s lp ;

  ConjPred1Ser c lp = { cl = SerC ; pol = Pos ; s = mkAP c lp } ;
  ConjPred1Estar c lp = { cl = EstarC ; pol = Pos ; s = mkAP c lp } ;
  ConjNegPred1Ser lp = { cl = SerC ; pol = Neg ; s = mkAP ni_Conj lp } ;
  ConjNegPred1Estar lp = { cl = EstarC ; pol = Neg ; s = mkAP ni_Conj lp } ;

  ConjInd = mkNP ;

  APred2Univ _ p i _ k = appPred2Quant p i ForAll k ;
  APred2Exist _ p i _ k = appPred2Quant p i Exist k ;
  APred2None _ p i _ k = mkS negativePol (appPred2Quant p i None k) ;

oper
  mkFun1, mkFun2 : Str -> N2 = \s -> P.mkN2 (P.mkN s) part_Prep ;

  appPred1 : Pred1T -> NP -> Cl =
    \p, x -> case p.cl of {
              SerC => mkCl x p.s ;
              EstarC => mkCl x (E.UseComp_estar (mkComp p.s))
            } ;

  appPred2 : Pred2T -> NP -> NP -> Cl =
    \p, x, y -> case p.cl of {
                  SerC => mkCl x p.s y ;
                  EstarC => mkCl x (E.UseComp_estar (mkComp (mkAP p.s y)))
                } ;

  appPred2Quant : Pred2T -> NP -> QuantP -> KindT -> Cl = 
    \p,i,q,k -> appPred2 p i (quantNP q k) ;

  classCtoCK : ClassC -> ClassCK =
    \c -> case c of {
      SerC => SerCK ;
      EstarC => EstarCK
    };

  mkSPol : Pol1 -> (Cl -> S) =
    \pol -> case pol of {
      Pos => mkS ;
      Neg => mkS negativePol
    } ;

  kindCN : KindT -> CN = 
    \k ->
    case k.pol of {
      Pos =>
        case k.cl of {
          SerCK => mkCN k.a k.n ;
          EstarCK => (mkCN k.n (mkRS (mkRCl which_RP (E.UseComp_estar (mkComp k.a)) ))) ;
          FigC => k.n
        } ;
      Neg =>
        case k.cl of {
          SerCK => (mkCN k.n (mkRS negativePol (mkRCl which_RP k.a))) ;
          _ => (mkCN k.n (mkRS negativePol (mkRCl which_RP (E.UseComp_estar (mkComp k.a)) )))  -- Fig no puede ser negativo
        }
    } ;

  quantNP : QuantP -> KindT -> NP =
    \q, k ->
      case q of {
        ForAll => let np = (mkNP thePl_Det (kindCN k)) in (mkNP all_Predet np | np) ;
        Exist => mkNP someSg_Det (kindCN k) ;
        None => mkNP (mkDet no_Quant) (kindCN k)
      } ;

  mkQuantIS : QuantP -> KindT -> Pred1T -> S =
    \q, k, p -> case p.cl of {
      EstarC => (mkSPol p.pol) (mkCl (quantNP q k) (E.UseComp_estar (mkComp p.s))) ;
      SerC => (mkSPol p.pol) (mkCl (quantNP q k) p.s)
    } ;

-- structural words
oper
  case_N = P.mkN "caso" ;
  such_A = P.mkA "tal" ;
  then_Adv = P.mkAdv "entonces" ;
  element_N = P.mkN "elemento" ;
  sii_Conj = MS.mkConj "" "si y solo si" P.singular ;
  ni_Conj = MS.mkConj "" "ni" P.singular ;
}
