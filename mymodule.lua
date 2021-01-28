-- mymodule.lua
-- Glenn G. Chappell
-- 2021-01-27
--
-- For CS F331 / CSCE A331 Spring 2021
-- Code from 1/27 - Example Lua Module
-- Not a complete program


-- To use this module, do
--     mymodule = require "mymodule"
-- in some Lua program.
-- Then you can call, for example, function "mymodule.print_with_stars".


local mymodule = {}  -- Module table


-- square
-- Given a number, return its square.
-- NOT EXPORTED
local function square(n)
    return n*n
end


-- square_plus_one
-- Given a number, return its square plus one.
-- EXPORTED
function mymodule.square_plus_one(n)
    return square(n) + 1
end


-- print_with_border
-- Given message and border character, prints message using the char as
-- the border.
-- NOT EXPORTED
local function print_with_border(msg, border)
    local n = msg:len()  -- length of string msg

    local function line()
        for i = 1, n+4 do
            io.write(border)
        end
        io.write("\n")
    end

    line()
    io.write(border .. " " .. msg .. " " .. border .. "\n")
    line()
end


-- print_with_stars
-- Given message and border character, prints message surrounded by
-- stars.
-- EXPORTED
function mymodule.print_with_stars(msg)
    print_with_border(msg, "*")
end


return mymodule      -- Return the module, so client code can use it

