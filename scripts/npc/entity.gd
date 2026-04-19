extends Node3D


@onready var monster_animation_player: AnimationPlayer = $MonsterAnimationPlayer

var is_shown: bool = false
var player: Node3D = null


func _ready() -> void:
	# Find player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	# Make entity invisible
	hide()


func _process(delta: float) -> void:
	if !is_shown:
		global_transform = player.get_node("EntitySpawn").global_transform


func uncover_entity() -> void:
	if !is_shown:
		is_shown = true
		show()
		
		monster_animation_player.play("jump")
