extends CharacterBody2D

@export var BACKSPEED = 200#击退速度
@export var _ACCELERATION=300#加速度
@export var _FRICTION=400#减速度
@export var MAX_SPEED=100#最大速度
const death_effect=preload("res://Effect/bat_death_effect.tscn")#载入死亡特效
var dirction = Vector2.ZERO#这个是获取击退方向的
var SPEED_REDUCE=Vector2.ZERO#这个是变回待机状态减速用的
@onready var bat_stats=$Bat_Ststs
@onready var PlayerFounder=$PlayerDirectionZone
@onready var A_sprite=$AnimatedSprite2D
@onready var Hurtbox=$Hurtboxes
@onready var softCollision=$SoftCollision
enum {
	idle,
	wander,
	chase
}
var state=idle

func _physics_process(delta):
	#击退效果
	dirction=dirction.move_toward(Vector2.ZERO,BACKSPEED*delta)#减速
	velocity=dirction

	move_and_slide()
	
	match state:
		idle:
			SPEED_REDUCE=SPEED_REDUCE.move_toward(Vector2.ZERO,_FRICTION*delta)
			velocity=SPEED_REDUCE
			seek_player() 
		wander:
			pass
		chase:
			var player=PlayerFounder.player
			if player!=null:
				var forward=(player.global_position-global_position).normalized()
				SPEED_REDUCE=SPEED_REDUCE.move_toward(forward*MAX_SPEED,_ACCELERATION*delta)
				velocity=SPEED_REDUCE
			A_sprite.flip_h=velocity.x<0
	
	if softCollision.is_collision():#判断重叠就把重叠对象推开
		velocity+=softCollision.get_push_vector()*delta*400
	
	move_and_slide()


func seek_player():
	if PlayerFounder.can_seen_player():
		state=chase
	else:
		state=idle


func _on_hurtboxes_area_entered(area):
	bat_stats.health=bat_stats.health-area.AttackDamage
	dirction = area.knock_back#获取来自角色攻击的方向
	dirction=dirction.normalized()*BACKSPEED#赋予初速度
	Hurtbox.creat_hit_effect()


func _on_bat_ststs_none_health():#设置死亡状态
	queue_free()
	var bat_death_effect=death_effect.instantiate()
	get_parent().add_child(bat_death_effect)
	bat_death_effect.global_position=global_position
	
	
