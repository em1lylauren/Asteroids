extends Area2D

var speed = 750

@onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer := Timer.new()
	add_child(timer)
	
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", despawnBullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position -= transform.y * speed * delta
	

# Despawns the bullet if out of frame to save resources
func despawnBullet():		
	owner.remove_child($".")
