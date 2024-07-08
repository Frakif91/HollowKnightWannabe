@tool
extends Camera2D

class_name PlayerCamera

signal switch()
var switching : bool = false

func switching_camera():
	print_debug("Debug Cam")
	switching = not switching
	if switching:
		follow_node = get_node(followed_node)
	else:
		follow_node = get_node(second_follow)
		

var camera: Camera2D = self
@export_node_path("Node2D") var followed_node: NodePath
@export_node_path("Node2D") var second_follow: NodePath
@export var default_randomStrength: float = 10.0
@export var default_shakeFade: float = 5.0

@onready var ui = $"ScreenAnchor/UI"
@onready var menu = $"Menu"
@onready var confirmation_window = $"ConfirmationDialog"
@onready var area_announcer = $"ScreenAnchor/AreaAnnouncer"
@onready var touch_button = $"ScreenAnchor/TouchButtons"
@onready var coin_counter = $"ScreenAnchor/UI/Control/CoinTex"
@onready var coin_player = AudioStreamPlayer.new()
@onready var follow_node = get_node_or_null(followed_node)
const coin_sfx = preload ("res://Assets/SFX/WU_SE_OBJ_COIN_BOUND.wav")
var menu_visible: bool = false


var cam_follow: CameraFollow = CameraFollow.new(camera, follow_node)
var cam_shake: CameraShake = CameraShake.new()

func _ready():
	switch.connect(switching_camera)
	coin_player.stream = coin_sfx
	if get_tree().current_scene is PlayerCamera:
		print("Debug Scene")
		area_announcer.show_title("Camera Test", "This is a camera test", 3)
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

func _process(delta):
	if menu.get_script() == load("res://Godot/Scripts/escape_menu.gd") and not Engine.is_editor_hint():
		menu_visible = menu.get("is_showed")
	#cam_follow._process(delta)
	cam_follow.follow_object(follow_node,5,Vector2.ZERO,delta)
	#cam_follow.follow_position(follow_node.position, 1 if follow_node.velocity == Vector2.ZERO else 3, Vector2(follow_node.velocity.x * 0.5, follow_node.velocity.y * 0.2), delta)

class CameraShake:
	var cam_in_cutsceen: bool = true
	var randomStrength = 10.0
	var shakeFade = 5.0
	var rng = RandomNumberGenerator.new()
	var shake_strength: float = 0.0
	var offset = Vector2.ZERO

	func shake_camera(power: float=10.0, fade: float=5.0):
		if (fade <= 0) or (fade >= power):
			shakeFade = 5.0
		else:
			shakeFade = fade
		if (power != 0):
			shake_strength = power
		else:
			shake_strength = randomStrength

	func advanced_shake(shake_power, shake_Fade):
		pass
	
	func _process(delta):
		if shake_strength > 0.05:
			shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
			offset = self.randomOffset()
		else:
			shake_strength = 0
	
	func randomOffset() -> Vector2:
		return Vector2(rng.randf_range( - shake_strength, shake_strength), rng.randf_range( - shake_strength, shake_strength))

class CameraFollow:

	const cam_follow_active_speed = 5.
	const cam_follow_inactive_speed = 3.
	var follow_node: Node2D
	var camera = Camera2D

	func _init(cam, followed_node):
		camera = cam
		follow_node = followed_node
	
	func _process(delta):
		if follow_node != null:
			pass
			#follow_object(follow_node, 5, Vector2(0,0), delta)
	
	func follow_object(node: Node, speed: float, node_offset: Vector2, delta: float):
		camera.position = lerp(camera.position, node.position + node_offset, speed * delta)
	
	func follow_position(pos2: Vector2, speed: float, node_offset: Vector2, delta: float):
		camera.position = lerp(camera.position, pos2 + node_offset, speed * delta)
	
	func tween_position(pos1: Vector2, pos2: Vector2, seconds):
		Tween.interpolate_value(pos1, pos2 - pos1, 0, seconds, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
