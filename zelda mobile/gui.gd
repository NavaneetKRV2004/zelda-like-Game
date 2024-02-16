extends CanvasLayer

@onready var check = $settings/VBoxContainer/CheckButton
@onready var sett = $settings
# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(OS.get_name())
	check.set_pressed(OS.get_name()=="Android")
	_on_check_button_toggled(check.button_pressed)
	$settings/VBoxContainer/HSplitContainer/HSlider.value=2
	

	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("settings"):
		sett.visible=not sett.visible
	if Input.is_action_just_pressed("reset zoom"):
		$settings/VBoxContainer/HSplitContainer/HSlider.value=2
func _physics_process(delta):
	if Input.is_action_pressed("zoom in"):
		$settings/VBoxContainer/HSplitContainer/HSlider.value+=0.6*delta
	if Input.is_action_pressed("zoom out"):
		$settings/VBoxContainer/HSplitContainer/HSlider.value-=0.6*delta
	


func _on_check_button_toggled(button_pressed):
	if button_pressed:
		$"Virtual Joystick".show()
		$touchbuttons.show()
	else:
		$"Virtual Joystick".hide()
		$touchbuttons.hide()


func _on_settings_button_down():
	$settings.visible=not $settings.visible


func _on_main_menu_button_up():
	get_parent().m.close()
	get_parent().m=null
	
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_quit_button_up():
	get_tree().quit()
	
func updatePlayersList(useless=null):
	$settings/players/names.clear()
	for i in get_parent().get_children(false):
			if  "isPlayer" in i :
				$settings/players/names.add_item("ID: "+i.name,null,false)


func _on_h_slider_value_changed(value):
	for i in get_parent().get_children():
		if "isPlayer" in i :
			i.changeZoom(value)


func _on_aa_toggled(button_pressed):
	print("bruh")
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d",1 if button_pressed else 0)
	


func _on_lf_toggled(button_pressed):
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d",1 if button_pressed else 0)
