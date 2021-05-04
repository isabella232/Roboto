extends Node

var playerList = []	

# For the server to add new players when they connect.
func Server_AddPlayer(playerId):
	# Only the server can run this
	if get_tree().get_network_unique_id() != 1:
		pass
	
	# Tell the new player about players that have already spawned
	for p in playerList:
		rpc_id(playerId, "All_AddPlayer", p)
	
	# Tell all clients (and this server) to add this new player
	rpc_id(0, "All_AddPlayer", playerId)
	

# For all connected peers (including the server) to sync the added player
remotesync func All_AddPlayer(playerNetworkId):
	# If anything besides the server calls this, don't do it.
	if get_tree().get_rpc_sender_id() != 1:
		pass
		
	# Spawn the player object
	var player = load("res://Assets/Scenes/Player.tscn").instance()
	player.name = str(playerNetworkId)
	player.set_network_master(playerNetworkId)
	playerList.append(playerNetworkId)
	
	# If this is the local player, notify the player script of that
	if playerNetworkId == get_tree().get_network_unique_id():
		player.isLocalPlayer = true
	
	# Put the player object into the tree
	var playerParent = get_node("/root/Root/World/Players")
	playerParent.add_child(player)

func Server_RemovePlayer(playerId):
	# Only the server can run this
	if get_tree().get_network_unique_id() != 1:
		pass
	
	# Tell all clients (and this server) to remove this player
	rpc_id(0, "All_RemovePlayer", playerId)
	
# For all connected peers (including the server) to sync the removal of a player
remotesync func All_RemovePlayer(playerId):
	# If anything besides the server calls this, don't do it.
	if get_tree().get_rpc_sender_id() != 1:
		pass
	
	# If the player is not in the player list, do not proceed
	var indexOfPlayer = playerList.find(playerId)
	if indexOfPlayer < 0:
		print("No player found to remove")
		pass
	
	# Remove the node from the tree
	var playerToRemove = get_node("/root/Root/World/Players/" + str(playerId))
	get_node("/root/Root/World/Players").remove_child(playerToRemove)
	
	# Free the resources now that the player has been removed and is no longer needed
	playerToRemove.queue_free()
	print("Removed player " + str(playerId))
	
	# Remove the ID from the player list
	playerList.remove(indexOfPlayer)
	

