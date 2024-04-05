extends CanvasLayer

#@onready var menu : MenuBar = $"MenuBar"
@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var menu : TabContainer = $MenuBar
var is_showed = false

func _ready():
	if scene_file_path == "res://Godot/Scene/debug_menu.tscn":
		Transitions.play("Hide")

func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("Menu"):
		is_showed = not is_showed
		show_hide(is_showed)

func show_hide(do_show : bool):
	if do_show:
		animplayer.play("Show-Hide")
		await animplayer.animation_finished
		menu.visible = false
	else:
		menu.visible = true
		animplayer.play_backwards("Show-Hide")