abstract Logic = Categories, LexiconSAT ** {

flags startcat = Prop ;

data
  True : Prop ;
  False : Prop ;
  ForAll : Quant ;
  Exists : Quant ;

data
  PAtom  : Atom  -> Prop ;                  -- x is even
  PNeg   : Prop  -> Prop ;                  -- it is not the case that x is even
  PConj  : Conj  -> Prop -> Prop -> Prop ;  -- x is even and y is odd
  PImpl  : Prop  -> Prop -> Prop ;          -- if x is even then y is odd

  -- <Qx : R.x : T.x>
  PQuant  : Quant -> Var -> Prop -> Prop -> Prop ;    -- for all number x, x is even

  IVar   : Var -> Ind ;                     -- x

  Equal : Pred2 ;
  Different : Pred2 ;

  APred1 : Pred1 -> Ind -> Atom ;           -- x is even
  APred2 : Pred2 -> Ind -> Ind -> Atom ;    -- x is above y

  IFun1  : Fun1 -> Ind -> Ind ;             -- the square of x
  IFun2  : Fun2 -> Ind -> Ind -> Ind ;      -- the sum of x and y

  VString : String -> Var ;                 -- x

  CAnd, COr : Conj ;                        -- and, or


-- supplementary. Kind introduction
data
  PNegAtom  : Atom -> Prop ;                           -- x is not even
  -- AKind  : Kind  -> Ind -> Atom ;                   -- Problema: A es una figura (no es una sentencia valida en SAT)
  UnivIS  : Var -> Kind -> Pred1 -> Prop ;             -- (in situ) every number
  ExistIS : Var -> Kind -> Pred1 -> Prop ;             -- (in situ) some number
  ModKind : Kind -> Pred1 -> Kind ;                    -- even number


-- transfer functions for quantification
fun QuantIStoP : Prop -> Prop ;
fun KindToProp : Kind -> Var -> Prop ;

def
  QuantIStoP (UnivIS v Figura p) = PQuant ForAll v True (Transfer (PAtom (APred1 p (IVar v)))) ;
  QuantIStoP (UnivIS v k p) = PQuant ForAll v (Transfer (KindToProp k v)) (Transfer (PAtom (APred1 p (IVar v)))) ;

  QuantIStoP (ExistIS v Figura p) = PQuant Exists v True (Transfer (PAtom (APred1 p (IVar v)))) ;
  QuantIStoP (ExistIS v k p) = PQuant Exists v (Transfer (KindToProp k v)) (Transfer (PAtom (APred1 p (IVar v)))) ;

  KindToProp (ModKind Figura pred) v = (PAtom (APred1 pred (IVar v))) ;
  KindToProp (ModKind k pred) v = PConj CAnd (PAtom (APred1 pred (IVar v))) (KindToProp k v) ;

-- tipos dependiente para permitir Pred2 distributivos
fun
  distr_equal : Distr Equal ;
  distr_diff : Distr Different ;


-- polimorfic conjunctions
data
  ConjPred1 : Conj -> [Pred1] -> Pred1 ;
  ConjInd : Conj -> [Ind] -> Ind ;
data
  -- aplicación parcial
  PartPred : Pred2 -> Ind -> Pred1 ;

  -- reflexividad en Pred2
  APredRefl : Pred2 -> Ind -> Atom ;

  -- distributividad de Pred2
  APred2Distr : (p : Pred2) -> Distr p -> [Ind] -> Atom ;
  
  -- conjunción de proposiciones (sentencias). e.g.: "p , q y r"
  PConjs : Conj -> [Prop] -> Prop ;
  
  -- cuantificación simbólica con lista de variables
  -- PQuants : Quant -> [Var] -> Prop -> Prop -> Prop ;


-- main transfer function
fun Transfer : Prop -> Prop ;
def
  Transfer (UnivIS v k p) = QuantIStoP (UnivIS v k p) ;
  Transfer (ExistIS v k p) = QuantIStoP (ExistIS v k p) ;
  Transfer (PAtom a) = PropPreds (PAtom a) ;
  Transfer (PNegAtom a) = PropPreds (PNegAtom a) ;
  Transfer (PConjs c lp) = PropList (PConjs c lp) ;
  Transfer (PQuant q v r t) = (PQuant q v (Transfer r) (Transfer t)) ;

-- transfer functions for list of preds and list of inds
fun PropPreds : Prop -> Prop ;

def 
  -- conj de individuos en Pred1
  PropPreds (PAtom (APred1 p (ConjInd c (BaseInd i1 i2)))) = PConj c (PropPreds (PAtom (APred1 p i1))) (PropPreds (PAtom (APred1 p i2))) ;
  PropPreds (PAtom (APred1 p (ConjInd c (ConsInd i1 li)))) = PConj c (PropPreds (PAtom (APred1 p i1))) (PropPreds (PAtom (APred1 p (ConjInd c li) ))) ;
  
  PropPreds (PNegAtom (APred1 p (ConjInd c (BaseInd i1 i2)))) = PConj c (PropPreds (PNegAtom (APred1 p i1))) (PropPreds (PNegAtom (APred1 p i2))) ;
  PropPreds (PNegAtom (APred1 p (ConjInd c (ConsInd i1 li)))) = PConj c (PropPreds (PNegAtom (APred1 p i1))) (PropPreds (PNegAtom (APred1 p (ConjInd c li)))) ;


  -- conj de individuos en Pred2
  PropPreds (PAtom (APred2 p (ConjInd c (BaseInd i1 i2)) i3 )) = PConj c (PropPreds (PAtom (APred2 p i1 i3))) (PropPreds (PAtom (APred2 p i2 i3))) ;
  PropPreds (PAtom (APred2 p (ConjInd c (ConsInd i1 li)) i2 )) = PConj c (PropPreds (PAtom (APred2 p i1 i2))) (PropPreds (PAtom (APred2 p (ConjInd c li) i2))) ;
  PropPreds (PAtom (APred2 p i3 (ConjInd c (BaseInd i1 i2)) )) = PConj c (PropPreds (PAtom (APred2 p i3 i1))) (PropPreds (PAtom (APred2 p i3 i2))) ;
  PropPreds (PAtom (APred2 p i2 (ConjInd c (ConsInd i1 li)) )) = PConj c (PropPreds (PAtom (APred2 p i2 i1))) (PropPreds (PAtom (APred2 p i2 (ConjInd c li) ))) ;
  
  PropPreds (PNegAtom (APred2 p (ConjInd c (BaseInd i1 i2)) i3 )) = PConj c (PropPreds (PNegAtom (APred2 p i1 i3))) (PropPreds (PNegAtom (APred2 p i2 i3))) ;
  PropPreds (PNegAtom (APred2 p (ConjInd c (ConsInd i1 li)) i2 )) = PConj c (PropPreds (PNegAtom (APred2 p i1 i2))) (PropPreds (PNegAtom (APred2 p (ConjInd c li) i2))) ;
  PropPreds (PNegAtom (APred2 p i3 (ConjInd c (BaseInd i1 i2)) )) = PNeg (PConj c (PropPreds (PAtom (APred2 p i3 i1))) (PropPreds (PAtom (APred2 p i3 i2)))) ;
  PropPreds (PNegAtom (APred2 p i2 (ConjInd c (ConsInd i1 li)) )) = PNeg (PConj c (PropPreds (PAtom (APred2 p i2 i1))) (PropPreds (PAtom (APred2 p i2 (ConjInd c li) )))) ;


  -- conj de individuos en Aplicación parcial de Pred2 en Pred1
  PropPreds (PAtom (APred1 (PartPred p2 (ConjInd c (BaseInd i1 i2))) i)) = PConj c (PropPreds (PAtom (APred1 (PartPred p2 i1) i))) (PropPreds (PAtom (APred1 (PartPred p2 i2) i))) ;
  PropPreds (PAtom (APred1 (PartPred p2 (ConjInd c (ConsInd i1 li))) i)) = PConj c (PropPreds (PAtom (APred1 (PartPred p2 i1) i))) (PropPreds (PAtom (APred1 (PartPred p2 (ConjInd c li)) i))) ;

  PropPreds (PNegAtom (APred1 (PartPred p2 (ConjInd c (BaseInd i1 i2))) i)) = PNeg (PConj c (PropPreds (PAtom (APred1 (PartPred p2 i1) i))) (PropPreds (PAtom (APred1 (PartPred p2 i2) i)))) ;
  PropPreds (PNegAtom (APred1 (PartPred p2 (ConjInd c (ConsInd i1 li))) i)) = PNeg (PConj c (PropPreds (PAtom (APred1 (PartPred p2 i1) i))) (PropPreds (PAtom (APred1 (PartPred p2 (ConjInd c li)) i)))) ;


  -- conj de Pred1
  PropPreds (PAtom (APred1 (ConjPred1 c (BasePred1 p1 p2)) i)) = PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 p2 i))) ;
  PropPreds (PAtom (APred1 (ConjPred1 c (ConsPred1 p1 lp)) i)) = PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 (ConjPred1 c lp) i))) ; 

  PropPreds (PNegAtom (APred1 (ConjPred1 c (BasePred1 p1 p2)) i)) = PNeg (PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 p2 i)))) ;
  PropPreds (PNegAtom (APred1 (ConjPred1 c (ConsPred1 p1 lp)) i)) = PNeg (PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 (ConjPred1 c lp) i)))) ;  

  -- distr Pred2
  PropPreds (PAtom (APred2Distr Equal d (BaseInd i1 i2))) = PAtom (APred2 Equal i1 i2) ;
  PropPreds (PAtom (APred2Distr Different d (BaseInd i1 i2))) = PAtom (APred2 Different i1 i2) ;
  PropPreds (PNegAtom (APred2Distr Equal d (BaseInd i1 i2))) = PNegAtom (APred2 Equal i1 i2) ;
  PropPreds (PNegAtom (APred2Distr Different d (BaseInd i1 i2))) = PNegAtom (APred2 Different i1 i2) ;
  -- PropPreds (PAtom (APred2Distr Equal (ConsInd i li))) = como lograr todas las combinaciones de individuos

  -- otherwise  
  PropPreds (PAtom a) = (PAtom a) ;
  PropPreds (PNegAtom a) = (PNegAtom a) ;


-- transfer functions for list of props
fun PropList : Prop -> Prop ;

def 
  PropList (PConjs c (BaseProp p1 p2 )) = PConj c p1 p2 ;
  PropList (PConjs c (ConsProp p lp)) = PConj c p (PropList (PConjs c lp)) ;
}
