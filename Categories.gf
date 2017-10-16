abstract Categories = {
cat
  Prop ;  -- proposition, complex or atomic   e.g. "0 is even and 1 is odd"
  Atom ;  -- atomic proposition               e.g. "0 is even"
  Pol ;   -- Polarity of Pred1
  Class;  -- Class of Preds
  Pred1 Pol Class; -- one-place predicate     e.g. "even"
  Pred2 Class ; -- two-place predicate        e.g. "A is less than B"
  Ind ;   -- individual term                  e.g. "the square of x"
  Var ;   -- variable of quantification       e.g. "x"
  Fun1 ;  -- one-place individual function    e.g. "square"
  Fun2 ;  -- two-place individual function    e.g. "sum"
  Conj ;  -- conjunction                      e.g. "and"
  Quant ;  -- quantification symbol           e.g. "∀"
  ClassK ;  -- Class of Kinds
  Kind ClassK ;  -- domain of quantification,        e.g. "even number"
  ToKind Class ClassK ;  -- Can create Kind of ClassK with Pred of Class ?
  Distr (c : Class) (Pred2 c) ;
  [Var] {1} ;    -- list of vars (min 1)
  [Ind] {2} ;    -- list of individuals (min 2)
  [Pred1 Pol Class] {2} ;  -- list of unary preds (min 2)
  [Prop] {2} ;  -- list of props (min 2)

data
  -- Basic constructors for Pol
  P : Pol ;  -- positive
  N : Pol ;  -- negative
data
  -- Basic constructors for Class
  Ser : Class ;
  Estar : Class ;
data
  -- Basic constructors for ClassK
  SerK : ClassK ;
  EstarK : ClassK ;
  Fig : ClassK ;
}