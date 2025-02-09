extends Area3D

@export var speed: float = 30.0  # Speed of the projectile
var direction: Vector3 = Vector3.ZERO
var target: Vector3
var my_shadow: MeshInstance3D
var target_tile: Tile

func _process(delta):
	# Move the projectile in a straight line
	if target.y < position.y:
		position += direction * speed * delta
	if target.y > position.y:
		# check if hit player somehow
		print("hit")
		target_tile.light_fire(false)
		my_shadow.visible = false
		my_shadow.queue_free()
		queue_free()

func set_target(target_position: Vector3):
	target = target_position
	# Calculate direction toward target (player)
	#randomize target direction
	var variation = 2
	var x = randf_range(target_position.x - variation, target_position.x + variation )
	var z = randf_range(target_position.z - variation, target_position.z + variation )
	direction = (target_position - position).normalized()

func _on_body_entered(body):
	print(body)
	#TODO: remove projectile and damagee player
