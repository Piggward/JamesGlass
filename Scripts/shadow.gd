extends MeshInstance3D
var i = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	i += 1.0
	var i_in_rad = deg_to_rad(i)
	mesh.material.albedo_color = Color(sin(i_in_rad), 0.0, 0.0, 1.0)
	print
