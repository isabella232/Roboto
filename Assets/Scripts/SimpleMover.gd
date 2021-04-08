extends Spatial

export(float) var speed = 2

var playerId

func _ready():	
	playerId = int(self.name.split("_")[1])
	return

func _physics_process(delta):
	if (playerId == get_node("/root/Root/UI").controlledPlayer):
		if Input.is_action_pressed("move_forward"):
			translate_object_local(transform.basis.z * speed * delta)
		if Input.is_action_pressed("move_backward"):
			translate_object_local(transform.basis.z * -speed * delta)
		Server.SendPlayerState({
			"T": OS.get_system_time_msecs(), 
			"I": playerId,
			"P": translation
		}, get_instance_id())
	pass
