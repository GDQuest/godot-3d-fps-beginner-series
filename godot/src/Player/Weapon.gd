extends RayCast
"""
Class that handles the shooting of a raycast weapon, and spawns a decal and
fires a particle effect at the intersection of the camera raycast.
"""

signal shot

onready var cooldown: Timer = $Cooldown

export var shot_impact: PackedScene
export var shot_particles: PackedScene


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("fire") and cooldown.is_stopped():
		shoot()


func shoot() -> void:
	cooldown.start()
	if is_colliding():
		var hit_position: = get_collision_point()
		var hit_direction: = get_collision_normal()
		generate_shot_impact(hit_position, hit_direction)
	owner.sound.pitch_scale = 1.0 + randf() / 20.0
	owner.sound.play()
	emit_signal("shot")


func generate_shot_impact(hit_position: Vector3, hit_direction: Vector3) -> void:
	var decal = shot_impact.instance()
	decal.set_as_toplevel(true)

	var particles: = shot_particles.instance()
	particles.set_as_toplevel(true)

	add_child(decal)
	add_child(particles)

	# Offset the position along the normal a little bit to prevent Z-fighting with the surface that got hit
	decal.look_at_from_position(hit_position + (hit_direction*0.001), hit_position + hit_direction, Vector3.UP)
	particles.global_transform.origin = hit_position
