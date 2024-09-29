extends Node2D

@onready var AnimatedSprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_SPACE)):
		$PlayerSprite.play("Shoot")
	else:
		$PlayerSprite.play("Idle")
		
	if (Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A)):
		$PlayerSprite.rotation -= delta
		
	if (Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D)):
		$PlayerSprite.rotation += delta
	pass
