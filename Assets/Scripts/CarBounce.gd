extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var speedBoost = 5
	var actualSpeed = 5 
	if Input.is_action_pressed("speed_boost"):
		actualSpeed += speedBoost
	if Input.is_action_pressed("move_right"):
		translate_object_local($ARVRCamera.transform.basis.x * actualSpeed * delta)
	if Input.is_action_pressed("move_left"):
		translate_object_local(-$ARVRCamera.transform.basis.x * actualSpeed * delta)
	if Input.is_action_pressed("move_forward"):
		translate_object_local(-$ARVRCamera.transform.basis.z * actualSpeed * delta)
	if Input.is_action_pressed("move_backward"):
		translate_object_local($ARVRCamera.transform.basis.z * actualSpeed * delta)
	if Input.is_action_pressed("move_up"):
		translate_object_local(-$ARVRCamera.transform.basis.y * actualSpeed * delta)
	if Input.is_action_pressed("move_down"):
		translate_object_local($ARVRCamera.transform.basis.y * actualSpeed * delta)
	pass
