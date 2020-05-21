extends Node2D

var ativado = true

var listaItens = []
var listaItensObjeto=[]

var preItem = preload("res://nodes/menus/MenuInGameItem.tscn")

var primeiro = 0
var posicao = 0
var ultimo 


func _ready():
	
	$AbaConsumiveis.set_text(ControlaDados.receberTexto("menus",16))
	$AbaEquipamentos.set_text(ControlaDados.receberTexto("menus",8))
	$AbaOutros.set_text(ControlaDados.receberTexto("menus",17))
	
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
			if na_area($fundo/AreaRolagem) :
				pass
			elif na_area($fundo/AreaRolagemBntCima) :
				subirLista()
			elif na_area($fundo/AreaRolagemBntBaixo) :
				descerLista()


func na_area(objeto):
	var posicao = objeto.get_global_position()
	var tamanho = objeto.get_node("Collision").get_shape().get_extents()
	var mousePosicao = get_global_mouse_position()
	tamanho = tamanho/2.0
	var retorno =((mousePosicao.x < (posicao.x+tamanho.x))and(mousePosicao.x > (posicao.x-tamanho.x)))
	retorno = (retorno and ((mousePosicao.y < (posicao.y+tamanho.y)) and (mousePosicao.y > (posicao.y-tamanho.y))))
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
	#ARRUMAR POSICAO DA BARRA!!
	var posicaoCursorBarra = $fundo/barraRolagem.get_global_position()
	var posicaoBarra = $fundo/AreaRolagem/Collision.get_global_position()
	var tamanhoBarra = $fundo/AreaRolagem/Collision.get_shape().get_extents()
	var dif = (len(listaItens) - len(listaItensObjeto))
	var localNovo = tamanhoBarra.y * (primeiro) / dif
	posicaoCursorBarra.y = localNovo + posicaoBarra.y - (tamanhoBarra.y/2.0)
	$fundo/barraRolagem.set_global_position(posicaoCursorBarra)
	
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
