"""
# PlayerState
PlayerState is a GDScript outside the SceneTree (Autoload) used to store variable about the player 
"""

extends Node

@onready var is_debug = OS.is_debug_build()

const save_path = "user://gamesave.save"

@export var Default_Variable : Dictionary = {
	"hp"							= 12,
	"max_hp"						= 12,
	"max_bp"						= 15,
	"SPEED"							= 125.0,
	"JUMP_VELOCITY"					= -170.0,
	"GRAVITY_MULT"					= 1.2,
	"STOPPING_FRICTION"				= 1000,
	"ACCELERATION_SPEED"			= 600,
	"STOPPING_FRICTION_AIRBORN"		= 10,
	"ACCELERATION_SPEED_AIRBORN"	= 350,
	"LOOK_DOWN_Y"					= 50,
	"can_attack_and_slide" 			= false,
	"wall_slide_enabled" 			= false,
 	"wall_slide_percentage" 		= 0.2,
	"wall_slide_min_spd" 			= 50.0,
 	"wall_slide_max_spd"			= 10.0,
	"money"							= 0,
	"level"							= 1,
	"damage"						= 1,
	"defense"						= 1,
	"xp"							= 0,
}


@export_category("Health & BP")
@export var max_hp : int = 12
@export var max_bp : int = 1
@export var hp : int = 12 :
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
@export var JUMP_VELOCITY = -170.0
@export var GRAVITY_MULT = 1.2
@export var STOPPING_FRICTION = 1000
@export var ACCELERATION_SPEED = 600
@export var STOPPING_FRICTION_AIRBORN = 10
@export var ACCELERATION_SPEED_AIRBORN = 350
@export var LOOK_DOWN_Y = 50
@export var JUMP_HOLD = 12
enum anim {WALK, STAND, JUMP, FALL, HURT, OVER, ATTACK}
const anim_name : Array[String] = ["Walk", "Stand", "Jump", "Fall", "Hurt", "Gameover", "Swing_Sword"]
var is_abletomove = true
var tp_pos = Vector2(0,0)
var player : MainCharacter
var camera : Camera2D
var safety_checkpoint_pos = Vector2(0,0)
var velocity # No use
var jump_remaining = JUMP_HOLD
var hurt_color = Color(1,0,0,1)
@export_category("Others")
@export var can_attack_and_slide : bool = false
@export var wall_slide_enabled = false
@export var wall_slide_percentage = 0.2
@export var wall_slide_min_spd = 50.0
@export var wall_slide_max_spd = 10.0


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

enum save_types {DEFAULT,GAMEPLAY,ENTIRE,INVENTORY,SCENE}

func save_file(type):
	printraw("Saving...")
	match(type):
		save_types.DEFAULT:
			print(" DEFAULT Variable")
			hp = Default_Variable["hp"]
			max_hp = Default_Variable["max_hp"]
			SPEED = Default_Variable["SPEED"]
			JUMP_VELOCITY = Default_Variable["JUMP_VELOCITY"]
			can_attack_and_slide = Default_Variable["can_attack_and_slide"]
			wall_slide_enabled = Default_Variable["wall_slide_enabled"]
			money = Default_Variable["money"]
			is_abletomove = true
			PlayerStats.states["InGameoverState"] = false

		save_types.GAMEPLAY:
			print(" GAMEPLAY Variable")
			#if FileAccess.file_exists(save_path):
			var file = FileAccess.open(save_path, FileAccess.WRITE)
			print("OPEN : " + error_string(FileAccess.get_open_error()))
			file.store_var(hp)
			file.store_var(max_hp)
			file.store_var(SPEED)
			file.store_var(JUMP_VELOCITY)
			file.store_var(can_attack_and_slide)
			file.store_var(wall_slide_enabled)
			file.store_var(money)
			file.store_var(is_abletomove)
			file.store_var(PlayerStats.states["InGameoverState"])
			file.store_var(get_tree())
			if player:
				file.store_var(player.position)
			else:
				file.store_var(Vector2(0,0))
			file.close()
			

func load_file(type):
	match(type):
		save_types.DEFAULT:
			hp = Default_Variable["hp"]
			max_hp = Default_Variable["max_hp"]
			SPEED = Default_Variable["SPEED"]
			JUMP_VELOCITY = Default_Variable["JUMP_VELOCITY"]
			can_attack_and_slide = Default_Variable["can_attack_and_slide"]
			wall_slide_enabled = Default_Variable["wall_slide_enabled"]
			money = Default_Variable["money"]
			is_abletomove = true
			PlayerStats.states["InGameoverState"] = false
		save_types.GAMEPLAY:
			if FileAccess.file_exists(save_path):
				var file = FileAccess.open(save_path, FileAccess.READ)
				print("OPEN : " + error_string(FileAccess.get_open_error()))
				hp =					 				file.get_var()
				max_hp = 								file.get_var()
				SPEED = 								file.get_var()
				JUMP_VELOCITY = 						file.get_var()
				can_attack_and_slide = 					file.get_var()
				wall_slide_enabled = 					file.get_var()
				money = 								file.get_var()
				is_abletomove = 						file.get_var()
				PlayerStats.states["InGameoverState"] = file.get_var()
				get_tree().change_scene_to_packed(		file.get_var())
				tp_pos =								file.get_var()
				file.close()
			else:
				printerr("File Doesn't exist !")



signal lose_health
signal gain_health
signal gameover
