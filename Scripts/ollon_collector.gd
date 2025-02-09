extends Control

var current: int = 0
@onready var ollon_1 = $HBoxContainer/Ollon1
@onready var ollon_2 = $HBoxContainer/Ollon2
@onready var ollon_3 = $HBoxContainer/Ollon3
@onready var ollon_4 = $HBoxContainer/Ollon4
@onready var ollon_5 = $HBoxContainer/Ollon5
var ollon_list: Array[TextureRect] = []
@onready var rescue_counter = $"../RescueCounter"

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
		return
	ollon_list[current].modulate.a = 1
	current += 1
	
func _deposit_ollon():
	if current == 0:
		return
		
	var dp = ollon_list[current-1].duplicate()
	ollon_list[current-1].modulate.a = 0.32
	add_child(dp)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(dp, "position", Vector2(rescue_counter.position.x, dp.position.y), 1)
	await tween.finished
	dp.queue_free()
	rescue_counter._on_ollon_rescued()
	current -= 1
	
#func update_text():
	#self.text = "Ollon collected: " + str(rescued)
