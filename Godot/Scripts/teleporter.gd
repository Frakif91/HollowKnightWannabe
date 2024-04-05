extends Area2D

class_name Teleporter

@export_category("Teleportation To Other Scene")
@export_file("*tscn") var scene = "res://Godot/Scene/level_1_1.tscn"
@export_enum("fade_out","fade_left_right_in","fade_right_left_in") var animation = "fade_out"
@export_subgroup("Teleportation")
@export var use_marker : bool = false
@export_node_path("Marker2D") var marker_path : NodePath = ""
@export var tp_pos : Vector2 = Vector2(0,0)
@export_enum("None","Player Interact") var condition = "None"

var the_player : MainCharacter
# Called when the node enters the scene tree for the first time.

func _ready():
	self.body_entered.connect(on_body_entered)

func on_body_entered(external_body):
	if (external_body is MainCharacter):
		print_debug(external_body)
		the_player = external_body
		if condition == "None":
			teleport()

func on_body_exit():
	the_player = null

func teleport():
	if use_marker:
		PlayerStats.tp_pos = get_node(marker_path).position
	else:
		PlayerStats.tp_pos = tp_pos
	Transitions.call("change_scene",scene,animation)
