extends Area2D

class_name Interaction

var interact_icon : AnimatedSprite2D
var instructions : Control
var instructions_animation : AnimatedSprite2D

@export_enum("Spikes","Checkpoint","Chest","Teleport","Teleport Interact","Death Sentense") var object_type : String
#spikes
@export var spike_damage : int = 4

#Chest
@onready var chest_audio : AudioStreamPlayer = $"OpenSFX"
var can_interact_with_chest = false
var can_interact_with_teleporter = false
@export var is_already_open = false
@export_file("*.tscn") var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	if object_type == "Chest":
		interact_icon = $Chest_Tex
		instructions = $"InteractIcon"
		instructions_animation = $"InteractIcon/Icon"
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
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
			pass
		"Checkpoint":
			if _body is MainCharacter:
				PlayerStats.safety_checkpoint_pos = position
				_body.sprite.modulate = Color(0.5,1,0.5)
		"Teleport Interact":
			if _body is MainCharacter:
				can_interact_with_teleporter = true
				instructions.visible = true
				instructions_animation.play("upward")

func _on_body_exited(_body):
	match(object_type):
		"Chest":
			if _body is MainCharacter:
				can_interact_with_chest = false
				instructions.visible = false
		"Teleport Interact":
			if _body is MainCharacter:
				can_interact_with_teleporter = false
				instructions.visible = false

func _process(_delta):
	match(object_type):
		"Chest":
			if Input.is_action_just_pressed(&"Interact") and !is_already_open:
				var mario : MainCharacter
				for i in self.get_overlapping_bodies():
					if i is MainCharacter:
						mario = i
						break
				if mario:
					instructions.visible = false
					is_already_open = true
					chest_audio.play()
					interact_icon.play("normal")
					await interact_icon.animation_finished
				mario.is_abletomove = true
		"Teleporter":
			if Input.is_action_just_pressed(&"Interact") and can_interact_with_teleporter:
				Transitions.change_scene(scene,"fade_out")
