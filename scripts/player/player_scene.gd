extends CharacterBody3D


const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

@onready var player_camera: Camera3D = $PlayerHead/Camera
@onready var ray_cast: RayCast3D = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var typewriter_dialog: Node2D = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip: Node2D = $PlayerUI/GameUI/PlayerTooltip

@onready var game_over_scene: Node2D = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene: Node2D = $PlayerUI/GameEnd/GameWonScene
@onready var color_rect: ColorRect = $PlayerHead/Camera/CanvasLayer/ColorRect
@onready var color_rect_signal: ColorRect = $PlayerUI/GameUI/ColorRect
@onready var noise_player: AudioStreamPlayer2D = $NoisePlayer


@export var is_fov_dynamic: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity: float = 0.75
@export var controller_sensitivity: float = 16.0

# Mouse movement
var mouse_delta: Vector2 = Vector2.ZERO

# Fov variables
var base_fov: float = 90.0
var increased_fov: float = 94.0
var current_fov: float = base_fov
var fov_change_speed: float = 5.0

# Debug for console info
var debug: bool = true

# Last collider player looked at
var last_looked_at: String = ""

var current_signal_amount: float = 0.0
var current_signal_receiving: float = 0.0

# Targets
var current_signal_amount_target: float = 0.0
var current_signal_receiving_target: float = 0.0


func _ready() -> void:
	GlobalVar.reset_game()
	player_camera.fov = current_fov
	TransitionOverlay.fade_out()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	noise_player.playing = true


func _input(event: InputEvent) -> void:
	if GlobalVar.is_game_active:
		if event is InputEventMouseMotion:
			mouse_delta = event.relative


func _process(delta: float) -> void:
	# Not processing at all if the game isn't active
	if not GlobalVar.is_game_active:
		return
	
	check_signal_amount()
	adjust_shader()
	
	# Smooth signal interpolation
	adjust_signals(delta)


func _physics_process(delta: float) -> void:
	# Not processing at all if the game isn't active
	if not GlobalVar.is_game_active:
		return
	
	# Camera movement
	adjust_camera(delta)
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = 0
	velocity.z = 0
	
	var speed_multiplier: float = 1.0
	if Input.is_action_pressed("move_sprint"): 
		speed_multiplier = 2.0
	
	velocity.x = direction.x * SPEED * speed_multiplier
	velocity.z = direction.z * SPEED * speed_multiplier
	
	if is_fov_dynamic:
		if speed_multiplier > 1.0:
			increase_fov(delta)
		else:
			decrease_fov(delta)
	
	move_and_slide()
	process_collisions()


func adjust_camera(delta: float) -> void:
	# Controller input
	var look_x := Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var look_y := (Input.get_action_strength("look_down") - Input.get_action_strength("look_up")) / 2
	var controller_look := Vector2(look_x, look_y) * controller_sensitivity
	
	# Mouse movement
	rotation_degrees.y -= (mouse_delta.x * mouse_sensitivity * delta * 60) / 10
	
	var look := mouse_delta + controller_look
	rotation_degrees.y -= (look.x * mouse_sensitivity * delta * 60) / 10
	player_camera.rotation_degrees.x = clamp(player_camera.rotation_degrees.x - (look.y * mouse_sensitivity * delta * 60) / 10, -90, 90)
	
	# Reset mouse delta
	mouse_delta = Vector2.ZERO
	controller_look = Vector2.ZERO


func process_collisions() -> void:
	if ray_cast.is_colliding():
		var collision_object: String = ray_cast.get_collider().name
		
		if collision_object == "InteractiveObject":
			var collision_item = ray_cast.get_collider()
			var was_object_used: bool = collision_item.get_parent().get_check_was_used()
			var damage_amount: float = collision_item.get_parent().get_damage_amount()
			
			if Input.is_action_just_pressed("object_interact"):
				if !was_object_used:
					collision_item.get_parent().interact_with_object()
					increase_signal_amount(damage_amount)
					change_receiving_signal_amount(0.0)
					player_tooltip.dismiss_tooltip()
		
		if collision_object != last_looked_at:
			last_looked_at = collision_object
			
			if collision_object == "InteractiveObject":
				var object = ray_cast.get_collider()
				var new_tooltip: String = object.get_parent().get_tooltip()
				player_tooltip.display_tooltip(new_tooltip, false)
			else:
				player_tooltip.dismiss_tooltip()
			
			if debug:
				print("Player is looking at: " + collision_object + ".")
	else:
		if last_looked_at != "nothing":
			last_looked_at = "nothing"
			player_tooltip.dismiss_tooltip()
			
			if debug:
				print("Player is looking at: nothing.")


func trigger_game_over() -> void:
	GlobalVar.toggle_game_over()
	game_over_scene.show_game_over()
	player_tooltip.dismiss_tooltip()


func trigger_game_won() -> void:
	GlobalVar.toggle_game_over()
	game_won_scene.show_game_won()
	player_tooltip.dismiss_tooltip()


func increase_fov(delta: float) -> void:
	current_fov = player_camera.fov
	current_fov = min(current_fov + fov_change_speed * delta, increased_fov)
	change_fov(current_fov)


func decrease_fov(delta: float) -> void:
	current_fov = player_camera.fov
	current_fov = max(current_fov - fov_change_speed * delta * 8, base_fov)
	change_fov(current_fov)


func change_fov(new_fov: float) -> void:
	player_camera.fov = new_fov


func warp_backwards() -> void:
	print("Warping player")
	global_position = global_position + Vector3(-48, 0, 0)


func increase_signal_amount(increased_amount: float) -> void:
	current_signal_amount_target += increased_amount
	#print("Signal increased to: " + str(current_signal_amount))


func change_receiving_signal_amount(increased_amount: float) -> void:
	current_signal_receiving_target = increased_amount
	#print("Signal reception changed to: " + str(current_signal_receiving))


func check_signal_amount() -> void:
	if current_signal_amount >= 100:
		trigger_game_over()


func adjust_shader() -> void:
	var signal_normalised = clamp(current_signal_amount / 100.0, 0.0, 1.0)
	var received_signal_normalised = clamp(current_signal_receiving / 100.0, 0.0, 1.0)
	color_rect.material.set_shader_parameter("signal_strength", signal_normalised)
	color_rect_signal.material.set_shader_parameter("signal_strength", received_signal_normalised)
	

func adjust_signals(delta: float) -> void:
	var adjustment_speed = 2
	
	current_signal_amount = lerp(current_signal_amount, current_signal_amount_target, adjustment_speed * delta)
	current_signal_receiving = lerp(current_signal_receiving, current_signal_receiving_target, adjustment_speed * delta)
	#print("Signal amount: " + str(current_signal_amount) + ", signal receiving: " + str(current_signal_receiving))
	
	# Noise sound level
	var current_signal_receiving_target_converted = current_signal_receiving_target / 100
	var current_signal_receiving_target_normalised = clamp(current_signal_receiving_target_converted, 0.0, 1.0)
	
	var db_value: float
	if current_signal_receiving_target_normalised <= 0.001:
		db_value = -80.0
	else:
		db_value = linear_to_db(current_signal_receiving_target_normalised)
	
	#print("db_value: " + str(db_value))
	noise_player.volume_db = db_value
