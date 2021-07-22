extends WorldEnvironment

func _ready():
	environment.glow_bloom = 0.0
	$tween.interpolate(self, "environment:glow_bloom", 0.0, 0.25, 1.0)
	$tween.start()
