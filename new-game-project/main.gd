extends Node

@export var Asteroid : PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

func new_game():
	score = 0
	$StartTimer.start()

func game_over():
	$ScoreTimer.stop()
	$AsteroidTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_score_timer_timeout():
	score += 1
	
func _on_start_timer_timeout():
	print("Starting...")
	$AsteroidTimer.start()
	$ScoreTimer.start()

func _on_asteroid_timer_timeout():
	print("Spawning asteroid...")
	var asteroid = Asteroid.instantiate()
	var spawnLocation = $AsteroidPath/AsteroidSpawnLocation
	spawnLocation.progress_ratio = randf()
	
	var direction = spawnLocation.rotation + PI / 2
	asteroid.position = spawnLocation.position
	
	direction += randf_range(-PI / 4, PI / 4)
	asteroid.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	add_child(asteroid)
