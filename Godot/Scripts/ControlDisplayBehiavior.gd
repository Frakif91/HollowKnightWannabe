extends Control

class_name Instructions

@export_node_path("AnimationPlayer") var animplayer_np : NodePath = ^"AnimationPlayer"
#@export_node_path("MainCharacter") var player_np : NodePath = ""
@onready var anim : AnimationPlayer = get_node(animplayer_np)
#@onready var player : MainCharacter = get_node(player_np)
const wait_time = 6
var timeing = 0
var showed = false

const animations = ["RESET","ON","OFF","Turning_on"]

func _ready():
	set_off()
	showed = false

func _process(delta):
	if PlayerStats.velocity == Vector2.ZERO:
		if timeing < wait_time:
			timeing += delta
		else:
			if showed == false:
				showed = true
				set_show()
	else:
		timeing = 0
		if showed == true:
			showed = false
			set_hide()
		


func set_hide():
	anim.play_backwards("Turning_on")
func set_show():
	anim.play("Turning_on",-1,0.5)
func set_on():
	anim.play("ON")
func set_off():
	anim.play("OFF")