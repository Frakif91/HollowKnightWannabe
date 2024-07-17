extends StaticBody2D

class_name Door_Interact

@onready var sprite : Sprite2D = $"./Sprite2D"
@onready var collision : CollisionShape2D = $"./Col"
@onready var label : Label = $"./Label"

@export var Lever1 : MapObject
@export var Lever2 : MapObject
@export var Lever3 : MapObject

@export var open_sfx : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.modulate = Color(1,1,1,1)
	if open_sfx:
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
	sprite.frame = 0
	collision.disabled = false
	label.show()
	sprite.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
var i = 0
func _on_lever_refresh():
	i = 0
	if Lever1.already_interacted_with_levier:
		i += 1
	if Lever2.already_interacted_with_levier:
		i += 1
	if Lever3.already_interacted_with_levier:
		i += 1
	sprite.frame = i

	if i == 3:
		collision.disabled = true
		label.hide()
		PlayerStats.player.is_abletomove = false
		PlayerStats.player.in_cutscene = true
		await PlayerStats.camera.cam_focus.focus()
		#PlayerStats.player.sprite.flip_h = sign(PlayerStats.player.position.x)
		var current_follow = PlayerStats.camera.follow_node
		PlayerStats.camera.follow_node = null
		await PlayerStats.camera.cam_follow.tween_position(PlayerStats.player.position, position, 2)
		# PlayerStats.camera.cam_follow.tween_override = true
		# Tween.interpolate_value(PlayerCamera.player.position, PlayerCamera.player.position - position, 0, 2, Tween.TRANS_CUBIC, ease(
		# PlayerStats.camera.cam_follow.tween_override = true
		await wait(0.1)
		sprite.hide()
		PlayerStats.camera.cam_shake.shake_camera(5,10)
		$"OpeningSFX".play()
		await wait(1)
		
		PlayerStats.camera.follow_node = current_follow
		PlayerStats.camera.cam_focus.unfocus()
		PlayerStats.player.in_cutscene = false
		PlayerStats.player.is_abletomove = true

func wait(seconds : float):
	await get_tree().create_timer(seconds).timeout