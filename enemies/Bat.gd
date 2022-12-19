extends KinematicBody2D

export var acceleration = 300
export var max_speed = 50
export var friction = 200

const enemy_death_effect = preload("res://enemies/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

onready var stats = $Stats
onready var animated_sprite = $AnimatedSprite
onready var player_detection_zone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var soft_collison = $SoftCollision
onready var wander_controller = $WanderController
onready var animation_player = $AnimationPlayer

func _ready():
	animated_sprite.play("fly")

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			handle_non_chase_state()
		WANDER:
			move_to_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= 1:
				# or random state
				state = IDLE
			handle_non_chase_state()
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				move_to_point(player.global_position, delta)
			else:
				state = IDLE

	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	if soft_collison.is_colliding():
		velocity += soft_collison.get_push_vector() * delta * 400
	knockback = move_and_slide(knockback)
	velocity = move_and_slide(velocity)
	

func move_to_point(target_position, delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite.flip_h = velocity.x < 0

func handle_non_chase_state():
	seek_player()
	if wander_controller.get_time_left() == 0: 
		wander_controller.start_wander_timer(rand_range(1, 3))
		state = pick_random_state([IDLE, WANDER])

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	# Will call the setter
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.start_invincibility(0.3)
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemy_death_effect_instance = enemy_death_effect.instance()
	get_parent().add_child(enemy_death_effect_instance)
	enemy_death_effect_instance.global_position = global_position

func _on_Hurtbox_invincibility_ended():
	animation_player.play("stop");


func _on_Hurtbox_invincibility_started():
	animation_player.play("start")
