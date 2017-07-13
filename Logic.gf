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

  APred1 : Pred1 -> Ind -> Atom ;           -- x is even
  APred2 : Pred2 -> Ind -> Ind -> Atom ;    -- x is above y
  AEqual : Ind -> Ind -> AtomEqual ;        -- x is equal to y

  IFun1  : Fun1 -> Ind -> Ind ;             -- the square of x
  IFun2  : Fun2 -> Ind -> Ind -> Ind ;      -- the sum of x and y

  VString : String -> Var ;                 -- x

  CAnd, COr : Conj ;                        -- and, or

  -- supplementary. Kind introduction

data
  PNegAtom  : Atom -> Prop ;                           -- x is not even
  PNegEqual : Ind -> Ind -> Prop ;                     -- x is different to y
  -- AKind  : Kind  -> Ind -> Atom ;                   -- Problema: A es una figura (no es una sentencia valida en SAT)
  -- data define las siguientes funciones como constructores de la categoria Prop.
  -- Es necesario definir como constructor para poder usarlo dentro de un def.
data
  UnivIS  : Var -> Kind -> Pred1 -> Prop ;             -- (in situ) every number
  ExistIS : Var -> Kind -> Pred1 -> Prop ;             -- (in situ) some number
  ModKind : Kind -> Pred1 -> Kind ;                    -- even number


-- transfer functions for quantification
{-
fun QuantIStoP : Prop -> Prop ;
fun KindToProp : Kind -> Var -> Prop ;

def
  QuantIStoP (UnivIS v Figura p) = PQuant ForAll v True (PAtom (APred1 p (IVar v))) ;  
  QuantIStoP (UnivIS v k p) = PQuant ForAll v (KindToProp k v) (PAtom (APred1 p (IVar v))) ;

  QuantIStoP (ExistIS v Figura p) = PQuant Exists v True (PAtom (APred1 p (IVar v))) ;  
  QuantIStoP (ExistIS v k p) = PQuant Exists v (KindToProp k v) (PAtom (APred1 p (IVar v))) ;

  KindToProp (ModKind Figura pred) v = (PAtom (APred1 pred (IVar v))) ;
  KindToProp (ModKind k pred) v = PConj CAnd (PAtom (APred1 pred (IVar v))) (KindToProp k v) ;
-}

-- suplementary. polimorfic conjunctions

data
  ConjPred1 : Conj -> [Pred1] -> Pred1 ;
  ConjInd : Conj -> [Ind] -> Ind ;
  -- PConjs : Conj -> [Prop] -> Prop ;
  -- PQuants : Quant -> [Var] -> Prop -> Prop -> Prop ;

-- transfer functions for list of preds and list of inds

{-
fun PropPreds : Prop -> Prop ;

def 
  -- conj de individuos
  PropPreds (PAtom (APred1 p (ConjInd c (BaseInd i1 i2)))) = PConj c (PropPreds (PAtom (APred1 p i1))) (PropPreds (PAtom (APred1 p i2))) ;
  PropPreds (PAtom (APred1 p (ConjInd c (ConsInd i1 li)))) = PConj c (PropPreds (PAtom (APred1 p i1))) (PropPreds (PAtom (APred1 p (ConjInd c li) ))) ;
  PropPreds (PNegAtom (APred1 p (ConjInd c (BaseInd i1 i2)))) = PConj c (PropPreds (PNegAtom (APred1 p i1))) (PropPreds (PNegAtom (APred1 p i2))) ;
  PropPreds (PNegAtom (APred1 p (ConjInd c (ConsInd i1 li)))) = PConj c (PropPreds (PNegAtom (APred1 p i1))) (PropPreds (PNegAtom (APred1 p (ConjInd c li)))) ;

  -- conj de predicados unarios
  PropPreds (PAtom (APred1 (ConjPred1 c (BasePred1 p1 p2)) i)) = PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 p2 i))) ;
  PropPreds (PAtom (APred1 (ConjPred1 c (ConsPred1 p1 lp)) i)) = PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 (ConjPred1 c lp) i))) ; 
  PropPreds (PNegAtom (APred1 (ConjPred1 c (BasePred1 p1 p2)) i)) = PNeg (PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 p2 i)))) ;
  PropPreds (PNegAtom (APred1 (ConjPred1 c (ConsPred1 p1 lp)) i)) = PNeg (PConj c (PropPreds (PAtom (APred1 p1 i))) (PropPreds (PAtom (APred1 (ConjPred1 c lp) i)))) ;  

  -- otherwise  
  PropPreds (PAtom a) = (PAtom a) ;
  PropPreds (PNegAtom a) = (PNegAtom a) ;
-}

}
