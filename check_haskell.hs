-- check_haskell.hs
-- Glenn G. Chappell
-- 2021-02-02
--
-- For CS F331 / CSCE A331 Spring 2021
-- A Haskell Program to Run
-- Used in Assignment 2, Exercise 1

module Main where


-- main
-- Print second secret message.
main = do
    putStrLn "Secret message #2:"
    putStrLn ""
    putStrLn secret_message


-- secret_message
-- A mysterious message.
secret_message = map xk xj where
    xa = [64,1,-39,49,0,-5]
    xb = [-15,-39,50,-7,-49,34]
    xc = [12,-11,3,-5,-45,55]
    xd = [-12,4,-5,-52,45,5]
    xe = [-23,9,6,-13,3,-11]
    xf = [2,-13,17,31,-14,6]
    xg = "The treasure is buried under a palm tree on the third island."
    xh = map (+ xl) $ concat [xa, xb, xc, xd, xe]
    xi a as = a : map (+ a) as
    xj = foldr xi [] xh
    xk a = toEnum a `asTypeOf` (head xg)
    xl = head xf

