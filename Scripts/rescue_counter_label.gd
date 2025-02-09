extends Label

var rescued: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text()
	pass # Replace with function body.

func _on_ollon_rescued(pos: Vector3):
	rescued += 1
	update_text()
	
func update_text():
	self.text = "Ollon collected: " + str(rescued)
