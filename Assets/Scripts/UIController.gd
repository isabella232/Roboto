extends Node

func _ready():
	get_node("Make_Server").connect("pressed", self, "MakeServer")
	get_node("Control_Player_1").connect("pressed", self, "ControlPlayer", [1])
	get_node("Control_Player_2").connect("pressed", self, "ControlPlayer", [2])
	get_node("Control_Player_3").connect("pressed", self, "ControlPlayer", [3])

func MakeServer():
	Server.StartServer()

func ControlPlayer(index):
	Client.ConnectToServer()
	get_node("/root/Root/World/Players/Player_" + str(index)).isLocalPlayer = true

func ChangeText(newText):
	print("Change Text to: " + newText)
	get_node("ColorRect/Client_Server_Label").text = newText
	
func ChangeInfo(newText):
	print("Change Text to: " + newText)
	get_node("ColorRect/Client_Server_Info").text = newText
