#!/usr/bin/env lua
-- uselexer.lua
-- Glenn G. Chappell
-- 2021-02-03
--
-- For CS F331 / CSCE A331 Spring 2021
-- Simple Main Program for lexer Module
-- Requires lexer.lua

lexer = require "lexer"


-- Our "program", which is sent to the lexer
-- Change this string and see what happens.
program = "_begin/ */begin3 \nbegin.*/*/* /*/a---b-a+++3+.a+.6\a-===="
        .."12.3.4;k - 4;k-4/*"
-- Above, "\a" is an alarm character. It may make a beep sound when
-- printed. It is included as an example of an illegal character.


-- Print the input ("program")
io.write("*** Lexer Input:\n")
io.write(program)
io.write("\n\n")

-- Lex away and print the output as we go
io.write("*** Lexer Output:\n")
for lexstr, cat in lexer.lex(program) do
    local catstr = lexer.catnames[cat]
    io.write(string.format("%-10s  %s\n", lexstr, catstr))
end

io.write("\n")
-- Uncomment the following to wait for the user before quitting
--io.write("Press ENTER to quit ")
--io.read("*l")

