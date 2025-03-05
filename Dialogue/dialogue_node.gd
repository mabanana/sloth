class_name DialogueNode

var id: String
var speaker_name: String
var text: String
var choices: Array[String]

func _init(id, speaker_name, text, choices: Array[String] = []):
	self.id = id
	self.speaker_name = speaker_name
	self.text = text
	self.choices = choices
