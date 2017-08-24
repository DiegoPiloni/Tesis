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

  -- < Qx : R.x : T.x >
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


-- Transfer functions --

-- Main transfer function
fun Transfer : Prop -> Prop ;
def
  Transfer (UnivIS v k p) = QuantIStoP (UnivIS v k p) ;
  Transfer (ExistIS v k p) = QuantIStoP (ExistIS v k p) ;
  Transfer (PAtom a) = TransAtom (PAtom a) ;
  Transfer (PNegAtom a) = TransAtom (PNegAtom a) ;
  Transfer (PConjs c lp) = TransPConjs (PConjs c lp) ;


-- Transfer functions for quantification
fun QuantIStoP : Prop -> Prop ;
fun KindToProp : Kind -> Var -> Prop ;

def
  QuantIStoP (UnivIS v Figura p) = PQuant ForAll v True (Transfer (PAtom (APred1 p (IVar v)))) ;
  QuantIStoP (UnivIS v k p) = PQuant ForAll v (Transfer (KindToProp k v)) (Transfer (PAtom (APred1 p (IVar v)))) ;

  QuantIStoP (ExistIS v Figura p) = PQuant Exists v True (Transfer (PAtom (APred1 p (IVar v)))) ;
  QuantIStoP (ExistIS v k p) = PQuant Exists v (Transfer (KindToProp k v)) (Transfer (PAtom (APred1 p (IVar v)))) ;

  KindToProp (ModKind Figura pred) v = (PAtom (APred1 pred (IVar v))) ;
  KindToProp (ModKind k pred) v = PConj CAnd (PAtom (APred1 pred (IVar v))) (KindToProp k v) ;


-- funciones para distribuir predicados binarios a lista de individuos
fun distrBinPred : (pred : Pred2) -> Ind -> [Ind] -> Prop ;
fun distrBin : (pred : Pred2) -> [Ind] -> Prop ;

def
  distrBinPred p x (BaseInd i1 i2) = PConj CAnd (PAtom (APred2 p x i1)) (PAtom (APred2 p x i2));
  distrBinPred p x (ConsInd i1 li) = PConj CAnd (PAtom (APred2 p x i1)) (distrBinPred p x li) ;  

  distrBin p (BaseInd i1 i2) = PAtom (APred2 p i1 i2);
  distrBin p (ConsInd i1 li) = PConj CAnd (distrBinPred p i1 li) (distrBin p li) ;


-- Distribuye la negación, sin modificar el operador de conjunción.
fun NegConj : Prop -> Prop ;
def
  NegConj (PAtom a) = PNegAtom a;
  NegConj (PNegAtom a) = PAtom a;  
  NegConj (PConj c p1 p2) = PConj c (NegConj p1) (NegConj p2) ;


-- Category to diff polarity
cat Polarity ;
data Pos, Neg : Polarity ;


-- Atomic Pred1 transfered
fun tr1 : Polarity -> Pred1 -> Ind -> Prop ;
def
  tr1 Pos p i = TransAtom (PAtom (APred1 p i)) ;
  tr1 Neg p i = TransAtom (PNegAtom (APred1 p i)) ;


-- Atomic Pred2 transfered
fun tr2 : Polarity -> Pred2 -> Ind -> Ind -> Prop ;
def
  tr2 Pos p i1 i2 = TransAtom (PAtom (APred2 p i1 i2)) ;
  tr2 Neg p i1 i2 = TransAtom (PNegAtom (APred2 p i1 i2)) ;


-- Transfer Pred1 with list of inds. (ej: A y B son rojos)
fun Pred1ListInd : Polarity -> Pred1 -> Conj -> [Ind] -> Prop ;
def
  Pred1ListInd Pos p c (BaseInd i1 i2) = PConj c (tr1 Pos p i1) (tr1 Pos p i2) ;
  Pred1ListInd Pos p c (ConsInd i1 li) = PConj c (tr1 Pos p i1) (Pred1ListInd Pos p c li) ;
  Pred1ListInd Neg p c (BaseInd i1 i2) = PConj c (tr1 Neg p i1) (tr1 Neg p i2) ;
  Pred1ListInd Neg p c (ConsInd i1 li) = PConj c (tr1 Neg p i1) (Pred1ListInd Neg p c li) ;


-- Transfer Pred2 with list of inds (Izquierda). (ej: A y B están arriba de C)
fun Pred2ListIndIzq : Polarity -> Pred2 -> Conj -> [Ind] -> Ind -> Prop ;
def
  Pred2ListIndIzq Pos p c (BaseInd i1 i2) i = PConj c (tr2 Pos p i1 i) (tr2 Pos p i2 i) ;
  Pred2ListIndIzq Pos p c (ConsInd ih li) i = PConj c (tr2 Pos p ih i) (Pred2ListIndIzq Pos p c li i) ;
  Pred2ListIndIzq Neg p c (BaseInd i1 i2) i = PConj c (tr2 Neg p i1 i) (tr2 Neg p i2 i) ;
  Pred2ListIndIzq Neg p c (ConsInd ih li) i = PConj c (tr2 Neg p ih i) (Pred2ListIndIzq Neg p c li i) ;


