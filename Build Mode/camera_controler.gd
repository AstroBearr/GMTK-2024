extends Camera3D

@export var target : Node3D = null
@export var radius : float = 10.0
@export var rotation_speed : float = 1.0

var angle : float = 0.0

var mouse : Vector2 = Vector2()

func _ready():
	target = $"Megatron/Brain Module"
	

func _process(delta: float):
	
	if Input.is_action_pressed("Right"):
		angle -= rotation_speed * delta
	if Input.is_action_pressed("Left"):
		angle += rotation_speed * delta


	update_camera_position()

func update_camera_position():
	var look_at = $"..".selection
	if $"..".selection == null:
		look_at = $"../Megatron/Brain Module"
		radius = 10.0
	else:
		radius = 5.0
		
	var x = look_at.global_position.x + radius * cos(angle)
	var z = look_at.global_position.z + radius * sin(angle)
	var y = look_at.global_position.y + 5.0

	global_transform.origin = Vector3(x, y, z)
	look_at(look_at.global_position, Vector3.UP)
	
func _input(event):
	if event is InputEventMouse:
		mouse = event.position
		get_selection()
func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	params.exclude = []
	var result = worldspace.intersect_ray(params)
	if not result == {}:
		if result["collider"].is_in_group("Module"):
			target = result["collider"]
		else:
			target = null
	else:
		target = null
	
