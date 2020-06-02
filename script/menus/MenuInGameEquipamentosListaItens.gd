extends Node2D

var ativado = false

var listaItens = []
var listaItensObjeto=[]

var preItem = preload("res://nodes/menus/MenuInGameItem2.tscn")

var posicaoCursorBarra
var tamanhoCursorBarra

var primeiro = 0
var posicao = 0
var ultimo 


func _ready():
	
	tamanhoCursorBarra = $barraRolagem.get_scale()
	posicaoCursorBarra = $barraRolagem.get_position()
	
	
	set_process(true)

func mudarPosicao(posicao):
	set_position(posicao)
	posicaoCursorBarra.x = $barraRolagem.get_position().x
	

func _process(delta):
	
	if(ativado and VariaveisGlobais.menuAberto):
		if Input.is_action_just_pressed("ui_down"):
			descerLista()
		elif Input.is_action_just_pressed("ui_up"):
			subirLista()
		elif Input.is_action_just_pressed("a"):
			pass
		if Input.is_action_just_pressed("mouse_left"):
			if Funcoes.na_area($AreaRolagemBntCima,$AreaRolagemBntCima/Collision) :
				subirLista()
			elif Funcoes.na_area($AreaRolagemBntBaixo,$AreaRolagemBntBaixo/Collision) :
				descerLista()
				
			
		if Input.is_action_pressed("mouse_left"):
			if Funcoes.na_area($AreaRolagem,$AreaRolagem/Collision) :
				var posicaoMouse = posicaoDoCursorNaArea($AreaRolagem,len(listaItens)).y
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

func carregaLista():
	
	limpaLista()
	$listaVazia.set_visible(false)
	primeiro = 0
	posicao = 0
	
	if (len(listaItens)<10):
		ultimo = len(listaItens)
	else:
		ultimo = 10
	
	for i in ultimo:
		var objeto = preItem.instance()
		objeto.set_position(Vector2(-10,-140 +(i*34)))
		objeto.posicao=i
		add_child(objeto)
		listaItensObjeto.append(objeto)
	desenharLista()
	
func desenharLista():
	
	for i in len(listaItensObjeto):
		var objeto = listaItensObjeto[i]
		objeto.defItem(listaItens[i+primeiro])
	
	var tamanhoBarra = $AreaRolagem/Collision.get_shape().get_extents()
	
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
		
		
		
		$barraRolagem.set_position(novoPosicaoCursorBarra)
		$barraRolagem.set_scale(novoTamanhoCursorBarra)
		
		var descri = get_parent().get_parent().get_parent().areaSecundaria
		if((descri != null) and (len(listaItensObjeto)>0)):
			descri.atualizaItem(listaItens[posicao+primeiro])
		else:
			print("fois")
			descri.atualizaItem(null)
		
		desenhaCursor()
	else:
		$cursor.set_visible(false)
	

func descerLista():
	if(posicao < len(listaItensObjeto)-1):
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
	$cursor.set_visible(false)
	for item in listaItensObjeto:
		item.queue_free()
	listaItensObjeto=[]
	
	
