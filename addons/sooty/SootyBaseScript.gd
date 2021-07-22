extends Node
class_name SootyBaseScript

var _t:float = 0.0
var time:DateTime = DateTime.new()
var play_time:DateTime = DateTime.new()

func _process(delta):
	_t += delta
	if _t >= 1.0:
		play_time.seconds += 1
		_t -= 1.0

func ordinal(s): return UtilStr.ordinal(s)
func commas(s): return UtilStr.commas(s)
func pick(from): return Rand.pick(from)

func randomize_seed(): seed(OS.get_system_time_msecs())

func call_group(group:String, call:String, args:Array=[]):
	return UtilGodot.call_group(group, call, args)

# accomplish an achievement
func achieve(id:String="", tick:int=1): AchievementManager.achieve(id, tick)

# unlock one of the rewards
func reward(id:String=""): RewardManager.reward(id)

func quest(id:String="", goal_id:String="", tick:int=1):
	id = UtilStr.to_var(id)
	if id in self.QUESTS:
		goal_id = UtilStr.to_var(goal_id)
		if self.QUESTS[id].progress(goal_id, tick):
			pass

func music(id, kwargs=null): Audio.music(id)
func ambient(id): Audio.ambient(id)
func play(id): Audio.sound(id)

func input(key="", text=""): Sooty._node("input", "input", [key, text])

func end(): Sooty.show_menu()
func quit(): Sooty.get_tree().quit()
func restart(): Sooty._restart()

func scene(id): Sooty._set_scene(id)
func show_menu(): Sooty.show_menu()
	
	
#func bell(text, kwargs={}):
#	find_or_create("bell")._text(text, kwargs)
#
#func text(from="", text="", args=[], printer=_printer):
#	find_or_create("text", "printer %s" % [printer], "text")._main(args, {from=from, text=text})
