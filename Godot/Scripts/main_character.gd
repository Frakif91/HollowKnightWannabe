extends CharacterBody2D

class_name MainCharacter

var SPEED = 125.0
var JUMP_VELOCITY = -270.0
var gravity_mult = 1.2
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
@onready var audioPlayer : AudioStreamPlayer = $"Audio"
@onready var jumpSound : AudioStreamOggVorbis = get("res://SML2_Jump.ogg")
@onready var lowlight : PointLight2D = $LowLight
@onready var highlight : PointLight2D = $HighLight
@onready var og_lowlight : PointLight2D = lowlight.duplicate()
@onready var og_highlight : PointLight2D = highlight.duplicate()

func _ready():
	sprite.play("Stand")
	print(self.scale.y)
	#print($"Collision".visible ,typeof($"Collision"))
	if tp_pos != Vector2.ZERO :
		position = tp_pos

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
	else:
		states["HasDoubleJumped"] = false
		if Input.is_action_pressed("Look_Down"):
			sprite.play("LookDown")

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or not states["HasDoubleJumped"]) and not states["InGameoverState"] and is_abletomove:
		velocity.y = JUMP_VELOCITY
		audioPlayer.play()
		if not is_on_floor() and states["HasDoubleJumped"] == false:
			states["HasDoubleJumped"] = true

	if is_on_floor():
		#Do some shit on the floor
		# (put code here)
		pass
		
	#region: physics
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Move_Left", "Move_right") * (is_abletomove as float)
	
	if sign(direction) == -1: sprite.flip_h = true
	elif sign(direction) == 1: sprite.flip_h = false
	
	if direction:
		if is_on_floor() and (not states["InGameoverState"] and is_abletomove): sprite.play(anim_name[anim.WALK])
		velocity.x = direction * SPEED
	else:
		if is_on_floor() and (not states["InGameoverState"] and is_abletomove): sprite.play(anim_name[anim.STAND])
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_pressed("ui_down") and is_on_floor():
		sprite.play("LookDown")
		camera.offset = Vector2(0,10)
	else:
		camera.offset = Vector2(0,0)

	
	if Input.is_action_just_pressed("Gameover") and is_on_floor() and is_abletomove:
		on_gameover()

	PlayerStats.velocity = velocity
	move_and_slide()
	#endregion

func wait(time:float):
	await get_tree().create_timer(time).timeout

func on_gameover():
		velocity.y = -250
		is_abletomove = false
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
		await wait(1)
		print("Wait for ready")
		await Transitions.play("fade_out")
		await wait(1)
		get_tree().reload_current_scene()


func ground():
	if is_on_floor():
		return true
	else:
		while not is_on_floor(): await wait(0.1)
		return true