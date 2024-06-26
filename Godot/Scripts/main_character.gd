extends CharacterBody2D

class_name MainCharacter
#var point_de_sovgarde = Vector2.ZERO
#region variable
var SPEED = PlayerStats.SPEED
var JUMP_VELOCITY = PlayerStats.JUMP_VELOCITY
var gravity_mult = PlayerStats.GRAVITY_MULT
var is_attacking = false
var is_in_jump_action = false
var has_double_jump = true
var is_dead = false
var invulnerability_timer = 1.
var is_invulnerable = false
var is_looking_down = false
var hurt_color : Color = Color(1,0,0)
var jump_hold = 10 # Number of frames to hold space (to jump higher)
var jump_remaining = 0
var gameover_load = preload("res://Assets/SFX/lego-breaking.mp3")

var STOPPING_FRICTION = PlayerStats.STOPPING_FRICTION
var ACCELERATION_SPEED = PlayerStats.ACCELERATION_SPEED
var STOPPING_FRICTION_AIRBORN = PlayerStats.STOPPING_FRICTION_AIRBORN
var ACCELERATION_SPEED_AIRBORN = PlayerStats.ACCELERATION_SPEED_AIRBORN

var LOOK_DOWN_Y = PlayerStats.LOOK_DOWN_Y

@onready var anim = PlayerStats.anim
@onready var anim_name = PlayerStats.anim_name
@onready var is_abletomove = PlayerStats.is_abletomove
@onready var wall_slide_enabled = PlayerStats.wall_slide_enabled
@onready var wall_slide_percentage = PlayerStats.wall_slide_percentage
@onready var wall_slide_min_spd = PlayerStats.wall_slide_min_spd
@onready var wall_slide_max_spd = PlayerStats.wall_slide_max_spd
@onready var states = PlayerStats.states
@onready var camera = PlayerStats.camera
@onready var tp_pos = PlayerStats.tp_pos

const suffer = [
	"res://Assets/SFX/STRVOICE_M28_WAAA.rsd.wav",
	"res://Assets/SFX/STRVOICE_M29_UWAA.rsd.wav",
	"res://Assets/SFX/STRVOICE_M30_OOOO.rsd.wav",
	"res://Assets/SFX/STRVOICE_M30_IKU.rsd.wav"
]


# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * self.scale.y * gravity_mult#980
@onready var sprite : AnimatedSprite2D = $"Sprite"
@onready var collision : CollisionPolygon2D = $"Collision"
@onready var audioPlayer : AudioStreamPlayer = $"JumpSFX"
@onready var swingSFX : AudioStreamPlayer = $"SwingSwordSFX"
@onready var jumpSound : AudioStreamOggVorbis = get("res://SML2_Jump.ogg")
@onready var lowlight : PointLight2D = $LowLight
@onready var highlight : PointLight2D = $HighLight
@onready var og_lowlight : PointLight2D = lowlight.duplicate()
@onready var og_highlight : PointLight2D = highlight.duplicate()
@onready var gameover_player : AudioStreamPlayer = AudioStreamPlayer.new() ; 
@onready var hit_collition : CollisionPolygon2D = $"Col_Hit/Attack_Area"

func _ready():
	gameover_player.stream = gameover_load
	self.add_child(gameover_player)
	sprite.play("Stand")
	#print(self.scale.y)
	#print($"Collision".visible ,typeof($"Collision"))
	if tp_pos != Vector2.ZERO :
		position = tp_pos
		#camera.position = tp_pos
	hit_collition.disabled = true
	PlayerStats.player = self

func _process(delta):
	var t_colorm = [sprite.modulate.r, sprite.modulate.g, sprite.modulate.b] # Actual color (colorM for Modulate)
	var t_colort = [1,1,1] #Target color (colorT for Target)
	var t_colorw = [delta,delta,delta] #Delta color (colorW for Weight)
	sprite.modulate = Color(
		lerpf(t_colorm[0],t_colort[0],t_colorw[0]),
		lerpf(t_colorm[1],t_colort[1],t_colorw[1]),
		lerpf(t_colorm[2],t_colort[2],t_colorw[2])
	)

