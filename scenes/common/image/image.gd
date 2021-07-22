extends Sprite
class_name SootyImage

const DEFAULT_SIDE:String = "center"

var node_type:String = "" # in case the same image is being shown twice with a different id

var tween:SavableTween
var evals = []
var _shake_power:float
var _run = true
var _at = DEFAULT_SIDE
var _view_buffer = Vector2(8, 0)
var _image = ""
var _image_blend = "fade"
var _image_blend_speed = 0.5
var _sway = 1.0
var _last_position:Vector2 = Vector2.ZERO
var _talk_noise = 0.0

func _ready():
	tween = $tween
	var _e
#	_e = tween.connect()
	_e = Sooty.connect("text_started", self, "_text_started")
	_e = Sooty.connect("text_finished", self, "_text_finished")
#	_e = tween.connect("tween_all_completed", self, "_tween_complete")

func _save():
	var out = {}
	for key in ["position", "scale", "_at", "_image", "_image_blend", "_last_position"]:
		out[key] = self[key]
	return out

func _load(data:Dictionary):
	set_texture(load(data._image))
	for key in data:
		self[key] = data[key]
#	Saver.load_node(self, data)

func _created():
	if not _image:
		set_image(name)
	at()
	fade()
	wait()

func _args_to_image_path(args):
	var a = [name]
	if args:
		a.append_array(args)
#	prints(name, node_type, args, a)
	return PoolStringArray(a).join(" ")

func _main(args=null, kwargs=null):
	if args:
		set_image(_args_to_image_path(args))
	
	if kwargs:
		for k in kwargs:
			match k:
				"scale": scale(kwargs[k])

func _text_started(from, _text, kwargs):
	if from == name:
		if kwargs and "tags" in kwargs:
			set_image(_args_to_image_path(kwargs.tags))
		_talk_noise = 1.0

func _text_finished(from):
	if from == name:
		_talk_noise = 0.0

func _pause_sooty():
	return _wait or evals or tween.is_active() or tween.not_finished()

func set_image(id:String):
	_image = Resources.image_path(id)
	
	if not _image:
		push_error("can't find image %s" % [id])
		return
	
	if _image_blend and texture:
		_fade_image()
	else:
		set_texture(load(_image))

func _fade_image():
	var image:Texture = load(_image)
	
	var mat = Resources.create_shader_material("image blend %s" % [_image_blend], {texture2=image})
	if mat:
		set_material(mat)
		var old_scale = scale
		var old_pos = get_view_xy(_get_screen_t(_at), texture.get_size())
		var new_pos = get_view_xy(_get_screen_t(_at), image.get_size())
		var new_scale = Vector2.ONE + ((image.get_size() - texture.get_size()) / image.get_size())
		$tween.interpolate_property(self, "material:shader_param/blend", 0.0, 1.0, _image_blend_speed, Tween.TRANS_QUAD)
		$tween.interpolate_property(self, "position", old_pos, new_pos, _image_blend_speed)
		$tween.interpolate_property(self, "scale", scale, new_scale * old_scale, _image_blend_speed)
		$tween.start()
		yield($tween, "tween_all_completed")
		set_scale(old_scale)
		set_offset(Vector2.ZERO)
		set_texture(image)
		set_material(null)
		at()

	else:
		print("can't find image blend %s" % [_image_blend])
		set_texture(image)

func _eval(eval):
	UtilStr.evaluate(eval, self)
#	if eval is String:
#		evals.append(eval)
#	else:
#		evals.append_array(eval)
#	_try_eval()

#func then():
#	_run = false

var _wait = false
func wait():
	if _wait == false:
		_wait = true
		var _e = tween.connect("tween_all_completed", self, "_done_waiting", [], CONNECT_ONESHOT)

func _done_waiting():
	_wait = false

