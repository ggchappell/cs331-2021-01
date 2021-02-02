#!/usr/bin/env lua
-- adv.lua
-- Glenn G. Chappell
-- 2021-02-01
--
-- For CS F331 / CSCE A331 Spring 2021
-- Code from 2/1 - Lua: Advanced Flow


io.write("This file contains sample code from February 1, 2021,\n")
io.write("for the topic \"Lua: Advanced Flow\".\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("useful. See the source.\n")


-- ***** Coroutines *****


io.write("\n*** Coroutines:\n")

-- Here is a coroutine: a function that can temporarily give up control
-- ("yield"), and then be resumed again.

-- small_fibos1
-- Yield Fibonacci numbers less than given limit.
function small_fibos1(limit)
    local currfib, nextfib = 0, 1
    while currfib < limit do
        coroutine.yield(currfib)  -- yield value; resumable afterwards
        currfib, nextfib = nextfib, currfib + nextfib
    end
end

-- Use the above coroutine
io.write("Small Fibonacci numbers, using a coroutine\n")

-- Get the coroutine wrapper function
cw = coroutine.wrap(small_fibos1)

f = cw(3000)  -- Attempt to get value from coroutine;
              --  argument passed to small_fibos1
while f ~= nil do  -- While coroutine has not returned
    io.write(f .. "  ")  -- Do something with our value
    f = cw()             -- Attempt to get another value from coroutine
end
io.write("\n")


-- ***** Custom Iterators *****


io.write("\n*** Custom Iterators:\n")

-- You can make your own iterators for use with the for-in control
-- structure.

-- The following code:
--
--   for u, v1, v2 in XYZ do
--       FOR_LOOP_BODY
--   end
--
-- is translated to:
--
--   local iter, state, u = XYZ
--   local v1, v2
--   while true do
--       u, v1, v2 = iter(state, u)
--       if u == nil then
--           break
--       end
--       FOR_LOOP_BODY
--   end
--
-- Above, "v1, v2" can be replaced with an arbitrary number of
-- variables, or with no variables at all.

-- Here is an example (with the same result as the above coroutine
-- example):

-- small_fibos2
-- Allows for-in iteration through Fibonacci numbers less than n.
function small_fibos2(limit)
    local currfib, nextfib = 0, 1

    function iter(dummy1, dummy2)
        if currfib >= limit then
            return nil  -- End iteration
        end
        local save_curr = currfib
        currfib, nextfib = nextfib, currfib + nextfib
        return save_curr
    end

    return iter, nil, nil
end

-- Use the above iterator
io.write("Small Fibonacci numbers, using a custom iterator\n")

for f in small_fibos2(3000) do
    io.write(f .. "  ")
end
io.write("\n")


io.write("\n")
io.write("This file contains sample code from February 1, 2021,\n")
io.write("for the topic \"Lua: Advanced Flow\".\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("useful. See the source.\n")

io.write("\n")
-- Uncomment the following to wait for the user before quitting
--io.write("Press ENTER to quit ")
--io.read("*l")

