extends Node

func _ready():
	get_node("Start_Server").connect("pressed", self, "StartServer")
	get_node("Connect_To_Server").connect("pressed", self, "ConnectToServer")

func StartServer():
	Server.StartServer()

func ConnectToServer():
	Client.ConnectToServer()

func ChangeText(newText):
	get_node("ColorRect/Client_Server_Label").text = newText
	
func ChangeInfo(newText):
	get_node("ColorRect/Client_Server_Info").text = newText
