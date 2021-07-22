class_name Horoscope

const ARIES:int = 0
const TAURUS:int = 1
const GEMINI:int = 2
const CANCER:int = 3
const LEO:int = 4
const VIRGO:int = 5
const LIBRA:int = 6
const SCORPIUS:int = 7
const SAGITTARIUS:int = 8
const CAPRICORN:int = 9
const AQUARIUS:int = 10
const PISCES:int = 11
#
const OPHIUCHUS:int = 12

const IDS:Array = ["aries", "taurus", "gemini", "cancer", "leo", "virgo", "libra", "scorpius", "sagittarius", "capricorn", "aquarius", "pisces", "ophiuchus"]
const UNICODE:Array = [0x2648, 0x2649, 0x264A, 0x264B, 0x264C, 0x264D, 0x264E, 0x264F, 0x2650, 0x2651, 0x2652, 0x2653, 0x26CE]
const TRINES:Array = ["fire", "earth", "air", "water"]
const _HOR_DATA:Array = [[9, 19, 10], [10, 18, 11], [11, 20, 0], [0, 19, 1], [1, 20, 2], [2, 20, 3], [3, 22, 4], [4, 22, 5], [5, 22, 6], [6, 22, 7], [7, 21, 8], [8, 21, 9]]

static func name(dt:DateTime) -> String: return _at(IDS, index_from_datetime(dt))
static func unicode(dt:DateTime) -> String: return _at(UNICODE, index_from_datetime(dt))
static func trine(dt:DateTime) -> String: return _at(TRINES, (index_from_datetime(dt) % 4))
static func hot_or_cold(dt:DateTime) -> String: return "hot" if ((index_from_datetime(dt) % 4) % 2) == 0 else "cold"
static func wet_or_dry(dt:DateTime) -> String: return "dry" if ((index_from_datetime(dt) % 4) / 2) == 0 else "wet"

static func index_from_datetime(dt:DateTime) -> int:
	var h = _HOR_DATA[dt.month_index]
	return h[0] if dt.day_of_month <= h[1] else h[2]

static func _at(list:Array, index:int):
	if index < 0 or index >= len(list):
		push_warning("%s is outside of %s" % [index, list])
		return "?"
	return list[index]
