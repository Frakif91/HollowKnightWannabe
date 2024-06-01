extends TouchScreenButton

var og_modulate = Color(1,1,1,0.5)
var full_modulate = Color(0.7,0.7,0.7,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = og_modulate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.pressed:
		modulate = full_modulate
	else:
		modulate = og_modulate
