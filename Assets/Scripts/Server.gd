extends Node

var network = NetworkedMultiplayerENet.new()

var ip = "127.0.0.1"
var port = 1909
var max_players = 100
var concurrentPlayers = 0
var isServer
var isConnected
var frameCount = 0
var player_state_collection = {}
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	isServer = true
	get_node("/root/Root/UI").ChangeText("This is the server")
	get_node("/root/Root/UI").ChangeInfo("Num Connected: " + str(concurrentPlayers))
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func ConnectToServer():
	get_node("/root/Root/UI").ChangeText("This is a client")
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _physics_process(delta):
	if (isServer):
		frameCount = (frameCount + 1) % 3
		if (frameCount == 0):
			for player in player_state_collection.keys():
				SyncPlayerState(player_state_collection[player], player)
	
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")
	concurrentPlayers = concurrentPlayers + 1
	get_node("/root/Root/UI").ChangeInfo("Num Connected: " + str(concurrentPlayers))
	
func _Peer_Disconnected(player_id):
	concurrentPlayers = concurrentPlayers - 1
	get_node("/root/Root/UI").ChangeInfo("Num Connected: " + str(concurrentPlayers))
	print("User " + str(player_id) + " disconnected.")
	
func _OnConnectionFailed():
	print("Failed to connect")
	get_node("/root/Root/UI").ChangeInfo("Not Connected")
	
func _OnConnectionSucceeded():
	print("Successfully connected")
	isConnected = true
	get_node("/root/Root/UI").ChangeInfo("Connected!")
	
func SendPlayerState(playerState, requester):
	if (isConnected):
		var server_id = 1
		rpc_unreliable_id(server_id, "Server_ReceivePlayerState", playerState, requester)
	
remote func Server_ReceivePlayerState(playerState, requester):
	print("Server: " + str(playerState.P))
	var player_id = get_tree().get_rpc_sender_id()
	player_state_collection[player_id] = playerState
	get_node("/root/Root/World/Players/Player_" + str(playerState.I)).transform.origin = playerState.P
	
	
func SyncPlayerState(playerState, requester):
	rpc_unreliable_id(0, "Client_ReceivePlayerState", playerState, requester)
	
remote func Client_ReceivePlayerState(playerState, requester):
	print("Client: Got position of " + str(playerState.P) + " for player " + str(playerState.I))
	get_node("/root/Root/World/Players/Player_" + str(playerState.I)).transform.origin = playerState.P
	# translate all the clients to match the server.  Rubber band the 
	# authoritative client if necessary
