extends Node3D


@onready var drain: Node3D = $".."
@onready var signal_scene: Node3D = $"../SignalScene"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"


var is_stopped = false
var countdown: float = 5


func _process(delta: float) -> void:
	if is_stopped:
		if countdown > 0:
			countdown -= delta
		else:
			countdown = 5
			is_stopped = false
			signal_scene.show()
			drain.reset_state()
			audio_stream_player_3d.play()


func process_object_interaction() -> void:
	signal_scene.hide()
	audio_stream_player_3d.stop()
	is_stopped = true
