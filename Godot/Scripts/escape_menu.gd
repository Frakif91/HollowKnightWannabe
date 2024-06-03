extends CanvasLayer

#@onready var menu : MenuBar = $"MenuBar"
@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var menu : TabContainer = $MenuBar
@onready var master_volume_label : Label = $"MenuBar/Settings/SettingsTab/MV_Title" 
@onready var volume_slider : HSlider = $"MenuBar/Settings/SettingsTab/Control/Volume_Slider"
@onready var local_select : OptionButton = $"MenuBar/Settings/SettingsTab/LocalSelect"
@onready var scene_select : VBoxContainer = $"MenuBar/Options/MarginContainer"
const locals = ["en","fr","de","es"]
var is_showed = false
var is_in_action = false

const FAILED = false
const SUCCES = true

func _ready():
	for idx in local_select.item_count:
		print("Removing Item n°" + str(idx) + " named " + local_select.get_item_text(idx))
		local_select.remove_item(idx)
	var i = 0
	if OS.is_debug_build():
		for lang in TranslationServer.get_loaded_locales():
			print("Languages n°"+ str(i+1) + " : " + str(lang) + " <-> " + str(TranslationServer.get_locale_name(lang)))
			local_select.add_item(TranslationServer.get_locale_name(lang),i)
			i += 1
			if PlayerStats.chosed_local_index == i:
				PlayerStats.chosed_local = lang
	
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
func TP_But5():
	teleporting(5)
func TP_But6():
	teleporting(6)

func _save_game_state():
	$"MenuBar/Options/MarginContainer/SaveSFX".play()
	PlayerStats.save_file(PlayerStats.save_types.GAMEPLAY)
func _load_game_state():
	$"MenuBar/Options/MarginContainer/LoadSFX".play()
	PlayerStats.load_file(PlayerStats.save_types.GAMEPLAY)

func teleporting(index: int):
	assert(index is int)
	#print(index)
	#var button_to_disable = []
	for child in scene_select.get_children():
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
		5:
			file = "tuto_scene.tscn"
		6:
			file = "laboratoir de bob.tscn"
		_:
			file = "title.tscn"
	Transitions.play("RESET")
	PlayerStats.tp_pos = Vector2(0,0)
	await Transitions.change_scene(path + file,"fade_out")
	for child in scene_select.get_children():
		if is_instance_of(child, Button):
			child.disabled = false
	if Transitions:
		assert(Transitions)
		await Transitions.play("fade_in")


func _on_volume_slider_value_changed(value):
	$"MenuBar/Settings/SettingsTab/ST_ChangeV_SFX".play()
	master_volume_label.text = tr("MASTER_VOLUME") + " : " + str(volume_slider.value) + "%"
	AudioServer.set_bus_volume_db(0,linear_to_db(volume_slider.value/200))


func _on_volume_slider_drag_ended(value_changed):
	$"MenuBar/Settings/SettingsTab/FN_ChangeV_SFX".play()

func _on_local_select_item_selected(index : int):
	TranslationServer.set_locale(locals[index])
	PlayerStats.chosed_local_index = index
	PlayerStats.chosed_local = TranslationServer.get_locale()
	#TranslationServer.get_language_name()
