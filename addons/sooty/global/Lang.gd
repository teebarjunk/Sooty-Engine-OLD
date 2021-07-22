tool
extends Node

signal language_changed()

var lang:String = "en" setget set_lang, get_lang
var words:Dictionary = {}

func _ready():
	var _e
	_e = Sooty.connect("collect_persistent", self, "_save_persistent")
	load_words()

func _save_persistent(save, data):
	if save:
		data["lang"] = lang
	
	elif "lang" in data:
		lang = data["lang"]
		load_words()

func get_lang() -> String: return lang
func set_lang(v:String):
	v = v.to_lower()
	if v != lang:
		lang = v
		emit_signal("language_changed")
		load_words()
		Sooty.save_persistent()

func load_words():
	var path = "res://addons/sooty/lang_common/json/ALL_WORDS.%s.json" % [lang]
	if lang == "??":
		lang = "fr"
	var data = UtilFile.load_dict(path)
	var t = Translation.new()
	t.locale = lang
	for k in data:
		t.add_message(k, data[k])
	TranslationServer.add_translation(t)
	TranslationServer.set_locale(lang)
