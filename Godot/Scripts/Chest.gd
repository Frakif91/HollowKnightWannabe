extends Area2D

class_name Interaction

@onready var interact_icon : AnimatedSprite2D = $Chest_Tex
@onready var instructions : Control = $"InteractIcon"
@onready var instructions_animation : AnimatedSprite2D = $"InteractIcon/Icon"

@export_enum("Spikes","Checkpoint","Chest","Teleport","Teleport Interact","Death Sentense") var object_type : String
#spikes
@export var spike_damage : int = 4

#Chest
@onready var chest_audio : AudioStreamPlayer = $"OpenSFX"
var can_interact_with_chest = false
@export var is_already_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
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

func _on_body_exited(_body):
	if _body is MainCharacter:
		can_interact_with_chest = false
		instructions.visible = false


func _process(_delta):
	if Input.is_action_just_pressed(&"Interact") and !is_already_open:
		var mario : MainCharacter
		for i in self.get_overlapping_bodies():
			if i is MainCharacter:
				mario = i
				break
		if mario:
			is_already_open = true
			instructions.visible = false
			chest_audio.play()
			interact_icon.play("normal")
			await interact_icon.animation_finished
			mario.is_abletomove = true