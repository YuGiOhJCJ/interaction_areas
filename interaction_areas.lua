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
interaction_areas = {}
interaction_areas.filename = minetest.get_worldpath() .. "/interaction_areas.dat"
interaction_areas.interaction_areas = {}
function interaction_areas.add(name, position_x, position_y, position_z, owner_name, dimension_x, dimension_y, dimension_z)
	position_x = tonumber(position_x)
	position_y = tonumber(position_y)
	position_z = tonumber(position_z)
	dimension_x = tonumber(dimension_x)
	dimension_y = tonumber(dimension_y)
	dimension_z = tonumber(dimension_z)
	if position_x == nil
		and position_y == nil
		and position_z == nil then
		position_x = interaction_areas.get_player_position(name).x
		position_y = interaction_areas.get_player_position(name).y
		position_z = interaction_areas.get_player_position(name).z
	end
	if position_y == nil then
		position_y = position_x
	end
	if position_z == nil then
		position_z = position_y
	end
	if dimension_x == nil then
		dimension_x = 1
	end
	if dimension_y == nil then
		dimension_y = dimension_x
	end
	if dimension_z == nil then
		dimension_z = dimension_y
	end
	if interaction_areas.get_interaction_area_id({x = position_x, y = position_y, z = position_z}, {x = dimension_x, y = dimension_y, z = dimension_z}) ~= nil then
		interaction_areas.print(name, "Unable to add an interaction area to the existing interaction areas because there is already an existing interaction area at this position")
		return
	end
	table.insert(interaction_areas.interaction_areas, {{x = position_x, y = position_y, z = position_z}, {x = dimension_x, y = dimension_y, z = dimension_z}, owner_name, {}})
	interaction_areas.save(name)
	interaction_areas.print(name, "Interaction area added to the existing interaction areas")
end
function interaction_areas.add_player(name, player_name, interaction_area_id)
	local index_min = 1
	local index_max = 0
	if interaction_area_id == "" then
		index_min = interaction_areas.get_interaction_area_id_from_position(interaction_areas.get_player_position(name))
		index_max = index_min
	elseif tonumber(interaction_area_id) ~= nil then
		index_min = tonumber(interaction_area_id)
		index_max = index_min
	else
		index_max = table.getn(interaction_areas.interaction_areas)
	end
	if index_min == nil or index_max == nil then
		interaction_areas.print(name, "Unable to add a player to the existing interaction areas because there is no interaction area at your position")
		return
	end
	if table.getn(interaction_areas.interaction_areas) == 0 then
		interaction_areas.print(name, "Unable to add a player to the existing interaction areas because there is no existing interaction area")
		return
	end
	if index_min < 1 or index_min > table.getn(interaction_areas.interaction_areas) then
		interaction_areas.print(name, "Unable to add a player to the existing interaction areas because the interaction area ID does not correspond to an existing interaction area")
		return
	end
	for index = index_min, index_max do
		if not minetest.check_player_privs(name, {interaction_areas_admin = true}) and interaction_areas.interaction_areas[index][3] ~= name then
			interaction_areas.print(name, "Unable to add a player to the existing interaction areas because this is not your interaction area")
			return
		end
	end
	for index = index_min, index_max do
		local contains = false
		for _, value in pairs(interaction_areas.interaction_areas[index][4]) do
			if value == player_name then
				contains = true
			end
		end
		if contains == false then
			table.insert(interaction_areas.interaction_areas[index][4], player_name)
		end
	end
	interaction_areas.save(name)
	interaction_areas.print(name, "Player added to the existing interaction area(s)")
end
function interaction_areas.convert()
	for _, value in pairs(interaction_areas.interaction_areas) do
		value[1].x = tonumber(value[1].x)
		value[1].y = tonumber(value[1].y)
		value[1].z = tonumber(value[1].z)
		value[2].x = tonumber(value[2].x)
		value[2].y = tonumber(value[2].y)
		value[2].z = tonumber(value[2].z)
		value[3] = tostring(value[3])
		if table.getn(value) == 3 then
			table.insert(value, {})
		end
	end
