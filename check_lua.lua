#!/usr/bin/env lua
-- check_lua.lua
-- Glenn G. Chappell
-- 2021-01-21
--
-- For CS F331 / CSCE A331 Spring 2021
-- A Lua Program to Run
-- Used in Assignment 1, Exercise 1


-- A mysterious table
tt = {[===[Vkj]===],"Odlqg",[2*3]='Qvxqj'..[==[uhhm]==],[2+2]='cuj',
      [2+[[3]]]=[=[Ut]=]..'zm'..[=[epptp]=],[3]=[[Yrwlw]]}


-- And a mysterious function
function ff(z)
    local k,x,r=74,38,35
    k = k-r - x x = x - r-k r=[===[]===]
    for y = 1,z :len() do
        r = r..string.char(string.byte(z,y)-(x%9))
        k, x = x, k+x
    end
    return r
end


-- Formatted output using the function and the table entries
io.write("Here is the secret message:\n\n")
io.write(string.format([[%s %]]..[==[s %s %s %]==]..'s %s\n',
         ff(tt[1]),ff(tt[2]),ff(tt[3]),ff(tt[4]),ff(tt[5]),ff(tt[6])))

-- Wait for user
io.write("\nPress ENTER to quit ")
io.read("*l")

