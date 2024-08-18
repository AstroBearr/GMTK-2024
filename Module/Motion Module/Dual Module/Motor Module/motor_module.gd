@tool
extends "res://Module/Motion Module/Dual Module/dual_module.gd"

func motion_parameters_update():
	$HingeJoint3D["motor/target_velocity"] = 0

func control_module(_key_index : int, event : InputEventKey):
	var key_index = _key_index
	if key_index == 0:
		pass
	match key_index:
		0:
			if (event.pressed):
				$HingeJoint3D["motor/max_impulse"] = 1.0
				$HingeJoint3D["motor/enable"] = true
				$HingeJoint3D["motor/target_velocity"] = motion_parameters["speed"]
				$Shaft.position.y += 0.001
			else:
				$HingeJoint3D["motor/target_velocity"] = 0
				$HingeJoint3D["motor/enable"] = false
				$HingeJoint3D["motor/max_impulse"] = 0.0
				$Shaft.angular_velocity = Vector3.ZERO
				
