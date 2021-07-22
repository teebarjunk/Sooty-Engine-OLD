class_name Rand
# lot's of noise stuff taken from https://github.com/keijiro/

#
# str
#

static func str_char() -> String: return pick("abcdefghijklmnopqrstuvwxyz0123456789")
static func str_number() -> String: return pick("123456789")
static func vowel() -> String: return pick("aeiou")
static func consonant() -> String: return pick("bcdfghjklmnpqrstvwxyz")

static func word(len_min:int=3, len_max:int=6, end_in_vowel:bool=true) -> String:
	var out = ""
	for i in int(rand_range(len_min, len_max)):
		if (i%2==0) == end_in_vowel:
			out += vowel()
		else:
			out += consonant()
	return out

static func sentence(len_min:int=4, len_max:int=10) -> String:
	var out = ""
	for i in int(rand_range(len_min, len_max)):
		if i == 0:
			out += word().capitalize()
		else:
			out += pick("      ,,,::;-") + word()
	return out + pick("......?!")

static func paragraph(len_min:int=3, len_max:int=5) -> String:
	var out = ""
	for i in int(rand_range(len_min, len_max)):
		if i != 0:
			out += " "
		out += sentence()
	return out

#
# bool
#

static func rand_bool() -> bool: return randi() % 2 == 0

#
# int
#

static func rand_rangei(minn:int, maxx:int) -> int: return minn + randi() % (maxx - minn)

static func massaged_max(samples:int=2, sides:int=6) -> int:
	var best:int = -(sides+1)
	for i in samples:
		best = int(max(best, randi() % sides))
	return best

static func massaged_min(samples:int=2, sides:int=6) -> int:
	var worst:int = (sides+1)
	for i in samples:
		worst = int(min(worst, randi() % sides))
	return worst

static func pick_massaged_max(list:Array, samples:int=2) -> int:
	return list[massaged_max(samples, len(list))]

static func pick_massaged_min(list:Array, samples:int=2) -> int:
	return list[massaged_min(samples, len(list))]

#
# lists
#

# list of random ints that add up to n
static func list_equaling(n:int=100, size:int=20) -> Array:
	var negative = n < 0
	if negative:
		n = -n
	var v = [0, n]
	for i in size-1: v.append(0 if n == 0 else randi() % n)
	v.sort()
	var out = []
	for i in range(1, size+1): out.append(v[i-1]-v[i] if negative else v[i]-v[i-1])
	return out

# list of random floats that add up to n
static func list_equalingf(n:float=1.0, size:int=20) -> Array:
	var negative = n < 0
	if n < 0:
		n = -n
	var v = [0, n]
	for i in size-1: v.append(randf() * n)
	v.sort()
	var out = []
	for i in range(1, size+1): out.append(v[i-1]-v[i] if negative else v[i]-v[i-1])
	return out

static func pick(items):
	if items is Dictionary:
		return items[pick(items.keys())]
	return items[randi() % len(items)]

static func pick_excluding(items, item):
	while true:
		var picked = pick(items)
		if picked != item or len(items) <= 1:
			return picked

# picks a random item and removes it from the list or dict.
static func pick_pop(items):
	if items is Dictionary:
		var k = pick(items.keys())
		var out = items[k]
		items.erase(k)
		return out
	elif items is Array:
		var i = randi() % len(items)
		var out = items[i]
		items.remove(i)
		return out
	push_warning("can't pick_pop %s" % [items])
	return null

# pick a set of items from a list
static func pick_set(items, count:int) -> Array:
	var out = []
	for i in count:
		out.append(pick(items))
	return out

# pick a distinct set of items from a list
static func pick_set_unique(items, count:int) -> Array:
	var out = []
	while len(out) < count or len(out) >= len(items):
		var itm = pick(items)
		if not itm in out:
			out.append(itm)
	return out

# keep picking from random lists
static func pick_recursive(p):
	while true:
		if not p is Array:
			return p
		p = pick(p)

