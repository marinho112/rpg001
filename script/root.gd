extends Node2D



var pausado = false

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_just_pressed("botao_pausa"):
		pausado = !pausado
		get_tree().paused=pausado
