extends Node2D

#Listas 
var listaAmigos = []
var listaInimigos = []
var listaAmigosObjeto = []
var listaInimigosObjeto = []
var listaTurnos = []
var vetorSelecionados = []
var listaSelecionados=[]
var listaCursoresSobressalentes=[]

var matrizPosicao=[]

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
var posicaoXCursor = 0
var posicaoYCursor = 0
var clicavel = true

#Contadores
var turno=0
var rodada=0
var ocilante= 0
var ocilantePersonagemPermanete =0
var numSelecionados =0

#objetos 
var atacante


# Called when the node enters the scene tree for the first time.
func _ready():
	listaAmigos.append(Global.personagemParty.new())
	listaAmigos[0].posicaoCombate=5
	listaAmigos.append(Global.personagemParty.new())
	listaAmigos[1].posicaoCombate=4
	listaAmigos.append(Global.personagemParty.new())
	listaAmigos[2].posicaoCombate=3
	listaAmigos.append(Global.personagemParty.new())
	listaAmigos[3].posicaoCombate=0
	listaAmigos.append(Global.personagemParty.new())
	listaAmigos[4].posicaoCombate=2
	listaAmigos.append(Global.personagemParty.new())
	listaAmigos[5].posicaoCombate=1
	
	
	listaInimigos.append(Global.personagemMob.new())
	listaInimigos[0].posicaoCombate = 0
	listaInimigos.append(Global.personagemMob.new())
	listaInimigos[1].posicaoCombate = 1
	listaInimigos.append(Global.personagemMob.new())
	listaInimigos[2].posicaoCombate = 2
	listaInimigos.append(Global.personagemMob.new())
	listaInimigos[3].posicaoCombate = 3
	listaInimigos.append(Global.personagemMob.new())
	listaInimigos[4].posicaoCombate = 4
	listaInimigos.append(Global.personagemMob.new())
	listaInimigos[5].posicaoCombate = 5
	
	for i in 3:
		pass#listaAmigos.remove(randi()%(len(listaAmigos)+1))
	
	for i in 3:
		listaInimigos.remove(randi()%(len(listaInimigos)+1))
	
	carregar_personagens()
	set_process(true)
	pass # Replace with function body.

func desenhaMatrizPosicao():
	for i in 4:
		matrizPosicao.append([null,null,null])
	
	for i in listaAmigosObjeto:
		
		var p = i.personagem.posicaoCombate
		var y = p%3
		var x=2
		if(p>2):
			x=3
			
		matrizPosicao[x][y]=i
	
	for i in listaInimigosObjeto:
		
		var p = i.personagem.posicaoCombate
		var y = p%3
		var x=0
		if(p<3):
			x=1
			
		matrizPosicao[x][y]=i
	

func _process(delta):
	
	animaTurno(delta)
	
	if(controleDeTurno):
		if(turno<len(listaTurnos)):
			var daVez= listaTurnos[turno]
			if (daVez.is_in_group(Constantes.GRUPO_ALIADOS)) :
				var menu = get_node("menuCombate")
				menu.ativado = true
				menu.personagemTurno = daVez
				controleDeTurno = false
			else:
				turno+=1
		if(turno>=len(listaTurnos)):
			turno=0
			rodada+=1
	
	emSelecao(delta)

func animaTurno(delta):
	var personagem = listaTurnos[turno]
	var position = personagem.get_global_position()
	var frames =personagem.get_node("AnimatedSprite").get_sprite_frames()
	var anim = personagem.get_node("AnimatedSprite").get_animation()
	var frame =personagem.get_node("AnimatedSprite").get_frame()
	var altura = frames.get_frame(anim,frame).get_size().y
	
	ocilantePersonagemPermanete+=delta *20
	if(ocilantePersonagemPermanete>=8):
		ocilantePersonagemPermanete=0
	position.y-= -10+ ocilantePersonagemPermanete + altura
	$apontaPersonagem.set_global_position(position)
	pass

