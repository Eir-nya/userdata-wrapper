--[[

--========================--
---- [INFO] INFORMATION ----
--========================--

/====/==============================================\====\
|    |                   WD200019                   |    |
| ♥  |                   presents:                  |  ♦ |
|====|==============================================|====|
|    |                          |                   |    |
|    |                          |         |         |    |
|    | _  _  ____   __  |/¯¯ /¯¯| /¯¯\  --|-- /¯¯\  |    |
|    | |  | <___   /__\ |    |  | |  ||   |   |  || |    |
|    | \__|  ___/  \___ |    \__| \__/|   \__ \__/| |    |
|    |                                              |    |
|    |                                              |    |
|    |   |      | |/¯¯ /¯¯\  |/¯\ |/¯\  __  |/¯¯    |    |
|    |   |  |   | |    |  || || | || | /__\ |       |    |
|    |   \__/\__/ |    \__/| |\_/ |\_/ \___ |       |    |
|    |                       |    |                 |    |
|    |                       |    |                 |    |
|====|==============================================|====|
| ♣  |     For |Unitale| and |Create Your Frisk|    |  ♠ |
|    |         |v0.2.1a|     |     v0.6.2.2    |    |    |
\====\==============================================/====/

A library providing functions you can use to wrap userdata objects in Unitale and Create Your Frisk.
 ~ by WD200019 ~ 

This library is especially useful to advanced Lua users, and can be very useful in some situations.

Say you're using CYF to make a moddable Lua environment, like Create Your Kris.
How would you force code like `Player.hp = 2` to run the code that updates your 

--=========================--
---- [INTR] INTRODUCTION ----
--=========================--

Hello! This is a library I made geared towards advanced Lua and Unitale/CYF programmers.
It revolves around "wrapping" userdata objects, in the same way that you can "wrap" functions.

~~~

Before we begin: What is "wrapping"?
"Wrapping" is a technique in Lua (name not official) that involves doing this to functions:

```
local bd = BattleDialog
function BattleDialog(text)
    DEBUG(text[1])
    bd(text)
end
```

This example "wraps" the function `BattleDialog`, so that it performs its default operations while also activating
a DEBUG call.

This can be very useful in causing functions to execute custom code, and apply this custom code to every time the function
is called, from anywhere and everywhere.



NOTE: This library will also make use of something in Lua called a "vararg", or "variable arguments".
You can learn about this awesome feature here: http://lua-users.org/wiki/VarargTheSecondClassCitizen.

~~~

So, if "wrapping" functions means injecting our own code into them, what does it mean to "wrap" userdata?

Well, userdata is a Lua object type that can't be modified easily, or even at all.
It has a set list of functions and properties that are controlled on the C# side ("built-in" to the engine),
and if a user wants to modify, remove or disable them...tough luck!



As an example, let's say we want to disable `Player.Hurt`, so that calling `Player.Hurt` will do nothing.

In regular Unitale/CYF, this is what you'd have to do:

 1. Wrap the Player by replacing it with a table
 
```
local _player = Player
Player = {}
```

 2. Add the custom function/variable

```
Player.Hurt = function() end -- does nothing
```

 3. Add **EVERY SINGLE OTHER PROPERTY OF THE PLAYER OBJECT!!!**

```
Player.x = {get = function() return _player.x end}
Player.y = {get = function() return _player.y end}
Player.absx = {get = function() return _player.absx end}
Player.absy = {get = function() return _player.absy end}
Player.name = {get = function() return _player.name end,
               set = function(val) _player.name = val end}
(......)
```

 4. Do really confusing metatable shenanigans

```
setmetatable(Player, {
        __index = function(t, v)
            if Player[v] and Player[v].get then
                return Player[v].get()
            end
        end,
        __newindex = function(t, k, v)
            if Player[k] and Player[k].set then
                Player[k].set(v)
            end
        end
        -- and possibly even more events, like __eq and __call
    })
```

~~~

Hopefully, you can now see the purpose of this library.
It's to eliminate all of the frustration, confusion, and tediousness involved in wrapping a userdata object.



Let's continue our example: How would we disable Player.Hurt using this library?
It's literally just four lines:

```
wrapper = require "Libraries/userdataWrapper"
wrapper.WrapPlayer({
        Hurt = {set = function() end}
    })
```

Yeah, that's it! Just like that, the Player object has been replaced with a "fake" player created out of metatables,
and `Player.Hurt` has been made to do nothing!
With this library, a huge number of things are possible! Just think of what you can do:

 * Disable entire functions and properties, like `Player.Hurt`!
 
 * Execute code when changing certain values, like making `Player.x = 10` actually move the player!
 
 * Compress entire chunks of code into singular functions, like calling `sprite.Set("attacking")` to start an animation!
 
 * Add, change, or re-order arguments in userdata functions, like adding an argument to `sprite.Move` to move in the Z direction!
 
 * Add your own custom values and functions, using getters and setters!



 - - - - - - - - - - - - - - - - - - - - - - - - - 

        --============================--
        ---- [SECT] SECTION OUTLINE ----
        --============================--

      You can use "Find" (CTRL+F, COMMAND+F)
         to search this file for these
      section names to jump straight to them.
  
      For example: Searching for SECT (with
        square brackets around it) will
              take you back here.

 - - - - - - - - - - - - - - - - - - - - - - - - - 
 
 * (INFO) INFORMATION
   Contains some version information about the
   library, and which engine versions it is
   compatible with.
   
 * (INTR) INTRODUCTION
   Contains a brief introduction to the purpose of
   this library, and where it might be useful.
   
 * (SECT) SECTION OUTLINE
   Contains a list of every section in this
   library, a description of what it is for, and
   its four-letter "tag".
   
 * (OVER) OVERRIDE TABLES
   Contains a tutorial and examples about how
   to use "override tables", which are tables
   that let you override userdata properties
   with your own Get/Set functions.
   
 * (VARI) VARIABLES
   Contains a list of every individual variable
   that can be set when using this library
   (mainly for the file that loads this library)
   
 * (FUNC) FUNCTIONS
   Contains a list of every individual function
   that can be called when using this library
   (mainly for the file that loads this library)
   
 * (NOTE) CLOSING NOTES
   Contains a list of small tidbits you need
   to know when using this library.
   
 * (OPTI) OPTIONS
   Contains the actual, settable variables
   listed in (VARI).
   
 * (MTHO) METHODS
   Contains the actual, callable functions
   listed in (FUNC).

- - - - - - - - - - - - - - - - - - - - - - - - - 

--============================--
---- [OVER] OVERRIDE TABLES ----
--============================--

So, here is a tutorial on "override tables". These are special tables, and they will let you
do whatever it is you needed this library to do in the first place.

They basically let you "override" (hence the name) userdata properties on a wrapped userdata object.

You can override all of: normal variables (like sprite.spritename), read-only variables (like Player.maxhp),
and even functions (like Player.Hurt).

This uses a system called "getters and setters".

~~~

So, here's an example: let's say I want to wrap a bullet, to make its Move function move it backwards instead of forwards.

If I want it to apply to a SINGLE bullet, then I just need to specify it in `wrapper.WrapProjectile`:

```
bullet = CreateProjectile("bullet", 0, 0)
bullet = wrapper.WrapProjectile(bullet, { !! HERE !! })
```

Because we want to override a FUNCTION, we need to specify ONLY a "set" function:

```
bullet = CreateProjectile("bullet", 0, 0)
bullet = wrapper.WrapProjectile(bullet, {
        Move = {
            set = function(_prj, prj, x, y)
                _prj.Move(-x, -y)
            end
        }
    })
```

If the above example code were to be used in-game, then this specific bullet would always move backwards every time bullet.Move
was called.

Here is a layout of how your functions are actually called:

```
set(_REAL_OBJECT, FAKE_OBJECT, ...)
get(_REAL_OBJECT, FAKE_OBJECT)
```

You get access to both the real object (like the actual userdata projectile, for instance), and the fake object (that is, the
metatable that "replaces" the actual userdata object).



Let's make use of these two arguments together! How about making `sprite.Set` automatically start an animation when you enter a certain phrase?

```
sprite = CreateSprite("bullet")
sprite = wrapper.WrapSprite(sprite, {
        Set = {
            set = function(_spr, spr, spritename)
                if spritename == "attacking" then
                    spr.SetAnimation("attacking")
                else
                    _spr.Set(spritename)
                end
            end
        },
        SetAnimation = {
            set = function(_spr, spr, ...)
                local args = {...}
                
                if #args == 1 and args[i] == "attacking" then
                    _spr.SetAnimation({"1", "2", "3", "4", "5", "6"}, 0.4, "Character/Attacking")
                    _spr.loopMode = "ONESHOT"
                else
                    _spr.SetAnimation(...)
                end
            end
        }
    })
```

Yeah, pretty useful, isn't it? Now, by just entering
    `sprite.Set("attacking")`
the code automatically calls
    `sprite.SetAnimation({"1", "2", "3", "4", "5", "6"}, 0.4, "Character/Attacking")`
AND
    `sprite.loopMode = "ONESHOT"` !



Next example: Overriding a variable that can be both get and set.

```
wrapper.WrapPlayer({
        hp = {
            set = function(_pla, pla, newValue)
                if invincible then
                    DEBUG("You are powerless to try to change my hp.")
                elseif newValue > 0 then
                    _pla.hp = newValue
                else
                    DEBUG("Your silly scripts can't kill me!!")
                    invincible = true -- a global variable that can be used from the script itself
                    _pla.lv = 20
                    _pla.hp = 99
                end
            end,
            get = function(_pla, pla)
                if invincible then
                    return math.huge -- +infinity in Lua
                else
                    return _pla.hp
                end
            end
        }
    })
```

In the above example, if any scripts try to set the player's hp to any value less than 1, a message will be displayed
and the player's hp will get instantly set to 99. After this, the player's hp can no longer be set, and trying to check
their hp value returns +infinity.

~~~

So, yes, as you can see, you can use this on all userdata values, and you can use both getters and setters.
Now, on to the next step! Applying your changes to every userdata of a type!



!! Note: If you only include a get function, then the variable will become read-only. !!



So, I have a custom replacement for `bullet.Move` that I want to apply to EVERY bullet. How do I do it?

```
bullet = wrapper.WrapProjectile(bullet, {
        Move = {
            set = function(_prj, prj, x, y)
                _prj.Move(-x, -y)
            end
        }
    })
```

Well, one way would be to wrap CreateProjectile...

```
local _cp = CreateProjectile
function CreateProjectile(...)
    local realBullet = _cp(...)
    return wrapper.WrapProjectile(bullet, {
            Move = {
                set = function(_prj, prj, x, y)
                    _prj.Move(-x, -y)
                end
            }
        })
end
```

But this is tedious, it takes up extra room, and there's got to be a better way, right?



Well, this library has the ability to wrap the default userdata-creating functions for you!

Here's an easier way to do what I did above:

```
wrapper.projectileValues = {
    Move = {
        set = function(_prj, prj, x, y)
            _prj.Move(-x, -y)
        end
    }
}

wrapper.WrapCreateProjectile()
wrapper.WrapCreateProjectileAbs()
```

There! Not only was it cleaner and easier to do, but it also applied the changes to CreateProjectileAbs!

So: This is something you can do for ALL "multi-instance" userdata objects. The prime examples of what I'm talking about
are projectiles and sprites. Basically, anything that you can create a potentially infinite amount of.





Now, for the full list of variables and functions for this library:

--======================--
---- [VARI] VARIABLES ----
--======================--

* wrapper.autoWrapSprite:
  
  = boolean = true
  - Set this to true to automatically wrap `projectile.sprite` for wrapped projectiles, and `Player.sprite` for the wrapped Player.
  - If this is true, then the values in `wrapper.spriteValues` will be applied to the sprite components of wrapped projectiles and the player.

* wrapper.autoUnwrapUserdata:
  
  = boolean = true
  - Set this to true, and the default functions that take userdata values as arguments will be changed to
    automatically unwrap any table values you enter into them.
    
  - As an example: `sprite.SetParent` takes a sprite object as its only argument. With `autoUnwrapUserdata` as true,
    all you have to do is pass a wrapped userdata OR a regular userdata. With this variable set to false, you would
    always have to pass a regular userdata value.

* wrapper.disguise
  
  = boolean = false
  - Set this to true to effectively "disguise" wrapped objects as real userdata values.
    What this means is: Error messages will be printed for trying to get non-existant properties, trying to convert the userdata to a string,
    using it in a for loop, and so on.
    
  - This is actually useful for functions such as CYK's `table.copy` function, because if the Player were wrapped, it would duplicate the metatable
    and cause problems. With `disguise` as true, such a function would be forced to believe that the wrapped userdata is a REAL userdata value.

* wrapper.spriteValues,
* wrapper.projectileValues,
* wrapper.scriptValues,
* wrapper.textValues
  
  = override table (see section (OVER)) = {}
  - Set this to an override table, and the values you set here will be applied to ALL wrapped sprites/projectiles/etc by default.
    For a full guide on using these, see section (OVER).

* wrappedObject.userdata
  
  = wrapped userdata object
  - By simply checking `wrappedObject.userdata`, you will be given the original userdata that was wrapped by the library.
    This property cannot be overwritten.





--======================--
---- [FUNC] FUNCTIONS ----
--======================--

* wrapper.WrapSprite(sprite, overrideTable = nil),
* wrapper.WrapProjectile(projectile, overrideTable = nil),
* wrapper.WrapScript(script, overrideTable = nil),
* wrapper.WrapText(text, overrideTable = nil)
  
  = takes 1 "multi-instance" userdata from Unitale/CYF, and one OPTIONAL override table (see section (OVER))
  - Returns a single table with metatables that "wraps" a given Unitale/CYF userdata object.
  
  - If you provide an override table as `overrideTable`, the custom values you set in it will be applied to the returned object.
  - If you leave the second argument blank, it will use the values in `wrapper.spriteValues`, `wrapper.projectileValues`, etc.

* wrapper.WrapPlayer(overrideTable = nil),
* wrapper.WrapAudio(overrideTable = nil),
* wrapper.WrapNewAudio(overrideTable = nil),
* wrapper.WrapInput(overrideTable = nil),
* wrapper.WrapTime(overrideTable = nil),
* wrapper.WrapMisc(overrideTable = nil),
* wrapper.WrapArena(overrideTable = nil),
* wrapper.WrapInventory(overrideTable = nil)
  
  = takes 1 "single-instance" userdata from Unitale/CYF, and one OPTIONAL override table (see section (OVER))
  - Immediately replaces a "single-instance" userdata from Unitale/CYF with a wrapped one.
  
  - The custom values you set in `overrideTable` will be applied to the returned table.

* wrapper.WrapCreateSprite(),
* wrapper.WrapCreateProjectile(),
* wrapper.WrapCreateProjectileAbs(),
* wrapper.WrapCreateText()
  
  = no arguments
  - Replaces `CreateSprite`/`CreateProjectile`/`CreateProjectileAbs`/etc. with a function that automatically wraps created userdata objects with
    `wrapper.spriteValues`, `wrapper.projectileValues`, etc.





--==========================--
---- [NOTE] CLOSING NOTES ----
--==========================--

There are a few IMPORTANT points to make before I can say you know everything you need to know.

 * In CYF, you can use `bullet["variable"]` and `sprite["variable"]` as shortcuts to `GetVar` and `SetVar`.
   Unfortunately, there is no way to differentiate between `bullet["variable"]` and `bullet.variable`.
   
   Trying to use `bullet.SetVar("x", 10)` and then `bullet["x"]` will return the actual table property `bullet.x`.
   
   So:
   
   !!! IF YOU HAVE VARIABLES LIKE `bullet["x"]`, YOU MUST USE SETVAR AND GETVAR TO ACCESS THEM !!!
   
   Or, the better option: AVOID using `bullet.SetVar("x", 10)` and other variables with the same names as regular properties, because
   it's bad practice, confusing, and will break this library, as mentioned above.
   
 * ALL created wrapped objects will have an unchangeable property: `wrappedObject.userdata`.
   All you have to do is access this, and it will return the original userdata that was wrapped by the object.
   
   This is REQUIRED for functions like `SetParent`, if `autoUnwrapUserdata` is false. Use it like this: `sprite.SetParent(wrappedObject.userdata)`
   
 * You can check if something is a wrapped table or userdata with `type(object)` (unless `disguise` is true).
   
 * Wrapping functions and objects only affects the script this library is loaded in.
   
 * Don't worry about issues with code that compares userdatas and such. Functions like OnHit are safe!

```
bullet = CreateProjectile("bullet", 0, 0)
bullet = wrapper.WrapProjectile(bullet)
(...)

function OnHit(p)
    if p == bullet then -- this checks out!
        (...)
    end
end
```

And, finally:

 * If your property has "set", but not "get", this library will interpret it as a userdata Function, and try to call it.
 
 * If your property has "get", but not "set", this library will interpret it as a read-only userdata variable.
 
 * If your property has neither "get" nor "set", trying to access it will error every time. There's no point in doing this.





--====================--
---- [OPTI] OPTIONS ----
--====================--

]]-- 

