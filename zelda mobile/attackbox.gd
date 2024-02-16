extends Area2D

var damagedEnemiesList=[]
var parent:Node
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous fra


func _on_body_entered(body):
	if not body in damagedEnemiesList and body.name != parent.name and body.has_method("damage"):
		body.rpc("damage",10)

