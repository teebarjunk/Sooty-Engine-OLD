extends Node

const PATH_SETTINGS:String = "user://settings.json"

# audio
export var mute = false setget set_mute
export var mute_music = false
export var mute_sound = false

export var volume = 1.0 setget set_volume
export var music_volume = 1.0 setget set_music_volume
export var ambience_volume = 1.0 setget set_ambience_volume
export var sound_volume = 1.0 setget set_sound_volume

# screen
export var full_screen = false setget set_full_screen

func _save_state():
	var state = {}
	for prop in UtilGodot.get_script_properties(self):
		state[prop] = self[prop]
	UtilFile.save_dict(PATH_SETTINGS, state)

func _load_state():
	var state = UtilFile.load_dict(PATH_SETTINGS)
	for prop in state:
		self[prop] = state[prop]

func _enter_tree(): _load_state()

func _unhandled_key_input(event):
	if not event.pressed:
		return
	
	match event.scancode:
		KEY_M:
			self.mute = not self.mute
			get_tree().set_input_as_handled()
		
		KEY_BRACKETRIGHT:
			self.volume += .1
			get_tree().set_input_as_handled()
		
		KEY_BRACKETLEFT:
			self.volume -= .1
			get_tree().set_input_as_handled()

func set_mute(b):
	mute = b
	AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), mute)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("sound"), mute)

func set_volume(f):
	volume = clamp(f, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(volume * music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sound"), linear2db(volume * sound_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("ambience"), linear2db(volume * ambience_volume))

func set_music_volume(f):
	music_volume = clamp(f, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(volume * music_volume))

func set_ambience_volume(f):
	ambience_volume = clamp(f, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("ambience"), linear2db(volume * ambience_volume))

func set_sound_volume(f):
	sound_volume = clamp(f, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sound"), linear2db(volume * sound_volume))

func set_full_screen(b):
	full_screen = b
	OS.window_fullscreen = full_screen
	
	
	
	

#
