tool
extends Control

export(int) var dots:int = 3
export(int) var index:int = 0
#export var radius:float = 5
#export var space:float = 4.0

func setup(d=dots, i=index):
	dots = d
	index = i
	update()

func _draw():
	var r = get_rect()
	var radius = r.size.y * .5
	var space = (r.size.x / (r.size.y / dots)) * .5
	
#	draw_rect(Rect2(Vector2.ZERO, r.size), Color.white, false)
	
	var buf = 0.45
	
	for i in dots:
		var t = Util.div(i, dots-1)
		var clr = Color.white if i == index else Color.darkgray
		var rad = radius if i == index else radius * .5
		draw_circle(Vector2(lerp(r.size.x * buf, r.size.x * (1.0 - buf), t), r.size.y * .5), rad, clr)
#		draw_circle(Vector2((space/dots) + i * space, 0), rad, clr)
