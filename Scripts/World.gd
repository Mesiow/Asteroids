extends Node

var HUD setget, getHUD

const Asteroid=preload("res://Scenes/Asteroid.tscn")

func _ready():
	spawnAsteroid()
	$AsteroidSpawnTimer.start()
	pass


func _on_AsteroidSpawnTimer_timeout():
	#spawn some new asteroids
	spawnAsteroid()
	pass
	
func spawnAsteroid():
	randomize()
	var ast=Asteroid.instance()

	#choose a random location on the Path2D
	$AsteroidSpawnPath/PathFollow2D.set_offset(randi())
	
	#set the asteroid direction perpendicular to the path direction
	var dir=$AsteroidSpawnPath/PathFollow2D.rotation + PI / 2
	
	#set asteroid position to a random location on the path
	ast.position=$AsteroidSpawnPath/PathFollow2D.position
	
	ast.spawn()
	call_deferred("add_child", ast)
	pass
	
	

func break_Asteroid_Received(asteroidHit):
	print("break asteroid signal received")
	
	if asteroidHit.scale <= asteroidHit.scaleToDestroy:
		asteroidHit.queue_free()
		return

	var newAsteroids = []
	newAsteroids.resize(2)
	newAsteroids[0]=Asteroid.instance()
	newAsteroids[1]=Asteroid.instance() #create 2 new asteroids
	
	newAsteroids[0].spawnAsteroid(asteroidHit.global_position, asteroidHit.scale)
	newAsteroids[1].spawnAsteroid(asteroidHit.global_position, asteroidHit.scale) #spawn new asteroid bits on the asteroid the player shot
	
	call_deferred("add_child", newAsteroids[0]) #stops game from freezing when adding new asteroids to the scene
	call_deferred("add_child", newAsteroids[1])
	pass
	
func getHUD():
	return $HUD
	pass