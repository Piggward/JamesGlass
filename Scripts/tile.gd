class_name Tile
extends Node3D

enum TileState {GRASS, DRYWOOD, FIRE, MOUNTAIN}

var state = TileState.GRASS
var pos: Vector3
# neighbors
# 0 - west
# 1 - north
# 2 - east
# 3 - south
var neighbours = [null, null, null, null]

var mesh: MeshInstance3D
@onready var fire_effect: Node3D = $FireEffect
@onready var ekollon: Node3D = $Ekollon

var tile_set_number = 1
var has_ollon = false

var dry_out_rate = 2

# TODO: move to game manager
var mesh_list = [
	load("Models/%s_0.obj" % [tile_set_number]),
	load("Models/%s_1.obj" % [tile_set_number]),
	load("Models/%s_2.obj" % [tile_set_number]),
	load("Models/mountain_tile.obj")
	]
var material = load("res://Materials/MainMaterial.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = $StaticBody/Mesh
	position = pos
	scale = Vector3(2, 2, 2) # <---------- Doubles the size of the things 😇
	rotate_y(randi_range(0,3) * (PI/2)) # 90degrees  * 0-3
	render()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func render():
	mesh.mesh = mesh_list[state]
	mesh.set_surface_override_material(0, material)
	
func light_fire():
	state = TileState.FIRE
	fire_effect.visible = true
	remove_ollon()
	render()

	var dried_out_tiles = []
	# SCOPE CREEP: Use normal dist
	var tiles_to_dry_out = randi_range(1, dry_out_rate)
	var available_neighbours = neighbours.filter(func(n): return n != null && n.state not in [TileState.FIRE, TileState.DRYWOOD])
	if len(available_neighbours) == 0:
		return []

	while tiles_to_dry_out != len(dried_out_tiles) && available_neighbours != []:
		var selected_tile = randi_range(0, len(available_neighbours) - 1)
		var tile_to_dry_out = available_neighbours[selected_tile]
		tile_to_dry_out.dry_out()
		dried_out_tiles.append(tile_to_dry_out)
		available_neighbours.pop_at(selected_tile)
	
	return dried_out_tiles
	
func remove_ollon():
	if has_ollon or ekollon.visible:
		ekollon.visible = false
		has_ollon = false
	if EventManager.ollon_aquired.is_connected(_on_ollon_aquired):
		EventManager.ollon_aquired.disconnect(_on_ollon_aquired)

func dry_out():
	state = TileState.DRYWOOD
	render()
	# TODO: rosta dina ollon
	
func spawn_ollon():
	has_ollon = true
	ekollon.visible = true
	EventManager.ollon_aquired.connect(_on_ollon_aquired)
	
func _on_ollon_aquired(pos: Vector3):
	if pos == self.pos:
		remove_ollon()
		
