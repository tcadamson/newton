--[[
Usage:
local loader = require "loader"
local body = loader(world, [filepath], body, x, y)
--]]

local obj = {}

obj.init = function()
	local physics = {{% for body in bodies %}{% if not forloop.first %}, {% endif %}
		["{{body.name}}"] = {
			static = {{body.static}},
			fixed = {{body.fixed_rotation}},
			ld = {{body.linear_damping}},
			ad = {{body.angular_damping}},
			fixtures = {{% for fixture in body.fixtures %}{% if not forloop.first %}, {% endif %} {% if fixture.isCircle %}
				{
					sensor = {{fixture.sensor}},
					density = {{fixture.density}},
					friction = {{fixture.friction}},
					restitution = {{fixture.restitution}},
					type = "circle",
					filter = {group = {{fixture.filter_group}}, category = {{fixture.filter_category}}, mask = {{fixture.filter_mask}}},
					shape = {radius = {{fixture.radius}}, cx = {{fixture.center.x}}, cy = {{fixture.center.y}}}
				}{% else %}{% for polygon in fixture.polygons %}{% if not forloop.first %}, {% endif %}
				{
					sensor = {{fixture.sensor}},
					density = {{fixture.density}},
					friction = {{fixture.friction}},
					restitution = {{fixture.restitution}},
					type = "polygon",
					filter = {group = {{fixture.filter_group}}, category = {{fixture.filter_category}}, mask = {{fixture.filter_mask}}},
					shape = {{% for point in polygon %}{% if not forloop.first %}, {% endif %}{{point.x}}, {{point.y}}{% endfor %}}
				}{% endfor %}{% endif %}{% endfor %}
			}
		}{% endfor %}
	}
	return physics
end

return obj