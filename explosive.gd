extends RigidBody2D

var explosionRadius = 50
var damageAmount = 5

func _process(delta):
	# Check if the item has been thrown and stopped moving
	if linear_velocity.length_squared() < 0.1:
		explode()

func explode():
	# Spawn explosion particles or animation
	# Apply damage to nearby entities within the explosion radius
	var bodies = get_world_2d().get_direct_space_state().intersect_circleshape(
		position,
		explosionRadius,
		[10],
		0, # Collision mask (adjust according to your game)
		false, # Use unfiltered results
		true # Exclude self from results
	)

	for body in bodies:
		if body.collider is CharacterBody2D:
			body.collider.apply_damage(0)

	# Optionally, queue_free() to remove the throwable item from the scene
	queue_free()
