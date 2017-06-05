concrete LogicSym of Logic =  open Prelude in {

flags coding = utf8 ;

lincat
  Prop, Atom, AtomEqual, Pred1, Pred2, Var, Conj, Ind, Fun1, Fun2 = Str ;

lin
  PAtom = idS ;
  PNeg p = negate p ;
  PConj conj p q = bin_op p conj q ;
  PImpl p q = bin_op p "⇒" q ;
  PUniv v p = (glue "<∀" v) ++ ":" ++ ":" ++ p ++ ">" ;
  PExist v p = (glue "<∃" v) ++ ":" ++ ":" ++ p ++ ">" ;
  APred1 f x = apply f x ;
  AEqual x y = equal x y ;
  APred2 f x y = apply (apply f x) y ;

  IVar = idS ;

  IFun1 f x = glue f (parentesis x) ; 
  IFun2 f x y = glue f (parentesis ( (glue x ",") ++ y) ) ; 

  VString sr = sr.s ;

  CAnd = "∧" ;
  COr = "∨" ;

-- supplementary

lincat
  Kind = Str ;
lin
  -- AKind k x = apply k x ;
  PNegAtom = negate ;
  PNegEqual x y = negate (parentesis (equal x y)) ;
  UnivIS v k p = (glue "<∀" v) ++  ":" ++ k ++ ":" ++ glue (apply p v) ">" ;
  ExistIS v k p =  (glue "<∃" v) ++ ":" ++ k ++ ":" ++ glue (apply p v) ">" ;
  ModKind k m = "modKind" ;

oper
    idS : Str -> Str = \s -> s ;
    apply : Str -> Str -> Str = \s1, s2 -> glue (glue s1 ".") s2 ;
    parentesis : Str -> Str = \s -> glue (glue "(" s) ")" ;
    negate : Str -> Str = \s -> glue "¬" s ;
    equal : Str -> Str -> Str = \x, y -> x ++ "=" ++ "y" ;
    bin_op : (s1, op, s2 : Str) -> Str = \s1, op, s2 -> parentesis (s1 ++ op ++ s2) ; 


-- test lexicon

lin

  -- Pred1

  Chico = "Chico" ;
  Mediano = "Mediano" ;
  Grande = "Grande" ;

  Rojo = "Rojo" ;
  Verde = "Verde" ;
  Azul = "Azul" ;

  -- Kind
  Circulo = "Circ" ;
  Triangulo = "Tr" ;
  Cuadrado = "Cuad" ;

  -- Pred2
  Izquierda = "izq" ;
  Derecha = "der" ;
  Arriba = "arriba" ;
  Abajo = "abajo" ;

  -- Kind
  Figura = "" ;
}
