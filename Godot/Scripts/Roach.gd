extends StaticBody2D

var is_dead = false
var speed = 100
var runing_speed = 200
var health : int = 3
var invulnerability_timer = 1.5
var is_invulnerable = false
enum states {IDLE, MOVING, CHASING, SCARED, DEAD}
enum behaviors {ROACH}
@onready var sound : AudioStreamPlayer = $"Sound"
@onready var defeat_sound = load("res://Assets/SFX/FFVII Victory Fanfare.mp3")
@onready var hurt_sound = load("res://Assets/SFX/LC_SFX/592. Shovel Hit Default.mp3")


@onready var damage_trigger = $"Damage_Trigger"
@onready var sprite = $"ASprite"

func _ready():
	damage_trigger.body_entered.connect(_body_entered)

func _process(delta):
	pass

func _body_entered(body):
	print("Body in Collition",body)
	if body is MainCharacter:
		is_dead = await get_hurt()
		if is_dead:
			sound.stream = defeat_sound
			sound.play()
			await sound.finished
			queue_free()


func get_hurt():
	if not is_invulnerable:
		health -= 1
		sound.stream = hurt_sound
		sound.play()
		if health < 0:
			return true
		is_invulnerable = true
		await get_tree().create_timer(invulnerability_timer).timeout
		is_invulnerable = false
		return false
