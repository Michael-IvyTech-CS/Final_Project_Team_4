extends CharacterBody2D

const SPEED: float = 50.0  # position change per 60th of a second (how fast this entity moves)

var direction_of_player: Vector2 = Vector2.ZERO
var player: Node2D  # variable representing the player to follow/target
var collision: KinematicCollision2D  # variable representing a collision with another object

# this is called about every 60th of a second
func _physics_process(delta):
	for object in get_slide_collision_count():
		collision = get_slide_collision(object)
		if collision.get_collider().name == 'player':
			pass
	# Get the player direction and handle the movement/deceleration.
	if player and (position.distance_to(player.position) != 0):
		direction_of_player = position.direction_to(player.position)
		velocity.x = direction_of_player.x * SPEED
		velocity.y = direction_of_player.y * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()


# triggers when the player enters the detection area
func _on_detection_area_body_entered(body):
	player = body  # identify the player entity so they can be followed

# triggers when the player leaves the detection area
func _on_detection_area_body_exited(body):
	player = null  # disable following/targeting of the player
