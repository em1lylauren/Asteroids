extends CharacterBody2D

@export var Bullet : PackedScene = preload("res://bullet.tscn")

var speed = 75
var rotationSpeed = 1
var rotationDirection = 0

var rotateDecay = 0.98 # decay so we aren't rotating forever
var moveDecay = 0.995 

@onready var screenSize = get_viewport_rect().size
@onready var health = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerSprite.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_input()
	rotation += rotationDirection  * rotationSpeed * delta
	rotationDirection *= rotateDecay
	velocity *= moveDecay
	
	var collision = move_and_collide(velocity * delta, false, 1)
	if collision:
		print("Collision - player")
		#velocity = velocity.reflect(collision.get_normal())
		velocity = velocity.slide(collision.get_normal())
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
	health -= 1


# Spawns a new bullet object
func shoot():
	$ShootSound.play()
	
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.transform = $BulletSpawnMarker.global_transform


func updateHealth():
	if health == 3:
		$"../CanvasLayer/Hearts".play("Hearts_3")
	elif health == 2:
		$"../CanvasLayer/Hearts".play("Hearts_2")
	elif health == 1:
		$"../CanvasLayer/Hearts".play("Hearts_1")
		$DamageParticles.scale_amount_max = 5
	else:
		$"../CanvasLayer/Hearts".play("Hearts_0")

func showScore():
	$"../CanvasLayer/ScoreUI".text = str("SCORE : ", Globals.SCORE)
