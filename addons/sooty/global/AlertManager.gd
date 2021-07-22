extends Node

signal alert(info)

var _queue:Array = []
var _simple_queue:Array = []
var _node:Node
var _simple_node:Node

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func alert(info):
	_queue.append(info)
	set_process(true)
	emit_signal("alert", info)

func simple_alert(info):
	prints(info, _simple_queue)
	_simple_queue.append(info)
	set_process(true)
#	emit_signal()

func _process(_delta):
	if _simple_queue and not UtilGodot.is_good(_simple_node):
		var info = _simple_queue.pop_front()
		print("create ", info)
		_simple_node = Resources.create_scene("simple_alert", get_tree().current_scene, { "_show_message": [info] })
	
	if not _queue:
		pass
#		set_process(false)
	
	elif not UtilGodot.is_good(_node) and not get_tree().paused:
		var info = _queue.pop_front()
		_node = Resources.create_scene("bell", get_tree().current_scene, { "_show_message": [info] })

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_L:
		alert({
			type="Test Achievement",
			name="Speak to {godette}.",
			desc="You spoke to {godette}."
		})
		get_tree().set_input_as_handled()
