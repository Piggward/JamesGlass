extends Node3D

const TILE_SCALE = 4

var TICK_IN_SECONDS = 1
var tick_counter = 0

const MAP_SIZE = 63
const RIM_SIZE = 3
const NUM_START_FIRES = 5
const MAX_OLLON = 30

var tiles_map = []
var fire_tile_list = []
var dry_tile_list = []
var ollon_tiles = []
var projectiles = []

var tile_scene = preload("res://Scenes/tile.tscn")
@onready var control = $CanvasLayer/SubViewportContainer/SubViewport/Control

var projectile_scene = preload("res://Scenes/projectile.tscn")
var projectile_shadow_scene = preload("res://Scenes/shadow.tscn")
var base_tile_position: Vector3

@onready var TIMER = $Timer
@onready var bg_music: AudioStreamPlayer = $BG_MUSIC

var music_by_intesity = [
	preload("res://Sounds/main-1.wav"),
	preload("res://Sounds/main-2.wav"),
	preload("res://Sounds/main-3.wav"),
	preload("res://Sounds/main-4.wav")
]

var mesh_list = [
	preload("res://Models/1_0.obj"),
	preload("res://Models/1_1.obj"),
	preload("res://Models/1_2.obj"),
	preload("res://Models/2_0.obj"),
	preload("res://Models/2_1.obj"),
	preload("res://Models/2_2.obj"),
	preload("res://Models/3_0.obj"),
	preload("res://Models/3_1.obj"),
	preload("res://Models/3_2.obj"),
	preload("res://Models/4_0.obj"),
	preload("res://Models/4_1.obj"),
	preload("res://Models/4_2.obj"),
	preload("res://Models/mountain_tile.obj"),
	preload("res://Models/Big tree.obj"),
	preload("res://Models/1_0.obj"),
	]

func size() -> int:
	return MAP_SIZE * 8
# Called when the node enters the scene tree for the first time.
func _ready():
	var start = Time.get_ticks_usec()
	print("Game manager ready: ", start/1000000.0)
	create_map()
	var end = Time.get_ticks_usec()
	print("Map created: ", (end)/1000000.0)
	create_rim()
	end = Time.get_ticks_usec()
	print("Rim created: ", (end)/1000000.0)
	light_initial_fires()
	print("Initial fires lit")
	spawn_ollon()
	print("Ollon spawned")
	
	#spawn_projectile()
	TIMER.wait_time = TICK_IN_SECONDS
	TIMER.start()
	control.create_mini_map()
	print("Minimap created")
	bg_music.stream = preload("res://Sounds/main-1.wav")
	bg_music.finished.connect(change_or_loop_music)
	bg_music.play(0)

	
	
func spawn_projectiles():
	var number = randi_range(1,3)
	for i in range(number):
		spawn_projectile()


func spawn_projectile():
	var player = get_parent().get_node("Player")
	# Generate a random spawn position
	#var spawn_x = randi_range(0, MAP_SIZE * TILE_SCALE)
	#var spawn_z = randi_range(0, MAP_SIZE * TILE_SCALE)
	#var spawn_position = Vector3(spawn_x, 64, spawn_z)
#
	##randomize target direction
	#print("player position", player.current_tile)
	#var variation = 10
	#var selected_target_tile = player.current_tile
	#var too_close_to_base = true
	#while too_close_to_base:
		#if base_tile_position.distance_to(selected_target_tile.position) < 4*TILE_SCALE:
			#selected_target_tile = selected_target_tile.select_random_neighbour()
		#else:
			#too_close_to_base = false
#
	#var neighbours_left_to_explore = randi_range(0, 2)
	#while neighbours_left_to_explore > 0:
		#selected_target_tile = selected_target_tile.select_random_neighbour()
		#if selected_target_tile.state in [0, 1]:
			#neighbours_left_to_explore -= 1
#
	#var shadow = projectile_shadow_scene.instantiate()
	#add_child(shadow)
	#shadow.position = Vector3(
		#selected_target_tile.position.x, 
		#selected_target_tile.position.y + 0.5,
		#selected_target_tile.position.z,
	#) 
	## Instantiate projectile
	#var projectile = projectile_scene.instantiate()
	#add_child(projectile)
#
	## Set position and target
	#projectile.position = spawn_position
	#projectile.set_target(shadow.position)  # Set direction
	#projectile.my_shadow = shadow
	#projectile.target_tile = selected_target_tile

