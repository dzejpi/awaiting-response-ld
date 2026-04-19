extends Area3D


@export var voice_number: int = 0


func _on_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		body.play_voice_message(voice_number)
		self.queue_free()
