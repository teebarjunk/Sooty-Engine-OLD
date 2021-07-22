tool
extends DictionaryResource
class_name CharacterInfo

func _init(d=null).(d):
#	print(d)
	pass

func _to_string():
	var out = UtilStr.format(get("name"), self)
	if "form" in self:
		return self.form % out
	return out

func add_stat(stat:String, amount:int):
	if not "stats" in _data:
		_data["stats"] = {}
	_data.stats[stat] = amount

func add_item(item:String, amount:int, kwargs=null):
	pass

func add_items(kwargs=null):
	if kwargs is Dictionary:
		for item_id in kwargs:
			add_item(item_id, kwargs[item_id])

func get_stat(stat:String) -> int:
	return _data.get("stats", {}).get(stat, 0)

func count(info) -> int:
	info = _fix_item(info)
	var total = 0
	if info:
		for item in self.Has:
			if item.id == info.id:
				total += item.sum
	return total

func _fix_item(item):
	match typeof(item):
		TYPE_STRING: return {id=item, sum=1}
		TYPE_ARRAY: return {id=item[0], sum=item[1]}
		TYPE_DICTIONARY: return item
		_: return null
