extends RigidBody2D


export var velocity=Vector2()
var rot
var scaleToDestroy=Vector2(0.3, 0.3)

const Explosion=preload("res://Scenes/Explosion.tscn")

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
	#get random rotation value
	rot=getRandomRotation()
	
	#random velocity
	velocity=getRandomVel()
	add_to_group("Asteroids") #add to the group
	pass
	
func spawnAsteroid(pos, size):
	global_position=pos
	global_scale = size * 0.5
	
	#get random rotation value
	rot=getRandomRotation()
	
	#random velocity
	velocity=getRandomVel()
	
	add_to_group("Asteroids")
	pass


func _on_Asteroid_body_entered(body):
	pass 


func breakApart():
	var worldNode=get_tree().get_root().get_node("/root/World")
	var HUDNode=worldNode.HUD
	HUDNode.get_node("Score").score+=20
	
	#emit particles
	var explosion=Explosion.instance()
	explosion.spawn(global_position)
	worldNode.add_child(explosion)
	
	var asteroidHit=self
	if scale <= scaleToDestroy:
		print("deleted")
		queue_free() #delete tiny asteroids
		return
		
	emit_signal("breakAsteroid", asteroidHit) #emit signal
	queue_free() #delete main asteroid
	pass
	
func getRandomRotation():
	randomize()
	return rand_range(-0.1, 0.1)
	pass
	
func getRandomVel():
	randomize()
	return Vector2(rand_range(1, 100), rand_range(1, 100))
	pass
	
func getRandomPos():
	randomize()
	return Vector2(rand_range(0, get_viewport_rect().size.x), rand_range(0, get_viewport_rect().size.y))
	pass
