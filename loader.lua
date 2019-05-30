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