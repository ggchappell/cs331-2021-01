#!/usr/bin/env lua
-- useparseit.lua
-- Glenn G. Chappell
-- 2021-02-17
--
-- For CS F331 / CSCE A331 Spring 2021
-- Simple Main Program for parseit Module
-- Requires parseit.lua

parseit = require "parseit"


-- String forms of symbolic constants
-- Used by printAST_parseit
symbolNames = {
  [1]="STMT_LIST",
  [2]="WRITE_STMT",
  [3]="RETURN_STMT",
  [4]="ASSN_STMT",
  [5]="FUNC_CALL",
  [6]="FUNC_DEF",
  [7]="IF_STMT",
  [8]="FOR_LOOP",
  [9]="STRLIT_OUT",
  [10]="CR_OUT",
  [11]="DQ_OUT",
  [12]="CHAR_CALL",
  [13]="BIN_OP",
  [14]="UN_OP",
  [15]="NUMLIT_VAL",
  [16]="BOOLLIT_VAL",
  [17]="READNUM_CALL",
  [18]="SIMPLE_VAR",
  [19]="ARRAY_VAR",
}


-- printAST_parseit
-- Write an AST, in (roughly) Lua form, with numbers replaced by the
-- symbolic constants used in parseit, where possible.
-- See the Assignment description for the AST Specification.
function printAST_parseit(...)
    if select("#", ...) ~= 1 then
        error("printAST_parseit: must pass exactly 1 argument")
    end
    local x = select(1, ...)  -- Get argument (which may be nil)

    if type(x) == "nil" then
        io.write("nil")
    elseif type(x) == "number" then
        if symbolNames[x] then
            io.write(symbolNames[x])
        else
            io.write("<ERROR: Unknown constant: "..x..">")
        end
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
        io.write("{ ")
        local first = true  -- First iteration of loop?
        local maxk = 0
        for k, v in ipairs(x) do
            if first then
                first = false
            else
                io.write(", ")
            end
            maxk = k
            printAST_parseit(v)
        end
        for k, v in pairs(x) do
            if type(k) ~= "number"
              or k ~= math.floor(k)
              or (k < 1 and k > maxk) then
                if first then
                    first = false
                else
                    io.write(", ")
                end
                io.write("[")
                printAST_parseit(k)
                io.write("]=")
                printAST_parseit(v)
            end
        end
        io.write(" }")
    end
end


-- astEq
-- Checks equality of two ASTs, represented as in the Assignment 4
-- description. Returns true if equal, false otherwise.
function astEq(ast1, ast2)
    if type(ast1) ~= type(ast2) then
        return false
    end

    if type(ast1) ~= "table" then
        return ast1 == ast2
    end

    if #ast1 ~= #ast2 then
        return false
    end

    for k = 1, #ast1 do  -- ipairs is problematic
        if not astEq(ast1[k], ast2[k]) then
            return false
        end
    end
    return true
end


-- bool2Str
-- Given boolean, return string representing it: "true" or "false".
function bool2Str(b)
    if b then
        return "true"
    else
        return "false"
    end
end


-- check
-- Given a "program", check its syntactic correctness using parseit.
-- Print results.
function check(program)
    dashstr = "-"
    io.write(dashstr:rep(72).."\n")
    io.write("Program: "..program.."\n")

    local good, done, ast = parseit.parse(program)
    assert(type(good) == "boolean")
    assert(type(done) == "boolean")
    if good then
        assert(type(ast) == "table")
    end

    if good and done then
        io.write("Good! - AST: ")
        printAST_parseit(ast)
        io.write("\n")
    elseif good and not done then
        io.write("Bad - extra characters at end\n")
    elseif not good and done then
        io.write("Unfinished - more is needed\n")
    else  -- not good and not done
        io.write("Bad - syntax error\n")
    end
end


-- Main program
-- Check several "programs".
io.write("Recursive-Descent Parser: Caracal\n")
check("")
check("write();")
check("write(a);")
check("write(a); write(b); write(cr);")
check("write(a, b, cr);")
check("write(\"abc\");")
check("a=3;")
check("a=a+1;")
check("a=readnum();")
check("write(a+1);")
check("def f(){write(\"yo\")}f();")
check("a=3;write(a+b, cr);")
check("a[e*2+1]=2;")
check("\n  # Caracal Example #1\n  # Glenn G. Chappell\n"..
      "  # 2021-02-10\n  nn = 3;\n  write(nn, cr);\n")
io.write("### Above should be the AST given in the Assignment 4 "..
         "description,\n")
io.write("### under 'Introduction'\n")
check("write();elseif")
io.write("### Above should be ")
io.write("\"Bad - extra characters at end\"\n")
check("def foo() { write(cr")
io.write("### Above should be ")
io.write("\"Unfinished - more is needed\"\n")
check("if (a b c)")
io.write("### Above should be ")
io.write("\"Bad - syntax error\"\n")

