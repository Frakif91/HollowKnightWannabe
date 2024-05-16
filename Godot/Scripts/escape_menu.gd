extends CanvasLayer

#@onready var menu : MenuBar = $"MenuBar"
@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var menu : TabContainer = $MenuBar
var is_showed = false
var is_in_action = false

const FAILED = false
const SUCCES = true

func _ready():
	if scene_file_path == "res://Godot/Scene/debug_menu.tscn":
		Transitions.play("Hide")
	$MenuBar/Menu/MarginContainer/QuitButton.pressed.connect(when_quit)
	$MenuBar/Menu/MarginContainer/Resume.pressed.connect(when_resume)
	$"../ConfirmationDialog".confirmed.connect(_quit)
	show_hide(false)

func _process(_delta):
	if Input.is_action_just_pressed("Menu") and not is_in_action:
		is_showed = not is_showed
		await show_hide(is_showed)
		

func show_hide(do_show : bool) -> bool:
	if not is_in_action:
		if do_show:
			#Show
			is_in_action = true
			menu.visible = true
			animplayer.play_backwards("Show-Hide")
			await animplayer.animation_finished
			is_in_action = false
			menu.visible = true
		else:
			#Hide
			is_in_action = true
			menu.visible = true
			animplayer.play("Show-Hide")
			await animplayer.animation_finished
			menu.visible = false
			is_in_action = false
		return SUCCES
	else:
		printerr("Is already in action !")
		return FAILED

func when_quit():
	$"../ConfirmationDialog".visible = true

func _quit():
	get_tree().quit()

func when_resume():
	is_showed = false
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
	Transitions.play("RESET")
	await Transitions.change_scene(path + file,"fade_out")
	for child in $MenuBar/Option/MarginContainer.get_children():
		if is_instance_of(child, Button):
			child.disabled = false
