extends Node2D

var listaInfoPersonagem = []
var preInfoPersonagem = preload("res://nodes/menus/MenuInGameInfoPersonagem.tscn")
var preOpcoes = preload("res://nodes/menus/MenuInGameOpcoes.tscn")
var areaSecundaria
var areaPrincipal
var proximaArea
var selecionaPersonagem = false
var posicao =0
var vibracaoCursor= 0
var adicaoCursor = 70

func _ready():
	atualizaPersonagens()
	atualizaAreaSecundaria(preOpcoes.instance())
	set_process(true)

func _process(delta):
	if selecionaPersonagem:
		$cursor.set_visible(true)
		selecaoPersonagem()
		desenhaCursor(delta)
	else:
		$cursor.set_visible(false)	

func descerCursor():
	if(posicao < len(listaInfoPersonagem)-1):
		posicao+=1
	
func subirCursor():
	if(posicao>0):
		posicao -= 1

func selecionaCursor():
	selecionaPersonagem = false
	proximaArea.defineSelecionado(listaInfoPersonagem[posicao].personagem)
	atualizaAreaPrincipal(proximaArea)
	
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
		novo.definePersonagem(item)
		novo.posicao = i
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

func selecionaPersonagem(proxArea):
	proximaArea=proxArea
	atualizaPersonagens()
	selecionaPersonagem = true

func selecaoPersonagem():
	if Input.is_action_just_pressed("ui_down"):
		descerCursor()
	elif Input.is_action_just_pressed("ui_up"):
		subirCursor()
	elif Input.is_action_just_pressed("a"):
		selecionaCursor()
	elif Input.is_action_just_pressed("s"):
		selecionaPersonagem = false
		areaSecundaria.cursorAtivado = true

func desenhaCursor(delta):
	if(len(listaInfoPersonagem)>0):
		var posicaoLocal = listaInfoPersonagem[posicao].get_position()
		posicaoLocal.x += 130 + vibracaoCursor
		if(vibracaoCursor > 10):
			adicaoCursor = -70
		elif(vibracaoCursor< -10):
			adicaoCursor = 70
		vibracaoCursor+= adicaoCursor * delta
		$cursor.set_position(posicaoLocal)

