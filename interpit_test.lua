#!/usr/bin/env lua
-- interpit_test.lua
-- Glenn G. Chappell
-- 2021-04-07
--
-- For CS F331 / CSCE A331 Spring 2021
-- Test Program for Module interpit
-- Used in Assignment 6, Exercise 2

interpit = require "interpit"  -- Import interpit module


-- *********************************************
-- * YOU MAY WISH TO CHANGE THE FOLLOWING LINE *
-- *********************************************

EXIT_ON_FIRST_FAILURE = true
-- If EXIT_ON_FIRST_FAILURE is true, then this program exits after the
-- first failing test. If it is false, then this program executes all
-- tests, reporting success/failure for each.


-- *********************************************************************
-- Testing Package
-- *********************************************************************


tester = {}
tester.countTests = 0
tester.countPasses = 0

function tester.test(self, success, testName)
    self.countTests = self.countTests+1
    io.write("    Test: " .. testName .. " - ")
    if success then
        self.countPasses = self.countPasses+1
        io.write("passed")
    else
        io.write("********** FAILED **********")
    end
    io.write("\n")
end

function tester.allPassed(self)
    return self.countPasses == self.countTests
end


-- *********************************************************************
-- Utility Functions
-- *********************************************************************


-- terminate
-- Called to end the program. Currently simply ends. To make the program
-- prompt the user and wait for the user to press ENTER, uncomment the
-- commented-out lines in the function body. The parameter is the
-- program's return value.
function terminate(status)
    -- Uncomment to following to wait for the user before terminating.
    --io.write("\nPress ENTER to quit ")
    --io.read("*l")

    os.exit(status)
end


function failExit()
    if EXIT_ON_FIRST_FAILURE then
        io.write("**************************************************\n")
        io.write("* This test program is configured to exit after  *\n")
        io.write("* the first failing test. To make it execute all *\n")
        io.write("* tests, reporting success/failure for each, set *\n")
        io.write("* variable                                       *\n")
        io.write("*                                                *\n")
        io.write("*   EXIT_ON_FIRST_FAILURE                        *\n")
        io.write("*                                                *\n")
        io.write("* to false, near the start of the test program.  *\n")
        io.write("**************************************************\n")

        -- Terminate program, signaling error
        terminate(1)
    end
end


function endMessage(passed)
    if passed then
        io.write("All tests successful\n")
    else
        io.write("Tests ********** UNSUCCESSFUL **********\n")
        io.write("\n")
        io.write("**************************************************\n")
        io.write("* This test program is configured to execute all *\n")
        io.write("* tests, reporting success/failure for each. To  *\n")
        io.write("* make it exit after the first failing test, set *\n")
        io.write("* variable                                       *\n")
        io.write("*                                                *\n")
        io.write("*   EXIT_ON_FIRST_FAILURE                        *\n")
        io.write("*                                                *\n")
        io.write("* to true, near the start of the test program.   *\n")
        io.write("**************************************************\n")
    end
end


-- printValue
-- Given a value, print it in (roughly) Lua literal notation if it is
-- nil, number, string, boolean, or table -- calling this function
-- recursively for table keys and values. For other types, print an
-- indication of the type. The second argument, if passed, is max_items:
-- the maximum number of items in a table to print.
function printValue(...)
    assert(select("#", ...) == 1 or select("#", ...) == 2,
           "printValue: must pass 1 or 2 arguments")
    local x, max_items = select(1, ...)  -- Get args (may be nil)
    if type(max_items) ~= "nil" and type(max_items) ~= "number" then
        error("printValue: max_items must be a number")
    end

    if type(x) == "nil" then
        io.write("nil")
    elseif type(x) == "number" then
        io.write(x)
    elseif type(x) == "string" then
        io.write('"'..x..'"')
    elseif type(x) == "boolean" then
        if x then
            io.write("true")
        else
            io.write("false")
        end
    elseif type(x) ~= "table" then
        io.write('<'..type(x)..'>')
    else  -- type is "table"
        io.write("{")
        local first = true  -- First iteration of loop?
        local key_count, unprinted_count = 0, 0
        for k, v in pairs(x) do
            key_count = key_count + 1
            if max_items ~= nil and key_count > max_items then
                unprinted_count = unprinted_count + 1
            else
                if first then
                    first = false
                else
                    io.write(",")
                end
                io.write(" [")
                printValue(k, max_items)
                io.write("]=")
                printValue(v, max_items)
            end
        end
        if unprinted_count > 0 then
            if first then
                first = false
            else
                io.write(",")
            end
            io.write(" <<"..unprinted_count)
            if key_count - unprinted_count > 0 then
                io.write(" more")
            end
            if unprinted_count == 1 then
                io.write(" item>>")
            else
                io.write(" items>>")
            end
        end
        io.write(" }")
    end
end


-- printArray
-- Like printValue, but prints top-level tables as arrays.
-- Uses printValue.
-- The second argument, if passed, is max_items: the maximum number of
-- items in a table to print.
function printArray(...)
    assert(select("#", ...) == 1 or select("#", ...) == 2,
           "printArray: must pass 1 or 2 arguments")
    local x, max_items = select(1, ...)  -- Get args (may be nil)
    if type(max_items) ~= "nil" and type(max_items) ~= "number" then
        error("printArray: max_items must be a number")
    end

    if type(x) ~= "table" then
        printValue(x, max_items)
    else
        io.write("{")
        local first = true  -- First iteration of loop?
        local key_count, unprinted_count = 0, 0
        for k, v in ipairs(x) do
            key_count = key_count + 1
            if max_items ~= nil and key_count > max_items then
                unprinted_count = unprinted_count + 1
            else
                if first then
                    first = false
                else
                    io.write(",")
                end
                io.write(" ")
                printValue(v, max_items)
            end
        end
        if unprinted_count > 0 then
            if first then
                first = false
            else
                io.write(",")
            end
            io.write(" <<"..unprinted_count)
            if key_count - unprinted_count > 0 then
                io.write(" more")
            end
            if unprinted_count == 1 then
                io.write(" item>>")
            else
                io.write(" items>>")
            end
        end
        io.write(" }")
    end
