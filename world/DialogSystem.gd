extends Node2D

var dialog_text = "" setget set_dialog_text

onready var text = $Panel/RichTextLabel
onready var panel = $Panel
onready var dialog_timer = $DialogTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	panel.visible = false

func set_dialog_text(value):
	panel.visible = true
	dialog_text = value
	text.text = dialog_text
	dialog_timer.start()

func hide_dialog():
	panel.visible = false

func start_dialog(value):
	set_dialog_text(value)

func _on_DialogTimer_timeout():
	pass
	# hide_dialog()
