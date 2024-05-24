extends Area2D

class_name MapObject

@export_category("Map Object")
@export_enum("Spikes","Checkpoint","Chest","Teleport","Teleport Interact","Death Sentense") var object_type : String

@export_subgroup("Interaction Icon")
@export var interact_offset = Vector2(0,-50)
@export var interact_scale = Vector2(0.3,0.3)

@export_subgroup("Chest")
@export var is_already_open = false
@export_enum("Coins","Healing") var chest_reward = "Healing"

@export_subgroup("Teleportation")
@export_file("*.tscn") var scene_to_TP
@export var tp_fade_animation : String = "fade_out" 
@export var tp_pos : Vector2 = Vector2(0,0)

@onready var sound : AudioStreamPlayer = $"Sound"
#@onready var defeat_sound = load("res://Assets/SFX/LC_SFX/614. Slam Ground.mp3")
@onready var hurt_sound = load("res://Assets/SFX/LC_SFX/592. Shovel Hit Default.mp3")
var interaction = preload("res://Godot/Nodes/Interact_icon.tscn")
var can_interact_with_chest = false
var can_interact_with_teleporter = false

var interact_icon : AnimatedSprite2D
var instructions  : Control
var instructions_animation : AnimatedSprite2D
var chest_audio : AudioStreamPlayer
var interaction_node


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if object_type == "Chest" or object_type == "Teleport Interact":
		interaction_node = interaction.instantiate()
		add_child(interaction_node)
		instructions = $"InteractIcon"
		instructions_animation = $"InteractIcon/Icon"
		instructions.position = interact_offset
		instructions.scale = interact_scale
		instructions.visible = false

	if object_type == "Chest":
		interact_icon = $Chest_Tex
		chest_audio = $"OpenSFX"
		instructions_animation.play("idle")
		if is_already_open:
			interact_icon.play("normal")
		instructions.visible = false
		

func _on_body_entered(_body):
	match(object_type):
		"Chest":
			if _body is MainCharacter and !is_already_open:
				can_interact_with_chest = true
				instructions.visible = true
				instructions_animation.play("upward")
		"Spikes":
			if _body is MainCharacter:
				position = PlayerStats.safety_checkpoint_pos
				PlayerStats.hp -= 1
				sound.stream = hurt_sound
				sound.play()
				_body.sprite.modulate = PlayerStats.hurt_color
				if PlayerStats.hp <= 0:
					_body.on_gameover()
			if _body is MainCharacter:
				_body.position = PlayerStats.safety_checkpoint_pos
				_body.get_hurt(4)
				_body.velocity = Vector2.ZERO
		"Checkpoint":
			if _body is MainCharacter:
				PlayerStats.safety_checkpoint_pos = _body.position
				_body.sprite.modulate = Color(0.5,1,0.5)
		"Teleport Interact":
			if _body is MainCharacter and _body.is_abletomove:
				can_interact_with_teleporter = true
				instructions.visible = true
				instructions_animation.play("upward")

func _on_body_exited(_body):
	match object_type:
		"Chest":
			if _body is MainCharacter:
				can_interact_with_chest = false
				instructions.visible = false
		"Teleport Interact":
			if _body is MainCharacter and _body.is_abletomove:
				can_interact_with_teleporter = false
				instructions.visible = false

func _input(event):
	match object_type:
		"Chest":
			if event.is_action_pressed(&"Interact") and not is_already_open and can_interact_with_chest:
				is_already_open = true
				instructions.visible = false
				chest_audio.play()
				interact_icon.play("normal")
				await interact_icon.animation_finished
				PlayerStats.is_abletomove = true
		"Teleport Interact":
			if event.is_action_pressed(&"Interact") and can_interact_with_teleporter:
				print_debug(typeof(scene_to_TP))
				PlayerStats.is_abletomove = false
				PlayerStats.tp_pos = tp_pos
				await Transitions.change_scene(scene_to_TP,"fade_out")
				PlayerStats.is_abletomove = true