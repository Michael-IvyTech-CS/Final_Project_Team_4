extends CharacterBody2D

@export var SPEED: float = 25.0  # position change per 60th of a second (how fast this entity moves)

var direction_of_player: Vector2 = Vector2.ZERO
var player: Node2D  # variable representing the player to follow/target
var collision: KinematicCollision2D  # variable representing a collision with another object
var idle_animation: String  # stores the name of the idle animation associated with the current movement direction

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("gameplay")
	add_to_group("enemies")
	randomize()  # scramble psuedo random seed
	match (randi() % 4):  # randomly select a starting facing direction
		0:
			idle_animation = "idle_down"
		1:
			idle_animation = "idle_left"
		2:
			idle_animation = "idle_up"
		3: 
			idle_animation = "idle_right"

# this is called about every 60th of a second
func _physics_process(delta):
	
	# MOVEMENT AND AI
	
	# The 2s and 3s represent the slopes of imaginary lines drawn from the enemy that, when crossed, 
	# cause the enemy to change direction.  These slopes (2/3, 3/2, etc) were chosen to create a 'dead zone' which 
	# prevents the enemy from rapidly flipping between animations when aproaching from the diagonal.
	if player:  # make sure there is actually a player to follow
		direction_of_player = position.direction_to(player.position)
		# Use the direction_of_player vector to determine the enemy movement direction and animation.
		if ((2 * direction_of_player.x) > (-3 * direction_of_player.y)) and ((2 * direction_of_player.x) > (3 * direction_of_player.y)):  # //
			velocity = Vector2(1.0, 0.0)  
			# enemy does not have diagonal movement animations, so movement is restricted to horizontal/vertical axes
			$AnimationPlayer.play("move_right")
			idle_animation = "idle_right"  # set the idle animation for when the player leaves the radius or collides
		elif ((2 * direction_of_player.x) < (-3 * direction_of_player.y)) and ((2 * direction_of_player.x) < (3 * direction_of_player.y)):
			velocity = Vector2(-1.0, 0.0)
			$AnimationPlayer.play("move_left")
			idle_animation = "idle_left"
		elif ((3 * direction_of_player.x) < (-2 * direction_of_player.y)) and ((3 * direction_of_player.x) > (2 * direction_of_player.y)):
			velocity = Vector2(0.0, -1.0)
			$AnimationPlayer.play("move_up")
			idle_animation = "idle_up"
		elif ((3 * direction_of_player.x) > (-2 * direction_of_player.y)) and ((3 * direction_of_player.x) < (2 * direction_of_player.y)):
			velocity = Vector2(0.0, 1.0)
			$AnimationPlayer.play("move_down")
			idle_animation = "idle_down"
	else:  # if no player has been detected, idle in the direction it last moved in
		$AnimationPlayer.play(idle_animation)
		velocity = Vector2.ZERO

	velocity = velocity.normalized()
	velocity *= SPEED
	move_and_slide()


# triggers when the player enters the detection area
func _on_detection_area_body_entered(body):
	player = body  # identify the player entity so they can be followed
	
	# set initial movement direction (otherwise enemy will have blindspots on the diagonals)
	direction_of_player = position.direction_to(player.position)
	if direction_of_player.x > direction_of_player.y:
		if direction_of_player.x > -direction_of_player.y:
			velocity = Vector2(1.0, 0.0)
			$AnimationPlayer.play("move_right")
			idle_animation = "idle_right"
		else:
			velocity = Vector2(0.0, -1.0)
			$AnimationPlayer.play("move_up")
			idle_animation = "idle_up"
	else:
		if direction_of_player.x < -direction_of_player.y:
			velocity = Vector2(-1.0, 0.0)
			$AnimationPlayer.play("move_left")
			idle_animation = "idle_left"
		else:
			velocity = Vector2(0.0, 1.0)
			$AnimationPlayer.play("move_down")
			idle_animation = "idle_down"

# triggers when the player leaves the detection area
func _on_detection_area_body_exited(body):
	player = null  # disable following/targeting of the player