local self = {}

-- set this to true to automatically wrap `projectile.sprite` for `CreateProjectile` and `CreateProjectileAbs`
-- and `Player.sprite` for `Player`
self.autoWrapSprite = true

-- set this to true, and the default functions that take userdata values as arguments will be changed to
-- automatically unwrap whatever values you enter into them.
self.autoUnwrapUserdata = true

-- set this to true, and all wrapped objects will "disguise" themselves as userdata
-- meaning: they will create error messages when you try to access a property that doesn't exist, try to get
-- their length, or use pairs or ipairs on them
self.disguise = false

-- enter items in this table to override the default get/set functions from the wrapper!
self.spriteValues = {
    -- examples:
    --[[
    xscale = {
        get = function(_spr, spr)
            return _spr.xscale
        end,
        set = function(_spr, spr, val)
            _spr.xscale = val
        end
    },
    SetPivot =  {
        set = function(_spr, spr, x, y)
            _spr.SetPivot(x, y)
            
            DEBUG(x)
            DEBUG(y)
        end
    },
    SetAnimation = {
        set = function(_spr, spr, tab, ...)
            for k, v in pairs(tab) do
                if v == "forbidden_sprite" then
                    error("Cannot include the forbidden sprite in an animation!", 2)
                end
            end
        end
    }
    ]]--
}

