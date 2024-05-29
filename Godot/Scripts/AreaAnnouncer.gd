extends Control

@onready var the_whole : Control = $"The Whole"
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var title_node : Label = $"The Whole/Title"
@onready var descr_node : Label = $"The Whole/Description"

#@onready var scene_properties : SceneProperties = $".." 

@export var title : String = "None"
@export var description : String = "None"
@export var enter_delay : float = 0.7
@export var enter_duration : float = 1.0
@export var post_duration : float = 3.0
@export var end_duration : float = 1.0

var default_font = load("res://Assets/Fonts/NITEMARE.TTF")
@export var font : Font = default_font

func _ready():
	title_node.set_message_translation(true)
	visible = false
	if get_tree().current_scene == self:
		show_title(title,description,post_duration)
	if font:
		title_node.label_settings.font = font
		descr_node.label_settings.font = font
	else:
		title_node.label_settings.font = default_font
		descr_node.label_settings.font = default_font

func show_title(sp_title,sp_description,duration):
	await wait(enter_delay)
	title_node.text = tr(sp_title)
	descr_node.text = tr(sp_description)
	animator.play("Show",0,1/enter_duration)
	await wait(0.1) #problems
	visible = true
	await animator.animation_finished
	await wait(duration)
	animator.play_backwards()
	await animator.animation_finished
	visible = false


## Coroutine who wait `time` second(s).
func wait(time : float):
	await get_tree().create_timer(time).timeout
