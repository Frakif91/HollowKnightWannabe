extends Control

var text_to_type : String = "You trippin' balls bruh..."
var wait_time = 0.05

@onready var image = $"ShopUi"
@onready var shop_audio = $"AudioStreamPlayer"
@onready var candle_light = $"PointLight2D"
@onready var menu_title = $"Control/Text"
@onready var menu_text = $"Control/Name"

func _ready():
	typing(text_to_type)

func typing(sentence):
	var words = []
	for letter in range(len(sentence)):
		words.append(String.chr(letter))
		var final_string = ""
		for word in words:
			final_string.append(word) 
		menu_text.text = final_string
		await get_tree().create_timer(wait_time).timeout
