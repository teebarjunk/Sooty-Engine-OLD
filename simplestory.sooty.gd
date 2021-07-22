extends SootyBaseScript # version 0.1
const PROP_CHARACTERS:Array = ["noob", "godette", "godot", "icon_png"]
# 4
var noob:CharacterInfo = CharacterInfo.new({"name":"Noob","desc":"A noob.","form":"[color=#ffadff2e][b]%s[/b][/color]"})
var godette:CharacterInfo = CharacterInfo.new({"name":"Godette","desc":"A game developer.","form":"[color=#ff00bfff][b]%s[/b][/color]"})
var godot:CharacterInfo = CharacterInfo.new({"name":"Godot","desc":"A game engine.","form":"[color=#ff1f8fff][b]%s[/b][/color]"})
var icon_png:CharacterInfo = CharacterInfo.new({"name":"icon.png","desc":"Texture placeholder.","form":"[color=#ff1f8fff][b][i]%s[/i][/b][/color]"})
func _init():
	_reset_everything()
func _reset_everything():
	Sooty.meta = {"title":"Godot Quest","subtitle":"The Begining","author":"The Author","version":"v1.0a"}
	Config.screen_size = Vector2( 800, 600 )
	Config.menu_image = "class_front"
	Config.menu_music = "intro theme"
	AchievementManager.clear()
	AchievementManager.add("good_ending", {"name":"Good Ending","desc":"Learned about {godot}.","icon":"godette head"})
	AchievementManager.add("bad_ending", {"name":"Bad Ending","desc":"Went home.","icon":"godette head mad"})
	QuestManager.clear()
	QuestManager.add("learn_godot", {"name":"Learn Godot","desc":"Ask GODETTE about learning GODOT.","goals":{"learn_functions":{"name":"Learn Functions"},"learn_arrays":{"name":"Learn Arrays"}}})
const CHAPTERS:Dictionary = {
	"start": [
		["_eval",             [["scene(\"class_steps\")"]]],
		["_eval",             [["music(\"happytune\")","input(\"noob.name\", \"What is the characters name?\")"]]],
		["_node",             ["text", "", [ "", "Another [i]boring[/i] school day ends." ]]],
		["_node",             ["godette", "", [ "main" ], {}, [ "scale(0.3)" ]]],
		["_eval",             [["play(\"hey\")"]]],
		["_node",             ["text", "", [ "godette", "Oh {noob}, I was wondering..." ]]],
		["_node",             ["text", "", [ "godette", "Have you ever heard of {godot}?  " ]]],
		["_eval",             [["play(\"laughter\")"]]],
		["_node",             ["text", "", [ "godette", "Well, I should be going." ]]],
		["_eval",             [["play(\"bye\")"]]],
		["_node",             ["godette", "", [ "leaving" ], {}, [  ]]],
		["_node",             ["list", "", [null, "\"\"", [{"-":"-","text":"Ask her about {godot}.","then":"start_menu_0"},{"-":"-","text":"Go on with your day.","then":"start_menu_1"}]]]]
	],
	"start_menu_0": [
		["_node",             ["text", "", [ "noob", "Hey, wait!" ]]],
		["_eval",             [["play(\"what\")"]]],
		["_node",             ["godette", "", [ "confused" ], {}, [  ]]],
		["_node",             ["text", "", [ "godette", "What? You want to learn about {godot}?" ]]],
		["_stack_goto",       ["good_ending"]]
	],
	"start_menu_1": [
		["_node",             ["text", "", [ "", "{godette} walks on away." ]]],
		["_node",             ["text", "", [ "noob", "Nah, not me. I could never make a game." ]]],
		["_stack_goto",       ["bad_ending"]]
	],
	"bad_ending": [
		["_eval",             [["scene(\"class_front\")"]]],
		["_eval",             [["music(\"no_hope\")","ambient(\"rain\")"]]],
		["_node",             ["rain", "", [  ], {}, [  ]]],
		["_node",             ["text", "", [ "noob", "What was she talking about?" ]]],
		["_node",             ["text", "", [ "noob", "Go-go-dot?" ]]],
		["_node",             ["text", "", [ "noob", "I guess I'll never know." ]]],
		["_eval",             [["achieve(\"bad_ending\")"]]],
		["_node",             ["text", "printer_center", [ "", "This is the [color=#ffff0000][b][i]Bad Ending[/i][/b][/color]." ]]],
		["_eval",             [["show_menu()"]]]
	],
	"good_ending": [
		["_eval",             [["scene(\"class_exit\")"]]],
		["_node",             ["godette", "", [ "main" ], {}, [ "scale(0.3)", "at(\"left\")" ]]],
		["_eval",             [["play(\"hello\")"]]],
		["_node",             ["text", "", [ "godette", "Oh, you showed up?" ]]],
		["_node",             ["godette", "", [  ], {}, [ "move(\"center\", 0.5)" ]]],
		["_node",             ["text", "", [ "godette", "I'm so glad you wanted to learn {godot}!" ]]],
		["_node",             ["text", "", [ "godette", "Oh, look who it is." ]]],
		["_node",             ["godette", "", [  ], {}, [ "move(\"centerleft\")" ]]],
		["_node",             ["icon_png", "", [  ], {}, [ "at(\"midright\")" ]]],
		["_node",             ["text", "", [ "godette", "This is {icon_png}. You'll be seeing a lot of him around." ]]],
		["_eval",             [["achieve(\"good_ending\")"]]],
		["_node",             ["text", "printer_center", [ "", "This is the [color=#ff99cc33][b][i]Good Ending[/i][/b][/color]!" ]]],
		["_eval",             [["show_menu()"]]]
	],
}
