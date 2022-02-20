extends Node


var TTS


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.has_singleton("GodotTTS"):
		TTS = Engine.get_singleton("GodotTTS")
		if TTS.isLanguageAvailable("Spanish", "AR"):
			TTS.initTextToSpeech("Spanish", "AR")
		else:
			print("Language is not available")


func say(text):
	TTS.textToSpeech(text)


func stop():
	TTS.stop()
