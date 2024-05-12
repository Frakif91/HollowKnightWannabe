"""
# PlayerState
PlayerState is a GDScript outside the SceneTree (Autoload) used to store variable about the player 
"""

extends Node

@onready var is_debug = OS.is_debug_build()

@export_category("Health & BP")
@export var max_hp : int = 20
@export var max_bp : int = 15
@export var hp : int = 10 :
	set(heal):
		print(heal)
		var value = heal - hp
		if (value > 0):
			if is_debug:
				print("Mario got healed by " + str(value) + "HP")
			gain_health.emit(value)
			var old_hp = hp
			hp = clamp(heal,0,max_hp)
			return hp  - old_hp
		elif (value < 0):
			if is_debug:
				print("Mario got damaged by " + str(value) + "HP")
			lose_health.emit(value)
			var old_hp = hp
			hp = clamp(heal,0,max_hp)
			return hp  - old_hp
		else:
			print("Didn't do shit")
			return 0
	get:
		return clamp(hp,0,max_hp)

#@export var hide_zeros = true
#@export_range(0,1,0.01) var low_percentage = 0.33
#@export_category("\"Low\" Effect")
#@export var low_health_effect : bool = true
#@export var affect_BP : bool = false
#@export var low_hp_color = Color(1, 0.322, 1)
#@export var low_bp_color = Color(0.5, 0.5, 0.5)

@export_category("Movement")
@export var SPEED = 125.0
@export var JUMP_VELOCITY = -270.0
@export var GRAVITY_MULT = 1.2
@export var STOPPING_FRICTION = 1000
@export var ACCELERATION_SPEED = 500
@export var STOPPING_FRICTION_AIRBORN = 1
@export var ACCELERATION_SPEED_AIRBORN = 250
@export var LOOK_DOWN_Y = 30
enum anim {WALK, STAND, JUMP, FALL, HURT, OVER, ATTACK}
const anim_name : Array[String] = ["Walk", "Stand", "Jump", "Fall", "Hurt", "Gameover", "Swing_Sword"]
var is_abletomove = true
var tp_pos = Vector2(0,0)
var velocity
@export_category("Others")
@export var can_attack_and_slide : bool = false
@export var wall_slide_enabled = false
@export var wall_slide_percentage = 0.2
@export var wall_slide_min_spd = 50.0
@export var wall_slide_max_spd = 10.0
var camera : Camera2D

@export_category("RPG - Stats")
@export var level : int = 0
@export var xp : int = 0
@export var money : int = 0
@export var speed_multiplier : float = 1.0
@export var jump_multiplier : float = 1.0

var states : Dictionary = {
	"Walking"=false,
	"Jumping"=false,
	"InGameoverState"=false,
	"IsVisible"=false,
	"HasDoubleJumped"=false,
	"IsWallSliding"=false,
	"IsInvincible"=false,
	"LowHealth"=false,
	"CanMove"=true}

var inventory : Dictionary = {
	"Helmet"			: 0,
	"Chestplate"		: 0,
	"Boots"  			: 0,
	"Main Hand"			: 0,
	"Second Hand"		: 0,
}

signal lose_health
signal gain_health
signal gameover