extends Area2D

const hit_effect = preload("res://enemies/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $InvincibilityTimer
onready var collision_shape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible: 
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = hit_effect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_InvincibilityTimer_timeout():
	# setter activated when self
	self.invincible = false

func _on_Hurtbox_invincibility_ended():
	set_deferred("monitoring", true)
	collision_shape.set_deferred("disabled", false)

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)
	collision_shape.set_deferred("disabled", true)
