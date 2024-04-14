extends Node

#设置属性
@export var max_health:float=20:
	get:
		return max_health
	set(value):
		max_health=value
		set_max_health(value)
		
var health=max_health :
	get:#读取值触发
		return health
	set(value):#更新值触发
		health=value
		set_health(health)


signal none_health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	health=max_health

func set_health(value):#把生命交给set_health，更新的后值都会交给这个方法处理
	emit_signal("health_changed",health)
	if value<=0:
		emit_signal("none_health")

func set_max_health(value):
	health=min(health,value)
	emit_signal("max_health_changed", value)
	
