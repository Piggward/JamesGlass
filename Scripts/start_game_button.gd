extends Button

@onready var animation_player = $"../../AnimationPlayer"


func _on_button_up():
	animation_player.play("fade_to_black")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://Scenes/player.tscn")
	pass # Replace with function body.
