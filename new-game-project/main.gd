extends Node

@export var Asteroid : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Starts the game
func new_game():
	Globals.SCORE = 0
	Globals.health = 3
	Globals.gameOver = false
	
	# Reset player values
	$Player.get_child(1).position = Vector2(600, 300)
	$Player.get_child(1).velocity = Vector2(0, 0)
	$Player.get_child(1).rotation = 0
	$Player.get_child(1).rotationDirection = 0
	
	# Reset player particle values
	$Player.get_child(1).get_child(5).emitting = false
	$Player.get_child(1).get_child(5).scale_amount_max = 3
	
	$StartTimer.start()

# Ends the game
func game_over():
	$AsteroidTimer.stop()
	$RestartTimer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.gameOver && $RestartTimer.is_stopped():
		game_over()

# Begins the score timer and asteroid spawn timer 
func _on_start_timer_timeout():
	$AsteroidTimer.start()

# Spawns an asteroid object
func _on_asteroid_timer_timeout():
	var asteroid = Asteroid.instantiate()
	
	# Randomize spawn location
	var spawnLocation = $AsteroidPath/AsteroidSpawnLocation
	spawnLocation.progress_ratio = randf()
	asteroid.position = spawnLocation.position
	
	# Randomize direction
	var direction = spawnLocation.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	asteroid.rotation = direction
	
	# Randomize velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	# Randomize size
	var size = randf_range(1.0, 3.5)
	asteroid.get_child(0).scale = Vector2(size, size)

	# Scale the collision mesh
	var polygon = asteroid.get_child(1).polygon
	for i in polygon.size():
		polygon.set(i, polygon[i] * (size * 0.5))
	asteroid.get_child(1).polygon = polygon
	
	add_child(asteroid)

# Breaks an existing asteroid into pieces
func spawnChildAsteroids(parent):
	var asteroid1 = Asteroid.instantiate()
	var asteroid2 = Asteroid.instantiate()
	
	# Give parent spawn location
	asteroid1.position = parent.position
	asteroid2.position = parent.position
	
	# Give parent rotation
	asteroid1.rotation = parent.rotation
	asteroid2.rotation = parent.rotation * -1
	
	# Give random velocity
	var direction = parent.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	var velocity = Vector2(randf_range(100.0, 150.0), 0.0)
	asteroid1.linear_velocity = velocity.rotated(direction)
	asteroid2.linear_velocity = velocity.rotated(direction * -1)
	
	# Randomize size
	var size = parent.get_child(0).scale / 2
	asteroid1.get_child(0).scale = size
	asteroid2.get_child(0).scale = size

	# Scale the collision mesh
	var polygon = asteroid1.get_child(1).polygon
	for i in polygon.size():
		polygon.set(i, polygon[i] * (size * 0.5))
	asteroid1.get_child(1).polygon = polygon
	
	polygon = asteroid2.get_child(1).polygon
	for i in polygon.size():
		polygon.set(i, polygon[i] * (size * 0.5))
	asteroid2.get_child(1).polygon = polygon
	
	add_child.call_deferred(asteroid1)
	add_child.call_deferred(asteroid2)


func _on_restart_timer_timeout() -> void:
	print("Restarting")
	new_game()
