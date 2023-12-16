extends Control

@export var StartScreen: PackedScene
@export var PauseScreen: PackedScene
@export var CreditsScreen: PackedScene
@export var ScoreScreen: PackedScene

signal start
signal kill

var playing: bool = false  # true when the 'play' button has been pressed and the user is presumably playing the game

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(StartScreen.instantiate())
	$StartScreen.hovered.connect(self._on_button_hover)
	$StartScreen.pressed.connect(self._on_button_press)
	pass
	# $CreditsScreen.visible = true
	# $StartScreen.visible = true
	# $PauseScreen.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		if get_tree().get_nodes_in_group("screen").size() == 0:
			add_child(PauseScreen.instantiate())
			get_tree().paused = true


func _on_button_hover(button):
	$button_hover_fx.play()


func _on_button_press(button):
	$button_press_fx.play()  # play satisfying button clicking sounds
	
	match button.to_lower():
		"play":
			start.emit()
			$StartScreen.queue_free()
		"credits":
			$StartScreen.queue_free()
			add_child(CreditsScreen.instantiate())
		"quit":
			await $button_press_fx.finished
			get_tree().quit()
		"resume":
			$PauseScreen.queue_free()
			get_tree().paused = false
		"quit to menu":
			# delete eithe the pause screen or the score screen (whichever sent the button press)
			for screen in get_tree().get_nodes_in_group("screen"):
				# technically there should only be one screen (making the loop redundant) 
				# but I don't know what the more elegant solution is
				screen.queue_free()
			get_tree().paused = false
			kill.emit()
			add_child(StartScreen.instantiate())
			pass
		"back":
			$CreditsScreen.queue_free()
			add_child(StartScreen.instantiate())
