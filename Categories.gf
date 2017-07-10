abstract Categories = {
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
  Quant ;  -- quantification symbol           e.g. "∀"
  Kind ;  -- domain of quantification,        e.g. "even number"
  -- [Prop] {2}  -- list of props (mn 2)
  [Var] {1} ;    -- list of vars (min 1)
  [Ind] {2} ;    -- list of individuals (min 2)
  [Pred1] {2} ;  -- list of unary preds (min 2)
}