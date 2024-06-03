extends Label

var timing = 0.0
var seconds = 0.0
var miliseconds = 0.0
var seconds_str = ""
var miliseconds_str = "&"

var stoped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene.scene_file_path == "res://Godot/Scene/map_quentin.tscn":
		show()
	else:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timing = timing + delta
	seconds = int(timing)
	miliseconds = int(timing*100) % 100

	if seconds < 10:	seconds_str = "0" + str(seconds)
	else:	seconds_str = str(seconds)
	
	if miliseconds < 10:	miliseconds_str = "0" + str(miliseconds)
	else:	miliseconds_str = str(miliseconds)

	if not PlayerStats.timer_stoped:
		text = seconds_str + ":" + miliseconds_str
