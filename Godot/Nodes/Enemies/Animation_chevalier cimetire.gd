extends CharacterBody2D
var PlayerPosition = Vector2.ZERO
var DchevalierPlayer = Vector2.ZERO
var vitese = Vector2(0.5,0)
var is_animemete = false
@onready var animation_player = $sekelétoneconténeur/AnimationPlayer
func _ready():
	pass
func _physics_process(delta):
	if is_animemete == false:
		await mouvemen()
	PlayerPosition = PlayerStats.player.position
	DchevalierPlayer = PlayerPosition - position
	print(DchevalierPlayer)

func mouvemen():
	if DchevalierPlayer[0] < -50 :
		animation_player.play("marche")
		position += -vitese
	elif DchevalierPlayer[0] > 50 :
		animation_player.play("marche")
		position += vitese
	else :
		is_animemete = true
		animation_player.play("frap loude")
		await animation_player.animation_finished
		is_animemete = false


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
