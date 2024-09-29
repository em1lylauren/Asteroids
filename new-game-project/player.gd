extends CharacterBody2D

@export var AnimatedSprite : AnimatedSprite2D

var speed = 10
var rotationSpeed = 1
var rotationDirection = 0

@onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerSprite.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_input()
	rotation += rotationDirection  * rotationSpeed * delta
	move_and_slide()
	screenWrap()


func get_input():
	if Input.is_action_just_released("ui_select") || Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right"):
		$PlayerSprite.play("Idle")
		
	if Input.is_key_pressed(KEY_LEFT):
		rotationDirection -= 1
		if !Input.is_key_pressed(KEY_SPACE) :
			$PlayerSprite.play("RotateLeft")
		
	if Input.is_key_pressed(KEY_RIGHT):
		rotationDirection += 1
		if !Input.is_key_pressed(KEY_SPACE) :
			$PlayerSprite.play("RotateRight")
		
	if Input.is_key_pressed(KEY_SPACE):
		$PlayerSprite.play("Shoot")
		if rotationDirection > 0:
			velocity -= transform.y * speed
		else:
			velocity += transform.y * speed
		
	
func screenWrap():
	# horizontal wrap
	if position.x > screenSize.x:
		position.x = 0
	if position.x < 0:
		position.x = screenSize.x
		
	# vertical wrap
	if position.y > screenSize.y:
		position.y = 0
	if position.y < 0:
		position.y = screenSize.y
	
