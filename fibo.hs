-- fibo.hs
-- Glenn G. Chappell
-- 2021-02-19
--
-- For CS F331 / CSCE A331 Spring 2021
-- Compute Fibonacci Numbers

module Main where


-- The Fibonacci number F(n), for n >= 0, is defined by F(0) = 0,
-- F(1) = 1, and for n >= 2, F(n) = F(n-2) + F(n-1).


-- fibopair
-- Given n >= 0, return a pair of Fibonacci numbers: (F(n), F(n+1)).
-- Used by fibo.
fibopair 0 = (0, 1)
fibopair n = (nextfib, currfib+nextfib) where
    (currfib, nextfib) = fibopair (n-1)


-- fibo
-- Given n >= 0, return Fibonacci number F(n).
-- Uses fibopair.
fibo n = currfib where
    (currfib, nextfib) = fibopair n


-- allfibs
-- List of ALL Fibonacci numbers: [F(0), F(1), F(2), ...].
-- Uses fibo.
allfibs = map fibo [0..]


-- printListWithName
-- Print items in given list, each preceded by "NAME(#) = ", where NAME
-- is the first parameter, and # is an increasing index starting at the
-- second parameter. The third parameter is the list.
--
-- Example usage:
--   printListWithName "Square" 2 [4,9,16]
-- Output:
--   Square(2) = 4
--   Square(3) = 9
--   Square(4) = 16
printListWithName _ _ [] = return ()
printListWithName name i (f:fs) = do
    putStrLn $ name ++ "(" ++ (show i) ++ ") = " ++ (show f)
    printListWithName name (i+1) fs


-- main
-- Print some Fibonacci numbers.
main = do
    putStrLn "Fibonacci Numbers"
    printListWithName "F" 0 my_fibo_list
    putStrLn ""

    where
        how_many_to_print = 20
        my_fibo_list = take how_many_to_print allfibs

