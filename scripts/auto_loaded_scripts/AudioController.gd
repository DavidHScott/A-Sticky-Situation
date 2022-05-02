extends Node

var _music_player:AudioStreamPlayer
var _effects_player:AudioStreamPlayer


var clip_queue = []
var clip_playing = false

var music_files = {
	"placeholder_music_1": preload("res://assets/audio/music/placeholder_PixelLounge.wav"),
}

var effects_files = {
	"menu_blip": preload("res://assets/audio/sfx/menu_nav.wav"),
	"button_click": preload("res://assets/audio/sfx/button_click.wav"),
}

func _ready():
	_music_player = AudioStreamPlayer.new()
	add_child(_music_player)
	_music_player.bus = "Music"
	
	_effects_player = AudioStreamPlayer.new()
	add_child(_effects_player)
	_effects_player.bus = "Effects"
	
	change_master_volume(SaveAndLoad.options.master_volume)
	change_music_volume(SaveAndLoad.options.music_volume)
	change_effects_volume(SaveAndLoad.options.sfx_volume)


func play_music(track_url:String):
	
	if music_files.get(track_url) == null:
		print("Error: audio track " + track_url + " cannot be found.")
		return
	
	stop_music()
	
	_music_player.stream = music_files.get(track_url)
	_music_player.play()


func stop_music():
	_music_player.stop()


# Play a single clip. Cancels clip currently playing
func play_clip(track_url:String):
	_effects_player.stop()
	
	_effects_player.stream = effects_files.get(track_url)
	_effects_player.play()


# Adds an audio clip to a queue. Does not cancel clip currently playing
func queue_clip(track_url:String):
	pass


func play_clips():
	clip_playing = true
	
	while clip_queue.size() > 0:
		
		_effects_player.stream = clip_queue[0]
		_effects_player.play()
		
		yield(_effects_player, "finished")
		
		clip_queue.pop_front()
	
	clip_playing = false


func change_master_volume(value):
	if value == 0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, (45 * value) - 45)


func change_music_volume(value):
	var bus_id = AudioServer.get_bus_index("Music")
	
	if value == 0:
		AudioServer.set_bus_mute(bus_id, true)
	else:
		AudioServer.set_bus_mute(bus_id, false)
		AudioServer.set_bus_volume_db(bus_id, (45 * value) - 45)


func change_effects_volume(value):
	var bus_id = AudioServer.get_bus_index("Effects")
	
	if value == 0:
		AudioServer.set_bus_mute(bus_id, true)
	else:
		AudioServer.set_bus_mute(bus_id, false)
		AudioServer.set_bus_volume_db(bus_id, (45 * value) - 45)
