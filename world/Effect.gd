extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("remove")

func _on_animation_finished():
	queue_free()
