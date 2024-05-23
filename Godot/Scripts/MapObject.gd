extends Area2D

class_name MapObject

var interaction = preload("res://Godot/Nodes/Interact_icon.tscn")

@export_enum("Spikes","Checkpoint","Chest","Teleport","Teleport Interact","Death Sentense") var object_type : String

var can_interact_with_chest = false
var can_interact_with_teleporter = false
@export var is_already_open = false

var interact_icon : AnimatedSprite2D
var instructions  : Control
var instructions_animation : AnimatedSprite2D
var chest_audio : AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
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
				_body.position = PlayerStats.safety_checkpoint_pos
				_body.get_hurt(4)
				_body.velocity = Vector2.ZERO
		"Checkpoint":
			if _body is MainCharacter:
				PlayerStats.safety_checkpoint_pos = _body.position
				_body.sprite.modulate = Color(0.5,1,0.5)

func _on_body_exited(_body):
	if object_type == "Chest":
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
