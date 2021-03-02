-- squareem.hs
-- Glenn G. Chappell
-- 2021-03-01
--
-- For CS F331 / CSCE A331 Spring 2021
-- Computer Science I Program in Haskell

module Main where

import System.IO  -- for hFlush, stdout


-- squareEm
-- Repeatedly input a number from the user. If 0, then quit; otherwise
--  print its square, and repeat.
squareEm = do
    putStr "Type a number (0 to quit): "
    hFlush stdout       -- Make sure prompt comes before input
    line <- getLine     -- Bind name to I/O-wrapped value
    let n = read line   -- Bind name to non-I/O value
                        -- Compiler knows n is a number by how we use it
    if n == 0
        then return ()  -- Must have I/O action here, so make it null
        else do
            putStrLn ""
            putStr "The square of your number is: "
            putStrLn $ show $ n*n
            putStrLn ""
            squareEm   -- Repeat


-- main
-- Demonstrate squareEm.
main = squareEm

