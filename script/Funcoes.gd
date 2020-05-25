extends Node



func _ready():
	pass # Replace with function body.

func na_area(objeto,collision):
	var posicao = objeto.get_global_position()
	var tamanho = collision.get_shape().get_extents()
	var mousePosicao = objeto.get_global_mouse_position()
	var retorno =((mousePosicao.x < (posicao.x+tamanho.x))and(mousePosicao.x > (posicao.x-tamanho.x)))
	retorno = (retorno and ((mousePosicao.y < (posicao.y+tamanho.y)) and (mousePosicao.y > (posicao.y-tamanho.y))))
	return retorno