end


-- numKeys
-- Given a table, return the number of keys in it.
function numKeys(tab)
    local keycount = 0
    for k, v in pairs(tab) do
        keycount = keycount + 1
    end
    return keycount
end


-- equal
-- Compare equality of two values. Returns false if types are different.
-- Uses "==" on non-table values. For tables, recurses for the value
-- associated with each key.
function equal(...)
    assert(select("#", ...) == 2,
           "equal: must pass exactly 2 arguments")
    local x1, x2 = select(1, ...)  -- Get args (may be nil)

    local type1 = type(x1)
    if type1 ~= type(x2) then
        return false
    end

    if type1 ~= "table" then
       return x1 == x2
    end

    -- Get number of keys in x1 & check values in x1, x2 are equal
    local x1numkeys = 0
    for k, v in pairs(x1) do
        x1numkeys = x1numkeys + 1
        if not equal(v, x2[k]) then
            return false
        end
    end

    -- Check number of keys in x1, x2 same
    local x2numkeys = 0
    for k, v in pairs(x2) do
        x2numkeys = x2numkeys + 1
    end
    return x1numkeys == x2numkeys
end



-- *********************************************************************
-- Definitions for This Test Program
-- *********************************************************************


-- Symbolic Constants for AST
-- Names differ from those in assignment, to avoid interference.
local STMTxLIST    = 1
local WRITExSTMT   = 2
local RETURNxSTMT  = 3
local ASSNxSTMT    = 4
local FUNCxCALL    = 5
local FUNCxDEF     = 6
local IFxSTMT      = 7
local FORxLOOP     = 8
local STRLITxOUT   = 9
local CRxOUT       = 10
local DQxOUT       = 11
local CHARxCALL    = 12
local BINxOP       = 13
local UNxOP        = 14
local NUMLITxVAL   = 15
local BOOLLITxVAL  = 16
local READNUMxCALL = 17
local SIMPLExVAR   = 18
local ARRAYxVAR    = 19


-- deepcopy
-- Returns deep copy of given value.
-- From http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


-- isState
-- Return true if given value is properly formatted Caracal state table,
-- false otherwise.
function isState(tab)
    -- Is table?
    if type(tab) ~= "table" then
        return false
    end

    -- Has exactly 3 keys?
    if numKeys(tab) ~= 3 then
        return false
    end

    -- Has f, v, a keys?
    if tab.f == nil or tab.v == nil or tab.a == nil then
        return false
    end

    -- f, v, a keys are tables?
    if type(tab.f) ~= "table"
      or type(tab.v) ~= "table"
      or type(tab.a) ~= "table" then
        return false
    end

    -- All items in f are string:table
    -- String begins with "[_A-Za-z]"
    for k, v in pairs(tab.f) do
        if type(k) ~= "string" or type(v) ~= "table" then
            return false
        end
        if k:sub(1,1) ~= "_"
           and (k:sub(1,1) < "A" or k:sub(1,1) > "Z")
           and (k:sub(1,1) < "a" or k:sub(1,1) > "z") then
            return false
        end
    end

    -- All items in v are string:number
    -- String begins with "[_A-Za-z]"
    for k, v in pairs(tab.v) do
        if type(k) ~= "string" or type(v) ~= "number" then
            return false
        end
        if k:sub(1,1) ~= "_"
           and (k:sub(1,1) < "A" or k:sub(1,1) > "Z")
           and (k:sub(1,1) < "a" or k:sub(1,1) > "z") then
            return false
        end
    end

    -- All items in a are string:table
    -- String begins with "[_A-Za-z]"
    -- All items in values in a are number:number
    for k, v in pairs(tab.a) do
        if type(k) ~= "string" or type(v) ~= "table" then
            return false
        end
        if k:sub(1,1) ~= "_"
           and (k:sub(1,1) < "A" or k:sub(1,1) > "Z")
           and (k:sub(1,1) < "a" or k:sub(1,1) > "z") then
            return false
        end
        for kk, vv in pairs(v) do
            if type(kk) ~= "number" or type(vv) ~= "number" then
                return false
            end
        end
    end

    return true
end


-- checkInterp
-- Given tester object, AST, array of input strings, input state, array
-- of expected output strings, expected output state, and string giving
-- the name of the test. Calls interpit.interp and checks output strings
-- & state. Prints result. If test fails and EXIT_ON_FIRST_FAILURE is
-- true, then print detailed results and exit program.
function checkInterp(t, ast,
                     input, statein,
                     expoutput, expstateout,
                     testName)
    -- Error flags
    local err_incallparam = false
    local err_outcallnil = false
    local err_outcallnonstr = false

    local incount = 0
    local function incall(param)
        if param ~= nil then
            err_incallparam = true
        end
        incount = incount + 1
        if incount <= #input then
            return input[incount]
        else
            return ""
        end
    end

    local output = {}
    local function outcall(str)
        if type(str) == "string" then
            table.insert(output, str)
        elseif str == nil then
            err_outcallnil = true
            table.insert(output, "")
        else
            err_outcallnonstr = true
            table.insert(output, "")
        end
    end

    local pass = true
    local msg = ""

    local success, result = pcall(interpit.interp,
                                  ast, statein, incall, outcall)
    if not success then
        pass = false
        msg = msg.."interpit.interp crashed:".."\n  "..result.."\n"
    else
        local stateout = result

        if incount > #input then
            pass = false
            msg = msg .. "Too many calls to incall\n"
        elseif incount < #input then
            pass = false
            msg = msg .. "Too few calls to incall\n"
        end

        if err_incallparam then
            pass = false
            msg = msg .. "incall called with parameter\n"
        end

        if #output > #expoutput then
            pass = false
            msg = msg .. "Too many calls to outcall\n"
        elseif #output < #expoutput then
            pass = false
            msg = msg .. "Too few calls to outcall\n"
        end

        if err_outcallnil then
            pass = false
            msg = msg ..
                 "outcall called with nil or missing parameter\n"
        end
        if err_outcallnonstr then
            pass = false
            msg = msg .. "outcall called with non-string parameter\n"
        end

        if not equal(output, expoutput) then
            pass = false
            msg = msg .. "Output incorrect\n"
        end

        if isState(stateout) then
            if not equal(stateout, expstateout) then
                pass = false
                msg = msg .. "Returned state is incorrect\n"
            end
        else
            pass = false
            msg = msg .. "Returned state is not a Caracal state\n"
        end
    end

    t:test(pass, testName)
    if pass or not EXIT_ON_FIRST_FAILURE then
        return
    end

    io.write("\n")
    io.write(msg)
    io.write("\n")
    failExit()
