extends AudioStreamPlayer2D

const level_music = preload("res://Scenes/game-music-loop-2-144037.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()

func _play_music_level():
	_play_music(level_music)
