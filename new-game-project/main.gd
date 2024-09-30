extends Node

@export var Asteroid : PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Starts the game
func new_game():
	score = 0
	$StartTimer.start()

# Ends the game
func game_over():
	$ScoreTimer.stop()
	$AsteroidTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Adds one to the score
func _on_score_timer_timeout():
	score += 1

# Begins the score timer and asteroid spawn timer 
func _on_start_timer_timeout():
	print("Starting...")
	$AsteroidTimer.start()
	$ScoreTimer.start()

# Spawns an asteroid object
func _on_asteroid_timer_timeout():
	print("Spawning asteroid...")
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
