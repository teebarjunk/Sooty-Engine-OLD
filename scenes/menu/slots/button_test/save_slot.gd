extends Control

var slot:String = "A"
var index:int = 0
var hovered:bool = false

var image:TextureRect

func _ready():
	focus_mode = Control.FOCUS_ALL
	image = $image
	
	var _e
	_e = connect("mouse_entered", self, "_mouse", [true])
	_e = connect("mouse_exited", self, "_mouse", [false])
	_e = connect("focus_entered", self, "_focus", [true])
	_e = connect("focus_exited", self, "_focus", [false])
	
#	for item in [$name, $icon/time, $icon/percentage]:
#		item.modulate = Color.darkgray

func _set_info(id, preview, info):
	var name = $back/items/label/name
	var percent = $back/items/percent
	var goals = $back/items/goals
	var chapter = $back/items/chapter
	var save_time = $back/items/label/save_time
	var play_time = $back/items/play_time
	
	slot = id
	name.text = id
	
	var prog = info.get("progress", {})
	var tick = prog.get("tick", 0)
	var toll = prog.get("toll", 0)
	
	if toll == 0:
		percent.text = ""
		goals.text = ""
	else:
		percent.text = str(100.0 * Util.div(prog.get("max_tick", 0), prog.get("max_toll", 0))) + "%"
		goals.text = "Goals: %s/%s" % [tick, toll]
	
	if "chapter" in info:
		chapter.text = info.chapter
	else:
		chapter.text = ""
	
	save_time.text = DateTime.new(info.get("save_time")).format("{date} {time} {years}")
	play_time.text = "Play Time: %s" % DateTime.new(info.get("play_time")).format("{time_military}")
	
	if preview:
		image.texture = preview
	else:
		image.texture = load("res://addons/sooty/white_pixel.png")

func _mouse(entered):
	hovered = entered
	image.hovered = entered

func _focus(entered):
	image.selected = entered
	
	if entered:
		owner._select(slot, index)
	else:
		owner._select(null, null)
	
	$tween.stop_all()
	$tween.interpolate_property($back/items, "modulate", $back/items.modulate, Color.greenyellow if entered else Color.darkgray, .25)
	$tween.start()
