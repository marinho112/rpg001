extends Node2D

var posicao = 0
var cursorAtivado = true
var ativado = true
var listaMenu = []

var preItem = preload("res://nodes/menus/MenuInGameItens.tscn")
var preDescricaoItem = preload("res://nodes/menus/janelaDescricao.tscn")

func _ready():
	listaMenu.append($OpcaoStatus)
	listaMenu.append($OpcaoEquipamentos)
	listaMenu.append($OpcaoHabilidades)
	listaMenu.append($OpcaoItens)
	listaMenu.append($OpcaoBestiario)
	listaMenu.append($OpcaoOpcoes)
	listaMenu.append($OpcaoAjuda)
	listaMenu.append($OpcaoSair)
	$OpcaoStatus/texto.set_text(ControlaDados.receberTexto("menus",7))
	$OpcaoEquipamentos/texto.set_text(ControlaDados.receberTexto("menus",8))
	$OpcaoHabilidades/texto.set_text(ControlaDados.receberTexto("menus",6))
	$OpcaoItens/texto.set_text(ControlaDados.receberTexto("menus",4))
	$OpcaoBestiario/texto.set_text(ControlaDados.receberTexto("menus",9))
	$OpcaoOpcoes/texto.set_text(ControlaDados.receberTexto("menus",10))
	$OpcaoAjuda/texto.set_text(ControlaDados.receberTexto("menus",11))
	$OpcaoSair/texto.set_text(ControlaDados.receberTexto("menus",12))

	set_process(true)
	
func _process(delta):
	if(ativado and VariaveisGlobais.menuAberto):
		if(cursorAtivado):
			controlaPosicaoCursor()
		desenhaCursor()
		controlaPosicaoCursorMouse()
		
func desenhaCursor():
	var posicao2 = listaMenu[posicao].get_global_position()
	posicao2.y += 2
	$cursor.set_global_position(posicao2)

func controlaPosicaoCursor():
	
	if Input.is_action_just_pressed("ui_up"):
		if(posicao>0):
			posicao-=1
	elif Input.is_action_just_pressed("ui_down"):
		if(posicao<7):
			posicao+=1
	
	if Input.is_action_just_pressed("a"):
		selecionaOpcaoMenu()

func controlaPosicaoCursorMouse():
	if Input.is_action_just_pressed("mouse_left"):
		var posicaoCursor=get_global_mouse_position()
		
		for i in len(listaMenu):
			var item = listaMenu[i]
			var tamanho = item.get_node("Collision").get_shape().get_extents()
			if((posicaoCursor.x > (item.get_global_position().x -tamanho.x)) and (posicaoCursor.x < (item.get_global_position().x +tamanho.x))):
				if((posicaoCursor.y > (item.get_global_position().y -tamanho.y)) and (posicaoCursor.y < (item.get_global_position().y +tamanho.y))):
					if(posicao == i):
						selecionaOpcaoMenu()
					else:
						posicao=i

func selecionaOpcaoMenu():
	print(str(posicao))
	match posicao:
		3:
			var menu2 = preDescricaoItem.instance()
			get_parent().get_parent().atualizaAreaSecundaria(menu2)
			var menu = preItem.instance()
			get_parent().get_parent().atualizaAreaPrincipal(menu)
		
		7:
			VariaveisGlobais.menuAberto = false
			get_parent().get_parent().set_visible(false)
