extends Node2D


var listaAmigos = [0,1,2,3,4,5]
var listaInimigos = [0,1,2,3,4,5]
var tamanhoAmigo
var tamanhoInimigo
var listaAmigosObjeto = []
var listaInimigosObjeto = []
var listaTurnos = []
var pre_personagem = preload("res://nodes/objetos/personagem_combate.tscn")
var controleDeTurno = true
var turno=0
var rodada=0
var numPersonagens= len(listaAmigos) + len(listaInimigos)
var mudarLadoSelecao=false
var selecaoAliados=false
var posicaoCursor = 0
var atacante
var acaoPretendida
var valorAcaoPretendida
var emSelecao=false
var ocilante= 0


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
		if(selecaoAliados):
			$cursor.set_frame(0)
			desenhaCursorSelecao(listaAmigosObjeto,delta)
		else:
			$cursor.set_frame(1)
			desenhaCursorSelecao(listaInimigosObjeto,delta)
	
		if Input.is_action_just_pressed("ui_up"):
			if(posicaoCursor>0):
				posicaoCursor-=1
			else:
				posicaoCursor=5
				
		if Input.is_action_just_pressed("ui_down"):
			if(posicaoCursor<5):
				posicaoCursor+=1
			else:
				posicaoCursor=0
				
		if Input.is_action_just_pressed("a"):
			emSelecao=false
			$cursor.set_visible(false)
			if(selecaoAliados):
				chamaAcao(listaAmigosObjeto[posicaoCursor])
			else:
				chamaAcao(listaInimigosObjeto[posicaoCursor])
		
		if Input.is_action_just_pressed("ui_right"):
			if(selecaoAliados and (posicaoCursor<3)):
				posicaoCursor += 3
			elif(posicaoCursor>=3):
				posicaoCursor -= 3
			elif(!selecaoAliados and mudarLadoSelecao):
				selecaoAliados=true
				posicaoCursor=0
		elif Input.is_action_just_pressed("ui_left"):
			if(!selecaoAliados and (posicaoCursor<3)):
				posicaoCursor += 3
			elif(posicaoCursor>=3):
				posicaoCursor -= 3
			elif(selecaoAliados and mudarLadoSelecao):
				selecaoAliados=false
				posicaoCursor=0
		
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
	
	
func chamaAcao(alvo):
	# Atacar : 0
	# Usar Item : 1

	match acaoPretendida:
		
		0:
			atacante.atacar(alvo,valorAcaoPretendida)

func seleciona(tipoSelecao,tipoAcao,codAcao,fonte):
	
	posicaoCursor = 0
	acaoPretendida=tipoAcao
	valorAcaoPretendida=codAcao
	atacante=fonte
	emSelecao=true
	$cursor.set_visible(true)
	
	if(tipoSelecao>1):
		mudarLadoSelecao=true
	else:
		mudarLadoSelecao=false
	
	if((tipoSelecao%2) == 0):
		selecaoAliados = false
	else:
		selecaoAliados = true
		
	pass
	
	
func terminaTurno():
	controleDeTurno = true
	turno+=1
	print("ESTAMOS NO TURNO: "+ str(turno))
		
	