end


-- *********************************************************************
-- Test Suite Functions
-- *********************************************************************


function test_pre_written(t)
    io.write("Test Suite: programs that work with pre-written"
             .." interpit.lua\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- Empty program
    ast = {STMTxLIST}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Empty program")

    -- Empty write
    ast = {STMTxLIST, {WRITExSTMT}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "write nothing")

    -- Write: empty string
    ast = {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '""'}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {""}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write: empty string")

    -- Write: string, double-quoted
    ast = {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"def"'}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"def"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write: string, double-quoted")

    -- Write: string + string
    ast = {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"abc"'},
      {STRLITxOUT, '"def"'}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"abc", "def"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write: string + cr")

    -- Write: number
    ast = {STMTxLIST, {WRITExSTMT, {NUMLITxVAL, "42"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"42"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write: number")

    -- Write: string + number + number + string
    ast = {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"abc"'},
      {NUMLITxVAL, "042"}, {NUMLITxVAL, "1"}, {STRLITxOUT, '"x"'}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"abc", "42", "1", "x"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write: string + number + number + string")

    -- Func, no call
    ast = {STMTxLIST, {FUNCxDEF, "x",
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"abc"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={}, a={}, f={["x"]={STMTxLIST,
      {WRITExSTMT, {STRLITxOUT, '"abc"'}}}}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Func, no call")

    -- Call, no func
    ast = {STMTxLIST, {FUNCxCALL, "x"}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Call, no func")

    -- Func with call (wrong name)
    ast = {STMTxLIST, {FUNCxDEF, "x",
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"abc"'}}}},
      {FUNCxCALL, "y"}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={}, a={}, f={["x"]={STMTxLIST,
      {WRITExSTMT, {STRLITxOUT, '"abc"'}}}}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Func with call (wrong name)")

    -- Func with call (right name)
    ast = {STMTxLIST, {FUNCxDEF, "x",
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"abc"'}}}},
      {FUNCxCALL, "x"}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"abc"}
    expstateout = {v={}, a={}, f={["x"]={STMTxLIST,
      {WRITExSTMT, {STRLITxOUT, '"abc"'}}}}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Func with call (right name)")

    -- Func defs func, no call
    ast = {STMTxLIST, {FUNCxDEF, "x",
      {STMTxLIST, {FUNCxDEF, "y", {STMTxLIST}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={}, a={}, f={["x"]={STMTxLIST,
      {FUNCxDEF, "y", {STMTxLIST}}}}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Func defs func, no call")

    -- Func defs func, with call
    ast = {STMTxLIST, {FUNCxDEF, "x",
      {STMTxLIST, {FUNCxDEF, "y", {STMTxLIST}}}},
      {FUNCxCALL, "x"}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={}, a={}, f={["x"]={STMTxLIST,
      {FUNCxDEF, "y", {STMTxLIST}}},
      ["y"]={STMTxLIST}}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Func defs func, with call")
end


function test_simple(t)
    io.write("Test Suite: simple programs\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- Simple assignment: number
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "a"},
      {NUMLITxVAL, "42"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["a"]=42}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Simple assignment: number")

    -- Simple assignment: true
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "a"},
      {BOOLLITxVAL, "true"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["a"]=1}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Simple assignment: true")

    -- Simple assignment: false
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "a"},
      {BOOLLITxVAL, "false"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["a"]=0}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Simple assignment: false")

    -- Simple if #1
    ast = {STMTxLIST, {IFxSTMT, {NUMLITxVAL, "0"}, {STMTxLIST}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Simple if #1")

    -- Simple if #2
    ast = {STMTxLIST, {IFxSTMT, {NUMLITxVAL, "4"}, {STMTxLIST}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Simple if #2")

    -- Simple for-loop
    ast = {STMTxLIST, {FORxLOOP, {}, {NUMLITxVAL, "0"}, {},
      {STMTxLIST}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Simple for-loop")

    -- Write: number
    ast = {STMTxLIST, {WRITExSTMT, {NUMLITxVAL, "28"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"28"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write: number")

    -- Write: undefined variable
    ast = {STMTxLIST, {WRITExSTMT, {SIMPLExVAR, "d"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write: undefined variable")

   -- Simple input
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "b"},
      {READNUMxCALL}}}
    input = {"37"}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["b"]=37}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Simple input")

    -- Set + write: variable
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "c"},
      {NUMLITxVAL, "57"}}, {WRITExSTMT, {SIMPLExVAR, "c"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"57"}
    expstateout = {v={["c"]=57}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Set + write: variable")

    -- Set + write: other variable
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "c"},
      {NUMLITxVAL, "57"}}, {WRITExSTMT, {SIMPLExVAR, "d"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = {v={["c"]=57}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Set + write: variable")

    -- Read + write: variable
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "c"},
      {READNUMxCALL}}, {WRITExSTMT, {SIMPLExVAR, "c"}}}
    input = {"12"}
    statein = deepcopy(emptystate)
    expoutput = {"12"}
    expstateout = {v={["c"]=12}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Read + write: variable")

    -- Read + write: other variable
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "c"},
      {READNUMxCALL}}, {WRITExSTMT, {SIMPLExVAR, "d"}}}
    input = {"24"}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = {v={["c"]=24}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Read + write: other variable")

    -- Set array
    ast = {STMTxLIST, {ASSNxSTMT,
      {ARRAYxVAR, "a", {NUMLITxVAL, "2"}},
      {NUMLITxVAL, "7"}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={}, a={["a"]={[2]=7}}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Set array")
end


function test_state(t)
    io.write("Test Suite: modified initial state\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- Empty program
    ast = {STMTxLIST}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - empty program")

    -- Set simple var #1
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "a"}, {NUMLITxVAL, "3"}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {}
    expstateout = {v={["a"]=3,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - set simple var #1")

    -- Set simple var #2
    ast = {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "c"}, {NUMLITxVAL, "3"}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {}
    expstateout = {v={["a"]=1,["b"]=2,["c"]=3},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - set simple var #2")

    -- Set array #1
    ast = {STMTxLIST, {ASSNxSTMT,
      {ARRAYxVAR, "b", {NUMLITxVAL, "2"}},
      {NUMLITxVAL, "9"}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {}
    expstateout = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=9,[4]=3}}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - set array #1")

    -- Set array #2
    ast = {STMTxLIST, {ASSNxSTMT,
      {ARRAYxVAR, "b", {NUMLITxVAL, "-5"}},
      {NUMLITxVAL, "9"}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {}
    expstateout = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3,[-5]=9}}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - set array #2")

    -- Set array #3
    ast = {STMTxLIST, {ASSNxSTMT,
      {ARRAYxVAR, "c", {NUMLITxVAL, "0"}},
      {NUMLITxVAL, "9"}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {}
    expstateout = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3},["c"]={[0]=9}},
      f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - set array #3")

    -- Write simple var #1
    ast = {STMTxLIST, {WRITExSTMT, {SIMPLExVAR, "a"}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - Write simple var #1")

    -- Write simple var #2
    ast = {STMTxLIST, {WRITExSTMT, {SIMPLExVAR, "c"}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - Write simple var #2")

    -- Write array #1
    ast = {STMTxLIST, {WRITExSTMT, {ARRAYxVAR, "a",
      {NUMLITxVAL, "4"}}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {"7"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - Write array #1")

    -- Write array #2
    ast = {STMTxLIST, {WRITExSTMT, {ARRAYxVAR, "a",
      {NUMLITxVAL, "8"}}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - Write array #2")

    -- Write array #3
    ast = {STMTxLIST, {WRITExSTMT, {ARRAYxVAR, "c",
      {NUMLITxVAL, "8"}}}}
    input = {}
    statein = {v={["a"]=1,["b"]=2},
      a={["a"]={[2]=3,[4]=7},["b"]={[2]=7,[4]=3}}, f={}}
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - Write array #3")

    -- Write-set-write-read-write
    ast = {STMTxLIST,
      {WRITExSTMT, {SIMPLExVAR, "abc"}},
      {ASSNxSTMT, {SIMPLExVAR, "abc"}, {NUMLITxVAL, "55"}},
      {WRITExSTMT, {SIMPLExVAR, "abc"}},
      {ASSNxSTMT, {SIMPLExVAR, "abc"}, {READNUMxCALL}},
      {WRITExSTMT, {SIMPLExVAR, "abc"}}}
    input = {"66"}
    statein = {v={["abc"]=44}, a={}, f={}}
    expoutput = {"44", "55", "66"}
    expstateout = {v={["abc"]=66}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - Write-set-write-read-write")

    -- Call func
    ast = {STMTxLIST, {FUNCxCALL, "q"}}
    input = {}
    statein = {v={}, a={}, f={["q"]=
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"x"'}}}
    }}
    expoutput = {"x"}
    expstateout = {v={}, a={}, f={["q"]=
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"x"'}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Modified initial state - Function")
end


function test_special_chars(t)
    io.write("Test Suite: write special characters\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- write with char()
    ast = {STMTxLIST, {WRITExSTMT, {CHARxCALL, {NUMLITxVAL, "65"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"A"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write with char()")

    -- char() containing nontrivial expression
    ast = {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}, {CHARxCALL,
      {{BINxOP, "+"}, {NUMLITxVAL, "60"}, {NUMLITxVAL, "6"}}},
      {STRLITxOUT, '"z"'}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"a", "B", "z"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "char() containing nontrivial expression")

    -- char() containing out-of-range value #1
    ast = {STMTxLIST, {WRITExSTMT, {CHARxCALL, {{UNxOP, "-"},
      {NUMLITxVAL, "1"}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {string.char(0)}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "char() containing out-of-range value #1")

    -- char() containing out-of-range value #2
    ast = {STMTxLIST, {WRITExSTMT, {CHARxCALL, {NUMLITxVAL, "1000"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {string.char(0)}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "char() containing out-of-range value #2")

    -- Write dq
    ast = {STMTxLIST, {WRITExSTMT, {DQxOUT}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {'"'}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write dq")

    -- Write several special characters
    ast =
      {STMTxLIST,{WRITExSTMT,{CHARxCALL,{NUMLITxVAL,"1"}},{DQxOUT},
        {CRxOUT},{CHARxCALL,{ NUMLITxVAL,"2"}},{DQxOUT},{CRxOUT}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {string.char(1), '"', '\n', string.char(2), '"', '\n'}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write several special characters")

    -- String with backslash
    ast = {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"\\n"'}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"\\n"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "String with backslash")
end


function test_expr(t)
    io.write("Test Suite: expressions\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- Write unary +
    ast = {STMTxLIST, {WRITExSTMT,
      {{UNxOP, "+"}, {NUMLITxVAL, "5"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"5"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write unary +")

    -- Write unary -
    ast = {STMTxLIST, {WRITExSTMT,
      {{UNxOP, "-"}, {NUMLITxVAL, "5"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"-5"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write unary -")

    -- Write not #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{UNxOP, "not"}, {NUMLITxVAL, "5"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write not #1")

    -- Write not #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{UNxOP, "not"}, {NUMLITxVAL, "0"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write not #2")

    -- Write not not
    ast = {STMTxLIST, {WRITExSTMT,
      {{UNxOP, "not"},{{UNxOP, "not"}, {NUMLITxVAL, "0"}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write not not")

    -- Write binary +
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "+"}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"7"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write binary +")

    -- Write binary -
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "-"}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"3"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write binary -")

    -- Write *
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "*"}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"10"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write *")

    -- Write /
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "/"}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"2"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write /")

    -- Write / (div by zero)
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "/"}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "0"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write / (div by zero)")

    -- Write %
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "%"}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write %")

    -- Write % (div by zero)
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "%"}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "0"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write % (div by zero)")

    -- Write == #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "=="}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write == #1")

    -- Write == #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "=="}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "5"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write == #2")

    -- Write != #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "!="}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write != #1")

    -- Write != #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "!="}, {NUMLITxVAL, "5"}, {NUMLITxVAL, "5"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write != #2")

    -- Write < #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "<"}, {NUMLITxVAL, "1"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write < #1")

    -- Write < #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "<"}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write < #2")

    -- Write < #3
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "<"}, {NUMLITxVAL, "3"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write < #3")

    -- Write <= #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "<="}, {NUMLITxVAL, "1"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write <= #1")

    -- Write <= #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "<="}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write <= #2")

    -- Write <= #3
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "<="}, {NUMLITxVAL, "3"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write <= #3")

    -- Write > #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, ">"}, {NUMLITxVAL, "1"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write > #1")

    -- Write > #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, ">"}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write > #2")

    -- Write > #3
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, ">"}, {NUMLITxVAL, "3"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write > #3")

    -- Write >= #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, ">="}, {NUMLITxVAL, "1"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write >= #1")

    -- Write >= #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, ">="}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write >= #2")

    -- Write >= #3
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, ">="}, {NUMLITxVAL, "3"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write >= #3")

    -- Write and #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "and"}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write and #1")

    -- Write and #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "and"}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "0"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write and #2")

    -- Write and #3
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "and"}, {NUMLITxVAL, "0"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write and #3")

    -- Write and #4
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "and"}, {NUMLITxVAL, "0"}, {NUMLITxVAL, "0"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write and #4")

    -- Write or #1
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "or"}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write or #1")

    -- Write or #2
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "or"}, {NUMLITxVAL, "2"}, {NUMLITxVAL, "0"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write or #2")

    -- Write or #3
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "or"}, {NUMLITxVAL, "0"}, {NUMLITxVAL, "2"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"1"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write or #3")

    -- Write or #4
    ast = {STMTxLIST, {WRITExSTMT,
      {{BINxOP, "or"}, {NUMLITxVAL, "0"}, {NUMLITxVAL, "0"}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Write or #4")

    -- Longer expression
    ast =
      {STMTxLIST,
        {WRITExSTMT,
          {{UNxOP, "-"},
            {{BINxOP, "-"},
              {{BINxOP, "=="}, {SIMPLExVAR, "x"}, {NUMLITxVAL, "3"}},
              {{BINxOP, "*"},
                {{BINxOP, "+"},
                  {NUMLITxVAL, "8"},
                  {BOOLLITxVAL, "true"}},
                {{UNxOP, "+"}, {SIMPLExVAR, "y"}}
              }
            }
          }
        }
      }
    input = {}
    statein = {v={["x"]=3, ["y"]=5}, a={}, f={}}
    expoutput = {"44"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Longer expression")
end


function test_intconv(t)
    io.write("Test Suite: integer conversion\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- Numeric literal #1
    ast =
      {STMTxLIST,
        {ASSNxSTMT, {SIMPLExVAR, "n"}, {NUMLITxVAL, "5.4"}}
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["n"]=5}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Integer conversion - numeric literal #1")

    -- Numeric literal #2
    ast =
      {STMTxLIST,
        {ASSNxSTMT, {SIMPLExVAR, "n"}, {NUMLITxVAL, "-7.4"}}
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["n"]=-7}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Integer conversion - numeric literal #2")

    -- Numeric literal #3
    ast =
      {STMTxLIST,
        {ASSNxSTMT, {SIMPLExVAR, "n"}, {NUMLITxVAL, "5.74e1"}}
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["n"]=57}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Integer conversion - numeric literal #3")

    -- Input
    ast =
      {STMTxLIST,
        {ASSNxSTMT, {SIMPLExVAR, "n"}, {READNUMxCALL}}
      }
    input = {"2.9"}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["n"]=2}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Integer conversion - input")

    -- Division + multiplication #1
    ast =
      {STMTxLIST,
        {WRITExSTMT,
          {{BINxOP, "*"},
            {{BINxOP, "/"}, {NUMLITxVAL, "10"}, {NUMLITxVAL, "3"}},
            {NUMLITxVAL, "3"}
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"9"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Integer conversion - division + multiplication #1")

    -- Division + multiplication #2
    ast =
      {STMTxLIST,
        {WRITExSTMT,
          {{BINxOP, "*"},
            {{BINxOP, "/"}, {NUMLITxVAL, "-3"}, {NUMLITxVAL, "2"}},
            {NUMLITxVAL, "2"}
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"-2"}
    expstateout = deepcopy(statein)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Integer conversion - division + multiplication #2")
end


function test_if(t)
    io.write("Test Suite: if-statements\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- If #1
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "4"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"a"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If #1")

    -- If #2
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If #2")

    -- If-else #1
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "5"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"a"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-else #1")

    -- If-else #2
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"b"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-else #2")

    -- If-elseif #1
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "6"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "7"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"a"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif #1")

    -- If-elseif #2
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "7"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"b"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif #2")

    -- If-elseif #3
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif #3")

    -- If-elseif-else #1
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "6"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "7"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"a"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif-else #1")

    -- If-elseif-else #2
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "7"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"b"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif-else #2")

    -- If-elseif-else #3
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"c"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif-else #3")

    -- If-elseif*-else #1
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "8"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}},
      {NUMLITxVAL, "9"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"d"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"e"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"f"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"a"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif*-else #1")

    -- If-elseif*-else #2
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}},
      {NUMLITxVAL, "9"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"d"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"e"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"f"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"d"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif*-else #2")

    -- If-elseif*-else #3
    ast = {STMTxLIST, {IFxSTMT,
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"d"'}}},
      {NUMLITxVAL, "0"},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"e"'}}},
      {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"f"'}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"f"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "If-elseif*-else #3")

    -- Nested if-else #1
    ast =
      {STMTxLIST,
        {IFxSTMT,
          {NUMLITxVAL, "1"},
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "1"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}
            }
          },
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "1"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"d"'}}}
            }
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"a"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Nested if-else #1")

    -- Nested if-else #2
    ast =
      {STMTxLIST,
        {IFxSTMT,
          {NUMLITxVAL, "1"},
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "0"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}
            }
          },
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "0"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"d"'}}}
            }
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"b"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Nested if-else #2")

    -- Nested if-else #3
    ast =
      {STMTxLIST,
        {IFxSTMT,
          {NUMLITxVAL, "0"},
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "1"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}
            }
          },
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "1"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"d"'}}}
            }
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"c"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Nested if-else #3")

    -- Nested if-else #4
    ast =
      {STMTxLIST,
        {IFxSTMT,
          {NUMLITxVAL, "0"},
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "0"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"a"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"b"'}}}
            }
          },
          {STMTxLIST,
            {IFxSTMT,
              {NUMLITxVAL, "0"},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"c"'}}},
              {STMTxLIST, {WRITExSTMT, {STRLITxOUT, '"d"'}}}
            }
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"d"}
    expstateout = deepcopy(emptystate)
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Nested if-else #4")
end


function test_for(t)
    io.write("Test Suite: for-loops\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- For-loop - counted
    ast =
      {STMTxLIST,
        {FORxLOOP,
          {ASSNxSTMT, {SIMPLExVAR, "i"}, {NUMLITxVAL, "0"}},
          {{BINxOP, "<"}, {SIMPLExVAR, "i"}, {NUMLITxVAL, "7"}},
            {ASSNxSTMT,
              {SIMPLExVAR, "i"},
              {{BINxOP, "+"}, {SIMPLExVAR, "i"}, {NUMLITxVAL, "1"}}
            },
          {STMTxLIST,
            {WRITExSTMT,
              {{BINxOP, "*"}, {SIMPLExVAR, "i"}, {SIMPLExVAR, "i"}}
            }
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0", "1", "4", "9", "16", "25", "36"}
    expstateout = {v={["i"]=7},a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "For-loop - counted")

    -- For-loop - read with sentinel
    ast =
      {STMTxLIST,
        {FORxLOOP,
          {ASSNxSTMT, {SIMPLExVAR, "notdone"}, {NUMLITxVAL, "1"}},
          {SIMPLExVAR, "notdone"},
          {},
          {STMTxLIST,
            {ASSNxSTMT, {SIMPLExVAR, "n"}, {READNUMxCALL}},
            {IFxSTMT,
              {{BINxOP, "=="}, {SIMPLExVAR, "n"}, {NUMLITxVAL, "99"}},
              {STMTxLIST,
                {ASSNxSTMT, {SIMPLExVAR, "notdone"}, {NUMLITxVAL, "0"}}
              },
              {STMTxLIST,
                {WRITExSTMT, {SIMPLExVAR, "n"}, {CRxOUT}}
              }
            }
          }
        },
        {WRITExSTMT, {STRLITxOUT, '"Bye!"'}, {CRxOUT}}
      }
    input = {"1", "8", "-17", "13.5", "99"}
    statein = deepcopy(emptystate)
    expoutput = {"1", "\n", "8", "\n", "-17", "\n", "13", "\n",
      "Bye!", "\n"}
    expstateout = {v={["notdone"]=0, ["n"]=99}, a={}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "For-loop - read with sentinel")
end


function test_return(t)
    io.write("Test Suite: returning a value\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- Writing a return value
    ast =
      {STMTxLIST,
        {FUNCxDEF, "sq",
          {STMTxLIST,
            {RETURNxSTMT,
              {{BINxOP, "*"}, {SIMPLExVAR, "a"}, {SIMPLExVAR, "a"}}
            }
          }
        },
        {ASSNxSTMT,
          {SIMPLExVAR, "a"},
          {NUMLITxVAL, "7"}
        },
        {WRITExSTMT,
          {FUNCxCALL, "sq"},
          {CRxOUT}
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"49","\n"}
    expstateout = {v={["a"]=7,["return"]=49}, a={}, f={["sq"]=
      {STMTxLIST, {RETURNxSTMT, {{BINxOP, "*"}, {SIMPLExVAR, "a"},
      {SIMPLExVAR, "a"}}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Writing a return value")

    -- Assigning a return value
    ast =
      {STMTxLIST,
        {FUNCxDEF, "sq",
          {STMTxLIST,
            {RETURNxSTMT,
              {{BINxOP, "*"}, {SIMPLExVAR, "a"}, {SIMPLExVAR, "a"}}
            }
          }
        },
        {ASSNxSTMT,
          {SIMPLExVAR, "a"},
          {NUMLITxVAL, "7"}
        },
        {ASSNxSTMT,
          {SIMPLExVAR, "c"},
          {FUNCxCALL, "sq"}
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["a"]=7,["c"]=49,["return"]=49}, a={}, f={["sq"]=
      {STMTxLIST, {RETURNxSTMT, {{BINxOP, "*"}, {SIMPLExVAR, "a"},
      {SIMPLExVAR, "a"}}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Assigning a return value")

    -- Returning a return value
    ast =
      {STMTxLIST,
        {FUNCxDEF, "p",
          {STMTxLIST,
            {RETURNxSTMT,
              {{BINxOP, "+"}, {SIMPLExVAR, "a"}, {NUMLITxVAL, "2"}}
            }
          }
        },
        {FUNCxDEF, "sq2",
          {STMTxLIST,
            {RETURNxSTMT,
              {{BINxOP, "*"}, {FUNCxCALL, "p"}, {FUNCxCALL, "p"}}
            }
          }
        },
        {ASSNxSTMT,
          {SIMPLExVAR, "a"},
          {NUMLITxVAL, "7"}
        },
        {ASSNxSTMT,
          {SIMPLExVAR, "c"},
          {FUNCxCALL, "sq2"}
        }
          }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["a"]=7,["c"]=81,["return"]=81}, a={}, f={["p"]=
      {STMTxLIST, {RETURNxSTMT, {{BINxOP, "+"}, {SIMPLExVAR, "a"},
      {NUMLITxVAL, "2"}}}},["sq2"]={STMTxLIST, {RETURNxSTMT,
      {{BINxOP, "*"}, {FUNCxCALL, "p"}, {FUNCxCALL, "p"}}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Returning a return value")

    -- Returning a value that is not used
    ast =
      {STMTxLIST,
        {FUNCxDEF, "sq",
          {STMTxLIST,
            {RETURNxSTMT,
              {{BINxOP, "*"}, {SIMPLExVAR, "a"}, {SIMPLExVAR, "a"}}
            }
          }
        },
        {ASSNxSTMT,
          {SIMPLExVAR, "a"},
          {NUMLITxVAL, "7"}
        },
        {FUNCxCALL, "sq"},
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["a"]=7,["return"]=49}, a={}, f={["sq"]=
      {STMTxLIST, {RETURNxSTMT, {{BINxOP, "*"}, {SIMPLExVAR, "a"},
      {SIMPLExVAR, "a"}}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Returning a value that is not used")

    -- Using a return value when nothing is returned
    ast =
      {STMTxLIST,
        {FUNCxDEF, "f",
          {STMTxLIST,
            {ASSNxSTMT,
              {SIMPLExVAR, "b"},
              {{BINxOP, "*"}, {SIMPLExVAR, "a"}, {SIMPLExVAR, "a"}}
            }
          }
        },
        {ASSNxSTMT,
          {SIMPLExVAR, "a"},
          {NUMLITxVAL, "7"}
        },
        {WRITExSTMT,
          {FUNCxCALL, "f"},
          {CRxOUT}
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"0","\n"}
    expstateout = {v={["a"]=7,["b"]=49}, a={}, f={["f"]=
      {STMTxLIST, {ASSNxSTMT, {SIMPLExVAR, "b"}, {{BINxOP, "*"},
      {SIMPLExVAR, "a"}, {SIMPLExVAR, "a"}}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Using a return value when nothing is returned")

    -- Using a previous return value
    ast =
      {STMTxLIST,
        {FUNCxDEF, "f",
          {STMTxLIST,
            {RETURNxSTMT,
              {NUMLITxVAL, "8"}
            }
          }
        },
        {FUNCxDEF, "g",
          {STMTxLIST,
            {WRITExSTMT,
              {STRLITxOUT, '"x"'}
            }
          }
        },
        {FUNCxCALL, "f"},
        {ASSNxSTMT,
          {SIMPLExVAR, "a"},
          {FUNCxCALL, "g"}
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"x"}
    expstateout = {v={["a"]=8,["return"]=8}, a={}, f={["f"]={STMTxLIST,
      {RETURNxSTMT, {NUMLITxVAL, "8"}}}, ["g"]={STMTxLIST, {WRITExSTMT,
      {STRLITxOUT, '"x"'}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Using a previous return value")
end


function test_fancy(t)
    io.write("Test Suite: fancy programs\n")

    local ast, statein, expoutput, expstateout
    local emptystate = {v={}, a={}, f={}}

    -- Recursion
    ast =
      {STMTxLIST,
        {FUNCxDEF, "x",
          {STMTxLIST,
            {WRITExSTMT, {SIMPLExVAR, "c"}},
            {ASSNxSTMT,
              {SIMPLExVAR, "c"},
              {{BINxOP, "-"}, {SIMPLExVAR, "c"}, {NUMLITxVAL, "1"}}
            },
            {IFxSTMT,
              {{BINxOP, ">"}, {SIMPLExVAR, "c"}, {NUMLITxVAL, "0"}},
              {STMTxLIST, {FUNCxCALL, "x"}}
            }
          }
        },
        {ASSNxSTMT, {SIMPLExVAR, "c"}, {NUMLITxVAL, "3"}},
        {FUNCxCALL, "x"}
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"3", "2", "1"}
    expstateout = {v={["c"]=0}, a={}, f={["x"]=
      {STMTxLIST, {WRITExSTMT, {SIMPLExVAR, "c"}},
      {ASSNxSTMT, {SIMPLExVAR, "c"},
      {{BINxOP, "-"}, {SIMPLExVAR, "c"}, {NUMLITxVAL, "1"}}},
      {IFxSTMT, {{BINxOP, ">"}, {SIMPLExVAR, "c"}, {NUMLITxVAL, "0"}},
      {STMTxLIST, {FUNCxCALL, "x"}}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Recursion")

    -- Using complex expression as array index
    ast =
      {STMTxLIST,
        {FORxLOOP,
          {ASSNxSTMT,
            {SIMPLExVAR, "i"},
            {NUMLITxVAL, "0"}
          },
          {{BINxOP, "<"},
            {SIMPLExVAR, "i"},
            {NUMLITxVAL, "100"}
          },
          {ASSNxSTMT,
            {SIMPLExVAR, "i"},
            {{BINxOP, "+"},
              {SIMPLExVAR, "i"},
              {NUMLITxVAL, "1"}
            }
          },
          {STMTxLIST,
            {ASSNxSTMT,
              {ARRAYxVAR,
                "a",
                {{BINxOP, "=="},
                  {{BINxOP, "%"},
                    {SIMPLExVAR, "i"},
                    {NUMLITxVAL, "3"}
                  },
                  {NUMLITxVAL, "0"}
                }
              },
              {{BINxOP, "+"},
                {ARRAYxVAR,
                  "a",
                  {{BINxOP, "=="},
                    {{BINxOP, "%"},
                      {SIMPLExVAR, "i"},
                      {NUMLITxVAL, "3"}
                    },
                    {NUMLITxVAL, "0"}
                  }
                },
                {NUMLITxVAL, "1"}
              }
            },
          }
        }
      }
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {}
    expstateout = {v={["i"]=100}, a={["a"]={[0]=66,[1]=34}}, f={}}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Using complex expression as array index")

    -- Fibonacci example
    ast =
      {STMTxLIST,{FUNCxDEF,"fibo",{STMTxLIST,{ASSNxSTMT,
        {SIMPLExVAR,"currfib"},{NUMLITxVAL,"0"}},{ASSNxSTMT,
        {SIMPLExVAR,"nextfib"},{NUMLITxVAL,"1"}},{FORxLOOP,{ASSNxSTMT,
        {SIMPLExVAR,"i"},{NUMLITxVAL,"0"}},{{BINxOP,"<"},
        {SIMPLExVAR,"i"},{SIMPLExVAR,"n"}},{ASSNxSTMT,{SIMPLExVAR,"i"},
        {{BINxOP,"+"},{SIMPLExVAR,"i"},{NUMLITxVAL,"1"}}},{STMTxLIST,
        {ASSNxSTMT,{SIMPLExVAR,"tmp"},{{BINxOP,"+"},
        {SIMPLExVAR,"currfib"},{SIMPLExVAR,"nextfib"}}},{ASSNxSTMT,
        {SIMPLExVAR,"currfib"},{SIMPLExVAR,"nextfib"}},{ASSNxSTMT,
        {SIMPLExVAR,"nextfib"},{SIMPLExVAR,"tmp"}}}},{RETURNxSTMT,
        {SIMPLExVAR,"currfib"}}}},{ASSNxSTMT,
        {SIMPLExVAR,"how_many_to_print"},{NUMLITxVAL,"20"}},{WRITExSTMT,
        {STRLITxOUT,'"Fibonacci Numbers"'},{CRxOUT}},{FORxLOOP,
        {ASSNxSTMT,{SIMPLExVAR,"j"},{NUMLITxVAL,"0"}},{{BINxOP,"<"},
        {SIMPLExVAR,"j"},{SIMPLExVAR,"how_many_to_print"}},{ASSNxSTMT,
        {SIMPLExVAR,"j"},{{BINxOP,"+"},{SIMPLExVAR,"j"},
        {NUMLITxVAL,"1"}}},{STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"n"},
        {SIMPLExVAR,"j"}},{ASSNxSTMT,{SIMPLExVAR,"ff"},
        {FUNCxCALL,"fibo"}},{WRITExSTMT,{STRLITxOUT,'"F("'},
        {SIMPLExVAR,"j"},{STRLITxOUT,'") = "'},{SIMPLExVAR,"ff"},
        {CRxOUT}}}}}
    input = {}
    statein = deepcopy(emptystate)
    expoutput = {"Fibonacci Numbers", "\n",
                 "F(", "0", ") = ", "0", "\n",
                 "F(", "1", ") = ", "1", "\n",
                 "F(", "2", ") = ", "1", "\n",
                 "F(", "3", ") = ", "2", "\n",
                 "F(", "4", ") = ", "3", "\n",
                 "F(", "5", ") = ", "5", "\n",
                 "F(", "6", ") = ", "8", "\n",
                 "F(", "7", ") = ", "13", "\n",
                 "F(", "8", ") = ", "21", "\n",
                 "F(", "9", ") = ", "34", "\n",
                 "F(", "10", ") = ", "55", "\n",
                 "F(", "11", ") = ", "89", "\n",
                 "F(", "12", ") = ", "144", "\n",
                 "F(", "13", ") = ", "233", "\n",
                 "F(", "14", ") = ", "377", "\n",
                 "F(", "15", ") = ", "610", "\n",
                 "F(", "16", ") = ", "987", "\n",
                 "F(", "17", ") = ", "1597", "\n",
                 "F(", "18", ") = ", "2584", "\n",
                 "F(", "19", ") = ", "4181", "\n"}
    expstateout = {["v"]={["return"]=4181,["j"]=20,["i"]=19,
      ["tmp"]=6765,["nextfib"]=6765,["n"]=19,["currfib"]=4181,
      ["how_many_to_print"]=20,["ff"]=4181},["a"]={},["f"]={["fibo"]=
        {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"currfib"},{NUMLITxVAL,"0"}},
          {ASSNxSTMT,{SIMPLExVAR,"nextfib"},{NUMLITxVAL,"1"}},{FORxLOOP,
          {ASSNxSTMT,{SIMPLExVAR,"i"},{NUMLITxVAL,"0"}},{{BINxOP,"<"},
          {SIMPLExVAR,"i"},{SIMPLExVAR,"n"}},{ASSNxSTMT,
          {SIMPLExVAR,"i"},{{BINxOP,"+"},{SIMPLExVAR,"i"},
          {NUMLITxVAL,"1"}}},{STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"tmp"},
          {{BINxOP,"+"},{SIMPLExVAR,"currfib"},{SIMPLExVAR,"nextfib"}}},
          {ASSNxSTMT,{SIMPLExVAR,"currfib"},{SIMPLExVAR,"nextfib"}},
          {ASSNxSTMT,{SIMPLExVAR,"nextfib"},{SIMPLExVAR,"tmp"}}}},
          {RETURNxSTMT,{SIMPLExVAR,"currfib"}}}
    }}
    checkInterp(t, ast, input, statein, expoutput, expstateout,
      "Fibonacci example")
end


function test_interpit(t)
    io.write("TEST SUITES FOR MODULE interpit\n")
    test_pre_written(t)
    test_simple(t)
    test_state(t)
    test_special_chars(t)
    test_expr(t)
    test_intconv(t)
    test_if(t)
    test_for(t)
    test_return(t)
    test_fancy(t)
end


-- *********************************************************************
-- Main Program
-- *********************************************************************


test_interpit(tester)
io.write("\n")
endMessage(tester:allPassed())

-- Terminate program, signaling no error
terminate(0)

