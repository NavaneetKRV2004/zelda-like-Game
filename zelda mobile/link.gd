extends CharacterBody2D

@onready var healthBar=$CanvasLayer/healthbar


var isPlayer = true
const SPEED =60.0
const chargeTime=1.0
const zoomMin=0.5
const zoomMax=4
var health:float=100.0:
	set(new_value):
		new_value=clamp(new_value,0,maxHealth)
		health=new_value
		updateHealth()
	get:
		return health
var maxHealth:float=100.0

var prev_dir:String="down"
var direction:Vector2 = Vector2.ZERO

var attacking:bool=false
var rolling:bool=false
var attackButtonPressed:bool
var attackButtonDuration=0.0
var attackButtonHeld:bool=false
var isCharging:bool=false
var isSpinning:bool=false

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var upHitbox:Vector2
@export var sideHitbox:Vector2
@export var downHitbox:Vector2

#@rpc("call_remote")
func playRpc(name:String):
	$link.play(name)

func attackBox(dir=""):
	var col=$Area2D/CollisionShape2D
#	col.position=Vector2.ZERO
#	col.disable=true
	match dir:
		"":
			col.position=Vector2.ZERO
			col.disabled=true
			return
		"up":
			col.position=upHitbox
		"side":
			col.position=sideHitbox* (-1 if $link.flip_h else 1)
		
			
		"down":
			col.position=downHitbox
	col.disabled=false
	
	
	
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	
func _ready():
	
	playRpc("stand_down")
	position=Vector2(50,50)
	set_multiplayer_authority(name.to_int())
	if not is_multiplayer_authority():
		isPlayer=false
		$CanvasLayer.free()
		$Camera2D.free()
		
	else:
		$Camera2D.enabled=true
	$link.animation_changed.connect(resetAttacking)
	$link.animation_finished.connect(resetAttacking)
	$link.animation_looped.connect(resetAttacking)
	
func _process(delta):
	
	
	if not is_multiplayer_authority(): 
		return
	$CanvasLayer/debug.text="Health: "+str(health)+"\nPosition: "+str(position)
	velocity=Vector2.ZERO
	
	rolling=Input.is_action_pressed("roll")
	attackButtonPressed=Input.is_action_just_pressed("attack")
	attackButtonHeld=Input.is_action_pressed("attack")
	
	direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	
	if direction != Vector2.ZERO and not attacking and not isSpinning:
		move()
	if not attacking and not isSpinning and direction==Vector2.ZERO: #if velocity != direction and direction==Vector2.ZERO:
		stand()
	if attackButtonPressed:
		attack()
		
	if attackButtonHeld:
		if not isSpinning:
			attackButtonDuration+=delta
		if attackButtonDuration>chargeTime and not isSpinning :
			playRpc("sword_spin")
			attackButtonDuration=0.0
			isSpinning = true
			
	else:
		attackButtonDuration=0.0
	
	
	
		
	
		
	

	move_and_slide()
	
	
func stand():
	playRpc("stand_"+ prev_dir)
	velocity=Vector2.ZERO
	
func attack():
	
	playRpc("sword_"+prev_dir)
	
	attackBox(prev_dir)
	attacking=true
		
func move():
	
	velocity = direction.normalized() * SPEED  *(2 if rolling else 1)
	if abs(velocity.x)>abs(velocity.y):
		playRpc("run_side" if not rolling else "roll_side")
		$link.flip_h=(true if velocity.x<0 else false)
		prev_dir="side"
		
	else:
		playRpc(("roll_" if rolling else "run_")+("down" if velocity.y>0 else "up"))
		$link.flip_h=false
		prev_dir="up" if velocity.y<0 else "down"

func resetAttacking():
	attackBox("")
	attacking=false
	isSpinning = false
		
		
@rpc("any_peer","call_remote")
func damage(d):
	print(name +"was damaged")
	health-=d
	
	if health<=0:
		respawn()
	else:
		rpc("playDamageAnimation")
	
	
func respawn():
	health=maxHealth
	position=Vector2(50,50)
	
func updateHealth():
	healthBar.health=roundf(health/maxHealth*100)
	
@rpc("call_local")
func playDamageAnimation():
	
	$AnimationPlayer.play("hurt")
	
func changeZoom(zoom):
	if isPlayer:
		$Camera2D.zoom.x=clamp(zoom,zoomMin,zoomMax)
		$Camera2D.zoom.y=clamp(zoom,zoomMin,zoomMax)
	