end
function interaction_areas.get_interaction_area_id(position, dimension)
	local position_1 = position
	local offset = interaction_areas.get_offset(dimension)
	local position_2 = {x = position_1.x + dimension.x + offset.x, y = position_1.y + dimension.y + offset.y, z = position_1.z + dimension.z + offset.z}
	for key, value in pairs(interaction_areas.interaction_areas) do
		local position_3 = value[1]
		offset = interaction_areas.get_offset(value[2])
		local position_4 = {x = position_3.x + value[2].x + offset.x, y = position_3.y + value[2].y + offset.y, z = position_3.z + value[2].z + offset.z}
		if math.max(position_1.x, position_2.x) >= math.min(position_3.x, position_4.x)
			and math.min(position_1.x, position_2.x) <= math.max(position_3.x, position_4.x)
			and math.max(position_1.y, position_2.y) >= math.min(position_3.y, position_4.y)
			and math.min(position_1.y, position_2.y) <= math.max(position_3.y, position_4.y)
			and math.max(position_1.z, position_2.z) >= math.min(position_3.z, position_4.z)
			and math.min(position_1.z, position_2.z) <= math.max(position_3.z, position_4.z) then
			return key
		end
	end
	return nil
end
function interaction_areas.get_interaction_area_id_from_position(position)
	return interaction_areas.get_interaction_area_id(position, {x = 1, y = 1, z = 1})
end
function interaction_areas.get_offset(dimension)
	local offset_x = 1
	local offset_y = 1
	local offset_z = 1
	if dimension.x > 0 then
		offset_x = -offset_x
	end
	if dimension.y > 0 then
		offset_y = -offset_y
	end
	if dimension.z > 0 then
		offset_z = -offset_z
	end
	return {x = offset_x, y = offset_y, z = offset_z}
end
function interaction_areas.get_player_position(name)
	return vector.round(minetest.get_player_by_name(name):getpos())
end
function interaction_areas.help(name, command)
	if command == "interaction_areas_add" then
		interaction_areas.print(name, "Usage: /interaction_areas_add [<position_x> [<position_y> [<position_z>]]] <owner_name> [<dimension_x> [<dimension_y> [<dimension_z>]]]")
		interaction_areas.print(name, "Description: Add an interaction area to the existing interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <position_x>: The X position of the interaction area (default value: The position of the player if Y and Z are not specified too)")
		interaction_areas.print(name, " <position_y>: The Y position of the interaction area (default value: The position of the player if X and Z are not specified too, else X)")
		interaction_areas.print(name, " <position_z>: The Z position of the interaction area (default value: The position of the player if X and Y are not specified too, else Y)")
		interaction_areas.print(name, " <owner_name>: The name of the player owning the interaction area")
		interaction_areas.print(name, " <dimension_x>: The X dimension of the interaction area (default value: 1)")
		interaction_areas.print(name, " <dimension_y>: The Y dimension of the interaction area (default value: X)")
		interaction_areas.print(name, " <dimension_z>: The Z dimension of the interaction area (default value: Y)")
		interaction_areas.print(name, "Privileges: interaction_areas_admin")
	elseif command == "interaction_areas_add_player" then
		interaction_areas.print(name, "Usage: /interaction_areas_add_player <player_name> [<interaction_area_id> | all]")
		interaction_areas.print(name, "Description: Add a player to one or more existing interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <player_name>: The name of the player to add to the interaction area(s)")
		interaction_areas.print(name, " <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)")
		interaction_areas.print(name, "Privileges: interaction_areas_user")
	elseif command == "interaction_areas_help" then
		interaction_areas.print(name, "Usage: /interaction_areas_help <command>")
		interaction_areas.print(name, "Description: Show the help for an interaction_areas command")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <command>: The command")
		interaction_areas.print(name, "Privileges: interaction_areas_user")
	elseif command == "interaction_areas_remove" then
		interaction_areas.print(name, "Usage: /interaction_areas_remove [<interaction_area_id> | all]")
		interaction_areas.print(name, "Description: Remove one or more interaction areas from the existing interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)")
		interaction_areas.print(name, "Privileges: interaction_areas_admin")
	elseif command == "interaction_areas_remove_player" then
		interaction_areas.print(name, "Usage: /interaction_areas_remove_player <player_name> [<interaction_area_id> | all]")
		interaction_areas.print(name, "Description: Remove a player from one or more existing interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <player_name>: The name of the player to remove from the interaction area(s)")
		interaction_areas.print(name, " <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)")
		interaction_areas.print(name, "Privileges: interaction_areas_user")
	elseif command == "interaction_areas_show" then
		interaction_areas.print(name, "Usage: /interaction_areas_show [<interaction_area_id> | all]")
		interaction_areas.print(name, "Description: Show one or more interaction areas")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, " <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)")
		interaction_areas.print(name, "Privileges: interaction_areas_user")
	elseif command == "interaction_areas_version" then
		interaction_areas.print(name, "Usage: /interaction_areas_version")
		interaction_areas.print(name, "Description: Show the interaction_areas version")
		interaction_areas.print(name, "Parameters:")
		interaction_areas.print(name, "Privileges: interaction_areas_user")
	else
		interaction_areas.print(name, "Unable to show the help for an interaction_areas command because the command does not correspond to an existing command")
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
	interaction_areas.convert()
