module Logic where

import PGF hiding (Tree)
import qualified PGF
----------------------------------------------------
-- automatic translation from GF to Haskell
----------------------------------------------------

class Gf a where
  gf :: a -> PGF.Tree
  fg :: PGF.Tree -> a

newtype GString = GString String  deriving Show

instance Gf GString where
  gf (GString x) = mkStr x
  fg t =
    case unStr t of
      Just x  ->  GString x
      Nothing -> error ("no GString " ++ show t)

newtype GInt = GInt Int  deriving Show

instance Gf GInt where
  gf (GInt x) = mkInt x
  fg t =
    case unInt t of
      Just x  ->  GInt x
      Nothing -> error ("no GInt " ++ show t)

newtype GFloat = GFloat Double  deriving Show

instance Gf GFloat where
  gf (GFloat x) = mkDouble x
  fg t =
    case unDouble t of
      Just x  ->  GFloat x
      Nothing -> error ("no GFloat " ++ show t)

----------------------------------------------------
-- below this line machine-generated
----------------------------------------------------

data GAtom =
   GAPred1 GPred1 GInd 
 | GAPred2 GPred2 GInd GInd 
  deriving Show

data GAtomEqual = GAEqual GInd GInd 
  deriving Show

data GConj =
   GCAnd 
 | GCOr 
  deriving Show

data GInd =
   GConjInd GConj GListInd 
 | GIFun1 GFun1 GInd 
 | GIFun2 GFun2 GInd GInd 
 | GIVar GVar 
  deriving Show

data GKind =
   GFigura 
 | GModKind GKind GPred1 
  deriving Show

newtype GListInd = GListInd [GInd] deriving Show

newtype GListPred1 = GListPred1 [GPred1] deriving Show

newtype GListVar = GListVar [GVar] deriving Show

data GPred1 =
   GAzul 
 | GChico 
 | GCirculo 
 | GConjPred1 GConj GListPred1 
 | GCuadrado 
 | GGrande 
 | GMediano 
 | GRojo 
 | GTriangulo 
 | GVerde 
  deriving Show

data GPred2 =
   GAbajo 
 | GArriba 
 | GDerecha 
 | GIzquierda 
  deriving Show

data GProp =
   GExistIS GVar GKind GPred1 
 | GFalse 
 | GPAtom GAtom 
 | GPConj GConj GProp GProp 
 | GPImpl GProp GProp 
 | GPNeg GProp 
 | GPNegAtom GAtom 
 | GPNegEqual GInd GInd 
 | GPQuant GQuant GVar GProp GProp 
 | GTrue 
 | GUnivIS GVar GKind GPred1 
  deriving Show

data GQuant =
   GExists 
 | GForAll 
  deriving Show

data GVar = GVString GString 
  deriving Show

data GFun1

data GFun2


instance Gf GAtom where
  gf (GAPred1 x1 x2) = mkApp (mkCId "APred1") [gf x1, gf x2]
  gf (GAPred2 x1 x2 x3) = mkApp (mkCId "APred2") [gf x1, gf x2, gf x3]

  fg t =
    case unApp t of
      Just (i,[x1,x2]) | i == mkCId "APred1" -> GAPred1 (fg x1) (fg x2)
      Just (i,[x1,x2,x3]) | i == mkCId "APred2" -> GAPred2 (fg x1) (fg x2) (fg x3)


      _ -> error ("no Atom " ++ show t)

instance Gf GAtomEqual where
  gf (GAEqual x1 x2) = mkApp (mkCId "AEqual") [gf x1, gf x2]

  fg t =
    case unApp t of
      Just (i,[x1,x2]) | i == mkCId "AEqual" -> GAEqual (fg x1) (fg x2)


      _ -> error ("no AtomEqual " ++ show t)

instance Gf GConj where
  gf GCAnd = mkApp (mkCId "CAnd") []
  gf GCOr = mkApp (mkCId "COr") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "CAnd" -> GCAnd 
      Just (i,[]) | i == mkCId "COr" -> GCOr 


      _ -> error ("no Conj " ++ show t)

