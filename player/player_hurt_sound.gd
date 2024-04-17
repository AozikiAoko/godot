extends AudioStreamPlayer2D


func _ready():
	connect("finished",Callable(queue_free))

