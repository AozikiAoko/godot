extends Camera2D

@onready var ButtomRight=$limited/buttomRight
@onready var TopLeft=$limited/topLeft

func _ready():
	limit_left=TopLeft.position.x
	limit_top=TopLeft.position.y
	limit_right=ButtomRight.position.x
	limit_bottom=ButtomRight.position.y
	
