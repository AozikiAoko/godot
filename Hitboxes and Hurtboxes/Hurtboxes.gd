extends Area2D
#这个是受击判断使用

const hit=preload("res://Effect/hit_effect.tscn")#载入受击特效

@onready var timer=$Timer
@onready var collision=$CollisionShape2D

signal invincibility_started
signal invincibility_ended

var invincible=false:#设置无敌帧
	
	get:
		return invincible
	set(value):
		invincible=value
		if invincible==true:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")



func creat_hit_effect():#受击效果
	var hit_effect=hit.instantiate()
	var main=get_tree().current_scene
	main.add_child(hit_effect)
	hit_effect.global_position=global_position

func start_invicibility(duration):#无敌帧开始
	invincible=true
	timer.start(duration)


func _on_timer_timeout():#无敌帧结束
	invincible=false


func _on_invincibility_started():#禁止伤害检测
	collision.set_deferred("disabled",true)#这里使用物理更新就要用这个方法，原理是异步调用


func _on_invincibility_ended():#重新允许检测伤害
	collision.disabled=false
