extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909
var isConnected
	
func ConnectToServer():
	get_node("/root/Root/UI").ChangeText("This is a client")
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect")
	get_node("/root/Root/UI").ChangeInfo("Not Connected")
	
func _OnConnectionSucceeded():
	print("Successfully connected")
	isConnected = true
	get_node("/root/Root/UI").ChangeInfo("Connected!")
	get_node("/root/Root/World/Players").Local_AddPlayer()
