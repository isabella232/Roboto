extends Spatial

export(float) var speed = 2

var playerId

func _ready():	
	playerId = int(self.name.split("_")[1])
	return

func isLocalPlayer():
	return playerId == get_node("/root/Root/UI").controlledPlayer

func _physics_process(delta):
	
	# If this instance is the locally controlled player.
	if isLocalPlayer():
		
		# Move the player with user input
		if Input.is_action_pressed("move_forward"):
			translate_object_local(transform.basis.z * speed * delta)
		if Input.is_action_pressed("move_backward"):
			translate_object_local(transform.basis.z * -speed * delta)
		
		# Send the player state to the server every frame
		Local_SendPlayerState({
			"T": OS.get_system_time_msecs(), 
			"I": playerId,
			"P": translation
		}, get_instance_id())

# For the locally controlled instance to update the server
func Local_SendPlayerState(playerState, requester):
	# Only the local player should run this
	if isLocalPlayer() && Client.isConnected:
		rpc_unreliable_id(1, "Server_ReceivePlayerState", playerState, requester)
	
# For the server to learn about updates made by any client, update it's own state 
# and tell all clients about the update
remote func Server_ReceivePlayerState(playerState, requester):
	# Only the server should ever run this
	if Server.isRunning:
		get_node("/root/Root/World/Players/Player_" + str(playerState.I)).transform.origin = playerState.P
		rpc_unreliable_id(0, "Client_ReceivePlayerState", playerState, requester)
	
# For all the clients to receive the player states from the server and update accordingly
remote func Client_ReceivePlayerState(playerState, requester):
	if Server.isRunning:
		# The server should never execute this 
		pass
	
	# No need to update the local player state. TODO: should still check the 
	# player and server are closely in sync
	if playerId != get_node("/root/Root/UI").controlledPlayer:
		get_node("/root/Root/World/Players/Player_" + str(playerState.I)).transform.origin = playerState.P
