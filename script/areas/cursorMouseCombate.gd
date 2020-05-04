extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	add_to_group(Constantes.GRUPO_CURSOR_MOUSE)
	pass # Replace with function body.


func _process(delta):
	var mousePosition = get_viewport().get_mouse_position()
	set_global_position(mousePosition)
