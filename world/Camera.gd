extends Camera2D

export var shake_amount = 0.3

onready var shake_timer = $ShakeTimer
onready var top_left_limit = $Limits/TopLeft
onready var bottom_right_limit = $Limits/BottomRight

var isShaking = false

func _ready():
	limit_top = top_left_limit.position.y
	limit_left = top_left_limit.position.x
	limit_bottom = bottom_right_limit.position.y
	limit_right = bottom_right_limit.position.x

func start_shake():
	isShaking = true
	shake_timer.start()

func _physics_process(delta):
	if isShaking:
		self.set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount))

func _on_ShakeTimer_timeout():
	isShaking = false

func _on_Player_player_take_damage():
	start_shake()
