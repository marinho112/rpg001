extends Node2D

var habilitado = false
var positionCursor = 0

var textoEsferas= ControlaDados.receberTexto("menus",2)

func _ready():
	set_process(true)
	$titulo.set_text(textoEsferas)
	pass # Replace with function body.

func _process(delta):
	
	set_visible(habilitado)
	atualizaLabels()
	desenhaCursor()
	

	
	if(habilitado):
		if(Input.is_action_just_pressed("mouse_left")):
			var local
			local = verificaArea($AreaDireita)
			if(local>-1):
				mudarEsfera(local,1)
			local = verificaArea($AreaEsquerda)
			if(local>-1):
				mudarEsfera(local,-1)
			if(Global.verificaCursorNoLocal($AreaNome)):
				habilitado=false
				get_parent().ativado = true
			
		verificaMovimentoCursor()
		verificaEditaValorEsferas()

func desenhaCursor():
	var position = $cursor.get_position()
	var valorY
	match positionCursor:
		0:
			valorY= $ValEsfDano.get_position().y
		1:
			valorY= $ValEsfDefesa.get_position().y
		2:
			valorY= $ValEsfAcerto.get_position().y
		3:
			valorY= $ValEsfEsquiva.get_position().y
			
	position.y = valorY + 10
	$cursor.set_position(position)

func verificaMovimentoCursor():
	if Input.is_action_just_pressed("ui_down"):
		
		if(positionCursor < 3):
			positionCursor +=1
	elif Input.is_action_just_pressed("ui_up"):
		if(positionCursor > 0):
			positionCursor -=1
	
func verificaEditaValorEsferas():
	
	if Input.is_action_just_pressed("ui_left"):
		mudarEsfera(positionCursor,-1)
		
	if Input.is_action_just_pressed("ui_right"):
		mudarEsfera(positionCursor,1)
	
func atualizaLabels():
	var personagem = get_parent().personagemTurno.personagem
	var morta = personagem.esferas
	morta -= personagem.esferasAtaque + personagem.esferasDefesa + personagem.esferasAcerto + personagem.esferasEsquiva
	$ValEsfDano.set_text(str(personagem.esferasAtaque))
	$ValEsfDefesa.set_text(str(personagem.esferasDefesa))
	$ValEsfAcerto.set_text(str(personagem.esferasAcerto))
	$ValEsfEsquiva.set_text(str(personagem.esferasEsquiva))
	$ValEsfMorta.set_text(str(morta))
	
func mudarEsfera(local,valor):
	var personagem = get_parent().personagemTurno.personagem
	var limite = personagem.maxValorEsferas
	if(((personagem.esferasAtaque+personagem.esferasDefesa+personagem.esferasEsquiva+personagem.esferasAcerto)< personagem.esferas)or (valor==-1)):
		match local:
			0:
				if(((personagem.esferasAtaque < limite)and(valor==1)) or ((personagem.esferasAtaque > 0)and(valor==-1))):
					personagem.esferasAtaque += valor
			1:
				if(((personagem.esferasDefesa < limite)and(valor==1)) or ((personagem.esferasDefesa > 0)and(valor==-1))):
					personagem.esferasDefesa += valor
			2:
				if(((personagem.esferasAcerto < limite)and(valor==1)) or ((personagem.esferasAcerto > 0)and(valor==-1))):
					personagem.esferasAcerto += valor
			3:
				if(((personagem.esferasEsquiva < limite)and(valor==1)) or ((personagem.esferasEsquiva > 0)and(valor==-1))):
					personagem.esferasEsquiva += valor

func verificaArea(area):
	var local = -1
	if(Global.verificaCursorNoLocal(area)):
		var mousePosition = area.get_local_mouse_position()
		var areaSize = area.get_node("Collision").get_shape().get_extents()
		local = int((mousePosition.y + (areaSize.y / 1.0)) / (areaSize.y/1.7))
	return local
	
