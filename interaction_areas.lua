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
interaction_areas = {}
interaction_areas.filename = minetest.get_worldpath() .. "/interaction_areas.dat"
interaction_areas.interaction_areas = {}
function interaction_areas.add(name, position_x, position_y, position_z, player_name, dimension_x, dimension_y, dimension_z)
	if position_x == ""
		and position_y == ""
		and position_z == "" then
		position_x = interaction_areas.get_player_position(name).x
		position_y = interaction_areas.get_player_position(name).y
		position_z = interaction_areas.get_player_position(name).z
	end
	if position_y == "" then
		position_y = position_x
	end
	if position_z == "" then
		position_z = position_y
	end
	if dimension_x == "" then
		dimension_x = 1
	end
	if dimension_y == "" then
		dimension_y = dimension_x
	end
	if dimension_z == "" then
		dimension_z = dimension_y
	end
	if interaction_areas.get_interaction_area_id({x = position_x, y = position_y, z = position_z}) ~= nil then
		interaction_areas.print(name, "Unable to add an interaction area to the existing interaction areas because there is already an existing interaction area at this position")
		return
	end
	table.insert(interaction_areas.interaction_areas, {{x = position_x, y = position_y, z = position_z}, {x = dimension_x, y = dimension_y, z = dimension_z}, player_name})
	interaction_areas.save(name)
	interaction_areas.print(name, "Interaction area added to the existing interaction areas")
end
function interaction_areas.get_player_position(name)
	return vector.round(minetest.get_player_by_name(name):getpos())
end
function interaction_areas.get_interaction_area_id(position)
	for key, value in pairs(interaction_areas.interaction_areas) do
		local position_1 = value[1]
		local position_2 = {x = position_1.x + value[2].x - 1, y = position_1.y + value[2].y - 1, z = position_1.z + value[2].z - 1}
		if position.x >= math.min(position_1.x, position_2.x)
			and position.x <= math.max(position_1.x, position_2.x)
			and position.y >= math.min(position_1.y, position_2.y)
			and position.y <= math.max(position_1.y, position_2.y)
			and position.z >= math.min(position_1.z, position_2.z)
			and position.z <= math.max(position_1.z, position_2.z) then
			return key
		end
	end
	return nil
end
function interaction_areas.help(name, command)
	if command == "add" then
		interaction_areas.print(name, "Usage: add [<position_x> [<position_y> [<position_z>]]] <player_name> [<dimension_x> [<dimension_y> [<dimension_z>]]]")
		interaction_areas.print(name, "Description: Add an interaction area to the existing interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <position_x>: The X position of the interaction area (default value: The position of the player if Y and Z are not specified too)")
		interaction_areas.print(name, " <position_y>: The Y position of the interaction area (default value: The position of the player if X and Z are not specified too, else X)")
		interaction_areas.print(name, " <position_z>: The Z position of the interaction area (default value: The position of the player if X and Y are not specified too, else Y)")
		interaction_areas.print(name, " <player_name>: The name of the player owning the interaction area")
		interaction_areas.print(name, " <dimension_x>: The X dimension of the interaction area (default value: 1)")
		interaction_areas.print(name, " <dimension_y>: The Y dimension of the interaction area (default value: X)")
		interaction_areas.print(name, " <dimension_z>: The Z dimension of the interaction area (default value: Y)")
	elseif command == "help" then
		interaction_areas.print(name, "Usage: help <command>")
		interaction_areas.print(name, "Description: Show the help for a command")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <command>: The command")
	elseif command == "remove" then
		interaction_areas.print(name, "Usage: remove [<interaction_area_id> | all]")
		interaction_areas.print(name, "Description: Remove one or more interaction areas from the existing interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)")
	elseif command == "show" then
		interaction_areas.print(name, "Usage: show [<interaction_area_id> | all]")
		interaction_areas.print(name, "Description: Show one or more interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)")
	else
		interaction_areas.print(name, "Unable to show the help for a command because the command does not correspond to an existing command")
		return
	end
