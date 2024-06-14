extends CharacterBody2D
var toucher = false
var premire_position = Vector2.ZERO
@export var direction = Vector2.ZERO


func _on_area_2d_body_entered(body):
	if body is MainCharacter and toucher == false :
		toucher = true
		premire_position = position
func _physics_process(delta):
	if toucher == true:
		velocity = direction
		move_and_slide()
		if velocity == Vector2.ZERO:
			position = premire_position
			toucher = false
