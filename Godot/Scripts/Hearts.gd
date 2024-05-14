@tool
extends GridContainer

## `Scene Property` used to get more info about the current level
@export_node_path("Node") var scene_properties : NodePath
@onready var scene_prop : SceneProperties = get_node_or_null(scene_properties)

@export var last_container_beat : bool = true
@export var test_hp : int = 6
@export var test_maxhp : int = 6 

@export var max_states : int = 2
@export var time_between_zooms : float = 1.5  

@onready var max_hp = PlayerStats.max_hp
@onready var hp = PlayerStats.hp

var heart_tex = [preload("res://Assets/GFX/hp_hd_0.png"),
				 preload("res://Assets/GFX/hp_hd_1.png"),
				 preload("res://Assets/GFX/hp_hd_2.png"),
				 preload("res://Assets/GFX/hp_hd_3.png"),
				 preload("res://Assets/GFX/hp_hd_4.png")]

var health_container : Array[TextureRect] = []
var act_texrect : TextureRect
var og_scale = scale
var last_container : TextureRect
# Called when the node enters the scene tree for the first time.
func _ready():
	if last_container_beat and not Engine.is_editor_hint():
		var timer_btw_beats = Timer.new()

	if not Engine.is_editor_hint():
		max_hp = PlayerStats.max_hp
		hp = PlayerStats.hp
	else:
		max_hp = 12
		hp = 12
	init_container(max_hp,hp)
	last_container = health_container[len(health_container) - 1]
	if scene_prop:
		#scene_prop
		pass

func _process(delta):
	if not Engine.is_editor_hint():
		max_hp = PlayerStats.max_hp
		hp = PlayerStats.hp
	process_health(max_hp,hp,delta,2)


func init_container(maxhp : int, curhp : int):
	#clear all children
	health_container = []
	for child in self.get_children():
		child.queue_free()
		self.remove_child(child)

	self.columns = floori(maxhp / float(max_states)) #revien a faire "x/2"
	for health in range(self.columns):
		act_texrect = TextureRect.new()
		act_texrect.texture = heart_tex[4]
		health_container.append(act_texrect)
	for tex in health_container:
		self.add_child(tex)

func process_health(maxhp,curhp,delta,unzoom_speed):
	if !Engine.is_editor_hint() and self.scale != og_scale:
		self.scale = lerp(self.scale, og_scale, delta/unzoom_speed)

	var i = 0
	var tex : Texture2D
	if Engine.is_editor_hint():
		for element in health_container:
			tex = heart_tex[clamp(test_hp - i,0,max_states)]
			element.texture = tex
			i += max_states
	else:
		for element in health_container:
			tex = heart_tex[clamp(curhp - i,0,max_states)]
			element.texture = tex
			i += max_states
			
func zoom_in():
	last_container.scale = Vector2(0.6,0.6)

		#i += max_states
		#if hp > i - 1:
		#	tex = fullhealth
		#	print_debug("full health ",i - 1," ",hp)
		#if hp == i - 1:
		#	tex = semihealth
		#	print_debug("semi health ",i - 1," ",hp)
		#if hp < i - 1:
		#	tex = mptyhealth
		#	print_debug("empty health ",i - 1," ",hp)
		#element.texture = tex
