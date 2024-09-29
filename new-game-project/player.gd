extends Node2D

@onready var AnimatedSprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerSprite.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_released("ui_select") || Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right")):
		$PlayerSprite.play("Idle")
		
	if (Input.is_key_pressed(KEY_LEFT)):
		$PlayerSprite.rotation -= delta
		if (!Input.is_key_pressed(KEY_SPACE)) :
			$PlayerSprite.play("RotateLeft")
		
	if (Input.is_key_pressed(KEY_RIGHT)):
		$PlayerSprite.rotation += delta
		if (!Input.is_key_pressed(KEY_SPACE)) :
			$PlayerSprite.play("RotateRight")
		
	if (Input.is_key_pressed(KEY_SPACE)):
		$PlayerSprite.play("Shoot")
