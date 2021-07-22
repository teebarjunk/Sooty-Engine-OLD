extends Node

static func count_menu_option(menu:int, option:int):
	var soot:Sooty = Global.get_tree().current_scene
	if not "menu_data" in soot._misc_save:
		soot._misc_save["menu_data"] = {}
	
	var key = [menu, option]
	if not key in soot._misc_save.menu_data:
		soot._misc_save.menu_data[key] = 1
	else:
		soot._misc_save.menu_data[key] += 1

static func get_menu_option_count(menu:int, option:int) -> int:
	var soot:Sooty = Global.get_tree().current_scene
	var key = [menu, option]
	if "menu_data" in soot._misc_save:
		return soot._misc_save.menu_data.get(key, 0)
	return 0

var options = []
var ending:bool = false

var _args = []
var _kwargs = {}

func _ready():
	var _e = Sooty.connect("hide_ui", self, "_hide_ui")

func _hide_ui(h):
	$scroll.visible = not h

func _save(): return { a=_args, k=_kwargs }
func _load(d):
	_args = d.a
	_kwargs = d.k
	_main(d.a, d.k)

func _main(args=null, kwargs=null):
	_args = args
	_kwargs = kwargs
	var _from = args[0]
	var _text = args[1]
	var _list = args[2]
	
#	var soot:Sooty = get_parent()
#	menu_id = hash(soot._last_step)
	
	for item in _list:
#		var option = soot._hash_to_step(h)
		# collect visible options
		if "test" in item and not get_parent().evaluate_is_true(item.test):
			continue
		options.append(item)#{ option_id=h, option=option })
	
	# if none, remove menu
	if not options:
		push_error("No menu options.")
		queue_free()
		return
	
	var prefab = $scroll/buttons/button_prefab
	var buttons = $scroll/buttons
	buttons.remove_child(prefab)
	prefab.set_material(Resources.create_shader_material("blur_screen_lod", {blur=2.0}))
#	print(Resources.shader_path("blur_screen_lod"), prefab.material.shader.resource_path)
	
	for item in options:
#		var option = item.option
		var o = prefab.duplicate()
		o.set_material(prefab.material)
		
		var text = Sooty.format(item.text)
		o.set_text(text)#"%s (%s)" % [text, 0])#get_menu_option_count(menu_id, item.option_id)])
		
#		if "test" in option and not get_parent()._eval_is_true(option.test):
#			o.disabled = true
#			o.text += " <%s>" % [option.test]
		
		o.connect("pressed", self, "_pressed", [o, item])
		buttons.add_child(o)

func _can_save():
	return not ending and not $tween.is_active()

func _pause_sooty():
	return true

func _pressed(s, option):
	if ending:
		return
	
	ending = true
	
	var _e
	var tween:Tween = $tween
	
	_e = tween.stop_all()
	
	# fade out unselected buttons right away
	for button in $scroll/buttons.get_children():
		if button != s:
			_e = tween.interpolate_property(button, "modulate", button.modulate, Color.transparent, 0.5, Tween.TRANS_QUINT)
	
	# fade out selected button after a few moments
	_e = tween.interpolate_property(s, "rect_position", s.rect_position, s.rect_position+Vector2(0, -8), 0.25, Tween.TRANS_BACK, Tween.EASE_IN_OUT, 0.25)
	_e = tween.interpolate_property(s, "modulate", s.modulate, Color.transparent, 0.5, Tween.TRANS_QUINT, Tween.EASE_IN_OUT, 0.5)
	_e = tween.start()
	
	yield(tween, "tween_all_completed")
	
	queue_free()
	
#	count_menu_option(menu_id, option_id)
	
	if "then" in option:
		Sooty._stack_call(option.then)
