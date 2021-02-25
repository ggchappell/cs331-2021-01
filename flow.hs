-- flow.hs
-- Glenn G. Chappell
-- 2021-02-24
--
-- For CS F331 / CSCE A331 Spring 2021
-- Code from 2/24 - Haskell: Flow of Control

module Main where

import System.IO  -- for hFlush, stdout


main = do
    putStrLn ""
    putStrLn "This file contains sample code from February 24, 2021,"
    putStrLn "for the topic \"Haskell: Flow of Control\"."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "useful. See the source."
    putStrLn ""


-- ***** Pattern Matching, Recursion, Lazy Evaluation *****


-- listLength
-- (listLength xs) returns length of given list.
-- So (listLength [4,5,2]) returns 3.
-- Same as standard function length.
listLength [] = 0
listLength (x:xs) = 1 + listLength xs

-- Try:
--   listLength [1..50]

-- listFrom
-- (listFrom n) returns the infinite list [n, n+1, n+2, ...].
-- Example of corecursion.
listFrom n = n:listFrom (n+1)

-- Try:
--   take 20 (listFrom 10)

-- myIf
-- Returns 2nd argument if 1st is true, 3rd if 1st is false.
myIf True  tval _    = tval
myIf False _    fval = fval

-- Try:
--   myIf (3 > 4) "yes" "no"


-- ***** Selection *****


-- If-Then-Else

-- fibo
-- Fibonacci computation using if-then-else.
fibo n = if (n <= 1) then n else (fibo (n-2) + fibo (n-1))

-- Try:
--   fibo 6

-- Guards

-- myAbs
-- Returns absolute value of argument.
-- Same as standard function abs.
myAbs x
    | x >= 0     = x   -- First line with True expression is used
    | otherwise  = -x  -- "otherwise" same as "True"

-- fibo'
-- Fibonacci computation using guards.
fibo' n
    | n <= 1     = n
    | otherwise  = fibo' (n-2) + fibo' (n-1)

-- stringSign
-- Returns sign of argument, as string ("positive", "negative", "zero").
stringSign x
    | x > 0      = "positive"
    | x < 0      = "negative"
    | otherwise  = "zero"

-- Try:
--   stringSign (3-6)

-- Case

-- fibocase
-- Like good 'ol fibo, but using a case construction.
fibocase n = case n of
    0 -> 0
    1 -> 1
    _ -> fibocase (n-2) + fibocase (n-1)


-- ***** Error Handling *****


-- Fatal Errors

-- error :: String -> a
-- Crashes program on execution, displaying given error message.

-- lookInd'
-- Lookup by index, zero-based.
-- Like lookInd from last time.
lookInd' n [] = error "lookInd': Subscript out of range"
lookInd' 0 (x:_) = x
lookInd' n (_:xs) = lookInd' (n-1) xs

-- Try:
--   lookInd' 2 [1,2,3,4]
--   lookInd' 20 [1,2,3,4]

-- undefined :: a
-- Crashes program on execution, displaying fixed error message.

-- fiboFast'
-- Improved Fibonacci function.
fiboFast' n
    | n < 0      = undefined
    | otherwise  = a where
        (a, b) = fiboPair n
        fiboPair 0 = (0, 1)
        fiboPair n = (d, c+d) where
            (c, d) = fiboPair (n-1)

-- Try:
--   fiboFast' 8
--   fiboFast' 1000
--   fiboFast' (-2)


-- ***** Encapsulated Loops *****


-- map: Apply function to each item of list

-- square
-- Returns square of a number - for use with map.
square x = x*x

-- myMap
-- Applies function to each item of a list.
-- Same as standard function map.
myMap f [] = []
myMap f (x:xs) = f x : myMap f xs

-- Try:
--   myMap square [1,4,6]
--   map square [1,4,6]
--   [ square x | x <- [1,4,6] ]

-- filter: Return list of items in a given list meeting some condition

-- myFilter
-- Returns list of all items for which boolean func returns True.
-- Same as standard function filter.
myFilter f [] = []
myFilter f (x:xs)
    | f x        = x:rest
    | otherwise  = rest where
    rest = myFilter f xs

-- Try:
--   myFilter (<= 2) [4,0,8,-2,1,6]
--   filter (<= 2) [4,0,8,-2,1,6]
--   [x | x <- [4,0,8,-2,1,6], x <= 2]

-- zip: Turn two lists into a list of pairs

-- myZip
-- Given two lists, returns list of pairs: the first pair holds the
-- first item from one list and the first item from the other list, etc.
-- This continues until one of the lists runs out.
-- Same as standard function zip.
myZip [] _ = []
myZip _ [] = []
myZip (x:xs) (y:ys) = (x,y):zip xs ys

-- Try:
--   zip (6,3,2,8) "Howdy!"

-- fold operations: Various functions for computing a value from a list

-- mySum
-- Returns sum of items in list.
-- Same as standard function sum.
mySum [] = 0
mySum (a:as) = a + mySum as

-- Same thing, done with a fold

-- mySum' - same as mySum.
mySum' xs = foldl (+) 0 xs

-- mySum'' - same, but will not handle an empty list.
mySum'' xs = foldl1 (+) xs

-- Try:
--   mySum [1..100]
--   mySum' [1..100]
--   mySum'' [1..100]

-- commafy
-- Join two String values, with comma-blank between.
commafy s1 s2 = s1 ++ ", " ++ s2

-- Try:
--   foldl1 commafy ["cats", "hamsters", "chocolate", "happiness"]

-- parenify
-- Join two String values, with a blank between and parentheses around.
parenify s1 s2 = "(" ++ s1 ++ " " ++ s2 ++ ")"

-- Try:
--   foldl1 parenify ["cats", "hamsters", "chocolate", "happiness"]
--   foldr1 parenify ["cats", "hamsters", "chocolate", "happiness"]


-- ***** Other *****


-- seq

-- Try:
--   seq 11 22
--   seq undefined 22

-- Here is listLength rewritten using seq to avoid stack overflow.

-- listLength'
-- (listLength' xs) returns length of given list.
-- Same as standard function length.
listLength' xs = llenplus 0 xs  where
    llenplus n [] = n
    llenplus n (_:xs) = seq n (llenplus (n+1) xs)

-- Do-Construction

-- reverseIt
-- Prompt the user for input, read a line, and print it reversed.
reverseIt = do
    putStr "Type something: "
    hFlush stdout
    line <- getLine
    putStrLn ""
    putStr "Your line, reversed: "
    putStrLn (reverse line)

-- Try:
--   reverseIt

