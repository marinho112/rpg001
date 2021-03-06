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

func mudarPosicao(posicao):
	set_position(posicao)
	posicaoCursorBarra.x = $fundo/barraRolagem.get_global_position().x
	

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
	
	if(ativado and VariaveisGlobais.menuAberto):
		if Input.is_action_just_pressed("ui_down"):
			descerLista()
		elif Input.is_action_just_pressed("ui_up"):
			subirLista()
		elif Input.is_action_just_pressed("ui_left"):
			tipoEsquerda()
		elif Input.is_action_just_pressed("ui_right"):
			tipoDireita()
		elif Input.is_action_just_pressed("a"):
			pass
		if Input.is_action_just_pressed("mouse_left"):
			if Funcoes.na_area($fundo/AreaRolagemBntCima,$fundo/AreaRolagemBntCima/Collision) :
				subirLista()
			elif Funcoes.na_area($fundo/AreaRolagemBntBaixo,$fundo/AreaRolagemBntBaixo/Collision) :
				descerLista()
				
			controlaTipoLista()
			
		if Input.is_action_pressed("mouse_left"):
			if Funcoes.na_area($fundo/AreaRolagem,$fundo/AreaRolagem/Collision) :
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
	
	
func desenhaCursor():
	var posicaoX = $cursor.get_position().x
	var posicaoY = listaItensObjeto[posicao].get_position().y
	$cursor.set_position(Vector2(posicaoX,posicaoY))

func controlaTipoLista():
	var area = $fundo/bordasLista/AreaSelecionaTipoItem
	if(Funcoes.na_area(area,area.get_node("Collision"))):
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
	primeiro = 0
	posicao = 0
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
		objeto.posicao=i
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
		if(dif != 0):
			percent = (len(listaItensObjeto) *1.0 / len(listaItens) )
			microPartes = tamanhoBarra.y * ((1-percent))/ dif
			novoPosicaoCursorBarra.y +=  microPartes * -((primeiro*2)+dif) 
			novoTamanhoCursorBarra.y*= percent
			
		$fundo/barraRolagem.set_global_position(novoPosicaoCursorBarra)
		$fundo/barraRolagem.set_scale(novoTamanhoCursorBarra)
		
		var descri = get_parent().get_parent().areaSecundaria
		if((descri != null) and (len(listaItensObjeto)>0)):
			descri.atualizaItem(listaItens[posicao+primeiro])
		else:
			print("fois")
			descri.atualizaItem(null)
		
		desenhaCursor()
	else:
		$cursor.set_visible(false)
	

func tipoDireita():
	if (tipoItemListado == Constantes.ITEM_TIPO_OUTROS):
		tipoItemListado = Constantes.ITEM_TIPO_UTILIZAVEL
	elif (tipoItemListado == Constantes.ITEM_TIPO_UTILIZAVEL):
		tipoItemListado = Constantes.ITEM_TIPO_EQUIPAMENTO
	elif (tipoItemListado == Constantes.ITEM_TIPO_EQUIPAMENTO):
		tipoItemListado = Constantes.ITEM_TIPO_OUTROS
	mudarPosicaoTipoItem()

func tipoEsquerda():
	if (tipoItemListado == Constantes.ITEM_TIPO_UTILIZAVEL):
		tipoItemListado = Constantes.ITEM_TIPO_OUTROS
	elif (tipoItemListado == Constantes.ITEM_TIPO_OUTROS):
		tipoItemListado = Constantes.ITEM_TIPO_EQUIPAMENTO
	elif (tipoItemListado == Constantes.ITEM_TIPO_EQUIPAMENTO):
		tipoItemListado = Constantes.ITEM_TIPO_UTILIZAVEL
	mudarPosicaoTipoItem()

func descerLista():
	if(posicao < len(listaItensObjeto) - 1):
		posicao+=1
	elif(ultimo < len(listaItens)):
		ultimo+=1
		primeiro+=1
	desenharLista()
	
func subirLista():
	if(posicao > 0):
		posicao-=1
	elif(primeiro > 0):
		ultimo-=1
		primeiro-=1
	desenharLista()


func limpaLista():
	for item in listaItensObjeto:
		item.queue_free()
	listaItensObjeto=[]
