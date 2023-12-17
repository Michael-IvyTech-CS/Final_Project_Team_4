extends Node2D

@export var World: PackedScene
@export var Enemy: PackedScene
@export var Player: PackedScene

@export var number_of_enemies: int = 20

@export var minimum_spawn_distance: int = 10 * 16  # number of tiles * tile size
@export var max_spawn_distance: int = 30  * 16

const BORDER_UPPER_LEFT_CORNER: Vector2 = Vector2(-90, -59)
const BORDER_LOWER_RIGHT_CORNER: Vector2 = Vector2(80, 64)

var score: int = 0
var enemies_killed: int = 0
var player_is_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect signals from child nodes
	$CanvasLayer/UI.start.connect(self._on_start)
	$CanvasLayer/UI.kill.connect(self._on_kill)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_is_dead:
		# tell the player that they lost
		$CanvasLayer/UI.display_score(score, false)
	elif (enemies_killed == number_of_enemies) and (get_tree().get_nodes_in_group("screen").size() == 0):
		# tell the player that they won
		$CanvasLayer/UI.display_score(score, true)


func spawn_enemies():
	randomize()  # reset rng seed
	$pivot/spawner.position.x = minimum_spawn_distance
	for i in range(0, number_of_enemies):
		# randomly rotating the pivot point
		$pivot.rotation_degrees = randi() % 360
		# choose a random distance from the pivot point
		$pivot/spawner.position.x += randi() % (max_spawn_distance - minimum_spawn_distance)
		# spawn an enemy at the location of the spawners
		var new_enemy = Enemy.instantiate()
		add_child(new_enemy)
		new_enemy.position = $pivot/spawner.global_position
		$pivot/spawner.position.x = minimum_spawn_distance


func _on_kill():
	# RESET FROM PREVIOUS INSTANCE
	
	# delete everything from previous game
	for entity in get_tree().get_nodes_in_group("gameplay"):
		entity.queue_free()
	
	# reset score and kill count
	score = 0
	enemies_killed = 0
	player_is_dead = false

func _on_start():
	# INITIALIZE NEW GAME
	
	# initialize world map
	add_child(World.instantiate())
	
	# initialize enemies
	spawn_enemies()
	
	# initialize player
	var new_player = Player.instantiate()
	add_child(new_player)
	# connect player signals
	new_player.player_death.connect(self._on_player_death)
	new_player.enemy_death.connect(self._on_enemy_death)


func _on_player_death():
	player_is_dead = true


func _on_enemy_death():
	score += 50
	enemies_killed += 1
