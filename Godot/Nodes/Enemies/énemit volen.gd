extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
var différence = 0
var good_distance = 50
var around_distance = 10
var move_speed = 100

var can_shot = true
signal fire

func _physics_process(delta):
	anim.play("default")
	
	différence = position - PlayerStats.player.position
	if différence.length() < good_distance + around_distance: # and différence.length() < good_distance - around_distance:
		velocity = différence.normalized() * move_speed
	else :
		velocity = différence.normalized() * move_speed * -1 + Vector2(0,-10)
		if can_shot == true :
			shot()
		#velocity = Vector2( Vector2(position - PlayerStats.player.position).normalized() * 90 - (position - PlayerStats.player.position)).normalized() * move_speed
	# if diférence < Vector2(120,120) and  diférence > Vector2(-120,-120):
	# 	if diférence[0] > 90 or diférence[0] < -90 :
	# 		velocity[0] = diférence[0]*-1
	# 	elif -60 < diférence[0] and diférence[0]< 60:
	# 		velocity[0] = diférence[0]
	
	# 	if diférence[1] > 50 or diférence[1] < -50 :
	# 		velocity[1] = diférence[1] * -1
	# 	elif -30 < diférence[1] and diférence[1] < 30:
	# 		velocity[1] = diférence[1]
	# 	if diférence < Vector2(90,50) and diférence > Vector2(80,40) and can_shot == true :
	# 		shot()
	# 	elif  diférence > Vector2(-90,-50) and diférence < Vector2(-80,-40) and can_shot == true :
	# 		shot()
	move_and_slide()

func shot():
	can_shot =false
	emit_signal("fire",position)
	await get_tree().create_timer(3.0).timeout
	can_shot = true
