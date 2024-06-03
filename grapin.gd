extends CharacterBody2D
var droit = true
var temps = 0.1
var direction = Vector2.ZERO
var tire = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_body_entered().connect(_on_body_entered)

func _on_body_entered(body):
	if is_instance_of(body,TileMap):
		print("a")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tire == false :
		if Input.is_action_just_pressed("Move_Left"):
			direction.x = -10
		elif Input.is_action_just_released("Move_Left"):
			direction.x=0
		if Input.is_action_just_pressed("Move_right"):
			direction.x = 10
		elif Input.is_action_just_released("Move_right"):
			direction.x=0
		if  Input.is_action_just_pressed("look_up"):
			direction.y = -10
		elif Input.is_action_just_released("look_up"):
			direction.y=0
		if Input.is_action_just_pressed("Look_Down"):
			direction.y = 10
		elif Input.is_action_just_released("Look_Down"):
			direction.y=0
	if Input.is_action_just_pressed("Attack")and tire == false and direction != Vector2.ZERO:
		tire=true
		position = PlayerStats.player.position
		await mouve()
		tire =false
		direction = Vector2.ZERO

func mouve():
	for i in range(12):
		position+= direction
		await get_tree().create_timer(0.1).timeout
