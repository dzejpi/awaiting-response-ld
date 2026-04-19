extends Node3D


var debug: bool = true
@export var is_force_shut: bool = false
var can_player_unlock: bool = false
@onready var door_audio_player: AudioStreamPlayer3D = $DoorAudioPlayer
@onready var open_trigger: Area3D = $OpenTrigger
@onready var close_trigger: Area3D = $CloseTrigger
@onready var door_animation_player: AnimationPlayer = $DoorAnimationPlayer


const SFX_DOORS_CLOSE = preload("uid://cersnrrbkfuhu")
const SFX_DOORS_OPEN = preload("uid://bph0w345451n2")


func _ready() -> void:
	if is_force_shut:
		open_trigger.queue_free()
		close_trigger.queue_free()


func trigger_knocking_sound() -> void:
	pass


func open_doors() -> void:
	open_trigger.queue_free()
	door_animation_player.play("open_door")
	door_audio_player.stream = SFX_DOORS_OPEN
	door_audio_player.play()


func close_doors() -> void:
	close_trigger.queue_free()
	door_animation_player.play("close_doors")
	door_audio_player.stream = SFX_DOORS_CLOSE
	door_audio_player.play()


func _on_open_trigger_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		open_doors()


func _on_close_trigger_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		close_doors()
