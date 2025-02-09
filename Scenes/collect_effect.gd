extends Node3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func emit_collect_effect():
	gpu_particles_3d.emitting=true
