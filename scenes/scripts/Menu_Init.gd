extends Control

#Variables for determine scene to load
var b_play		= false
var b_config	= false
var b_about		= false
var b_quit		= false

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	#VoiceConfiguration.connect("voice_activated", self, "scene_voice")
	scene_voice()

func scene_voice():
	#$"/root/VoiceConfiguration".play_voice("res://resources/sounds/main_menu.mp3")
	#if !sound_has_played:
		#sound_has_played = true
		$MainMenuSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Load scene acording to selection from menu
func _on_OptionSelected_finished():
	if b_quit: get_tree().quit()
	elif b_play: get_tree().change_scene("res://scenes/Choose_Player.tscn")
	elif b_config: get_tree().change_scene("res://scenes/Juego.tscn")
	elif b_about: get_tree().change_scene("res://scenes/DificultadScene.tscn")

#Functions to setup boolean to determine scene to load and doing a sound on selection
func _on_PlayButton_pressed():
	b_play = true
	$OptionSelected.play()

func _on_ConfigButton_pressed():
	b_config = true
	$OptionSelected.play()

func _on_AboutUsButton_pressed():
	b_about = true
	$OptionSelected.play()

func _on_QuitButton_pressed():
	$OptionSelected.play()
	b_quit = true
