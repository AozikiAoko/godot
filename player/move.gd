extends CharacterBody2D

@export var _ACCELERATION=400#加速度
@export var MAX_SPEED = 5
@export var _FRICTION=400#减速度
@export var ROLL_SPEED=7
var RollVector=Vector2.ZERO
var stat=PlayerStats
enum {
	MOVE,
	ROLL,
	ATTACK
}#枚举常量列出三种状态

const Player_Hurt_Sound=preload("res://player/player_hurt_sound.tscn")

var state=MOVE
@onready var Animation_Tree=$AnimationTree
@onready var Animation_State=Animation_Tree.get("parameters/playback")#获取动作状态
@onready var disable=$HitboxPivot/Hitboxes/CollisionShape2D
@onready var Hitbox=$HitboxPivot/Hitboxes
@onready var Hurtbox=$Hurtboxes
@onready var blinkPlayer=$BlinkAnimationPlayer

func _ready():
	stat.connect("none_health",Callable(queue_free))
	print(PlayerStats.health)
	print(PlayerStats.max_health)

func _physics_process(delta):
	match state:#状态机
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	
	
func move_state(delta):
	var dir=Vector2.ZERO
	
	#get_action_strength拥有表现移动力度的效果，在手柄上可以很好地体现出来
	dir.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	dir.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	
	#上面这种写法可以实现动作间的抵消效果，比如向左抵消向右的速度
	dir=dir.normalized()
	#拿到方向的单位向量
	if dir != Vector2.ZERO:
		RollVector=dir
		Hitbox.knock_back=dir#把角色朝向设为攻击方向
		Animation_Tree.set("parameters/idle/blend_position",dir)#加载待机状态
		Animation_Tree.set("parameters/run/blend_position",dir)#加载跑步状态
		Animation_Tree.set("parameters/Attack/blend_position",dir)#加载攻击状态
		Animation_Tree.set("parameters/roll/blend_position",dir)#加载翻滚状态
		Animation_State.travel("run")#进入跑步状态
		velocity=velocity.move_toward(MAX_SPEED*dir,_ACCELERATION*delta)#设置到达最大速度的变化
	else:
		Animation_State.travel("idle")#进入待机状态
		velocity=velocity.move_toward(Vector2.ZERO,_FRICTION*delta)#将velocity的速度以减速度的减少至0
	move()
	
	if Input.is_action_pressed("ui_attack"):#按下攻击转为攻击状态
		state=ATTACK
		
	if Input.is_action_pressed("ui_roll"):
		if dir!=Vector2.ZERO:
			state=ROLL
	
func move():
	move_and_collide(velocity)#按照该速度运行

func attack_state():
	velocity=Vector2.ZERO
	Animation_State.travel("Attack")
	
func Animation_Finish():#这个在动画里的方法轨道里会调用
	state=MOVE
	
func roll_state():
	velocity=RollVector*ROLL_SPEED
	Animation_State.travel("roll")
	move()
	


func _on_hurtboxes_area_entered(_area):
	stat.health-=5
	Hurtbox.start_invicibility(0.5)
	Hurtbox.creat_hit_effect()
	
	#受击音效
	var player_hurt_sound=Player_Hurt_Sound.instantiate()#实例化
	get_tree().current_scene.add_child(player_hurt_sound)#创建子节点
	



func _on_hurtboxes_invincibility_started():#在无敌帧期间闪烁
	blinkPlayer.play(("Start"))


func _on_hurtboxes_invincibility_ended():
	blinkPlayer.play("Stop")
