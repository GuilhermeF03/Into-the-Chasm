class_name LevelConfigConstants

#region Constants
@export_group("Constants")

@export_subgroup("Grid")
const GRID_HEIGHT = 5
const GRID_WIDTH = 5

@export_subgroup("Tile")
const INDIVIDUAL_TILE_SIZE = 16
const ROOM_BASE_SIZE = 20
const ROOM_SCALE = 4
const GRID_TILE_SIZE = INDIVIDUAL_TILE_SIZE * ROOM_BASE_SIZE * ROOM_SCALE 

@export_group("Level")
const LEVEL_MIN_ROOMS = 5
const LEVEL_MAX_ROOMS = 7
