extends Label

var rescued: int = 0
@onready var panel_container = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text()
	panel_container.size.x = get_viewport_rect().size.x / 6
	pass # Replace with function body.

func _on_ollon_rescued():
	rescued += 1
	EventManager.ollon_saved = rescued
	update_text()
	
func update_text():
	self.text = "Nuts secured: " + str(rescued)
