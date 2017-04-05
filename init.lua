-- interaction_areas: A minetest mod to manage interaction areas.
-- Copyright (C) 2016-2017 YuGiOhJCJ

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
minetest.register_chatcommand("interaction_areas_add", {
	params = "[<position_x> [<position_y> [<position_z>]]] <owner_name> [<dimension_x> [<dimension_y> [<dimension_z>]]]",
	description = "Add an interaction area to the existing interaction areas",
	privs = {interaction_areas_admin = true},
	func = function(name, param)
		local position_x, position_y, position_z, owner_name, dimension_x, dimension_y, dimension_z = string.match(param, "^%s*(%-?%d*)%s*(%-?%d*)%s*(%-?%d*)%s*(%w+)%s*(%-?%d*)%s*(%-?%d*)%s*(%-?%d*)%s*$")
		if position_x ~= nil
			and position_y ~= nil
			and position_z ~= nil
			and owner_name ~= nil
			and dimension_x ~= nil
			and dimension_y ~= nil
			and dimension_z ~= nil then
			interaction_areas.add(name, position_x, position_y, position_z, owner_name, dimension_x, dimension_y, dimension_z)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas_add)")
		end
	end
})
minetest.register_chatcommand("interaction_areas_add_player", {
	params = "<player_name> [<interaction_area_id> | all]",
	description = "Add a player to one or more existing interaction areas",
	privs = {interaction_areas_user = true},
	func = function(name, param)
		local player_name, interaction_area_id = string.match(param, "^%s*(%w+)%s*(%w*)%s*$")
		if player_name ~= nil
			and interaction_area_id ~= nil
			and (interaction_area_id == "" or tonumber(interaction_area_id) ~= nil or interaction_area_id == "all") then
			interaction_areas.add_player(name, player_name, interaction_area_id)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas_add_player)")
		end
	end
})
minetest.register_chatcommand("interaction_areas_help", {
	params = "<command>",
	description = "Show the help for an interaction_areas command",
	privs = {interaction_areas_user = true},
	func = function(name, param)
		local command = string.match(param, "^%s*([%l_]+)%s*$")
		if command ~= nil then
			interaction_areas.help(name, command)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas_help)")
		end
	end
})
minetest.register_chatcommand("interaction_areas_remove", {
	params = "[<interaction_area_id> | all]",
	description = "Remove one or more interaction areas from the existing interaction areas",
	privs = {interaction_areas_admin = true},
	func = function(name, param)
		local interaction_area_id = string.match(param, "^%s*(%w*)%s*$")
		if interaction_area_id ~= nil
			and (interaction_area_id == "" or tonumber(interaction_area_id) ~= nil or interaction_area_id == "all") then
			interaction_areas.remove(name, interaction_area_id)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas_remove)")
		end
	end
})
minetest.register_chatcommand("interaction_areas_remove_player", {
	params = "<player_name> [<interaction_area_id> | all]",
	description = "Remove a player from one or more existing interaction areas",
	privs = {interaction_areas_user = true},
	func = function(name, param)
		local player_name, interaction_area_id = string.match(param, "^%s*(%w+)%s*(%w*)%s*$")
		if player_name ~= nil
			and interaction_area_id ~= nil
			and (interaction_area_id == "" or tonumber(interaction_area_id) ~= nil or interaction_area_id == "all") then
			interaction_areas.remove_player(name, player_name, interaction_area_id)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas_remove_player)")
		end
	end
})
minetest.register_chatcommand("interaction_areas_show", {
	params = "[<interaction_area_id> | all]",
	description = "Show one or more interaction areas",
	privs = {interaction_areas_user = true},
	func = function(name, param)
		local interaction_area_id = string.match(param, "^%s*(%w*)%s*$")
		if interaction_area_id ~= nil
			and (interaction_area_id == "" or tonumber(interaction_area_id) ~= nil or interaction_area_id == "all") then
			interaction_areas.show(name, interaction_area_id)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas_show)")
		end
	end
})
minetest.register_chatcommand("interaction_areas_version", {
	params = "",
	description = "Show the interaction_areas version",
	privs = {interaction_areas_user = true},
	func = function(name, param)
		local result = string.match(param, "^%s*$")
		if result ~= nil then
			interaction_areas.version(name)
		else
			interaction_areas.print(name, "Invalid parameters (see /help interaction_areas_version)")
		end
	end
})
minetest.register_privilege("interaction_areas_admin", "Can use the administrator interaction_areas commands, interact with all interaction areas and manage players of all interaction areas")
minetest.register_privilege("interaction_areas_user", "Can use the user interaction_areas commands")
interaction_areas.load()
