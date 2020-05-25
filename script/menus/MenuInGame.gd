extends Node2D

var listaInfoPersonagem = []
var preInfoPersonagem = preload("res://nodes/menus/MenuInGameInfoPersonagem.tscn")
var preOpcoes = preload("res://nodes/menus/MenuInGameOpcoes.tscn")
var areaSecundaria
var areaPrincipal

func _ready():
	atualizaPersonagens()

func limparPersonagens():
	var lista = $AreaPrincipal.get_children()
	for elemento in lista :
		elemento.queue_free()
	
	listaInfoPersonagem= []
		
func atualizaPersonagens():
	
	limparPersonagens()
	
	for i in len(VariaveisGlobais.listaPersonagens):
		var item = VariaveisGlobais.listaPersonagens[i]
		var novo = preInfoPersonagem.instance()
		#ROMOVER linha com recuperaTudo 
		item.recuperaTudo(2)
		novo.personagem=item
		var novoPosicao = Vector2(0,-190 + (i*80))
		novo.set_global_position(novoPosicao)
		$AreaPrincipal.add_child(novo)
		listaInfoPersonagem.append(novo)

func atualizaAreaPrincipal(area):
	var lista = $AreaPrincipal.get_children()
	
	for elemento in lista :
		elemento.queue_free()
	
	$AreaPrincipal.add_child(area)
	areaPrincipal = area
	
func atualizaAreaSecundaria(area):
	var lista = $AreaSecundaria.get_children()
	
	for elemento in lista :
		elemento.queue_free()
	
	$AreaSecundaria.add_child(area)
	areaSecundaria = area
