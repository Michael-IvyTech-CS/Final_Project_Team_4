extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartScreen.visible = true
	# $PauseScreen.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_hover(button):
	$button_hover_fx.play()
	print(button + " button hovered.")


func _on_button_press(button):
	$button_press_fx.play()
	print(button + " button pressed.")
