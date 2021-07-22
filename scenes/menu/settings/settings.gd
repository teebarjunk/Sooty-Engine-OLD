extends Node

onready var _volume:HSlider = $control/options/volume/field
onready var _music_volume:HSlider = $control/options/music_volume/field
onready var _ambience_volume:HSlider = $control/options/ambience_volume/field
onready var _sound_volume:HSlider = $control/options/sound_volume/field

func _ready():
	var _e
#	_e = $control/options/back.connect("pressed", self, "_pressed", ["back"])
	
	for k in ["volume", "music_volume", "ambience_volume", "sound_volume"]:
		var node = self.get("_" + k)
		node.value = Settings.get(k)
		_e = node.connect("value_changed", self, "_modified", [k])

func _modified(value, key):
	Settings.set(key, value)

func _pressed(id):
	match id:
		"back":
			Settings._save_state()
