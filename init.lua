-- interaction_areas: A minetest mod to manage interaction areas.
-- Copyright (C) 2016 YuGiOhJCJ

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
dofile(minetest.get_modpath("interaction_areas") .. "/interaction_areas.lua")
dofile(minetest.get_modpath("interaction_areas") .. "/minetest.lua")
minetest.register_chatcommand("interaction_areas", {
	params = "add [<position_x> [<position_y> [<position_z>]]] <player_name> [<dimension_x> [<dimension_y> [<dimension_z>]]] | help <command> | remove [<interaction_area_id> | all] | show [<interaction_area_id> | all] | version",
	description = "Manage interaction areas",
	privs = {interaction_areas = true},
	func = function(name, param)
		local param_add_position_x, param_add_position_y, param_add_position_z, param_add_player_name, param_add_dimension_x, param_add_dimension_y, param_add_dimension_z = string.match(param, "^%s*add%s*(%-?%d*)%s*(%-?%d*)%s*(%-?%d*)%s*(%w+)%s*(%-?%d*)%s*(%-?%d*)%s*(%-?%d*)%s*$")
		local param_help = string.match(param, "^%s*help%s*(%l+)%s*$")
		local param_remove = string.match(param, "^%s*remove%s*(%w*)%s*$")
		local param_show = string.match(param, "^%s*show%s*(%w*)%s*$")
		local param_version = string.match(param, "^%s*version%s*$")
		if param_add_position_x ~= nil
			or param_add_position_y ~= nil
			or param_add_position_z ~= nil
			or param_add_player_name ~= nil
			or param_add_dimension_x ~= nil
			or param_add_dimension_y ~= nil
			or param_add_dimension_z ~= nil then
			interaction_areas.add(name, param_add_position_x, param_add_position_y, param_add_position_z, param_add_player_name, param_add_dimension_x, param_add_dimension_y, param_add_dimension_z)
		elseif param_help ~= nil then
			interaction_areas.help(name, param_help)
		elseif param_remove ~= nil
			and (param_remove == "" or tonumber(param_remove) ~= nil or param_remove == "all") then
			interaction_areas.remove(name, param_remove)
		elseif param_show ~= nil
			and (param_show == "" or tonumber(param_show) ~= nil or param_show == "all") then
			interaction_areas.show(name, param_show)
		elseif param_version ~= nil then
			interaction_areas.version(name)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas)")
		end
	end
})
minetest.register_privilege("interaction_areas", "Can use the interaction_areas command")
interaction_areas.load()
