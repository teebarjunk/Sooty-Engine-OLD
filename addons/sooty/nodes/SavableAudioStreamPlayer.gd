extends AudioStreamPlayer
class_name SavableAudioStreamPlayer

var path:String
var volume:float setget set_volume, get_volume

func set_volume(v):
	volume = clamp(v, 0.0, 1.0)
	volume_db = linear2db(volume)

func get_volume() -> float:
	return db2linear(volume_db)

func _save():
	return {playing=playing, time=get_playback_position()}

func _load(d:Dictionary):
	if d.playing:
		play(d.time)
	else:
		seek(d.time)
