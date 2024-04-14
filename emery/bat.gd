extends CharacterBody2D

@export var BACKSPEED = 100#击退速度
@export var _ACCELERATION=300#加速度
@export var _FRICTION=400#减速度
@export var MAX_SPEED=50#最大速度
@export var taget_distance=5#离目标的距离
const death_effect=preload("res://Effect/bat_death_effect.tscn")#载入死亡特效
var dirction = Vector2.ZERO#这个是获取运动方向的
@onready var bat_stats=$Bat_Ststs#蝙蝠数值表
@onready var PlayerFounder=$PlayerDirectionZone#玩家检测区域
@onready var A_sprite=$AnimatedSprite2D#
@onready var Hurtbox=$Hurtboxes
@onready var softCollision=$SoftCollision
@onready var wandercontroler=$WanderControler


enum {
	idle,
	wander,
	chase
}
var state=idle

func _ready():
	state=pick_random_state([idle,wander])
	randomize()#生成不同的随机种子

func _physics_process(delta):
	#击退效果
	dirction=dirction.move_toward(Vector2.ZERO,BACKSPEED*delta)#减速
	velocity=dirction
	
	move_and_slide()
	
	match state:
		idle:
			dirction=dirction.move_toward(Vector2.ZERO,_FRICTION*delta)#若有速度就减速
			velocity=dirction
			seek_player() 
			
			if wandercontroler.get_time_left()==0:#如果剩余时间为0就随机选择待机或游荡状态
				Update_Timer()
				
		wander:
			seek_player()
			if wandercontroler.get_time_left()==0:
				Update_Timer()
			
			if global_position.distance_to(wandercontroler.taget_position)<=taget_distance:#抵达位置后设置，若离目标距离小就停止此次的运动
				Update_Timer()
				
			#游荡功能实现
			Move_to_Taget(delta,wandercontroler.taget_position)
							
		chase:
			var player=PlayerFounder.player#检测玩家是否在区域里存在，存在就追踪
			if player!=null:
				Move_to_Taget(delta,player.global_position)
			else:
				state=idle
			
	
	if softCollision.is_collision():#判断重叠就把重叠对象推开
		velocity+=softCollision.get_push_vector()*delta*400
	
	move_and_slide()


func seek_player():#发现玩家进入区域就会切换到追踪状态，否则就切回去
	if PlayerFounder.can_seen_player():
		state=chase

func pick_random_state(state_list):#随机状态设置
	state_list.shuffle()#将所有状态打乱(这个state_list是数组)
	return state_list.pop_front()#返回数组第一个元素

func _on_hurtboxes_area_entered(area):
	bat_stats.health=bat_stats.health-area.AttackDamage
	dirction = area.knock_back#获取来自角色攻击的方向
	dirction=dirction.normalized()*BACKSPEED#赋予击退初速度
	Hurtbox.creat_hit_effect()


func _on_bat_ststs_none_health():#设置死亡状态
	queue_free()
	var bat_death_effect=death_effect.instantiate()
	get_parent().add_child(bat_death_effect)
	bat_death_effect.global_position=global_position
	
func Update_Timer():#设置状态并重启计时器
	state=pick_random_state([idle,wander])
	wandercontroler.set_wander_timer(randi_range(1,3))
	

func Move_to_Taget(delta,taget_position):#向着某个方向移动
	var forward=global_position.direction_to(taget_position)
	dirction=dirction.move_toward(forward*MAX_SPEED,_ACCELERATION*delta)
	velocity=dirction
	A_sprite.flip_h=velocity.x<0
	
	
	
	