end
function interaction_areas.print(name, message)
	minetest.chat_send_player(name, "interaction_areas: " .. message, false)
end
function interaction_areas.remove(name, interaction_area_id)
	local index_min = 1
	local index_max = 0
	if interaction_area_id == "" then
		index_min = interaction_areas.get_interaction_area_id_from_position(interaction_areas.get_player_position(name))
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
	for index = index_max, index_min, -1 do
		table.remove(interaction_areas.interaction_areas, index)
	end
	interaction_areas.save(name)
	interaction_areas.print(name, "Interaction area(s) removed from the existing interaction areas")
end
function interaction_areas.remove_player(name, player_name, interaction_area_id)
	local index_min = 1
	local index_max = 0
	if interaction_area_id == "" then
		index_min = interaction_areas.get_interaction_area_id_from_position(interaction_areas.get_player_position(name))
		index_max = index_min
	elseif tonumber(interaction_area_id) ~= nil then
		index_min = tonumber(interaction_area_id)
		index_max = index_min
	else
		index_max = table.getn(interaction_areas.interaction_areas)
	end
	if index_min == nil or index_max == nil then
		interaction_areas.print(name, "Unable to remove a player from the existing interaction areas because there is no interaction area at your position")
		return
	end
	if table.getn(interaction_areas.interaction_areas) == 0 then
		interaction_areas.print(name, "Unable to remove a player from the existing interaction areas because there is no existing interaction area")
		return
	end
	if index_min < 1 or index_min > table.getn(interaction_areas.interaction_areas) then
		interaction_areas.print(name, "Unable to remove a player from the existing interaction areas because the interaction area ID does not correspond to an existing interaction area")
		return
	end
	for index = index_min, index_max do
		if not minetest.check_player_privs(name, {interaction_areas_admin = true}) and interaction_areas.interaction_areas[index][3] ~= name then
			interaction_areas.print(name, "Unable to remove a player from the existing interaction areas because this is not your interaction area")
			return
		end
	end
	for index = index_min, index_max do
		local key = interaction_areas.table_get_key_from_value(interaction_areas.interaction_areas[index][4], player_name)
		if key ~= nil then
			table.remove(interaction_areas.interaction_areas[index][4], key)
		end
	end
	interaction_areas.save(name)
	interaction_areas.print(name, "Player removed from the existing interaction area(s)")
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
		index_min = interaction_areas.get_interaction_area_id_from_position(interaction_areas.get_player_position(name))
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
	interaction_areas.print(name, "ID => (position_x, position_y, position_z) owner_name (dimension_x, dimension_y, dimension_z) player_name, ...")
	for index = index_min, index_max do
		interaction_areas.print(name, index .. " => " .. minetest.pos_to_string(interaction_areas.interaction_areas[index][1]) .. " " .. interaction_areas.interaction_areas[index][3] .. " " .. minetest.pos_to_string(interaction_areas.interaction_areas[index][2]) .. " " .. table.concat(interaction_areas.interaction_areas[index][4], ", "))
	end
	interaction_areas.print(name, "Interaction area(s) shown")
end
function interaction_areas.table_get_key_from_value(my_table, my_value)
	for key, value in pairs(my_table) do
		if value == my_value then
			return key
		end
	end
	return nil
end
function interaction_areas.version(name)
	interaction_areas.print(name, "interaction_areas 20170822")
	interaction_areas.print(name, "By YuGiOhJCJ <yugiohjcj@1s.fr>")
	interaction_areas.print(name, "http://yugiohjcj.1s.fr/")
end
