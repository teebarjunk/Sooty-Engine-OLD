extends Node

export var icon:String = ""
export var head:String = "popup"
export var text:String = "Are you sure?"
var on_accept:FuncRef
var on_cancel:FuncRef

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
	$backing.material = Resources.create_shader_material("blur_screen_lod")
	
	var _e
	_e = $backing/elements/buttons/accept.connect("pressed", self, "_pressed", ["accept"])
	_e = $backing/elements/buttons/cancel.connect("pressed", self, "_pressed", ["cancel"])
	
	Resources.set_fonts($backing/elements/head, "open_sans_16")
	Resources.set_fonts($backing/elements/text, "open_sans_16")
	$backing/elements/head.text = head
	$backing/elements/text.text = text
	
	if not icon:
		$backing/elements/CenterContainer/icon.visible = false
	else:
		$backing/elements/CenterContainer/icon.texture = Resources.load_texture(icon)

func _pause_sooty():
	return true

func _exit_tree():
	get_tree().paused = false

func _pressed(id):
	match id:
		"cancel":
			if on_cancel:
				on_cancel.call_func()
		"accept":
			if on_accept:
				on_accept.call_func()
	
	queue_free()
