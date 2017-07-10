module Main where

    import PGF
    import System.Environment
    import Transfer

    main :: IO ()
    main = do
        file:_ <- getArgs
        gr <- readPGF file
        interact (translate gr)

    -- Removes from string the BIND char " &+ ".
    bind :: [Char] -> [Char]
    bind [] = []
    bind (' ' : '&' : '+' : ' ' : s) = bind s
    bind (c:s) = c : bind s

    bindM :: [String] -> [String]
    bindM = map bind

    translate :: PGF -> String -> String
    translate gr s = case parseAllLang gr (startCat gr) s of
        (lg,t:_):_ -> unlines $
            bindM [linearize gr l (transfer t) | l <- languages gr, l /= lg]
        _ -> "NO PARSE\n"

