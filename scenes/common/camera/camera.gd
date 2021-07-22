extends Camera2D

var _eval
var _do_tween = false

export(float, 0.0, 10.0) var noise_scale:float = 0
export(float) var noise_time:float = 1.0

func _ready():
	$tween.set_parent(self)

func _created():
	position = get_viewport().size * .5

func _save():
	return { tween = $tween._save() }

func _load(d:Dictionary):
	$tween.set_parent(self, d.tween)

func _process(_delta):
	if _eval and not $tween.is_active():
#		print("--")
		for e in _eval.pop_front().split(" && "):
#			print("E ", e)
			get_parent().evaluate(e, self)
#		print("--")
		
	if _do_tween:
		_do_tween = false
		var _e = $tween.start()
	
	# screen noise
	if noise_scale > 0.0:
		var r = Rand.noise_timed()
		minn = min(minn, r)
		maxx = max(maxx, r)
#		prints(r, minn, maxx)
		offset = lerp(offset, Rand.v2_timed_fbm(position, noise_time) * noise_scale, .125)
		rotation = lerp_angle(rotation, Rand.noise_timed(.11, 0.5) * noise_scale * 0.01, .125)
		zoom.x = lerp(zoom.x, 0.5 + (Rand.noise_timed(.312, 0.5) * noise_scale * .01), .125)
		zoom.y = zoom.x
		
	elif offset:
		offset *= .5

var minn = 0
var maxx = 0

func message(s):
	if "eval" in s:
		_eval = s.eval.duplicate()

func center():
	pass

func noise(scale=1.0):
	noise_scale = scale

func zoom(scale=1, target=null, x=0, y=0):
	var z = Vector2.ONE * (1.0 / float(scale))
	$tween.interpolate(self, "zoom", zoom, z, 1.0)
	if target:
		target = get_parent().get_node_or_null(target)
		if target:
			$tween.interpolate(self, "position", position, target.position + Vector2(x, y), 1.0)
	else:
		$tween.interpolate(self, "position", position, get_viewport().size * .5, 1.0)
	_do_tween = true

func pan(a="left", b="right", duration=1.0):
	a = get_screen_position(a)
	b = get_screen_position(b)
	$tween.interpolate(self, "position", a, b, duration)
	_do_tween = true

func pan_to(a="right", duration=1.0):
	a = get_screen_position(a)
	$tween.interpolate(self, "position", position, a, duration)
	_do_tween = true

func tilt(degrees=0):
	$tween.interpolate(self, "rotation_degrees", rotation_degrees, degrees, 1.0)
	_do_tween = true

func tilt_spring(degrees=0, time=1.0):
	$tween.interpolate(self, "rotation_degrees", rotation_degrees, degrees, time, Tween.TRANS_BACK)
	_do_tween = true

var _shake_power
var _shake_position
func shake(power=1.0, duration=1.0):
	var _e
	_shake_power = power * 30.0
	_e = $tween.interpolate_method(self, "_shake", 0.0, 1.0, duration*.5)
	_e = $tween.interpolate_method(self, "_shake", 1.0, 0.0, duration*.5)
	_do_tween = true
	_shake_position = position

func _shake(t):
	position = _shake_position + Rand.v2_timed_noise(_shake_position, 10.0) * t * _shake_power

func _pause_sooty():
	return $tween.is_active()

func get_screen_position(at:String):
	var p = get_viewport().size * .5
	var r = get_viewport().size * zoom * .5 # get_rect().size * .5
	match at:
		"left": p.x = p.x - p.x + r.x
		"right": p.x = p.x + p.x - r.x
		"top": p.y = p.y - p.y + r.y
		"bottom": p.y = p.y + p.y - r.y
		"topleft":
			p.y = p.y - p.y + r.y
			p.x = p.x - p.x + r.x
		"topright":
			p.y = p.y - p.y + r.y
			p.x = p.x + p.x - r.x
		"bottomleft":
			p.y = p.y + p.y - r.y
			p.x = p.x - p.x + r.x
		"bottomright":
			p.y = p.y + p.y - r.y
			p.x = p.x + p.x - r.x
	return p
