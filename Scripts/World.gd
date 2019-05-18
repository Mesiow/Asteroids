extends Node

const Asteroid=preload("res://Scenes/Asteroid.tscn")

func _ready():
		
	for i in range(1):
		var ast=Asteroid.instance()
		ast.spawn()
		add_child(ast)

	pass
	

func break_Asteroid_Received(asteroidHit):
	print("break asteroid signal received")
	
	#for i in range(1): 
	var ast=Asteroid.instance()
	var position=asteroidHit.global_position #spawn broken pieces at the asteroid we hit
	ast.spawnBrokenBits(position)
	call_deferred("add_child", ast) #stops game from freezing when adding new asteroids to the scene
	pass
