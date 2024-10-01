extends RigidBody2D

@onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AsteroidSprite.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.gameOver:
		queue_free()
	
	if $AsterioidOOBTimer.is_stopped():
		$AsterioidOOBTimer.start()

# When an asteroid collides with something
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		#print("Collided with player - asteroid")
		
		# Give the player some i-frames so they don't instantly lose all health
		if $InvincibilityFrameTimer.is_stopped():
			$InvincibilityFrameTimer.start()
			body.takeDamage()

# Be destroyed 
func beDestroyed():
	$AsteroidSprite.play("Destroyed")
	$AsteroidCollision2D.set_deferred("disabled", true)     
	$DespawnTimer.start()
	
	# Spawn 2 children asteroids if above a certain size threshold
	if self.get_child(0).scale >= Vector2(1.5, 1.5):
		get_node("../../Main").spawnChildAsteroids(self)

# Despawns self
func _on_despawn_timer_timeout() -> void:
	queue_free()

# Despawns if out of bounds
func _on_asterioid_oob_timer_timeout() -> void:
	if position.x > screenSize.x || position.x < 0:
		#print("Despawned")
		queue_free.call_deferred()
		
	if position.y > screenSize.y || position.y < 0:
		#print("Despawned") 
		queue_free.call_deferred()
