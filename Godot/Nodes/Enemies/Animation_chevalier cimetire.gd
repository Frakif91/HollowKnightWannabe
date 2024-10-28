extends CharacterBody2D
var PlayerPosition = Vector2.ZERO
var DchevalierPlayer = Vector2.ZERO #dinstance séparent le joueur et le bosse "chevailer"
var vitese = Vector2(0.5,0)
var a =false
var is_animemete = false #est entrain de jouer une animation 

@onready var animation_player = $sekelétoneconténeur/AnimationPlayer
func _ready():
	pass
func _physics_process(delta):
	if is_animemete == true :
		mouvemen()
	if is_animemete == false:
		await animation()
	PlayerPosition = PlayerStats.player.position
	DchevalierPlayer = PlayerPosition - position

func animation():
	if DchevalierPlayer[0] < -50 :
		animation_player.play("marche")
	elif DchevalierPlayer[0] > 50 :
		animation_player.play("marche")
	else :
		animation_player.play("frap loude")
	is_animemete= true


func mouvemen():
	if DchevalierPlayer[0] < -50 :
		position += -vitese
	elif DchevalierPlayer[0] > 50 :
		position += vitese




func _on_animation_player_animation_finished(anim_name):
	is_animemete = false
