extends RigidBody2D


export var velocity=Vector2()
var rot
var destroyAsteroidScale=Vector2(0.1, 0.1)

signal breakAsteroid(asteroidHit)

func _ready():
	set_process(true)
	#connect the break asteroid signal to the world node with the callback function break_Asteroid_Received
	var worldNode=get_tree().get_root().get_node("/root/World") 
	self.connect("breakAsteroid", worldNode, "break_Asteroid_Received")
	pass
	
func _process(delta):
	#check x
	if global_position.x > get_viewport_rect().size.x + 60: #if we go off the side on the right loop back to the other side
		global_position=Vector2(-59, global_position.y)
	elif global_position.x < -60:
		global_position=Vector2(get_viewport_rect().size.x + 59, global_position.y)
	
	#check y
	if global_position.y > get_viewport_rect().size.y + 60:
		global_position=Vector2(global_position.x, -59)
	elif global_position.y < -60:
		global_position=Vector2(global_position.x, get_viewport_rect().size.y + 59)
		

	
	translate(velocity * delta)
	rotate(rot)
	pass
	
func spawn():
	randomize()
	global_position=getRandomPos()
	
	#get random rotation value
	rot=getRandomRotation()
	
	#random velocity
	velocity=getRandomVel()
	
	add_to_group("Asteroids") #add to the group
	pass
	
func spawnBrokenBits(pos):
	randomize()
	global_position=pos
	
	rot=getRandomRotation()
	
	velocity=getRandomVel()
	
	scale=Vector2(scale.x - 0.3, scale.y - 0.3)
	
	add_to_group("Asteroids_Child")
	pass

func _on_Asteroid_body_entered(body):
	if body.is_in_group("Ship"):
		body.queue_free() #destroy ship
	pass 


func breakApart():
	var asteroidHit=self
	emit_signal("breakAsteroid", asteroidHit)
	scale = Vector2(scale.x - 0.2, scale.y - 0.2)
	
	if scale < destroyAsteroidScale:#destroy the asteroid because it became too small
		queue_free() 
		return
	
	rot=getRandomRotation()
	pass
	
func getRandomRotation():
	var r=rand_range(-0.1, 0.1)
	return r
	pass
	
func getRandomVel():
	var randX=rand_range(1, 100)
	var randY=rand_range(1, 100)
	return Vector2(randX, randY)
	pass
	
func getRandomPos():
	var randPosX=rand_range(0, get_viewport_rect().size.x)
	var randPosY=rand_range(0, get_viewport_rect().size.y)
	return Vector2(randPosX, randPosY)
	pass