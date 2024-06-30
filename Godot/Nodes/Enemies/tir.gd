extends CharacterBody2D
var diférense = Vector2.ZERO
var dont_mov = false
func _on_vol_et_tir_fire(p):
	dont_mov = false
	position = p+diférense
	diférense = PlayerStats.player.position-position 
func _physics_process(delta):
	if dont_mov == false :
		velocity = diférense
		move_and_slide()
func _on_area_2d_body_entered(body):
	pass
