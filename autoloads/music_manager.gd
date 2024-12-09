extends Node


@onready var music_player: AudioStreamPlayer = $MusicPlayer

func play(stream: AudioStream) -> void:
	if music_player.stream == stream:
		return
	music_player.stream = stream
	music_player.play()
