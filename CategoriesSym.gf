concrete CategoriesSym of Categories = {

param Pred2Type = Equality | Inequality | Position ;
param Pred1Type = Original | Equality1 | Inequality1 | Position1 ;

lincat
  Prop, Atom, Var, Conj, Quant, Ind, Fun1, Fun2 = Str ;
  Pred1 = { t : Pred1Type ; symb : Str ; ind : Str } ;
  Pred2 = { t : Pred2Type ; s : Str } ;
}