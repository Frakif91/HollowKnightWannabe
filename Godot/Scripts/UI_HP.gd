extends Control

@onready var hp = PlayerStats.hp
@onready var bp = PlayerStats.bp
@onready var low_health_effect = PlayerStats.low_health_effect
@onready var low_hp_color = PlayerStats.low_hp_color
@onready var low_bp_color = PlayerStats.low_bp_color
@onready var low_percentage = PlayerStats.low_percentage
@onready var max_hp = PlayerStats.max_hp
@onready var max_bp = PlayerStats.max_bp
@onready var affect_BP = PlayerStats.affect_BP
@onready var hide_zeros = PlayerStats.hide_zeros

const og_link = "res://Assets/GFX/Numbers/"
var images = [
		load(og_link + "0.png"),
		load(og_link + "1.png"),
		load(og_link + "2.png"),
		load(og_link + "3.png"),
		load(og_link + "4.png"),
		load(og_link + "5.png"),
		load(og_link + "6.png"),
		load(og_link + "7.png"),
		load(og_link + "8.png"),
		load(og_link + "9.png")]

func _ready():
	pass

func _process(_delta):
	var image_hp_10
	var image_hp_01
	var image_bp_10
	var image_bp_01

	if (hp < 10):
		image_hp_01 = images[hp]
		image_hp_10 = images[0]
	else:
		image_hp_01 = images[int(str(hp)[1])]
		image_hp_10 = images[int(str(hp)[0])]

	if (bp < 10):
		image_bp_01 = images[bp]
		image_bp_10 = images[0]
	else:
		image_bp_01 = images[int(str(bp)[1])]
		image_bp_10 = images[int(str(bp)[0])]
	
	$"UI_Health/HP_01".texture = image_hp_01
	$"UI_Health/BP_01".texture = image_bp_01
	$"UI_Health/HP_10".texture = image_hp_10
	$"UI_Health/BP_10".texture = image_bp_10

	if hide_zeros:
		if (hp < 10):
			$"UI_Health/HP_10".visible = false
		else:
			$"UI_Health/HP_10".visible = true
		
		if (bp < 10):
			$"UI_Health/BP_10".visible = false
		else:
			$"UI_Health/BP_10".visible = true

	if low_health_effect:
		if hp < (max_hp*low_percentage):
			$"UI_Health/HP_01".self_modulate = low_hp_color
			$"UI_Health/HP_10".self_modulate = low_hp_color
		else:
			$"UI_Health/HP_01".self_modulate = Color("white")
			$"UI_Health/HP_10".self_modulate = Color("white")
	if low_health_effect and affect_BP:
		if bp < (max_bp*low_percentage):
			$"UI_Health/BP_01".self_modulate = low_bp_color
			$"UI_Health/BP_10".self_modulate = low_bp_color
		else:
			$"UI_Health/BP_01".self_modulate = Color("white")
			$"UI_Health/BP_10".self_modulate = Color("white")
