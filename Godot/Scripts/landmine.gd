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
		var camera : Camera2D = $".".get_viewport().get_camera_2d()

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
			PlayerStats.hp -= damage 
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
			mario.sprite.play(PlayerStats.anim_name[PlayerStats.anim.HURT])
			if (PlayerStats.hp <= 0):
				mario.call("on_gameover")
			else:
				await wait(0.8)
				mario.is_abletomove = true

