extends Control

@export var text_to_type : Array[String] = ["You trippin' balls bruh...",
	"Man, i think you need healing cuz you're hallucinating.",
	"Come back with money next time.","..."]
var wait_time = 0.02
var is_typing = false
var have_to_stop

@onready var image = $"ShopUi"
@onready var shop_audio = $"AudioStreamPlayer"
@onready var candle_light = $"PointLight2D"
@onready var menu_title = $"Control/Name"
@onready var menu_text = $"Control/Text"

var line_of_text : int = 0

func _ready():
	typing(text_to_type[0])

func _input(event):
	if event.is_action_pressed("Interact") and not is_typing:
		line_of_text += 1
		if line_of_text > len(text_to_type) - 1:
			line_of_text = 0 
		await typing(text_to_type[line_of_text])
	elif event.is_action_pressed("Interact") and is_typing:
		have_to_stop = true
		await wait(wait_time + 0.01)
		menu_text.text = text_to_type[line_of_text]
		is_typing = false
		have_to_stop = false
		

func typing(sentence : String):
	is_typing = true
	var words = []
	for letter in range(len(sentence)):
		words.append(sentence[letter])

	var final_string = ""
	for word in words:
		final_string = final_string + word 
		menu_text.text = final_string
		if word != " ":
			await wait(wait_time)
		if have_to_stop:
			return
	is_typing = false

func wait(time):
	await get_tree().create_timer(time).timeout