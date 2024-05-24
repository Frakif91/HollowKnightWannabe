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

func _input(event):
	if event.is_action_pressed("Interact") and can_interact_with_shop:
		can_interact_with_shop = false
		PlayerStats.is_abletomove = false
		audio.play()
		$"ShopSeller".play("hey")
		PlayerStats.tp_pos = PlayerStats.player.position		
		await Transitions.change_scene(shop_ui,"fade_out")
		
		#Transitions.play("fade_in")
