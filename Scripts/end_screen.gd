extends Control


@onready var animation_player = $AnimationPlayer

@onready var label = $Label
@onready var nut_amount = $NutAmount
var og_text: String
func _ready():
	animation_player.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	og_text = nut_amount.text
	nut_amount.text = nut_amount.text % str(EventManager.ollon_saved)

func _on_exit_btn_pressed():
	get_tree().quit()
	
func _on_play_again_btn_pressed():
	nut_amount.text = og_text
	get_tree().change_scene_to_file("res://Scenes/player.tscn")
