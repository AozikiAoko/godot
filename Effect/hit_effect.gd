extends AnimatedSprite2D


func _ready():

	connect("animation_finished",Callable(animation_finish))
	frame=0
	play("hit_effect")
	

func animation_finish():
	queue_free()

