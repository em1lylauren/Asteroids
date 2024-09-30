extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AsteroidSprite.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# When an asteroid collides with something
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		print("Collided with player - asteroid")

func _on_despawn_timer_timeout() -> void:
	queue_free()
