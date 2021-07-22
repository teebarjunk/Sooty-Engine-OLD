extends Resource

func generate(parser:SootyParser):
	var path = "res://.temp_json.json"
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(JSON.print(parser.meta_data.chapters))
	file.close()
	
	var pyout = []
	OS.execute("python3", ["graph.py"], true, pyout, true)
	for line in pyout:
		if line.strip_edges():
			print(line.strip_edges())