func _physics_process(delta):
	#not finished
	PlayerStats.states["IsWallSliding"] = is_on_wall_only()	

	# Add the gravity.
	if not is_on_floor():
		if PlayerStats.wall_slide_enabled and is_on_wall_only() and velocity.y > 0 and PlayerStats.is_abletomove:
			velocity.y += (gravity * delta) * PlayerStats.wall_slide_percentage
			velocity.y = clamp(velocity.y, PlayerStats.wall_slide_max_spd, PlayerStats.wall_slide_min_spd)
		else:
			velocity.y += (gravity * delta)
		if (velocity.y < 0) and not PlayerStats.states["InGameoverState"] and PlayerStats.is_abletomove: # y < 0 = HIGHER
			sprite.play(PlayerStats.anim_name[PlayerStats.anim.JUMP])
		elif (velocity.y > 0) and not PlayerStats.states["InGameoverState"] and PlayerStats.is_abletomove:
			sprite.play(PlayerStats.anim_name[PlayerStats.anim.FALL])

	# Handle jump.
	"""
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or not states["HasDoubleJumped"]) and not states["InGameoverState"] and PlayerStats.is_abletomove:
		velocity.y = JUMP_VELOCITY
		audioPlayer.play()
		if not is_on_floor() and states["HasDoubleJumped"] == false:
			states["HasDoubleJumped"] = true
	"""	

	if Input.is_action_just_pressed("Jump") and PlayerStats.is_abletomove and not PlayerStats.states["InGameoverState"]:
		if is_on_floor():
			PlayerStats.jump_remaining = PlayerStats.JUMP_HOLD
			audioPlayer.play()
			velocity.y = PlayerStats.JUMP_VELOCITY
		elif (not is_on_floor() and PlayerStats.jump_remaining <= 0) and has_double_jump:
			audioPlayer.play()
			has_double_jump = false
			velocity.y = PlayerStats.JUMP_VELOCITY * 1.2
	
	if Input.is_action_pressed("Jump") and (PlayerStats.jump_remaining > 0) and PlayerStats.is_abletomove and not PlayerStats.states["InGameoverState"]:
		velocity.y = PlayerStats.JUMP_VELOCITY
		PlayerStats.jump_remaining -= 1		

	# Stop Holding Button "Jump" or Bumped Head on Celing -> Reset Hold Jump
	if Input.is_action_just_released("Jump") or is_on_ceiling_only():
		PlayerStats.jump_remaining = 0
	
	if is_on_floor():
		has_double_jump = true

	# Handle Attacks
	if Input.is_action_just_pressed("Attack") and is_on_floor() and not is_attacking and PlayerStats.is_abletomove and not PlayerStats.states["InGameoverState"]:
		sprite.play(anim_name[anim.ATTACK])
		swingSFX.play()
		hit_collition.disabled = false
		is_attacking = true
		await wait(0.4)
		hit_collition.disabled = true
		await wait(0.01)
		is_attacking = false
		sprite.play(anim_name[anim.STAND])

	
		
	#region Physics
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Move_Left", "Move_right") * (is_abletomove as float)
	
	if sign(direction) == -1: sprite.flip_h = true ; hit_collition.scale.x = -1
	elif sign(direction) == 1: sprite.flip_h = false ; hit_collition.scale.x = 1

	if is_looking_down:
		direction = 0 #if you're looking down, stops you from moving
	if is_attacking and (not PlayerStats.can_attack_and_slide):
		direction = 0
	if camera.menu_visible:
		direction = 0

	
	if direction:
		if is_on_floor() and (not PlayerStats.states["InGameoverState"] and PlayerStats.is_abletomove and not is_attacking):
			sprite.play(anim_name[anim.WALK])
			velocity.x = move_toward(velocity.x,direction * SPEED, delta * ACCELERATION_SPEED)
		else:
			velocity.x = move_toward(velocity.x,direction * SPEED, delta * ACCELERATION_SPEED_AIRBORN)
	else:
		if is_on_floor() and (not PlayerStats.states["InGameoverState"] and PlayerStats.is_abletomove and not is_attacking):
			sprite.play(anim_name[anim.STAND])
			velocity.x = move_toward(velocity.x, 0, delta * STOPPING_FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, delta * STOPPING_FRICTION_AIRBORN)
	
	if Input.is_action_pressed("Look_Down") and is_on_floor():
		sprite.play("LookDown")
		is_looking_down = true
		camera.offset.y = lerpf(camera.offset.y,LOOK_DOWN_Y,0.1)
	else:
		is_looking_down = false
		camera.offset.y = lerpf(camera.offset.y,0,0.1)

	
	if Input.is_action_just_pressed("Gameover") and is_on_floor() and is_abletomove:
		on_gameover()

	PlayerStats.velocity = velocity
	move_and_slide()
	#endregion

