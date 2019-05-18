extends Area2D

export var speed=150
var velocity=Vector2()

func _ready():
	set_process(true)
	#set the velocity to the mouse position normalized times the speed so it will travel towards the mouse with the speed var
	var aimDir=get_global_mouse_position() - global_position
	var aimDirNorm=aimDir.normalized()
	velocity=aimDirNorm * speed
	pass
	
func _process(delta):	
	translate(velocity * delta)
	pass


func _on_VisibilityNotifier2D_screen_exited(): #remove bullet
	queue_free()
	pass


func _on_Bullet_body_entered(body):
	if body.is_in_group("Asteroids") or body.is_in_group("Asteroids_Child"):
		body.breakApart() #asteroid break apart function
		queue_free() #remove bullet that hit
	pass # Replace with function body.
