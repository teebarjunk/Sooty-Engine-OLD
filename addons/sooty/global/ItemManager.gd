extends Node

var items:Dictionary = {}

func get_info(id) -> ItemInfo:
	return items[id] as ItemInfo
