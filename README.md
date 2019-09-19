# userdata-wrapper
### For **[Unitale v0.2.1a](https://www.reddit.com/r/Unitale/wiki/ref#wiki_unitale_download)** and **[Create Your Frisk v0.6.3](https://github.com/RhenaudTheLukark/CreateYourFrisk/releases/tag/v0.6.3)**

A library providing functions you can use to wrap userdata objects in Unitale and Create Your Frisk.
> \~ *by WD200019* \~ 

This library is fully documented! Either open the lua file itself, or read on for a formatted version of the library's tutorial.

Any questions, comments, or concerns? Contact me on [reddit](https://www.reddit.com/user/WD200019/) or Discord (**`WD200019#8327`**).

***

&nbsp;

Say you're using CYF to make a moddable Lua environment, like [Create Your Kris](https://github.com/RhenaudTheLukark/CreateYourKris).
How would you force code like `Player.Hurt(3)` to run some of your own code that you need to run? Maybe you need to instantly update an hp bar sprite, for instance.

It would be cool to **replace Player.Hurt with your own function** - but that's impossible, isn't it?

# Introduction

Let's talk about how to accomplish the above "by normal means" as well as with this library.

Regularly, you might forcefully update your hp bar sprite according to the player's hp every frame (which is already very wasteful, intensive and wildly inaccurate).

But even then, say you want something to happen if the user runs `Player.Hurt` and it would now kill the player - like a *custom game over screen*? Tough luck - before you can run any of your own code, the engine will take over from here and instantly show the Undertale game over sequence.

The next step, then, is a *metatable*. A lua table that, when certain properties are *get* or *set*, will run custom code defined by you. But you don't want to manually copy and paste a "default case" function for *every single property of the `Player` object*, do you? `Player.x`, `Player.y`, `Player.sprite`, `Player.hp`, `Player.maxhp`, `Player.maxhpshift`, `Player.atk`, `Player.weapon`, `Player.lv`, `Player.ishurting`, `Player.lastenemychosen`...need I say more?

&nbsp;

And that is where this library comes in. You can **replace and create any and all properties and functions in any userdata object!**
("userdata" means an object provided by the engine, such as the Time object, the Player object, the Bullet object, the Inventory object...)

This takes all of the work out of the process. You don't need to know metatables, or make a list of all properties of an object and their types, or even make a custom Player object at all!

The above example is now as simple as

```lua
wrapper = require "Libraries/userdataWrapper"
wrapper.WrapPlayer({
        Hurt = {
            set = function(_pla, pla, hurtAmount, invulnFrames)
                -- get the hp value of the real Player object
                if _pla.hp - hurtAmount <= 0 then
                    -- maybe you want a custom game over screen? put it here!
                    Encounter.Call("StartGameOver")
                    EndWave()
                else
                    -- set hp bar sprites and whatnot!
                    Encounter.Call("UpdateFakeUI")
                    
                    -- call the ACTUAL Player.Hurt function provided by the engine
                    _pla.Hurt(hurtAmount, invulnFrames)
                end
            end
        }
    })
```

After this code is run, ALL future occurences of `Player.Hurt` (in this script) will instead call the function you defined above!

Now imagine putting this in a new .lua file and loading it as a library at the beginning of every wave - that's only *one line* in each wave file, and now magically every wave file in your mod has this customized version of the Player!

&nbsp;

This library has many uses beyond this, too.

Read on for tutorials and documentation on the rest of the library!

# Override Tables

So, here is a tutorial on "override tables". These are special tables that provide a list of properties (functions and variables)
that you want to write custom code for.

They basically let you "override" (hence the name) userdata properties on a wrapped userdata object. In addition, any properties
you add that are not properties of the original userdata object will be added as *custom* properties.

You can override all of: normal variables (like `sprite.spritename`), read-only variables (like `Player.maxhp`), and even functions (like `Player.Hurt`).

This uses a system called "getters and setters".

***

So, here's an example: let's say I want to wrap a bullet, to make its Move function move it backwards instead of forwards.

If I want it to apply to a SINGLE bullet, then I just need to specify it in `wrapper.WrapProjectile`:

```lua
bullet = CreateProjectile("bullet", 0, 0)
bullet = wrapper.WrapProjectile(bullet, { !! HERE !! })
```

Because we want to override a FUNCTION, we need to specify ONLY a "set" function:

```lua
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

```lua
set(_REAL_OBJECT, FAKE_OBJECT, ...)
get(_REAL_OBJECT, FAKE_OBJECT)
```

You get access to both the real object (like the actual userdata projectile, for instance), and the fake object (that is, the
metatable that "replaces" the actual userdata object).

&nbsp;

Let's make use of these two arguments together! How about making `sprite.Set` automatically start an animation when you enter a certain phrase?

```lua
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

```lua
sprite.Set("attacking")
```

the code automatically calls

```lua
sprite.SetAnimation({"1", "2", "3", "4", "5", "6"}, 0.4, "Character/Attacking")`
```

AND

```lua
sprite.loopMode = "ONESHOT"
```
!

*(As a side note, the `...` you see above is a **[VarArg](http://lua-users.org/wiki/VarargTheSecondClassCitizen)**. You don't need to know how to do this to use this library.)*

&nbsp;

Next example: Overriding a variable that can be both get and set.

```lua
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

***

So, yes, as you can see, you can use this on all userdata values, and you can use both getters and setters.
Now, on to the next step! Applying your changes to every userdata of a type!

&nbsp;


So, I have a custom replacement for `bullet.Move` that I want to apply to EVERY bullet. How do I do it?

```lua
bullet = wrapper.WrapProjectile(bullet, {
        Move = {
            set = function(_prj, prj, x, y)
                _prj.Move(-x, -y)
            end
        }
    })
```

Well, one way would be to wrap CreateProjectile...

```lua
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

```lua
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

There! Not only was it cleaner and easier to do, but it also applied the changes to `CreateProjectileAbs`!

So: This is something you can do for ALL "multi-instance" userdata objects. The prime examples of what I'm talking about
are projectiles and sprites. Basically, anything that you can create a potentially infinite amount of.

&nbsp;

Now, for the full list of variables and functions for this library:

# Variables

* `wrapper.autoWrapSprite`:
  
  = boolean = `true`
  - Set this to `true` to automatically wrap `projectile.sprite` for wrapped projectiles, and `Player.sprite` for the wrapped Player.
  - If this is `true`, then the values in `wrapper.spriteValues` will be applied to the sprite components of wrapped projectiles and the player.

* `wrapper.autoUnwrapUserdata`:
  
  = boolean = `true`
  - Set this to `true`, and the default functions that take userdata values as arguments will be changed to
    automatically unwrap any table values you enter into them.
    
  - As an example: `sprite.SetParent` takes a sprite object as its only argument. With `autoUnwrapUserdata` as true,
    all you have to do is pass a wrapped userdata OR a regular userdata. With this variable set to `false`, you would
    always have to pass a regular userdata value.

* `wrapper.autoWrapFile`:
  
  = boolean = `true`
  - Set this to `true`, and whenever you use `Misc.OpenFile` from the wrapped Misc object, it will, *by default*, return a wrapped File object.
    I say "by default" because if you provide your own custom `OpenFile` function, it will be used instead (nothing unique to this variable).
  - If this is `true`, then the values in `wrapper.fileValues` will be applied to any File objects created from the wrapped Misc object.

* `wrapper.disguise`
  
  = boolean = `false`
  - Set this to `true` to effectively "disguise" wrapped objects as real userdata values.
    What this means is: Error messages will be printed for trying to get non-existant properties, trying to convert the userdata to a string, using it in a for loop, and so on.
    
  - This is actually useful for functions such as CYK's `table.copy` function, because if the Player were wrapped, it would duplicate the metatable and cause problems. With `disguise` as `true`, such a function would be forced to believe that the wrapped userdata is a REAL userdata value.

* `wrapper.spriteValues`,
* `wrapper.projectileValues`,
* `wrapper.scriptValues`,
* `wrapper.textValues`,
* `wrapper.fileValues`,
  
  = override table (see section **Override Tables**) = `{}`
  - Set this to an override table, and the values you set here will be applied to ALL wrapped sprites/projectiles/etc by default.
    For a full guide on using these, see section **Override Tables**.

* `wrappedObject.userdata`
  
  = wrapped userdata object
  - By simply checking `wrappedObject.userdata`, you will be given the original userdata that was wrapped by the library.
    This property cannot be overwritten.
# Functions

* `wrapper.WrapSprite(sprite, overrideTable = nil)`,
* `wrapper.WrapProjectile(projectile, overrideTable = nil)`,
* `wrapper.WrapScript(script, overrideTable = nil)`,
* `wrapper.WrapText(text, overrideTable = nil)`,
* `wrapper.WrapFile(file, overrideTable = nil)`,
  
  = takes 1 "multi-instance" userdata from Unitale/CYF, and one OPTIONAL override table (see section **Override Tables**)
  - Returns a single table with metatables that "wraps" a given Unitale/CYF userdata object.
  
  - If you provide an override table as `overrideTable`, the custom values you set in it will be applied to the returned object.
  - If you leave the second argument blank, it will use the values in `wrapper.spriteValues`, `wrapper.projectileValues`, etc.

* `wrapper.WrapPlayer(overrideTable = nil)`,
* `wrapper.WrapAudio(overrideTable = nil)`,
* `wrapper.WrapNewAudio(overrideTable = nil)`,
* `wrapper.WrapInput(overrideTable = nil)`,
* `wrapper.WrapTime(overrideTable = nil)`,
* `wrapper.WrapMisc(overrideTable = nil)`,
* `wrapper.WrapArena(overrideTable = nil)`,
* `wrapper.WrapInventory(overrideTable = nil)`
  
  = takes 1 "single-instance" userdata from Unitale/CYF, and one OPTIONAL override table (see section **OVERRIDE TABLES**)
  - Immediately replaces a "single-instance" userdata from Unitale/CYF with a wrapped one.

  - The custom values you set in `overrideTable` will be applied to the returned table.etc.

* `wrapper.WrapCreateSprite()`,
* `wrapper.WrapCreateProjectile()`,
* `wrapper.WrapCreateProjectileAbs()`,
* `wrapper.WrapCreateText()`
  
  = no arguments
  - Replaces `CreateSprite`/`CreateProjectile`/`CreateProjectileAbs`/etc. with a function that automatically wraps created userdata objects with `wrapper.spriteValues`, `wrapper.projectileValues`, etc.

# Closing Notes

There are a few IMPORTANT points to make before I can say you know everything you need to know.

 * In CYF, you can use `bullet["variable"]` and `sprite["variable"]` as shortcuts to `GetVar` and `SetVar`.
   Unfortunately, there is no way to differentiate between `bullet["variable"]` and `bullet.variable`.
   
   Trying to use `bullet.SetVar("x", 10)` and then `bullet["x"]` will return the actual table property `bullet.x`.
   
   So:
   
###   !!! IF YOU HAVE VARIABLES LIKE `bullet["x"]`, YOU MUST USE `SetVar` AND `GetVar` TO ACCESS THEM !!!
   
   Or, the better option: **AVOID** using `bullet.SetVar("x", 10)` and other variables with the same names as regular properties, because it's bad practice, confusing, and will break this library, as mentioned above.
   
 * *ALL* created wrapped objects will have an unchangeable property: `wrappedObject.userdata`.
   All you have to do is access this, and it will return the original userdata that was wrapped by the object.
   
   This is *REQUIRED* for functions like `SetParent`, if `autoUnwrapUserdata` is false. Use it like this: `sprite.SetParent(wrappedObject.userdata)`
   
 * You can check if something is a wrapped table or userdata with `type(object)` (unless `disguise` is true).
   
 * Wrapping functions and objects only affects the script this library is loaded in.
   
 * Don't worry about issues with code that compares userdatas and such. Functions like OnHit are safe!

```lua
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

 * If your property has "set", but not "get", this library will interpret it as a userdata **Function**, and try to call it. 

 * If your property has "get", but not "set", this library will interpret it as a **read-only** userdata **variable**.
 
 * If your property has neither "get" nor "set", trying to access it will error every time. There's no point in doing this.

***

Any questions, comments, or concerns? Contact me on [reddit](https://www.reddit.com/user/WD200019/) or Discord (**`WD200019#8327`**).
