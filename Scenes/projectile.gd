extends Area3D

@export var speed: float = 30.0  # Speed of the projectile
var direction: Vector3 = Vector3.ZERO

func _process(delta):
	# Move the projectile in a straight line
	position += direction * speed * delta

	#TODO: Remove projectile if outside of map
	

func set_target(target_position: Vector3):
	# Calculate direction toward target (player)
	#randomize target direction
	var variation = 2
	var x = randf_range(target_position.x - variation, target_position.x + variation )
	var z = randf_range(target_position.z - variation, target_position.z + variation )
	direction = (Vector3(x, target_position.y, z ) - global_position).normalized()

func _on_body_entered(body):
	print(body)
	#TODO: remove projectile and damagee player
