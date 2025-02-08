extends Node3D

const TILE_SCALE = 2

const MAP_SIZE = 10
const NUM_START_FIRES = 5
var tiles_map = []
var tile_scene = preload("res://Scenes/tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	create_map()
	light_initial_fires()

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
			
func connect_neighbors(tile):
	var x = tile.pos.x / TILE_SCALE
	var z = tile.pos.z / TILE_SCALE
	if x > 0: # Has west neighbor
		tile.n_west = tiles_map[z][x-1]
	if x < (MAP_SIZE - 1): # Has east neighbor
		tile.n_west = tiles_map[z][x+1]
	if z > 0: # Has north neighbor
		tile.n_west = tiles_map[z-1][x]
	if z < (MAP_SIZE - 1): # Has south neighbor
		tile.n_west = tiles_map[z+1][x]

func light_initial_fires():
	for i in range(NUM_START_FIRES):
		var x = randi_range(0, MAP_SIZE-1)
		var z = randi_range(0, MAP_SIZE-1)
		
		var tile = tiles_map[z][x]
		tile.light_fire()
		
	
