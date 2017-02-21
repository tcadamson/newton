# LÖVE PhysicsEditor Library
Use the tools in this library to export bodies created using CodeAndWeb's
PhysicsEditor (https://www.codeandweb.com/physicseditor), then load them
into your LÖVE game. Comes with a "wdraw" utility that renders all the
physics bodies in a given physics world.

## Instructions
In PhysicsEditor: go to Preferences > Custom exporter directory, and point
it to the export folder. You can now select Love2D as an export option.

### Usage example
```lua
local loader = require "loader"
local wdraw = require "wdraw"
local world = love.physics.newWorld()
local body
local x, y = 100, 100

function love.load()
	body = loader(world, "physics/exportedFile", "bodyName", x, y)
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	wdraw(world)
end
```