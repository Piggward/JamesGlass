extends Control


func _on_exit_btn_pressed():
	get_tree().quit()
	
func _on_play_again_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/player.tscn")
