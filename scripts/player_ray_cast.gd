extends RayCast3D
@onready var player: Player = $".."
@onready var ollon_collector = $"../../CanvasLayer/OllonCollector"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collider = get_collider()
	if not collider:
		player.current_tile = null
		return
	var tile: Tile = collider.get_parent()
	if tile != player.current_tile:
		if player.current_tile:
			player.current_tile.set_player(false)
		player.current_tile = tile
		
		if player.current_tile:
			player.current_tile.set_player(true)
			
			if tile.neighour_to_base and ollon_collector.current > 0:
				ollon_collector._deposit_ollon()
	pass
