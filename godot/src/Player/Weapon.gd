extends Node
"""
Class that handles the shooting of a raycast weapon, and spawns a decal and
fires a particle effect at the intersection of the camera raycast.
"""


onready var cooldown: Timer = $Cooldown

export var hit_effect: PackedScene
export var hit_particle: PackedScene

var ray: RayCast


func _ready() -> void:
	yield(owner, "ready")
	ray = owner.camera.get_node("RayCast")


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("fire") and cooldown.is_stopped():
		shoot()


func shoot() -> void:
	cooldown.start()
	if ray.is_colliding():
		var hit_position: = ray.get_collision_point()
		var hit_direction: = ray.get_collision_normal()
		generate_hit_effect(hit_position, hit_direction)
	owner.camera.screen_kick(2.5, 0.2)
	owner.sound.pitch_scale = 1.0 + randf() / 20.0
	owner.sound.play()


func generate_hit_effect(hit_position: Vector3, hit_direction: Vector3) -> void:
	var decal = hit_effect.instance()
	decal.set_as_toplevel(true)

	var particles: = hit_particle.instance()
	particles.set_as_toplevel(true)

	add_child(decal)
	add_child(particles)

	# Offset the position along the normal a little bit to prevent Z-fighting with the surface that got hit
	decal.look_at_from_position(hit_position + (hit_direction*0.001), hit_position + hit_direction, Vector3.UP)
	particles.global_transform.origin = hit_position