func carregar_personagens():
	
	tamanhoAmigo=len(listaAmigos)
	tamanhoInimigo=len(listaInimigos)
	listaAmigosObjeto=[]
	listaInimigosObjeto=[]

	for i in tamanhoAmigo:
		var item= listaAmigos[i]
		var personagem = pre_personagem.instance()
		personagem.virado = false
		personagem.get_node("AnimatedSprite").set_animation("default")
		listaAmigosObjeto.append(personagem)
		add_child(personagem)
		personagem.personagem=item
		personagem.add_to_group(Constantes.GRUPO_ALIADOS)
		
		var x=900
		var y= item.posicaoCombate * 130
		if(item.posicaoCombate>2):
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
		var y= item.posicaoCombate * 130
		if(item.posicaoCombate>2):
			x=200
			y+= 120 - 130 * 3
		else:
			y+= 180
			
		personagem.alteraPosicaoPermanente(Vector2(x,y))
	
	ordenaTurno()
	desenhaMatrizPosicao()

	
func ordenaTurno():
	listaTurnos = listaAmigosObjeto + listaInimigosObjeto

func emSelecao(delta):
	if(emSelecao):
		if(posicaoXCursor>1):
			$cursor.set_frame(0)
			desenhaCursorSelecao(delta)
		else:
			$cursor.set_frame(1)
			desenhaCursorSelecao(delta)
		
		var xMax=0
		var xMin=0
		
		if(mudarLadoSelecao):
			xMax=3
			xMin=0
		elif(selecaoAliados):
			xMax=3
			xMin=2
		else:
			xMax=1
			xMin=0
			
			pass
		var repetir=true
		
		if Input.is_action_just_pressed("ui_up"):
			if(!clicavel):
				clicavel=true
			while(repetir):
				repetir=false
				if(posicaoYCursor>0):
					posicaoYCursor-=1
				else:
					posicaoYCursor=(2)
					if(posicaoXCursor>xMin):
						posicaoXCursor-=1
					else:
						posicaoXCursor = xMax
						posicaoYCursor = 2
				
				if(matrizPosicao[posicaoXCursor][posicaoYCursor]==null):
					repetir=true
				var posicaoAtual=(posicaoXCursor*10)+posicaoYCursor
				for i in len(listaSelecionados):
					if(posicaoAtual==listaSelecionados[i]):
						repetir=true
		
		repetir=true
		if Input.is_action_just_pressed("ui_down"):
			if(!clicavel):
				clicavel=true
			while(repetir):
				repetir=false
				if(posicaoYCursor< 2):
					posicaoYCursor+=1
				else:
					posicaoYCursor=0
					if(posicaoXCursor<xMax):
						posicaoXCursor+=1
					else:
						posicaoXCursor = xMin
						posicaoYCursor = 0
				
					
				if(matrizPosicao[posicaoXCursor][posicaoYCursor]==null):
					repetir=true
				var posicaoAtual=(posicaoXCursor*10)+posicaoYCursor
				for i in len(listaSelecionados):
					if(posicaoAtual==listaSelecionados[i]):
						repetir=true
		
		if (Input.is_action_just_pressed("a") and clicavel):
			clickaPersonagem()
		if(Input.is_action_just_pressed("mouse_left")):
			for x in (xMax-xMin+1):
				for y in 3:
					if(matrizPosicao[x+xMin][y]!=null):
						var lista = matrizPosicao[x+xMin][y].get_overlapping_areas()
						for i in lista:
							if(i.is_in_group(Constantes.GRUPO_CURSOR_MOUSE)):
								if((posicaoXCursor == x) and (posicaoYCursor)==y):
									clickaPersonagem()
								else:
									posicaoXCursor=x+xMin
									posicaoYCursor=y
									break
									
		var posicaoAntiga = (posicaoXCursor*10) + posicaoYCursor
		if Input.is_action_just_pressed("ui_right"):
			
			if(!clicavel):
				clicavel=true
			for i in 3:
				if((posicaoXCursor+i<xMax)and(matrizPosicao[posicaoXCursor+(1+i)][posicaoYCursor]!= null)):
					posicaoXCursor+=1+i
					break
		elif Input.is_action_just_pressed("ui_left"):
			if(!clicavel):
				clicavel=true
			var novoX=posicaoXCursor
			for i in 3:
				if((posicaoXCursor-i>xMin)and(matrizPosicao[posicaoXCursor-(1+i)][posicaoYCursor]!= null)):
					posicaoXCursor-=1+i
					break
		for i in len(listaSelecionados):
			var posicaoCursor= (posicaoXCursor*10) + posicaoYCursor
			if(posicaoCursor==listaSelecionados[i]):
				posicaoYCursor=posicaoAntiga%10
				posicaoXCursor=int((posicaoAntiga-posicaoYCursor)/10)
				break