instance Gf GInd where
  gf (GConjInd x1 x2) = mkApp (mkCId "ConjInd") [gf x1, gf x2]
  gf (GIFun1 x1 x2) = mkApp (mkCId "IFun1") [gf x1, gf x2]
  gf (GIFun2 x1 x2 x3) = mkApp (mkCId "IFun2") [gf x1, gf x2, gf x3]
  gf (GIVar x1) = mkApp (mkCId "IVar") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1,x2]) | i == mkCId "ConjInd" -> GConjInd (fg x1) (fg x2)
      Just (i,[x1,x2]) | i == mkCId "IFun1" -> GIFun1 (fg x1) (fg x2)
      Just (i,[x1,x2,x3]) | i == mkCId "IFun2" -> GIFun2 (fg x1) (fg x2) (fg x3)
      Just (i,[x1]) | i == mkCId "IVar" -> GIVar (fg x1)


      _ -> error ("no Ind " ++ show t)

instance Gf GKind where
  gf GFigura = mkApp (mkCId "Figura") []
  gf (GModKind x1 x2) = mkApp (mkCId "ModKind") [gf x1, gf x2]

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Figura" -> GFigura 
      Just (i,[x1,x2]) | i == mkCId "ModKind" -> GModKind (fg x1) (fg x2)


      _ -> error ("no Kind " ++ show t)

instance Gf GListInd where
  gf (GListInd [x1,x2]) = mkApp (mkCId "BaseInd") [gf x1, gf x2]
  gf (GListInd (x:xs)) = mkApp (mkCId "ConsInd") [gf x, gf (GListInd xs)]
  fg t =
    GListInd (fgs t) where
     fgs t = case unApp t of
      Just (i,[x1,x2]) | i == mkCId "BaseInd" -> [fg x1, fg x2]
      Just (i,[x1,x2]) | i == mkCId "ConsInd" -> fg x1 : fgs x2


      _ -> error ("no ListInd " ++ show t)

instance Gf GListPred1 where
  gf (GListPred1 [x1,x2]) = mkApp (mkCId "BasePred1") [gf x1, gf x2]
  gf (GListPred1 (x:xs)) = mkApp (mkCId "ConsPred1") [gf x, gf (GListPred1 xs)]
  fg t =
    GListPred1 (fgs t) where
     fgs t = case unApp t of
      Just (i,[x1,x2]) | i == mkCId "BasePred1" -> [fg x1, fg x2]
      Just (i,[x1,x2]) | i == mkCId "ConsPred1" -> fg x1 : fgs x2


      _ -> error ("no ListPred1 " ++ show t)

instance Gf GListVar where
  gf (GListVar [x1]) = mkApp (mkCId "BaseVar") [gf x1]
  gf (GListVar (x:xs)) = mkApp (mkCId "ConsVar") [gf x, gf (GListVar xs)]
  fg t =
    GListVar (fgs t) where
     fgs t = case unApp t of
      Just (i,[x1]) | i == mkCId "BaseVar" -> [fg x1]
      Just (i,[x1,x2]) | i == mkCId "ConsVar" -> fg x1 : fgs x2


      _ -> error ("no ListVar " ++ show t)

instance Gf GPred1 where
  gf GAzul = mkApp (mkCId "Azul") []
  gf GChico = mkApp (mkCId "Chico") []
  gf GCirculo = mkApp (mkCId "Circulo") []
  gf (GConjPred1 x1 x2) = mkApp (mkCId "ConjPred1") [gf x1, gf x2]
  gf GCuadrado = mkApp (mkCId "Cuadrado") []
  gf GGrande = mkApp (mkCId "Grande") []
  gf GMediano = mkApp (mkCId "Mediano") []
  gf GRojo = mkApp (mkCId "Rojo") []
  gf GTriangulo = mkApp (mkCId "Triangulo") []
  gf GVerde = mkApp (mkCId "Verde") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Azul" -> GAzul 
      Just (i,[]) | i == mkCId "Chico" -> GChico 
      Just (i,[]) | i == mkCId "Circulo" -> GCirculo 
      Just (i,[x1,x2]) | i == mkCId "ConjPred1" -> GConjPred1 (fg x1) (fg x2)
      Just (i,[]) | i == mkCId "Cuadrado" -> GCuadrado 
      Just (i,[]) | i == mkCId "Grande" -> GGrande 
      Just (i,[]) | i == mkCId "Mediano" -> GMediano 
      Just (i,[]) | i == mkCId "Rojo" -> GRojo 
      Just (i,[]) | i == mkCId "Triangulo" -> GTriangulo 
      Just (i,[]) | i == mkCId "Verde" -> GVerde 


      _ -> error ("no Pred1 " ++ show t)

