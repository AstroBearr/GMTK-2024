extends Node3D

var target : Node3D =  null
@export var selection : Node3D = null
@export var drag_object : Node3D = null

var prev_mouse_pos : Vector2 = Vector2()
var mouse_pos : Vector2 = Vector2()

var rotation_sensitivity = 0.01
var movement_sensitivity = 0.01

var dragging : bool = false
var new_dragging : bool = false

enum EDIT_MODE {SELECT, MOVE, ROTATE} 
var edit_mode : EDIT_MODE = EDIT_MODE.SELECT
var old_edit_mode : EDIT_MODE = EDIT_MODE.SELECT

var quad_module = preload("res://Module/Shape Module/Quad Module/quad_module.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	target = $Camera3D.target
	#selection = $"Megatron/Brain Module"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target = $Camera3D.target
	if Input.is_action_just_released("Left Mouse Button"):
		prev_mouse_pos = Vector2()
		if new_dragging:
			edit_mode = old_edit_mode
			new_dragging = false
		dragging = false
		if edit_mode == EDIT_MODE.SELECT:
			selection = target
		
	if Input.is_action_just_pressed("Left Mouse Button"):
		if target:
			dragging = true
			drag_object = target
	if dragging:
		mouse_pos = get_viewport().get_mouse_position()
		match edit_mode:
			EDIT_MODE.ROTATE:
				rotate_mode()
			EDIT_MODE.MOVE:
				move_mode()
	else:
		prev_mouse_pos = Vector2()
		

func _would_collide(simulated_transform: Transform3D) -> bool:
	# Get the shape from the drag_object's CollisionShape3D node
	var collision_shape = drag_object.get_node("CollisionShape3D")
	if collision_shape:
		var shape = collision_shape.shape

		# Set up the collision query
		var space_state = get_world_3d().direct_space_state
		var params = PhysicsShapeQueryParameters3D.new()
		params.transform = simulated_transform
		params.shape_rid = shape.get_rid()
		params.margin = 0
		params.exclude = [drag_object]

		# Check if the shape would collide with anything
		var result = space_state.intersect_shape(params)
		return result.size() > 0

	return false


func rotate_mode():
		
	if prev_mouse_pos == Vector2():  # Initialize it to the current mouse position if it hasn't been set
		prev_mouse_pos = mouse_pos

	# Calculate mouse delta
	var mouse_delta = mouse_pos - prev_mouse_pos

	# Get the camera
	var camera = get_viewport().get_camera_3d()
	var camera_transform = camera.global_transform

	# Camera's local axes
	var camera_forward = -camera_transform.basis.z.normalized()
	var camera_right = camera_transform.basis.x.normalized()
	var camera_up = camera_transform.basis.y.normalized()
	
	# Calculate rotation amounts
	var rotation_amount_x = mouse_delta.x * rotation_sensitivity
	var rotation_amount_y = mouse_delta.y * rotation_sensitivity
	
	# Simulate the new rotation
	var simulated_transform = drag_object.global_transform
	simulated_transform.basis = simulated_transform.basis.rotated(camera_up, rotation_amount_x)
	simulated_transform.basis = simulated_transform.basis.rotated(camera_right, rotation_amount_y)
	
	# Check for collisions
	if not _would_collide(simulated_transform):
		# Apply rotation if no collision is detected
		drag_object.global_transform = simulated_transform

	# Update previous mouse position
	prev_mouse_pos = mouse_pos
	

func move_mode():
	if prev_mouse_pos == Vector2():  # Initialize it to the current mouse position if it hasn't been set
		prev_mouse_pos = mouse_pos

	# Calculate mouse delta
	var mouse_delta = mouse_pos - prev_mouse_pos

	# Get the camera
	var camera = get_viewport().get_camera_3d()
	var camera_transform = camera.global_transform

	# Camera's local axes
	var camera_right = camera_transform.basis.x.normalized()
	var camera_up = camera_transform.basis.y.normalized()
	
	# Calculate rotation amounts
	var move_amount_x = mouse_delta.x * movement_sensitivity
	var move_amount_y = mouse_delta.y * movement_sensitivity
	
	# Simulate the new rotation
	var simulated_transform = drag_object.global_transform
	simulated_transform.origin +=  Vector3(camera_up * -move_amount_y)
	simulated_transform.origin +=  Vector3(camera_right * move_amount_x)
	
	# Check for collisions
	if not _would_collide(simulated_transform):
		# Apply rotation if no collision is detected
		drag_object.global_transform = simulated_transform

	# Update previous mouse position
	prev_mouse_pos = mouse_pos

func _on_select_pressed():
	edit_mode = EDIT_MODE.SELECT
func _on_move_pressed():
	edit_mode = EDIT_MODE.MOVE
func _on_rotate_pressed():
	edit_mode = EDIT_MODE.ROTATE


func _on_quad_module_button_down():
	var obj : Node3D = quad_module.instantiate()
	
	obj["position"] = get_viewport().get_camera_3d().project_position(mouse_pos, 3)
	$Megatron.add_child(obj)
	old_edit_mode = edit_mode
	edit_mode = EDIT_MODE.MOVE
	drag_object = obj
	dragging = true
	new_dragging = true
	
	while _would_collide(obj.global_transform):
		obj["position"] += get_viewport().get_camera_3d().global_transform.basis.z.normalized()
