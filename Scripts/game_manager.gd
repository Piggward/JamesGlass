extends Node3D

const TILE_SCALE = 4

var TICK_IN_SECONDS = 1

const MAP_SIZE = 64
const RIM_SIZE = 3
const NUM_START_FIRES = 5
var tiles_map = []
var fire_tile_list = []
var dry_tile_list = []
var tile_scene = preload("res://Scenes/tile.tscn")

@onready var TIMER = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	create_map()
	create_rim()
	light_initial_fires()
	TIMER.wait_time = TICK_IN_SECONDS
	TIMER.start()
	
func create_map():
	for z in range(MAP_SIZE):
		var row = []
		for x in range(MAP_SIZE):
			var tile = tile_scene.instantiate()
			tile.has_ollon = true
			tile.pos = Vector3(x * TILE_SCALE, 0, z * TILE_SCALE)
			add_child(tile)
			row.append(tile)
		tiles_map.append(row)
		
	for z in range(MAP_SIZE):
		for x in range(MAP_SIZE):
			connect_neighbors(tiles_map[z][x])

func create_rim():
	for z in range(-RIM_SIZE, MAP_SIZE+RIM_SIZE):
		for x in range(-RIM_SIZE, MAP_SIZE+RIM_SIZE):
			if (x >= 0 && x < MAP_SIZE) && (z >= 0 && z < MAP_SIZE):
				continue
			var rim_tile = tile_scene.instantiate()
			rim_tile.state = 2
			rim_tile.pos = Vector3(x * TILE_SCALE, 0, z * TILE_SCALE)
			add_child(rim_tile)

func connect_neighbors(tile):
	var x = tile.pos.x / TILE_SCALE
	var z = tile.pos.z / TILE_SCALE
	if x > 0: # Has west neighbor
		tile.neighbours[0] = tiles_map[z][x-1]
	if x < (MAP_SIZE - 1): # Has east neighbor
		tile.neighbours[2] = tiles_map[z][x+1]
	if z > 0: # Has north neighbor
		tile.neighbours[1] = tiles_map[z-1][x]
	if z < (MAP_SIZE - 1): # Has south neighbor
		tile.neighbours[3] = tiles_map[z+1][x]

func light_initial_fires():
	for i in range(NUM_START_FIRES):
		var x = randi_range(0, MAP_SIZE-1)
		var z = randi_range(0, MAP_SIZE-1)
		
		var tile = tiles_map[z][x]
		fire_tile_list.append(tile)
		dry_tile_list.append_array(tile.light_fire())
		
func light_shit_on_fire():
	var new_dry_tile_list = []
	for dry_tile in dry_tile_list:
		new_dry_tile_list.append_array(dry_tile.light_fire())
		fire_tile_list.append(dry_tile)
	dry_tile_list = new_dry_tile_list
		
	
func _on_timer_timeout():
	light_shit_on_fire()
