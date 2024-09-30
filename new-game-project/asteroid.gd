extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AsteroidSprite.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.gameOver:
		queue_free()

# When an asteroid collides with something
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		#print("Collided with player - asteroid")
		
		# Give the player some i-frames so they don't instantly lose all health
		if $InvincibilityFrameTimer.is_stopped():
			$InvincibilityFrameTimer.start()
			body.takeDamage()

func _on_despawn_timer_timeout() -> void:
	queue_free()
