-- evaluator.lua  UNFINISHED
-- Glenn G. Chappell
-- 2020-03-29
--
-- For CS F331 / CSCE A331 Spring 2021
-- Evaluator for Arithmetic Expression Represented as AST
-- Used by evalmain.lua


local evaluator = {}  -- Our module


-- Symbolic Constants for AST

local BIN_OP     = 1
local NUMLIT_VAL = 2
local SIMPLE_VAR = 3


-- Named Variables

varValues = {
    ["e"]   = 2.71828182845904523536,
    ["pi"]  = 3.14159265358979323846,
    ["phi"] = 1.61803398874989484820,
    ["zero"] = 0,
    ["one"] = 1,
    ["two"] = 2,
    ["three"] = 3,
    ["four"] = 4,
    ["five"] = 5,
    ["six"] = 6,
    ["seven"] = 7,
    ["eight"] = 8,
    ["nine"] = 9,
    ["ten"] = 10,
    ["answer"] = 42,
    ["year"] = 2021,
}


-- Primary Function

-- evaluator.eval
-- Takes AST in form specified in rdparser4.lua. Returns numeric value.
-- No error checking is done.
function evaluator.eval(ast)
    print("##### Function evaluator.eval needs to be written! #####")
    return 42  -- Dummy value
    -- TODO: WRITE THIS!!!
end


-- Module Export

return evaluator

