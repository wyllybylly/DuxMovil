tool
extends MenuButtonBase


func _ready():
	update_size()


func update_size():
	rect_min_size.x = $ButtonText.text.length() * ConfigVariables.get_text_size_m_value() * 0.75 - 10.0
	rect_min_size.y = ConfigVariables.get_text_size_m_value() + 12.0
