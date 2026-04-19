extends Node3D


@onready var open_trigger: Area3D = $OpenTrigger
@onready var door_animation_player: AnimationPlayer = $DoorAnimationPlayer

var door_open: bool = false


func _on_open_trigger_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		if !door_open:
			door_open = true
			door_animation_player.play("door_open")
