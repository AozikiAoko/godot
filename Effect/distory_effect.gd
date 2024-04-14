extends AnimatedSprite2D


func _ready():#播放动画
	connect("animation_finished",Callable(_animation_finished))
	frame=0
	play("GrassAnimate")
	


func _animation_finished():
	queue_free()
