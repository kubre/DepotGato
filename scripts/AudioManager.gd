extends Node

const AUDIO_EFFECTS := {
	BALLOON_POP = preload("res://audio/pop.wav"),
}

var audio_player_pool: Array[AudioStreamPlayer] = []


func _ready() -> void:
	_init_pool()


func _init_pool() -> void:
	var audio_player_group := Node.new()
	for i in range(5):
		var audio_stream_player = AudioStreamPlayer.new()
		audio_stream_player.stream = AUDIO_EFFECTS["BALLOON_POP"]
		audio_player_pool.append(audio_stream_player)
		audio_player_group.add_child(audio_stream_player)
	add_child(audio_player_group)


func play_sound(audio: AudioStream) -> void:
	var audio_stream_player = audio_player_pool.pop_back()
	audio_stream_player.stream = audio
	audio_stream_player.play()
	audio_player_pool.insert(0, audio_stream_player)
