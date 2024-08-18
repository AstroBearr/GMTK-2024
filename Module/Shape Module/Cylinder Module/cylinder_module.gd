@tool
extends "res://Module/Shape Module/shape_module.gd"

func scale_update():
	var shape = CylinderShape3D.new()
	shape.radius = scale_x
	shape.height = scale_y
	$CollisionShape3D.set_shape(shape)
	var mesh = CylinderMesh.new()
	mesh.top_radius = scale_x
	mesh.bottom_radius = scale_x
	mesh.height = scale_y
	$MeshInstance3D.set_mesh(mesh)
	$"."["mass"] = 3.1415 * scale_x * scale_x * scale_y
