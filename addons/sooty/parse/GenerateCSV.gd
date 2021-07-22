tool
extends Resource

var csv = ["keys", "en"]

func generate(parser:SootyParser):
	var f = funcref(self, "_dig")
	for index in parser.chapters:
		var ch = parser.chapters[index]
		UtilDict.dig(ch.steps, f)

func _dig(d):
	if "T" in d and d.T in ["text"]:
		print(d.get("from", ""), ",", d.get("text", ""))
