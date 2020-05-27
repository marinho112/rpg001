extends Node2D


var selecionado


func _ready():
	pass # Replace with function body.

func defineSelecionado(para):
	selecionado = para
	print(str(selecionado.nome))
