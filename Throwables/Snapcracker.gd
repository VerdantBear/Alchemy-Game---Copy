extends RigidBody2D

var explosion_radius = 10
var min_damage = 1
var max_damage = 3

var strength = 0
var direction = false

func _on_Snapcracker_body_entered(body):
	if body.is_in_group("enemies"):
		apply_damage(body)
	explode()

func _on_Snapcracker_area_entered(area):
	if area.is_in_group("surfaces"):
		explode()

func explode():
	# Optionally, spawn explosion particles or play an explosion animation
	queue_free()

func apply_damage(target):
	if target.is_in_group("enemies"):
		# Generate a random damage value within the specified range
		var damage = randf_range(min_damage, max_damage)
		target.apply_damage(damage)





func init(d):
	direction = d
	
func throw(imp_vec):
	strength = imp_vec
	if direction:
		strength = imp_vec
	apply_impulse(Vector2.ZERO, strength)
	
