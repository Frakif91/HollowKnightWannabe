extends Button

@export_file("*.tscn") var scene = "res://Godot/Scene/Basic Scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1,1,1,1)
	print_debug("Ready !")
	Transitions.play("Hide")
	self.button_down.connect(_button_pressed)

func _input(event):
	if event.is_action_pressed("Menu"):
		_button_pressed()

func _button_pressed():
	modulate = Color(0,1,0,1)
	Transitions.play("RESET")
	print_debug("Pressed")
	Transitions.change_scene(scene,"fade_out")
