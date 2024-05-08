extends CharacterBody2D

var is_dead = false
var speed = 100
var runing_speed = 200
var health : int = 2
var invulnerability_timer = 1.
var is_invulnerable = false
var movement_target_spos = false

enum movement_type {XAXIS,YAXIS,BAXIS,NAXIS}
@export_enum("X (↔) Axis","Y (↕) Axis","Both Axis","None") var ex_movement_type : int = movement_type.NAXIS

@export var position1 : Marker2D
@export var position2 : Marker2D
enum states {IDLE, MOVING, CHASING, SCARED, DEAD}
enum behaviors {ROACH}
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

	var t_colorm = [modulate.r,modulate.g,modulate.b] # Actual color
	var t_colort = [1,1,1] #Aimed color
	var t_colorw = [0.1,0.1,0.1] #Delta color
	modulate = Color(
		lerpf(t_colorm[0],t_colort[0],t_colorw[0]),
		lerpf(t_colorm[1],t_colort[1],t_colorw[1]),
		lerpf(t_colorm[2]*delta,t_colort[2]*delta,t_colorw[2]*delta)
	)
	if is_invulnerable:
		#wierd number and ten's because '%' modulo function cannot be used with int 
		var temp_time_left = int(Invincibility_Timer.time_left*1000) #time between 0 and invulnerability_timer
		var temp_blinking_interval = 100 # 0.1 * 1000
		visible = (temp_time_left % temp_blinking_interval) < (temp_blinking_interval / 2)
	else:
		visible = true

func _body_entered(body):
	if body is MainCharacter or body is CharacterBody2D:
		print_debug("Body in Collition",body)
		is_dead = await get_hurt()
		if is_dead:
			sound.stream = defeat_sound
			sound.play()
			await sound.finished
			queue_free()

func move():
	if position1 and position2: #If both markers are present
		var omw_direction = Vector2(0,0)
		match ex_movement_type:
			movement_type.XAXIS: #Move left to right
				if movement_target_spos:
					omw_direction.x = sign(self.position.x - position1.position.x)
				else:
					omw_direction.x = sign(self.position.x - position2.position.x)
				#
				if movement_target_spos and ((self.position.x - position1.position.x) < speed):
					movement_target_spos = true
				elif not movement_target_spos and ((self.position.x - position2.position.x) < speed):
					movement_target_spos = false
			movement_type.YAXIS: #Move up and down
				if movement_target_spos:
					omw_direction.y = sign(self.position.y - position1.position.y)
				else:
					omw_direction.y = sign(self.position.y - position2.position.y)
				#
				if movement_target_spos and (abs(self.position.y - position1.position.y) < speed):
					movement_target_spos = true
				elif not movement_target_spos and (abs(self.position.y - position2.position.y) < speed):
					movement_target_spos = false
			movement_type.BAXIS: #Move left, up, right and down
				if movement_target_spos:
					omw_direction.x = sign(self.position.x - position1.position.x)
					omw_direction.y = sign(self.position.y - position1.position.y)
				else:
					omw_direction.x = sign(self.position.x - position2.position.x)
					omw_direction.y = sign(self.position.y - position2.position.y)
				#
				if movement_target_spos and ((abs(self.position.x - position1.position.x) < speed) or (abs(self.position.y - position1.position.y) < speed)):
					movement_target_spos = true
				elif not movement_target_spos and ((abs(self.position.x - position2.position.x) < speed) or (abs(self.position.y - position2.position.y) < speed)):
					movement_target_spos = false
			movement_type.NAXIS: #Don't move
				omw_direction = Vector2.ZERO
		if ex_movement_type != movement_type.NAXIS:
			omw_direction = omw_direction.normalized()
		
		if movement_target_spos != old_target_direction_is_s:
			old_target_direction_is_s = movement_target_spos
			printerr("Changing Directions")
		velocity = omw_direction * speed
		move_and_slide()
	else:
		if ex_movement_type != movement_type.NAXIS:
			print_debug("Markers are invalid / absent")


func get_hurt():
	if not is_invulnerable:
		health -= 1
		sound.stream = hurt_sound
		sound.play()
		modulate = Color(1,0,0)
		is_invulnerable = true
		if health < 0:
			return true
		Invincibility_Timer.start(invulnerability_timer)
		await Invincibility_Timer.timeout
		is_invulnerable = false
		return false
