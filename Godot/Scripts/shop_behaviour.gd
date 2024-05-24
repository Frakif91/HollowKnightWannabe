extends Control

#@export var text_to_type : Array[String] = ["You trippin' balls bruh...",
#	"Man, i think you need healing cuz you're hallucinating.",
#	"Come back with money next time.","..."]

var text_to_type : Dictionary = {
		"R0" : "Bonjour ! vous avez besoin de quelque chose ?",
		"Q1" :"Qu’est-ce que cet endroit",
		"R1" : "Eh bien, c’est le sous-sol du cimetière ?",
		"Q2" : "Vous êtes un pirate ?",
		"R2" : "Oui, enfin autrefois, à cette époque, je me prénommais… J’ai sillonné toutes les mers du monde avec mon équipage, les Botri. Nous étions les grands pirates de notre temps.",
		"Q3" : "Comment vous êtes-vous retrouvé ici ?",
		"R3" : "Malgré notre ténacité en tant que pirates, cela ne nous a pas protégés d’une trahison. C’était la nuit, et nous avions fait escale sur une petite île où nous avons décidé de passer la nuit. Mais à peine avions-nous fermé les yeux que j’ai entendu crier : ‘La marine ! La marine !’ J’ai sauté de mon hamac, attrapé mon sabre, et vu deux énormes navires qui nous tiraient dessus. J’ai combattu comme un diable, mais ils ont fini par m’attraper et me faire prisonnier. Ils avaient prévu de me pendre, mais avant cela, on m’a laissé un étrange message qui m’a conduit à être enterré dans mon village natal, et c’est ainsi que je me suis retrouvé ici.",
		"Q4" : "Qui est ce garde ?",
		"R4" : "Tout ce que je sais de lui, c’est qu’il n’a pas l’intention de laisser sortir la moindre personne du cimetière. J’aurais bien aimé lui apprendre les bonnes manières avec un engin autre que ce bâton."
}


var wait_time = 0.02
var is_typing = false
var have_to_stop

@onready var image = $"ShopUi"
@onready var shop_audio = $"AudioStreamPlayer"
@onready var candle_light = $"PointLight2D"
@onready var menu_title = $"Control/Name"
@onready var menu_text = $"Control/Text"

var line_of_text : String = "R0"

func _ready():
	typing(text_to_type["R0"])

func _input(event):
	if event.is_action_pressed("Interact") and not is_typing:
		line_of_text[1] = str(int(line_of_text[1]) + 1)
		if int(line_of_text[1]) > len(text_to_type) - 1:
			line_of_text = "R0"
		await typing(text_to_type[line_of_text])
	elif event.is_action_pressed("Interact") and is_typing:
		have_to_stop = true
		await wait(wait_time + 0.01)
		menu_text.text = text_to_type[line_of_text]
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
		menu_text.text = final_string
		if word != " ":
			await wait(wait_time)
		if have_to_stop:
			return
	is_typing = false

func wait(time):
	await get_tree().create_timer(time).timeout

func _on_button_pressed():
	print_debug("Pressed")
	typing("I hope to see you next time.")
	await wait(0.3)
	await Transitions.change_scene("res://Godot/Scene/Shop.tscn","fade_out")
