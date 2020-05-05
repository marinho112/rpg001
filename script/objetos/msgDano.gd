extends Node2D

var vel= 100



# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	var position = get_global_position()
	position.y -= delta*vel
	set_global_position(position)
	pass


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
