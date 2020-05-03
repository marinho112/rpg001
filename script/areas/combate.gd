extends Node2D

#Listas 
var listaAmigos = [0,1,2,3,4,5]
var listaInimigos = [0,1,2,3,4,5]
var listaAmigosObjeto = []
var listaInimigosObjeto = []
var listaTurnos = []
var vetorSelecionados = []
var listaAmigosSelecionados=[]
var listaInimigosSelecionados=[]
var listaCursoresSobressalentes=[]

#Preloads
var pre_personagem = preload("res://nodes/objetos/personagem_combate.tscn")
var pre_cursor = preload("res://nodes/objetos/cursor.tscn")

#Variaveis Inteiras
var tamanhoAmigo
var tamanhoInimigo
var numSelecao =1
var acaoPretendida
var valorAcaoPretendida


#Variaveis de Controle
var controleDeTurno = true
var mudarLadoSelecao=false
var selecaoAliados=false
var selecaoIndividual=true
var emSelecao=false
var posicaoCursor = 0
var ocilante= 0
var clicavel = true

#Contadores
var turno=0
var rodada=0
var numPersonagens= len(listaAmigos) + len(listaInimigos)
var numSelecionados =0

#objetos 
var atacante


# Called when the node enters the scene tree for the first time.
func _ready():
	carregar_personagens()
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	
	if(controleDeTurno):
		if(turno<len(listaTurnos)):
			var daVez= listaTurnos[turno]
			if (daVez.is_in_group(Constantes.GRUPO_ALIADOS)) :
				var menu = get_node("menuCombate")
				menu.ativado = true
				menu.personagemTurno = daVez
				controleDeTurno = false
			else:
				print("turno do monstro: "+ str(turno))
				turno+=1
		else:
			turno=0
			rodada+=1
	
	emSelecao(delta)

func carregar_personagens():
	
	tamanhoAmigo=len(listaAmigos)
	tamanhoInimigo=len(listaInimigos)

	for i in tamanhoAmigo:
		var item= listaAmigos[i]
		var personagem = pre_personagem.instance()
		personagem.get_node("AnimatedSprite").set_animation("default")
		listaAmigosObjeto.append(personagem)
		add_child(personagem)
		personagem.personagem=item
		personagem.add_to_group(Constantes.GRUPO_ALIADOS)
		
		var x=900
		var y= i * 130
		if(i>2):
			x=1100
			y+= 120 - 130 *3
		else:
			y+= 180
			
		personagem.alteraPosicaoPermanente(Vector2(x,y))
		
	for i in tamanhoInimigo:
		var item= listaInimigos[i]
		var personagem = pre_personagem.instance()
		personagem.virado = true
		personagem.get_node("AnimatedSprite").set_flip_h(true)
		personagem.get_node("AnimatedSprite").set_animation("default")
		personagem.personagem=item
		listaInimigosObjeto.append(personagem)
		add_child(personagem)
		personagem.add_to_group(Constantes.GRUPO_INIMIGO)
		
		var x=400
		var y= i * 130
		if(i>2):
			x=200
			y+= 120 - 130 * 3
		else:
			y+= 180
			
		personagem.alteraPosicaoPermanente(Vector2(x,y))
	
	ordenaTurno()
		

	
func ordenaTurno():
	listaTurnos = listaAmigosObjeto + listaInimigosObjeto

