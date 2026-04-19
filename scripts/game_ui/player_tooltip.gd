extends Node2D


@onready var tooltip_label: Label = $TooltipLabel
@onready var tooltip_label_voice: Label = $TooltipLabelVoice

var flashing_speed: float = 1
var is_flashing: bool = false
var is_flashing_up: bool = true
var is_tooltip_visible: bool = false
var is_voice_tooltip_visible: bool = false
var action_required: String = ""
var auto_dismiss_time: float = 0.0
var auto_voice_dismiss_time: float = 0.0


func _ready() -> void:
	# Tooltip off by default
	dismiss_tooltip()
	dismiss_voice_tooltip()


func _process(delta) -> void:
	if is_flashing:
		var current_modulation: float = modulate.a
		if is_flashing_up:
			if current_modulation < 1.0:
				modulate.a = min(modulate.a + (flashing_speed * delta), 1.0)
			else:
				modulate.a = 1.0
				is_flashing_up = false
		else:
			if current_modulation > 0.0:
				modulate.a = max(modulate.a - (flashing_speed * delta), 0.0)
			else:
				modulate.a = 0.0
				is_flashing_up = true
	
	# Auto dismiss (if set)
	if auto_dismiss_time > 0.0:
		auto_dismiss_time -= delta
		if auto_dismiss_time <= 0.0:
			dismiss_tooltip()
	
	if auto_voice_dismiss_time > 0.0:
		auto_voice_dismiss_time -= delta
		if auto_voice_dismiss_time <= 0.0:
			dismiss_voice_tooltip()


func _input(_event) -> void:
	# Don't check if the string is empty
	if action_required != "" and Input.is_action_just_pressed(action_required):
		dismiss_tooltip()


# Displays tooltip. Optional flashing, action (from Input map) to press and time to automatically disappear
func display_tooltip(tooltip_text: String, tooltip_flashing: bool, action_to_dismiss: String = "", duration: float = 0.0) -> void:
	tooltip_label.text = tooltip_text
	
	is_flashing = tooltip_flashing
	if tooltip_flashing:
		modulate.a = 0.0
	else:
		modulate.a = 1.0
		
	action_required = action_to_dismiss
	auto_dismiss_time = duration
	is_tooltip_visible = true
	tooltip_label.show()


func display_voice_tooltip(tooltip_text: String, duration: float = 0.0) -> void:
	tooltip_label_voice.text = tooltip_text
	
	auto_voice_dismiss_time = duration
	is_voice_tooltip_visible = true
	tooltip_label_voice.show()


# Hides tooltip and resets values
func dismiss_tooltip() -> void:
	tooltip_label.text = ""
	action_required = ""
	auto_dismiss_time = 0.0
	is_flashing = false
	is_tooltip_visible = false
	tooltip_label.hide()


func dismiss_voice_tooltip() -> void:
	tooltip_label_voice.text = ""
	tooltip_label_voice.hide()