func wait(time:float):
	await get_tree().create_timer(time).timeout


func on_gameover():
	PlayerStats.gameover.emit()
	PlayerStats.states["InGameoverState"] = true
	PlayerStats.is_abletomove = false
	var gamover_sound = gameover_load.instantiate_playback()
	sprite.play("Gameover")
	gameover_player.play()
	await sprite.animation_finished
	await wait(1)
	await Transitions.change_scene("reload","fade_out")
	PlayerStats.load_file(PlayerStats.save_types.DEFAULT)


"""
func on_gameover():
	#region On Gameover
		velocity.y = -250
		PlayerStats.is_abletomove = false
		states["InGameoverState"] = true
		sprite.stop()
		sprite.play(anim_name[anim.HURT])
		audioPlayer.stream = load(suffer.pick_random())
		audioPlayer.play()
		print("JUMP")
		move_and_slide()
		await ground()
		print("STOP")
		audioPlayer.stream = load("res://Assets/SFX/STRVOICE_M17_GAMEOVER.rsd.wav")
		audioPlayer.play()
		sprite.play(anim_name[anim.OVER])
		print("TIME AS COME")
		await sprite.animation_finished
		print("QUITING")
		await Transitions.play("fade_out")
		await wait(1)
		print("Wait for ready")
		Transitions.play("fade_in")
		get_tree().reload_current_scene()
		PlayerStats.is_abletomove = true
		PlayerStats.states["InGameoverState"] = false
		#endregion
"""

func ground():
	if is_on_floor():
		return true
	else:
		while not is_on_floor(): await wait(0.1)
		return true

@onready var sound : AudioStreamPlayer = $"Sound"
@onready var defeat_sound = load("res://Assets/SFX/LC_SFX/614. Slam Ground.mp3")
@onready var hurt_sound = load("res://Assets/SFX/LC_SFX/592. Shovel Hit Default.mp3")
@onready var Invincibility_Timer : Timer = $ITimer

func _on_body_collition(body):
	if body is Ennemies:
		when_hit(body.damage_dealt)
	"""_add_constant_torqueif body is Interaction:
		if body.type == "Spikes":
			_on_spike_collition(body.spike_damage)
		elif body.type == "Checkpoint":
			_on_checkpoint_collition(body)
		elif body.type == "Chest":
			pass"""

func when_hit(damage):
	#Cannot check collition so, check Roach.gd for this function "call"
	#print_debug("Body in Collition")
	is_dead = await get_hurt(damage)
	if is_dead:
		on_gameover()

func get_hurt(damage):
	if not is_invulnerable:
		PlayerStats.hp -= damage
		sound.stream = hurt_sound
		sound.play()
		sprite.modulate = hurt_color
		is_invulnerable = true
		if PlayerStats.hp <= 0:
			return true
		Invincibility_Timer.start(invulnerability_timer)
		await Invincibility_Timer.timeout
		is_invulnerable = false
		return false