# swap between parents, selecting at that index
static func genome_pick(parents, r:float=.5) -> Array:
	var child = []
	var parent = pick(parents)
	for i in len(parents[0]):
		if randf() > r:
			parent = pick(parents)
		child.append(parent[i])
	return child

static func genome_lerp(parents) -> Array:
	var child = []
	for i in len(parents[0]):
		child.append(lerp(parents[0][i], parents[1][i], randf()))
	return child

#
# dict
#

static func _get_dict_weight(d:Dictionary) -> float:
	var total_weight:float = 0.0
	for k in d:
		total_weight += d[k]
	return total_weight

# pass a dict where keys will be returned and values are weights
static func pick_weighted(d:Dictionary, total_weight=null):
	if total_weight == null:
		total_weight = _get_dict_weight(d)
	var r:float = 1 + randf() * total_weight
	for k in d:
		r -= d[k]
		if r <= 0:
			return k

#
# colors
#

static func _hsv(h, s, v, a=1.0) -> Color: return Color().from_hsv(wrapf(h, 0.0, 1.0), s, v, a)

static func color_from_hash(item, a:float=1.0):
	seed(hash(item))
	return color_hsv(1, 1, a)

static func color_hsv(s:float=1, v:float=1, a:float=1) -> Color:
	return _hsv(randf(), s, v, a)

static func colors2_complimentary(s:float=1, v:float=1) -> PoolColorArray:
	var h = randf()
	return PoolColorArray([_hsv(h, s, v), _hsv(h+.5, s, v)])

static func colors3_analogous(dist:float=.05, s:float=1, v:float=1) -> PoolColorArray:
	var h = randf()
	return PoolColorArray([_hsv(h-dist, s, v), _hsv(h, s, v), _hsv(h+dist, s, v)])

static func colors3_triad(s:float=1, v:float=1) -> PoolColorArray:
	var h = randf()
	return PoolColorArray([_hsv(h, s, v), _hsv(h+(1.0/3.0), s, v), _hsv(h-(1.0/3.0), s, v)])

static func colors3_split_complement(dist:float=.05, s:float=1, v:float=1) -> PoolColorArray:
	var h = randf()
	return PoolColorArray([_hsv(h, s, v), _hsv(h+.5-dist, s, v), _hsv(h+.5+dist, s, v)])

static func colors4_square(s:float=1, v:float=1) -> PoolColorArray:
	var h = randf()
	return PoolColorArray([_hsv(h, s, v), _hsv(h+.25, s, v), _hsv(h+.5, s, v), _hsv(h+.75, s, v)])

static func colors4_tetrad(dist:float=.05, s:float=1, v:float=1) -> PoolColorArray:
	var h = randf()
	return PoolColorArray([_hsv(h, s, v), _hsv(h+dist, s, v), _hsv(h+.5, s, v), _hsv(h+.5+dist, s, v)])

#
# geometry
#

# slow when first called, because it hasn't cached data.
func in_polygon2D(poly:Polygon2D) -> Vector2:
	if not poly.has_meta("total_weight"):
		var points:PoolVector2Array = poly.polygon
		var indices:PoolIntArray = Geometry.triangulate_delaunay_2d(points)
		var tris:Dictionary = {}
		for i in range(0, len(indices), 3):
			var a = points[indices[i]]
			var b = points[indices[i+1]]
			var c = points[indices[i+2]]
			tris[[a,b,c]] = (a-b).cross(b-c).length() / 2.0 # area of triangle is it's weight
		poly.set_meta("tris", tris)
		poly.set_meta("indices", indices)
		poly.set_meta("total_weight", _get_dict_weight(tris))
	
	var rand_tri = pick_weighted(poly.get_meta("tris"), poly.get_meta("total_weight"))
	return in_triangle(rand_tri)

