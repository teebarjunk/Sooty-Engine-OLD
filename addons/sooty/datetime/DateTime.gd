tool
extends DictionaryResource
class_name DateTime

#static func gregorian_to_sexagenary(y:int) -> int:
#	return (y - 4)
#	return int((y - 3) - (60 * int(floor((y - 3) / 60))))

var seconds:int setget set_seconds, get_seconds
var minutes:int setget set_minutes, get_minutes
var hours:int setget set_hours, get_hours
var days:int setget set_days, get_days
var years:int setget set_years, get_years

var total_seconds:int setget set_total_seconds, get_total_seconds
var total_minutes:int setget, get_total_minutes
var total_hours:int setget, get_total_hours
var total_days:int setget, get_total_days

var weekday:String setget set_weekday, get_weekday
var weekday_index:int setget set_weekday_index, get_weekday_index
var month:String setget set_month, get_month
var month_index:int setget set_month_index, get_month_index
var day_of_month:int setget set_day_of_month, get_day_of_month
var day_of_month_ordinal:String setget, get_day_of_month_ordinal

var season:String setget, get_season
var period:String setget, get_period

var is_daytime:bool setget, get_is_daytime
var is_weekend:bool setget, get_is_weekend
var am_pm:String setget, get_am_pm
var hour_12:int setget, get_hour_12
var date:String setget, get_date
var time:String setget, get_time
var time_military:String setget, get_time_military

func _init(d=null):
	clear()
	if d:
		if d is Dictionary:
			add(d)
		elif d is int:
			set_seconds(d)
		else:
			add(d._data)

func _save():
	return _data

func update_delta(d:float):
	# update play time
	if not "delta" in _data:
		_data["delta"] = d
	else:
		_data.delta += d
	
	if _data.delta >= 1:
		self.seconds += 1
		_data.delta -= 1

func get_hours12() -> int: return get_hours() % 12
func get_date() -> String: return "%s %s" % [get_month().capitalize(), get_day_of_month_ordinal()]
func get_time() -> String: return "%s:%02d %s" % [get_hours12(), get_minutes(), get_am_pm()]
func get_time_military() -> String: return "%02d:%02d:%02d" % [_data.hours, _data.minutes, _data.seconds]

func get_seconds() -> int: return _data[K_SECONDS]
func set_seconds(i:int): 
	_data[K_SECONDS] = wrapi(i, 0, SECONDS_IN_MINUTE)
	self.minutes += i / SECONDS_IN_MINUTE

func get_minutes() -> int: return _data[K_MINUTES]
func set_minutes(i:int):
	_data[K_MINUTES] = wrapi(i, 0, MINUTES_IN_HOUR)
	self.hours += i / MINUTES_IN_HOUR

func get_hours() -> int: return _data[K_HOURS]
func set_hours(i:int):
	_data[K_HOURS] = wrapi(i, 0, HOURS_IN_DAY)
	self.days += i / HOURS_IN_DAY

func get_days() -> int: return _data[K_DAYS]
func set_days(i:int):
	_data[K_DAYS] = wrapi(i, 0, DAYS_IN_YEAR)
	self.years += i / DAYS_IN_YEAR

func get_years() -> int: return _data[K_YEARS]
func set_years(i:int):
	_data[K_YEARS] = i

func clear():
	for k in [K_SECONDS, K_MINUTES, K_HOURS, K_DAYS, K_YEARS]:
		_data[k] = 0

func reset(d:Dictionary={}):
	clear()
	add(d)

func copy(dt):
	for k in [K_SECONDS, K_MINUTES, K_HOURS, K_DAYS, K_YEARS]:
		_data[k] = dt._data[k]

func duplicate_future(amount):
	var dt = duplicate()
	dt.add(amount)
	return

