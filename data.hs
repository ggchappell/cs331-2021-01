-- data.hs  UNFINISHED
-- Glenn G. Chappell
-- 2020-03-01
--
-- For CS F331 / CSCE A331 Spring 2021
-- Code from 3/1 - Haskell: Data

module Main where

import System.IO  -- for hFlush, stdout


main = do
    putStrLn ""
    putStrLn "This file contains sample code from March 1, 2021,"
    putStrLn "for the topic \"Haskell: Data\"."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "useful. See the source."
    putStrLn ""


-- ***** data Declaration *****


-- Define a new type with "data"

data Product = Pr String String  -- Product name, Manufacturer name
-- Above, the new type is "Product". "Pr" is a *constructor*. Here is a
-- value of type Product:
--   Pr "Sanka" "Kraft Foods"

-- Pattern matching works with constructors. We can use this to get a
-- String out of a Product.

pName :: Product -> String
pName (Pr pn _) = pn  -- Get product name

mName :: Product -> String
mName (Pr _ mn) = mn  -- Get manufacturer name

-- Try:
--   sanka = Pr "Sanka" "Kraft Foods"
--   pName sanka
--   mName sanka

-- Here are functions that do equality checking and conversion to String
-- for type Product.

sameProduct :: Product -> Product -> Bool
sameProduct (Pr pn1 mn1) (Pr pn2 mn2) = (pn1 == pn2) && (mn1 == mn2)

productToString :: Product -> String
productToString (Pr pn mn) = pn ++ " [made by " ++ mn ++ "]"

-- Try:
--   tide = Pr "Tide" "Procter & Gamble"
--   crest = Pr "Crest" "Procter & Gamble"
--   sameProduct tide crest
--   sameProduct tide tide
--   productToString crest


-- ***** Overloading & Type Classes *****


-- Overloading in Haskell is done via type classes. For each overloaded
-- function or operator, there is a corresponding type class. In order
-- to overload the function/operator for a type, that type must be in
-- the type class; we say it is an *instance* of the type class.

-- The equality (==) and inequality (/=) operators are overloaded for
-- instances of type class Eq. In order to overload these for type
-- Product, we make Product an instance of Eq. When we do so, we define
-- the == operator.

instance Eq Product where
    Pr pn1 mn1 == Pr pn2 mn2 = (pn1 == pn2) && (mn1 == mn2)

-- Try:
--   axe = Pr "Axe" "Unilever"
--   dove_soap = Pr "Dove" "Unilever"
--   dove_bar = Pr "Dove" "M&M/Mars"
--   axe == dove_soap
--   dove_soap == dove_bar
--   axe == axe
--   axe /= dove_soap
--   axe /= axe

-- Having defined the == operator, the /= operator is defined for us.
-- This is typical of the way type classes work. We could have defined
-- the /= operator ourselves, and then the == operator would have been
-- defined for us. We also have the option of defining both ourselves.

-- Function "show", which does conversion to String, is overloaded using
-- type class Show.

instance Show Product where
    show (Pr pn mn) = pn ++ " [made by " ++ mn ++ "]"

-- Try:
--   dove_soap = Pr "Dove" "Unilever"
--   show dove_soap
--   dove_soap
--   show dove_soap ++ " is not soap; it is a *beauty bar*."

