extends Node2D

var ativado = true

var listaItens = []
var listaItensObjeto=[]

var preItem = preload("res://nodes/menus/MenuInGameItem.tscn")

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
	
	carregaLista()
	desenharLista()
	set_process(true)

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
		if Input.is_action_pressed("mouse_left"):
			if na_area($fundo/AreaRolagem) :
				var tamanhoBarra = $fundo/AreaRolagem/Collision.get_shape().get_extents()
				var posicaoBarra = $fundo/AreaRolagem.get_global_position()
				var dif =(len(listaItens)-len(listaItensObjeto) )
				var partes = tamanhoBarra.y / len(listaItens)
				var mousePosition = get_global_mouse_position()
				
				mousePosition -= posicaoBarra - tamanhoBarra
				mousePosition = mousePosition/2.0
				var posicaoMouse = int(mousePosition.y/partes)
				while(posicaoMouse < (posicao+primeiro)):
					subirLista()
				while(posicaoMouse > (posicao+primeiro)):
					descerLista()
				
				
				#posicaoBarra-= tamanhoBarra
				#mousePosition.y -= posicaoBarra.y 
				#primeiro += int(mousePosition.y/(partes*2.0))
				#ultimo = primeiro + 13
				desenharLista()

func na_area(objeto):
	var posicao = objeto.get_global_position()
	var tamanho = objeto.get_node("Collision").get_shape().get_extents()
	var mousePosicao = get_global_mouse_position()
	var retorno =((mousePosicao.x < (posicao.x+tamanho.x))and(mousePosicao.x > (posicao.x-tamanho.x)))
	print(str(retorno))
	retorno = (retorno and ((mousePosicao.y < (posicao.y+tamanho.y)) and (mousePosicao.y > (posicao.y-tamanho.y))))
	print(str(retorno))
	return retorno
	
func desenhaCursor():
	var posicaoX = $cursor.get_position().x
	var posicaoY = listaItensObjeto[posicao].get_position().y
	$cursor.set_position(Vector2(posicaoX,posicaoY))

func carregaLista():
	listaItens=VariaveisGlobais.listaItens
	
	if (len(listaItens)<13):
		ultimo = len(listaItens)
	else:
		ultimo = 13
	
	for i in ultimo+1:
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
	
	var dif =(len(listaItensObjeto) - len(listaItens) )
	var percent = (len(listaItensObjeto) *1.0 / len(listaItens) )
	
	var microPartes = tamanhoBarra.y * ((1-percent))/ dif
	novoPosicaoCursorBarra.y +=  microPartes * -((primeiro*2)+dif) 
	
	novoTamanhoCursorBarra.y*= percent
	
	
	$fundo/barraRolagem.set_global_position(novoPosicaoCursorBarra)
	$fundo/barraRolagem.set_scale(novoTamanhoCursorBarra)
	desenhaCursor()

func descerLista():
	if(posicao < 13):
		posicao+=1
	elif(ultimo < len(listaItens)-1):
		ultimo+=1
		primeiro+=1
	desenharLista()
	
func subirLista():
	if(posicao > 0):
		posicao-=1
	elif(ultimo > 13):
		ultimo-=1
		primeiro-=1
	desenharLista()
