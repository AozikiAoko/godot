extends Area2D

const hit=preload("res://Effect/hit_effect.tscn")#载入受击特效

@export var show_effect=true

func _on_area_entered(area):
	if show_effect:
		var hit_effect=hit.instantiate()
		var main=get_tree().current_scene
		main.add_child(hit_effect)
		hit_effect.global_position=global_position
