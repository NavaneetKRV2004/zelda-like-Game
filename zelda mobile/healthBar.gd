@tool
extends Node2D


var maxSize:float=302.0
@export var health:=100:
	set(new_value):
		health=clamp(new_value,0,100)
		#$red.size.x=health*(maxSize-2)/100.0
	get:
		return health
	

func _ready():
	$white.size.x=maxSize
	health=100


	
	
	
func _process(delta):
	$red.size.x=lerpf($red.size.x,health/100.0*(maxSize-2),0.1)
	
	