-- Transfer Pred2 with list of inds (Derecha). (ej: A está arriba de B y C)
fun Pred2ListIndDer : Polarity -> Pred2 -> Conj -> Ind -> [Ind] -> Prop ;
def
  Pred2ListIndDer Pos p c i (BaseInd i1 i2) = PConj c (tr2 Pos p i i1) (tr2 Pos p i i2) ;
  Pred2ListIndDer Pos p c i (ConsInd ih li) = PConj c (tr2 Pos p i ih) (Pred2ListIndDer Pos p c i li) ;
  Pred2ListIndDer Neg p c i (BaseInd i1 i2) = PNeg (PConj c (tr2 Pos p i i1) (tr2 Pos p i i2)) ;
  Pred2ListIndDer Neg p c i (ConsInd ih li) = PNeg (PConj c (tr2 Pos p i ih) (Pred2ListIndDer Pos p c i li)) ;


-- Transfer Partial Aplication of Pred2 with list of inds. 
fun PartPred2ListInd : Polarity -> Pred2 -> Conj -> Ind -> [Ind] -> Prop ;
def
  PartPred2ListInd Pos p c i (BaseInd i1 i2) = PConj c (tr1 Pos (PartPred p i1) i) (tr1 Pos (PartPred p i2) i) ;
  PartPred2ListInd Pos p c i (ConsInd ih li) = PConj c (tr1 Pos (PartPred p ih) i) (PartPred2ListInd Pos p c i li) ;
  PartPred2ListInd Neg p c i (BaseInd i1 i2) = PNeg (PConj c (tr1 Pos (PartPred p i1) i) (tr1 Pos (PartPred p i2) i)) ;
  PartPred2ListInd Neg p c i (ConsInd ih li) = PNeg (PConj c (tr1 Pos (PartPred p ih) i) (PartPred2ListInd Pos p c i li)) ;


-- Transfer List of Pred1 (ej: A es rojo y verde)
fun TransListPred1 : Polarity -> Conj -> [Pred1] -> Ind -> Prop ;
def
  TransListPred1 Pos c (BasePred1 p1 p2) i = PConj c (tr1 Pos p1 i) (tr1 Pos p2 i) ;
  TransListPred1 Pos c (ConsPred1 ph lp) i = PConj c (tr1 Pos ph i) (TransListPred1 Pos c lp i) ; 
  TransListPred1 Neg c (BasePred1 p1 p2) i = PNeg (PConj c (tr1 Pos p1 i) (tr1 Pos p2 i)) ;
  TransListPred1 Neg c (ConsPred1 ph lp) i = PNeg (PConj c (tr1 Pos ph i) (TransListPred1 Pos c lp i)) ;  


-- Transfer function for atomic props. (Takes care of lists of inds/preds).
fun TransAtom : Prop -> Prop ;
def
  -- Conj de individuos en Pred1
  TransAtom (PAtom (APred1 p (ConjInd c li))) = Pred1ListInd Pos p c li ;
  TransAtom (PNegAtom (APred1 p (ConjInd c li))) = Pred1ListInd Neg p c li ;

  -- Conj de individuos en Pred2 --
  -- Lista de individuos a izquierda
  TransAtom (PAtom (APred2 p (ConjInd c li) i)) = Pred2ListIndIzq Pos p c li i ;
  TransAtom (PNegAtom (APred2 p (ConjInd c li) i)) = Pred2ListIndIzq Neg p c li i ;

  -- Lista de individuos a derecha
  TransAtom (PAtom (APred2 p i (ConjInd c li))) = Pred2ListIndDer Pos p c i li ;
  TransAtom (PNegAtom (APred2 p i (ConjInd c li))) = Pred2ListIndDer Neg p c i li ;

  -- Conj de individuos en Aplicación parcial de Pred2
  TransAtom (PAtom (APred1 (PartPred p2 (ConjInd c li)) i)) = PartPred2ListInd Pos p2 c i li ;  
  TransAtom (PNegAtom (APred1 (PartPred p2 (ConjInd c li)) i)) = PartPred2ListInd Neg p2 c i li ;  

  -- Conj de Pred1
  TransAtom (PAtom (APred1 (ConjPred1 c lp) i)) = TransListPred1 Pos c lp i ;
  TransAtom (PNegAtom (APred1 (ConjPred1 c lp) i)) = TransListPred1 Neg c lp i ;

  -- Distr Pred2
  TransAtom (PAtom (APred2Distr p d li)) = distrBin p li;
  TransAtom (PNegAtom (APred2Distr p d li)) = NegConj (distrBin p li);

  -- otherwise
  TransAtom pa = pa ;


-- Transfer functions for list of props
fun TransPConjs : Prop -> Prop ;

def 
  TransPConjs (PConjs c (BaseProp p1 p2 )) = PConj c p1 p2 ;
  TransPConjs (PConjs c (ConsProp p lp)) = PConj c p (TransPConjs (PConjs c lp)) ;
}