func minimal_string():
	var out = ""
	for k in [K_YEARS, K_DAYS, K_HOURS, K_MINUTES, K_SECONDS]:
		if _data[k]:
			if out != "":
				out += ", "
			out += "%s:%s" % [k, _data[k]]
	return out

func format(s:String="{time} {seconds}s {date} {years}"): return UtilStr.format(s, self)
func printout(s:String="{time} {seconds}s {date} {years}"): print(format(s))

func add(other):
	if other is int:
		self.seconds += other
	
	elif other is Dictionary:
		if "year" in other: self.years = other["year"]
		if "month" in other: self.month = other["month"]
		
		if K_SECONDS in other: self.seconds += other[K_SECONDS]
		if K_MINUTES in other: self.minutes += other[K_MINUTES]
		if K_HOURS in other: self.hours += other[K_HOURS]
		if K_DAYS in other: self.days += other[K_DAYS]
		if K_YEARS in other: self.years += other[K_YEARS]
		
		if "day_of_month" in other: self.day_of_month = other["day_of_month"]
		if "weekday" in other: self.weekday = other["weekday"]
	
	else:
		push_error("Don't know how to add %s to datetime." % [UtilGodot.type_name(other)])

func set_from_current_datetime():
	clear()
	var d = OS.get_datetime()
	var days = d.day-1 + days_until_month(d.year, d.month-1)
	add({K_YEARS:d.year, K_DAYS:days, K_HOURS:d.hour, K_MINUTES:d.minute, K_SECONDS:d.second})
	return self

func set_total_seconds(s:int):
	clear()
	self.seconds = s

func get_total_seconds() -> int:
	return self.seconds +\
		self.minutes * SECONDS_IN_MINUTE +\
		self.hours * SECONDS_IN_HOUR +\
		self.days * SECONDS_IN_DAY +\
		self.years * SECONDS_IN_YEAR

func get_total_minutes() -> int:
	return self.minutes +\
		self.hours * MINUTES_IN_HOUR +\
		self.days * MINUTES_IN_DAY +\
		self.years * MINUTES_IN_YEAR

func get_total_hours() -> int:
	return self.hours +\
		self.days * HOURS_IN_DAY +\
		self.years * HOURS_IN_YEAR

func get_total_days() -> int:
	return self.days +\
		self.years * DAYS_IN_YEAR

func get_weekday_planet() -> String: return _at(WEEKDAY_PLANETS, self.weekday_index)
func get_weekday() -> String: return _at(WEEKDAYS, self.weekday_index).capitalize()
func get_weekday_index() -> int:
	# zeller's congruence
	var m = self.month_index - 1
	var y = self.years
	var d = self.day_of_month
	
	if m < 1:
		m += 12
		y -= 1
	
	var z = 13 * m - 1
	z = int(z / 5)
	z += d
	z += y
	z += int(y / 4)
	return wrapi(z - 1, 0, 7)

func set_weekday(wd:String):
	for i in 7:
		if WEEKDAYS[i].begins_with(wd):
			set_weekday_index(i)

func set_weekday_index(wd:int):
	self.days += abs(get_weekday_index() - (7 if wd == 0 else wd))

func set_month(id:String):
	for i in 12:
		if MONTHS[i].begins_with(id):
			self.month_index = i
			return
	push_error("No month: %s" % [id])

func get_month() -> String:
	return _at(MONTHS, self.month_index)

func set_month_index(m:int):
	var y = self.years
	self.days = days_until_month(y, m)
	self.years = y

func get_month_index() -> int:
	for i in range(11, -1, -1):
		if self.days >= days_until_month(self.years, i):
			return i
	return -1

func set_day_of_month(d:int):
	var y = self.years
	self.days = days_until_month(y, self.month_index) + d - 1
	self.years = y

func get_day_of_month() -> int:
	return self.days - days_until_month(self.years, self.month_index) + 1

func get_day_of_month_ordinal() -> String:
	return ordinal(get_day_of_month())

#
# periods
#

