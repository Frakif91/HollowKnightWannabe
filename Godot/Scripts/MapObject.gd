extends Area2D

class_name MapObject

@export_category("Map Object")
@export_enum("Spikes","Checkpoint","Chest","Teleport","Teleport Interact","Death Sentense","Lever") var object_type : String
@export var spike_damage = 2
@export var connected_door : Door_Interact

@export_subgroup("Interaction Icon","interact_")
@export var interact_offset = Vector2(0,-50)
@export var interact_scale = Vector2(0.3,0.3)

@export_subgroup("Chest")
@export var is_already_open = false
@export_enum("Coins","Healing") var chest_reward = "Coins"
@export var reward_count = 1

@export_subgroup("Teleportation","tp_")
@export_file("*.tscn") var tp_to_scene
@export var tp_fade_animation : String = "fade_out" 
@export var tp_pos : Vector2 = Vector2(0,0)
@export var tp_look_at_the_door : bool = false

@onready var sound : AudioStreamPlayer = AudioStreamPlayer.new()
#@onready var defeat_sound = load("res://Assets/SFX/LC_SFX/614. Slam Ground.mp3")
@onready var hurt_sound = load("res://Assets/SFX/LC_SFX/592. Shovel Hit Default.mp3")
var interaction = preload("res://Godot/Nodes/Interact_icon.tscn")
var open_door_sound = load("res://Assets/SFX/WU_SE_OBJ_DOOR_OPEN.wav")
var close_door_sound = load("res://Assets/SFX/WU_SE_OBJ_DOOR_CLOSE.wav")
var can_interact_with_chest = false
var can_interact_with_teleporter = false
var can_interact_with_levier = false
var already_interacted_with_levier = false

var interact_icon : AnimatedSprite2D
var instructions  : Control
var instructions_animation : AnimatedSprite2D
var chest_audio : AudioStreamPlayer
var interaction_node

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(sound)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if object_type == "Chest" or object_type == "Teleport Interact" or object_type == "Lever":
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
			if _body is MainCharacter and not _body.is_invulnerable:
				PlayerStats.camera.apply_shake(3)
				Input.vibrate_handheld(200)
				Input.start_joy_vibration(0,0.5,1,0.2)
				PlayerStats.hp -= spike_damage
				sound.stream = hurt_sound
				sound.play()
				_body.sprite.modulate = _body.hurt_color
				if PlayerStats.hp <= 0:
					_body.velocity = Vector2.ZERO
					_body.on_gameover()
				else:
					_body.velocity = Vector2(0,-200)
					PlayerStats.is_invulnerable = true
					PlayerStats.is_abletomove = false
					PlayerStats.in_cutscene = true
					_body.sprite.play("Hurt")
					_body.sprite.modulate = PlayerStats.hurt_color
					sound.stream = PlayerStats.player.hurt_sound
					sound.play()
					await get_tree().create_timer(0.5).timeout
					await Transitions.play("fade_bottom_up_in",3)
					_body.position = PlayerStats.safety_checkpoint_pos
					PlayerStats.is_abletomove = true
					PlayerStats.is_invulnerable = false
					PlayerStats.in_cutscene = true
					Transitions.play("fade_bottom_up_out",3)
					#_body.move_and_slide()
				
		"Checkpoint":
			if _body is MainCharacter:
				PlayerStats.safety_checkpoint_pos = _body.position
				_body.sprite.modulate = Color(0.5,1,0.5)
		"Teleport Interact":
			if _body is MainCharacter and _body.is_abletomove:
				can_interact_with_teleporter = true
				instructions.visible = true
				instructions_animation.play("upward")
		"Lever":
			if _body is MainCharacter:
				can_interact_with_levier = true
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
		"Lever":
			if _body is MainCharacter and _body.is_abletomove:
				can_interact_with_levier = false
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
				match(chest_reward):
					"Coins":
						PlayerStats.money += reward_count
					"Healing":
						PlayerStats.hp += reward_count
					"Max_HP":
						PlayerStats.max_hp += reward_count
						PlayerStats.hp = PlayerStats.max_hp
						var audbig_reward = AudioStreamPlayer.new()
						audbig_reward.stream = load("res://Assets/SFX/139-item-catch.mp3")
						audbig_reward.play()
				PlayerStats.is_abletomove = true
		"Teleport Interact":
			if event.is_action_pressed(&"Interact") and can_interact_with_teleporter:
				print_debug(typeof(tp_to_scene))
				PlayerStats.is_abletomove = false
				PlayerStats.tp_pos = tp_pos
				#PlayerStats.player.sprite.play()
				if tp_look_at_the_door:
					sound.stop()
					sound.stream = open_door_sound
					sound.play()
				await Transitions.change_scene(tp_to_scene,"fade_out")
				PlayerStats.is_abletomove = true
				if tp_look_at_the_door:
					sound.stop()
					sound.stream = close_door_sound
					sound.play()
		"Lever":
			if event.is_action_pressed(&"Interact") and can_interact_with_levier == true and not already_interacted_with_levier:
				$AnimatedSprite2D.play("default")
				already_interacted_with_levier = true
				$"OpenSFX".play()
				if connected_door:
					connected_door._on_lever_refresh()
				
		
		
