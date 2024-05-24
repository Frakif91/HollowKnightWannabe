extends CanvasLayer

@onready var animator : AnimationPlayer = $"AnimationPlayer"
@onready var clrect = $"ColorRect"

var last_animation
signal finished_fadeout
# Called when the node enters the scene tree for the first time.
func _enter_tree():
	pass

func play(animation : String):
	animator.play(animation)
	await animator.animation_finished
	finished_fadeout.emit()

func change_scene(scene,animation):
	animator.play(animation)
	await animator.animation_finished
	last_animation = animation
	if scene is String:
		if scene != "reload":
			get_tree().call_deferred("change_scene_to_file",scene)
			finish_animation(last_animation)
		else:
			get_tree().reload_current_scene()
			finish_animation(last_animation)
	elif scene is PackedScene:
			get_tree().call_deferred("change_scene_to_file",scene)
			get_tree().change_scene_to_packed(scene)
			finish_animation(last_animation)

func finish_animation(last_anim):
	play("RESET")
	print_debug("Finishing FO Animation : ",last_animation)
	if last_anim == "fade_out":
		animator.play("fade_in")
		last_animation = "none"
	elif last_anim == "fade_left_right_in":
		animator.play("fade_left_right_out")
		last_animation = "none"
	elif last_anim == "fade_right_left_in":
		animator.play("fade_right_left_out")
		last_animation = "none"
