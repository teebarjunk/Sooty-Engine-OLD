extends Node

func setup(achievement:AchievementInfo):
	var a_icon = $item/icon_holder/icon
	var a_progress = $item/properties/progress
	var a_name = $item/properties/text/name
	var a_desc = $item/properties/text/desc
	var a_prog_label = $item/properties/progress/label
	var a_prog = $item/properties/progress/bar
	
	Resources.set_fonts(a_name, Config.caption_font)
	Resources.set_fonts(a_desc, Config.caption_font)
	Resources.set_fonts(a_prog_label, Config.alert_name_font)
	
	if achievement.is_hidden():
		# text
		a_name.bbcode_text = "?" # award._name
		a_desc.bbcode_text = "?"
		# progress
		a_prog_label.text = ""
		a_progress.visible = false
		
		self.modulate = Color.darkgray
		Resources.set_texture(a_icon, "locked")
		
	else:
		# icon
		Resources.set_texture(a_icon, achievement.get_icon())
#		yield(get_tree(), "idle_frame")
#		a_icon.rect_size = Util.one_over(a_icon.texture.get_size())# * Vector2(32, 32)
#		print(a_icon, a_icon.texture, Util.one_over(a_icon.texture.get_size()))
		# text
		a_name.bbcode_text = Sooty.format(achievement.name)
		a_desc.bbcode_text = Sooty.format(achievement.desc)
		# progress
		if achievement.toll == 1:
			a_progress.visible = false
		
		a_prog_label.text = "%s out of %s" % [achievement.tick, achievement.toll]
		a_prog.value = int(achievement.get_progress() * 100.0)
	
