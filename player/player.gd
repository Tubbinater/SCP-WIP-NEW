extends Node3D

signal province_selected

#Nodes
@onready var camera: Camera3D = $Camera3D

#Camera move
@export_range(0,1000,1) var camera_move_speed:float = 350.0
#adjust position speed based on zoom distance
@onready var camera_move_speed_adjusted_w_zoom:float = camera_move_speed + abs(camera.position.y)
#change speed based on player shift input (change in function, not here)
var camera_shift_speed:int = 1

#Camera rotate
var camera_rotation_direction:float = 0
@export_range(0,10,0.1) var camera_rotation_speed:float = 0.20
@export_range(0,20,1) var camera_base_rotation_speed:float = 6

#Camera pan
@export_range(0,32,4) var camera_automatic_pan_margin:int = 16
@export_range(0,20,0.5) var camera_automatic_pan_speed:float = 18

#Camera zoom
var camera_zoom_direction:float = 0
@export_range(0,1000,1) var camera_zoom_speed:float = 1000.0
@export_range(-100,100,1) var camera_zoom_min:float = -70
@export_range(0,1000,1) var camera_zoom_max:float = 10
@export_range(0,2,.1) var camera_zoom_speed_damp:float = 0.92

#flags
var camera_can_process:bool = true
var camera_can_move_base:bool = true
var camera_can_zoom:bool = true
var camera_can_automatic_pan:bool = false
var camera_can_rotate_base:bool = true
var camera_can_rotate_socket_x:bool = true
var camera_can_rotate_by_mouse_offfset:bool = true

#Internal flag
var camera_is_rotating_base:bool = false
var camera_is_rotating_mouse:bool = false
var mouse_last_position:Vector2 = Vector2.ZERO



func _ready() -> void:
	camera_zoom_min = 10
	camera_zoom_max = 150
	
func _process(delta:float) -> void:
	if !camera_can_process: return
	camera_base_move(delta)
	camera_zoom_update(delta)
	camera_automatic_pan(delta)
	camera_base_rotate(delta)


#Moves the base of camera
func camera_base_move(delta:float) -> void:
	if !camera_can_move_base: return
	var velocity_direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("camera_forward"): velocity_direction -= transform.basis.z
	if Input.is_action_pressed("camera_backward"): velocity_direction += transform.basis.z
	if Input.is_action_pressed("camera_right"): velocity_direction += transform.basis.x
	if Input.is_action_pressed("camera_left"): velocity_direction -= transform.basis.x
	
	if Input.is_action_pressed("shift_click"): camera_shift_speed = 2
	else: camera_shift_speed = 1
	
	#adjust camera speed based on zoom distance and shift input
	camera_move_speed_adjusted_w_zoom = (camera_move_speed + camera.position.y) * camera_shift_speed
	
	position += velocity_direction.normalized() * camera_move_speed_adjusted_w_zoom  * delta


func _unhandled_input(event: InputEvent) -> void:
	
		## Exit
	if Input.is_action_pressed("Exit"):
		get_tree().quit()
	
	
	#Camera Zoom
	if event.is_action("camera_zoom_in"):
		camera_zoom_direction = 1
	elif  event.is_action("camera_zoom_out"):
		camera_zoom_direction = -1
	
	#Camera rotations
	if event.is_action_pressed("camera_rotate_right"):
		camera_rotation_direction = -1
		camera_is_rotating_base = true
	elif event.is_action_pressed("camera_rotate_left"):
		camera_rotation_direction = 1
		camera_is_rotating_base = true
	elif event.is_action_released("camera_rotate_left") or event.is_action_released("camera_rotate_right"):
		camera_is_rotating_base = false
		
	if event.is_action_pressed("camera_rotate"):
		mouse_last_position = get_viewport().get_mouse_position()
		camera_is_rotating_mouse = true
	elif event.is_action_released("camera_rotate"):
		camera_is_rotating_mouse = false
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shoot_ray()


func camera_zoom_update(delta:float) -> void:
	#if !camera_can_zoom:return
	#
	#var new_zoom:float = clamp(camera.position.z + camera_zoom_speed * -(camera_zoom_direction) * delta, camera_zoom_min, camera_zoom_max)
	#
	#camera.position.z = new_zoom
	#camera_zoom_direction *= camera_zoom_speed_damp
	#########################################
	
	if !camera_can_zoom: return

	var zoom_amount = camera_zoom_speed * -camera_zoom_direction * delta
	
	# Move the socket instead of the camera itself
	var new_pos = camera.position
	new_pos.y = clamp(
		new_pos.y + zoom_amount,
		camera_zoom_min,
		camera_zoom_max
	)
	camera.position = new_pos

	camera_zoom_direction *= camera_zoom_speed_damp



#Rotates the camera base
func camera_base_rotate(delta:float) -> void:
	if !camera_can_rotate_base or !camera_is_rotating_base : return
	
	#To rotate
	camera_base_rotate_left_right(delta, camera_rotation_direction * camera_base_rotation_speed)


#Rotates the camera speed left or right
func camera_base_rotate_left_right(delta:float, dir:float) -> void:
	rotation.y += dir * camera_rotation_speed * delta
	
# Pans the camera automatically based on screen margins
func camera_automatic_pan(delta:float) -> void:
	if !camera_can_automatic_pan: return
	
	var viewport_current:Viewport = get_viewport()
	var pan_direction:Vector2 = Vector2(1,1) #Starts negative
	var viewport_visible_rectangle:Rect2i = Rect2i(viewport_current.get_visible_rect())
	var viewport_size:Vector2i = viewport_visible_rectangle.size
	var current_mouse_position:Vector2 = viewport_current.get_mouse_position()
	var margin:float = camera_automatic_pan_margin #Shortcut var
	
	var zoom_factor:float = position.y * 0.1
	
	#X pan
	if ((current_mouse_position.x < margin) or (current_mouse_position.x > viewport_size.x - margin)):
		if current_mouse_position.x > viewport_size.x/2.0:
			pan_direction.x = -1
		global_translate(Vector3(pan_direction.x * delta * camera_automatic_pan_speed * zoom_factor,0,0))
	
	#Y pan
	if ((current_mouse_position.y < margin) or (current_mouse_position.y > viewport_size.y - margin)):
		if current_mouse_position.y > viewport_size.y/2.0:
			pan_direction.y = -1
		global_translate(Vector3(0, 0, pan_direction.y * delta * camera_automatic_pan_speed * zoom_factor))
		


func shoot_ray(): #https://forum.godotengine.org/t/get-mouse-position-not-aligh-towards-the-edge-of-screen/108126/18
	var mouse_position = get_viewport().get_mouse_position()
	var target_plane_mouse = Plane(-camera.global_basis.z,0)
	var from = camera.project_ray_origin(mouse_position)
	var dir = camera.project_ray_normal(mouse_position)
	var cursor_position_on_plane = target_plane_mouse.intersects_ray(from,dir)
	if cursor_position_on_plane:
		province_selected.emit(Vector2(cursor_position_on_plane.x,cursor_position_on_plane.z))
