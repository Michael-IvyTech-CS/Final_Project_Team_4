extends CharacterBody2D


const speed = 100
var  current_direction = "down"
var attack_range = false
var current_attack = false
var attack_in_progress = false


func _ready():
	$AnimatedSprite2D.play("front_idle")
	
	
func _physics_process(delta):
	player_movement()
	attack()
	
	
func player_movement():
	
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_animation(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	
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
	
	if Input.is_action_just_pressed("attack"):
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
			
			
func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		attack_range = true
		
		
func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		attack_range = false
		
		
func _on_attacking_cooldown_timeout():
	$attacking_cooldown.stop()
	current_attack = false
	attack_in_progress = false
	
	
