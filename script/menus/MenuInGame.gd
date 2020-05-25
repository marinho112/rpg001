extends Node2D

var listaInfoPersonagem = []
var preInfoPersonagem = preload("res://nodes/menus/MenuInGameInfoPersonagem.tscn")

func _ready():
	atualizaPersonagens()

func limparPersonagens():
	for item in listaInfoPersonagem:
		item.queue_free()
		listaInfoPersonagem= []
		
func atualizaPersonagens():
	
	limparPersonagens()
	
	for i in len(VariaveisGlobais.listaPersonagens):
		var item = VariaveisGlobais.listaPersonagens[i]
		var novo = preInfoPersonagem.instance()
		#ROMOVER linha com recuperaTudo 
		item.recuperaTudo(2)
		novo.personagem=item
		var novoPosicao = Vector2(-165,-190 + (i*80))
		novo.set_global_position(novoPosicao)
		add_child(novo)
		listaInfoPersonagem.append(novo)

