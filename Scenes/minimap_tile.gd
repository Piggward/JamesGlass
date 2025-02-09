class_name MinimapTile
extends ColorRect

@export var minx: float
@export var miny: float
@export var tile: Tile

# Called when the node enters the scene tree for the first time.
func _ready():
	update_color(tile)
	tile.tile_change.connect(update_color)
	self.set_custom_minimum_size(Vector2(minx, miny))
	pass # Replace with function body.


func update_color(tile: Tile):
	if tile.has_player:
		color = Color.CYAN
		return
	if tile.has_ollon:
		color = Color.GOLD
		return
		
	match (tile.state):
		Tile.TileState.MOUNTAIN:
			color = Color.GRAY
		Tile.TileState.GRASS:
			color = Color.WEB_GREEN
		Tile.TileState.DRYWOOD:
			color = Color.ORANGE
		Tile.TileState.FIRE:
			color = Color.RED
