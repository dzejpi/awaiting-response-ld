extends Area3D


var is_game_won_triggered: bool = false


func _on_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		if !is_game_won_triggered:
			is_game_won_triggered = true
			body.trigger_game_won()
			self.queue_free()
