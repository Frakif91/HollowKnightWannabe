extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
var diférence = 1
var can_shot = true
signal fire

func _physics_process(delta):
	anim.play("default")
	diférence = position - PlayerStats.player.position
	if diférence < Vector2(120,120) and  diférence > Vector2(-120,-120):
		if diférence[0]>90 or diférence[0]<-90 :
			velocity[0] = diférence[0]*-1
		elif -60 < diférence[0] and diférence[0]< 60:
			velocity[0] = diférence[0]
	
		if diférence[1]>50 or diférence[1]<-50 :
			velocity[1] = diférence[1]*-1
		elif -30 < diférence[1] and diférence[1]< 30:
			velocity[1] = diférence[1]
		if diférence<Vector2(90,50) and diférence > Vector2(80,40) and can_shot == true :
			shot()
		elif  diférence>Vector2(-90,-50) and diférence < Vector2(-80,-40) and can_shot == true :
			shot()
		move_and_slide()
func shot():
	can_shot =false
	emit_signal("fire",position)
	await get_tree().create_timer(1.0).timeout
	can_shot = true
