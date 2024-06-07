extends CharacterBody2D
var droit = true
var shoot_time = 0.1
var cooldown = 0.5
var direction = Vector2.ZERO
var shooting = false
var speed = 500
var progression = 0

@onready var direction_indicator = $"Indicator"

func _on_body_entered(body):
	if is_instance_of(body,TileMap):
		print("a")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shooting == false:
		direction = Vector2.ZERO
		if Input.get_axis(&"Move_Left",&"Move_right"):
			direction.x = Input.get_axis(&"Move_Left",&"Move_right")
		if Input.get_axis(&"look_up",&"Look_Down"):
			direction.y = Input.get_axis(&"look_up",&"Look_Down")
	
	# Indicateur Visuel sur la direction
	if direction and PlayerStats.player: #Vérifier si on pointe bien une direction et que le joueur
		direction_indicator.global_position = PlayerStats.player.position + (direction * 20)

	if Input.is_action_just_pressed("Attack") and not shooting: #Si tu peux attaquer
		shoot() #alors Attaque
	
	if shooting:
		progression += 1
		position = PlayerStats.player.position
		#print(direction,speed,progression)
		velocity = direction * speed * progression
		move()

func shoot():
	shooting = true
	progression = 0
	position = PlayerStats.player.position
	await wait(shoot_time)
	progression = 0
	shooting = false

func move():
	move_and_slide()

func wait(time:float):
	await get_tree().create_timer(time).timeout
