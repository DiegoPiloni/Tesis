concrete CategoriesSpa of Categories = open 
  SyntaxSpa, 
  SymbolSpa in {

param Pred2Type = Equality | Inequality | Position ;
param Pred1Type = Original | PA Pred2Type ;
param Pol1 = Pos | Neg ;
param ClassC = SerC | EstarC ;
param ClassCK = SerCK | EstarCK | FigC ;
param QuantP = Exist | ForAll | None ;

oper KindT : Type = { cl : ClassCK ; pol : Pol1 ; n : CN ; a : AP } ;
oper Pred1T : Type = { cl : ClassC ; pol : Pol1 ; s : AP } ;
oper Pred2T : Type = { cl : ClassC ; s : A2 } ;

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
  Class = {} ;
  ClassK = {} ;
  ToKind = {} ;
}
