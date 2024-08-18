@tool
extends Node3D

@export_category("Health")
@export var health : int
@export var max_health : int

@export_category("Scale")
@export var scale_x : float
@export var scale_y : float
@export var scale_z : float

var time_accumulator : float = 0.0
var is_build = true

func _ready():
	scale_update()
	paint_update()
	$"."["freeze"] = true

func scale_update():
	pass
func paint_update():
	pass
func _process(delta):
	if Engine.is_editor_hint():
		time_accumulator += delta
		if time_accumulator >= 5.0:
			time_accumulator = 0.0
			scale_update()
			paint_update()