instance Gf GPred2 where
  gf GAbajo = mkApp (mkCId "Abajo") []
  gf GArriba = mkApp (mkCId "Arriba") []
  gf GDerecha = mkApp (mkCId "Derecha") []
  gf GIzquierda = mkApp (mkCId "Izquierda") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Abajo" -> GAbajo 
      Just (i,[]) | i == mkCId "Arriba" -> GArriba 
      Just (i,[]) | i == mkCId "Derecha" -> GDerecha 
      Just (i,[]) | i == mkCId "Izquierda" -> GIzquierda 


      _ -> error ("no Pred2 " ++ show t)

instance Gf GProp where
  gf (GExistIS x1 x2 x3) = mkApp (mkCId "ExistIS") [gf x1, gf x2, gf x3]
  gf GFalse = mkApp (mkCId "False") []
  gf (GPAtom x1) = mkApp (mkCId "PAtom") [gf x1]
  gf (GPConj x1 x2 x3) = mkApp (mkCId "PConj") [gf x1, gf x2, gf x3]
  gf (GPImpl x1 x2) = mkApp (mkCId "PImpl") [gf x1, gf x2]
  gf (GPNeg x1) = mkApp (mkCId "PNeg") [gf x1]
  gf (GPNegAtom x1) = mkApp (mkCId "PNegAtom") [gf x1]
  gf (GPNegEqual x1 x2) = mkApp (mkCId "PNegEqual") [gf x1, gf x2]
  gf (GPQuant x1 x2 x3 x4) = mkApp (mkCId "PQuant") [gf x1, gf x2, gf x3, gf x4]
  gf GTrue = mkApp (mkCId "True") []
  gf (GUnivIS x1 x2 x3) = mkApp (mkCId "UnivIS") [gf x1, gf x2, gf x3]

  fg t =
    case unApp t of
      Just (i,[x1,x2,x3]) | i == mkCId "ExistIS" -> GExistIS (fg x1) (fg x2) (fg x3)
      Just (i,[]) | i == mkCId "False" -> GFalse 
      Just (i,[x1]) | i == mkCId "PAtom" -> GPAtom (fg x1)
      Just (i,[x1,x2,x3]) | i == mkCId "PConj" -> GPConj (fg x1) (fg x2) (fg x3)
      Just (i,[x1,x2]) | i == mkCId "PImpl" -> GPImpl (fg x1) (fg x2)
      Just (i,[x1]) | i == mkCId "PNeg" -> GPNeg (fg x1)
      Just (i,[x1]) | i == mkCId "PNegAtom" -> GPNegAtom (fg x1)
      Just (i,[x1,x2]) | i == mkCId "PNegEqual" -> GPNegEqual (fg x1) (fg x2)
      Just (i,[x1,x2,x3,x4]) | i == mkCId "PQuant" -> GPQuant (fg x1) (fg x2) (fg x3) (fg x4)
      Just (i,[]) | i == mkCId "True" -> GTrue 
      Just (i,[x1,x2,x3]) | i == mkCId "UnivIS" -> GUnivIS (fg x1) (fg x2) (fg x3)


      _ -> error ("no Prop " ++ show t)

instance Gf GQuant where
  gf GExists = mkApp (mkCId "Exists") []
  gf GForAll = mkApp (mkCId "ForAll") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Exists" -> GExists 
      Just (i,[]) | i == mkCId "ForAll" -> GForAll 


      _ -> error ("no Quant " ++ show t)

instance Gf GVar where
  gf (GVString x1) = mkApp (mkCId "VString") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "VString" -> GVString (fg x1)


      _ -> GVString (GString "x")

instance Show GFun1

instance Gf GFun1 where
  gf _ = undefined
  fg _ = undefined



instance Show GFun2

instance Gf GFun2 where
  gf _ = undefined
  fg _ = undefined




