interaction_areas

 * Mod version: 20160223
 * Mod license: GPL 3 or later
 * Minetest version: 0.4.13
 * Mod dependencies: none
 * Report bugs or request help using my contact address

 This is a minetest mod to manage interaction areas.

 See the AUTHORS.txt file for the contact address.
 See the ChangeLog.txt file for the history of the changes.
 See the description.txt file for the description.
 See the INSTALL.txt file for the instructions on how to install.
 See the LICENSE.txt file for the license.
 See the TODO.txt file for the list of tasks left to do.

 Table of contents
  1. Privileges
  2. Commands
   2.1. Administrator commands
   2.2. User commands

 1. Privileges

  This minetest mod adds two privileges:
   * interaction_areas_admin
   * interaction_areas_user

  If you grant the interaction_areas_admin privilege to a player, he can:
   * Use the administrator interaction_areas commands (see section 2.1)
   * Interact with all interaction areas
   * Manage players of all interaction areas

  If you grant the interaction_areas_user privilege to a player, he can:
   * Use the user interaction_areas commands (see section 2.2)

  In singleplayer mode, these two privileges are enabled by default.
  You can check that by pressing the F10 key and typing: "/privs".

  In client/server mode, it is recommended to give both privileges to the server administrator(s) and only the interaction_areas_user to normal users.
  You can grant these privileges by pressing the F10 key and typing "/grant <player_name> <privilege>".
  It is recommended to edit the "minetest.conf" file of minetest to add the interaction_areas_user privilege as a default privilege: "default_privs = interact, shout, interaction_areas_user".

 2. Commands

  This minetest mod adds seven commands.
  Two of them are the administrator interaction_areas commands:
   * interaction_areas_add
   * interaction_areas_remove
  Five of them are the user interaction_areas commands:
   * interaction_areas_add_player
   * interaction_areas_help
   * interaction_areas_remove_player
   * interaction_areas_show
   * interaction_areas_version

  You can check that by pressing the F10 key and typing: "/help".
  Regarding the privileges granted to you (see section 1), you will see more or less commands.

  2.1. Administrator commands

   The interaction_areas_add command:
    * Usage: /interaction_areas_add [<position_x> [<position_y> [<position_z>]]] <owner_name> [<dimension_x> [<dimension_y> [<dimension_z>]]]
    * Description: Add an interaction area to the existing interaction areas
    * Parameters:
     * <position_x>: The X position of the interaction area (default value: The position of the player if Y and Z are not specified too)
     * <position_y>: The Y position of the interaction area (default value: The position of the player if X and Z are not specified too, else X)
     * <position_z>: The Z position of the interaction area (default value: The position of the player if X and Y are not specified too, else Y)
     * <owner_name>: The name of the player owning the interaction area
     * <dimension_x>: The X dimension of the interaction area (default value: 1)
     * <dimension_y>: The Y dimension of the interaction area (default value: X)
     * <dimension_z>: The Z dimension of the interaction area (default value: Y)

   The interaction_areas_remove command:
    * Usage: /interaction_areas_remove [<interaction_area_id> | all]
    * Description: Remove one or more interaction areas from the existing interaction areas
    * "Parameters:
     * <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)

  2.2. User commands

   The interaction_areas_add_player command:
    * Usage: /interaction_areas_add_player <player_name> [<interaction_area_id> | all]
    * Description: Add a player to one or more existing interaction areas
    * Parameters:
     * <player_name>: The name of the player to add to the interaction area(s)
     * <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)

   The interaction_areas_help command:
    * Usage: /interaction_areas_help <command>
    * Description: Show the help for an interaction_areas command
    * Parameters:
     * <command>: The command

   The interaction_areas_remove_player command:
    * Usage: /interaction_areas_remove_player <player_name> [<interaction_area_id> | all]
    * Description: Remove a player from one or more existing interaction areas
    * Parameters:
     * <player_name>: The name of the player to remove from the interaction area(s)
     * <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)

   The interaction_areas_show command:
    * Usage: /interaction_areas_show [<interaction_area_id> | all]
    * Description: Show one or more interaction areas
    * Parameters:
    * <interaction_area_id>: The ID of the interaction area (default value: The interaction area at the position of the player)

   The interaction_areas_version command:
    * Usage: /interaction_areas_version
    * Description: Show the interaction_areas version
    * Parameters: none
