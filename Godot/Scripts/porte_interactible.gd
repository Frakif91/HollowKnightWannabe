extends StaticBody2D

class_name Door_Interact

@onready var sprite : Sprite2D = $"./Sprite2D"
@onready var collision : CollisionShape2D = $"./Col"
@onready var label : Label = $"./Label"

@export var Lever1 : MapObject
@export var Lever2 : MapObject
@export var Lever3 : MapObject

@export var open_sfx : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	if open_sfx:
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
	sprite.frame = 0
	collision.disabled = false
	label.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
var i = 0
func _on_lever_refresh():
	i = 0
	if Lever1.already_interacted_with_levier:
		i += 1
	if Lever2.already_interacted_with_levier:
		i += 1
	if Lever3.already_interacted_with_levier:
		i += 1
	sprite.frame = i
	if i == 3:
		collision.disabled = true
		label.hide()
		$"OpeningSFX".play()