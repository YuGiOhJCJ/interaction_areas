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
function minetest.is_protected(pos, name)
	if minetest.check_player_privs(name, {interaction_areas = true}) then
		return false
	end
	local interaction_area_id = interaction_areas.get_interaction_area_id(pos)
	if interaction_area_id == nil then
		interaction_areas.print(name, "Unable to interact because this is not an interaction area")
		return true
	elseif interaction_areas.interaction_areas[interaction_area_id][3] == name then
		return false
	else
		interaction_areas.print(name, "Unable to interact because this is not your interaction area")
		return true
	end
end
