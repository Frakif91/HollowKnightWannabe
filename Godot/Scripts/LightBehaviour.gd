@tool
extends PointLight2D

var light : PointLight2D = self
@export_category("Light behaviour")
@export var min_light = 0.5
@export var max_light = 3.0
@export var step_light = 100.0
@export var power_light = 5.0
@onready var rng_light = FastNoiseLite.new()
var rng_default = randf()*100.0
var value = rng_default
var is_clamp = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value += delta * step_light
	if is_clamp:
		light.energy = clamp((1 + rng_light.get_noise_1d(value))*(max_light-min_light),min_light,max_light)
	else:
		light.energy = (1 + rng_light.get_noise_1d(value))*(max_light-min_light)
	#print("Light Energy : ",light.energy)
