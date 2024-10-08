extends CharacterBody2D

@export var Bullet : PackedScene = preload("res://bullet.tscn")

var speed = 75
var rotationSpeed = 1
var rotationDirection = 0

var rotateDecay = 0.98 # decay so we aren't rotating forever
var moveDecay = 0.996 

@onready var screenSize = get_viewport_rect().size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerSprite.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !Globals.gameOver:
		get_input()
		
		if Globals.health <= 0:
			die()

	rotation += rotationDirection  * rotationSpeed * delta
	rotationDirection *= rotateDecay
	velocity *= moveDecay
	
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() is RigidBody2D:
			#print("Asteroid Collision")
			
			# Give the player some i-frames so they don't instantly lose all health
			if $"../InvincibilityFrameTimer".is_stopped():
				$"../InvincibilityFrameTimer".start()
				takeDamage()
		
	screenWrap()
	updateHealth()
	showScore()
	


# Gets input from the user
func get_input():
	# go back to idle animation when not doing any other animation
	if (!$PlayerSprite.is_playing()):
		$PlayerSprite.play("Idle")
		
	# rotate ship
	if Input.is_key_pressed(KEY_LEFT):
		rotationDirection = -2.5
		if !Input.is_key_pressed(KEY_SPACE) :
			$PlayerSprite.play("RotateLeft")
		
	if Input.is_key_pressed(KEY_RIGHT):
		rotationDirection = 2.5
		if !Input.is_key_pressed(KEY_SPACE) :
			$PlayerSprite.play("RotateRight")

	# space bar pressed
	if Input.is_action_just_pressed("ui_select"):
		$PlayerSprite.play("Shoot")
		
		# spawn bullet
		shoot()
		
		if cos(rotation) > 90:
			velocity -= transform.y * speed
		else:
			velocity += transform.y * speed


# Checks if user OOB and wraps them around to the other end of the screen
func screenWrap():
	# horizontal wrap
	if position.x > screenSize.x:
		$PlayerSprite.play("Warp")
		position.x = 0
	if position.x < 0:
		$PlayerSprite.play("Warp")
		position.x = screenSize.x

	# vertical wrap
	if position.y > screenSize.y:
		$PlayerSprite.play("Warp")
		position.y = 0
	if position.y < 0:
		$PlayerSprite.play("Warp")
		position.y = screenSize.y


# Takes 1 heart from the player
func takeDamage():
	$DamageParticles.emitting = true
	$PlayerSprite.play("Hit")
	$HitSound.play()
	Globals.health -= 1


# Spawns a new bullet object
func shoot():
	$ShootSound.play()
	
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.transform = $BulletSpawnMarker.global_transform


# Updates the health bar
func updateHealth():
	if Globals.health == 3:
		$"../CanvasLayer/Hearts".play("Hearts_3")
	elif Globals.health == 2:
		$"../CanvasLayer/Hearts".play("Hearts_2")
	elif Globals.health == 1:
		$"../CanvasLayer/Hearts".play("Hearts_1")
		$DamageParticles.scale_amount_max = 5
	else:
		$"../CanvasLayer/Hearts".play("Hearts_0")
		$DamageParticles.scale_amount_max = 8


# Updates the player's score
func showScore():
	$"../CanvasLayer/ScoreUI".text = str("SCORE : ", Globals.SCORE)


# Plays the death animation and ends the game
func die():
	$PlayerSprite.play("Die")
	Globals.gameOver = true
	
