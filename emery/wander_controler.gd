extends Node2D

@onready var timer=$Timer
@onready var start_position=global_position#开始游荡的位置
@onready var taget_position=global_position#结束游荡的位置

@export var wander_range:int=500#游荡范围

func _ready():
	Update_Taget_position()

func Update_Taget_position():#更新目标位置
	var taget_vector=Vector2(randi_range(-wander_range,wander_range),randi_range(-wander_range,wander_range))#指向目标位置向量量
	taget_position=start_position+taget_vector
	

func get_time_left():#获取剩余时间
	return timer.time_left
	
func set_wander_timer(duration):#参数是时间
	timer.start(duration)

	
func _on_timer_timeout():#每过一段时间就会自动更新目标位置
	Update_Taget_position()
	
