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
