tool
class_name AchievementInfo
extends DictionaryResource

var name:String = "Basic Achievement"
var desc:String = "Gain a point."
var tick:int = 0
var toll:int = 1
#var icon:String = "icon"

var hidden:bool = false
var enabled:bool = true

var datetime:DateTime = DateTime.new() # Will be a date time once achieved.
var accepted:bool = false # Has the user accepted the rewards?

func _init(d=null).(d):
	pass

func _save():
	return {
		keys={
			tick=tick,
			hidden=hidden,
			enabled=enabled,
			accepted=accepted
		},
		datetime=datetime._save()
	}

func _load(d):
	for k in d.keys:
		set(k, d.keys[k])
	datetime._load(d.datetime)

func clear():
	tick = 0
	datetime.clear()
	accepted = false

func is_complete() -> bool:
	return tick == toll

func is_hidden() -> bool:
	return tick == 0

func get_icon() -> String:
	return getor("icon", "icon")

func progress(amount:int=1) -> bool:
	var np = min(tick + amount, toll)
	if np == tick:
		return false

	set("tick", np)

	if is_complete():
		AlertManager.alert({
			type="Achievement",
			name=name,
			desc=desc,
			icon=get_icon(),
			sound="achievement_got"
		})
		datetime.set_from_current_datetime()

	else:
#		var sound = "coin01"# % [int(rand_range(1, 7))]
		AlertManager.alert({
			type="Achievement Progress",
			name=name,
			desc=desc,
			icon="icon locked",
			sound="achievement_progress",
			progress=get_progress()
		})
	return true

func get_progress() -> float:
	return Util.div(tick, toll)

