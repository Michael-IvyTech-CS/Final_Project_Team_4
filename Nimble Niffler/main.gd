extends Node2D

@export var World: PackedScene
@export var Enemy: PackedScene
@export var Player: PackedScene

@export var number_of_enemies: int = 10

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect signals from child nodes
	$CanvasLayer/UI.start.connect(self._on_start)
	$CanvasLayer/UI.kill.connect(self._on_kill)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_enemies():
	pass


func _on_kill():
	# RESET FROM PREVIOUS INSTANCE
	
	# delete everything from previous game
	for entity in get_tree().get_nodes_in_group("gameplay"):
		entity.queue_free()
	
	# reset score
	score = 0

func _on_start():
	# INITIALIZE NEW GAME
	
	# initialize world map
	add_child(World.instantiate())
	
	# initialize enemies
	add_child(Enemy.instantiate())
	
	# initialize player
	add_child(Player.instantiate())
