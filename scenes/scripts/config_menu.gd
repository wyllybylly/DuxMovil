extends VBoxContainer


var selection = 0
var option_selected = false
var commit_selection = 0

var style_box
var selection_box_size
var selection_box_pos
var pressed_time
var current_rect

var change_option_player
var select_option_player

var from_level = false
signal changes_canceled
signal changes_saved


func _draw():
	draw_style_box(style_box, Rect2(selection_box_pos, selection_box_size))


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize option values
	set_default_values()
	
	# Load sounds
	change_option_player = get_node("../../../ChangeOptionPlayer")
	select_option_player = get_node("../../../SelectOptionPlayer")
	
	# Initialize selection boxes
	style_box = StyleBoxFlat.new()
	style_box.set_corner_radius_all(5)
	style_box.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style_box.border_color = Color.orange
	style_box.border_width_bottom = 5
	style_box.border_width_top = 5
	style_box.border_width_left = 5
	style_box.border_width_right = 5
	selection_box_pos = Vector2(-7.5, get_child(selection).get_rect().position.y - 5.0)
	selection_box_size = Vector2(get_child(selection).get_rect().size.x + 15, get_child(selection).get_rect().size.y + 10)

func _process(_delta):
	# Controls
	if Input.is_action_just_pressed("ui_down"):
		if not option_selected:
			if selection < get_child_count():
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
		if selection < get_child_count():
			if option_selected:
				pressed_time = 0
				manage_option("right")
		elif commit_selection < 2:
			commit_selection += 1
			set_selection(selection)
	if Input.is_action_just_pressed("ui_left"):
		if selection < get_child_count():
			if option_selected:
				pressed_time = 0
				manage_option("left")
		elif commit_selection > 0:
			commit_selection -= 1
			set_selection(selection)
	if Input.is_action_just_pressed("ui_accept"):
		if selection < get_child_count():
			select()
		else:
			select_option_player.pitch_scale = 1.0
			select_option_player.stop()
			select_option_player.play()
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
	$OverlaySizeRow/OverlaySizeOption.value = ConfigVariables.get_overlay_size()
	$OverlayAlphaRow/OverlayAlphaOption.value = ConfigVariables.get_overlay_alpha()
	$TextSizeRow/TextSizeOption.value = ConfigVariables.get_text_size()


func set_selection(new_value):
	selection = new_value
	if new_value == get_child_count():
		var option = get_node("../CommitButtons/HBoxContainer").get_child(2 * commit_selection)
		var option_pos = option.rect_global_position - rect_global_position
		selection_box_pos = Vector2(option_pos.x - 7.5, option_pos.y - 5.0)
		selection_box_size = Vector2(option.get_rect().size.x + 15.0, option.get_rect().size.y + 10.0)
	else:
		selection_box_pos = Vector2(-7.5, get_child(selection).get_rect().position.y - 5.0)
		selection_box_size = Vector2(get_child(selection).get_rect().size.x + 15, get_child(selection).get_rect().size.y + 10)
	change_option_player.stop()
	change_option_player.play()
	update()


func select():
	if option_selected:
		select_option_player.pitch_scale = 2.0
		selection_box_pos = Vector2(-7.5, get_child(selection).get_rect().position.y - 5.0)
		selection_box_size = Vector2(get_child(selection).get_rect().size.x + 15, get_child(selection).get_rect().size.y + 10)
	else:
		select_option_player.pitch_scale = 1.0
		selection_box_pos = Vector2(get_child(selection).get_child(1).get_rect().position.x + get_child(selection).get_rect().position.x - 7.5, get_child(selection).get_child(1).get_rect().position.y  + get_child(selection).get_rect().position.y - 5.0)
		selection_box_size = Vector2(get_child(selection).get_child(1).get_rect().size.x + 15, get_child(selection).get_child(1).get_rect().size.y + 10)
	select_option_player.stop()
	select_option_player.play()
	option_selected = !option_selected
	update()


func update_box():
	if option_selected:
		selection_box_pos = Vector2(get_child(selection).get_child(1).get_rect().position.x + get_child(selection).get_rect().position.x - 7.5, get_child(selection).get_child(1).get_rect().position.y  + get_child(selection).get_rect().position.y - 5.0)
		selection_box_size = Vector2(get_child(selection).get_child(1).get_rect().size.x + 15, get_child(selection).get_child(1).get_rect().size.y + 10)
	else:
		if selection == get_child_count():
			var option = get_node("/root/Menu/CenterContainer/VBoxContainer/CommitButtons/HBoxContainer").get_child(2 * commit_selection)
			var option_pos = option.rect_global_position - rect_global_position
			selection_box_pos = Vector2(option_pos.x - 7.5, option_pos.y - 5.0)
			selection_box_size = Vector2(option.get_rect().size.x + 15.0, option.get_rect().size.y + 10.0)
		else:
			selection_box_pos = Vector2(-7.5, get_child(selection).get_rect().position.y - 5.0)
			selection_box_size = Vector2(get_child(selection).get_rect().size.x + 15, get_child(selection).get_rect().size.y + 10)
	update()


func manage_option(input):
	# Get option
	var option = get_child(selection).get_child(1)
	
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
	ConfigVariables.update_overlay_size($OverlaySizeRow/OverlaySizeOption.value)
	ConfigVariables.set_overlay_alpha($OverlayAlphaRow/OverlayAlphaOption.value)
	ConfigVariables.set_text_size($TextSizeRow/TextSizeOption.value)
	if !from_level:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/Menu_Init.tscn")
	else:
		emit_signal("changes_saved")


func _on_Cancel_button_up():
	if !from_level:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/Menu_Init.tscn")
	else:
		emit_signal("changes_canceled")


func _on_Reset_button_up():
	set_default_values()


func _on_TextSizeOption_value_changed(value):
	$TextSizeRow/TextSizeLabel.get("custom_fonts/font").set_size(ConfigVariables.get_text_size_m_value(value))
	get_node("../Title").get("custom_fonts/font").set_size(ConfigVariables.get_text_size_l_value(value))
	set_min_size(value)
	yield(get_tree(), "idle_frame")
	update_box()


func set_min_size(value):
	for row in get_children():
		row.get_child(0).rect_min_size.x = 200.0 + 90.0 * value
