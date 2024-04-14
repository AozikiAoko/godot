extends Control


var hearts=20:#设置生命值
	get:
		return hearts
	set(value):
		hearts=clamp(value,0,max_hearts)
		set_hearts(value)

var max_hearts=20:#最大生命值
	get:
		return max_hearts
	set(value):
		max_hearts=max(value,1)#限定最大生命值
		set_maxheart(max_hearts)
		
@onready var heartUI_Full=$HeartUIFull
@onready var hearUI_Empty=$HeartUIEmpty

func set_hearts(hearts):#限定生命值范围,并设置更新ui
	if heartUI_Full!=null:
		heartUI_Full.size.x=hearts*15
	
func set_maxheart(value):#更新最大生命值ui
	value=min(value,max_hearts)
	if hearUI_Empty!=null:
		hearUI_Empty.size.x=value*15
		
	

func _ready():
	max_hearts=PlayerStats.max_health
	hearts=PlayerStats.health
	PlayerStats.connect("health_changed",Callable(set_hearts))
	PlayerStats.connect("max_health_changed",Callable(set_maxheart))
