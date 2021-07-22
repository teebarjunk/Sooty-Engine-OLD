tool
extends Node

const MAX_SOUNDS:int = 6

# keep track of song positions, so they can start where they left off.
# otherwise you may listen to the beginning of the song a lot.
var music_positions:Dictionary = {}

var active_music:Array = []
var active_sounds:Array = []
var queued_sounds:Array = []
var tween:SavableTween

var fade_speed:float = 0.5

func _ready():
	tween = SavableTween.new()
	tween.set_name("tween")
	add_child(tween)
	
	var _e = Sooty.connect("collect_save_data", self, "_sooty_save")

func _sooty_save(save, data):
	if save:
		data["audio"] = _save()
	
	elif "audio" in data:
		_load(data["audio"])

func _save():
	var paths = []
	for node in active_music:
		music_positions[node.path] = node.get_playback_position()
		paths.append(node.path)
	
	return {
		music_positions=music_positions,
		paths=paths
	}

func _load(d):
	_stop_all()
	
	music_positions = d.get("music_positions", music_positions)
	if "paths" in d:
		for path in d.paths:
			_add_music_player(path)

func sound(id, kwargs=null):
	var path = Resources.audio_path(id)
	if path:
		if len(queued_sounds) >= MAX_SOUNDS:
			queued_sounds.append([path, kwargs])
		else:
			_play_sound(path, kwargs)
	else:
		print("can't find sound %s" % [id])

func _sound_finished(node):
	active_sounds.erase(node)
	remove_child(node)
	if queued_sounds:
		var p = queued_sounds.pop_front()
		_play_sound(p[0], p[1])

func _play_sound(path:String, kwargs=null):
	var node:SavableAudioStreamPlayer = SavableAudioStreamPlayer.new()
	active_sounds.append(node)
	add_child(node)
	node.set_bus("sound")
	node.set_stream(load(path))
	node.play()
	
	if kwargs:
		if "pitch" in kwargs:
			node.pitch_scale = clamp(kwargs.pitch, 0.01, 2.0)
		
		if "volume" in kwargs:
			node.volume = kwargs.volume
	
	node.connect("finished", self, "_sound_finished", [node], CONNECT_ONESHOT)

func _find_music(id):
	for m in active_music:
		if m.get_meta("id") == id:
			return m
	return null

func _add_music_player(path:String, kwargs=null):
	var stream = load(path)
	if not stream:
		push_error("can't find audio %s" % [path])
		return null
	
	var node = load("res://addons/sooty/prefab/music_player.tscn").instance()
	active_music.append(node)
	add_child(node)
	node.path = path
	node.set_stream(stream)
	
	var offset = node.stream.get_length() * 0.0
	
	if path in music_positions:
		offset = music_positions[path]
	
	node.play(offset)
	return node

func _remove_music_player(node):
	music_positions[node.path] = node.get_playback_position()
	remove_child(node)
	node.queue_free()
	active_music.erase(node)

func _stop_all():
	for i in range(len(active_music)-1, -1, -1):
		_remove_music_player(active_music[i])

func ambient(id:String, kwargs=null):
	var path = Resources.audio_path(id)
	var node = _find_music("ambient")
	
	# is there already a player?
	if node == null:
		node = _add_music_player(path, kwargs)
		node.set_id("ambient")
		node.fade_in()
	
	else:
		node.name = "last_enviro"
		node.fade_out()
		
		var next = _add_music_player(path, kwargs)
		node.set_id("ambient")
		next.fade_in()

func music(id:String, kwargs=null):
	var path = Resources.audio_path(id)
	if not path:
		push_error("no song %s" % [id])
		return
	
	var node = _find_music("playing")
	
	# is there already a player?
	if node == null:
		node = _add_music_player(path, kwargs)
		node.set_id("playing")
		node.fade_in()
	
	else:
		node.name = "last"
		node.fade_out()
		
		var next = _add_music_player(path, kwargs)
		node.set_id("playing")
		next.fade_in()


func clear_effects(buss:String="main"):
	var buss_index = AudioServer.get_bus_index(buss)
	for i in range(AudioServer.get_bus_effect_count(buss_index)-1,-1,-1):
		AudioServer.remove_bus_effect(buss_index, i) 

func effect(type:String="", e:Dictionary={}):
	var n = "AudioEffect" + type.capitalize()
	var effect = _get_effect(n)
	if not effect:
		effect = _add_effect(n)
	Util.set_keys2(effect, e)

func _get_effect(n:String) -> AudioEffect:
	for i in AudioServer.get_bus_effect_count(0):
		var e = AudioServer.get_bus_effect(0, i)
		if e.get_class() == n:
			return e
	return null

func _add_effect(n:String) -> AudioEffect:
	var effect = ClassDB.instance(n)
	AudioServer.add_bus_effect(0, effect)
	return _get_effect(n)



#
