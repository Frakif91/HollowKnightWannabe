extends CharacterBody2D
var diférense = Vector2.ZERO
var dont_mov = false
func _physics_process(delta):
	if dont_mov == false :
		velocity = diférense
		move_and_slide()
func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		position = Vector2(1000,1000)


func _on_vol_et_tir_fier(P):
	dont_mov = false
	position = P
	diférense = PlayerStats.player.position-position
