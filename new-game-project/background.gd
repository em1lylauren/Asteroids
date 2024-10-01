extends CanvasLayer

var direction = 1
var rotateDirection = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timerTransform := Timer.new()
	add_child(timerTransform)
	
	timerTransform.wait_time = 3.5
	timerTransform.one_shot = false
	timerTransform.start()
	timerTransform.connect("timeout", swapDirection)
	
	var timerRotate := Timer.new()
	add_child(timerRotate)
	
	timerRotate.wait_time = 5.5
	timerRotate.one_shot = false
	timerRotate.start()
	timerRotate.connect("timeout", swapRotate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	movePlanetY($Planet1, delta, 3)
	movePlanetY($Planet2, delta, 1)
	movePlanetX($Planet3, delta, 2)


func movePlanetY(planet: Sprite2D, delta: float, speed: float):
	planet.position += planet.transform.y * speed * delta * direction
	planet.rotation += 0.05 * delta * rotateDirection


func movePlanetX(planet: Sprite2D, delta: float, speed: float):
	planet.position += planet.transform.x * speed * delta * direction
	planet.rotation += 0.05 * delta * rotateDirection


func swapDirection():
	direction *= -1


func swapRotate():
	rotateDirection *= -1
	


func _on_invincibility_frame_timer_timeout() -> void:
	#print("I-frame timer done")
	pass
