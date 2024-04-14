extends Node2D

const  Use_Grass_Effect=preload("res://Effect/grass_distory_effect.tscn")#载入
		
func Grass_Effect():
	var Grass_Effect=Use_Grass_Effect.instantiate()#引用	
	get_parent().add_child(Grass_Effect)#在父类下创建为子节点
	Grass_Effect.global_position=global_position#获取草的位置并添加
	


func _on_hurtboxes_area_entered(area):#检测到hurtbox有东西进入就执行
	Grass_Effect()
	queue_free()
