extends SootyImage
class_name SootyBG

var blur_rect:ColorRect
var blur_amount:float = 0.0 setget set_blur, get_blur

func _ready():
	blur_rect = $blur_rect
	blur_rect.set_material(Resources.load_material("blur screen lod"))
#	set_process(false)

func _created():
	at("middle")
#	modulate = Color.black
#	tint("white")
#	wait()
#	_wait = true

func set_texture(t):
	.set_texture(t)
	var vs = get_viewport_rect().size
	var rs = get_texture().get_size()
	position = vs * .5
	scale = Vector2(1.0 / rs.x, 1.0 / rs.y) * vs
	
func _args_to_image_path(args):
	return PoolStringArray(args).join(" ")

func blur(amount:float=0.0, time=1.0):
	print("blur ", amount, time)
	tween.interpolate(self, "blur_amount", blur_amount, amount, time)
	wait()

func set_blur(b):
	blur_amount = b
	blur_rect.visible = blur_amount > 0.0
	blur_rect.material.set_shader_param("blur", blur_amount)
	
	var s = get_rect().size
	blur_rect.rect_position = -s * .5
	blur_rect.rect_size = s

func get_blur():
	return blur_amount#blur_rect.material.get_shader_param("blur")
