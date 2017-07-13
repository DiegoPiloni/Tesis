module Transfer where

    import PGF (Tree)
    import Logic

    transfer :: Tree -> Tree
    transfer = gf . norm . fg

    norm :: GProp -> GProp
    norm p@(GUnivIS _ _ _) = quantIStoP p
    norm p@(GExistIS _ _ _) = quantIStoP p
    norm p@(GPAtom (GAPred1 _ _)) = propPreds p
    norm p@(GPNegAtom (GAPred1 _ _)) = propPreds p
    norm (GPNeg p) = GPNeg (norm p)
    norm (GPConj c p1 p2) = GPConj c (norm p1) (norm p2)
    norm (GPImpl p1 p2) = GPImpl (norm p1) (norm p2)
    norm p = p

    quantIStoP :: GProp -> GProp
    quantIStoP (GUnivIS v GFigura p) = GPQuant GForAll v GTrue (GPAtom (GAPred1 p (GIVar v)))
    quantIStoP (GUnivIS v k p) = GPQuant GForAll v (kindToProp k v) (GPAtom (GAPred1 p (GIVar v)))
    quantIStoP (GExistIS v GFigura p) = GPQuant GExists v GTrue (GPAtom (GAPred1 p (GIVar v))) 
    quantIStoP (GExistIS v k p) = GPQuant GExists v (kindToProp k v) (GPAtom (GAPred1 p (GIVar v)))
    quantIStoP p = p

    kindToProp :: GKind -> GVar -> GProp
    kindToProp (GModKind GFigura pred) v = (GPAtom (GAPred1 pred (GIVar v)))
    kindToProp (GModKind k pred) v = GPConj GCAnd (GPAtom (GAPred1 pred (GIVar v))) (kindToProp k v)

    propPreds :: GProp -> GProp
    -- conj de individuos
    propPreds (GPAtom (GAPred1 p (GConjInd c (GListInd [i1, i2])))) = GPConj c (propPreds (GPAtom (GAPred1 p i1))) (propPreds (GPAtom (GAPred1 p i2)))
    propPreds (GPAtom (GAPred1 p (GConjInd c (GListInd (i1:li)) ))) = GPConj c (propPreds (GPAtom (GAPred1 p i1))) (propPreds (GPAtom (GAPred1 p (GConjInd c (GListInd li) ))))
    propPreds (GPNegAtom (GAPred1 p (GConjInd c (GListInd [i1, i2])))) = (GPConj c (propPreds (GPNegAtom (GAPred1 p i1))) (propPreds (GPNegAtom (GAPred1 p i2))))
    propPreds (GPNegAtom (GAPred1 p (GConjInd c (GListInd (i1:li)) ))) = (GPConj c (propPreds (GPNegAtom (GAPred1 p i1))) (propPreds (GPNegAtom (GAPred1 p (GConjInd c (GListInd li) )))))
    -- conj de predicados unarios
    propPreds (GPAtom (GAPred1 (GConjPred1 c (GListPred1 [p1,p2])) i)) = GPConj c (propPreds (GPAtom (GAPred1 p1 i))) (propPreds (GPAtom (GAPred1 p2 i)))
    propPreds (GPAtom (GAPred1 (GConjPred1 c (GListPred1 (p1:lp)) ) i)) = GPConj c (propPreds (GPAtom (GAPred1 p1 i))) (propPreds (GPAtom (GAPred1 (GConjPred1 c (GListPred1 lp) ) i)))
    propPreds (GPNegAtom (GAPred1 (GConjPred1 c (GListPred1 [p1,p2])) i)) = GPNeg (GPConj c (propPreds (GPAtom (GAPred1 p1 i))) (propPreds (GPAtom (GAPred1 p2 i))))
    propPreds (GPNegAtom (GAPred1 (GConjPred1 c (GListPred1 (p1:lp)) ) i)) = GPNeg (GPConj c (propPreds (GPAtom (GAPred1 p1 i))) (propPreds (GPAtom (GAPred1 (GConjPred1 c (GListPred1 lp) ) i))))
    -- otherwise
    propPreds p = p