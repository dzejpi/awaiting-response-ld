extends Node3D


@onready var red_button: Node3D = $".."
@onready var signal_scene: Node3D = $"../SignalScene"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"



func process_object_interaction() -> void:
	signal_scene.queue_free()
	audio_stream_player_3d.play()
