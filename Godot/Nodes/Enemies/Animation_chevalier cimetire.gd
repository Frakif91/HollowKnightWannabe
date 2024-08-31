extends Node

@onready var animation_player = $sekelétoneconténeur/AnimationPlayer
func _ready():
	animation_player.play("marche")
