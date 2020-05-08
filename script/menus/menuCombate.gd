extends Area2D

var itens= []
var itens2=[]
var posicao=0
var primeiro=0
var tamanho=0
var lista = []
var linhas = []
var ativado = true
var personagemTurno

var contaTempo=0


func _ready():
	linhas = [get_node("linha 1"),get_node("linha 2"),get_node("linha 3"),get_node("linha 4"),get_node("linha 5"),get_node("linha 6"),get_node("linha 7"),get_node("linha 8")]
	itens.append(Global.elementoMenu.new(1,"Atacar"))
	itens.append(Global.elementoMenu.new(0,"Item1",itens))
	itens.append(Global.elementoMenu.new(0,"Item3",itens2))
	
	itens2.append(Global.elementoMenu.new(0,"Item4",itens2))
	itens2.append(Global.elementoMenu.new(0,"Item5"))
	itens2.append(Global.elementoMenu.new(0,"Item6",itens))
	
	lista=itens
	desenhaMenu()
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	
	if(ativado):
		if (Input.is_action_just_pressed("a")):
			ativaAcaoBtn(lista[posicao+primeiro])
			
		elif (Input.is_action_pressed("ui_up")):
			if((posicao>0)and(contaTempo==0)):
				posicao-=1
			elif(contaTempo==0):
				if(primeiro>0):
					primeiro-=1
					desenhaMenu()
			contaTempo+=delta
		elif Input.is_action_pressed("ui_down"):
			if((posicao<tamanho-1)and(contaTempo==0)):
				posicao+=1
			elif(contaTempo==0):
				if(primeiro<len(lista)-tamanho):
					primeiro+=1
					desenhaMenu()
			contaTempo+=delta
		else:
			contaTempo=0
		if(contaTempo>=0.25):
			contaTempo=0
		
		if(Input.is_action_just_pressed("mouse_left")):
			var areas = get_overlapping_areas()
			var cursorNoLocal = false 
			for i in areas:
				if(i.is_in_group(Constantes.GRUPO_CURSOR_MOUSE)):
					cursorNoLocal=true
			if(cursorNoLocal):
				var mousePosition = get_viewport().get_mouse_position()
				var position = get_global_position()
				var tamanhoArea = $CollisionShape2D.get_shape().get_extents()
				position.x -= tamanhoArea.x
				position.y -= tamanhoArea.y
				var parte = tamanhoArea.y / 4
				var local = mousePosition.y - position.y
				local = local/parte
				if(local <= tamanho):
					if(posicao == int(local)):
						ativaAcaoBtn(lista[posicao+primeiro])
					else:
						posicao = int(local)
					
		
		atualizaPosicao()
		desenhaEsferas()
	pass
	

func ativaAcaoBtn(botao):
	match botao.tipo:
		Constantes.TIPO_ELEMENTO_MENU_ITEM :
			pass
		Constantes.TIPO_ELEMENTO_MENU_ATAQUE: 
			ativado=false
			get_parent().seleciona(0,1,0,GolpesClasses.Ataque_Basico_Fisico_Corpo_a_Corpo.new(personagemTurno),personagemTurno)
		_:
			lista=botao.proximo
			desenhaMenu()
	
func atualizaPosicao():
	var lugar=linhas[posicao].get_position()
	lugar.x+=74
	lugar.y+=10
	$cursor.set_position(lugar)
	
func trocaPersonagemMenu():
	if(personagemTurno != null):
		if(personagemTurno.is_in_group(Constantes.GRUPO_ALIADOS)):
			lista = personagemTurno.personagem.menu
	
	desenhaMenu()
	
func desenhaMenu():
	zerarLinhas()
	
	
	if(len(lista)<8):
		tamanho = len(lista)
	else:
		tamanho=8
	
	for i in tamanho:
		linhas[i].set_text(lista[i+primeiro].texto)
		pass
	
	desenhaEsferas()
	atualizaPosicao()

func desenhaEsferas():
	if(personagemTurno != null):
		var EA = personagemTurno.personagem.esferasAtaque
		var ED = personagemTurno.personagem.esferasDefesa
		var EAc = personagemTurno.personagem.esferasAcerto
		var EE = personagemTurno.personagem.esferasEsquiva
		var EM = personagemTurno.personagem.esferas
		EM -= EA+ED+EAc+EE
		
		$esferas/lbl_esfera_Dano.set_text(str(EA))
		$esferas/lbl_esfera_Defesa.set_text(str(ED))
		$esferas/lbl_esfera_Acerto.set_text(str(EAc))
		$esferas/lbl_esfera_Esquiva.set_text(str(EE))
		$esferas/lbl_esfera_Morta.set_text(str(EM))

func zerarLinhas():
	for i in 8:
		linhas[i].set_text("")
