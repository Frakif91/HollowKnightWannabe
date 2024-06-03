@tool
extends Camera2D

class_name PlayerCamera

var camera : Camera2D = self
@export var randomStrength : float = 10.0
@export var shakeFade : float = 5.0
var menu_visible : bool = false

@onready var ui = $"ScreenAnchor/UI"
@onready var menu = $"Menu"
@onready var confirmation_window = $"ConfirmationDialog"
@onready var area_announcer = $"ScreenAnchor/AreaAnnouncer"
@onready var touch_button = $"ScreenAnchor/TouchButtons"

var rng = RandomNumberGenerator.new()
var shake_strength : float = 0.0

func _ready():
	if get_tree().current_scene is PlayerCamera:
		print("Debug Scene")
		area_announcer.show_title("Camera Test","This is a camera test",3)
	if not Engine.is_editor_hint():
		PlayerStats.camera = self
		ui.visible = true
		menu.visible = true
		touch_button.show()
	else:
		touch_button.hide()
		ui.visible = false
		menu.visible = false
	#OS.alert("Do you want to quit ?","Are you sure ?")

func apply_shake(power):
	if (power != 0):
		shake_strength = power
	else:
		shake_strength = randomStrength

func _process(delta):
	if shake_strength > 0.05:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		offset = randomOffset()
	if menu.get_script() == load("res://Godot/Scripts/escape_menu.gd") and not Engine.is_editor_hint():
		menu_visible = menu.get("is_showed")

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
