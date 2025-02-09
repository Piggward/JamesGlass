class_name MinimapTile
extends ColorRect

@export var minx: float
@export var miny: float
@export var tile: Tile

var green = "#2f4d2f" 
var brown = "#7a5859" 
var red = "#b55945" 
var gold = "#de9f47" 
var gray = "#d5d6db"
# Called when the node enters the scene tree for the first time.
func _ready():
	update_color(tile)
	tile.tile_change.connect(update_color)
	self.set_custom_minimum_size(Vector2(minx, miny))
	pass # Replace with function body.


func update_color(tile: Tile):
	if tile.has_player:
		color = Color(gold)
		return
	if tile.has_ollon:
		color = Color(brown)
		return
		
	match (tile.state):
		Tile.TileState.MOUNTAIN:
			color = Color(gray)
		Tile.TileState.GRASS:
			color = Color(green)
		Tile.TileState.DRYWOOD:
			color = Color(red)
		Tile.TileState.FIRE:
			color = Color(red)
