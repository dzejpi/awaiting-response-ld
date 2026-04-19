extends Node3D


func _on_signal_10_body_entered(body: Node3D) -> void:
	adjust_signal_reception(body, 10.0)


func _on_signal_10_body_exited(body: Node3D) -> void:
	adjust_signal_reception(body, 0.0)


func _on_signal_25_body_entered(body: Node3D) -> void:
	adjust_signal_reception(body, 25.0)


func _on_signal_25_body_exited(body: Node3D) -> void:
	adjust_signal_reception(body, 10.0)


func _on_signal_50_body_entered(body: Node3D) -> void:
	adjust_signal_reception(body, 50.0)


func _on_signal_50_body_exited(body: Node3D) -> void:
	adjust_signal_reception(body, 25.0)


func _on_signal_75_body_entered(body: Node3D) -> void:
	adjust_signal_reception(body, 75.0)


func _on_signal_75_body_exited(body: Node3D) -> void:
	adjust_signal_reception(body, 50.0)


func _on_signal_100_body_entered(body: Node3D) -> void:
	adjust_signal_reception(body, 100.0)


func _on_signal_100_body_exited(body: Node3D) -> void:
	adjust_signal_reception(body, 75.0)


func adjust_signal_reception(body: Node3D, amout: float) -> void:
	if body.name == "PlayerScene":
		body.change_receiving_signal_amount(amout)
