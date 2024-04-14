extends Area2D


func is_collision():#判断是否
	var area=get_overlapping_areas()#获取碰撞的重叠区域
	return area.size()>0
	
func get_push_vector():
	var areas=get_overlapping_areas()
	var push_vector=Vector2.ZERO
	if is_collision():
		var area=areas[0]
		
		#获取一个从别的区域获取的位置指向这个区域位置的向量
		push_vector=area.global_position.direction_to(global_position)
		push_vector=push_vector.normalized()
		
	return push_vector
	
