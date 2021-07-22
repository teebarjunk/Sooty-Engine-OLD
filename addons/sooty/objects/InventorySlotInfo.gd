extends DictionaryResource
class_name InventorySlotInfo

func _init(d=null).(d):
	_merge_unique({id="", sum=0})

func item_info() -> ItemInfo:
	return ItemManager.get_info(self.id)

# returns remainder
func add(amount) -> int:
	var max_sum = item_info().get_stack_size()
	var space = max_sum - self.sum
	var diff = min(amount, space)
	self.sum += diff
	amount -= diff
	return diff
