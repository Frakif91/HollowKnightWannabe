extends Area2D

@onready var shop_area : Area2D = self
@onready var instructions : Control = $"InteractIcon"
@onready var instructions_animation : AnimatedSprite2D = $"InteractIcon/Icon"
@onready var audio : AudioStreamPlayer = $"SelectSound"
var shop_ui = preload("res://Godot/Scene/shop_ui.tscn") 
var can_interact_with_shop = false

func _ready():
	$"ShopSeller".play("idle")
	instructions.visible = false
	shop_area.body_entered.connect(_on_body_entered)
	shop_area.body_exited.connect(_on_body_exited)
	#shop_area.get_overlapping_bodies()

func _on_body_entered(_body):
	print(_body)
	if _body is CharacterBody2D:
		can_interact_with_shop = true
		instructions.visible = true
		instructions_animation.play("upward")

func _on_body_exited(_body):
	print(_body)
	if _body is CharacterBody2D:
		can_interact_with_shop = false
		instructions.visible = false
	pass

func _process(_delta):
	if Input.is_action_just_pressed("Interact") and can_interact_with_shop:
		PlayerStats.is_abletomove = false
		audio.play()
		$"ShopSeller".play("hey")
		await Transitions.change_scene("reload","fade_out")
		PlayerStats.is_abletomove = true


var text : Dictionary = {
		"Q1" :"Qu’est-ce que cet endroit",
		"R1" : "Eh bien, c’est le sous-sol du cimetière ?",
		"Q2" : "Vous êtes un pirate ?",
		"R2" : "Oui, enfin autrefois, à cette époque, je me prénommais… J’ai sillonné toutes les mers du monde avec mon équipage, les Botri. Nous étions les grands pirates de notre temps.",
		"Q3" : "Comment vous êtes-vous retrouvé ici ?",
		"R3" : "Malgré notre ténacité en tant que pirates, cela ne nous a pas protégés d’une trahison. C’était la nuit, et nous avions fait escale sur une petite île où nous avons décidé de passer la nuit. Mais à peine avions-nous fermé les yeux que j’ai entendu crier : ‘La marine ! La marine !’ J’ai sauté de mon hamac, attrapé mon sabre, et vu deux énormes navires qui nous tiraient dessus. J’ai combattu comme un diable, mais ils ont fini par m’attraper et me faire prisonnier. Ils avaient prévu de me pendre, mais avant cela, on m’a laissé un étrange message qui m’a conduit à être enterré dans mon village natal, et c’est ainsi que je me suis retrouvé ici.",
		"Q4" : "Qui est ce garde ?",
		"R4" : "Tout ce que je sais de lui, c’est qu’il n’a pas l’intention de laisser sortir la moindre personne du cimetière. J’aurais bien aimé lui apprendre les bonnes manières avec un engin autre que ce bâton."
}
