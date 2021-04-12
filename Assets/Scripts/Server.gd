extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100
var concurrentPlayers = 0
var isRunning

func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	isRunning = true
	get_node("/root/Root/UI").ChangeText("This is the server")
	get_node("/root/Root/UI").ChangeInfo("Num Connected: " + str(concurrentPlayers))
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")
	concurrentPlayers = concurrentPlayers + 1
	get_node("/root/Root/UI").ChangeInfo("Num Connected: " + str(concurrentPlayers))
	
func _Peer_Disconnected(player_id):
	concurrentPlayers = concurrentPlayers - 1
	get_node("/root/Root/UI").ChangeInfo("Num Connected: " + str(concurrentPlayers))
	print("User " + str(player_id) + " disconnected.")
