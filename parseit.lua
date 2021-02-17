-- parseit.lua  INCOMPLETE
-- Glenn G. Chappell
-- 2021-02-17
--
-- For CS F331 / CSCE A331 Spring 2021
-- Solution to Assignment 4, Exercise 1
-- Requires lexit.lua


local lexit = require "lexit"


-- *********************************************************************
-- Module Table Initialization
-- *********************************************************************


local parseit = {}  -- Our module


-- *********************************************************************
-- Variables
-- *********************************************************************


-- For lexer iteration
local iter          -- Iterator returned by lexit.lex
local state         -- State for above iterator (maybe not used)
local lexer_out_s   -- Return value #1 from above iterator
local lexer_out_c   -- Return value #2 from above iterator

-- For current lexeme
local lexstr = ""   -- String form of current lexeme
local lexcat = 0    -- Category of current lexeme:
                    --  one of categories below, or 0 for past the end


-- *********************************************************************
-- Symbolic Constants for AST
-- *********************************************************************


local STMT_LIST    = 1
local WRITE_STMT   = 2
local RETURN_STMT  = 3
local ASSN_STMT    = 4
local FUNC_CALL    = 5
local FUNC_DEF     = 6
local IF_STMT      = 7
local FOR_LOOP     = 8
local STRLIT_OUT   = 9
local CR_OUT       = 10
local DQ_OUT       = 11
local CHAR_CALL    = 12
local BIN_OP       = 13
local UN_OP        = 14
local NUMLIT_VAL   = 15
local BOOLLIT_VAL  = 16
local READNUM_CALL = 17
local SIMPLE_VAR   = 18
local ARRAY_VAR    = 19


-- *********************************************************************
-- Utility Functions
-- *********************************************************************


-- advance
-- Go to next lexeme and load it into lexstr, lexcat.
-- Should be called once before any parsing is done.
-- Function init must be called before this function is called.
local function advance()
    -- Advance the iterator
    lexer_out_s, lexer_out_c = iter(state, lexer_out_s)

    -- If we're not past the end, copy current lexeme into vars
    if lexer_out_s ~= nil then
        lexstr, lexcat = lexer_out_s, lexer_out_c
    else
        lexstr, lexcat = "", 0
    end
end


-- init
-- Initial call. Sets input for parsing functions.
local function init(prog)
    iter, state, lexer_out_s = lexit.lex(prog)
    advance()
end


-- atEnd
-- Return true if pos has reached end of input.
-- Function init must be called before this function is called.
local function atEnd()
    return lexcat == 0
end


-- matchString
-- Given string, see if current lexeme string form is equal to it. If
-- so, then advance to next lexeme & return true. If not, then do not
-- advance, return false.
-- Function init must be called before this function is called.
local function matchString(s)
    if lexstr == s then
        advance()
        return true
    else
        return false
    end
end


-- matchCat
-- Given lexeme category (integer), see if current lexeme category is
-- equal to it. If so, then advance to next lexeme & return true. If
-- not, then do not advance, return false.
-- Function init must be called before this function is called.
local function matchCat(c)
    if lexcat == c then
        advance()
        return true
    else
        return false
    end
end


-- *********************************************************************
-- "local" Statements for Parsing Functions
-- *********************************************************************


local parse_program
local parse_stmt_list
local parse_simple_stmt
local parse_complex_stmt
local parse_write_arg
local parse_expr
local parse_compare_expr
local parse_arith_expr
local parse_term
local parse_factor


-- *********************************************************************
-- The Parser: Function "parse" - EXPORTED
-- *********************************************************************


-- parse
-- Given program, initialize parser and call parsing function for start
-- symbol. Returns pair of booleans & AST. First boolean indicates
-- successful parse or not. Second boolean indicates whether the parser
-- reached the end of the input or not. AST is only valid if first
-- boolean is true.
function parseit.parse(prog)
    -- Initialization
    init(prog)

    -- Get results from parsing
    local good, ast = parse_program()  -- Parse start symbol
    local done = atEnd()

    -- And return them
    return good, done, ast
end


-- *********************************************************************
-- Parsing Functions
-- *********************************************************************


-- Each of the following is a parsing function for a nonterminal in the
-- grammar. Each function parses the nonterminal in its name and returns
-- a pair: boolean, AST. On a successul parse, the boolean is true, the
-- AST is valid, and the current lexeme is just past the end of the
-- string the nonterminal expanded into. Otherwise, the boolean is
-- false, the AST is not valid, and no guarantees are made about the
-- current lexeme. See the AST Specification near the beginning of this
-- file for the format of the returned AST.

