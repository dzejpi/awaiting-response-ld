extends Node3D


@export var has_dealt_damage = false
@export var hurt_amount = 10
@export var tooltip: String = ""
var original_toltip: String = ""

@onready var object_manager: Node3D = $ObjectManager


func _ready() -> void:
	original_toltip = tooltip


func interact_with_object() -> void:
	has_dealt_damage = true
	tooltip = ""
	object_manager.process_object_interaction()


func get_damage_amount():
	return hurt_amount


func get_tooltip():
	return tooltip


func get_check_was_used():
	return has_dealt_damage


func reset_state() -> void:
	has_dealt_damage = false
	tooltip = original_toltip
