abstract Logic = Categories, LexiconSAT ** {

flags startcat = Prop ; coding = utf8 ;


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
  PEquiv : Prop -> Prop -> Prop ;           -- p if and only if q

  -- Symbolic constructor < Qx : R.x : T.x >
  PQuant  : Quant -> Var -> Prop -> Prop -> Prop ;

  -- Variables are strings
  VString : String -> Var ;                 -- "x"
  -- Variables as individual terms
  IVar   : Var -> Ind ;                     -- "x"

  -- Basic binary predicates
  Equal : Pred2 Ser ;                          -- x is equal to y
  Different : Pred2 Ser ;                      -- x is different to y

  -- Predicate application
  APred1 : (c : Class) -> Pred1 P c -> Ind -> Atom ;  -- x is even
  ANPred1 : (c : Class) -> Pred1 N c -> Ind -> Prop ;
  -- MPred1 : Pred1 m -> Ind -> Prop ; -- mixed Pred1 polarity?

  APred2 : (c : Class) -> Pred2 c -> Ind -> Ind -> Atom ;    -- x is above y

  -- Negate pred1 polarity
  NegatedPred1 : (c : Class) -> Pred1 P c -> Pred1 N c ;

  -- Function application
  IFun1  : Fun1 -> Ind -> Ind ;             -- the square of x
  IFun2  : Fun2 -> Ind -> Ind -> Ind ;      -- the sum of x and y

  -- Conjunctions
  CAnd, COr : Conj ;                        -- and, or

-- Linguistic related constructions
data
  PNegAtom  : Atom -> Prop ;  -- x is not even
  UnivIS  : Var -> (ck : ClassK) -> Kind ck -> (c : Class) -> (pol : Pol) -> Pred1 pol c -> Prop ;              -- (in situ) every number
  ExistIS : Var -> (ck : ClassK) -> Kind ck -> (c : Class) -> (pol : Pol) -> Pred1 pol c -> Prop ;              -- (in situ) some number
  NoneIS : Var -> (ck : ClassK) -> Kind ck -> (c : Class) -> (pol : Pol) -> Pred1 pol c -> Prop ;              -- (in situ) no number
  ModKind : Kind Fig -> (c : Class) -> (pol : Pol) -> Pred1 pol c -> (ck : ClassK) -> ToKind c ck -> Kind ck ;  -- even number (domain of quantification)

-- Dependent types to allow distributive binary predicates
fun
  distr_equal : Distr Ser Equal ;
  distr_diff : Distr Ser Different ;

-- Dependent types to define possible modifications of Kind.
fun
  toSerK : ToKind Ser SerK ;
  toEstarK : ToKind Estar EstarK ;

data
  {-
  ConjPred1 : Conj -> (c : Class) -> [Pred1 P c] -> Pred1 P c ;
  ConjNegPred1 : (c : Class) -> [Pred1 P c] -> Pred1 N c ;  -- solo se usa para conjunción negativa con ni
  -}
  -- Polimorfic conjunction
  ConjPred1Ser : Conj -> [Pred1 P Ser] -> Pred1 P Ser ;
  ConjPred1Estar : Conj -> [Pred1 P Estar] -> Pred1 P Estar ;
  -- ConjNeg solo se usa para conjunción negativa con ni
  ConjNegPred1Ser : [Pred1 P Ser] -> Pred1 N Ser ;
  ConjNegPred1Estar : [Pred1 P Estar] -> Pred1 N Estar ;
  -- MixedPred1 : Pred1 p -> Pred1 n -> Pred1 m ;

  ConjInd : Conj -> [Ind] -> Ind ;
  PConjs : Conj -> [Prop] -> Prop ;

  -- Partial application
  PartPred : (c : Class) -> Pred2 c -> Ind -> Pred1 P c ;

  -- Reflexividad en Pred2
  APredRefl : (c : Class) -> Pred2 c -> Ind -> Atom ;

  -- Distributividad de Pred2
  APred2Distr : (c : Class) -> (p : Pred2 c) -> Distr c p -> [Ind] -> Atom ;

  -- A está arriba de todos los cuadrados
  APred2Univ : Var -> Pred2 Estar -> Ind -> (ck : ClassK) -> Kind ck -> Atom ;
  APred2Exist : Var -> Pred2 Estar -> Ind -> (ck : ClassK) -> Kind ck -> Atom ;
  APred2None : Var -> Pred2 Estar -> Ind -> (ck : ClassK) -> Kind ck -> Prop ;

  -- Cuantificación anidada
  UnivUnivIS : (v1, v2 : Var) -> Pred2 Estar -> (ck1, ck2: ClassK) -> Kind ck1 -> Kind ck2 -> Prop ;
  UnivExistIS : (v1, v2 : Var) -> Pred2 Estar -> (ck1, ck2: ClassK) -> Kind ck1 -> Kind ck2 -> Prop ;
  ExistExistIS : (v1, v2 : Var) -> Pred2 Estar -> (ck1, ck2: ClassK) -> Kind ck1 -> Kind ck2 -> Prop ;
  ExistUnivIS : (v1, v2 : Var) -> Pred2 Estar -> (ck1, ck2: ClassK) -> Kind ck1 -> Kind ck2 -> Prop ;
  -- Cuantificación simbólica con lista de variables
  -- PQuants : Quant -> [Var] -> Prop -> Prop -> Prop ;


-- Transfer functions --

-- Main transfer function
fun Transfer : Prop -> Prop ;
def
  Transfer (UnivIS v ck k cl pol p) = QuantIStoP (UnivIS v ck k cl pol p) ;
  Transfer (ExistIS v ck k cl pol p) = QuantIStoP (ExistIS v ck k cl pol p) ;
  Transfer (NoneIS v ck k cl pol p) = QuantIStoP (NoneIS v ck k cl pol p) ;
  Transfer (PAtom a) = TransAtom (PAtom a) ;
  Transfer (PNegAtom a) = TransAtom (PNegAtom a) ;
  Transfer (ANPred1 cl p i) = TransNegPred1 (ANPred1 cl p i) ;
  Transfer (APred2None v p i ck k) = TransAPred2None (APred2None v p i ck k) ;
  Transfer (PConjs c lp) = TransPConjs (PConjs c lp) ;
  -- Nested Quant
  Transfer (UnivUnivIS v1 v2 p ck1 ck2 k1 k2) = TransQuantAnid (UnivUnivIS v1 v2 p ck1 ck2 k1 k2) ;
  Transfer (UnivExistIS v1 v2 p ck1 ck2 k1 k2) = TransQuantAnid (UnivExistIS v1 v2 p ck1 ck2 k1 k2) ;
  Transfer (ExistExistIS v1 v2 p ck1 ck2 k1 k2) = TransQuantAnid (ExistExistIS v1 v2 p ck1 ck2 k1 k2) ;
  Transfer (ExistUnivIS v1 v2 p ck1 ck2 k1 k2) = TransQuantAnid (ExistUnivIS v1 v2 p ck1 ck2 k1 k2) ;
  -- Simple recursive calls
  Transfer (PConj c p q) = PConj c (Transfer p) (Transfer q) ;
  Transfer (PImpl p q) = PImpl (Transfer p) (Transfer q) ;
  Transfer (PEquiv p q) = PEquiv (Transfer p) (Transfer q) ;
  Transfer (PNeg p) = PNeg (Transfer p) ;

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
fun tr1 : Polarity -> (cl : Class) -> Pred1 P cl -> Ind -> Prop ;
def
  tr1 pol cl p = tr pol (APred1 cl p);

-- Atomic Pred2 transfered
fun tr2 : Polarity -> (cl : Class) -> Pred2 cl -> Ind -> Ind -> Prop ;
def
  tr2 pol cl p i1 = tr pol (APred2 cl p i1) ;


-- Distribuye la negación, sin modificar el operador de conjunción.
-- Solo se usa en distribución, ver si se puede quitar, o usar en otros lados
fun NegConj : Prop -> Prop ;
def
  NegConj (PAtom a) = PNegAtom a ;
  NegConj (PNegAtom a) = PAtom a ;
  NegConj (PConj c p1 p2) = PConj c (NegConj p1) (NegConj p2) ;
  NegConj p = PNeg p ;

-- Transfer Pred with list of inds. (high-order to accept Pred1 & Pred2)
fun PredListInd : (Ind -> Prop) -> Conj -> [Ind] -> Prop ;
def
  PredListInd f c (BaseInd i1 i2) = PConj c (f i1) (f i2) ;
  PredListInd f c (ConsInd i li) = PConj c (f i) (PredListInd f c li) ;

-- Transfer Pred1 with list of inds. (ej: A y B son rojos)
fun Pred1ListInd : Polarity -> (cl : Class) -> Pred1 P cl -> Conj -> [Ind] -> Prop ;
def 
  Pred1ListInd pol cl p c li = PredListInd (tr1 pol cl p) c li ;


-- Transfer Pred2 with list of inds (Izquierda). (ej: A y B están arriba de C)
fun Pred2ListIndIzq : Polarity -> (cl : Class) -> Pred2 cl -> Conj -> [Ind] -> Ind -> Prop ;
def
  Pred2ListIndIzq pol cl p c (BaseInd i1 i2) i = PConj c (tr2 pol cl p i1 i) (tr2 pol cl p i2 i) ;
  Pred2ListIndIzq pol cl p c li i = PredListInd (\ind -> tr2 pol cl p ind i) c li ;


-- Transfer Pred2 with list of inds (Derecha). (ej: A está arriba de B y C)
fun Pred2ListIndDer : Polarity -> (cl : Class) -> Pred2 cl -> Conj -> Ind -> [Ind] -> Prop ;
def
  Pred2ListIndDer Pos cl p c i li = PredListInd (tr2 Pos cl p i) c li ;
  Pred2ListIndDer Neg cl p c i li = PNeg (Pred2ListIndDer Pos cl p c i li) ;


-- Transfer Partial Aplication of Pred2 with list of inds. 
fun PartPred2ListInd : Polarity -> (cl : Class) -> Pred2 cl -> Conj -> Ind -> [Ind] -> Prop ;
def
  PartPred2ListInd Pos cl p c i li = PredListInd (\ind -> tr1 Pos cl (PartPred cl p ind) i) c li ;
  PartPred2ListInd Neg cl p c i li = PNeg (PartPred2ListInd Pos cl p c i li) ;


-- Transfer List of Pred1 (ej: A es rojo y verde)
fun TransListPred1 : Polarity -> Conj -> (cl : Class) -> [Pred1 P cl] -> Ind -> Prop ;
def
  TransListPred1 Pos c _ (BasePred1 P cl p1 p2) i = PConj c (tr1 Pos cl p1 i) (tr1 Pos cl p2 i) ;
  TransListPred1 Pos c _ (ConsPred1 P cl ph lp) i = PConj c (tr1 Pos cl ph i) (TransListPred1 Pos c cl lp i) ;
  TransListPred1 Neg c cl lp i = PNeg (TransListPred1 Pos c cl lp i) ;


-- Funciones para distribuir predicados binarios a lista de individuos
fun distrBinPred : (cl : Class) -> Pred2 cl -> Ind -> [Ind] -> Prop ;
fun distrBin : Polarity -> (cl : Class) -> Pred2 cl -> [Ind] -> Prop ;

def
  distrBinPred cl p x (BaseInd i1 i2) = PConj CAnd (PAtom (APred2 cl p x i1)) (PAtom (APred2 cl p x i2));
  distrBinPred cl p x (ConsInd i1 li) = PConj CAnd (PAtom (APred2 cl p x i1)) (distrBinPred cl p x li) ;

  distrBin Pos cl p (BaseInd i1 i2) = PAtom (APred2 cl p i1 i2);
  distrBin Pos cl p (ConsInd i1 li) = PConj CAnd (distrBinPred cl p i1 li) (distrBin Pos cl p li) ;
  distrBin Neg cl p li = NegConj (distrBin Pos cl p li) ;
-- End of auxiliar functions --


fun trNeg1 : (cl : Class) -> Pred1 N cl -> Ind -> Prop ;
def
  trNeg1 cl (NegatedPred1 cl p) i = tr1 Neg cl p i ;
  trNeg1 Ser (ConjNegPred1Ser (BasePred1 P Ser p1 p2)) i = PConj CAnd (tr1 Neg Ser p1 i) (tr1 Neg Ser p2 i) ;
  trNeg1 Ser (ConjNegPred1Ser (ConsPred1 P Ser p lp)) i = PConj CAnd (tr1 Neg Ser p i) (trNeg1 Ser (ConjNegPred1Ser lp) i) ;
  trNeg1 Estar (ConjNegPred1Estar (BasePred1 P Estar p1 p2)) i = PConj CAnd (tr1 Neg Estar p1 i) (tr1 Neg Estar p2 i) ;
  trNeg1 Estar (ConjNegPred1Estar (ConsPred1 P Estar p lp)) i = PConj CAnd (tr1 Neg Estar p i) (trNeg1 Estar (ConjNegPred1Estar lp) i) ;

fun TransNegPred1 : Prop -> Prop ;
def
  TransNegPred1 (ANPred1 cl p i) = trNeg1 cl p i ;

fun TransAPred2None : Prop -> Prop ;
def
  TransAPred2None (APred2None v p i ck k) = PNeg (Transfer (PAtom (APred2Exist v p i ck k))) ;

-- tr1 or trNeg1 depending polarity
fun tr1PoN : (pol : Pol) -> (cl : Class) -> Pred1 pol cl -> Ind -> Prop ;
def
  tr1PoN P cl p = tr1 Pos cl p ;
  tr1PoN N cl p = trNeg1 cl p ;

-- Range given Kind
fun Range : Var -> (ck : ClassK) -> Kind ck -> Prop ;
def
   Range _ _ Figura = True ;
   Range v ck k = (KindToProp ck k v) ;

-- Transfer functions for in-situ quantification. Takes Ind to apply term.
fun qIStoP : Quant -> Var -> (ck : ClassK) -> Kind ck -> (c : Class) -> (pol : Pol) -> Pred1 pol c -> Ind -> Prop ;
def
  qIStoP q v ck k cl pol p (ConjInd c li) = PredListInd (\i -> (PQuant q v (Range v ck k) ((tr1PoN pol cl p) i))) c li ;
  qIStoP q v ck k cl pol p i = PQuant q v (Range v ck k) ((tr1PoN pol cl p) i) ;

-- Transfer functions for in-situ quantification
fun QuantIStoP : Prop -> Prop ;
fun KindToProp : (ck : ClassK) -> Kind ck -> Var -> Prop ;

def
  QuantIStoP (UnivIS v ck k cl pol p) = qIStoP ForAll v ck k cl pol p (IVar v) ;
  QuantIStoP (ExistIS v ck k cl pol p) = qIStoP Exists v ck k cl pol p (IVar v) ;
  QuantIStoP (NoneIS v ck k cl pol p) = PNeg (qIStoP Exists v ck k cl pol p (IVar v)) ;
  KindToProp ck (ModKind Figura pol cl p _ _) v = (tr1PoN cl pol p) (IVar v) ;
  -- KindToProp ck (ModKind k pol cl p) v = PConj CAnd ((tr1PoN cl pol p) (IVar v)) (KindToProp Ser k v) ;

fun TransQuantAnid : Prop -> Prop ;
def
  TransQuantAnid (UnivUnivIS v1 v2 p ck1 ck2 k1 k2) = PQuant ForAll v1 (Range v1 ck1 k1)
      (PQuant ForAll v2 (Range v2 ck2 k2) (Transfer (PAtom (APred2 Estar p (IVar v1) (IVar v2))))) ;

  TransQuantAnid (UnivExistIS v1 v2 p ck1 ck2 k1 k2) = PQuant ForAll v1 (Range v1 ck1 k1)
      (PQuant Exists v2 (Range v2 ck2 k2) (Transfer (PAtom (APred2 Estar p (IVar v1) (IVar v2))))) ;

      TransQuantAnid (ExistExistIS v1 v2 p ck1 ck2 k1 k2) = PQuant Exists v1 (Range v1 ck1 k1)
      (PQuant Exists v2 (Range v2 ck2 k2) (Transfer (PAtom (APred2 Estar p (IVar v1) (IVar v2))))) ;

      TransQuantAnid (ExistUnivIS v1 v2 p ck1 ck2 k1 k2) = PQuant Exists v1 (Range v1 ck1 k1)
      (PQuant ForAll v2 (Range v2 ck2 k2) (Transfer (PAtom (APred2 Estar p (IVar v1) (IVar v2))))) ;

-- Transfer function for atomic props. (Takes care of lists of inds/preds).
fun TransAtom : Prop -> Prop ;
def
  -- Lista de individuos en Pred1
  TransAtom (PAtom (APred1 cl p (ConjInd c li))) = Pred1ListInd Pos cl p c li ;
  TransAtom (PNegAtom (APred1 cl p (ConjInd c li))) = Pred1ListInd Neg cl p c li ;

  -- Lista de individuos en Pred2 --
  -- Lista de individuos a izquierda
  TransAtom (PAtom (APred2 cl p (ConjInd c li) i)) = Pred2ListIndIzq Pos cl p c li i ;
  TransAtom (PNegAtom (APred2 cl p (ConjInd c li) i)) = Pred2ListIndIzq Neg cl p c li i ;

  -- Lista de individuos a derecha
  TransAtom (PAtom (APred2 cl p i (ConjInd c li))) = Pred2ListIndDer Pos cl p c i li ;
  TransAtom (PNegAtom (APred2 cl p i (ConjInd c li))) = Pred2ListIndDer Neg cl p c i li ;

  -- Lista de individuos en Aplicación parcial de Pred2
  TransAtom (PAtom (APred1 _ (PartPred cl p2 (ConjInd c li)) i)) = PartPred2ListInd Pos cl p2 c i li ;
  TransAtom (PNegAtom (APred1 _ (PartPred cl p2 (ConjInd c li)) i)) = PartPred2ListInd Neg cl p2 c i li ;

  -- Conj de Pred1
  TransAtom (PAtom (APred1 Ser (ConjPred1Ser c lp) i)) = TransListPred1 Pos c Ser lp i ;
  TransAtom (PNegAtom (APred1 Ser (ConjPred1Ser c lp) i)) = TransListPred1 Neg c Ser lp i ;
  TransAtom (PAtom (APred1 Estar (ConjPred1Estar c lp) i)) = TransListPred1 Pos c Estar lp i ;
  TransAtom (PNegAtom (APred1 Estar (ConjPred1Estar c lp) i)) = TransListPred1 Neg c Estar lp i ;

  -- Distr Pred2
  TransAtom (PAtom (APred2Distr cl p d li)) = distrBin Pos cl p li;
  TransAtom (PNegAtom (APred2Distr cl p d li)) = distrBin Neg cl p li;

  -- Application of Pred2 with Quant
  TransAtom (PAtom (APred2Univ v p i ck k)) = qIStoP ForAll v ck k Estar P (PartPred Estar p (IVar v)) i ;
  TransAtom (PNegAtom (APred2Univ v p i ck k)) = NegConj (qIStoP ForAll v ck k Estar P (PartPred Estar p (IVar v)) i) ;

  TransAtom (PAtom (APred2Exist v p i ck k)) = qIStoP Exists v ck k Estar P (PartPred Estar p (IVar v)) i ;
  TransAtom (PNegAtom (APred2Exist v p i ck k)) = NegConj (qIStoP Exists v ck k Estar P (PartPred Estar p (IVar v)) i) ;

  -- otherwise
  TransAtom pa = pa ;


-- Transfer functions for list of props
fun TransPConjs : Prop -> Prop ;

def
  TransPConjs (PConjs c (BaseProp p1 p2)) = PConj c (Transfer p1) (Transfer p2) ;
  TransPConjs (PConjs c (ConsProp p lp)) = PConj c (Transfer p) (TransPConjs (PConjs c lp)) ;

}
