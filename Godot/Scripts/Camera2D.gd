@tool
extends Camera2D

var camera : Camera2D = self
@export var randomStrength : float = 10.0
@export var shakeFade : float = 5.0
var menu_visible : bool = false

@onready var ui = $"ScreenAnchor/UI"
@onready var menu = $"Menu"
@onready var confirmation_window = $"ConfirmationDialog"

var rng = RandomNumberGenerator.new()
var shake_strength : float = 0.0

func _ready():
	if not Engine.is_editor_hint():
		PlayerStats.camera = self
		ui.visible = true
		menu.visible = true
	else:
		ui.visible = false
		menu.visible = false
	#OS.alert("Do you want to quit ?","Are you sure ?")

func apply_shake(power):
	if (power != null):
		shake_strength = power
	else:
		shake_strength = randomStrength

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		offset = randomOffset()
	menu_visible = menu.is_showed

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
