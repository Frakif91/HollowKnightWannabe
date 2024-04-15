extends Control

@onready var the_whole : Control = $"The Whole"
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var title_node : Label = $"The Whole/Title"
@onready var descr_node : Label = $"The Whole/Description"


@export var title : String = "None":
	set(value):
		title = value
		title_node.text = value
@export var description : String = "None":
	set(value):
		description = value
		descr_node.text = value
@export var enter_delay : float = 0.0
@export var enter_duration : float = 1.0
@export var post_duration : float = 1.0
@export var end_duration : float = 1.0

var default_font = load("res://Assets/Fonts/")
@export var font : Font = default_font

func _ready():
	if font:
		title_node.font = font
		descr_node.font = font
	else:
		title_node.font = default_font
		descr_node.font = default_font

func _enter_tree():
	await wait(enter_delay)
	animator.play("Show",-1,enter_duration)
	await wait(post_duration)
	animator.play_backwards()


## Coroutine who wait `time` second(s).
func wait(time : float):
	await get_tree().create_timer(time).timeout