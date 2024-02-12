extends Button

@onready var scene = "res://Godot/Scene/Basic Scene.tscn"
@onready var fade_out = Transitions

# Called when the node enters the scene tree for the first time.
func _ready():
	Transitions.play("RESET")
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	print_debug("Pressed")
	Transitions.change_scene(scene,"fade_out")
