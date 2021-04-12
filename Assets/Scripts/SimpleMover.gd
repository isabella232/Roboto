extends Spatial

export(float) var speed = 2

var isLocalPlayer = false

# Runs at 60 FPS
func _physics_process(delta):
	Local_MovePlayer(delta)
	Local_SendPlayerState({
		"T": OS.get_system_time_msecs(), 
		"P": translation
	})

# For the locally controlled instance to be moved by user input
func Local_MovePlayer(delta):
	# Only the local player should ever run this
	if isLocalPlayer:
		if Input.is_action_pressed("move_forward"):
			translate_object_local(transform.basis.z * speed * delta)
		if Input.is_action_pressed("move_backward"):
			translate_object_local(transform.basis.z * -speed * delta)

# For the locally controlled instance to update the server
func Local_SendPlayerState(playerState):
	# Only the local player should ever run this
	if isLocalPlayer && Client.isConnected:
		rpc_unreliable_id(1, "Server_ReceivePlayerState", playerState)
	
# For the server to learn about updates made by any client and relay that to all clients
remote func Server_ReceivePlayerState(playerState):
	# Only the server should ever run this
	if Server.isRunning:
		# Relay the updated player state back to all clients and the server itself
		# TODO: This will push player state to newly connected clients who haven't yet spawned the player
		# sending this state.  It will display a harmless error each tick until the player is spawned.
		rpc_unreliable_id(0, "Client_ReceivePlayerState", playerState, get_tree().get_rpc_sender_id())
	
# Runs on all clients and the server to update positions of updated player
remotesync func Client_ReceivePlayerState(playerState, requester):
	if isLocalPlayer:
		# TODO: the local player should still sync if it's off by some margin,
		# but overwriting the local player with server state is setting the
		# local player to its history a few ms ago.
		pass
	else:
		get_node("/root/Root/World/Players/" + str(requester)).transform.origin = playerState.P
