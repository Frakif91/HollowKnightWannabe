extends StaticBody2D
var proche = false
@onready var anim = $"AnimatedSprite2D2"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Attack") and proche == true:
		anim.play("default")


func _body_entered(body):
	if body is MainCharacter:
		proche = true



func _on_area_2d_body_exited(body):
	if body is MainCharacter:
		proche = false


func _on_animated_sprite_2d_2_animation_finished() -> void:
	print("a")
	queue_free()
