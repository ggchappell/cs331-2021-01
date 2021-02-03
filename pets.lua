-- pets.lua
-- Glenn G. Chappell
-- 2021-01-29
--
-- For CS F331 / CSCE A331 Spring 2021
-- Code from 1/29 - Lua Pets Module
-- Not a complete program


-- To use this module, do
--     pets = require "pets"
-- in some Lua program.
-- Then you can call, for example, function "pets.Dog.new".


local pets = {}  -- Our module


-- Dog
-- Table intended to be used as a metatable. Implements the equivalent
-- of a C++ or Java class, with a constructor, a data member, and
-- methods.
-- EXPORTED

-- The value for internal-use-only key _sound is the Dog's bark sound.
-- The default value, set by the constructor is "Ruff!".

pets.Dog = {}

-- Dog.__index
-- Make Dog act like a class.
function pets.Dog.__index(tbl, key)
    return pets.Dog[key]
end

-- Dog.new
-- Make a new object of the "class" Dog, and return it.
-- Like a C++ constructor.
function pets.Dog.new(barkSound)
    if barkSound == nil then
        barkSound = "Ni!"  -- Default (we are the dogs who say, "Ni!")
    end
    local obj = {}          -- Our object
    setmetatable(obj, pets.Dog)
    obj._sound = barkSound
    return obj
end

-- Dog.bark
-- Print the Dog's bark sound, followed by a newline.
-- This function is intended to be called via the colon operator.
function pets.Dog.bark(self)
    io.write(self._sound.."\n")
end

-- Dog.setBark
-- Set the Dog's bark sound to the given string.
-- This function is intended to be called via the colon operator.
function pets.Dog.setBark(self, new_sound)
    self._sound = new_sound
end


return pets      -- Return the module, so client code can use it

