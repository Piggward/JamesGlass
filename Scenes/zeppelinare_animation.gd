extends Node3D
@onready var zeppelinare: Node3D = $"."
@onready var propeller_animation: AnimationPlayer = $"Zeppelinare/Propeller animation"
@onready var zeppelinare_animation_player: AnimationPlayer = $zeppelinareAnimationPlayer
@onready var propeller_ljud: AudioStreamPlayer3D = $Zeppelinare/Propeller/PropellerLjud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	propeller_animation.play("propeller_idle")
	zeppelinare_animation_player.play("zeppelinare_bobbing")
	pass # Replace with function body.

func get_propeller_ljud():
	return propeller_ljud
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
