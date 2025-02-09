extends SpotLight3D

var burn: Burn
var progress: bool
var wait_for_cd: bool
const max_energy = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	for child in player.get_children():
		if child is Burn:
			burn = child
			
	player.burning_changed.connect(_on_burning_changed)
	pass # Replace with function body.

func _on_burning_changed(value):
	if value:
		progress = true
	else:
		wait_for_cd = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if progress:
		self.light_energy = max_energy * (burn.current_burn_time / burn.max_burn_time)
		if wait_for_cd and self.light_energy == 0:
			progress = false
			wait_for_cd = false
