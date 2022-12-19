extends Node2D

onready var dialog_system = $CanvasLayer/DialogSystem

func _ready():
	randomize()
	
func start_dialog(value):
	dialog_system.start_dialog(value)

func _on_Omar_start_dialog():
	start_dialog("*stance* UwU\nShokran shokran broshan!\nVem är den fattig gubba du pratar om?")

func _on_Omar_hide_dialog():
	dialog_system.hide_dialog()
