#!/usr/bin/env lua
-- obj.lua
-- Glenn G. Chappell
-- 2021-01-29
--
-- For CS F331 / CSCE A331 Spring 2021
-- Code from 1/29 - Lua: Objects
-- Requires pets.lua


io.write("This file contains sample code from January 29, 2021,\n")
io.write("for the topic \"Lua: Objects\".\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("useful. See the source.\n")


-- ***** Metatables *****


io.write("\n*** Metatables:\n")

-- A table can have a "metatable", which is another table that is used
-- to implement special operations on the original table. Examples of
-- special operations are operator overloading and handling of
-- nonexistent keys. For each special operation, a function in the
-- metatable having a corresponding name is called. The name of the
-- function in the metatable always begins with two underscores.

tx = { ["x"]=42 }      -- A table
mtx = {}               -- Another table, to be used as a metatable

-- Create a metatable relationship using standard-library function
-- setmetatable.
setmetatable(tx, mtx)  -- Now mtx is the metatable of tx

io.write("(Not much to print here)\n")


-- ***** Class & Object *****


io.write("\n*** Class & Object:\n")
--
-- Now we use metatables to simulate the class-object relationship found
-- in programming languages like C++.

-- The table to be used as a metatable ("class")
mt = {}

-- count_to
-- Prints numbers 1 to n on a single line.
function mt.count_to(n)
    for i = 1, n do
        io.write(i .. " ")
    end
    io.write("\n")
end

-- The __index entry in a table's metatable is called when a nonexistent
-- key is accessed in the table. Here we set this function to return the
-- corresponding member of the metatable.
function mt.__index(tbl, key)
    return mt[key]
end
-- Above, parameter "tbl" is the table with the missing key. Function
-- __index must take this parameter, but we do not use it here.

-- Now, mt is like a "class". We wish to make an "object": a table whose
-- metatable is mt. Let's give mt a member "new" that creates one and
-- returns it.
function mt.new()
    local t = {}
    setmetatable(t, mt)  -- mt is now the metatable of t
    t.x = 3              -- Initialize a "data member"
    return t
end

-- Now we make our table: t
t = mt.new()

-- What happens when we call member t.count_to? There is no t.count_to,
-- so the metatable will be used.
io.write('The following should print "1 2 3 4 5 6":\n  ');
t.count_to(6)


-- ***** Colon Operator *****


io.write("\n*** Colon Operator:\n")

-- Some member functions need to know the table they are called on. Lua
-- has no notion of "the current object" (like "*this" in C++). A
-- solution is to pass the table to the member function.
--     tabl.foo(tabl, a, b)
-- However, the above is redundant. So Lua offers shorthand:
--     tabl:foo(a, b)

function t.increment_x(self)
    self.x = self.x+1
end

t:increment_x()

-- t.x was 3. We incremented it. The following should print "4":
io.write("t.x = " .. t.x .. " (should be 4)\n")

-- The colon operator is particularly useful when using a metatable. A
-- function that is a member of the metatable of table t needs to know
-- about t if it is to access a member of t.

function mt.print_x(self)
    io.write(self.x .. "\n")
end

io.write("Another way to print t.x: ")
t:print_x()

-- The following code deals with a "class" Dog defined in the module
-- pets, in the file pets.lua.

-- Import the "pets" module

pets = require "pets"

-- There is a "class" defined in pets.lua: Dog. All of Dog's methods
-- take the object as a first parameter (even if they do not need it,
-- for consistency). So we call them all via the colon operator.

-- Make a Dog
rover = pets.Dog.new()

-- I get tired of the "pets."; use something simpler
Dog = pets.Dog

-- Make another Dog and set its bark sound
fifi = Dog.new()
fifi:setBark("Yip! Yip! Yip!")

-- Make yet another Dog and set its bark sound
bruiser = Dog.new("RRRROWF!!!")

io.write("\nRover barks:\n  ")
rover:bark()
io.write("Fifi barks:\n  ")
fifi:bark()
io.write("Bruiser barks:\n  ")
bruiser:bark()


-- ***** Operator Overloading *****


io.write("\n*** Operator Overloading:\n")

-- We demonstrate Lua's operator overloading using tables that hold a
-- number in the value associated with key "n".

-- Here is our metatable, which defines the binary "+" and "*"
-- operators. The special function names are "__add" and "__mul".

opmt = {}  -- "opmt" = OPerator MetaTable

function opmt.__add(t1, t2)
    local t3 = {}
    setmetatable(t3, opmt)
    t3.n = t1.n + t2.n
    return t3
end

function opmt.__mul(t1, t2)
    local t3 = {}
    setmetatable(t3, opmt)
    t3.n = t1.n * t2.n
    return t3
end

-- Now we make two tables with the above as their metatable and use the
-- overloaded "+" and "*" operators.

-- Numbers that we will operate on:
num_a = 3
num_b = 5
num_c = 4

ta = { ["n"]=num_a }
setmetatable(ta, opmt)
tb = { ["n"]=num_b }
setmetatable(tb, opmt)
tc = { ["n"]=num_c }
setmetatable(tc, opmt)

td = ta + tb * tc  -- Use overloaded "+" and "*" operators

io.write("Using overloaded \"+\" and \"*\" operators:\n  ")
io.write(num_a.." + "..num_b.." * "..num_c.." = "..td.n.."\n")


-- ***** Closures *****


io.write("\n*** Closures:\n")

-- A closure is a function that carries with it (some portion of) the
-- environment it was defined. Closures offer a simple way to do some of
-- the things we might do with an object in traditional C++ OO style.

-- make_multiplier
-- Return a function (a closure) that multiplies by the given k.
function make_multiplier(k)
    function mult(x)
        return k*x
    end

    return mult
end

-- Now use the closure turned above.
times2 = make_multiplier(2)     -- Function that multiplies by 2
triple = make_multiplier(3)     -- Function that multiplies by 3
times100 = make_multiplier(100) -- Function that multiples by 100
io.write("17 times 2 is " .. times2(17) .. "\n")
io.write("25 tripled is " .. triple(25) .. "\n")
io.write("-7 times 100 is " .. times100(-7) .. "\n")

-- Think about how we might do the above in a traditional OO style. We
-- could create an object with a member function that multiplies a
-- parameter by some data member. We would set the data member to 2 or 3
-- in a constructor to get the functionality shown above. So the
-- existence of closures means we have less need for objects.

-- Closure version of pets.Dog

function make_dog(barkSound)
    if barkSound == nil then
        barkSound = "Ni!"  -- Default
    end

    -- The closure
    function bark()
        io.write(barkSound.."\n")
    end

    return bark
end

fido = make_dog()
fluffy = make_dog("Yap!! Yap!!")

io.write("\n")
io.write("Fibo barks:\n  ")
fido()
io.write("Fluffy barks:\n  ")
fluffy()


io.write("\n")
io.write("This file contains sample code from January 29, 2021,\n")
io.write("for the topic \"Lua: Objects\".\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("useful. See the source.\n")

io.write("\n")
-- Uncomment the following to wait for the user before quitting
--io.write("Press ENTER to quit ")
--io.read("*l")

