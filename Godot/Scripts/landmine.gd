extends Area2D

@onready var boom_audio : AudioStreamPlayer2D = $"AStreamer"
@onready var anim_player : AnimationPlayer = $"AnimPlayer"
var audio1 : AudioStreamMP3
var audio2 : AudioStreamMP3
@export_range(0,20.0,0.1) var ejection_power = 5.0
@export_range(0,10.0,0.1) var mario_x_boost = 3.0
@export_range(0,10.0,0.1) var mario_y_boost = 0.5
@export var eject_max_range = 150.0
@export var max_damage = 30
# Called when the node enters the scene tree for the first time.

func _ready():
	audio1 = boom_audio.stream
	audio2 = load("res://Assets/SFX/LC_SFX/464. Mine Detonate.mp3")

func wait(time:float):
	await get_tree().create_timer(time).timeout

func kaboom():
	boom_audio.play()
	anim_player.play("starting")

func _on_body_entered(body:Node2D):
	if (body is CharacterBody2D):
		var ui : Control = %"UI"
		var mario = body
		var camera : Camera2D = %"Camera"
		#If UI and CAMERA not found.
		if (ui == null) and (camera == null):
			printerr("UI and Camera" + error_string(ERR_DOES_NOT_EXIST))
			print_debug("Both The UI and Camera were not found.")
			return null
		#if UI not found BUT Camera found
		elif (ui==null) and (camera != null):
			ui = camera.get_node_or_null(NodePath(camera.get_path() as String + "/ScreenAnchor/UI"))
			#if still not found. terminate.
			if (ui == null):
				printerr("The UI Was Still Not found")
				print_debug("Camera : ", camera.get_path())
				print_debug("Camera : ", (camera.get_path() as String) + "/ScreenAnchor/UI")
				return null
		#If shit is fine then continue to do some drugs. (idk jk)
		if (ui != null):
			if mario.states["IsInGameover"]:
				return null
			boom_audio.stream = audio1
			kaboom()
			await wait(0.7)
			camera.apply_shake(20.0)
			boom_audio.stop()
			boom_audio.stream = audio2
			boom_audio.play()
			var damage = clamp(eject_max_range - self.position.distance_to(mario.position),0,eject_max_range)/eject_max_range*max_damage
			ui.hp = ui.hp - damage 
			if damage != 0:
				mario.is_abletomove = true
			var eject_direction : Vector2 = self.position.direction_to(mario.position)
			var eject_power : float = clamp(eject_max_range - self.position.distance_to(mario.position),0,eject_max_range)
			mario.velocity = eject_direction * eject_power * ejection_power
			print("Puissance d'ejection : ",eject_power," Vecteur : ",eject_direction, " Total : ", eject_direction * eject_power)
			print(mario.velocity,mario)
			mario.velocity.x *= mario_x_boost
			mario.velocity.y *= mario_y_boost
			mario.move_and_slide()
			mario.sprite.play(mario.anim_name[mario.anim.HURT])
			if (ui.hp <= 0):
				mario.call("on_gameover")
			else:
				await wait(0.8)
				mario.is_abletomove = true

