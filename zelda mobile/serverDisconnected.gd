extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation=str(randi_range(1,2))
	



func _on_button_button_up():
	get_tree().change_scene_to_file("res://node_2d.tscn")
