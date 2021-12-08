tool
extends GridContainer


var selection = 0
var option_selected = false
var commit_selection = 0

var style_box
var selection_box_size
var selection_box_pos
var pressed_time

var change_option_player
var select_option_player


func _draw():
	draw_style_box(style_box, Rect2(selection_box_pos, selection_box_size))


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize selection boxes
	style_box = StyleBoxFlat.new()
	style_box.set_corner_radius_all(5)
	style_box.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style_box.border_color = Color.orange
	style_box.border_width_bottom = 5
	style_box.border_width_top = 5
	style_box.border_width_left = 5
	style_box.border_width_right = 5
	selection_box_size = Vector2(get_rect().size.x + 15, get_child(2 * selection).get_rect().size.y + 10)
	selection_box_pos = Vector2(-7.5, -5.0)
#	option_box_size = Vector2.ZERO
#	option_box_pos = Vector2(get_child(2 * selection + 1).get_rect().position.x - 7.5, get_child(2 * selection + 1).get_rect().position.y - 5.0)
	
	# Initialize option values
	set_default_values()
	
	# Load sounds
	change_option_player = get_node("/root/Menu/ChangeOptionPlayer")
	select_option_player = get_node("/root/Menu/SelectOptionPlayer")


func _process(delta):
	# Controls
	if Input.is_action_just_pressed("ui_down"):
		if not option_selected:
			if selection < (get_child_count() / 2):
				set_selection(selection + 1)
		else:
			pressed_time = 0
			manage_option("down")
	if Input.is_action_just_pressed("ui_up"):
		if not option_selected:
			if selection > 0:
				set_selection(selection - 1)
		else:
			pressed_time = 0
			manage_option("up")
	if Input.is_action_just_pressed("ui_right"):
		if selection < get_child_count() / 2 and option_selected:
			pressed_time = 0
			manage_option("right")
		elif commit_selection < 2:
			commit_selection += 1
			set_selection(selection)
	if Input.is_action_just_pressed("ui_left"):
		if selection < get_child_count() / 2 and option_selected:
			pressed_time = 0
			manage_option("left")
		elif commit_selection > 0:
			commit_selection -= 1
			set_selection(selection)
	if Input.is_action_just_pressed("ui_accept"):
		select_option_player.stop()
		select_option_player.play()
		if selection < get_child_count() / 2:
			select()
		else:
			if commit_selection == 0:
				_on_Save_button_up()
			elif commit_selection == 1:
				_on_Cancel_button_up()
			elif commit_selection == 2:
				_on_Reset_button_up()
	if Input.is_action_pressed("ui_down"):
		if option_selected:
			pressed_time += 1
			if pressed_time % 10 == 0:
				manage_option("down")
	if Input.is_action_pressed("ui_up"):
		if option_selected:
			pressed_time += 1
			if pressed_time % 10 == 0:
				manage_option("up")
	if Input.is_action_pressed("ui_right"):
		if option_selected:
			pressed_time += 1
			if pressed_time % 10 == 0:
				manage_option("right")
	if Input.is_action_pressed("ui_left"):
		if option_selected:
			pressed_time += 1
			if pressed_time % 10 == 0:
				manage_option("left")


func set_default_values():
	$OverlaySizeOption.value = ConfigVariables.get_overlay_size_value()
	$OverlayAlphaOption.value = ConfigVariables.get_overlay_alpha()


func set_selection(new_value):
	selection = new_value
	if new_value == get_child_count() / 2:
		var option = get_node("/root/Menu/CenterContainer/VBoxContainer/CommitButtons/HBoxContainer").get_child(2 * commit_selection)
		var option_pos = option.rect_global_position - rect_global_position
		selection_box_pos = Vector2(option_pos.x - 7.5, option_pos.y - 5.0)
		selection_box_size = Vector2(option.get_rect().size.x + 15.0, option.get_rect().size.y + 10.0)
	else:
		selection_box_pos = Vector2(-7.5, min(get_child(2 * selection).get_rect().position.y, get_child(2 * selection + 1).get_rect().position.y) - 5.0)
		selection_box_size = Vector2(get_rect().size.x + 15, max(get_child(2 * selection).get_rect().size.y, get_child(2 * selection + 1).get_rect().size.y) + 10)
	change_option_player.stop()
	change_option_player.play()
	update()


func select():
	if option_selected:
		selection_box_pos = Vector2(-7.5, min(get_child(2 * selection).get_rect().position.y, get_child(2 * selection + 1).get_rect().position.y) - 5.0)
		selection_box_size = Vector2(get_rect().size.x + 15, max(get_child(2 * selection).get_rect().size.y, get_child(2 * selection + 1).get_rect().size.y) + 10)
	else:
		selection_box_pos = Vector2(get_child(2 * selection + 1).get_rect().position.x - 7.5, get_child(2 * selection + 1).get_rect().position.y - 5.0)
		selection_box_size = Vector2(get_child(2 * selection + 1).get_rect().size.x + 15, get_child(2 * selection + 1).get_rect().size.y + 10)
	option_selected = !option_selected
	update()


func manage_option(input):
	# Get option
	var option = get_child(2 * selection + 1)
	
	# SpinBox
	if option is SpinBox:
		if input == "up" or input == "right":
			option.value += option.step
		elif input == "down" or input == "left":
			option.value -= option.step
	
	# HSlider
	elif option is HSlider:
		if input == "up" or input == "right":
			option.value += option.step
		elif input == "down" or input == "left":
			option.value -= option.step


func _on_Save_button_up():
	ConfigVariables.update_overlay_size($OverlaySizeOption.value)
	ConfigVariables.set_overlay_alpha($OverlayAlphaOption.value)
	get_tree().change_scene("res://scenes/Menu_Init.tscn")


func _on_Cancel_button_up():
	get_tree().change_scene("res://scenes/Menu_Init.tscn")


func _on_Reset_button_up():
	set_default_values()
