extends KinematicBody2D

const enemy_death_effect = preload("res://enemies/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WALK,
	ATTACK
}

export var acceleration = 300
export var max_speed = 50
export var friction = 200

onready var animated_sprite = $AnimatedSprite
onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var smash_hitbox = $SmashHitbox
onready var smash_pivot = $SmashPivot

var knockback = Vector2.ZERO

var state

func _ready():
	state = IDLE
	animated_sprite.play("attack")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	if (knockback.x > 0):
		smash_pivot.rotate(1)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.start_invincibility(0.3)
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemy_death_effect_instance = enemy_death_effect.instance()
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
