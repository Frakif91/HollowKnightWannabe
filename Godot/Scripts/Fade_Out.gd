extends CanvasLayer

@onready var animator : AnimationPlayer = $"AnimationPlayer"
@onready var clrect = $"ColorRect"

var last_animation
signal finished_fadeout
# Called when the node enters the scene tree for the first time.
func _enter_tree():
	pass

func play(animation):
	animator.play(animation)
	await animator.animation_finished
	finished_fadeout.emit()

func change_scene(scene,animation):
	animator.play(animation)
	await animator.animation_finished
	last_animation = animation
	if scene != "reload":
		get_tree().call_deferred("change_scene_to_file",scene)
		finish_animation()
	else:
		get_tree().reload_current_scene()
		finish_animation()
		

func finish_animation():
	print_debug(last_animation)
	play("RESET")
	if last_animation == "fade_out":
		animator.play("fade_in")
		last_animation = "none"
	if last_animation == "fade_left_right_in":
		animator.play("fade_left_right_out")
		last_animation = "none"
	if last_animation == "fade_right_left_in":
		animator.play("fade_right_left_out")
		last_animation = "none"
