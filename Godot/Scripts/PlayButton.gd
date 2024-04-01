extends Button

@onready var scene = "res://Godot/Scene/Basic Scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("Ready !")
	Transitions.play("Hide")
	self.button_down.connect(_button_pressed)

func _button_pressed():
	print_debug("Pressed")
	Transitions.change_scene(scene,"fade_out")
