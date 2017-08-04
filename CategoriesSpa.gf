concrete CategoriesSpa of Categories = open 
  SyntaxSpa, 
  SymbolSpa in {

param Pred2Type = Equality | Inequality | Position ;
param Pred1Type = Original | PA Pred2Type ;

lincat
  Prop = S ;
  Atom = Cl ;
  Pred1 = { t : Pred1Type ; s : AP } ;
  Pred2 = { t : Pred2Type ; s : A2 } ;
  Var = Symb ;
  Conj = SyntaxSpa.Conj ;
  Ind = NP ;
  Fun1 = N2 ;
  Fun2 = N2 ;
  Kind = CN ;
  [Prop] = [S] ;
  [Pred1] = [AP] ;
  [Ind] = [NP] ;
  [Var] = NP ;
  Distr = {} ;
}