func get_season() -> String:
	return _at(SEASONS, wrapi(self.month_index-2, 0, 12) / 3)

func get_period() -> String:
	return _at(PERIOD, (wrapi(self.hours-1, 0, 24) * len(PERIOD)) / 24)

func get_part_of_day_delta() -> float:
	return wrapf(get_day_delta() * len(PERIOD) - .25, 0.0, 1.0)

# how many seconds into the day are we?
func get_seconds_into_day() -> int:
	return self.seconds + (self.minutes * SECONDS_IN_MINUTE) + (self.hours * SECONDS_IN_HOUR)

# how many seconds into the week are we?
func get_seconds_into_week() -> int:
	return self.weekday_index * SECONDS_IN_DAY

# how many seconds into the year are we?
func get_seconds_into_year() -> int:
	return get_seconds_into_day() + (self.days * SECONDS_IN_DAY)

func get_seconds_until_next_day() -> int:
	return SECONDS_IN_DAY - get_seconds_into_day()

func get_seconds_until_next_week() -> int:
	return SECONDS_IN_WEEK - get_seconds_into_week()

func get_seconds_until_next_month() -> int:
	var month:int = self.month_index
	var days_until = DAYS_IN_YEAR if month == MONTH_DEC else days_until_month(self.years, month+1)
	return (days_until - self.days) * SECONDS_IN_DAY

func get_seconds_until_next_year() -> int:
	return SECONDS_IN_YEAR - get_seconds_into_year()

#
# day
#

# 0.0 -> 1.0
func get_day_delta() -> float: return get_seconds_into_day() / float(SECONDS_IN_DAY)
func get_year_delta() -> float: return get_seconds_into_year() / float(SECONDS_IN_YEAR)

func get_is_daytime() -> bool: return self.hours >= 5 and self.hours <= 16
func get_is_weekend() -> bool: return self.days >= 6
func get_am_pm() -> String: return "am" if self.hours < 12 else "pm"
func get_hour_12() -> int: return (self.hours % 12)+1
#func _nmod(x:int, y:int):
#	if x < 0:
#		return -(y-x)/y
#	else:
#		return x/y

static func _at(list:Array, index:int):
	if index < 0 or index >= len(list):
		push_warning("%s is outside of %s" % [index, list])
		return "?"
	return list[index]

static func dict_to_seconds(d:Dictionary) -> int:
	return int(d.get(K_SECONDS, 0)) +\
		int(d.get(K_MINUTES, 0)) * SECONDS_IN_MINUTE +\
		int(d.get(K_HOURS, 0)) * SECONDS_IN_HOUR +\
		int(d.get(K_DAYS, 0)) * SECONDS_IN_DAY +\
		int(d.get(K_YEARS, 0)) * SECONDS_IN_YEAR

static func dict_from_seconds(s:int) -> Dictionary:
	var y:int = s / SECONDS_IN_YEAR
	s -= y * SECONDS_IN_YEAR
	var d:int = s / SECONDS_IN_DAY
	s -= d * SECONDS_IN_DAY
	var h:int = s / SECONDS_IN_HOUR
	s -= h * SECONDS_IN_HOUR
	var m:int = s / SECONDS_IN_MINUTE
	s -= m * SECONDS_IN_MINUTE
	return {K_YEARS:y, K_DAYS:d, K_HOURS:h, K_MINUTES:m, K_SECONDS:s}

static func is_leap(y:int) -> bool: return y % 4 == 0 and (y % 100 != 0 or y % 400 == 0)
static func days_in_month(y:int, m:int) -> int: return 29 if m == MONTH_FEB and is_leap(y) else DAYS_IN_MONTH[m]
static func days_until_month(y:int, m:int) -> int: return DAYS_UNTIL_MONTH[m] + (1 if m == MONTH_FEB and is_leap(y) else 0)

