extends Node3D


@onready var computer_full: Node3D = $"."
@onready var signal_scene: Node3D = $"../SignalScene"


func process_object_interaction() -> void:
	signal_scene.queue_free()
