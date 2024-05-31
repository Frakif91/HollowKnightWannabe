extends Control

#@export var text_to_type : Array[String] = ["You trippin' balls bruh...",
#	"Man, i think you need healing cuz you're hallucinating.",
#	"Come back with money next time.","..."]

var text_to_type : Dictionary = {
		"R0" : "Bonjour ! vous avez besoin de quelque chose ?",
		"Q1" : "Qu’est-ce que cet endroit ?",
		"R1" : "Eh bien, Nous sommes au sous-sol du cimetière...",
		"Q2" : "Vous êtes un pirate ?",
		"R2" : "Oui, enfin autrefois, à cette époque, je me prénommais… J’ai sillonné toutes les mers du monde avec mon équipage, les Botri. Nous étions les grands pirates de notre temps.",
		"Q3" : "Comment vous êtes-vous retrouvé ici ?",
		"R3" : "Malgré notre ténacité en tant que pirates, cela ne nous a pas protégés d’une trahison. C’était la nuit, et nous avions fait escale sur une petite île où nous avons décidé de passer la nuit.",
		"R4" : "Mais à peine avions-nous fermé les yeux que j’ai entendu crier : \"La marine ! La marine !\" J’ai sauté de mon hamac, attrapé mon sabre, et vu deux énormes navires qui nous tiraient dessus.",
		"R5" : "J’ai combattu comme un diable, mais ils ont fini par m’attraper et me faire prisonnier. Ils avaient prévu de me pendre...", 
		"R6" : "...mais avant cela, on m’a laissé un étrange message qui m’a conduit à être enterré dans mon village natal, et c’est ainsi que je me suis retrouvé ici.",
		"Q7" : "Qui est ce garde ?",
		"R7" : "Tout ce que je sais de lui, c’est qu’il n’a pas l’intention de laisser sortir la moindre personne du cimetière. J’aurais bien aimé lui apprendre les bonnes manières avec un engin autre que ce bâton."
}

var wait_time = 0.03
var is_typing = false
var have_to_stop

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
			return
		if word != " ":
			$"Talk".play()
			await wait_rule(word)
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

