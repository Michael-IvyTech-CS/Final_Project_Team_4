extends Control

signal hovered(button)
signal pressed(pressed)

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect the button signals to the main UI node for processing
	hovered.connect(get_parent_control()._on_button_hover)
	pressed.connect(get_parent_control()._on_button_press)
	# add to screen group
	add_to_group("screen")


func _on_quit_to_menu_mouse_entered():
	hovered.emit($"CenterContainer/ScoreMenu/quit to menu".text.to_lower())


func _on_quit_to_menu_pressed():
	pressed.emit($"CenterContainer/ScoreMenu/quit to menu".text.to_lower())
