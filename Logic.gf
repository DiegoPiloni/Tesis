abstract Logic = {

flags startcat = Prop ;

cat
  Prop ;  -- proposition, complex or atomic   e.g. "0 is even and 1 is odd"
  Atom ;  -- atomic proposition               e.g. "0 is even"
  AtomEqual ; -- atomic equality              e.g. "A is equal to B"
  Pred1 ; -- one-place predicate              e.g. "even"
  Pred2 ; -- two-place predicate              e.g. "A is less than B"
  Ind ;   -- individual term                  e.g. "the square of x"
  Var ;   -- variable of quantification       e.g. "x"
  Fun1 ;  -- one-place individual function    e.g. "square"
  Fun2 ;  -- two-place individual function    e.g. "sum"
  Conj ;  -- conjunction                      e.g. "and"

fun
  PAtom  : Atom  -> Prop ;                  -- x is even
  PNeg   : Prop  -> Prop ;                  -- it is not the case that x is even
  PConj  : Conj  -> Prop -> Prop -> Prop ;  -- x is even and y is odd
  PImpl  : Prop  -> Prop -> Prop ;          -- if x is even then y is odd

  -- <Qx : : T.x> (Rango true)
  PUniv1  : Var -> Prop -> Prop ;    -- for all x, x is even
  PExist1 : Var -> Prop -> Prop ;    -- there is an x such that x is even

  -- <Qx : R.x : T.x>
  PUniv2  : Var -> Prop -> Prop -> Prop ;    -- for all number x, x is even
  PExist2 : Var -> Prop -> Prop -> Prop ;    -- there is a number x such that x is even 

  IVar   : Var -> Ind ;                     -- x

  APred1 : Pred1 -> Ind -> Atom ;           -- x is even
  APred2 : Pred2 -> Ind -> Ind -> Atom ;    -- x is above y
  AEqual : Ind -> Ind -> AtomEqual ;        -- x is equal to y

  IFun1  : Fun1 -> Ind -> Ind ;             -- the square of x
  IFun2  : Fun2 -> Ind -> Ind -> Ind ;      -- the sum of x and y

  VString : String -> Var ;                 -- x

  CAnd, COr : Conj ;                        -- and, or

  -- supplementary

cat
  Kind ;    -- domain of quantification,   e.g. "even number"

fun
  PNegAtom  : Atom -> Prop ;                           -- x is not even
  PNegEqual : Ind -> Ind -> Prop ;                     -- x is different to y
  -- AKind  : Kind  -> Ind -> Atom ;                   -- Problema: A es una figura (no es una sentencia valida en SAT)
-- data define las siguientes funciones como constructores de la categoria Prop.
-- Es necesario definir como constructor para poder usarlo dentro de un def.
data
  UnivIS  : Var -> Kind -> Pred1 -> Prop ;             -- (in situ) every number
  ExistIS : Var -> Kind -> Pred1 -> Prop ;             -- (in situ) some number
  ModKind : Kind -> Pred1 -> Kind ;                    -- even number

fun UnivIStoP : Prop -> Prop ;
fun ExistIStoP : Prop -> Prop ;
fun KindToProp : Kind -> Var -> Prop ;

def UnivIStoP (UnivIS v Figura p) = PUniv1 v (PAtom (APred1 p (IVar v))) ;  
def UnivIStoP (UnivIS v k p) = PUniv2 v (KindToProp k v) (PAtom (APred1 p (IVar v))) ;

def ExistIStoP (ExistIS v Figura p) = PExist1 v (PAtom (APred1 p (IVar v))) ;  
def ExistIStoP (ExistIS v k p) = PExist2 v (KindToProp k v) (PAtom (APred1 p (IVar v))) ;

def KindToProp (ModKind Figura pred) v = (PAtom (APred1 pred (IVar v))) ;
def KindToProp (ModKind k pred) v = PConj CAnd (PAtom (APred1 pred (IVar v))) (KindToProp k v) ;  

-- test lexicon: SAT

data Figura : Kind ;
fun
  Rojo, Azul, Verde : Pred1 ;
  Chico, Mediano, Grande: Pred1 ;
  Triangulo, Cuadrado, Circulo : Pred1 ;
  Izquierda, Derecha, Arriba, Abajo : Pred2 ;

}