func create_map():
	var middle_of_map = (MAP_SIZE - 1) / 2
	for z in range(MAP_SIZE):
		var row = []
		for x in range(MAP_SIZE):
			var tile = tile_scene.instantiate()
			var tile_set_number = randi_range(0, 3)
			tile.mesh_list = mesh_list.slice(tile_set_number*3, tile_set_number*3+4)
			if z == x && z == middle_of_map: # Big Tree in the middle
				tile.state = Tile.TileState.BASE
				tile.mesh_list.append(mesh_list[13])
				tile.mesh_list.append(mesh_list[13])
			tile.pos = Vector3(x * TILE_SCALE, 0, z * TILE_SCALE)
			add_child(tile)
			row.append(tile)
		tiles_map.append(row)
	
	print("-- Initial pass: ", Time.get_ticks_usec()/1000000.0)
	for z in range(MAP_SIZE):
		for x in range(MAP_SIZE):
			connect_neighbors(tiles_map[z][x])
	print("-- Second pass: ", Time.get_ticks_usec()/1000000.0)
	
	# TODO: move me, I dont really belong here
	# Det är för att göra tiledsen runtom BigTree som safeareas
	var base_tile = tiles_map[middle_of_map][middle_of_map]
	base_tile_position = base_tile.position
	if base_tile.state == Tile.TileState.BASE: 
		var mid = (MAP_SIZE - 1) / 2
		var additional_safe_tiles = [
			tiles_map[mid + 1][mid + 1],
			tiles_map[mid + 1][mid - 1],
			tiles_map[mid - 1][mid - 1],
			tiles_map[mid - 1][mid + 1],
		]
		for neighbor in (base_tile.neighbours + additional_safe_tiles):
			neighbor.state = Tile.TileState.LANDING
			neighbor.mesh_list.append(mesh_list[14])
			neighbor.mesh_list.append(mesh_list[14])
			neighbor.render()
			for add_neighbor in neighbor.neighbours:
				if add_neighbor not in additional_safe_tiles && add_neighbor != base_tile:
					add_neighbor.mesh_list.append(mesh_list[14])
					add_neighbor.mesh_list.append(mesh_list[14])
					add_neighbor.state = Tile.TileState.LANDING
					add_neighbor.render()
	print("-- Middle Tree pass: ", Time.get_ticks_usec()/1000000.0)
	

func create_rim():
	for z in range(-RIM_SIZE, MAP_SIZE+RIM_SIZE):
		for x in range(-RIM_SIZE, MAP_SIZE+RIM_SIZE):
			if (x >= 0 && x < MAP_SIZE) && (z >= 0 && z < MAP_SIZE):
				continue
			var rim_tile = tile_scene.instantiate()
			rim_tile.mesh_list = mesh_list.slice(0, 5)
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
	var i = 5 + floor(tick_counter/3) + floor(tick_counter/11)
	var n = 0
	var random_weight_point = Vector3(
		[0, round(MAP_SIZE/2), MAP_SIZE].pick_random(),
		0,
		[0, round(MAP_SIZE/2), MAP_SIZE].pick_random()
	)
	dry_tile_list.shuffle()
	#shuffled_dry_list.sort_custom(
	#	func(n, c): return n.pos.distance_to(random_weight_point) < c.pos.distance_to(random_weight_point)
	#)
	for dry_tile in dry_tile_list:
		if i == n:
			break
		n += 1
		if dry_tile.has_ollon:
			ollon_tiles.pop_at(ollon_tiles.find(dry_tile))
		dry_tile_list.append_array(dry_tile.light_fire())
		fire_tile_list.append(dry_tile)
	for k in range(0, n-1):
		dry_tile_list.pop_front()
	
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
		if candidate_ollon_tile not in fire_tile_list and not candidate_ollon_tile.are_neighbours_on_fire():
			candidate_ollon_tile.spawn_ollon()
			ollon_tiles.append(candidate_ollon_tile)

func _on_timer_timeout():
	tick_counter += 1
	light_shit_on_fire()
	if tick_counter % 5 == 0:
		set_fire_to_trapped_grass()
	if tick_counter % 5 == 0:
		spawn_projectiles()
	spawn_ollon()
	

func change_or_loop_music():
	var amount_of_fire = float(len(fire_tile_list)) / float((MAP_SIZE * MAP_SIZE))
	#print("this much fire", amount_of_fire)
	#print("this many fire tiles", len(fire_tile_list))
	#print("this map size", (MAP_SIZE * MAP_SIZE))
	if amount_of_fire > 0.5 && bg_music.stream != music_by_intesity[3]:
		bg_music.stream = music_by_intesity[3]
	elif amount_of_fire > 0.25 && bg_music.stream != music_by_intesity[2]:
		bg_music.stream = music_by_intesity[2]
	elif amount_of_fire > 0.1 && bg_music.stream != music_by_intesity[1]:
		bg_music.stream = music_by_intesity[1]
	if not bg_music.is_playing():
		bg_music.play(0)
