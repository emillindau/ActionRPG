extends KinematicBody2D

const PlayerHurtSound = preload("res://player/PlayerHurtSound.tscn")

signal player_take_damage

export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var ACCELERATION = 500
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animation_tree = $AnimationTree
onready var animation_state = $AnimationTree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blink_animation_player = $BlinkAnimationPlayer

func _ready():
	stats.connect("no_health", self, "queue_free")
	animation_tree.active = true
	$HitboxPivot/SwordHitbox/CollisionShape2D.disabled = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("game_right") - Input.get_action_strength("game_left")
	input_vector.y = Input.get_action_strength("game_down") - Input.get_action_strength("game_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		sync_animation_tree(input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("game_attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("game_roll"):
		state = ROLL

func attack_state(_delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move()
	
func move():
	# Move and slide handles the delta
	velocity = move_and_slide(velocity)

func sync_animation_tree(vector):
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Run/blend_position", vector)
	animation_tree.set("parameters/Attack/blend_position", vector)
	animation_tree.set("parameters/Roll/blend_position", vector)
	
func attack_animation_end():
	state = MOVE

func roll_animation_end():
	velocity = velocity * 0.8
	state = MOVE

func _on_Hurtbox_area_entered(area):
	emit_signal("player_take_damage")
	stats.health -= area.damage
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var player_hurt_sound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(player_hurt_sound)


func _on_Hurtbox_invincibility_started():
	blink_animation_player.play("start")


func _on_Hurtbox_invincibility_ended():
	blink_animation_player.play("stop")
