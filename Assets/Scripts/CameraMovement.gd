extends Spatial

var speed = 2
var mouse_sens = 0.3
var camera_anglev=0

enum VR_MODE { NONE, NATIVE_MOBILE, OPEN_VR }

export(VR_MODE) var vrMode = VR_MODE.NONE

func _ready():	
	
	if vrMode == VR_MODE.NONE:
		print("No VR")
		return
	
	var VR = ARVRServer.find_interface(getVRModeString(vrMode))
	if VR and VR.initialize():
		get_viewport().arvr = true
		get_viewport().hdr = false

		OS.vsync_enabled = false
		Engine.target_fps = 90
	else:
		printerr("Unable to use selected VR interface, falling back to No VR")		
	return

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
			
func getVRModeString(vrMode):
	if vrMode == VR_MODE.OPEN_VR:
		return "OpenVR"
	elif vrMode == VR_MODE.NATIVE_MOBILE:
		return "Native mobile"	
		
