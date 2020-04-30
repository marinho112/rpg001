extends Node2D

var listaAmigos = [0,1,2,3,4,5]
var listaInimigos = [0,1,2,3,4,5]
var tamanhoAmigo
var tamanhoInimigo
var listaAmigosObjeto = []
var listaInimigosObjeto = []
var pre_personagem = preload("res://nodes/objetos/personagem_combate.tscn")
var turno=0
var rodada=0
var numPersonagens= len(listaAmigos) + len(listaInimigos)

# Called when the node enters the scene tree for the first time.
func _ready():
	carregar_personagens()
	set_process(true)
	pass # Replace with function body.

func carregar_personagens():
	
	tamanhoAmigo=len(listaAmigos)
	tamanhoInimigo=len(listaInimigos)

	for i in tamanhoAmigo:
		var item= listaAmigos[i]
		var personagem = pre_personagem.instance()
		personagem.get_node("AnimatedSprite").set_animation("default")
		listaAmigosObjeto.append(personagem)
		add_child(personagem)
		add_to_group("party")
		
		var x=900
		var y= i * 130
		if(i>2):
			x=1100
			y+= 120 - 130 *3
		else:
			y+= 180
			
		personagem.set_position(Vector2(x,y))
		
	for i in tamanhoInimigo:
		var item= listaInimigos[i]
		var personagem = pre_personagem.instance()
		personagem.get_node("AnimatedSprite").set_flip_h(true)
		personagem.get_node("AnimatedSprite").set_animation("default")
		listaInimigosObjeto.append(personagem)
		add_child(personagem)
		add_to_group("inimigo")
		
		var x=400
		var y= i * 130
		if(i>2):
			x=200
			y+= 120 - 130 * 3
		else:
			y+= 180
			
		personagem.set_position(Vector2(x,y))
		
func _process(delta):
	
	if(turno<tamanhoAmigo):
		listaAmigosObjeto[turno].ativa(1)
	elif(turno<tamanhoAmigo+tamanhoInimigo):
		listaInimigosObjeto[turno-tamanhoAmigo].ativa(1)
	else:
		turno=0
		rodada+=1
	
func seleciona(tipoSelecao,tipoAcao):
		
	pass
	#if Input.is_action_just_released("a"):
	#	if(turno<tamanhoAmigo):
	#		listaAmigosObjeto[turno].ativa(0)
	#	elif(turno<tamanhoAmigo+tamanhoInimigo):
	#		listaInimigosObjeto[turno-tamanhoAmigo].ativa(0)
	#	turno+=1
		
	
