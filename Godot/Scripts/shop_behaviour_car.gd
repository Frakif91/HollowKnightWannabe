extends Control

#@export var text_to_type : Array[String] = ["You trippin' balls bruh...",
#	"Man, i think you need healing cuz you're hallucinating.",
#	"Come back with money next time.","..."]

var text_to_type : Dictionary = {
		"R0" : "Hi, I'm Car, i am a silly feline that does some silly things !",
		"R0FR" : "Salut ! Je m'appelle Car, je suis un furry qui fait des choses rigolotes sur OF",
		"Q1" : "Qu’est-ce que cet endroit ?",
}

var wait_time = 0.03
var is_typing = false
var have_to_stop
var sprites = [preload("res://Assets/GFX/Car_shop_Talking2.png"),
			   preload("res://Assets/GFX/Car_shop.png")]
var decaly = -5
var decal_randomness = 2
var og_speed = 0.2
var will_vibrate = 5
var vibrate_index = 0

@onready var car_shop = $"CarShop"
@onready var og_pos : Vector2 = car_shop.position
@onready var image = $"ShopUi"
@onready var shop_audio = $"AudioStreamPlayer"
@onready var candle_light = $"PointLight2D"
@onready var menu_title = $"Control/Name"
@onready var menu_text = $"Control/Text"

var line_of_text : String = "R0"

func _ready():
	PlayerStats.is_abletomove = true
	#TranslationServer.add_translation(load("res://Godot/Pot/shop.en .translation"))
	print("Traduction Available for menu text object : " + str(menu_text.can_translate_messages()))
	typing(tr("SHOP_HI"))

func _input(event):
	if event.is_action_pressed("Interact") and not is_typing:
		line_of_text[1] = str(int(line_of_text[1]) + 1)
		if int(line_of_text[1]) > 7:
			line_of_text = "R0"
		await tr_typing("SHOP_"+line_of_text)
	elif event.is_action_pressed("Interact") and is_typing:
		have_to_stop = true
		await wait(wait_time + 0.02)
		menu_text.text = "\"" + str(tr("SHOP_"+line_of_text)) + "\""
		is_typing = false
		have_to_stop = false

func typing(sentence : String):
	is_typing = true
	var words = []
	for letter in range(len(sentence)):
		words.append(sentence[letter])

	var final_string = ""
	for word in words:
		final_string = final_string + word
		menu_text.text = "\"" + final_string + "\""
		if have_to_stop:
			return
		if word != " ":
			$"Talk".play()
			await wait_rule(word)
	is_typing = false

func tr_typing(key : String):
	var sentence = tr(key)
	is_typing = true
	var words = []
	for letter in range(len(sentence)):
		words.append(sentence[letter])

	var final_string = ""
	for word in words:
		final_string = final_string + word
		menu_text.text = "\"" + final_string + "\""
		if have_to_stop:
			$"CarShop".position = og_pos
			return
		if word != " ":
			$"Talk".play()
			await wait_rule(word)
	$"CarShop"
	is_typing = false

func wait(time):
	await get_tree().create_timer(time).timeout

func _on_button_pressed():
	if is_typing:
		have_to_stop = true
		await wait(wait_time)
	have_to_stop = false
	print_debug("Pressed")
	await tr_typing("SHOP_GB")
	await wait(0.3)
	await Transitions.change_scene("res://Godot/Scene/Shop.tscn","fade_out")

func _process(delta):
	$"CarShop".position = lerp($"CarShop".position,og_pos,og_speed)

func wait_rule(letter):
	match(letter):
		" ":
			return
		".":
			await wait(wait_time*20)
		",":
			await wait(wait_time*10)
		":":
			await wait(wait_time*10)
		"?":
			await wait(wait_time*20)
		"!":
			await wait(wait_time*15)
		_:
			vibrate_index += 1
			if (vibrate_index % will_vibrate) <= will_vibrate/2:
				$"CarShop".position.y = og_pos.y + decaly
			else:
				$"CarShop".position.y = og_pos.y
			await wait(wait_time)

func _on_heal_button():
	print_debug("Pressed")
	if not is_typing:
		if PlayerStats.hp == PlayerStats.max_hp:
			$"SelectSFX".play()
			await tr_typing("SHOP_HEAL_FULL")
		else:
			await tr_typing("SHOP_HEAL")
			PlayerStats.hp = PlayerStats.max_hp
			$"HealSFX".play()

func _on_guard_qna():
	if not is_typing:
		await tr_typing("SHOP_R7")

