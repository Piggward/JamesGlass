extends ProgressBar

var rescue: Rescue
var progress: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	for child in player.get_children():
		if child is Rescue:
			rescue = child
			
	player.rescuing_changed.connect(_on_rescuing_changed)
	self.max_value = rescue.rescue_time
	pass # Replace with function body.

func _on_rescuing_changed(value):
	if value:
		progress = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if progress:
		self.value = rescue.current_rescue_time
