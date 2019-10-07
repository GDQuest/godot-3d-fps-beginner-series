extends Node

"""
This is the main script for the Demo scene.  This accepts a signal
from the player to generate a decal at a set position with a rotation
that points along the raycast's collision normal.

Feedback is appreciated.
"""


export var hit_effect: PackedScene
export var hit_particle: PackedScene

var ray: RayCast


func _unhandled_input(event) -> void:
	if not ray:
		ray = owner.camera.get_node("RayCast")
	if event.is_action_pressed("fire") and ray.is_colliding():
		shoot()


func shoot() -> void:
	owner.camera.screen_kick(2.5, 0.3)
	var hit_position: Vector3 = ray.get_collision_point()
	var hit_direction: Vector3 = ray.get_collision_normal()
	generate_hit_effect(hit_position, hit_direction)
	generate_hit_particle(hit_position, hit_direction)
	owner.sound.play()


func generate_hit_effect(hit_position: Vector3, hit_direction: Vector3) -> void:
	var temp = hit_effect.instance()
	#note: we offset along the normal a little bit to prevent Z-fighting with the surface that got hit
	temp.look_at_from_position(hit_position + (hit_direction*0.001), hit_position + hit_direction, Vector3.UP)
	get_tree().root.add_child(temp)


func generate_hit_particle(hit_position: Vector3, hit_direction: Vector3) -> void:
	var temp = hit_particle.instance()
	temp.global_transform.origin = hit_position
	get_tree().root.add_child(temp)