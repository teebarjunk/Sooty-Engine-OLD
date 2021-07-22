extends Node

var _save = true
var _slots:Array = []
var _slot_page:String = "A"
var _selected_slot = null
var _selected_index = null

func _ready():
	# create four slots
	for i in 3:
		var slot = $items.get_child(i)
		slot.index = i
		_slots.append(slot)
	
	var _e
	for child in $items/alphabet.get_children():
		_e = (child as Button).connect("pressed", self, "_set_page", [child.name])
	
	_set_page("A")

func _select(slot, index):
#	var double = slot == _selected_slot
	_selected_slot = slot
	_selected_index = index
	if slot != null:
		if _save:
			Sooty.save_game(slot)
			AlertManager.simple_alert({ text="Saved Slot %s" % [slot] })
			_update_slot(index, slot)
		else:
			Sooty.load_game(slot)
			queue_free()
			

func _set_page(page):
	_slot_page = page
	
	for i in 3:
		_update_slot(i, "%s%s" % [_slot_page, i+1])

func _update_slot(index, slot):
	var info = Sooty.get_slot_info(slot)
	_slots[index]._set_info(slot, info.image, info.info)
