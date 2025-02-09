class_name Tile
extends Node3D

enum TileState {GRASS, DRYWOOD, FIRE, MOUNTAIN, BASE, LANDING}

var state = TileState.GRASS
var pos: Vector3
# neighbors
# 0 - west
# 1 - north
# 2 - east
# 3 - south
var neighbours = [null, null, null, null]

var has_player = false

var mesh: MeshInstance3D
@onready var fire_effect: Node3D = $FireEffect
@onready var ekollon: Node3D = $Ekollon

var tile_set_number = 1
var has_ollon = false

var dry_out_rate = 2

signal tile_change(tile: Tile)

# TODO: move to game manager
var mesh_list = [
	load("Models/%s_0.obj" % [tile_set_number]),
	load("Models/%s_1.obj" % [tile_set_number]),
	load("Models/%s_2.obj" % [tile_set_number]),
	load("Models/mountain_tile.obj"),
	load("Models/Big tree.obj"),
	load("Models/1_0.obj"),
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
	
	if state == TileState.BASE:
		scale = Vector3(4, 4, 4)
		$StaticBody/Mesh.scale = Vector3(2, 2, 2)
		$StaticBody/Mesh.position += Vector3(0, -0.5, 0)
		$StaticBody/BigTreeCollisonShape.disabled = false
		# TODO: fix me, kanske att "Tile" ska ha en gräs-mesh hela tiden?
		var tmp_ground = MeshInstance3D.new()
		tmp_ground.mesh = mesh_list[0]
		tmp_ground.set_surface_override_material(0, material)
		tmp_ground.rotate_z(PI)
		tmp_ground.position += Vector3(0, -0.06, 0)
		$StaticBody.add_child(tmp_ground)
	if state == TileState.LANDING:
		rotate_z(PI) # TODO: landing asset
		$StaticBody/CollisionShape3D.disabled = true # Disabled because the tile is flipped
	
func light_fire():
	state = TileState.FIRE
	fire_effect.visible = true
	remove_ollon()
	render()
	state_changed()

	var dried_out_tiles = []
	# SCOPE CREEP: Use normal dist
	var tiles_to_dry_out = randi_range(1, dry_out_rate)
	var available_neighbours = neighbours.filter(func(n): return n != null && n.state == TileState.GRASS)
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
		state_changed()
	if EventManager.ollon_aquired.is_connected(_on_ollon_aquired):
		EventManager.ollon_aquired.disconnect(_on_ollon_aquired)

func dry_out():
	state = TileState.DRYWOOD
	render()
	# TODO: rosta dina ollon

func are_neighbours_on_fire() -> bool:
	var on_fire_count = 0
	for neighbour in neighbours:
		if neighbour == null or neighbour.state == TileState.FIRE:
			on_fire_count += 1
	return on_fire_count == 4

func spawn_ollon():
	has_ollon = true
	ekollon.visible = true
	EventManager.ollon_aquired.connect(_on_ollon_aquired)
	state_changed()
	
func _on_ollon_aquired(pos: Vector3):
	if pos == self.pos:
		remove_ollon()
		
func state_changed():
	tile_change.emit(self)
	
func set_player(value):
	has_player = value
	state_changed()
