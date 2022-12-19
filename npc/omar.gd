extends StaticBody2D

signal start_dialog
signal hide_dialog

export var goto_position = Vector2.ZERO

onready var audio_stream = $AudioStreamPlayer2D

var isPlaying = false
var isMoving = false
var velocity = Vector2.ZERO

func _ready():
	if goto_position == Vector2.ZERO:
		goto_position = $GotoPosition.position

func _physics_process(delta):
	if global_position.distance_to(goto_position) <= 1:
		isMoving = false
	if isMoving:
		var direction = global_position.direction_to(goto_position)
		velocity = velocity.move_toward(direction * 50, 50 * delta)
		global_position += velocity.normalized()

func _on_PlayerDetection_body_entered(body):
	if !isPlaying:
		audio_stream.play()
		isPlaying = true

func _on_PlayerDetection_body_exited(body):
	if isPlaying:
		audio_stream.stop()
		isPlaying = false

func _on_MoveDetection_body_entered(body):
	if !isMoving:
		isMoving = true
		emit_signal("start_dialog")

func _on_MoveDetection_body_exited(body):
	emit_signal("hide_dialog")
