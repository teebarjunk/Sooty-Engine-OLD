extends DictionaryResource
class_name QuestInfo

#const STATE_NOT_STARTED:String = "GOAL_NOT_STARTED"
#const STATE_IN_PROGRESS:String = "GOAL_IN_PROGRESS"
#const STATE_PASSED:String = "GOAL_PASSED"
#const STATE_FAILED:String = "GOAL_FAILED"

class Goal:
	var name:String
	var desc:String
	var toll:int = 1
	var tick:int = 0
	var require:Array
	
	var on_fail:String
	var on_pass:String

	func _init(d):
		name = d.get("name", name)
		desc = d.get("desc", desc)
		toll = d.get("toll", toll)
		on_fail = d.get("fail", on_fail)
		on_pass = d.get("pass", on_pass)
		require = d.get("require", [])
	
	func progress(amount=1):
		var t = min(tick+amount, toll)
		if t != tick:
			tick = t
	
	func is_complete() -> bool:
		return tick == toll

var name:String
var desc:String
var goals:Dictionary = {}

var enabled:bool = true
var started:bool = false
var passed:int = 0
var failed:int = 0

var last_update:DateTime = DateTime.new()

func _init(d).(d):
	last_update.set_from_current_datetime()
	
	name = d.get("name", name)
	desc = d.get("desc", desc)
	enabled = d.get("enabled", enabled)
	started = d.get("started", started)
	var sg = d.get("goals", {})
	for id in sg:
		add_goal(id, sg[id])

func _save():
	var out = {
		keys={
			enabled=enabled,
			started=started,
			passed=passed,
			failed=failed,
		},
		subgoals={},
		last_update=last_update._save()
	}
	for k in goals:
		out.goals[k] = goals[k].tick
	return out

func _load(d):
	for k in d.keys:
		set(k, d.keys[k])
	
	for k in d.goals:
		goals[k].tick = d.goals[k]
	
	last_update._load(d.last_update)

func get_tick_and_toll():
	var tick = 0
	var toll = 0
	for g in goals:
		tick += goals[g].tick
		toll += goals[g].toll
	return {tick=tick, toll=toll}

func is_complete() -> bool:
	return passed > 0 or failed > 0

func get_attempt_count() -> int:
	return passed + failed + (1 if started else 0)

func add_goal(id, kwargs):
	goals[id] = Goal.new(kwargs)

func has_requirements(gid) -> bool:
	for rid in goals[gid].require:
		if not goals[rid].is_complete():
			return false
	return true

func start():
	if not started:
		started = true
		
		AlertManager.notify({
			type="Quest Started",
			name=name
		})
		last_update.set_from_current_datetime()

func fail():
	if started:
		started = false
		failed += 1
		
		AlertManager.notify({
			type="Quest Failed",
			name=name
		})
		last_update.set_from_current_datetime()
		
	else:
		print("can't fail '%s' if not started." % [name])

func clear():
	started = false
	failed = 0
	passed = 0
	for goal in goals.values():
		goal.tick = 0

# returns true if completed
func progress(gid, amount=1) -> bool:
	if not gid in goals:
		return false
	
	var g:Goal = goals[gid]
	if not g.is_complete() and has_requirements(gid):
		if not started:
			start()
		
		g.progress(amount)
		
		if g.is_complete():
			AlertManager.notify({
				type="Quest Goal Complete",
				name=g.name,
				desc=g.desc
			})
		else:
			AlertManager.notify({
				type="Quest Goal Progress",
				name=g.name,
				desc=g.desc,
				progress=Util.div(g.tick, g.toll)
			})
		last_update.set_from_current_datetime()
	
	var finished = true
	for gid in goals:
		if not goals[gid].is_complete():
			finished = false
			break
	
	if finished:
		started = false
		passed += 1
		
		AlertManager.notify({
			type="Quest Complete",
			name=name
		})
		last_update.set_from_current_datetime()
		return true
	
	return false


#
