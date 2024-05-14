extends CharacterBody2D

class_name Ennemies

@export_category("Stats")

var is_dead = false
@export var speed = 20
@export var runing_speed = 200
@export var health : int = 2
var invulnerability_timer = 1.
var is_invulnerable = false 
var gravity = 50
var hurt_color : Color = Color(1,0,0)

@export_category("Behavior")
enum movement_type {XAXIS,YAXIS,BAXIS,NAXIS}
enum states {IDLE, MOVING, CHASING, SCARED, DEAD}
enum entity_type {ROACH,FLY}
@export var cur_entity_type : entity_type = entity_type.ROACH

var move_direction_right = false
@export_enum("X (↔) Axis","Y (↕) Axis","Both Axis","None") var ex_movement_type : int = movement_type.NAXIS

#@export var position1 : Marker2D
#@export var position2 : Marker2D

@onready var sound : AudioStreamPlayer = $"Sound"
@onready var defeat_sound = load("res://Assets/SFX/LC_SFX/614. Slam Ground.mp3")
@onready var hurt_sound = load("res://Assets/SFX/LC_SFX/592. Shovel Hit Default.mp3")
@onready var Invincibility_Timer : Timer = $ITimer

@onready var damage_trigger = $"Damage_Trigger"
@onready var sprite : AnimatedSprite2D = $"ASprite"

# test
var old_target_direction_is_s = false

func _ready():
	pass
	#damage_trigger.body_entered.connect(_body_entered)

func _process(delta):

	var turn = sign(velocity.x)
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	move()

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c == MainCharacter:
			c.when_hit()


	var t_colorm = [modulate.r,modulate.g,modulate.b] # Actual color
	var t_colort = [1,1,1] #Aimed color
	var t_colorw = [0.1,0.1,0.1] #Delta color
	modulate = Color(
		lerpf(t_colorm[0],t_colort[0],t_colorw[0]),
		lerpf(t_colorm[1],t_colort[1],t_colorw[1]),
		lerpf(t_colorm[2],t_colort[2],t_colorw[2])
	)
	if is_invulnerable:
		#wierd number and ten's because '%' modulo function cannot be used with int 
		var temp_time_left = int(Invincibility_Timer.time_left*1000) #time between 0 and invulnerability_timer
		var temp_blinking_interval = 100 # 0.1 * 1000
		visible = (temp_time_left % temp_blinking_interval) < (temp_blinking_interval / 2)
	else:
		visible = true

	if is_dead:
		sprite.flip_v = true

func _body_entered(body):
	if body is Col_Hit:
		#print_debug("Body in Collition",body)
		is_dead = await get_hurt()
		if is_dead:
			sound.stream = defeat_sound
			sound.play()
			await sound.finished
			queue_free()
	if body is MainCharacter:
		#print Touched
		print_debug("Touched")
		body.when_hit()

func _old_move():
	#Old Code -> not working and i did a burnout
	"if position1 and position2: #If both markers are present
		var omw_direction = Vector2(0,0)
		match ex_movement_type:
			movement_type.XAXIS: #Move left to right
				if movement_target_spos:
					omw_direction.x = sign(self.position.x - position1.position.x)
				else:
					omw_direction.x = sign(self.position.x - position2.position.x)
				#
				if movement_target_spos and ((self.position.x - position1.position.x) < speed):
					change_direction(false)
				elif not movement_target_spos and ((self.position.x - position2.position.x) < speed):
					change_direction(true)
			movement_type.YAXIS: #Move up and down
				if movement_target_spos:
					omw_direction.y = sign(self.position.y - position1.position.y)
				else:
					omw_direction.y = sign(self.position.y - position2.position.y)
				#
				if movement_target_spos and (abs(self.position.y - position1.position.y) < speed):
					change_direction(true)
				elif not movement_target_spos and (abs(self.position.y - position2.position.y) < speed):
					change_direction(false)
			movement_type.BAXIS: #Move left, up, right and down
				if movement_target_spos:
					omw_direction.x = sign(self.position.x - position1.position.x)
					omw_direction.y = sign(self.position.y - position1.position.y)
				else:
					omw_direction.x = sign(self.position.x - position2.position.x)
					omw_direction.y = sign(self.position.y - position2.position.y)
				#
				if movement_target_spos and ((abs(self.position.x - position1.position.x) < speed) or (abs(self.position.y - position1.position.y) < speed)):
					change_direction(true)
				elif not movement_target_spos and ((abs(self.position.x - position2.position.x) < speed) or (abs(self.position.y - position2.position.y) < speed)):
					change_direction(false)
			movement_type.NAXIS: #Don't move
				omw_direction = Vector2.ZERO
		if ex_movement_type != movement_type.NAXIS:
			omw_direction = omw_direction.normalized()

		velocity = omw_direction * speed
		move_and_slide()
	else:
		if ex_movement_type != movement_type.NAXIS:
			'print_debug('Markers are invalid / absent')"

func move():
	if is_on_wall():
		move_direction_right = not move_direction_right
	
	velocity.x = ((int(move_direction_right) * 2) - 1) * speed
	velocity.y = gravity
	if not is_dead:
		move_and_slide()
"
func change_direction(direction_s):
	movement_target_spos = direction_s
	printerr('Changing direction')
"

func get_hurt():
	if not is_invulnerable:
		health -= 1
		sound.stream = hurt_sound
		sound.play()
		modulate = hurt_color
		is_invulnerable = true
		if health < 0:
			return true
		Invincibility_Timer.start(invulnerability_timer)
		await Invincibility_Timer.timeout
		is_invulnerable = false
		return false
