extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@export var SPEED: float = 5.0
@export var stop_radius: float = 1

var target_position: Vector3 = Vector3(271,1,33)

func _physics_process(_delta: float) -> void:
	
	if !Globals.Large_fuel_upg: #add future upgrade where units ignore terrain / water obstacles
		nav_agent.target_position = target_position
		
		var next_path_position := nav_agent.get_next_path_position()
		var direction := global_position.direction_to(next_path_position)
		
		velocity = direction * SPEED
		
		if nav_agent.is_navigation_finished():
			velocity = Vector3.ZERO
		
	else:
		var distance = global_transform.origin.distance_to(target_position)
		if distance > stop_radius:
			velocity = global_position.direction_to(target_position) * SPEED
			
		else:
			velocity = Vector3.ZERO
	
	move_and_slide()
	
