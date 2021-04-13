extends Node

var playerList = []

func Local_AddPlayer():
	rpc_id(1, "Server_AddPlayer")
	
remote func Server_AddPlayer():
	# Only the server can run this
	if get_tree().get_network_unique_id() != 1:
		pass
	
	# Tell the new player about players that have already spawned
	for p in playerList:
		rpc_id(get_tree().get_rpc_sender_id(), "All_AddPlayer", p)
	
	# Tell all clients to add this new player
	rpc_id(0, "All_AddPlayer", get_tree().get_rpc_sender_id())
	
	
remotesync func All_AddPlayer(playerNetworkId):
	# If anything besides the server calls this, don't do it.
	if get_tree().get_rpc_sender_id() != 1:
		pass
		
	# Spawn the player object
	var player = load("res://Assets/Scenes/Player.tscn").instance()
	player.name = str(playerNetworkId)
	player.set_network_master(playerNetworkId)
	playerList.append(playerNetworkId)
	
	# If I am the local player, I need to log that
	if playerNetworkId == get_tree().get_network_unique_id():
		player.isLocalPlayer = true
	
	# Put the player object into the tree
	var playerParent = get_node("/root/Root/World/Players")
	playerParent.add_child(player)
	
	print("Spawned player with instanceID: " + str(player.get_instance_id()) + " and network unique ID: " + str(playerNetworkId))
