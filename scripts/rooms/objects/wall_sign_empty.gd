extends Node3D


@export_multiline var sign_text: String = ""
@onready var sign_label: Label3D = $SignLabel


func _ready() -> void:
	sign_label.text = sign_text
