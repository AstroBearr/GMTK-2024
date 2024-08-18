@tool
extends "res://Module/Shape Module/shape_module.gd"

func paint_update():
	$MeshInstance3D.get_active_material(0).albedo_color =  Color(1, 0, 0)
