concrete CategoriesSym of Categories = {

param Pred2Type = Equality | Inequality | Position ;
param Pred1Type = Original | PA Pred2Type ;

oper Pred1T : Type = { t : Pred1Type ; symb : Str ; ind : Str } ;
oper Pred2T : Type = { t : Pred2Type ; s : Str } ;

lincat
  Prop, Atom, Var, Conj, Quant, Ind, Fun1, Fun2 = Str ;
  Pred1 = Pred1T ;
  Pred2 = Pred2T ;
}