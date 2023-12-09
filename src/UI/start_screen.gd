extends Control

signal hovered(button)
signal pressed(pressed)


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	# connect the button signals to the main UI node for processing
	hovered.connect(get_parent_control()._on_button_hover)
	pressed.connect(get_parent_control()._on_button_press)


func button_hover(button):
	hovered.emit(button)


func button_press(button):
	pressed.emit(button)


func _on_play_mouse_entered():
	button_hover(get_node("CenterContainer/StartMenuOptions/play").text.to_lower())


func _on_play_pressed():
	# get the button's text and pass that along as a form of identifier
	button_press(get_node("CenterContainer/StartMenuOptions/play").text.to_lower())


func _on_credits_mouse_entered():
	# get the button's text and pass that along as a form of identifier
	button_hover(get_node("CenterContainer/StartMenuOptions/credits").text.to_lower())


func _on_credits_pressed():
	# get the button's text and pass that along as a form of identifier
	button_press(get_node("CenterContainer/StartMenuOptions/credits").text.to_lower())


func _on_quit_mouse_entered():
	# get the button's text and pass that along as a form of identifier
	button_hover(get_node("CenterContainer/StartMenuOptions/quit").text.to_lower())


func _on_quit_pressed():
	# get the button's text and pass that along as a form of identifier
	button_press(get_node("CenterContainer/StartMenuOptions/quit").text.to_lower())
