extends DictionaryResource
class_name InventoryInfo

func _init():
	set("items", [])

func has(id) -> bool:
	if id is String:
		return count(id) >= 1
	
	elif id is Dictionary:
		for k in id:
			if count(k) < id[k]:
				return false
		return true
	
	return false

func count(id) -> int:
	var count = 0
	
	if id is String:
		for slot_item in self.items:
			if slot_item.id == id:
				count += slot_item.sum
	
	elif id is Dictionary:
		for k in id:
			count += count(id[k])
	
	return count

func add(id, sum=1, kwargs=null):
	self.items.append(_new_slot(id, sum))

func remove(id, sum=1, kwargs=null):
	pass

func _new_slot(id:String, sum:int=1):
	return InventorySlotInfo.new({id=id, sum=sum})