func emSelecao(delta):
	if(emSelecao):
		var lista=[]
		if(selecaoAliados):
			$cursor.set_frame(0)
			desenhaCursorSelecao(listaAmigosObjeto,delta)
			lista = listaAmigosSelecionados
		else:
			$cursor.set_frame(1)
			desenhaCursorSelecao(listaInimigosObjeto,delta)
			lista = listaInimigosSelecionados
			
		var repetir=true
		
		if Input.is_action_just_pressed("ui_up"):
			if(!clicavel):
				clicavel=true
			while(repetir):
				repetir=false
				if(posicaoCursor>0):
					posicaoCursor-=1
				else:
					posicaoCursor=5
				for i in len(lista):
					if(posicaoCursor==lista[i]):
						repetir=true
		
		repetir=true
		if Input.is_action_just_pressed("ui_down"):
			if(!clicavel):
				clicavel=true
			while(repetir):
				repetir=false
				if(posicaoCursor<5):
					posicaoCursor+=1
				else:
					posicaoCursor=0
				for i in len(lista):
					if(posicaoCursor==lista[i]):
						repetir=true
		
		if (Input.is_action_just_pressed("a") and clicavel):
			if(selecaoIndividual):
				var novoCursor = pre_cursor.instance()
				novoCursor.set_position($cursor.get_position())
				novoCursor.set_sprite_frames($cursor.get_sprite_frames())
				novoCursor.set_animation($cursor.get_animation())
				novoCursor.set_frame($cursor.get_frame())
				novoCursor.set_visible(true)
				add_child(novoCursor)
				clicavel=false
				
				listaCursoresSobressalentes.append(novoCursor)
				if(selecaoAliados):
					listaAmigosSelecionados.append(posicaoCursor)
				else:
					listaInimigosSelecionados.append(posicaoCursor)
				
			if(numSelecionados<numSelecao):
				numSelecionados+=1
				if(selecaoAliados):
					vetorSelecionados.append(listaAmigosObjeto[posicaoCursor])
				else:
					vetorSelecionados.append(listaInimigosObjeto[posicaoCursor])
			if(numSelecionados>=numSelecao):
				if(!clicavel):
					clicavel=true
					
				emSelecao=false
				$cursor.set_visible(false)
				chamaAcao(vetorSelecionados) # envias a ação
				listaAmigosSelecionados=[]
				listaInimigosSelecionados=[]
				for i in len(listaCursoresSobressalentes):
					listaCursoresSobressalentes[i].queue_free()
				listaCursoresSobressalentes=[]
		var posicaoAntiga = posicaoCursor
		if Input.is_action_just_pressed("ui_right"):
			if(!clicavel):
				clicavel=true
			if(selecaoAliados and (posicaoCursor<3)):
				posicaoCursor += 3
			elif(posicaoCursor>=3):
				posicaoCursor -= 3
			elif(!selecaoAliados and mudarLadoSelecao):
				selecaoAliados=true
				posicaoCursor=0
		elif Input.is_action_just_pressed("ui_left"):
			if(!clicavel):
				clicavel=true
			if(!selecaoAliados and (posicaoCursor<3)):
				posicaoCursor += 3
			elif(posicaoCursor>=3):
				posicaoCursor -= 3
			elif(selecaoAliados and mudarLadoSelecao):
				selecaoAliados=false
				posicaoCursor=0
				
		for i in len(lista):
			if(posicaoCursor==lista[i]):
				posicaoCursor=posicaoAntiga
				break
		
		
			pass

func desenhaCursorSelecao(lista,delta):
	
	#var position = $cursor.get_position()
	var positionElemento = lista[posicaoCursor].get_position()
	var frames =lista[posicaoCursor].get_node("AnimatedSprite").get_sprite_frames()
	var anim = lista[posicaoCursor].get_node("AnimatedSprite").get_animation()
	var frame =lista[posicaoCursor].get_node("AnimatedSprite").get_frame()
	var tamanhoElemento = frames.get_frame(anim,frame).get_size()
	var ajusteTamanho = tamanhoElemento.x + 12 + ocilante
	if (ocilante< 4):
		ocilante += delta *18
	else:
		ocilante*=-1
	if(selecaoAliados):
		ajusteTamanho *=-1
	
	$cursor.set_position(Vector2(positionElemento.x + ajusteTamanho, positionElemento.y))
	
	
func chamaAcao(alvos):
	# Atacar : 0
	# Usar Item : 1

	match acaoPretendida:
		
		0:
			atacante.atacar(alvos,valorAcaoPretendida)

func seleciona(tipoSelecao,numSelecao,tipoAcao,codAcao,fonte):
	
	posicaoCursor = 0
	acaoPretendida=tipoAcao
	valorAcaoPretendida=codAcao
	atacante=fonte
	emSelecao=true
	vetorSelecionados=[]
	self.numSelecao=numSelecao
	numSelecionados=0
	$cursor.set_visible(true)
	if((tipoSelecao|61)==(63)):
		mudarLadoSelecao=true
	else:
		mudarLadoSelecao=false
	if((tipoSelecao|62)==(63)):
		selecaoAliados = true
	else:
		selecaoAliados = false
	if((tipoSelecao|59)==(63)):
		selecaoIndividual=true
	else:
		selecaoIndividual=false
	
	pass
	
	
func terminaTurno():
	controleDeTurno = true
	turno+=1
	print("ESTAMOS NO TURNO: "+ str(turno))
		

func alertaCombate(titulo,texto,tempo,pausar):
	$alertaTelaCombate/fundo/titulo.set_text(titulo)
	$alertaTelaCombate/fundo/texto.set_text(texto)
	$timerAlerta.set_wait_time(tempo)
	$alertaTelaCombate.set_visible(true)
	$timerAlerta.start()
	get_tree().paused=pausar
	
	pass


func _on_Timer_timeout():
	$alertaTelaCombate.set_visible(false)
	get_tree().paused=false
	pass 
