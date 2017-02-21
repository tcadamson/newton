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

local loader = {}

local function loadFixtures(body, list)
	for i = 1, #list do
		local fdata, f, s = list[i]
		local shapes = {
			circle = function(shape)
				return love.physics.newCircleShape(shape.cx, shape.cy, shape.radius)
			end,
			polygon = function(shape)
				return love.physics.newPolygonShape(unpack(shape))
			end
		}
		s = shapes[fdata.type](fdata.shape)
		f = love.physics.newFixture(body, s)
		f:setSensor(fdata.sensor)
		f:setDensity(fdata.density)
		f:setFriction(fdata.friction)
		f:setRestitution(fdata.restitution)
		f:setFilterData(fdata.filter.category, fdata.filter.mask, fdata.filter.group)
	end
end

loader.call = function(world, filepath, body, x, y)
	local data = require(filepath).init()[body]
	local b, btype
	if not data.static then btype = "dynamic" end
	b = love.physics.newBody(world, x, y, btype)
	b:setFixedRotation(data.fixed)
	b:setLinearDamping(data.ld)
	b:setAngularDamping(data.ad)
	loadFixtures(b, data.fixtures)
	return b
end

setmetatable(loader, {__call = function(t, ...) return loader.call(...) end})
return loader