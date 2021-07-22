class_name Birthstone

static func by_month(dt:DateTime) -> String:
	match dt.month_index:
		DateTime.MONTH_JAN: return "garnet"
		DateTime.MONTH_FEB: return "amethyst"
		DateTime.MONTH_MAR: return "bloodstone"
		DateTime.MONTH_APR: return "diamond"
		DateTime.MONTH_MAY: return "emerald"
		DateTime.MONTH_JUN: return "pearl"
		DateTime.MONTH_JUL: return "ruby"
		DateTime.MONTH_AUG: return "peridot"
		DateTime.MONTH_SEP: return "saphire"
		DateTime.MONTH_OCT: return "opal"
		DateTime.MONTH_NOV: return "topaz"
		DateTime.MONTH_DEC: return "turquoise"
		_: return "?"

static func by_weekday(dt:DateTime) -> Array:
	match dt.weekday_index:
		DateTime.DAY_SUN: return ["topaz", "diamond"]
		DateTime.DAY_MON: return ["pearl", "crystel"]
		DateTime.DAY_TUE: return ["ruby", "emerald"]
		DateTime.DAY_WED: return ["amethyst", "lodestone"]
		DateTime.DAY_THU: return ["sapphire", "carnelian"]
		DateTime.DAY_FRI: return ["emerald", "cat's eye"]
		DateTime.DAY_SAT: return ["turquoise", "diamond"]
		_: return []

static func by_horoscope(dt:DateTime) -> String:
	match Horoscope.index_from_datetime(dt):
		Horoscope.ARIES: return "bloodstone"
		Horoscope.TAURUS: return "sapphire"
		Horoscope.GEMINI: return "agate"
		Horoscope.CANCER: return "emerald"
		Horoscope.LEO: return "onyx"
		Horoscope.VIRGO: return "carnelian"
		Horoscope.LIBRA: return "chrysolite"
		Horoscope.SCORPIUS: return "beryl"
		Horoscope.SAGITTARIUS: return "topaz"
		Horoscope.CAPRICORN: return "ruby"
		Horoscope.AQUARIUS: return "garnet"
		Horoscope.PISCES: return "amethyst"
		_: return "?"
