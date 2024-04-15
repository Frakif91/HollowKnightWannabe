@tool
extends Node
var og_node : Node


@export_category("In Game")

@export var ig_node_modulate : Color = Color(0,0,0,1): #IN GAME
	set(value):
		ig_node_modulate = value
		apply_ig_changes()
@export var ig_node_light : float = 1.0:    #IN GAME
	set(value):
		ig_node_light = value
		apply_ig_changes()
@export var ie_node_modulate : Color = Color(0,0,0,1): #IN EDITOR
	set(value):
		ie_node_modulate = value
		apply_editor_changes()
@export var ie_node_light : float = 1.0 : #IN EDITOR
	set(value):
		ie_node_light = value
		apply_editor_changes()

#func _process(_delta):
#	apply_editor_changes()
#	apply_ig_changes()

func apply_editor_changes():
	#Est-ce que le script est executé dans l'éditeur ?
	if Engine.is_editor_hint():
		if is_instance_of(self,CanvasModulate):
				print_debug("CanvasModulate, in Editor")
				self.color = ie_node_modulate
		if is_instance_of(self,Light2D):
				print_debug("Light2D, in Editor")
				self.energy = ie_node_light

func apply_ig_changes():
	if not Engine.is_editor_hint():
			if is_instance_of(self,CanvasModulate):
				print_debug("CanvasModulate, in Game")
				self.color = ig_node_modulate
		if is_instance_of(self,Light2D):
				print_debug("Light2D, in Game")
				self.energy = ig_node_light