extends Node

var controlledPlayer = 0


func _ready():
	get_node("Make_Server").connect("pressed", self, "MakeServer")
	get_node("Control_Player_1").connect("pressed", self, "ControlPlayer", [1])
	get_node("Control_Player_2").connect("pressed", self, "ControlPlayer", [2])
	get_node("Control_Player_3").connect("pressed", self, "ControlPlayer", [3])

func MakeServer():
	Server.StartServer()

func ControlPlayer(playerId):
	Client.ConnectToServer()
	print("Setting controlled player to " + str(playerId))
	controlledPlayer = playerId

func ChangeText(newText):
	print("Change Text to: " + newText)
	get_node("ColorRect/Client_Server_Label").text = newText
	
func ChangeInfo(newText):
	print("Change Text to: " + newText)
	get_node("ColorRect/Client_Server_Info").text = newText
