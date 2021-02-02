extends Spatial

var speed = 2
var mouse_sens = 0.3
var camera_anglev=0

func _ready():
	print("Hello World!")
	var interfaces = ARVRServer.get_interfaces()
	for i in interfaces.size():
		print (interfaces[i])
		
	var VR = ARVRServer.find_interface("Native mobile")
	if VR and VR.initialize():
		get_viewport().arvr = true
		get_viewport().hdr = false

		OS.vsync_enabled = false
		Engine.target_fps = 90
	else:
		print("No VR")

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		translate_object_local($ARVRCamera.transform.basis.x * speed * delta)
	if Input.is_action_pressed("move_left"):
		translate_object_local(-$ARVRCamera.transform.basis.x * speed * delta)
	if Input.is_action_pressed("move_forward"):
		translate_object_local(-$ARVRCamera.transform.basis.z * speed * delta)
	if Input.is_action_pressed("move_backward"):
		translate_object_local($ARVRCamera.transform.basis.z * speed * delta)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x*mouse_sens))
		var changev=-event.relative.y*mouse_sens
		if camera_anglev+changev>-50 and camera_anglev+changev<50:
			camera_anglev+=changev
			$ARVRCamera.rotate_x(deg2rad(changev))
