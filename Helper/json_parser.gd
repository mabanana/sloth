extends Object
class_name JsonParser

static func load_json(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		
		if parse_result == OK:
			return json.get_data()
		else:
			print("JsonParser: parse failed")
			
	prints("JsonParser: file not found.")
	return {}
