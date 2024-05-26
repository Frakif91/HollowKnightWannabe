extends CanvasLayer

#@onready var menu : MenuBar = $"MenuBar"
@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var menu : TabContainer = $MenuBar
@onready var master_volume_label : Label = $"MenuBar/Settings/SettingsTab/MV_Title" 
@onready var volume_slider : HSlider = $"MenuBar/Settings/SettingsTab/Control/Volume_Slider"
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
	menu.visible = false
	animplayer.play_backwards("Show-Hide")

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
func save_game_state():
	PlayerStats.save_file(PlayerStats.save_types.GAMEPLAY)
func load_game_state():
	PlayerStats.load_file(PlayerStats.save_types.GAMEPLAY)

func teleporting(index: int):
	assert(index is int)
	#print(index)
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
	PlayerStats.tp_pos = Vector2(0,0)
	await Transitions.change_scene(path + file,"fade_out")
	for child in $MenuBar/Option/MarginContainer.get_children():
		if is_instance_of(child, Button):
			child.disabled = false
	if Transitions:
		assert(Transitions)
		await Transitions.play("fade_in")


func _on_volume_slider_value_changed(value):
	$"MenuBar/Settings/SettingsTab/ST_ChangeV_SFX".play()
	master_volume_label.text = "MASTER VOLUME : " + str(volume_slider.value) + "%"
	AudioServer.set_bus_volume_db(0,linear_to_db(volume_slider.value/200))


func _on_volume_slider_drag_ended(value_changed):
	$"MenuBar/Settings/SettingsTab/FN_ChangeV_SFX".play()


func _on_load_button_pressed():
	pass # Replace with function body.
