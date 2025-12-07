@tool
extends Control
class_name selection_wheel
signal selected(index)
@export var trigger_action:String="ui_select"
@export var items_count:int=1
@export_range(0.0, 1.0,0.1) var offset_percentage:float
@export var radius:int
@export var inner_circle_color:Color
@export var inner_circle_width:int
@export var circle_color:Color
@export var line_color:Color
@export var line_width:int
@export_range(0.0, 1.0,0.1) var transparency:float
@export var AA:bool=true
@export var image_scale:float=1
@export var items:Array[Node]
@export var select_color:Color
var step_angle:float
var t=preload("res://icon.svg")
var angles=[]
var temp
var select:int=0
func _ready() -> void:
	hide()
	step_angle=2*PI/items_count
	for j in range(items_count):
		var icon=TextureRect.new()
		icon.position=(0.5+offset_percentage/2.0)*radius*Vector2(sin(step_angle*(j+0.5)),-cos(step_angle*(j+0.5)))
		add_child(icon)
		icon.name="icon"+str(items_count)
		icon.texture=t
		icon.pivot_offset=icon.size/2.0
		icon.scale=Vector2(image_scale,image_scale)/10.0
		
		
	
func _process(delta: float) -> void:
	queue_redraw()
	if Input.is_action_just_pressed(trigger_action):
		show()
		
		
		pass
	if Input.is_action_just_released(trigger_action):
		emit_signal("selected",select)
		hide()
		
		
		
	
	
func _draw() -> void:

	step_angle=2*PI/items_count
	
	
	for i in range(items_count):
		var sp:Vector2=radius*Vector2(sin(step_angle*i),-cos(step_angle*i))
		draw_line(sp,sp*offset_percentage,line_color,line_width,AA)
		
	var alpha_color=circle_color
	alpha_color.a=transparency
	draw_circle(Vector2(0,0),radius,alpha_color,true,-1,AA)
	draw_circle(Vector2(0,0),radius*offset_percentage,inner_circle_color,false,inner_circle_width,AA)
	
	temp=fmod(angle_to_mouse()+TAU,TAU)
	select=int(temp/step_angle)
	temp=select*step_angle-PI/2
	draw_arc(Vector2.ZERO,radius,temp,temp+step_angle,36,select_color,line_width*2,AA)
	


func angle_to_mouse() -> float:
	return PI+Vector2(0,1).angle_to(get_local_mouse_position())
