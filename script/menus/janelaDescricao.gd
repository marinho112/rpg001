extends Node2D

var ativado = false
var item

func _ready():
	set_process(true)
	$btnSair.get_node("texto").set_text("Sair(S)")
	
func _process(delta):
	if(ativado):
		if Input.is_action_just_pressed("mouse_left"):
			if Funcoes.na_area($btnSair,$btnSair/CollisionShape2D):
				ativado = false
				set_visible(false)
			elif Funcoes.na_area($btnOk,$btnSair/CollisionShape2D):
				item.ativar(null)

func atualizaItem(item):
	self.item=item
	$btnOk.set_visible(true)
	var textoItem = ""
	if(item.tipo == Constantes.ITEM_TIPO_OUTROS):
		$btnOk.set_visible(false)
	elif(Constantes.ITEM_TIPO_UTILIZAVEL):
		textoItem = "Usar"
	elif(Constantes.ITEM_TIPO_EQUIPAMENTO):
		textoItem="Equipar"
		
	$btnOk.get_node("texto").set_text(textoItem)
	$titulo.set_text(item.nome)
	$texto.set_text(item.descricao)
