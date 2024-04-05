extends Node

class_name SceneProperties

@export var scene_name : String = "Graveyard"
@export var scene_description : String = "A dark and Cold Place"
@export_node_path("MainCharacter") var npPlayer : NodePath
@export_node_path("Camera2D") var npCamera : NodePath
@export_node_path("AudioStreamPlayer") var npBGAudio : NodePath

@export var do_player_emit_light : bool = true
@export var camera_default_zoom : Vector2 = Vector2(2,2)

@onready var player : MainCharacter = get_node(npPlayer)
@onready var camera : Camera2D = get_node(npCamera)
@onready var background_audio_player : AudioStreamPlayer = get_node(npBGAudio)

func _ready():
	if !player.is_node_ready():
		await player.ready
	if not do_player_emit_light:
		player.lowlight.energy = 0
		player.highlight.energy = 0
	if not scene_name.is_empty():
		pass
