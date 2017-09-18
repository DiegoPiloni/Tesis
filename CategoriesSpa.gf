concrete CategoriesSpa of Categories = open 
  SyntaxSpa, 
  SymbolSpa in {

param Pred2Type = Equality | Inequality | Position ;
param Pred1Type = Original | PA Pred2Type ;
param Pol1 = Pos | Neg ;
param QuantP = Exist | ForAll ;

oper KindT : Type = { pol : Pol1 ; n : CN ; a : AP } ;
oper Pred1T : Type = { t : Pred1Type ; pol : Pol1 ; s : AP } ;
oper Pred2T : Type = { t : Pred2Type ; s : A2 } ;

lincat
  Prop = S ;
  Atom = Cl ;
  Pred1 = Pred1T ;
  Pred2 = Pred2T ;
  Var = Symb ;
  Conj = SyntaxSpa.Conj ;
  Ind = NP ;
  Fun1 = N2 ;
  Fun2 = N2 ;
  Kind = KindT ;
  [Prop] = [S] ;
  [Pred1] = [AP] ;
  [Ind] = [NP] ;
  [Var] = NP ;
  Distr = {} ;
  Pol = {} ;
}
