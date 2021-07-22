class_name Zodiac

const RAT:int = 0
const OX:int = 1
const TIGER:int = 2
const RABBIT:int = 3
const DRAGON:int = 4
const SNAKE:int = 5
const HORSE:int = 6
const GOAT:int = 7
const MONKEY:int = 8
const ROOSTER:int = 9
const DOG:int = 10
const PIG:int = 11

# zodiac compatibilty
const COMPATIBLE_BEST:int = 0
const COMPATIBLE_GOOD:int = 1
const COMPATIBLE_OKAY:int = 2
const COMPATIBLE_SOSO:int = 3
const COMPATIBLE_POOR:int = 4
const COMPATIBLE_GRIM:int = 5

const IDS:Array = ["rat", "ox", "tiger", "rabbit", "dragon", "snake", "horse", "goat", "monkey", "rooster", "dog", "pig"]
const UNICODE:Array = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
const EMOJI:Array = ["🐀🐂🐅🐇🐉🐍🐎🐐🐒🐓🐕🐖"] # you wont be able to see these without an emoji font
const COMPATIBILITY:Array = ["best", "good", "okay", "soso", "poor", "grim"]

static func animal(year) -> String: return _at(IDS, _h(year))
static func emoji(year) -> String: return _at(EMOJI, _h(year))
static func unicode(year) -> String: return _at(UNICODE, _h(year))
static func trine(year) -> int: return (_h(year) % 4)
static func season(year) -> String: return _at(DateTime.SEASONS, int((_h(year) - 2) / 3.0))
static func element(year) -> String: return ["wood", "fire", "earth", "metal", "water"][int(_h(year) / 2) % 4]
static func yin_or_yang(year) -> String: return "yin" if _h(year) % 2 != 0 else "yang"
static func weekday(year) -> String: return _at(DateTime.WEEKDAYS, weekday_index(_h(year)))
static func weekday_index(year) -> int:
	match _h(year):
		MONKEY: return DateTime.DAY_SUN
		GOAT: return DateTime.DAY_MON
		DRAGON, PIG: return DateTime.DAY_TUE
		TIGER, HORSE: return DateTime.DAY_WED
		RAT, SNAKE: return DateTime.DAY_THU
		RABBIT, DOG: return DateTime.DAY_FRI
		OX, ROOSTER: return DateTime.DAY_SAT
		_: return -1

static func compatible(a, b) -> String:
	for i in 6:
		if _compatible(a, b, i):
			return COMPATIBILITY[i]
	return "???"

static func is_best(a, b) -> bool:
	a = _h(a)
	b = _h(b)
	return a != b and trine(a) == trine(b) 

static func is_good(a, b) -> bool:
	a = _h(a)
	b = _h(b)
	return a != b and _z(abs(_z(a-1)-5.5)) == _z(abs(_z(b-1)-5.5))

static func is_okay(a, b) -> bool:
	a = _h(a)
	b = _h(b)
	return a != b and int(_z(a-2)/3) == int(_z(b-2)/3)

static func is_soso(a, b) -> bool:
	a = _h(a)
	b = _h(b)
	# just check that it isn't in any other group
	for c in [COMPATIBLE_BEST, COMPATIBLE_GOOD, COMPATIBLE_OKAY, COMPATIBLE_POOR, COMPATIBLE_GRIM]:
		if _compatible(a, b, c):
			return false
	return true
# nearest half + neighbors of direct opposite - harmful
#			if a == b or is_zodiac_compatible(a, b, ZC_POOR) or is_zodiac_compatible(a, b, ZC_GRIM):
#				return false
#			var d = _zdist(a, b)
#			return d == 5 or d <= 3

static func is_poor(a, b) -> bool:
	a = _h(a)
	b = _h(b)
	return _zdist(a, b) == 6

static func is_grim(a, b) -> bool:
	a = _h(a)
	b = _h(b)
	return a != b and _z(abs(_z(a+2)-5.5)) == _z(abs(_z(b+2)-5.5))

# https://en.wikipedia.org/wiki/Chinese_zodiac
static func _compatible(a, b, mode:int) -> bool:
	match mode:
		COMPATIBLE_BEST: return is_best(a, b)
		COMPATIBLE_GOOD: return is_good(a, b)
		COMPATIBLE_OKAY: return is_okay(a, b)
		COMPATIBLE_SOSO: return is_soso(a, b)
		COMPATIBLE_POOR: return is_poor(a, b)
		COMPATIBLE_GRIM: return is_grim(a, b)
		_:
			push_error("no compatibility mode %s" % mode)
			return false

# year to horoscope index
static func _h(y) -> int:
	if y is DateTime:
		y = y.years
	return _z(y - 4)

static func _zdist(a:int, b:int) -> int:
	var p = int(abs(b - a)) % 12
	return 12 - p if p > 6 else p

static func _z(z) -> int:
	return wrapi(z, 0, 12) # int(floor(fposmod(z, 12)))

static func _at(list:Array, index:int):
	if index < 0 or index >= len(list):
		push_warning("%s is outside of %s" % [index, list])
		return "?"
	return list[index]
