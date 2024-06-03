extends Camera2D

var camera : Camera2D = self
var mouse_pos : Vector2
var move_power = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Attack"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_pos = get_local_mouse_position() - Vector2(get_window().size)/2
		camera.position += mouse_pos/move_power
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE