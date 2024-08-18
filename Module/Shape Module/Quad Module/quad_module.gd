@tool
extends "res://Module/Shape Module/shape_module.gd"

func scale_update():
	var shape = BoxShape3D.new()
	shape.size = Vector3(scale_x, scale_y, scale_z)
	$CollisionShape3D.set_shape(shape)
	var mesh = BoxMesh.new()
	mesh.size = Vector3(scale_x, scale_y, scale_z)
	$MeshInstance3D.set_mesh(mesh)
	$"."["mass"] = scale_x * scale_y * scale_z
