extends Node3D


var debug: bool = true
var is_closed: bool = true
var can_player_unlock: bool = false
@onready var door_audio_player: AudioStreamPlayer3D = $DoorAudioPlayer


func _ready() -> void:
	pass


func trigger_knocking_sound() -> void:
	pass
