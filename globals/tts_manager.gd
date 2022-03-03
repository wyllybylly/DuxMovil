extends Node


var TTS
var on = true
var has_tts


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.has_singleton("GodotTTS"):
		has_tts = true
		on = true
		TTS = Engine.get_singleton("GodotTTS")
		if TTS.isLanguageAvailable("Spanish", "AR"):
			TTS.initTextToSpeech("Spanish", "AR")
		else:
			print("Language is not available")
	else:
		has_tts = false
		on = false


func say(text):
	if on:
		TTS.textToSpeech(text)


func stop():
	if on:
		TTS.stop()


func toggle(new_state):
	if has_tts:
		on = new_state


func is_on():
	return on
