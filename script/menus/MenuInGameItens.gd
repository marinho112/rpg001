extends Node2D

var ativado = true

var listaItens = []
var listaItensObjeto=[]

var preItem = preload("res://nodes/menus/MenuInGameItem.tscn")

var tipoItemListado = Constantes.ITEM_TIPO_OUTROS

var posicaoCursorBarra
var tamanhoCursorBarra

var primeiro = 0
var posicao = 0
var ultimo 


func _ready():
	
	$AbaConsumiveis.set_text(ControlaDados.receberTexto("menus",16))
	$AbaEquipamentos.set_text(ControlaDados.receberTexto("menus",8))
	$AbaOutros.set_text(ControlaDados.receberTexto("menus",17))
	
	tamanhoCursorBarra = $fundo/barraRolagem.get_scale()
	posicaoCursorBarra = $fundo/barraRolagem.get_global_position()
	

	mudarPosicaoTipoItem()
	
	set_process(true)

func mudarPosicaoTipoItem():
	var vetor = Vector2(0,0)
	match tipoItemListado:
		Constantes.ITEM_TIPO_UTILIZAVEL:
			vetor = $AbaConsumiveis.get_global_position()
		Constantes.ITEM_TIPO_EQUIPAMENTO:
			vetor = $AbaEquipamentos.get_global_position()
		Constantes.ITEM_TIPO_OUTROS:
			vetor = $AbaOutros.get_global_position()
	
	vetor.x+= 65
	vetor.y+= 23
	$fundo/bordasLista/caixaSelecaoTipo.set_global_position(vetor)
	carregaLista()
	desenharLista()
			
func _process(delta):
	
	if(ativado):
		if Input.is_action_just_pressed("ui_down"):
			descerLista()
		elif Input.is_action_just_pressed("ui_up"):
			subirLista()
		if Input.is_action_just_pressed("mouse_left"):
			if na_area($fundo/AreaRolagemBntCima) :
				subirLista()
			elif na_area($fundo/AreaRolagemBntBaixo) :
				descerLista()
				
			controlaTipoLista()
			
		if Input.is_action_pressed("mouse_left"):
			if na_area($fundo/AreaRolagem) :
				var posicaoMouse = posicaoDoCursorNaArea($fundo/AreaRolagem,len(listaItens)).y
				while(posicaoMouse < (posicao+primeiro)):
					subirLista()
				while(posicaoMouse > (posicao+primeiro)):
					descerLista()
				desenharLista()

func posicaoDoCursorNaArea(area,separacao):
	var tamanhoBarra = area.get_node("Collision").get_shape().get_extents()
	var posicaoBarra = area.get_global_position()
	var partes = tamanhoBarra / separacao
	var mousePosition = get_global_mouse_position()
	
	mousePosition -= posicaoBarra - tamanhoBarra
	mousePosition = mousePosition/2.0
	return Vector2(int(mousePosition.x/partes.x),int(mousePosition.y/partes.y))
	
	
func na_area(objeto):
	var posicao = objeto.get_global_position()
	var tamanho = objeto.get_node("Collision").get_shape().get_extents()
	var mousePosicao = get_global_mouse_position()
	var retorno =((mousePosicao.x < (posicao.x+tamanho.x))and(mousePosicao.x > (posicao.x-tamanho.x)))
	retorno = (retorno and ((mousePosicao.y < (posicao.y+tamanho.y)) and (mousePosicao.y > (posicao.y-tamanho.y))))
	return retorno
	
func desenhaCursor():
	var posicaoX = $cursor.get_position().x
	var posicaoY = listaItensObjeto[posicao].get_position().y
	$cursor.set_position(Vector2(posicaoX,posicaoY))

func controlaTipoLista():
	var area = $fundo/bordasLista/AreaSelecionaTipoItem
	if(na_area(area)):
		var posicaoCursor = posicaoDoCursorNaArea(area,3)
		match int(posicaoCursor.x):
			0:
				tipoItemListado = Constantes.ITEM_TIPO_UTILIZAVEL
			1:
				tipoItemListado = Constantes.ITEM_TIPO_EQUIPAMENTO
			2:
				tipoItemListado = Constantes.ITEM_TIPO_OUTROS
				
		mudarPosicaoTipoItem()

func carregaLista():
	listaItens=[]
	limpaLista()
	for item in VariaveisGlobais.listaItens:
		if(item.tipo == tipoItemListado):
			listaItens.append(item)
	
	if (len(listaItens)<14):
		ultimo = len(listaItens)
	else:
		ultimo = 14
	
	for i in ultimo:
		var objeto = preItem.instance()
		objeto.set_position(Vector2(-20,-178 +(i*30)))
		add_child(objeto)
		listaItensObjeto.append(objeto)
	
func desenharLista():
	
	for i in len(listaItensObjeto):
		var objeto = listaItensObjeto[i]
		objeto.defItem(listaItens[i+primeiro])
	
	var tamanhoBarra = $fundo/AreaRolagem/Collision.get_shape().get_extents()
	
	var novoTamanhoCursorBarra=tamanhoCursorBarra
	var novoPosicaoCursorBarra=posicaoCursorBarra
	var dif
	var percent
	var microPartes
	if (len(listaItens)>0):
		$cursor.set_visible(true)
		dif =(len(listaItensObjeto) - len(listaItens) )
		percent = (len(listaItensObjeto) *1.0 / len(listaItens) )
		microPartes = tamanhoBarra.y * ((1-percent))/ dif
		novoPosicaoCursorBarra.y +=  microPartes * -((primeiro*2)+dif) 
		novoTamanhoCursorBarra.y*= percent
		
		$fundo/barraRolagem.set_global_position(novoPosicaoCursorBarra)
		$fundo/barraRolagem.set_scale(novoTamanhoCursorBarra)
		desenhaCursor()
	else:
		$cursor.set_visible(false)

func descerLista():
	if(posicao < 13):
		posicao+=1
	elif(ultimo < len(listaItens)):
		ultimo+=1
		primeiro+=1
	desenharLista()
	
func subirLista():
	if(posicao > 0):
		posicao-=1
	elif(ultimo > 12):
		ultimo-=1
		primeiro-=1
	desenharLista()

func limpaLista():
	for item in listaItensObjeto:
		item.queue_free()
	listaItensObjeto=[]
