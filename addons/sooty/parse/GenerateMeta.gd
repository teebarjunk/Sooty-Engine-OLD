extends Resource

const K_TYPE:String = "T"
const WORDS_PER_MINUTE:float = 200.0
const WORD_COUNTS:Dictionary = {
	999_999_999: "NO WAY!",
	1_800_000: "Mahabharata",
	1_200_000: "One Thousand and One Nights",
	950_000: "Planescape: Torment",
	820_595: "Fate/Stay Night",
	780_000: "The Bible",
	620_000: "Steins;Gate",
	455_125: "Lord of the Rings",
	300_000: "Mass Effect",
	206_052: "Moby Dick",
	185_723: "Dune",
	147_317: "Iliad",
	129_443: "Odyssey",
	110_000: "epic novel",
	90_000: "average novel",
	80_000: "novel",
	77_241: "Doki Doki Literature Club",
	50_000: "light novel",
	40_000: "small novel",
	33_000: "Kingdom Hearts",
	28_000: "Assassin's Creed",
	20_000: "novella",
	12_000: "movie script",
	10_000: "Halo: Combat Evolved",
	9_000: "Grand Theft Auto III",
	7_500: "novelette",
	5_500: "short story",
	3_600: "comic book",
	3_500: "a book chapter",
	2_947: "Hansel and Gretel",
	2_763: "Cinderella",
	1_500: "chapter book",
	1_000: "flash fiction",
	700: "newspaper article",
	600: "Manga chapter",
	500: "picture book",
	400: "a page",
	200: "a paragraph",
	150: "half a page",
	15: "a sentence",
	0: "nothing"
}

var _chapter_id
var _chapter = {}

var parser:SootyParser

var main:Dictionary = {
	time=0,
	lines=0,
	words=0
}
var chapters:Dictionary = {}
var characters:Dictionary = {}
var resources:Dictionary = {
	image={},
	sound={},
	scene={}
}

var routes:Dictionary = {}

func _init(p):
	parser = p

func file_meta(data):
	for k in data:
		main[k] = data[k]

func _do_chapter(ch:Dictionary):
	var fr = funcref(self, "_collect_step_meta")
	_chapter_id = ch.index
	_chapter = {
		name=ch.path[-1],
		time=0,
		lines=0,
		words=0,
		chars=[],
		next="",
		goto=[],
		call=[],
		goto_from=[],
		call_from=[],
	}
	chapters[_chapter_id] = _chapter
	UtilDict.dig(ch.steps, fr)
	
	main.words += _chapter.words
	main.lines += _chapter.lines
	_chapter.time = _words_to_time(_chapter.words)

func generate():
	_chapter = {}
	for index in parser.chapters:
		if _chapter and not _chapter.goto:
			_chapter.next = index
		
		var ch = parser.chapters[index]
		
		_do_chapter(ch)
	
#	_do_chapter(parser.ending)
	
	for cid in chapters:
		for c in chapters[cid].call:
			chapters[c].call_from.append(cid)
		
		for c in chapters[cid].goto:
			chapters[c].goto_from.append(cid)
	
	for cid in chapters:
		if not chapters[cid].goto and not chapters[cid].call_from and chapters[cid].next:
			chapters[cid].goto.append(chapters[cid].next)
	
	# chapter percentages
	for cid in chapters:
		var c = chapters[cid]
		c.lines = "%s (%s)" % [c.lines, _percent(c.lines, main.lines)]
		c.words = "%s (%s)" % [c.words, _percent(c.words, main.words)]
	
	for character in characters:
		var c = characters[character]
		c.lines = "%s (%s)" % [c.lines, _percent(c.lines, main.lines)]
		c.words = "%s (%s)" % [c.words, _percent(c.words, main.words)]
	
	main.time = _words_to_time(main.words)
	
	var word_count = main.words
	main.words = "%s (%s)" % [main.words, _page_count(main.words)]

func _percent(x, y):
	return "%" + str(int(Util.div(x, y) * 100.0))

func _words_to_time(words:int):
	var minutes = words / WORDS_PER_MINUTE
	return "%.1f minutes" % [minutes]

# how many pages written?
func _page_count(words:int) -> String:
	var out = ""
	var last
	for wc in WORD_COUNTS:
		if words >= wc:
			var more = words - wc
			var until = last - main.words
			out = "%s more than %s. %s til %s" % [more, WORD_COUNTS[wc], until, WORD_COUNTS[last]]
			break
		last = wc
	return out

func _add(d:Dictionary, k):
	if k in d:
		d[k] += 1
	else:
		d[k] = 1

func _collect_step_meta(step:Dictionary):
	if K_TYPE in step:
		match step[K_TYPE]:
			"bell": _add(resources.sound, step.bell)
			"sound": _add(resources.sound, step.id)
			"music": _add(resources.sound, step.id)
			
			"image": _add(resources.image, step.id)
			"scene": _add(resources.scene, step.id)
			
			"text":
				var wc = len(step.text.split(" "))
				_chapter.words += wc
				_chapter.lines += 1
				
				if "from" in step:
					var from = step.from.replace("{", "").replace("}", "")
					
					if not from in _chapter.chars:
						_chapter.chars.append(from)
					
					if not from in characters:
						characters[from] = {
							lines=0,
							words=0
						}
					characters[from].words += wc
					characters[from].lines += 1
			
			"goto":
				if not step.goto in _chapter.goto:
					_chapter.goto.append(step.goto)
			
			"call":
				if not step.call in _chapter.call:
					_chapter.call.append(step.call)
			
			"end":
				if not "_END_" in _chapter.goto:
					_chapter.goto.append(9999)

