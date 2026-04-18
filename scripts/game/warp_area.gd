extends Area3D


@onready var removable_wall: Node3D = $RemovableWall
var is_wall_removed: bool = false


func _on_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		body.warp_backwards()
		body.increase_signal_amount(10.0)
		
		if !is_wall_removed:
			is_wall_removed = true
			removable_wall.queue_free()
