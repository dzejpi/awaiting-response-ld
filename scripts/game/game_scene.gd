extends Node3D


@export var debug: bool = false
@export var child_count_countdown: float = 1
var current_child_count_countdown: float = child_count_countdown

# Ceilings
@onready var ceiling_a: Node3D = $Rooms/RoomA/Ceiling
@onready var ceiling_b: Node3D = $Rooms/RoomB/Ceiling
@onready var ceiling_c: Node3D = $Rooms/RoomC/Ceiling
@onready var ceiling_d: Node3D = $Rooms/RoomD/Ceiling
@onready var ceiling_e: Node3D = $Rooms/RoomE/Ceiling
@onready var ceiling_f: Node3D = $Rooms/RoomF/Ceiling
@onready var ceiling_g: Node3D = $Rooms/RoomG/Ceiling

# Player
@onready var player_scene: CharacterBody3D = $PlayerScene

var current_signal: float = 0
var is_game_over: bool = false


func _ready() -> void:
	show_all_ceilings()


func _process(delta: float) -> void:
	if debug:
		if current_child_count_countdown > 0:
			current_child_count_countdown -= delta
		else:
			current_child_count_countdown = child_count_countdown
			print("Game nodes: " + str(get_child_count()))
			
	check_signal_amount()


func show_all_ceilings() -> void:
	ceiling_a.show()
	ceiling_b.show()
	ceiling_c.show()
	ceiling_d.show()
	ceiling_e.show()
	ceiling_f.show()
	ceiling_g.show()


func check_signal_amount() -> void:
	if current_signal >= 100 && !is_game_over:
		is_game_over = true
		player_scene.trigger_game_over()
