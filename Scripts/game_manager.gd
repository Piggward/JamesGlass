extends Node3D

const TILE_SCALE = 4

var TICK_IN_SECONDS = 1
var tick_counter = 0

const MAP_SIZE = 64
const RIM_SIZE = 3
const NUM_START_FIRES = 5
const MAX_OLLON = 3

var tiles_map = []
var fire_tile_list = []
var dry_tile_list = []
var ollon_tiles = []

var tile_scene = preload("res://Scenes/tile.tscn")

@onready var TIMER = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	create_map()
	create_rim()
	light_initial_fires()
	spawn_ollon()
	TIMER.wait_time = TICK_IN_SECONDS
	TIMER.start()
	
func create_map():
	for z in range(MAP_SIZE):
		var row = []
		for x in range(MAP_SIZE):
			var tile = tile_scene.instantiate()
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
			if z == -RIM_SIZE || z == MAP_SIZE+RIM_SIZE || x == -RIM_SIZE || x == MAP_SIZE+RIM_SIZE:
				rim_tile.state = 3

			rim_tile.pos = Vector3(x * TILE_SCALE, 0, z * TILE_SCALE)

			add_child(rim_tile)
			if not (z == -RIM_SIZE || z == MAP_SIZE+RIM_SIZE || x == -RIM_SIZE || x == MAP_SIZE+RIM_SIZE):
				rim_tile.fire_effect.visible = true

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
		# Get a random position on the grid
		var x = randi_range(0, MAP_SIZE-1)
		var z = randi_range(0, MAP_SIZE-1)
		
		# Get the position's distance from closets wall
		var x_dist_from_border = min(x - MAP_SIZE, MAP_SIZE - x)
		var z_dist_from_border = min(z - MAP_SIZE, MAP_SIZE - z)
		
		# Move position to closets wall
		if x_dist_from_border < z_dist_from_border:
			z = MAP_SIZE - 1 if z > MAP_SIZE/2 else 0
		elif z_dist_from_border < x_dist_from_border:
			x = MAP_SIZE - 1 if x > MAP_SIZE/2 else 0
		else:
			if randi_range(0, 1) > 0:
				z = MAP_SIZE - 1 if z > MAP_SIZE/2 else 0
			else:
				x = MAP_SIZE - 1 if x > MAP_SIZE/2 else 0
		
		var tile = tiles_map[z][x]
		fire_tile_list.append(tile)
		dry_tile_list.append_array(tile.light_fire())
		
func light_shit_on_fire():
	var new_dry_tile_list = []
	for dry_tile in dry_tile_list:
		if dry_tile.has_ollon:
			ollon_tiles.pop_at(ollon_tiles.find(dry_tile))
		new_dry_tile_list.append_array(dry_tile.light_fire())
		fire_tile_list.append(dry_tile)
	dry_tile_list = new_dry_tile_list
	
func set_fire_to_trapped_grass():
	# TODO: maybe we should just keep track of a "grass_tile_list" as well hmmmmmm :thinking:
	for i in range(MAP_SIZE):
		for j in range(MAP_SIZE):
			var tile = tiles_map[i][j]
			if tile.state != Tile.TileState.GRASS:
				continue
			var neighboring_tiles = tile.neighbours.filter(func(n): return n != null)
			if neighboring_tiles.all(func(neighbor): return neighbor.state == Tile.TileState.FIRE):
				# Surrounded by fire, so lit me up fam
				tile.light_fire() # We don't need to append dry-tiles sinces all neighbors are on fire
				fire_tile_list.append(tile)
		
	

func spawn_ollon():
	if len(ollon_tiles) == MAX_OLLON:
		return

	while len(ollon_tiles) != MAX_OLLON:
		var z = randi_range(0, MAP_SIZE-1)
		var x = randi_range(0, MAP_SIZE-1)
		var candidate_ollon_tile = tiles_map[z][x]
		if candidate_ollon_tile not in fire_tile_list:
			candidate_ollon_tile.spawn_ollon()
			ollon_tiles.append(candidate_ollon_tile)

func _on_timer_timeout():
	tick_counter += 1
	light_shit_on_fire()
	if tick_counter % 5 == 0:
		set_fire_to_trapped_grass()
	spawn_ollon()
