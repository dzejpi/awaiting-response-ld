extends Node3D


@export var has_dealt_damage = false
@export var hurt_amount = 10
@export var tooltip: String = ""

@onready var object_manager: Node3D = $ObjectManager


func interact_with_object() -> void:
	has_dealt_damage = true
	tooltip = ""


func get_damage_amount():
	return hurt_amount


func get_tooltip():
	return tooltip


func get_check_was_used():
	return has_dealt_damage
