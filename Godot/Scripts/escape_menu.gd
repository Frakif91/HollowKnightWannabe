extends CanvasLayer

#@onready var menu : MenuBar = $"MenuBar"
@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var menu : TabContainer = $MenuBar
var is_showed = false
var is_in_action = false

func _ready():
	if scene_file_path == "res://Godot/Scene/debug_menu.tscn":
		Transitions.play("Hide")
	$MenuBar/Menu/MarginContainer/QuitButton.pressed.connect(when_quit)
	$MenuBar/Menu/MarginContainer/Resume.pressed.connect(when_resume)

func _unhandled_input(event : InputEvent):
	#$MenuBar/Option/MarginContainer/ButtonTPScene1.pressed.connect("when_teleporting(1)")
	if Input.is_action_pressed("Menu"):
		if not is_in_action:
			is_in_action = true
			is_showed = not is_showed
			show_hide(is_showed)
			is_in_action = false
		else:
			printerr("Not in Action")
	else:
		print("Wrong Input",event)
		

func show_hide(do_show : bool):
	if not is_in_action:
		is_in_action = true
		if do_show:
			animplayer.play("Show-Hide")
			await animplayer.animation_finished
			menu.visible = false
			is_in_action = false
		else:
			menu.visible = true
			animplayer.play_backwards("Show-Hide")
			await animplayer.animation_finished
			is_in_action = false

func when_quit():
	get_tree().quit()

func when_resume():
	is_showed = not is_showed
	show_hide(is_showed)
	
func TP_But1():
	teleporting(1)
func TP_But2():
	teleporting(2)
func TP_But3():
	teleporting(3)
func TP_But4():
	teleporting(4)


func teleporting(index: int):
	assert(index is int)
	print(index)

	#var button_to_disable = []
	for child in $MenuBar/Option/MarginContainer.get_children():
		if is_instance_of(child, Button):
			child.disabled = true

	#return null
	var path = "res://Godot/Scene/"
	var file
	match(index):
		1:
			file = "tileset_test.tscn" 
		2:
			file = "tileset_2.tscn"
		3:
			file = "Shop.tscn"
		4:
			file = "map_quentin.tscn"
		_:
			file = "title.tscn"
	
	await Transitions.change_scene(path + file,"fade_out")
	for child in $MenuBar/Option/MarginContainer.get_children():
		if is_instance_of(child, Button):
			child.disabled = false