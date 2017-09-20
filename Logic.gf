abstract Logic = Categories, LexiconSAT ** {

flags startcat = Prop ;

data
  -- Basic constructors for Prop and Quant Categories.
  True : Prop ;
  False : Prop ;
  ForAll : Quant ;
  Exists : Quant ;

data
  -- Main Prop constructors
  PAtom  : Atom  -> Prop ;                  -- x is even
  PNeg   : Prop  -> Prop ;                  -- it is not the case that x is even
  PConj  : Conj  -> Prop -> Prop -> Prop ;  -- x is even and y is odd
  PImpl  : Prop  -> Prop -> Prop ;          -- if x is even then y is odd

  -- < Qx : R.x : T.x >
  PQuant  : Quant -> Var -> Prop -> Prop -> Prop ;  -- for all number x, x is even

  -- Variables are strings
  VString : String -> Var ;                 -- "x"
  -- Variables as individual terms
  IVar   : Var -> Ind ;                     -- "x"

  -- Basic binary predicates
  Equal : Pred2 ;                          -- x is equal to y
  Different : Pred2 ;                      -- x is different to y

  -- Negate pred1 polarity
  NegatedPred1 : Pred1 P -> Pred1 N ;

  -- Predicate application
  APred1 : Pred1 P -> Ind -> Atom ;           -- x is even
  ANPred1 : Pred1 N -> Ind -> Prop ;
  --MPred1 : Pred1 m -> Ind -> Prop ;
  APred2 : Pred2 -> Ind -> Ind -> Atom ;    -- x is above y

  -- Function application
  IFun1  : Fun1 -> Ind -> Ind ;             -- the square of x
  IFun2  : Fun2 -> Ind -> Ind -> Ind ;      -- the sum of x and y

  -- Conjunctions
  CAnd, COr : Conj ;                        -- and, or
  sii_Conj : Conj ;                         -- if and only if

-- Linguistic related constructions
data
  PNegAtom  : Atom -> Prop ;                           -- x is not even
  UnivIS  : Var -> Kind -> (pol : Pol) -> Pred1 pol -> Prop ;             -- (in situ) every number
  ExistIS : Var -> Kind -> (pol : Pol) -> Pred1 pol -> Prop ;             -- (in situ) some number
  ModKind : Kind -> (pol : Pol) -> Pred1 pol -> Kind ;                    -- even number (domain of quantification)

-- Dependent types to allow distributive binary predicates
fun
  distr_equal : Distr Equal ;
  distr_diff : Distr Different ;


data
  -- Polimorfic conjunction
  ConjPred1 : Conj -> [Pred1 P] -> Pred1 P ;
  ConjNegPred1 : [Pred1 P] -> Pred1 N ;  -- solo se usa para conjunción negativa con ni
  -- MixedPred1 : Pred1 p -> Pred1 n -> Pred1 m ;

  ConjInd : Conj -> [Ind] -> Ind ;
  PConjs : Conj -> [Prop] -> Prop ;

  -- Partial application
  PartPred : Pred2 -> Ind -> Pred1 P ;

  -- Reflexividad en Pred2
  APredRefl : Pred2 -> Ind -> Atom ;

  -- Distributividad de Pred2
  APred2Distr : (p : Pred2) -> Distr p -> [Ind] -> Atom ;

  -- Cuantificación simbólica con lista de variables
  -- PQuants : Quant -> [Var] -> Prop -> Prop -> Prop ;


-- Transfer functions --

-- Main transfer function
fun Transfer : Prop -> Prop ;
def
  Transfer (UnivIS v k pol p) = QuantIStoP (UnivIS v k pol p) ;
  Transfer (ExistIS v k pol p) = QuantIStoP (ExistIS v k pol p) ;
  Transfer (PAtom a) = TransAtom (PAtom a) ;
  Transfer (PNegAtom a) = TransAtom (PNegAtom a) ;
  Transfer (ANPred1 p i) = TransNegPred1 (ANPred1 p i) ;
  Transfer (PConjs c lp) = TransPConjs (PConjs c lp) ;

-- Auxiliar categories and functions --
-- Category to diff polarity
cat Polarity ;
data Pos, Neg : Polarity ;

-- Atomic Pred transfered. (high-order to accept Pred1 & Pred2)
fun tr : Polarity -> (Ind -> Atom) -> Ind -> Prop ;
def
  tr Pos f i = TransAtom (PAtom (f i)) ;
  tr Neg f i = TransAtom (PNegAtom (f i)) ;


-- Atomic Pred1 transfered
fun tr1 : Polarity -> Pred1 P -> Ind -> Prop ;
def
  tr1 pol p = tr pol (APred1 p);

-- Atomic Pred2 transfered
fun tr2 : Polarity -> Pred2 -> Ind -> Ind -> Prop ;
def
  tr2 pol p i1 = tr pol (APred2 p i1) ;


-- Distribuye la negación, sin modificar el operador de conjunción.
-- Solo se usa en distribución, ver si se puede quitar, o usar en otros lados
fun NegConj : Prop -> Prop ;
def
  NegConj (PAtom a) = PNegAtom a;
  NegConj (PNegAtom a) = PAtom a;
  NegConj (PConj c p1 p2) = PConj c (NegConj p1) (NegConj p2) ;


-- Transfer Pred with list of inds. (high-order to accept Pred1 & Pred2)
fun PredListInd : (Ind -> Prop) -> Conj -> [Ind] -> Prop ;
def
  PredListInd f c (BaseInd i1 i2) = PConj c (f i1) (f i2) ;
  PredListInd f c (ConsInd i li) = PConj c (f i) (PredListInd f c li) ;

-- Transfer Pred1 with list of inds. (ej: A y B son rojos)
fun Pred1ListInd : Polarity -> Pred1 P -> Conj -> [Ind] -> Prop ;
def 
  Pred1ListInd pol p c li = PredListInd (tr1 pol p) c li ;


-- Transfer Pred2 with list of inds (Izquierda). (ej: A y B están arriba de C)
fun Pred2ListIndIzq : Polarity -> Pred2 -> Conj -> [Ind] -> Ind -> Prop ;
def
  Pred2ListIndIzq pol p c (BaseInd i1 i2) i = PConj c (tr2 pol p i1 i) (tr2 pol p i2 i) ;
  Pred2ListIndIzq pol p c li i = PredListInd (\ind -> tr2 pol p ind i) c li ;


-- Transfer Pred2 with list of inds (Derecha). (ej: A está arriba de B y C)
fun Pred2ListIndDer : Polarity -> Pred2 -> Conj -> Ind -> [Ind] -> Prop ;
def
  Pred2ListIndDer Pos p c i li = PredListInd (tr2 Pos p i) c li ;
  Pred2ListIndDer Neg p c i li = PNeg (Pred2ListIndDer Pos p c i li) ;


-- Transfer Partial Aplication of Pred2 with list of inds. 
fun PartPred2ListInd : Polarity -> Pred2 -> Conj -> Ind -> [Ind] -> Prop ;
def
  PartPred2ListInd Pos p c i li = PredListInd (\ind -> tr1 Pos (PartPred p ind) i) c li ;
  PartPred2ListInd Neg p c i li = PNeg (PartPred2ListInd Pos p c i li) ;


-- Transfer List of Pred1 (ej: A es rojo y verde)
fun TransListPred1 : Polarity -> Conj -> [Pred1 P] -> Ind -> Prop ;
def
  TransListPred1 Pos c (BasePred1 P p1 p2) i = PConj c (tr1 Pos p1 i) (tr1 Pos p2 i) ;
  TransListPred1 Pos c (ConsPred1 P ph lp) i = PConj c (tr1 Pos ph i) (TransListPred1 Pos c lp i) ;
  TransListPred1 Neg c lp i = PNeg (TransListPred1 Pos c lp i) ;


-- Funciones para distribuir predicados binarios a lista de individuos
fun distrBinPred : Pred2 -> Ind -> [Ind] -> Prop ;
fun distrBin : Polarity -> Pred2 -> [Ind] -> Prop ;

def
  distrBinPred p x (BaseInd i1 i2) = PConj CAnd (PAtom (APred2 p x i1)) (PAtom (APred2 p x i2));
  distrBinPred p x (ConsInd i1 li) = PConj CAnd (PAtom (APred2 p x i1)) (distrBinPred p x li) ;    

  distrBin Pos p (BaseInd i1 i2) = PAtom (APred2 p i1 i2);
  distrBin Pos p (ConsInd i1 li) = PConj CAnd (distrBinPred p i1 li) (distrBin Pos p li) ;
  distrBin Neg p li = NegConj (distrBin Pos p li) ;
-- End of auxiliar functions --


fun trNeg1 : Pred1 N -> Ind -> Prop ;
def
  trNeg1 (NegatedPred1 p) i = tr1 Neg p i ;
  trNeg1 (ConjNegPred1 (BasePred1 P p1 p2)) i = PConj CAnd (tr1 Neg p1 i) (tr1 Neg p2 i) ;
  trNeg1 (ConjNegPred1 (ConsPred1 P p lp)) i = PConj CAnd (tr1 Neg p i) (trNeg1 (ConjNegPred1 lp) i) ;

fun TransNegPred1 : Prop -> Prop ;
def
  TransNegPred1 (ANPred1 p i) = trNeg1 p i ;


-- tr1 or trNeg1 depending polarity
fun tr1PoN : (pol : Pol) -> Pred1 pol -> Ind -> Prop ;
def
  tr1PoN P p = tr1 Pos p ;
  tr1PoN N p = trNeg1 p ;

-- Transfer functions for in-situ quantification
fun QuantIStoP : Prop -> Prop ;
fun KindToProp : Kind -> Var -> Prop ;

def
  QuantIStoP (UnivIS v Figura pol p) = PQuant ForAll v True ((tr1PoN pol p) (IVar v)) ;
  QuantIStoP (UnivIS v k pol p) = PQuant ForAll v (KindToProp k v) ((tr1PoN pol p) (IVar v)) ;

  QuantIStoP (ExistIS v Figura pol p) = PQuant Exists v True ((tr1PoN pol p) (IVar v)) ;
  QuantIStoP (ExistIS v k pol p) = PQuant Exists v (KindToProp k v) ((tr1PoN pol p) (IVar v)) ;

  KindToProp (ModKind Figura pol p) v = (tr1PoN pol p) (IVar v) ;
  KindToProp (ModKind k pol p) v = PConj CAnd ((tr1PoN pol p) (IVar v)) (KindToProp k v) ;


-- Transfer function for atomic props. (Takes care of lists of inds/preds).
fun TransAtom : Prop -> Prop ;
def
  -- Lista de individuos en Pred1
  TransAtom (PAtom (APred1 p (ConjInd c li))) = Pred1ListInd Pos p c li ;
  TransAtom (PNegAtom (APred1 p (ConjInd c li))) = Pred1ListInd Neg p c li ;

  -- Lista de individuos en Pred2 --
  -- Lista de individuos a izquierda
  TransAtom (PAtom (APred2 p (ConjInd c li) i)) = Pred2ListIndIzq Pos p c li i ;
  TransAtom (PNegAtom (APred2 p (ConjInd c li) i)) = Pred2ListIndIzq Neg p c li i ;

  -- Lista de individuos a derecha
  TransAtom (PAtom (APred2 p i (ConjInd c li))) = Pred2ListIndDer Pos p c i li ;
  TransAtom (PNegAtom (APred2 p i (ConjInd c li))) = Pred2ListIndDer Neg p c i li ;

  -- Lista de individuos en Aplicación parcial de Pred2
  TransAtom (PAtom (APred1 (PartPred p2 (ConjInd c li)) i)) = PartPred2ListInd Pos p2 c i li ;  
  TransAtom (PNegAtom (APred1 (PartPred p2 (ConjInd c li)) i)) = PartPred2ListInd Neg p2 c i li ;  

  -- Conj de Pred1
  TransAtom (PAtom (APred1 (ConjPred1 c lp) i)) = TransListPred1 Pos c lp i ;
  TransAtom (PNegAtom (APred1 (ConjPred1 c lp) i)) = TransListPred1 Neg c lp i ;

  -- Distr Pred2
  TransAtom (PAtom (APred2Distr p d li)) = distrBin Pos p li;
  TransAtom (PNegAtom (APred2Distr p d li)) = distrBin Neg p li;

  -- otherwise
  TransAtom pa = pa ;


-- Transfer functions for list of props
fun TransPConjs : Prop -> Prop ;

def 
  TransPConjs (PConjs c (BaseProp p1 p2 )) = PConj c (Transfer p1) (Transfer p2) ;
  TransPConjs (PConjs c (ConsProp p lp)) = PConj c (Transfer p) (TransPConjs (PConjs c lp)) ;

}
