extends Camera2D

@onready var path =get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path.progress+=delta*100


func _on_node_2d_child_entered_tree(node):
	if "isPlayer" in node:
		enabled=false
