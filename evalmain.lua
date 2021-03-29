#!/usr/bin/env lua
-- evalmain.lua
-- Glenn G. Chappell
-- 2021-03-29
--
-- For CS F331 / CSCE A331 Spring 2021
-- REPL for evaluator.lua
-- Requires lexer.lua, rdparser4.lua, evaluator.lua


rdparser4 = require "rdparser4"
evaluator = require "evaluator"


-- ***** Helper Functions *****


-- printHelp
-- Print help for REPL.
local function printHelp()
    io.write("Type an arithmetic expression to evaluate it.\n")
    io.write("Some named variables have values (e.g., pi).\n")
    io.write("Note that \"1+2\" is illegal; type \"1 + 2\" instead.\n")
    io.write("To exit, type \"exit\".\n")
end


-- errMsg
-- Given an error message, prints it in flagged-error form, with a
-- newline appended.
local function errMsg(msg)
    assert(type(msg) == "string")

    io.write("*** ERROR - "..msg.."\n")
end


-- elimSpace
-- Given a string, remove all leading & trailing whitespace, and return
-- result. If given nil, returns nil.
local function elimSpace(s)
    if s == nil then
        return nil
    end

    local ss = s:gsub("^%s+", "")
    ss = ss:gsub("%s+$", "")
    return ss
end


-- ***** Primary Funtion *****


-- repl
-- Our REPL. Prompt & get a line. If it is "exit", them exit. Otherwise,
-- try to treat it as an arithmetic expression, parsing and evaluating
-- it. If this succeeds, then print the result. If it fails, print an
-- error message, UNLESS it looks like an incomplete expression. In that
-- case, keep inputting, and continue to attempt to evaluate. REPEAT.
function repl()
    local line, good, done, ast, result
    local source = ""

    printHelp()
    while true do
        -- Print newline if not continuing existing expression
        if source == "" then
            io.write("\n")
        end


        -- Input a line until nonblank line read
        repeat
            if source == "" then
                io.write(">> ")
            else
                io.write(".. ")
            end
            io.flush()  -- Ensure previous output is done before input
            line = io.read("*l")  -- Read a line
            line = elimSpace(line)
        until line ~= ""

        -- Check for time-to-exit
        if line == nil                        -- Read error (EOF?)
           or line:sub(1,2) == "ex" then      -- Exit command
            io.write("\n")
            break
        end

        -- Do parse
        source = source .. line
        good, done, ast = rdparser4.parse(source)

        -- Handle results of parse
        if good then
            if done then
                -- good, done: CORRECT PARSE; EVALUATE
                result = evaluator.eval(ast)
                io.write(result,"\n")
                source = ""
            else
                -- good, not done: EXTRA CHARS @ END
                errMsg("Syntax error (extra characters at end)")
                source = ""
            end
        else
            if done then
                -- not good, done: INCOMPLETE
                source = source .. "\n"
            else
                -- not good, not done: SYNTAX ERROR
                errMsg("Syntax error")
                source = ""
            end
        end
    end
end


-- ***** Main Program *****


repl()  -- Run our REPL

