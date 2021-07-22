extends AudioStreamPlayer

onready var tween:Tween = $tween

var volume:float setget set_volume
var path:String

func _ready():
	set_bus("music")
	pause_mode = Node.PAUSE_MODE_PROCESS

func set_id(id):
	set_name(id)
	set_meta("id", id)

func fade_in(time=1.0):
	self.volume = 0.0
	tween.interpolate_property(self, "volume", 0.0, 1.0, time)
	tween.start()
	
func fade_out(time=1.0):
	tween.interpolate_property(self, "volume", volume, 0.0, time)
	tween.start()
	yield(tween, "tween_all_completed")
	get_parent()._remove_music_player(self)

func set_volume(v):
	volume = clamp(v, 0.0, 1.0)
	volume_db = linear2db(volume)