end
function interaction_areas.load()
	local file = io.open(interaction_areas.filename, "r")
	if file == nil then
		return
	end
	interaction_areas.interaction_areas = minetest.deserialize(file:read("*a"))
	if type(interaction_areas.interaction_areas) ~= "table" then
		interaction_areas.interaction_areas = {}
	end
	file:close()
end
function interaction_areas.print(name, message)
	minetest.chat_send_player(name, "interaction_areas: " .. message, false)
end
function interaction_areas.remove(name, interaction_area_id)
	local index_min = 1
	local index_max = 0
	if interaction_area_id == "" then
		index_min = interaction_areas.get_interaction_area_id(interaction_areas.get_player_position(name))
		index_max = index_min
	elseif tonumber(interaction_area_id) ~= nil then
		index_min = tonumber(interaction_area_id)
		index_max = index_min
	else
		index_max = table.getn(interaction_areas.interaction_areas)
	end
	if index_min == nil or index_max == nil then
		interaction_areas.print(name, "Unable to remove an interaction area from the existing interaction areas because there is no interaction area at your position")
		return
	end
	if table.getn(interaction_areas.interaction_areas) == 0 then
		interaction_areas.print(name, "Unable to remove an interaction area from the existing interaction areas because there is no existing interaction area")
		return
	end
	if index_min < 1 or index_min > table.getn(interaction_areas.interaction_areas) then
		interaction_areas.print(name, "Unable to remove an interaction area from the existing interaction areas because the interaction area ID does not correspond to an existing interaction area")
		return
	end
	for index = index_min, index_max do
		table.remove(interaction_areas.interaction_areas, index)
	end
	interaction_areas.save(name)
	interaction_areas.print(name, "Interaction area(s) removed from the existing interaction areas")
end
function interaction_areas.save(name)
	local data = minetest.serialize(interaction_areas.interaction_areas)
	if data == nil then
		interaction_areas.print(name, "Unable to serialize data")
		return
	end
	local file = io.open(interaction_areas.filename, "w")
	if file == nil then
		interaction_areas.print(name, "Unable to save data to the file " .. interaction_areas.filename)
		return
	end
	file:write(data)
	file:close()
end
function interaction_areas.show(name, interaction_area_id)
	local index_min = 1
	local index_max = 0
	if interaction_area_id == "" then
		index_min = interaction_areas.get_interaction_area_id(interaction_areas.get_player_position(name))
		index_max = index_min
	elseif tonumber(interaction_area_id) ~= nil then
		index_min = tonumber(interaction_area_id)
		index_max = index_min
	else
		index_max = table.getn(interaction_areas.interaction_areas)
	end
	if index_min == nil or index_max == nil then
		interaction_areas.print(name, "Unable to show an interaction area because there is no existing interaction area at your position")
		return
	end
	if table.getn(interaction_areas.interaction_areas) == 0 then
		interaction_areas.print(name, "Unable to show an interaction area because there is no existing interaction area")
		return
	end
	if index_min < 1 or index_min > table.getn(interaction_areas.interaction_areas) then
		interaction_areas.print(name, "Unable to show an interaction area because the interaction area ID does not correspond to an existing interaction area")
		return
	end
	interaction_areas.print(name, "id => (position_x, position_y, position_z) (dimension_x, dimension_y, dimension_z) player_name)")
	for index = index_min, index_max do
		interaction_areas.print(name, index .. " => " .. minetest.pos_to_string(interaction_areas.interaction_areas[index][1]) .. " " .. minetest.pos_to_string(interaction_areas.interaction_areas[index][2]) .. " " .. interaction_areas.interaction_areas[index][3])
	end
	interaction_areas.print(name, "Interaction area(s) shown")
end
function interaction_areas.version(name)
	interaction_areas.print(name, "interaction_areas 1.00")
	interaction_areas.print(name, "By YuGiOhJCJ <yugiohjcj@1s.fr>")
	interaction_areas.print(name, "http://yugiohjcj.1s.fr/")
end
