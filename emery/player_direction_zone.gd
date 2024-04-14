extends Area2D
#用于检测玩家是否存在监视范围的脚本
var player=null

func can_seen_player():
	return player!=null


func _on_body_entered(body):
	player=body


func _on_body_exited(body):
	player=null
