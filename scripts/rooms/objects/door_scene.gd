extends Node3D


var debug: bool = true
@export var is_force_shut: bool = false
var can_player_unlock: bool = false
@onready var door_audio_player: AudioStreamPlayer3D = $DoorAudioPlayer
@onready var open_trigger: Area3D = $OpenTrigger
@onready var close_trigger: Area3D = $CloseTrigger
@onready var door_animation_player: AnimationPlayer = $DoorAnimationPlayer


func _ready() -> void:
	if is_force_shut:
		open_trigger.queue_free()
		close_trigger.queue_free()


func trigger_knocking_sound() -> void:
	pass


func open_doors() -> void:
	open_trigger.queue_free()
	door_animation_player.play("open_door")


func close_doors() -> void:
	close_trigger.queue_free()
	door_animation_player.play("close_doors")


func _on_open_trigger_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		open_doors()


func _on_close_trigger_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		close_doors()
