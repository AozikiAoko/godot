extends Node
class_name stat

#设置属性
@export var max_health:float=1
@onready var health=max_health :
	get:#读取值触发
		return health
	set(value):#更新值触发
		health=value
		set_health(health)


signal none_health

func set_health(value):#把生命交给set_health，更新的后值都会交给这个方法处理
	if value<=0:
		emit_signal("none_health")