-- NOTE. Declare parsing functions "local" above, but not below. This
-- allows them to be called before their definitions.


-- parse_program
-- Parsing function for nonterminal "program".
-- Function init must be called before this function is called.
function parse_program()
    local good, ast

    good, ast = parse_stmt_list()
    return good, ast
end


-- parse_stmt_list
-- Parsing function for nonterminal "stmt_list".
-- Function init must be called before this function is called.
function parse_stmt_list()
    local good, ast1, ast2

    ast1 = { STMT_LIST }
    while true do
        if lexstr == "write"
          or lexstr == "return"
          or lexcat == lexit.ID then
            good, ast2 = parse_simple_stmt()
            if not good then
                return false, nil
            end
            if not matchString(";") then
                return false, nil
            end
        elseif lexstr == "def"
          or lexstr == "if"
          or lexstr == "for" then
            good, ast2 = parse_complex_stmt()
            if not good then
                return false, nil
            end
        else
            break
        end

        table.insert(ast1, ast2)
    end

    return true, ast1
end


-- parse_simple_stmt
-- Parsing function for nonterminal "simple_stmt".
-- Function init must be called before this function is called.
function parse_simple_stmt()
    local good, ast1, ast2, savelex, arrayflag

    if matchString("write") then
        if not matchString("(") then
            return false, nil
        end

        if matchString(")") then
            return true, { WRITE_STMT }
        end

        good, ast1 = parse_write_arg()
        if not good then
            return false, nil
        end

        ast2 = { WRITE_STMT, ast1 }

        while matchString(",") do
            good, ast1 = parse_write_arg()
            if not good then
                return false, nil
            end

            table.insert(ast2, ast1)
        end

        if not matchString(")") then
            return false, nil
        end

        return true, ast2

    elseif matchString("return") then
        -- TODO: WRITE THIS!!!

    else
        -- TODO: WRITE THIS!!!

    end
end


-- parse_complex_stmt
-- Parsing function for nonterminal "complex_stmt".
-- Function init must be called before this function is called.
function parse_complex_stmt()
    local good, ast1, ast2, ast3, ast4, savelex

    if matchString("def") then
        -- TODO: WRITE THIS!!!

    elseif matchString("if") then
        -- TODO: WRITE THIS!!!

    elseif matchString("for") then
        if not matchString("(") then
            return false, nil
        end

        if matchString(";") then
            ast1 = {}
        else
            good, ast1 = parse_simple_stmt()
            if not good then
                return false, nil
            end

            if not matchString(";") then
                return false, nil
            end
        end

        if matchString(";") then
            ast2 = {}
        else
            good, ast2 = parse_expr()
            if not good then
                return false, nil
            end

            if not matchString(";") then
                return false, nil
            end
        end

        if matchString(")") then
            ast3 = {}
        else
            good, ast3 = parse_simple_stmt()
            if not good then
                return false, nil
            end

            if not matchString(")") then
                return false, nil
            end
        end

        if not matchString("{") then
            return false, nil
        end

        good, ast4 = parse_stmt_list()
        if not good then
            return false, nil
        end

        if not matchString("}") then
            return false, nil
        end

        return true, { FOR_LOOP, ast1, ast2, ast3, ast4 }
    end
end


-- parse_write_arg
-- Parsing function for nonterminal "write_arg".
-- Function init must be called before this function is called.
function parse_write_arg()
    local savelex, good, ast1

    savelex = lexstr
    if matchCat(lexit.STRLIT) then
        return true, { STRLIT_OUT, savelex }

        -- TODO: WRITE THIS!!!
    end
end


-- parse_expr
-- Parsing function for nonterminal "expr".
-- Function init must be called before this function is called.
function parse_expr()
    -- TODO: WRITE THIS!!!
end


-- parse_compare_expr
-- Parsing function for nonterminal "compare_expr".
-- Function init must be called before this function is called.
function parse_compare_expr()
    -- TODO: WRITE THIS!!!
end


-- parse_arith_expr
-- Parsing function for nonterminal "arith_expr".
-- Function init must be called before this function is called.
function parse_arith_expr()
    -- TODO: WRITE THIS!!!
end


-- parse_term
-- Parsing function for nonterminal "term".
-- Function init must be called before this function is called.
function parse_term()
    -- TODO: WRITE THIS!!!
end


-- parse_factor
-- Parsing function for nonterminal "factor".
-- Function init must be called before this function is called.
function parse_factor()
    -- TODO: WRITE THIS!!!
end


-- *********************************************************************
-- Module Table Return
-- *********************************************************************


return parseit

