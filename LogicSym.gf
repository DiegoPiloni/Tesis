concrete LogicSym of Logic = CategoriesSym, LexiconSATSym ** open Prelude in {

flags coding = utf8 ;

lin
  PAtom = idS ;
  PNeg = negate ;
  PConj = bin_op ;
  PImpl = bin_op "⇒" ;
  PEquiv = bin_op "≡" ;
  PQuant = quant ;
  APred1 _ = appPred1 ;
  ANPred1 _ p x = negate (appPred1 p x) ;
  APred2 _ = appPred2 ;
  NegatedPred1 _ p = p ;

  IVar = idS ;
  Equal = { t = Equality ; s = "=" } ;
  Different = { t = Inequality ; s = "=" } ;

  IFun1 f x = glue f (parentesis x) ;
  IFun2 f x y = glue f (parentesis ( (glue x ",") ++ y) ) ;

  VString sr = sr.s ;

  CAnd = "∧" ;
  COr = "∨" ;

  True = "True" ;
  False = "False" ;
  ForAll = "∀" ;
  Exists = "∃" ;


lin
  PNegAtom = negate ;
  PartPred _ p i = { t = PA p.t ; symb = p.s ; ind = i } ;
  APredRefl _ p i = appPred2 p i i ;

  -- No se linealiza Kind a lenguaje simbólico
  -- No se linealiza QuantIS a lenguaje simbólico
  -- No se linealizan listas a lenguaje simbólico

oper
    idS : Str -> Str = \s -> s ;
    apply : (f, x : Str) -> Str = \f, x -> glue (glue f ".") x ;
    parentesis : Str -> Str = \s -> glue (glue "(" s) ")" ;
    negate : Str -> Str = \s -> glue "¬" s ;
    equal : (eq, x, y : Str) -> Str = \eq, x, y -> parentesis (x ++ eq ++ y) ;
    bin_op : (op, s1, s2 : Str) -> Str = \op, s1, s2 -> parentesis (s1 ++ op ++ s2) ;
    appPred1 : Pred1T -> Str -> Str = 
      \p, x -> case p.t of {
                 Original => apply p.symb x ;
                 (PA Position) => apply (apply p.symb x) p.ind;
                 (PA Equality) => equal p.symb x p.ind ;
                 (PA Inequality) => negate (equal p.symb x p.ind)
               } ;
    appPred2 : Pred2T -> (x, y : Str) -> Str = 
      \p, x, y -> case p.t of {
                    Equality => equal p.s x y ;
                    Inequality => negate (equal p.s x y) ;
                    Position => apply (apply p.s x) y
                  } ;
    quant : (q, v, r, t : Str) -> Str = 
      \q, v, r, t -> (glue (glue "〈" q) v) ++ ":" ++ r ++ ":" ++  t ++ "〉" ;

}
