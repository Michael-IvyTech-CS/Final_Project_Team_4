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


func button_hover(button):
	hovered.emit(button)


func button_press(button):
	pressed.emit(button)
	

func _on_resume_mouse_entered():
	button_hover(get_node("CenterContainer/PauseMenuOptions/resume").text.to_lower())


func _on_resume_pressed():
	button_press(get_node("CenterContainer/PauseMenuOptions/resume").text.to_lower())


func _on_quit_to_menu_mouse_entered():
	button_hover(get_node("CenterContainer/PauseMenuOptions/quit to menu").text.to_lower())


func _on_quit_to_menu_pressed():
	button_press(get_node("CenterContainer/PauseMenuOptions/quit to menu").text.to_lower())
