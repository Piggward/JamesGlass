extends Label

var rescued: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	for child in player.get_children():
		if child is Rescue:
			child.ollon_rescued.connect(_on_ollon_rescued)
	
	update_text()
	pass # Replace with function body.

func _on_ollon_rescued():
	rescued += 1
	update_text()
	
func update_text():
	self.text = "Ollon rescued: " + str(rescued)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
