extends Node2D

const grass_effect_scene = preload("res://world/GrassEffect.tscn") 

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()

func create_grass_effect():
	var grass_effect = grass_effect_scene.instance()
	grass_effect.global_position = global_position

	# Get the root main scene
	get_parent().add_child(grass_effect)
