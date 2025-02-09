extends Area3D
@onready var projectile_flying: AudioStreamPlayer3D = $ProjectileFlying

@export var speed: float = 30.0  # Speed of the projectile
var direction: Vector3 = Vector3.ZERO
var target: Vector3
var my_shadow: MeshInstance3D
var target_tile: Tile
var queue_for_free = false

func _process(delta):
	if queue_for_free:
		return
	# Move the projectile in a straight line
	if target.y < position.y:
		position += direction * speed * delta
	if target.y > position.y:
		# check if hit player somehow
		print("hit")
		projectile_flying.play(0)
		target_tile.light_fire(false)
		my_shadow.visible = false
		my_shadow.queue_free()
		#visible = false
		queue_for_free = true
		# crashing sound
		projectile_flying.play()
		projectile_flying.finished.connect(kill_me)

func set_target(target_position: Vector3):
	target = target_position
	# Calculate direction toward target (player)
	#randomize target direction
	var variation = 2
	var x = randf_range(target_position.x - variation, target_position.x + variation )
	var z = randf_range(target_position.z - variation, target_position.z + variation )
	direction = (target_position - position).normalized()

func kill_me():
	queue_free()
