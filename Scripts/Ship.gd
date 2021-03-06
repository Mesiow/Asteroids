extends Area2D

export var acceleration=Vector2()
export var velocity=Vector2()
var speed=50
var okToFire=true
signal died

const Crosshair=preload("res://Scenes/Crosshair.tscn")
const Bullet=preload("res://Scenes/Bullet.tscn")
const Explosion=preload("res://Scenes/Explosion.tscn")

func _ready():
	set_process(true)
	set_process_input(true)
	
	var worldNode=get_tree().get_root().get_node("/root/World")
	self.connect("died", worldNode, "player_Died_Received")
	
	var crossHair=Crosshair.instance()
	add_child(crossHair) #so it does not rotate with the ship
	add_to_group("Ship")
	pass 

func _process(delta):
	look_at(get_global_mouse_position()) #ship looks towards mouse
	
	#check x
	if global_position.x > get_viewport_rect().size.x: #if we go off the side on the right loop back to the other side
		global_position=Vector2(0, global_position.y)
	elif global_position.x < 0:
		global_position=Vector2(get_viewport_rect().size.x, global_position.y)
	
	#check y
	if global_position.y > get_viewport_rect().size.y:
		global_position=Vector2(global_position.x, 0)
	elif global_position.y < 0:
		global_position=Vector2(global_position.x, get_viewport_rect().size.y)

	translate(velocity * delta)
	pass

func _input(event):
	
	if InputEventMouseButton && Input.is_action_pressed("LeftMouse"):
		if okToFire:
			shoot()
			okToFire=false
	
	if Input.is_action_pressed("Up"):
		acceleration.y-=0.5
		velocity.y=-speed * -acceleration.y
	if Input.is_action_pressed("Down"):
		acceleration.y+=0.5
		velocity.y=speed * acceleration.y
	if Input.is_action_pressed("Left"):
		acceleration.x-=0.5
		velocity.x=-speed * -acceleration.x
	if Input.is_action_pressed("Right"):
		acceleration.x+=0.5
		velocity.x=speed * acceleration.x
	
	pass
	
func shoot():
	$ShootTimer.start()
	var bullet=Bullet.instance()
	bullet.global_position=$Muzzle.global_position
	get_tree().get_root().add_child(bullet)
	add_to_group("Bullets")
	$ShipLaser.play()
	pass

func _on_ShootTimer_timeout():
	okToFire=true
	pass 
	

func _on_Ship_body_entered(body):
	if body.is_in_group("Asteroids"):
		emit_signal("died")
		
		var worldNode=get_tree().get_root().get_node("/root/World")
		var explosion=Explosion.instance()
		explosion.spawn(global_position)
		worldNode.add_child(explosion)
		queue_free() #if we hit an asteroid
	pass
