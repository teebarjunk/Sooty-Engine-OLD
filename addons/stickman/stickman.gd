tool
extends Node2D

export var head_texture:Texture
export var head_size:Vector2 = Vector2(32.0, 32.0)
export(float, -3.141, 3.141) var head_rotation:float = 0 setget set_head_rotation
export var width:float = 10.0
export var trunk_scale:float = 2.0
export var color:Color = Color.gray
export var antialias:bool = true

func _get_tool_buttons(): return ["test"]

func test():
	var d = DictionaryResource.new()
	d.score = 10
	d.score1 = 1
	d.internal_var = "non"
	print(d, d._save(), d.score1)
#	d.score2 = 20
#	print(d, d._save(), d.score1)
#	d.score1 = 10
#	print(d, d._save(), d.score1)

func set_head_rotation(v):
	head_rotation = v
	update()

func _draw():
	var mid = Vector2(0, 0)
	var neck = Vector2(0, -64)
	var r = ceil(width * .5)
	var aa = antialias
	
	draw_line(mid, neck, color, width * trunk_scale)
#	draw_circle(neck, r*trunk_scale, color)
	
	var l_shoulder = neck + Vector2(-16, 0)
	var l_arm = l_shoulder + Vector2(-8, 32)
	var l_wrist = l_arm + Vector2(0, 32)
	draw_line(l_shoulder, l_arm, color, width, aa)
	draw_line(l_arm, l_wrist, color, width, aa)
	
	draw_circle(l_arm, r, color)
	draw_circle(l_wrist, r, color)
	
	var r_shoulder = neck + Vector2(16, 0)
	var r_arm = r_shoulder + Vector2(8, 32)
	var r_wrist = r_arm + Vector2(0, 32)
	draw_line(r_shoulder, r_arm, color, width, aa)
	draw_line(r_arm, r_wrist, color, width, aa)
	
	draw_circle(r_arm, r, color)
	draw_circle(r_wrist, r, color)
	
	
	# left leg
	var l_hip = mid + Vector2(-8, 0)
	var l_leg = l_hip + Vector2(-8, 32)
	var l_ankle = l_leg + Vector2(0, 32)
	draw_line(l_hip, l_leg, color, width, aa)
	draw_line(l_leg, l_ankle, color, width, aa)
	
	draw_circle(l_hip, r, color)
	draw_circle(l_leg, r, color)
	
	# right leg
	var r_hip = mid + Vector2(8, 0)
	var r_leg = r_hip + Vector2(8, 32)
	var r_ankle = r_leg + Vector2(0, 32)
	draw_line(r_hip, r_leg, color, width, aa)
	draw_line(r_leg, r_ankle, color, width, aa)
	
	draw_circle(r_hip, r, color)
	draw_circle(r_leg, r, color)
	
	# head
	var head = neck
	draw_set_transform(head, head_rotation, Vector2.ONE)
	if head_texture:
		draw_texture_rect(head_texture, Rect2(Vector2(-head_size.x*.5, -head_size.y), head_size), false, Color.white)
