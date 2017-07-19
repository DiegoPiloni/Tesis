concrete LogicSym of Logic = CategoriesSym, LexiconSATSym ** open Prelude in {

flags coding = utf8 ;

lin
  PAtom = idS ;
  PNeg = negate ;
  PConj = bin_op ;
  PImpl = bin_op "⇒" ;
  PQuant = quant ;
  APred1 p x = case p.t of {
                 Original => apply p.symb x ;
                 Position1 => apply (apply p.symb x) p.ind;
                 Equality1 => equal p.symb x p.ind ;
                 Inequality1 => negate (equal p.symb x p.ind)
               } ;
  APred2 p x y = case p.t of {
                   Equality => equal p.s x y ;
                   Inequality => negate (equal p.s x y) ;
                   Position => apply (apply p.s x) y
                 } ;

  IVar = idS ;
  Equal = {t = Equality ; s = "=" } ;
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
  PartPred p i = { t = pred1_param p.t ; symb = p.s ; ind = i } ;
  APredRefl p i = case p.t of {
                   Equality => equal p.s i i ;
                   Inequality => negate (equal p.s i i) ;
                   Position => apply (apply p.s i) i
                 } ;
  -- No se linealiza Kind a lenguaje simbólico
  -- No se linealiza QuantIS a lenguaje simbólico.


oper
    idS : Str -> Str = \s -> s ;
    apply : (f, x : Str) -> Str = \f, x -> glue (glue f ".") x ;
    parentesis : Str -> Str = \s -> glue (glue "(" s) ")" ;
    negate : Str -> Str = \s -> glue "¬" s ;
    equal : (eq, x, y : Str) -> Str = \eq, x, y -> parentesis (x ++ eq ++ y) ;
    bin_op : (op, s1, s2 : Str) -> Str = \op, s1, s2 -> parentesis (s1 ++ op ++ s2) ;
    quant : (q, v, r, t : Str) -> Str = 
      \q, v, r, t -> (glue (glue "〈" q) v) ++ ":" ++ r ++ ":" ++  t ++ "〉" ;
    pred1_param : Pred2Type -> Pred1Type = 
      \p2type -> case p2type of {
                  Position => Position1 ;
                  Equality => Equality1 ;
                  Inequality => Inequality1
                } ;

}