# sort objects with datetimes.
func sort(a:Array, key:String, reverse:bool=false):
	_data.sort_key = key
	_data.sort_reverse = reverse
	a.sort_custom(self, "_sort")
	var _e
	_e = _data.erase("sort_key")
	_e = _data.erase("sort_reverse")
	return a

func _sort(a, b):
	var k = _data.sort_key
	if _data.sort_reverse:
		return a[k].total_seconds < b[k].total_seconds
	else:
		return a[k].total_seconds >= b[k].total_seconds

# dictionary keys
const K_YEARS:String = "years"
const K_DAYS:String = "days"
const K_HOURS:String = "hours"
const K_MINUTES:String = "minutes"
const K_SECONDS:String = "seconds"

const DAYS_IN_YEAR:int = 365
const DAYS_IN_WEEK:int = 7
const HOURS_IN_DAY:int = 24
const HOURS_IN_YEAR:int = HOURS_IN_DAY * 365
const MINUTES_IN_HOUR:int = 60
const MINUTES_IN_DAY:int = MINUTES_IN_HOUR * HOURS_IN_DAY
const MINUTES_IN_YEAR:int = MINUTES_IN_DAY * 365
const SECONDS_IN_MINUTE:int = 60
const SECONDS_IN_HOUR:int = SECONDS_IN_MINUTE * MINUTES_IN_HOUR # 3600
const SECONDS_IN_DAY:int = SECONDS_IN_MINUTE * MINUTES_IN_HOUR * HOURS_IN_DAY # 86400
const SECONDS_IN_WEEK:int = SECONDS_IN_DAY * DAYS_IN_WEEK
const SECONDS_IN_YEAR:int = SECONDS_IN_MINUTE * MINUTES_IN_HOUR * HOURS_IN_DAY * DAYS_IN_YEAR # 31540000

# godot preserves dict order. this order is important.
#const D:Dictionary = {
#	K_YEARS: SECONDS_IN_YEAR,
#	K_DAYS: SECONDS_IN_DAY,
#	K_HOURS: SECONDS_IN_HOUR,
#	K_MINUTES: SECONDS_IN_MINUTE,
#	K_SECONDS: 1
#}

const POD_DAWN:int = 0
const POD_MORNING:int = 1
const POD_DAY:int = 2
const POD_DUSK:int = 3
const POD_EVENING:int = 4
const POD_NIGHT:int = 5

const DAY_SUN:int = 0
const DAY_MON:int = 1
const DAY_TUE:int = 2
const DAY_WED:int = 3
const DAY_THU:int = 4
const DAY_FRI:int = 5
const DAY_SAT:int = 6

const MONTH_JAN:int = 0
const MONTH_FEB:int = 1
const MONTH_MAR:int = 2
const MONTH_APR:int = 3
const MONTH_MAY:int = 4
const MONTH_JUN:int = 5
const MONTH_JUL:int = 6
const MONTH_AUG:int = 7
const MONTH_SEP:int = 8
const MONTH_OCT:int = 9
const MONTH_NOV:int = 10
const MONTH_DEC:int = 11

const SEASON_SPRING:int = 0
const SEASON_SUMMER:int = 1
const SEASON_AUTUMN:int = 2
const SEASON_WINTER:int = 3

const PERIOD:Array = ["dawn", "morning", "day", "dusk", "evening", "night"]
const WEEKDAYS:Array = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
const WEEKDAY_PLANETS:Array = ["sun", "moon", "mars", "mercury", "jupiter", "venus", "saturn"]
const MONTHS:Array = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
const SEASONS:Array = ["spring", "summer", "autumn", "winter"]

const DAYS_IN_MONTH:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
const DAYS_UNTIL_MONTH:Array = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]

const _ORDINAL:Dictionary = {1: 'st', 2: 'nd', 3: 'rd'}
static func ordinal(n) -> String:
	n = int(n)
	return str(n) + _ORDINAL.get(n if n % 100 < 20 else n % 10, "th")
