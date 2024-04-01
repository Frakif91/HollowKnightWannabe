extends Node


signal on_beat_hit

@export_node_path("AudioStreamPlayer") var audio_node_path : NodePath
@onready var audio_player : AudioStreamPlayer = get_node_or_null(audio_node_path)
@export var audio_stream : AudioStream
@export var default_bpm : float
@onready var tween_out = get_tree().create_tween().bind_node(self)
@export var transition_duration = 1.00
@export var transition_type = 1 # TRANS_SINE

var progress = 0
var curBeat = 0
var beat_count
var time_per_beat = 0


func _ready():
	if audio_player != null:
		audio_stream = audio_player.stream
		fade_in(audio_player)

	if default_bpm != 0:
		var song_lenght = audio_stream.get_length()
		beat_count = audio_stream._get_beat_count()
		default_bpm = audio_stream._get_bpm()
		time_per_beat = song_lenght / beat_count
	
	var beat_per_minute = 65.0
	time_per_beat = 60/beat_per_minute

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if audio_player.playing:
		progress += delta
		if progress >= time_per_beat * curBeat:
			curBeat += 1
			on_beat_hit.emit()

func fade_out(stream_player):
	# tween music volume down to 0
	tween_out.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	# when the tween ends, the music will be stopped

func fade_in(stream_player):
	# tween music volume down to 0
	var og_volume = stream_player.volume_db
	stream_player.volume_db = -80
	tween_out.set_trans(transition_type)
	tween_out.set_ease(Tween.EASE_IN)
	tween_out.tween_property(stream_player, "volume_db" ,og_volume, transition_duration)
	#tween_out.interpolate_property(stream_player, "volume_db", -80, og_volume, transition_duration, transition_type, Tween.EASE_IN, 0)
	#tween_out.start()
	# when the tween ends, the music will be stopped

func _on_TweenOut_tween_completed(object, _key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
	object.volume_db = 0 # reset volume