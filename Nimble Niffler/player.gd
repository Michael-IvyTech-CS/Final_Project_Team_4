extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true


const speed = 100
var  current_direction = "down"
var attack_range = false
var current_attack = false
var attack_in_progress = false


func _ready():
	add_to_group("gameplay")
	add_to_group("player")
	$AnimatedSprite2D.play("front_idle")
	
	
func _physics_process(delta):
	player_movement()
	attack()
	enemy_attack()
	
	if health <= 0:
		player_alive = false #add end screen / respawn / menu
		health = 0
		print("Player has died")
		self.queue_free
	
	
func player_movement():
	# set player character animation and movement direction based on user input
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		velocity.x = 1
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		velocity.x = -1
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_animation(1)
		velocity.y = 1
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)
		velocity.y = -1
		velocity.x = 0
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	
	# multiply velocity by speed
	velocity *= speed
	move_and_slide()
	
	
func play_animation(movement):
	var direction = current_direction
	var animation = $AnimatedSprite2D
	
	if direction == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("side_idle")
	if direction == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("side_idle")
	
	if direction == "down":
		animation.flip_h = false
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("front_idle")
	if direction == "up":
		animation.flip_h = false
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("back_idle")
	
	
func attack():
	var direction = current_direction
	
	if Input.is_action_just_pressed("ui_accept"):
		current_attack = true
		attack_in_progress = true
		if direction == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$attacking_cooldown.start()
		if direction == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$attacking_cooldown.start()
		if direction == "down":
			$AnimatedSprite2D.play("front_attack")
			$attacking_cooldown.start()
		if direction == "up":
			$AnimatedSprite2D.play("back_attack")
			$attacking_cooldown.start()
			
func player():
	pass
	
func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true
		
		
func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func _on_attacking_cooldown_timeout():
	$attacking_cooldown.stop()
	current_attack = false
	attack_in_progress = false
	
	
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attacking_cooldown.start()
		print("health")

func _on_attackcooldown_timeout():
	enemy_attack_cooldown = true