func in_triangle(tri:Array):
	var a = randf()
	var b = randf()
	if  a > b:
		return tri[0] * b + tri[1] * (a - b) + tri[2] * (1.0 - a)
	else:
		return tri[0] * a + tri[1] * (b - a) + tri[2] * (1.0 - b)

# vec2
static func v2() -> Vector2:
	return Vector2(randf(), randf())

static func on_circle() -> Vector2:
	var r = randf() * TAU
	return Vector2(cos(r), sin(r))

static func in_circle() -> Vector2:
	var r = randf() * TAU
	var l = randf()
	return Vector2(cos(r) * l, sin(r) * l)

# vec3
static func v3() -> Vector3: return Vector3(randf(), randf(), randf())
static func on_sphere() -> Vector3: return v3().normalized()
static func in_sphere() -> Vector3: return on_sphere() * randf()

# aabb
static func in_aabb(aabb):
	if aabb is AABB:
		return aabb.position + aabb.size * v3()
	elif aabb.has_method("get_aabb"):
		return aabb.global_transform * in_aabb(aabb.get_aabb())

#
# lerp
#

static func lerp_rand(a, b):
	if a is Vector3:
		return Vector3(lerp(a.x, b.x, randf()), lerp(a.y, b.y, randf()), lerp(a.z, b.z, randf()))
	elif a is Vector2:
		return Vector2(lerp(a.x, b.x, randf()), lerp(a.y, b.y, randf()))
	elif a is Color:
		return _hsv(lerp(a.h, b.h, randf()), lerp(a.s, b.s, randf()), lerp(a.v, b.v, randf()), lerp(a.a, b.a, randf()))
	else:
		return lerp(a, b, randf())

#
# noise
#

const TIME_SCALE:float = .001
static func _time(time_scale:float=.001) -> float: return OS.get_ticks_msec() * TIME_SCALE * time_scale

# about -0.5 - 0.5
static func noise(x:float) -> float:
	var X = _floori(x) & 0xff
	x -= floor(x)
	return lerp(_grad(_perm[X], x), _grad(_perm[X+1.0], x-1.0), _fade(x))

static func noise_timed(s:float=0, time_scale:float=1) -> float: return noise(s + _time(time_scale))
static func noise_timed_lerp(a, b, s:float=0, time_scale:float=1) -> float: return lerp(a, b, noise_timed(s, time_scale) + .5)

static func v2_noise(s:Vector2) -> Vector2: return Vector2(noise(s.x), noise(s.y))
static func v3_noise(s:Vector3) -> Vector3: return Vector3(noise(s.x), noise(s.y), noise(s.z))

static func v2_timed_noise(s:Vector2=Vector2(1,2), time_scale:float=1) -> Vector2: return v2_noise(s + Vector2.ONE * _time(time_scale))
static func v3_timed_noise(s:Vector3=Vector3(1,2,3), time_scale:float=1) -> Vector3: return v3_noise(s + Vector3.ONE * _time(time_scale))

#
# fractal brownian motion
#

# -0.5 - 0.5
static func fbm(x:float, octaves:int=2) -> float:
	var total:float = 0.0 		# final result
	var amplitude:float = 1.0	# amplitude
	var maximum:float = 0.0		# maximum
	var e:float = 3.0
	for i in octaves:
		total += amplitude * noise(x)
		maximum += amplitude
		amplitude *= 0.5
		x *= e
		e *= .95
	return total / maximum

static func fbm_timed(s:float=0, time_scale:float=1, octaves:int=2) -> float: return fbm(s + _time(time_scale), octaves)
static func fbm_timed_lerp(a, b, s:float=0, time_scale:float=1, octaves:int=2) -> float: return lerp(a, b, fbm_timed(s, octaves, time_scale) + .5)

static func v2_fbm(s:Vector2, octaves:int=2) -> Vector2: return Vector2(fbm(s.x, octaves), fbm(s.y, octaves))
static func v3_fbm(s:Vector3, octaves:int=2) -> Vector3: return Vector3(fbm(s.x, octaves), fbm(s.y, octaves), fbm(s.z, octaves))

