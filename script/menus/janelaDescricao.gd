extends Node2D

var item


func _ready():
	set_process(true)
	$btnVoltar/texto.set_text(ControlaDados.receberTexto("menus",19))
	
func _process(delta):

	if(VariaveisGlobais.menuAberto):
		if Input.is_action_just_pressed("mouse_left"):
			
			if Funcoes.na_area($btnOk,$btnOk/CollisionShape2D):
				item.ativar(null)
			elif Funcoes.na_area($btnVoltar,$btnVoltar/CollisionShape2D):
				voltar()
		
		if Input.is_action_just_pressed("s"):
			voltar()

func voltar():
	var novoNode = get_parent().get_parent().preOpcoes.instance()
	get_parent().get_parent().selecionaPersonagem=false
	get_parent().get_parent().atualizaAreaSecundaria(novoNode)
	get_parent().get_parent().atualizaPersonagens()

func atualizaItem(item):
	var textoItem = ""
	
	if(item == null):
		$btnOk.set_visible(false)
		$btnVoltar.set_position(Vector2(0,$btnVoltar.get_position().y))
		$titulo.set_text("")
		$texto.set_text("")
	else:
		self.item=item
		$btnOk.set_visible(true)
		$btnVoltar.set_position(Vector2(70,$btnVoltar.get_position().y))
		
		if(item.tipo == Constantes.ITEM_TIPO_OUTROS):
			$btnOk.set_visible(false)
			$btnVoltar.set_position(Vector2(0,$btnVoltar.get_position().y))
		elif(Constantes.ITEM_TIPO_UTILIZAVEL):
			textoItem = $btnVoltar/texto.set_text(ControlaDados.receberTexto("menus",20))
		elif(Constantes.ITEM_TIPO_EQUIPAMENTO):
			textoItem=$btnVoltar/texto.set_text(ControlaDados.receberTexto("menus",21))
		
		$titulo.set_text(item.nome)
		$texto.set_text(item.descricao)

	$btnOk.get_node("texto").set_text(textoItem)
		
