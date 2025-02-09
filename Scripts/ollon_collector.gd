extends Control

var current: int = 0
@onready var ollon_1 = $PanelContainer/HBoxContainer/Ollon1
@onready var ollon_2 = $PanelContainer/HBoxContainer/Ollon2
@onready var ollon_3 = $PanelContainer/HBoxContainer/Ollon3
@onready var ollon_4 = $PanelContainer/HBoxContainer/Ollon4
@onready var ollon_5 = $PanelContainer/HBoxContainer/Ollon5
@onready var deposit_sound_player: AudioStreamPlayer3D = $"../../Player/DepositSoundPlayer"

var ollon_list: Array[TextureRect] = []
@onready var rescue_counter = $"../RescueCounter"
var depositing = false
@onready var panel_container = $PanelContainer

var jingles_to_play = 0
var jingles_played = 0
var playable_jingles = [
	preload("res://Sounds/leave_nut_1.wav"),
	preload("res://Sounds/leave_nut_2.wav"),
	preload("res://Sounds/leave_nut_3.wav"),
	preload("res://Sounds/leave_nut_4.wav"),
	preload("res://Sounds/leave_nut_5.wav"),
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.ollon_aquired.connect(_on_ollon_rescued)
	ollon_list.append(ollon_1)
	ollon_list.append(ollon_2)
	ollon_list.append(ollon_3)
	ollon_list.append(ollon_4)
	ollon_list.append(ollon_5)
	pass # Replace with function body.

func _on_ollon_rescued(pos: Vector3):
	if current >= ollon_list.size():
		panel_container.flicker()
		return
	ollon_list[current].modulate.a = 1
	current += 1
	
func _deposit_ollon():
	depositing = true
	if current == 0:
		return
	jingles_to_play = current
	play_jingle()
	deposit_sound_player.finished.connect(play_jingle)
	for i in current:
		var index = current - 1 - i
		var dp = ollon_list[index].duplicate()
		ollon_list[index].modulate.a = 0.32
		add_child(dp)
		var tween = create_tween().set_parallel(true)
		var random_time = randf_range(0.5, 1.5)
		tween.tween_property(dp, "position", Vector2(rescue_counter.position.x, dp.position.y), random_time)
		tween.finished.connect(func(): dp.queue_free(); rescue_counter._on_ollon_rescued())
	current = 0
	depositing = false
#func update_text():
	#self.text = "Nuts collected: " + str(rescued)

func play_jingle():
	if jingles_played == jingles_to_play:
		jingles_to_play = 0;
		jingles_played = 0;
		return 
	if jingles_to_play == 0:
		return
	var next_jingle = playable_jingles[jingles_played]
	if not deposit_sound_player.is_playing():
		deposit_sound_player.stream = next_jingle
		deposit_sound_player.play(0)
		jingles_played += 1
		
