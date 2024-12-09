extends Node


@onready var menu_music_player = $MenuMusicPlayer
@onready var intro_game_music_player = $IntroGameMusicPlayer
@onready var game_music_player = $GameMusicPlayer


func play_menu_music() -> void:
	if menu_music_player.playing:
		return
	game_music_player.stop()
	menu_music_player.play()

func play_game_music() -> void:
	menu_music_player.stop()
	Debug.log("paramos")
	$Timer.start()

func _on_timer_timeout():
	Debug.log("y parte")
	intro_game_music_player.play()

func _on_intro_game_music_player_finished():
	Debug.log("y sigue")
	game_music_player.play()