func _process(_delta):
	_try_eval()
	
	var d = (_last_position - position) * .25
	rotation_degrees = lerp(rotation_degrees, d.x * _sway, .5) + Rand.fbm_timed(-position.x, 4.0) * 2.0 * _talk_noise
	_last_position = position
	
	offset.y = -Rand.noise_timed(position.x, 5.0) * 48.0 * _talk_noise

func _try_eval():
	if not tween.is_active():
		if tween.get_runtime() > 0:
			var _e = tween.start()
		
		elif evals:
			_run = true
#			print("---")
			while evals and _run:
				var e = evals.pop_front()
#				print(e)
				UtilStr.evaluate_string(e, self)
#				get_parent().eval(e, self)
#			print("---")

func scale(s=1.0):
	set_scale(Vector2(s, s))

func tint(color="white", time=1.0):
	if color is String:
		color = ColorN(color, 1.0)
	tween.interpolate(self, "modulate", modulate, color, time)

func blur(_amount:float=0.0, _time=0.5):
	print("blur not implemented for images atm.")

# set position
func at(side=_at, x=0, y=0):
	position = get_screen_position(side, Vector2(x, y))
	_at = side
	_last_position = position

func move(side=_at, duration=1, x=0.0, y=0.0):
	_at = side
	var dest = get_screen_position(side, Vector2(x, y))
	tween.interpolate(self, "position", position, dest, duration)

func spring(side=_at, duration=1, x=0, y=0):
	_at = side
	var dest = get_screen_position(side, Vector2(x, y))
	tween.interpolate(self, "position", position, dest, duration, Tween.TRANS_BACK, Tween.EASE_IN_OUT)

func fade(inout="in", duration=1.0):
	match inout:
		"in":
			modulate = Color.transparent
			tween.interpolate(self, "modulate", Color.transparent, Color.white, duration)
		"out":
			tween.interpolate(self, "modulate", modulate, Color.transparent, duration)

var _pause:float = 0
func pause(duration=1.0):
	tween.interpolate(self, "_pause", duration, 0.0, duration)

func shake(duration=1.0, power=1.0):
	_shake_power = power * 30.0
	tween.interpolate_func(self, "_shake", 0.0, 1.0, duration*.5, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.interpolate_func(self, "_shake", 1.0, 0.0, duration*.5, Tween.TRANS_BACK, Tween.EASE_OUT, duration*.5)

func _shake(t):
	offset = Rand.v2_timed_noise(position, 10.0) * t * _shake_power

func remove():
	queue_free()

func _unhandled_key_input(event):
	if event.pressed and name != "bg":
		match event.scancode:
			KEY_UP: at("top")
			KEY_DOWN: at("bottom")
			KEY_LEFT: at("left")
			KEY_RIGHT: at("right")
			KEY_SHIFT: at("middle")
#		print(position, get_viewport().size, get_viewport_rect())
		update()

func get_view_xy(t:Vector2, r=null) -> Vector2:
	var p = get_viewport().size - _view_buffer * 2.0
	if not r:
		r = get_rect().size
	r = r * scale * .5
	return Vector2(
		lerp(r.x, p.x-r.x, t.x),
		lerp(r.y, p.y-r.y, t.y)) + _view_buffer

func _get_screen_t(at:String) -> Vector2:
	match at:
		"left": return Vector2(0, 1)
		"midleft": return Vector2(.25, .5)
		"right": return Vector2(1, 1)
		"midright": return Vector2(.75, .5)
		"center": return Vector2(.5, 1)
		"centerleft": return Vector2(.25, 1)
		"centerright": return Vector2(.75, 1)
		"middle": return Vector2(.5, .5)
		"top": return Vector2(.5, 0)
		"topleft": return Vector2(0, 0)
		"topright": return Vector2(1, 0)
		_: return Vector2(.5, 1)

func get_screen_position(at:String, o:Vector2) -> Vector2:
	var p = _get_screen_t(at)
	return get_view_xy(p + o)
