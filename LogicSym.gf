concrete LogicSym of Logic = CategoriesSym, LexiconSATSym ** open Prelude in {

flags coding = utf8 ;

lin
  PAtom = idS ;
  PNeg p = negate p ;
  PConj conj p q = bin_op p conj q ;
  PImpl p q = bin_op p "⇒" q ;
  PQuant q v r t = (glue (glue "〈" q) v) ++ ":" ++ r ++ ":" ++  t ++ "〉" ;
  APred1 f x = apply f x ;
  AEqual x y = equal x y ;
  APred2 f x y = apply (apply f x) y ;

  IVar = idS ;

  IFun1 f x = glue f (parentesis x) ; 
  IFun2 f x y = glue f (parentesis ( (glue x ",") ++ y) ) ; 

  VString sr = sr.s ;

  CAnd = "∧" ;
  COr = "∨" ;

  True = "True" ;
  False = "False" ;
  ForAll = "∀" ;
  Exists = "∃" ;

-- extension con Kind

lin
  PNegAtom = negate ;
  PNegEqual x y = negate (parentesis (equal x y)) ;
  -- No se linealiza Kind a lenguaje simbólico
  -- AKind k x = apply k x ;
  -- ModKind k m = ;
  -- No se linealizan los arboles UnivIS, ExistIS a lenguaje simbólico.
  -- UnivIS v k p = (glue "<∀" v) ++  ":" ++ k ++ ":" ++ glue (apply p v) ">" ;
  -- ExistIS v k p =  (glue "<∃" v) ++ ":" ++ k ++ ":" ++ glue (apply p v) ">" ;

-- extension conjunción polimórfica


oper
    idS : Str -> Str = \s -> s ;
    apply : Str -> Str -> Str = \s1, s2 -> glue (glue s1 ".") s2 ;
    parentesis : Str -> Str = \s -> glue (glue "(" s) ")" ;
    negate : Str -> Str = \s -> glue "¬" s ;
    equal : Str -> Str -> Str = \x, y -> x ++ "=" ++ "y" ;
    bin_op : (s1, op, s2 : Str) -> Str = \s1, op, s2 -> parentesis (s1 ++ op ++ s2) ; 

}