func clickaPersonagem():
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
		
		listaSelecionados.append((posicaoXCursor*10)+posicaoYCursor)
		
	if(numSelecionados<numSelecao):
		numSelecionados+=1
		vetorSelecionados.append(matrizPosicao[posicaoXCursor][posicaoYCursor])
	if(numSelecionados>=numSelecao):
		if(!clicavel):
			clicavel=true
			
		emSelecao=false
		$cursor.set_visible(false)
		chamaAcao(vetorSelecionados) # envias a ação
		listaSelecionados=[]
		for i in len(listaCursoresSobressalentes):
			listaCursoresSobressalentes[i].queue_free()
		listaCursoresSobressalentes=[]
		
func desenhaCursorSelecao(delta):
	
	#var position = $cursor.get_position()
	var perso = matrizPosicao[posicaoXCursor][posicaoYCursor]
	var positionElemento = perso.get_position()
	var frames =perso.get_node("AnimatedSprite").get_sprite_frames()
	var anim = perso.get_node("AnimatedSprite").get_animation()
	var frame =perso.get_node("AnimatedSprite").get_frame()
	var tamanhoElemento = frames.get_frame(anim,frame).get_size()
	var ajusteTamanho = tamanhoElemento.x + 12 + ocilante
	if (ocilante< 4):
		ocilante += delta *18
	else:
		ocilante*=-1
	if(posicaoXCursor>1):
		ajusteTamanho *=-1
	
	$cursor.set_position(Vector2(positionElemento.x + ajusteTamanho, positionElemento.y))
	
	
func chamaAcao(alvos):
	# Atacar : 0
	# Usar Item : 1

	match acaoPretendida:
		
		0:
			atacante.atacar(alvos,valorAcaoPretendida)

func seleciona(tipoSelecao,numSelecao,tipoAcao,codAcao,fonte):
	
	acaoPretendida=tipoAcao
	valorAcaoPretendida=codAcao
	atacante=fonte
	emSelecao=true
	vetorSelecionados=[]
	numSelecionados=0
	$cursor.set_visible(true)
	if((tipoSelecao|62)==(63)):
		selecaoAliados = true
	else:
		selecaoAliados = false
	if((tipoSelecao|61)==(63)):
		mudarLadoSelecao=true
	else:
		mudarLadoSelecao=false
	if((tipoSelecao|59)==(63)):
		selecaoIndividual=true
	else:
		selecaoIndividual=false
	
	var x = 1
	var y = 0
	var z =-1
	
	if(selecaoAliados):
		x = 2
		z = 1
	
	while(matrizPosicao[x][y] == null):
		y+=1
		if(y>2):
			x+= z
			y=0
			 
	posicaoXCursor = x
	posicaoYCursor = y
	
	
	if ((len(listaInimigos) < numSelecao) and selecaoIndividual):
		self.numSelecao<=len(listaInimigos)
	else:
		self.numSelecao=numSelecao
	pass
	
	
func terminaTurno():
	controleDeTurno = true
	turno+=1
		

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
