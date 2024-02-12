@tool
extends GridContainer

@export var max_states : int = 2
@export_category("Health & BP")
@export var max_hp : int = 6:
	set(health):
		max_hp = health

@export var hp : int = 3 :
	set(heal):
		print(heal)
		var value = heal - hp
		if (value > 0):
			print("Mario got healed by " + str(value) + "HP")
			var old_hp = hp
			hp = clamp(heal,0,max_hp)
			process_health()
			return hp  - old_hp
		elif (value < 0):
			print("Mario got damaged by " + str(value) + "HP")
			var old_hp = hp
			hp = clamp(heal,0,max_hp)
			process_health()
			return hp  - old_hp
		else:
			print("Didn't do shit")
	get:
		return clamp(hp,0,max_hp)

var heart_tex = [preload("res://Assets/GFX/hp_hd_0.png"),
				 preload("res://Assets/GFX/hp_hd_1.png"),
				 preload("res://Assets/GFX/hp_hd_2.png"),
				 preload("res://Assets/GFX/hp_hd_3.png"),
				 preload("res://Assets/GFX/hp_hd_4.png")]

var health_container : Array[TextureRect] = []
var act_texrect : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	init_container()

func init_container():
	#clear all children
	health_container = []
	for child in self.get_children():
		self.remove_child(child)
		child.free()

	self.columns = floori(max_hp / float(max_states)) #revien a faire "x/2"
	for health in range(self.columns):
		act_texrect = TextureRect.new()
		act_texrect.texture = heart_tex[4]
		health_container.append(act_texrect)
	for tex in health_container:
		self.add_child(tex)

func process_health():
	var i = 0
	var tex : Texture2D
	for element in health_container:
		tex = heart_tex[clamp(hp - i,0,4)]
		element.texture = tex
		i += max_states

			










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
