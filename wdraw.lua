--[[
The MIT License (MIT)

Copyright (c) 2017 Taylor Adamson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local wdraw = {}

local function getShapeColor(sensor, stype)
	local alpha = 90
	local colors = {
		sensor = {230, 20, 0, alpha},
		circle = {100, 50, 25, alpha},
		polygon = {100, 50, 225, alpha}
	}
	local stype = stype
	if sensor then stype = "sensor" end
	return colors[stype]
end

wdraw.call = function(world)
	local bodies = world:getBodyList()
	local outline = {0, 0, 0}
	local render = {
		circle = function(body, shape)
			local cx, cy = shape:getPoint()
			love.graphics.circle("fill", cx, cy, shape:getRadius())
			love.graphics.setColor(outline)
			love.graphics.circle("line", cx, cy, shape:getRadius())
        end,
        polygon = function(body, shape)
        	love.graphics.polygon("fill", shape:getPoints())
        	love.graphics.setColor(outline)
        	love.graphics.polygon("line", shape:getPoints())
    	end
	}
	love.graphics.setLineWidth(1)
	for i = 1, #bodies do
		local b = bodies[i]
		local fixtures = b:getFixtureList()
		local x, y = b:getPosition()
		local reset = {255, 255, 255}
		love.graphics.push()
		love.graphics.translate(b:getPosition())
		love.graphics.rotate(b:getAngle())
		for j = 1, #fixtures do
			local f = fixtures[j] 
			local s, stype = f:getShape(), f:getShape():getType()
			love.graphics.setColor(getShapeColor(f:isSensor(), stype))
			render[stype](b, s)
			love.graphics.setColor(reset)
		end
		love.graphics.pop()
	end
end

setmetatable(wdraw, {__call = function(t, ...) wdraw.call(...) end})
return wdraw