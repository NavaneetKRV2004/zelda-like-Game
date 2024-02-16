extends Node2D
var m:ENetMultiplayerPeer=null
var a=preload("res://link.tscn")
# Called when the node enters the scene tree for the first time.
var players=[]


func _ready():
#	print("---------\n"+encode("192.168.1.19"))
#	print(encode("12.23.52.45"))
#	print(decode("ABABABAB"))
#	print(decode("ZBB")+"\n---------")
	
	
	m=ENetMultiplayerPeer.new()
	var temp=IP.get_local_addresses()
	var temp2=""
	for i in temp:
		if i.begins_with("192.168."):
			temp2=i
			
	temp2=encode(temp2)
			
	$gui/Panel/VBoxContainer/hostip.text=temp2
	
	$gui/touchbuttons/attack.button_down.connect(Input.action_press.bind("attack"))
	$gui/touchbuttons/attack.button_up.connect(Input.action_release.bind("attack"))
#	$gui/touchbuttons/attack.pressed.connect(Input.is_action_press("attack"))
#
	$gui/touchbuttons/roll.button_down.connect(Input.action_press.bind("roll"))
	$gui/touchbuttons/roll.button_up.connect(Input.action_release.bind("roll"))
	#$gui/touchbuttons/roll.pressed.connect(Input.is_action_pressed("roll"))
	
func _process(delta):
	pass
	
		

func _on_host_button_up():
	m.peer_connected.connect(addPlayer)
	m.peer_disconnected.connect(removePlayer)
	m.create_server(6969)
	multiplayer.multiplayer_peer=m
	$gui/Panel.hide()
	addPlayer(1)
	
	
	


func _on_join_button_up():
	
	$gui/Panel/VBoxContainer/ip.text=rectify($gui/Panel/VBoxContainer/ip.text)
	var t:String=$gui/Panel/VBoxContainer/ip.text

	if not decode(t).is_valid_ip_address():
		print("Invalid IP: "+decode(t))
		return
	
	m.create_client(decode(t),6969)#"localhost" if t == "" else t,6969)
	multiplayer.multiplayer_peer=m
	multiplayer.server_disconnected.connect(server_gone)
	
	$gui/Panel.hide()
	addPlayer(m.get_unique_id())
	
func addPlayer(id):
	$gui.updatePlayersList()
	if m.get_unique_id()==1:
		print("adding player" +str(id) )
	var b=a.instantiate()
	
	b.name=str(id)
	b.position=Vector2(-1,-1)
	
	add_child(b)

func server_gone():
	m=null
	get_tree().change_scene_to_file("serverDisconnected.tscn")
	
	
func encode(ipa):
	var ip=ipa.split(".")
	if len(ip) != 4:
		push_error("ip has more than 4 numbers")
		return null
	var str2=""
	for i in ip:
		str2+=AA(int(i))
	if str2.substr(0,6)=="HKGMAB":
		return "Z"+str2[6]+str2[7];
	else:
		return str2
		
func decode(ipa:String):
	ipa=ipa.to_upper()
	if len(ipa)==3 and ipa[0]=="Z" and tff(ipa[1]+ipa[2])<256:
		return "192.168.1."+str(tff(ipa[1]+ipa[2]))
	elif(len(ipa)==8):
		var p=""
		for i in [0,2,4,6]:
			p+=str(tff(ipa[i]+ipa[i+1]))+"."
		p=p.rstrip(".")
		return p
	elif ipa =="":
		return "127.0.0.1"
			
	
	
func AA(num:int) -> String:
	if num>255:
		push_error(str(num)+"num above 255")
		return "AA"
	var sec=num/26
	var fir=num%26
	sec=char(65+sec)
	fir=char(65+fir)
	var str1=sec+fir
	return str1
	
func tff(code:String) -> int:
	if len(code)>2:
		print("too long")
		return -1
	var fir=code[0].to_ascii_buffer()[0]-65
	var sec=code[1].to_ascii_buffer()[0]-65
	var t= fir*26+sec
	if t>255:
		push_error(str(t)+"num above 255")
		return 255
	else:
		return t
	
	
func rectify(st:String):
	st=st.to_upper()
	var t=""
	for i in st:
		if i in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
			t+=i
	if t=="":
		return ""
	return t
	

func removePlayer(id:int):
	var no=get_node_or_null(str(id))
	if no != null:
		remove_child(no)