static func v2_timed_fbm(s:Vector2=Vector2(1,2), octaves:int=2, time_scale:float=1) -> Vector2: return v2_fbm(s + Vector2.ONE * _time(time_scale), octaves)
static func v3_timed_fbm(s:Vector3=Vector3(1,2,3), octaves:int=2, time_scale:float=1) -> Vector3: return v3_fbm(s + Vector3.ONE * _time(time_scale), octaves)

static func _noise2(x:float, y:float) -> float:
	var X = _floori(x) & 0xff
	var Y = _floori(y) & 0xff
	x -= floor(x)
	y -= floor(y)
	var u = _fade(x)
	var v = _fade(y)
	var A = (_perm[X] + Y) & 0xff
	var B = (_perm[X+1] + Y) & 0xff
	return lerp(lerp(_grad2(_perm[A], x, y),	_grad2(_perm[B], x-1, y), u),
				lerp(_grad2(_perm[A+1], x, y-1), _grad2(_perm[B+1], x-1, y-1), u), v)

static func _noise3(x:float, y:float, z:float) -> float:
	var X = _floori(x) & 0xff
	var Y = _floori(y) & 0xff
	var Z = _floori(z) & 0xff
	x -= _floori(x)
	y -= _floori(y)
	z -= _floori(z)
	var u = _fade(x)
	var v = _fade(y)
	var w = _fade(z)
	var A  = (_perm[X] + Y) & 0xff
	var B  = (_perm[X+1] + Y) & 0xff
	var AA = (_perm[A] + Z) & 0xff
	var BA = (_perm[B] + Z) & 0xff
	var AB = (_perm[A+1] + Z) & 0xff
	var BB = (_perm[B+1] + Z) & 0xff
	return lerp(lerp(lerp(_grad3(_perm[AA], x, y, z), _grad3(_perm[BA], x-1, y, z), u),
					lerp(_grad3(_perm[AB], x, y-1, z), _grad3(_perm[BB], x-1, y-1, z), u), v),
				lerp(lerp(_grad3(_perm[AA+1], x, y, z-1), _grad3(_perm[BA+1], x-1, y, z-1), u),
					lerp(_grad3(_perm[AB+1], x, y-1, z-1), _grad3(_perm[BB+1], x-1, y-1, z-1), u), v), w)

static func _fbm2(x:float, y:float, octave:int=2) -> float:
	var total:float = 0.0
	var amplitude:float = 0.5
	var maximum:float = 0.0
	var e:float = 3.0
	for i in octave:
		total += amplitude * _noise2(x, y)
		maximum += amplitude
		amplitude *= 0.5
		x *= e
		y *= e
		e *= .95
	return total / maximum

static func _fbm3(x:float, y:float, z:float, octave:int=2) -> float:
	var total:float = 0.0
	var amplitude:float = 0.5
	var maximum:float = 0.0
	var e:float = 3.0
	for i in octave:
		total += amplitude * _noise3(x, y, z)
		maximum += amplitude
		amplitude *= 0.5
		x *= e
		y *= e
		z *= e
		e *= .95
	return total / maximum

static func _floori(x:float) -> int: return int(floor(x))
static func _fade(t:float) -> float: return t * t * t * (t * (t * 6.0 - 15.0) + 10.0)
static func _grad(h:int, x:float) -> float: return x if (h & 1) == 0 else -x
static func _grad2(h:int, x:float, y:float) -> float: return (x if (h & 1) == 0 else -x) + (y if (h & 2) == 0 else -y)

static func _grad3(h:int, x:float, y:float, z:float) -> float:
	h = h & 15;
	var u = x if h < 8 else y
	var v = y if h < 4 else (x if h == 12 || h == 14 else z)
	return (u if (h & 1) == 0 else -u) + (v if (h & 2) == 0 else -v)

const _perm:Array = [
151,160,137,91,90,15,
131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
151]
