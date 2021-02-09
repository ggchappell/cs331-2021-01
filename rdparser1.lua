-- rdparser1.lua
-- Glenn G. Chappell
-- 2021-02-08
--
-- For CS F331 / CSCE A331 Spring 2021
-- Recursive-Descent Parser #1: Simple
-- Requires lexer.lua


-- Grammar
-- Start symbol: item
--
--     item   ->  "(" item ")"
--             |  thing
--     thing  ->  ID
--             |  "%"

local lexer = require "lexer"


-- *********************************************************************
-- Module Table Initialization
-- *********************************************************************


local rdparser1 = {}  -- Our module


-- *********************************************************************
-- Variables
-- *********************************************************************


-- For lexer iteration
local iter          -- Iterator returned by lexer.lex
local state         -- State for above iterator (maybe not used)
local lexer_out_s   -- Return value #1 from above iterator
local lexer_out_c   -- Return value #2 from above iterator

-- For current lexeme
local lexstr = ""   -- String form of current lexeme
local lexcat = 0    -- Category of current lexeme:
                    --  one of categories below, or 0 for past the end


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
    iter, state, lexer_out_s = lexer.lex(prog)
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


local parse_item
local parse_thing


-- *********************************************************************
-- The Parser: Function "parse" - EXPORTED
-- *********************************************************************


-- parse
-- Given program, initialize parser and call parsing function for start
-- symbol. Returns boolean indicating successful parse or not.
function rdparser1.parse(prog)
    -- Initialization
    init(prog)

    -- Get results from parsing
    local good = parse_item()  -- Parse start symbol

    -- And return them
    return good
end


-- *********************************************************************
-- Parsing Functions
-- *********************************************************************


-- Each of the following is a parsing function for a nonterminal in the
-- grammar. Each function parses the nonterminal in its name. A return
-- value of true means a correct parse, and the current lexeme is just
-- past the end of the string the nonterminal expanded into. A return
-- value of false means an incorrect parse; in this case no guarantees
-- are made about the current lexeme.

-- NOTE. Declare parsing functions "local" above, but not below. This
-- allows them to be called before their definitions.


-- parse_item
-- Parsing function for nonterminal "item".
-- Function init must be called before this function is called.
function parse_item()
    if matchString("(") then
        if not parse_item() then
            return false
        end
        if not matchString(")") then
            return false
        end
        -- We would construct an AST here
        return true
    elseif parse_thing() then
        -- We would construct an AST here
        return true
    else
        return false
    end
end


-- parse_thing
-- Parsing function for nonterminal "thing".
-- Function init must be called before this function is called.
function parse_thing()
    if matchCat(lexer.ID) then
        -- We would construct an AST here
        return true
    elseif matchString("%") then
        -- We would construct an AST here
        return true
    else
        return false
    end
end


-- *********************************************************************
-- Module Table Return
-- *********************************************************************


return rdparser1

