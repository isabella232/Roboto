extends Spatial

export(float) var speed = 2

var isLocalPlayer = false

# Runs at 60 FPS
func _physics_process(delta):
	Local_MovePlayer(delta)
	Local_SendPlayerState({
		"T": OS.get_system_time_msecs(), 
		"P": translation
	}, get_instance_id())

# For the locally controlled instance to be moved by user input
func Local_MovePlayer(delta):
	# Only the local player should ever run this
	if isLocalPlayer:
		if Input.is_action_pressed("move_forward"):
			translate_object_local(transform.basis.z * speed * delta)
		if Input.is_action_pressed("move_backward"):
			translate_object_local(transform.basis.z * -speed * delta)

# For the locally controlled instance to update the server
func Local_SendPlayerState(playerState, requester):
	# Only the local player should ever run this
	if isLocalPlayer && Client.isConnected:
		rpc_unreliable_id(1, "Server_ReceivePlayerState", playerState, requester)
	
# For the server to learn about updates made by any client and relay that to all clients
remote func Server_ReceivePlayerState(playerState, requester):
	# Only the server should ever run this
	if Server.isRunning:
		# Relay the updated player state back to all clients and the server itself
		rpc_unreliable_id(0, "Client_ReceivePlayerState", playerState, requester)
	
# Runs on all clients and the server to update positions of updated player
remotesync func Client_ReceivePlayerState(playerState, requester):
	if isLocalPlayer:
		# TODO: the local player should still sync if it's off by some margin,
		# but overwriting the local player with server state is setting the
		# local player to its history a few ms ago.
		pass
	else:
		instance_from_id(requester).transform.origin = playerState.P