-- enter items in this table to override the default get/set functions from the wrapper!
-- used by both CreateProjectile and CreateProjectileAbs, as they both create projectiles
self.projectileValues = {
    -- examples:
    --[[
    Move = {
        set = function(_prj, prj, ...)
            _prj.Move(...)
            
            prj.sprite.Set("bullet_" .. math.floor(({...}))[1] / 10)
            
            DEBUG("You moved the bullet " .. ({...})[1] .. " pixels right and " .. ({...})[2] .. "pixels up.")
        end
    }
    ]]--
}

-- enter items in this table to override the default get/set functions from the wrapper!
self.scriptValues = {
    
}

-- enter items in this table to override the default get/set functions from the wrapper!
self.textValues = {
    
}





--====================--
---- [MTHO] METHODS ----
--====================--



-- Little tip: if you're using Notepad++ or a similar text editor, try to "minimize" the functions that come before
-- self.WrapCreateSprite, by clicking the "-" next to the line numbers. The functions here are very long.

-- If you do want to look at them, though, you can instead minimize the sections that start with the single line "do".
-- They were specifically written in this way so you could hide whole sections of each function at once, instead of
-- having to scroll all the way through.

-- Happy browsing!



-- usage: after using CreateSprite, use `sprite = WrapSprite(sprite, customTable)`
-- you can provide values to be used here by changing this library's `spriteValues` table
function self.WrapSprite(_spr, customTable)
    local spr = {}
    
    if not customTable then
        -- copy `self.spriteValues` to `customTable`
        customTable = {}
        
        for k, v in pairs(self.spriteValues) do
            -- every item in `self.spriteValues` is a name-keyed table with at least one function named at the key `get` or `set`
            customTable[k] = { set = v.set, get = v.get }
        end
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- LuaSpriteController stats:
        --
        -- UNITALE:
        -- Can only be Get:
        -- isactive, width, height, animcomplete
        --
        -- Can be Get and Set:
        -- x, y, xscale, yscale, color, alpha, rotation
        --
        -- Functions:
        -- Set, SetParent, SetPivot, SetAnchor, Scale, SetAnimation, StopAnimation, MoveTo,
        -- MoveToAbs, SendToTop, SendToBottom, Remove
        --
        -- Object[variable] enabled?
        -- No
        --
        -- CYF:
        -- 
        -- Can only be Get:
        -- spritename, isactive, width, height, animcomplete, totaltime
        -- 
        -- Can be Get and Set:
        -- _img, nativeSizeDelta, keyframes, data, tag, x, y, z, absx, absy, absz, xscale, yscale, loopmode,
        -- color, color32, alpha, alpha32, rotation, layer, animationpaused, currentframe, currenttime,
        -- animationspeed
        -- 
        -- Functions:
        -- Set, SetParent, SetPivot, SetAnchor, Move, MoveTo, MoveToAbs, Scale, SetAnimation,
        -- StopAnimation, SendToTop, SendToBottom, MoveBelow, MoveAbove, Remove, Dust, SetVar, GetVar
        --
        -- Object[variable] enabled?
        -- Yes
        
        -- Can only be Get:
        if Encounter and Encounter["isCYF"] or isCYF then
            spr.spritename = {get = function() return _spr.spritename   end}
            spr.totaltime  = {get = function() return _spr.totaltime    end}
        end
        spr.animcomplete   = {get = function() return _spr.animcomplete end}
        spr.isactive       = {get = function() return _spr.isactive     end}
        spr.width          = {get = function() return _spr.width        end}
        spr.height         = {get = function() return _spr.height       end}
        
        -- Can be Get and Set:
        if Encounter and Encounter["isCYF"] or isCYF then
            spr._img            = {get = function() return _spr._img            end, set = function(val) _spr._img = val            end}
            spr.nativeSizeDelta = {get = function() return _spr.nativeSizeDelta end, set = function(val) _spr.nativeSizeDelta = val end}
            spr.keyframes       = {get = function() return _spr.keyframes       end, set = function(val) _spr.keyframes = val       end}
            spr.data            = {get = function() return _spr.data            end, set = function(val) _spr.data = val            end}
            spr.tag             = {get = function() return _spr.tag             end, set = function(val) _spr.tag = val             end}
            spr.absx            = {get = function() return _spr.absx            end, set = function(val) _spr.absx = val            end}
            spr.absy            = {get = function() return _spr.absy            end, set = function(val) _spr.absy = val            end}
            spr.z               = {get = function() return _spr.z               end, set = function(val) _spr.z = val               end}
            spr.absz            = {get = function() return _spr.absz            end, set = function(val) _spr.absz = val            end}
            spr.loopmode        = {get = function() return _spr.loopmode        end, set = function(val) _spr.loopmode = val        end}
            spr.color32         = {get = function() return _spr.color32         end, set = function(val) _spr.color32 = val         end}
            spr.alpha32         = {get = function() return _spr.alpha32         end, set = function(val) _spr.alpha32 = val         end}
            spr.layer           = {get = function() return _spr.layer           end, set = function(val) _spr.layer = val           end}
            spr.animationpaused = {get = function() return _spr.animationpaused end, set = function(val) _spr.animationpaused = val end}
            spr.currentframe    = {get = function() return _spr.currentframe    end, set = function(val) _spr.currentframe = val    end}
            spr.currenttime     = {get = function() return _spr.currenttime     end, set = function(val) _spr.currenttime = val     end}
            spr.animationspeed  = {get = function() return _spr.animationspeed  end, set = function(val) _spr.animationspeed = val  end}
        end
        spr.x                   = {get = function() return _spr.x               end, set = function(val) _spr.x = val               end}
        spr.y                   = {get = function() return _spr.y               end, set = function(val) _spr.y = val               end}
        spr.xscale              = {get = function() return _spr.xscale          end, set = function(val) _spr.xscale = val          end}
        spr.yscale              = {get = function() return _spr.yscale          end, set = function(val) _spr.yscale = val          end}
        spr.color               = {get = function() return _spr.color           end, set = function(val) _spr.color = val           end}
        spr.alpha               = {get = function() return _spr.alpha           end, set = function(val) _spr.alpha = val           end}
        spr.rotation            = {get = function() return _spr.rotation        end, set = function(val) _spr.rotation = val        end}
        
        -- Functions:
        if Encounter and Encounter["isCYF"] or isCYF then
            spr.MoveBelow     = {set = function(...) return _spr.MoveBelow(...)     end}
            spr.MoveAbove     = {set = function(...) return _spr.MoveAbove(...)     end}
            spr.Dust          = {set = function(...) return _spr.Dust(...)          end}
            spr.SetVar        = {set = function(...) return _spr.SetVar(...)        end}
            spr.GetVar        = {set = function(...) return _spr.GetVar(...)        end}
        end
        spr.Set               = {set = function(...) return _spr.Set(...)           end}
        spr.SetParent         = {set = function(...) return _spr.SetParent(...)     end}
        spr.SetPivot          = {set = function(...) return _spr.SetPivot(...)      end}
        spr.SetAnchor         = {set = function(...) return _spr.SetAnchor(...)     end}
        spr.Move              = {set = function(...) return _spr.Move(...)          end}
        spr.MoveTo            = {set = function(...) return _spr.MoveTo(...)        end}
        spr.MoveToAbs         = {set = function(...) return _spr.MoveToAbs(...)     end}
        spr.Scale             = {set = function(...) return _spr.Scale(...)         end}
        spr.SetAnimation      = {set = function(...) return _spr.SetAnimation(...)  end}
        spr.StopAnimation     = {set = function(...) return _spr.StopAnimation(...) end}
        spr.SendToTop         = {set = function(...) return _spr.SendToTop(...)     end}
        spr.SendToBottom      = {set = function(...) return _spr.SendToBottom(...)  end}
        spr.Remove            = {set = function(...) return _spr.Remove(...)        end}
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        if self.autoUnwrapUserdata then
            spr.SetParent = {set = function(other)
                    if type(other) == "table" then
                        return _spr.SetParent(other.userdata)
                    else
                        return _spr.SetParent(other)
                    end
                end}
            spr.MoveAbove = {set = function(other)
                    if type(other) == "table" then
                        return _spr.MoveAbove(other.userdata)
                    else
                        return _spr.MoveAbove(other)
                    end
                end}
            spr.MoveBelow = {set = function(other)
                    if type(other) == "table" then
                        return _spr.MoveBelow(other.userdata)
                    else
                        return _spr.MoveBelow(other)
                    end
                end}
        end
        
        for index, newvalue in pairs(customTable) do
            spr[index] = newvalue
        end
        
        spr.userdata = {get = function() -- cannot be overwritten
            --[[
                    ##################\\          #####     
                    ####......      \\#######\\\;#ººººº#    
                      ######......        \\\#######ººº#    
                        ########......        ######;;##    
                        ##      ######..........    ####    
                    ####              ################  ####
                ####                                  ######
                #####         m  a  g  i  c         ########
                #### ###                        ####::::####
                ####::  ####                ####::::::::####
                ####        ####        ####::::::::    ####
                ####        ::::########::::::::::::    ####
                ####          ::    ##::::::        ::::####
                ####  ::      ::::::##      ::::####::  ####
                ####::##::    ::    ##::    ::##ºººº##::####
                ######º###::  ::    ##::    ::#ºººººº#::####
                #####º º º##::  ::::##::  ::##ºººººººº######
                ####  º º º ##::    ##::::::####ºººººººº####
                #### º º º º####::####::################    
                ##### º º º ####::::##::##########          
                  ######################                    
                      ###############
            ]]--
            return _spr
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real sprite
        for _, v in pairs(spr) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(spr[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(spr[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_spr, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    -- allow for `sprite["variable"]`
                    if (Encounter and Encounter["isCYF"] or isCYF) and _spr[index] and not customTable[index] then
                        return _spr.GetVar(index)
                    elseif spr[index] then
                        if spr[index].get then
                            return spr[index].get(_spr, returnTab)
                        elseif spr[index].set then -- if a property has set but not get, it must be a function
                            return spr[index] -- in that case, this line will access the "set" value retrieved above
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_prj) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    -- allow for `sprite["variable"] = value`
                    if (Encounter and Encounter["isCYF"] or isCYF) and not spr[key] then
                        _spr.SetVar(key, value)
                    else
                        if spr[key].set then
                            -- for custom values only: pass the real sprite object, then the fake one, then the value
                            if customTable[key] then
                                spr[key].set(_spr, returnTab, value)
                            else
                                spr[key].set(value)
                            end
                        end
                        
                        if self.disguise then
                            error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_prj) .. ">", 2)
                        else
                            return nil
                        end
                    end
                end,
                __eq = function(o1, o2)
                    return _spr
                end,
                __tostring = function()
                    return tostring(_spr)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _spr or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
    
        return returnTab
    end
end

-- usage: after using CreateProjectile or CreateProjectileAbs, use `projectile = WrapProjectile(projectile, customTable)`
-- you can provide values to be used here by changing this library's `projectileValues` table
function self.WrapProjectile(_prj, customTable)
    local spr
    if self.autoWrapSprite then
        spr = self.WrapSprite(_prj.sprite)
    end
    
    local prj = {}
    
    if not customTable then
        -- copy `self.projectileValues` to `customTable`
        customTable = {}
        
        for k, v in pairs(self.projectileValues) do
            -- every item in `self.projectileValues` is a name-keyed table with at least one function named at the key `get` or `set`
            customTable[k] = { set = v.set, get = v.get }
        end
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- ProjectileController stats:
        --
        -- UNITALE:
        --
        -- Can only be Get:
        -- x, y, absx, absy, isactive, sprite
        --
        -- Can be Get and Set:
        -- (none)
        --
        -- Functions:
        -- UpdatePosition, Remove, Move, MoveTo, MoveToAbs, SendToTop, SendToBottom, SetVar, GetVar
        --
        -- Object[variable] enabled?
        -- No
        --
        -- CYF:
        -- 
        -- Can only be Get:
        -- ppchanged, isactive, sprite, isColliding
        -- 
        -- Can be Get and Set:
        -- x, y, absx, absy, ppcollision, isPersistent, layer
        -- 
        -- Functions:
        -- ResetCollisionSystem, Remove, Move, MoveTo, MoveToAbs, SendToTop, SendToBottom, SetVar, GetVar
        --
        -- Object[variable] enabled?
        -- Yes
        
        -- Can only be Get:
        if Encounter and Encounter["isCYF"] or isCYF then
            prj.isColliding = {get = function() return _prj.isColliding end}
            prj.ppchanged   = {get = function() return _prj.ppchanged   end}
        elseif not isCYF and ((Encounter and not Encounter["isCYF"]) or not Encounter) then
            prj.x           = {get = function() return _prj.x           end}
            prj.y           = {get = function() return _prj.y           end}
            prj.absx        = {get = function() return _prj.absx        end}
            prj.absy        = {get = function() return _prj.absy        end}
        end
        if not self.autoWrapSprite then
            prj.sprite      = {get = function() return _prj.sprite      end}
        end
        prj.isactive        = {get = function() return _prj.isactive    end}
        
        -- Can be Get and Set:
        if Encounter and Encounter["isCYF"] or isCYF then
            prj.ppcollision  = {get = function() return _prj.ppcollision  end, set = function(val) _prj.ppcollision = val  end}
            prj.isPersistent = {get = function() return _prj.isPersistent end, set = function(val) _prj.isPersistent = val end}
            prj.layer        = {get = function() return _prj.layer        end, set = function(val) _prj.layer = val        end}
            prj.x                = {get = function() return _prj.x            end, set = function(val) _prj.x = val            end}
            prj.y                = {get = function() return _prj.y            end, set = function(val) _prj.y = val            end}
            prj.absx             = {get = function() return _prj.absx         end, set = function(val) _prj.absx = val         end}
            prj.absy             = {get = function() return _prj.absy         end, set = function(val) _prj.absy = val         end}
        end
        
        -- Functions:
        if Encounter and Encounter["isCYF"] or isCYF then
            prj.ResetCollisionSystem = {set = function(...) return _prj.ResetCollisionSystem(...) end}
        elseif not isCYF and ((Encounter and not Encounter["isCYF"]) or not Encounter) then
            prj.UpdatePosition       = {set = function(...) return _prj.UpdatePosition(...)       end}
        end
        prj.Remove                   = {set = function(...) return _prj.Remove(...)               end}
        prj.Move                     = {set = function(...) return _prj.Move(...)                 end}
        prj.MoveTo                   = {set = function(...) return _prj.MoveTo(...)               end}
        prj.MoveToAbs                = {set = function(...) return _prj.MoveToAbs(...)            end}
        prj.SendToTop                = {set = function(...) return _prj.SendToTop(...)            end}
        prj.SendToBottom             = {set = function(...) return _prj.SendToBottom(...)         end}
        prj.SetVar                   = {set = function(...) return _prj.SetVar(...)               end}
        prj.GetVar                   = {set = function(...) return _prj.GetVar(...)               end}
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        if self.autoWrapSprite then
            prj.sprite = {
                get = function()
                        return spr
                    end
            }
        end
        
        for index, newvalue in pairs(customTable) do
            prj[index] = newvalue
        end
        
        prj.userdata = {get = function() -- cannot be overwritten
            return _prj
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(prj) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real projectile object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(prj[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(prj[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_prj, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    -- allow for `projectile["variable"]`
                    if (Encounter and Encounter["isCYF"] or isCYF) and not prj[index] then
                        return _prj.GetVar(index)
                    elseif prj[index] then
                        if prj[index].get then
                            return prj[index].get(_prj, returnTab)
                        elseif prj[index].set then -- if a property has set but not get, it must be a function
                            return prj[index] -- in that case, this line will access the "set" value retrieved above
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_prj) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    -- allow for `projectile["variable"] = value`
                    if (Encounter and Encounter["isCYF"] or isCYF) and not prj[key] then
                        _prj.SetVar(key, value)
                    else
                        if prj[key].set then
                            -- for custom values only: pass the real sprite object, then the fake one, then the value
                            if customTable[key] then
                                return prj[key].set(_prj, returnTab, value)
                            else
                                return prj[key].set(value)
                            end
                        end
                        
                        if self.disguise then
                            error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_prj) .. ">", 2)
                        else
                            return nil
                        end
                    end
                end,
                __eq = function(o1, o2)
                    return _prj
                end,
                __tostring = function()
                    return tostring(_prj)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _prj or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- usage: `scriptObject = WrapScript(scriptObject, customTable)`
-- you can provide values to be used here by changing this library's `scriptValues` table
function self.WrapScript(_scr, customTable)
    local scr = {}
    
    if not customTable then
        -- copy `self.scriptValues` to `customTable`
        customTable = {}
        
        for k, v in pairs(self.scriptValues) do
            -- every item in `self.scriptValues` is a name-keyed table with at least one function named at the key `get` or `set`
            customTable[k] = { set = v.set, get = v.get }
        end
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- ScriptWrapper stats:
        --
        -- UNITALE:
        --
        -- Can only be Get:
        -- (none)
        --
        -- Can be Get and Set:
        -- (none)
        --
        -- Functions:
        -- SetVar, GetVar, Call
        --
        -- Object[variable] enabled?
        -- Yes
        --
        -- CYF:
        --
        -- Can only be Get:
        -- (none)
        -- 
        -- Can be Get and Set:
        -- instances, script, scriptname, text, monstersprite
        -- 
        -- Functions:
        -- SetVar, GetVar, Call
        --
        -- Object[variable] enabled?
        -- Yes
        
        -- Can only be Get:
        -- (none)
        
        -- Can be Get and Set:
        if Encounter and Encounter["isCYF"] or isCYF then
            scr.instances     = {get = function() return _scr.instances     end, set = function(val) _scr.instances = val     end}
            scr.script        = {get = function() return _scr.script        end, set = function(val) _scr.script = val        end}
            scr.scriptname    = {get = function() return _scr.scriptname    end, set = function(val) _scr.scriptname = val    end}
            scr.text          = {get = function() return _scr.text          end, set = function(val) _scr.text = val          end}
            scr.monstersprite = {get = function() return _scr.monstersprite end, set = function(val) _scr.monstersprite = val end}
        end
        
        -- Functions:
        scr.SetVar = {set = function(...) return _scr.SetVar(...) end}
        scr.GetVar = {set = function(...) return _scr.GetVar(...) end}
        scr.Call   = {set = function(...) return _scr.Call(...)   end}
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            scr[index] = newvalue
        end
        
        scr.userdata = {get = function() -- cannot be overwritten
            return _scr
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(scr) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real script object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(scr[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(scr[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_scr, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    -- allow for `script["variable"]`
                    if not scr[index] then
                        return _scr.GetVar(index)
                    elseif scr[index] then
                        if scr[index].get then
                            return scr[index].get(_scr, returnTab)
                        elseif scr[index].set then -- if a property has set but not get, it must be a function
                            return scr[index] -- in that case, this line will access the "set" value retrieved above
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_scr) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    -- allow for `script["variable"] = value`
                    if not scr[key] then
                        _scr.SetVar(key, value)
                    else
                        if scr[key].set then
                            -- for custom values only: pass the real sprite object, then the fake one, then the value
                            if customTable[key] then
                                return scr[key].set(_scr, returnTab, value)
                            else
                                return scr[key].set(value)
                            end
                        end
                        
                        if self.disguise then
                            error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_scr) .. ">", 2)
                        else
                            return nil
                        end
                    end
                end,
                __eq = function(o1, o2)
                    return _scr
                end,
                __tostring = function()
                    return tostring(_scr)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _scr or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- usage: `text = WrapText(text, customTable)`
-- you can provide values to be used here by changing this library's `textValues` table
function self.WrapText(_txt, customTable)
    local txt = {}
    
    if not customTable then
        -- copy `self.textValues` to `customTable`
        customTable = {}
        
        for k, v in pairs(self.textValues) do
            -- every item in `self.textValues` is a name-keyed table with at least one function named at the key `get` or `set`
            customTable[k] = { set = v.set, get = v.get }
        end
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- LuaTextManager stats:
        --
        -- UNITALE:
        --
        -- N/A
        --
        -- CYF:
        --
        -- Can only be Get:
        -- isactive, lineComplete, allLinesComplete
        --
        -- Charset
        -- 
        -- Can be Get and Set:
        -- progressmode, x, y, absx, absy, textMaxWidth, bubbleHeight, layer, _color, hasColorBeenSet,
        -- hasAlphaBeenSet, color, color32, alpha, alpha32,
        --
        -- letterSound, letters, currentLine, currentReferenceCharacter, nextMonsterDialogueOnce, nmd2,
        -- wasStated, offset, caller, textQueue, blockSkip, hidden, skipNowIfBlocked, LateStartWaiting
        -- 
        -- Functions:
        -- MoveBelow, MoveAbove, SetParent, SetText, LateStart, AddText, SetVoice, SetFont, SetEffect,
        -- IsTheLineFinished, IsTheTextFinished, ShowBubble, SetSpeechThingPositionAndSide, HideBubble,
        -- NextLine, SetAutoWaitTimeBetweenTexts, MoveTo, MoveToAbs, SetPivot, GetTextWidth, GetTextHeight
        --
        -- SetCaller, SetHorizontalSpacing, SetVerticalSpacing, ResetFont, SetPause, IsPaused, IsFinished,
        -- SetMute, SetTextQueue, SetTextQueueAfterValue, ResetCurrentCharacter, AddToTextQueue,
        -- CanSkip, CanAutoSkip, CanAutoSkipThis, CanAutoSkipAll, LineCount, SetOffset, LineComplete,
        -- AllLinesComplete, SetTextFrameAlpha, HasNext, NextLineText, SkipText, DoSkipFromPlayer,
        -- SkipLine, CharacterCount, DestroyText
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        local onlyGet = {"isactive", "lineComplete", "allLinesComplete",
            
            "Charset"}
        
        for _, name in pairs(onlyGet) do
            txt[name] = {get = function() return _txt[name] end}
        end
        
        -- Can be Get and Set:
        local getAndSet = {"progressmode", "x", "y", "absx", "absy", "textMaxWidth", "bubbleHeight", "layer",
            "_color", "hasColorBeenSet", "hasAlphaBeenSet", "color", "color32", "alpha", "alpha32",
            
            "letterSound", "letters", "currentLine", "currentReferenceCharacter", "nextMonsterDialogueOnce",
            "nmd2", "wasStated", "offset", "caller", "textQueue", "blockSkip", "hidden", "skipNowIfBlocked",
            "LateStartWaiting"}
        
        for _, name in pairs(getAndSet) do
            txt[name] = {get = function() return _txt[name] end, set = function(val) _txt[name] = val end}
        end
        
        -- Functions:
        local functions = {"MoveBelow", "MoveAbove", "SetParent", "SetText", "LateStart", "AddText", "SetVoice",
            "SetFont", "SetEffect", "IsTheLineFinished", "IsTheTextFinished", "ShowBubble",
            "SetSpeechThingPositionAndSide", "HideBubble", "NextLine", "SetAutoWaitTimeBetweenTexts", "MoveTo",
            "MoveToAbs", "SetPivot", "GetTextWidth", "GetTextHeight",
            
            "SetCaller", "SetHorizontalSpacing", "SetVerticalSpacing", "ResetFont", "SetPause", "IsPaused",
            "IsFinished", "SetMute", "SetTextQueue", "SetTextQueueAfterValue", "ResetCurrentCharacter",
            "AddToTextQueue", "CanSkip", "CanAutoSkip", "CanAutoSkipThis", "CanAutoSkipAll", "LineCount",
            "SetOffset", "LineComplete", "AllLinesComplete", "SetTextFrameAlpha", "HasNext", "NextLineText",
            "SkipText", "DoSkipFromPlayer", "SkipLine", "CharacterCount", "DestroyText"}
        
        for _, name in pairs(functions) do
            txt[name] = {set = function(...) return _txt[name](...) end}
        end
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        if self.autoUnwrapUserdata then
            txt.SetParent = {set = function(spr)
                    if type(spr) == "table" then
                        return _txt.SetParent(spr.userdata)
                    else
                        return _txt.SetParent(spr)
                    end
                end}
            txt.MoveAbove = {set = function(other)
                    if type(other) == "table" then
                        return _real.MoveAbove(other.userdata)
                    else
                        return _real.MoveAbove(other)
                    end
                end}
            txt.MoveBelow = {set = function(other)
                    if type(other) == "table" then
                        return _real.MoveBelow(other.userdata)
                    else
                        return _real.MoveBelow(other)
                    end
                end}
            txt.SetCaller = {set = function(scr)
                    if type(scr) == "table" then
                        return _real.SetCaller(scr.userdata)
                    else
                        return _real.SetCaller(scr)
                    end
                end}
        end
        
        for index, newvalue in pairs(customTable) do
            txt[index] = newvalue
        end
        
        txt.userdata = {get = function() -- cannot be overwritten
            return _txt
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(txt) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real text object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(txt[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(txt[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_txt, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    -- allow for `txtipt["variable"]`
                    if txt[index] and txt[index].get then
                        return txt[index].get(_txt, returnTab)
                    elseif txt[index].set then -- if a property has set but not get, it must be a function
                        return txt[index] -- in that case, this line will access the "set" value retrieved above
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_txt) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if txt[key].set then
                        -- for custom values only: pass the real text object, then the fake one, then the value
                        if customTable[key] then
                            return txt[key].set(_txt, returnTab, value)
                        else
                            return txt[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_txt) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _txt
                end,
                __tostring = function()
                    return tostring(_txt)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _txt or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapPlayer = function(_pla, customTable)
    local spr
    if self.autoWrapSprite then
        spr = self.WrapSprite(_pla.sprite)
    end
    
    local pla = {}
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- LuaPlayerStatus stats:
        --
        -- UNITALE:
        --
        -- Can only be Get:
        -- x, y, absx, absy, sprite, isHurting, isMoving
        --
        -- Can be Get and Set:
        -- hp, name, lv
        --
        -- Functions:
        -- Hurt, Heal, SetControlOverride, MoveTo, MoveToAbs
        --
        -- Object[variable] enabled?
        -- No
        --
        -- CYF:
        -- 
        -- Can only be Get:
        -- x, y, absx, absy, sprite, maxhp, MaxHPShift, maxhpshift, atk, weapon, weaponatk, def,
        -- armor, armordef, lastenemychosen, lasthitmultiplier, isHurting, ishurting, isMoving, ismoving
        -- 
        -- Can be Get and Set:
        -- hp, name, lv
        -- 
        -- Functions:
        -- Hurt, Heal, SetControlOverride, Move, MoveTo, MoveToAbs, ForceHP, SetMaxHPShift, setMaxHPShift,
        -- SetAttackAnim, ResetAttackAnim, ChangeTarget, ForceAttack, MultiTarget, ForceMultiAttack, CheckDeath
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        local onlyGet = {"x", "y", "absx", "absy", "isHurting", "isMoving"}
        
        if Encounter and Encounter["isCYF"] or isCYF then
            local add = {"maxhp", "MaxHPShift", "maxhpshift", "atk", "weapon", "weaponatk", "def", "armor", "armordef",
                "lastenemychosen", "lasthitmultiplier", "ishurting", "ismoving"}
            
            for _, v in pairs(add) do
                table.insert(onlyGet, v)
            end
        end
        
        if not self.autoWrapSprite then
            table.insert(onlyGet, "sprite")
        end
        
        for _, name in pairs(onlyGet) do
            pla[name] = {get = function() return _pla[name] end}
        end
        
        -- Can be Get and Set:
        local getAndSet = {"hp", "name", "lv"}
        
        for _, name in pairs(getAndSet) do
            pla[name] = {get = function() return _pla[name] end, set = function(val) _pla[name] = val end}
        end
        
        -- Functions:
        local functions = {"Hurt", "Heal", "SetControlOverride", "MoveTo", "MoveToAbs"}
        
        if Encounter and Encounter["isCYF"] or isCYF then
            local add = {"Move", "ForceHP", "SetMaxHPShift", "setMaxHPShift", "SetAttackAnim", "ResetAttackAnim",
            "ChangeTarget", "ForceAttack", "MultiTarget", "ForceMultiAttack", "CheckDeath"}
            
            for _, v in pairs(add) do
                table.insert(functions, v)
            end
        end
        
        for _, name in pairs(functions) do
            pla[name] = {set = function(...) return _pla[name](...) end}
        end
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        if self.autoWrapSprite then
            pla.sprite = {
                get = function()
                    return spr
                end
            }
        end
        
        if customTable then
            for index, newvalue in pairs(customTable) do
                pla[index] = newvalue
            end
        end
        
        pla.userdata = {get = function() -- cannot be overwritten
            return _pla
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real Player
        for k, v in pairs(pla) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real Player object as the first argument, and the fake object as the second
        if customTable then
            for k, v in pairs(customTable) do
                if type(pla[k]) == "table" then -- allow for variables and functions to be set to nil
                    setmetatable(pla[k], {
                            __call = function(tab, ...)
                                if tab.set then
                                    return tab.set(_pla, returnTab, ...)
                                end
                            end
                        })
                end
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    if pla[index] then
                        if pla[index].get then
                            return pla[index].get(_pla, returnTab)
                        elseif pla[index].set then -- if a property has set but not get, it must be a function
                            return pla[index] -- in that case, this line will access the "set" value retrieved above
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_prj) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if pla[key].set then
                        -- for custom values only: pass the real Player object, then the fake one, then the value
                        if customTable[key] then
                            pla[key].set(_pla, returnTab, value)
                        else
                            pla[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_prj) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _pla
                end,
                __tostring = function()
                    return tostring(_pla)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _pla or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapAudio = function(_aud, customTable)
    local aud = {}
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- MusicManager stats:
        --
        -- UNITALE:
        --
        -- Can only be Get:
        -- playtime, totaltime
        --
        -- Can be Get and Set:
        -- (none)
        --
        -- Functions:
        -- LoadFile, PlaySound, Pitch, Volume, Play, Stop, Pause, Unpause
        --
        -- Object[variable] enabled?
        -- No
        --
        -- CYF:
        --
        -- Can only be Get:
        -- IsPlaying, isPlaying, totaltime
        -- 
        -- Can be Get and Set:
        -- src, hiddenDictionary, filename, playtime
        -- 
        -- Functions:
        -- Play, Stop, Pause, Unpause, Volume, Pitch, LoadFile, PlaySound, IsStoppedOrNull, StopAll,
        -- PauseAll, UnpauseAll, GetSoundDictionary, SetSoundDictionary
        --
        -- Object[variable] enabled?
        -- Yes
        
        -- Can only be Get:
        if not isCYF and ((Encounter and not Encounter["isCYF"]) or not Encounter) then
            aud.playtime  = {fet = function() return _aud.playtime  end}
            aud.totaltime = {fet = function() return _aud.totaltime end}
        end
        
        -- Can be Get and Set:
        if (Encounter and Encounter["isCYF"]) or isCYF then
            aud.src              = {get = function() return _aud.src              end, set = function(val) _aud.src = val              end}
            aud.hiddenDictionary = {get = function() return _aud.hiddenDictionary end, set = function(val) _aud.hiddenDictionary = val end}
            aud.filename         = {get = function() return _aud.filename         end, set = function(val) _aud.filename = val         end}
            aud.playtime         = {get = function() return _aud.playtime         end, set = function(val) _aud.playtime = val         end}
        end
        
        -- Functions:
        if (Encounter and Encounter["isCYF"]) or isCYF then
            aud.IsStoppedOrNull    = {set = function(...) return _aud.IsStoppedOrNull(...)    end}
            aud.StopAll            = {set = function(...) return _aud.StopAll(...)            end}
            aud.PauseAll           = {set = function(...) return _aud.PauseAll(...)           end}
            aud.UnpauseAll         = {set = function(...) return _aud.UnpauseAll(...)         end}
            aud.GetSoundDictionary = {set = function(...) return _aud.GetSoundDictionary(...) end}
            aud.SetSoundDictionary = {set = function(...) return _aud.SetSoundDictionary(...) end}
        end
        aud.LoadFile  = {set = function(...) return _aud.LoadFile(...)  end}
        aud.PlaySound = {set = function(...) return _aud.PlaySound(...) end}
        aud.Pitch     = {set = function(...) return _aud.Pitch(...)     end}
        aud.Volume    = {set = function(...) return _aud.Volume(...)    end}
        aud.Play      = {set = function(...) return _aud.Play(...)      end}
        aud.Stop      = {set = function(...) return _aud.Stop(...)      end}
        aud.Pause     = {set = function(...) return _aud.Pause(...)     end}
        aud.Unpause   = {set = function(...) return _aud.Unpause(...)   end}
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            aud[index] = newvalue
        end
        
        aud.userdata = {get = function() -- cannot be overwritten
            return _aud
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(aud) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real audipt object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(aud[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(aud[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_aud, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    -- allow for `audio["variable"]`
                    if (Encounter and Encounter["isCYF"] or isCYF) and not aud[index] then
                        return _aud.GetSoundDictionary(index)
                    elseif aud[index] then
                        if aud[index].get then
                            return aud[index].get(_aud, returnTab)
                        elseif aud[index].set then -- if a property has set but not get, it must be a function
                            return aud[index] -- in that case, this line will access the "set" value retrieved above
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_aud) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    -- allow for `audio["variable"] = value`
                    if (Encounter and Encounter["isCYF"] or isCYF) and not aud[key] then
                        _aud.SetSoundDictionary(key, value)
                    else
                        if aud[key].set then
                            -- for custom values only: pass the real sprite object, then the fake one, then the value
                            if customTable[key] then
                                return aud[key].set(_aud, returnTab, value)
                            else
                                return aud[key].set(value)
                            end
                        end
                        
                        if self.disguise then
                            error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_aud) .. ">", 2)
                        else
                            return nil
                        end
                    end
                end,
                __eq = function(o1, o2)
                    return _aud
                end,
                __tostring = function()
                    return tostring(_aud)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _aud or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapNewAudio = function(_new, customTable)
    local new = {}
    
    if not isCYF and ((Encounter and not Encounter["isCYF"]) or not Encounter) then
        error("The NewAudio object is exclusive to CYF.", 2)
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- NewMusicManager stats:
        --
        -- UNITALE:
        --
        -- N/A
        --
        -- CYF:
        --
        -- Can only be Get:
        -- (none)
        -- 
        -- Can be Get and Set:
        -- audiolist, audioname
        -- 
        -- Functions:
        -- CreateChannel, CreateChannelAndGetAudioSource, DestroyChannel, Exists, GetAudioName, GetTotalTime,
        -- PlayMusic, PlaySound, PlayVoice, SetPitch, GetPitch, SetVolume, GetVolume, Play, Stop, Pause,
        -- Unpause, SetPlayTime, GetPlayTime, GetCurrentTime, StopAll, PauseAll, UnpauseAll, isStopped,
        -- IsStopped, OnLevelWasLoaded
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        -- (none)
        
        -- Can be Get and Set:
        local getAndSet = {"audiolist", "audioname"}
        
        for _, name in pairs(getAndSet) do
            new[name] = {get = function() return _new[name] end, set = function(val) _new[name] = val end}
        end
        
        -- Functions:
        local functions = {"CreateChannel", "CreateChannelAndGetAudioSource", "DestroyChannel", "Exists",
            "GetAudioName", "GetTotalTime", "PlayMusic", "PlaySound", "PlayVoice", "SetPitch", "GetPitch",
            "SetVolume", "GetVolume", "Play", "Stop", "Pause", "Unpause", "SetPlayTime", "GetPlayTime",
            "GetCurrentTime", "StopAll", "PauseAll", "UnpauseAll", "isStopped", "IsStopped", "OnLevelWasLoaded"}
        
        for _, name in pairs(functions) do
            new[name] = {set = function(...) return _new[name](...) end}
        end
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            new[index] = newvalue
        end
        
        new.userdata = {get = function() -- cannot be overwritten
            return _new
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(new) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real newipt object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(new[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(new[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_new, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    if new[index].get then
                        return new[index].get(_new, returnTab)
                    elseif new[index].set then -- if a property has set but not get, it must be a function
                        return new[index] -- in that case, this line will access the "set" value retrieved above
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_new) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if new[key].set then
                        -- for custom values only: pass the real sprite object, then the fake one, then the value
                        if customTable[key] then
                            return new[key].set(_new, returnTab, value)
                        else
                            return new[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_new) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _new
                end,
                __tostring = function()
                    return tostring(_new)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _new or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapInput = function(_inp, customTable)
    local inp = {}
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- LuaInputBinding stats:
        --
        -- UNITALE:
        --
        -- Can only be Get:
        -- Confirm, Cancel, Menu, Up, Down, Left, Right
        --
        -- Can be Get and Set:
        -- (none)
        --
        -- Functions:
        -- (none)
        --
        -- Object[variable] enabled?
        -- No
        --
        -- CYF:
        --
        -- Can only be Get:
        -- Confirm, Cancel, Menu, Up, Down, Left, Right, MousePosX, MousePosY, isMouseInWindow, IsMouseInWindow
        -- 
        -- Can be Get and Set:
        -- (none)
        -- 
        -- Functions:
        -- GetKey
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        local onlyGet = {"Confirm", "Cancel", "Menu", "Up", "Down", "Left", "Right"}
        
        if (Encounter and Encounter["isCYF"]) or isCYF then
            local add = {"MousePosX", "MousePosY", "isMouseInWindow", "IsMouseInWindow"}
            
            for _, v in pairs(add) do
                table.insert(onlyGet, v)
            end
        end
        
        for _, name in pairs(getAndSet) do
            inp[name] = {get = function() return _inp[name] end, set = function(val) _inp[name] = val end}
        end
        
        -- Can be Get and Set:
        -- (none)
        
        -- Functions:
        if (Encounter and Encounter["isCYF"]) or isCYF then
            inp.GetKey = {set = function(...) return inp.GetKey(...) end}
        end
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            inp[index] = newvalue
        end
        
        inp.userdata = {get = function() -- cannot be overwritten
            return _inp
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(inp) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real Input object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(inp[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(inp[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_inp, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    if inp[index].get then
                        return inp[index].get(_inp, returnTab)
                    elseif inp[index].set then -- if a property has set but not get, it must be a function
                        return inp[index] -- in that case, this line will access the "set" value retrieved above
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_inp) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if inp[key].set then
                        -- for custom values only: pass the real input object, then the fake one, then the value
                        if customTable[key] then
                            return inp[key].set(_inp, returnTab, value)
                        else
                            return inp[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_inp) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _inp
                end,
                __tostring = function()
                    return tostring(_inp)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _inp or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapTime = function(_tim, customTable)
    local tim = {}
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- LuaUnityTime stats:
        --
        -- UNITALE:
        --
        -- Can only be Get:
        -- time, dt, mult
        --
        -- Can be Get and Set:
        -- (none)
        --
        -- Functions:
        -- (none)
        --
        -- Object[variable] enabled?
        -- No
        --
        -- CYF:
        --
        -- Can only be Get:
        -- time, dt, mult, wave
        -- 
        -- Can be Get and Set:
        -- (none)
        -- 
        -- Functions:
        -- (none)
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        local onlyGet = {"time", "dt", "mult"}
        
        if (Encounter and Encounter["isCYF"]) or isCYF then
            table.insert(onlyGet, "wave")
        end
        
        for _, name in pairs(onlyGet) do
            tim[name] = {get = function() return _tim[name] end}
        end
        
        -- Can be Get and Set:
        -- (none)
        
        -- Functions:
        -- (none)
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            tim[index] = newvalue
        end
        
        tim.userdata = {get = function() -- cannot be overwritten
            return _tim
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(tim) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real timut object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(tim[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(tim[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_tim, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    if tim[index].get then
                        return tim[index].get(_tim, returnTab)
                    elseif tim[index].set then -- if a property has set but not get, it must be a function
                        return tim[index] -- in that case, this line will access the "set" value retrieved above
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_tim) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if tim[key].set then
                        -- for custom values only: pass the real Time object, then the fake one, then the value
                        if customTable[key] then
                            return tim[key].set(_tim, returnTab, value)
                        else
                            return tim[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_tim) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _tim
                end,
                __tostring = function()
                    return tostring(_tim)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _tim or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapMisc = function(_mis, customTable)
    local mis = {}
    
    if not isCYF and ((Encounter and not Encounter["isCYF"]) or not Encounter) then
        error("The Misc object is exclusive to CYF.", 2)
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- Misc stats:
        --
        -- UNITALE:
        --
        -- N/A
        --
        -- CYF:
        --
        -- Can only be Get:
        -- MachineName, ScreenHeight, ScreenWidth, WindowWidth, WindowHeight
        -- 
        -- Can be Get and Set:
        -- FullScreen, cameraX, cameraY, window, WindowName, WindowX, WindowY
        -- 
        -- Functions:
        -- ShakeScreen, StopShake, MoveCamera, MoveCameraTo, ResetCamera, RetargetWindow, FindWindow,
        -- MoveWindow, GetWindowText, SetWindowText, GetWindowRect, MoveWindow, MoveWindowTo
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        local onlyGet = {"MachineName", "ScreenHeight", "ScreenWidth", "WindowWidth", "WindowHeight"}
        
        for _, name in pairs(onlyGet) do
            mis[name] = {get = function() return _mis[name] end}
        end
        
        -- Can be Get and Set:
        local getAndSet = {"FullScreen", "cameraX", "cameraY", "window", "WindowName", "WindowX", "WindowY"}
        
        for _, name in pairs(getAndSet) do
            mis[name] = {get = function() return _mis[name] end, set = function(val) _mis[name] = val end}
        end
        
        -- Functions:
        local functions = {"ShakeScreen", "StopShake", "MoveCamera", "MoveCameraTo", "ResetCamera",
            "RetargetWindow", "FindWindow", "MoveWindow", "GetWindowText", "SetWindowText", "GetWindowRect",
            "MoveWindow", "MoveWindowTo"}
        
        for _, name in pairs(functions) do
            mis[name] = {set = function(...) return _mis[name](...) end}
        end
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            mis[index] = newvalue
        end
        
        mis.userdata = {get = function() -- cannot be overwritten
            return _mis
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(mis) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real Misc object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(mis[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(mis[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_mis, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    if mis[index].get then
                        return mis[index].get(_mis, returnTab)
                    elseif mis[index].set then -- if a property has set but not get, it must be a function
                        return mis[index] -- in that case, this line will access the "set" value retrieved above
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_mis) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if mis[key].set then
                        -- for custom values only: pass the real Misc object, then the fake one, then the value
                        if customTable[key] then
                            return mis[key].set(_mis, returnTab, value)
                        else
                            return mis[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_mis) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _mis
                end,
                __tostring = function()
                    return tostring(_mis)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _mis or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapArena = function(_are, customTable)
    local are = {}
    
    if not Encounter or not Arena then
        error("NOT THE WAVE SCRIPT\n\nsorry but pls don't", 2)
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- LuaArenaStatus stats:
        --
        -- UNITALE:
        --
        -- Can only be Get:
        -- width, height, currentwidth, currentheight
        --
        -- Can be Get and Set:
        -- (none)
        --
        -- Functions:
        -- Resize, ResizeImmediate
        --
        -- Object[variable] enabled?
        -- No
        --
        -- CYF:
        --
        -- Can only be Get:
        -- width, height, x, y, currentwidth, currentheight, currentx, currenty, isResizing, isresizing,
        -- isMoving, ismoving, isModifying, ismodifying
        -- 
        -- Can be Get and Set:
        -- (none)
        -- 
        -- Functions:
        -- Resize, ResizeImmediate, Hide, Show, Move, MoveTo, MoveAndResize, MoveToAndResize
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        local onlyGet = {"width", "height", "currentwidth", "currentheight"}
        
        if (Encounter and Encounter["isCYF"]) or isCYF then
            local add = {"x", "y", "currentx", "currenty", "isResizing", "isresizing", "isMoving",
                "ismoving", "isModifying", "ismodifying"}
            
            for _, name in pairs(add) do
                table.insert(onlyGet, name)
            end
        end
        
        for _, name in pairs(onlyGet) do
            are[name] = {get = function() return _are[name] end}
        end
        
        -- Can be Get and Set:
        -- (none)
        
        -- Functions:
        local functions = {"Resize", "ResizeImmediate"}
        
        if (Encounter and Encounter["isCYF"]) or isCYF then
            local add = {"Hide", "Show", "Move", "MoveTo", "MoveAndResize", "MoveToAndResize"}
            
            for _, name in pairs(add) do
                table.insert(functions, name)
            end
        end
        
        for _, name in pairs(functions) do
            are[name] = {set = function(...) return _are[name](...) end}
        end
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            are[index] = newvalue
        end
        
        are.userdata = {get = function() -- cannot be overwritten
            return _are
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(are) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real Arena object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(are[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(are[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_are, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    if are[index].get then
                        return are[index].get(_are, returnTab)
                    elseif are[index].set then -- if a property has set but not get, it must be a function
                        return are[index] -- in that case, this line will access the "set" value retrieved above
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_are) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if are[key].set then
                        -- for custom values only: pass the real Arena object, then the fake one, then the value
                        if customTable[key] then
                            return are[key].set(_are, returnTab, value)
                        else
                            return are[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_are) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _are
                end,
                __tostring = function()
                    return tostring(_are)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _are or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- this is an internal function! you can't call it yourself, or bad things would happen.
local wrapInventory = function(_inv, customTable)
    local inv = {}
    
    if not isCYF and ((Encounter and not Encounter["isCYF"]) or not Encounter) then
        error("The Inventory object is exclusive to CYF.", 2)
    end
    
    --------------------------------------
    ---- DEFAULT VALUES AND FUNCTIONS ----
    --------------------------------------
    
    do
        -- LuaInventory stats:
        --
        -- UNITALE:
        --
        -- N/A
        --
        -- CYF:
        --
        -- Can only be Get:
        -- ItemCount
        -- 
        -- Can be Get and Set:
        -- NoDelete
        -- 
        -- Functions:
        -- GetItem, GetType, SetItem, AddItem, RemoveItem, AddCustomItems, SetInventory, SetAmount
        --
        -- Object[variable] enabled?
        -- No
        
        -- Can only be Get:
        inv.ItemCount = {get = function() return _inv.ItemCount end}
        
        -- Can be Get and Set:
        inv.NoDelete = {get = function() return _inv.NoDelete end, set = function(val) _inv.NoDelete = val end}
        
        -- Functions:
        local functions = {"GetItem", "GetType", "SetItem", "AddItem", "RemoveItem", "AddCustomItems", "SetInventory",
            "SetAmount"}
        
        for _, name in pairs(functions) do
            inv[name] = {set = function(...) return _inv[name](...) end}
        end
    end
    
    -------------------------------------
    ---- CUSTOM VALUES AND FUNCTIONS ----
    -------------------------------------
    
    do
        for index, newvalue in pairs(customTable) do
            inv[index] = newvalue
        end
        
        inv.userdata = {get = function() -- cannot be overwritten
            return _inv
        end}
    end
    
    -----------------------------------
    ---- OTHER WRAPPER NECESSITIES ----
    -----------------------------------
    
    do
        local returnTab = {}
        
        -- make every "property" of this table act like setting and getting the real property from the real projectile
        for k, v in pairs(inv) do
            setmetatable(v, {
                    __call = function(tab, ...)
                        if tab.set then
                            return tab.set(...)
                        end
                    end
                })
        end
        
        -- special case for custom values: pass the real invna object as the first argument, and the fake object as the second
        for k, v in pairs(customTable) do
            if type(inv[k]) == "table" then -- allow properties and functions to be set to nil
                setmetatable(inv[k], {
                        __call = function(tab, ...)
                            if tab.set then
                                return tab.set(_inv, returnTab, ...)
                            end
                        end
                    })
            end
        end
        
        setmetatable(returnTab, {
                __index = function(_, index)
                    if inv[index].get then
                        return inv[index].get(_inv, returnTab)
                    elseif inv[index].set then -- if a property has set but not get, it must be a function
                        return inv[index] -- in that case, this line will access the "set" value retrieved above
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_inv) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __newindex = function(_, key, value)
                    if inv[key].set then
                        -- for custom values only: pass the real Inventory object, then the fake one, then the value
                        if customTable[key] then
                            return inv[key].set(_inv, returnTab, value)
                        else
                            return inv[key].set(value)
                        end
                    end
                    
                    if self.disguise then
                        error("cannot access field " .. tostring(index) .. " of userdata <" .. tostring(_inv) .. ">", 2)
                    else
                        return nil
                    end
                end,
                __eq = function(o1, o2)
                    return _inv
                end,
                __tostring = function()
                    return tostring(_inv)
                end,
                __call = function(_, ...)
                    error(self.disguise and "attempt to call a userdata value" or "attempt to call a wrapped userdata value", 2)
                end,
                __metatable = not self.disguise and _inv or nil,
                __len = function(_)
                    error(self.disguise and "attempt to get length of a userdata value" or "attempt to get length of a wrapped userdata value", 2)
                end,
                __pairs = function(_, k)
                    error(self.disguise and "bad argument #1 to 'next' (table expected, got userdata)" or "bad argument #1 to 'next' (table expected, got wrapped userdata)", 2)
                end,
                __ipairs = function(_, k)
                    error(self.disguise and "bad argument #1 to '!!next_i!!' (table expected, got userdata)" or "bad argument #1 to '!!next_i!!' (table expected, got wrapped userdata)", 2)
                end
            })
        
        return returnTab
    end
end

-- call this to override CreateSprite with an automatically-wrapped version!
function self.WrapCreateSprite()
    local _CreateSprite = CreateSprite
    function CreateSprite(...)
        local _spr = _CreateSprite(...)
        
        return self.WrapSprite(_spr)
    end
end

-- call this to override CreateProjectile with an automatically-wrapped version!
function self.WrapCreateProjectile()
    local _CreateProjectile = CreateProjectile
    function CreateProjectile(...)
        local _prj = _CreateProjectile(...)
    
        return self.WrapProjectile(_prj)
    end
end

-- call this to override CreateProjectileAbs with an automatically-wrapped version!
function self.WrapCreateProjectileAbs()
    local _CreateProjectileAbs = CreateProjectileAbs
    function CreateProjectileAbs(...)
        local _prj = _CreateProjectileAbs(...)
    
        return self.WrapProjectile(_prj)
    end
end

-- call this to override CreateText with an automatically-wrapped version!
function self.WrapCreateText()
    local _CreateText = CreateText
    function CreateText(...)
        local _txt = _CreateText(...)
        
        return self.WrapText(_txt)
    end
end

-- call this to instantly wrap the Player! (case-sensitive)
function self.WrapPlayer(customTable)
    Player = wrapPlayer(Player, customTable)
end

-- call this to instantly wrap the Audio object! (case-sensitive)
function self.WrapAudio(customTable)
    Audio = wrapAudio(Audio, customTable)
end

-- call this to instantly wrap the NewAudio object! (case-sensitive)
function self.WrapNewAudio(customTable)
    NewAudio = wrapNewAudio(NewAudio, customTable)
end

-- call this to instantly wrap the Input object! (case-sensitive)
function self.WrapInput(customTable)
    Input = wrapInput(Input, customTable)
end

-- call this to instantly wrap the Time object! (case-sensitive)
function self.WrapTime(customTable)
    Time = wrapTime(Time, customTable)
end

-- call this to instantly wrap the Misc object! (case-sensitive)
function self.WrapMisc(customTable)
    Misc = wrapMisc(Misc, customTable)
end

-- call this to instantly wrap the Arena object! (case-sensitive)
function self.WrapArena(customTable)
    Arena = wrapArena(Arena, customTable)
end

-- call this to instantly wrap the Inventory object! (case-sensitive)
function self.WrapInventory(customTable)
    Inventory = wrapInventory(Inventory, customTable)
end

return self
