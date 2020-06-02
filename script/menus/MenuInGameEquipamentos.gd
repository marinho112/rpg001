extends "res://script/abstratos/MenuInGameSubItemAreaPrincipal.gd"

#var preOpcoes = preload("res://nodes/menus/MenuInGameOpcoes.tscn")

var posicao = 0

var preDescricaoEquipamento = preload("res://nodes/menus/janelaDescricao.tscn")

func _ready():
	set_process(true)	


func _process(delta):
	
	if(ativado):
		if Input.is_action_just_pressed("ui_down"):
			descerCursor()
		elif Input.is_action_just_pressed("ui_up"):
			subirCursor()
		elif Input.is_action_just_pressed("a"):
			ativaCursor()
		elif Input.is_action_just_pressed("mouse_left"):
			verificaClique()
		
		if Input.is_action_just_pressed("s"):
			voltar()

func verificaClique():
	if Funcoes.na_area($AreaEquipamentos,$AreaEquipamentos/CollisionShape2D):
		var tamanho = $AreaEquipamentos/CollisionShape2D.get_shape().get_extents()
		var posicaoArea = $AreaEquipamentos/CollisionShape2D.get_global_position()
		var posicaoMouse = get_global_mouse_position()
		posicaoMouse -= posicaoArea - (tamanho)
		posicaoMouse = int(posicaoMouse.y / 45)
		if(posicaoMouse == posicao):
			ativaCursor()
		else:
			posicao = posicaoMouse 
			desenharCursor()


func voltar():
	var pai = get_parent() 
	pai.remove_child(self)
	pai.get_parent().selecionaPersonagem(self)
		

func desenharCursor():
	var listaCampos= [$nomeItemCabeca,$nomeItemDireita,$nomeItemEsquerda,$nomeItemMaos,$nomeItemCorpo,$nomeItemPes,$nomeItemAcessorio1,$nomeItemAcessorio2,$nomeItemAcessorio3,$nomeItemAcessorio4]
	var posicaoCampo = listaCampos[posicao].get_position()
	var tamanhoCampo = listaCampos[posicao].get_size()
	var vetor = Vector2(posicaoCampo.x+tamanhoCampo.x - 5,posicaoCampo.y+(tamanhoCampo.y/2.0))
	$cursor.set_position(vetor)
	$MenuInGameEquipamentosListaItens/listaVazia.set_visible(false)
	
func subirCursor():
	if(posicao > 0):
		posicao-=1
	else:
		posicao = 9
	desenharCursor()
	
func descerCursor():
	if(posicao < 9):
		posicao+=1
	else:
		posicao = 0
	desenharCursor()
	
func ativaCursor():
	var listaItens = []
	var tipo 
	match posicao:
		0:
			tipo = Constantes.EQUIPAMENTO_TIPO_CABECA
		1:
			tipo = Constantes.EQUIPAMENTO_TIPO_ARMA
		2:
			tipo = Constantes.EQUIPAMENTO_TIPO_ESCUDO
		3:
			tipo = Constantes.EQUIPAMENTO_TIPO_MAOS
		4:
			tipo = Constantes.EQUIPAMENTO_TIPO_CORPO
		5:
			tipo = Constantes.EQUIPAMENTO_TIPO_PES
		_:
			tipo = Constantes.EQUIPAMENTO_TIPO_ACESSORIO
		
	for item in VariaveisGlobais.listaItens:
		var vai = false
		if(item.tipo == Constantes.ITEM_TIPO_EQUIPAMENTO):
			if(item.equipamento.tipoEquipamento == tipo):
				if (tipo == Constantes.EQUIPAMENTO_TIPO_ACESSORIO):
					vai = true
				else:
					for elemento in selecionado.equipaveis:
						if(elemento == item.equipamento.subTipoEquipamento):
							vai = true
				if(vai):
					listaItens.append(item)
	
	if(len(listaItens)>0):
		var secundario = preDescricaoEquipamento.instance()
		secundario.tipoVoltar = 1
		get_parent().get_parent().atualizaAreaSecundaria(secundario)
		
		$MenuInGameEquipamentosListaItens.listaItens = listaItens
		$MenuInGameEquipamentosListaItens.carregaLista()
		$MenuInGameEquipamentosListaItens.ativado = true
		ativado = false
	else:
		$MenuInGameEquipamentosListaItens.limpaLista()
		$MenuInGameEquipamentosListaItens/listaVazia.set_visible(true)
		
		
func defineSelecionado(para):
	selecionado = para

func reaverFoco():
	ativado = true
	$MenuInGameEquipamentosListaItens.ativado = false
	$MenuInGameEquipamentosListaItens.limpaLista()
