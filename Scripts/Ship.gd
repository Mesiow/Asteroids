extends KinematicBody2D

export var acceleration=Vector2()
export var velocity=Vector2()
var speed=50
var okToFire=true

const Bullet=preload("res://Scenes/Bullet.tscn")

func _ready():
	set_process(true)
	set_process_input(true)
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
	pass

func _on_ShootTimer_timeout():
	okToFire=true
	pass 
	
func processCollision():
	#var bullets = get_groups().find("Bullets")
	var asteroids=get_groups().find("Asteroids")
	
	pass
	

