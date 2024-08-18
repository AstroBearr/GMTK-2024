@tool
extends "res://Module/module.gd"

@export_category("Motion Module")
@export var motion_parameters : Dictionary
@export var keybinds : Array[int]

func _input(event):
	if event is InputEventKey:
		if event.keycode in keybinds:
			control_module(keybinds.find(event.keycode), event)

func control_module(_key_index : int, event : InputEventKey):
	pass

func motion_parameters_update():
	pass

func _ready():
	motion_parameters_update()
