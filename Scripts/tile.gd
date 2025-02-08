class_name Tile
extends Node3D

enum TileState {GRASS, DRYWOOD, FIRE}

var state = TileState.GRASS
var pos: Vector3
# neighbors
var n_north: Tile
var n_east: Tile
var n_south: Tile
var n_west: Tile

var mesh: MeshInstance3D

var tile_set_number = 1
var has_ollon = false

# TODO: move to game manager
var mesh_list = [
	load("Models/%s_0.obj" % [tile_set_number]),
	load("Models/%s_1.obj" % [tile_set_number]),
	load("Models/%s_2.obj" % [tile_set_number]),
	]
var material = load("res://Materials/tile_test_materialtres.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = $StaticBody/Mesh
	position = pos
	render()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func render():
	mesh.mesh = mesh_list[state]
	mesh.set_surface_override_material(0, material)
	
func light_fire():
	state = TileState.FIRE
	render()
	
