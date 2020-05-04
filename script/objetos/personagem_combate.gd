extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var inimigoAtacado
var personagem
var moverAtaque=true
var ataqueFinalizado = false
var animacaoAtaque = true
var controlaAtaque = false
var controlaHits=false
var voltando = false
var turnoTerminado = false
var bloqueado = false
var virado = false
var golpeDistancia= false
var golpeMagico = false
var speed = 200
var atacados=[]
var listaInimigos= []
var posicaoInicial
var ataquesRealizados=0 # Numero de movimentos para ataque
var golpesRealizados = 0 
var golpesPorAtaque=2 #Numero animações de ataque
var intervaloHits=0.01
var hitsPorGolpeRaiz=1 # efeitos de golpe por animação de ataque
var hitsPorGolpe=0
var hitsSecundariosPorGolpe=1 # hits por efeitos de golpe
var distanciaDeSurgimentoDoGolpe = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	
	controlaAtaque(delta)
	golpesControleHits(delta)
	
	

func alteraPosicaoPermanente(posicao):
	set_position(posicao)
	posicaoInicial=posicao

func atribuiValoresAtaque(golpesPorAtaque,hitsPorGolpeRaiz,intervaloHits,hitsSecundariosPorGolpe,distanciaDeSurgimentoDoGolpe,distancia,magia):
	self.golpesPorAtaque=golpesPorAtaque 
	self.hitsPorGolpeRaiz=hitsPorGolpeRaiz
	self.intervaloHits=intervaloHits
	self.hitsSecundariosPorGolpe=hitsSecundariosPorGolpe
	self.distanciaDeSurgimentoDoGolpe = distanciaDeSurgimentoDoGolpe
	self.golpeDistancia=distancia
	self.golpeMagico=magia

func atacar(atacados,tipoAtaque):
	
	turnoTerminado=false
	
	match tipoAtaque:
		0:
			atribuiValoresAtaque(1,1,0.01,1,50,false,false)
			
	
	moverAtaque=!golpeDistancia
	self.listaInimigos=get_parent().listaInimigosObjeto
	self.atacados=atacados
	ataquesRealizados=0
	ataqueFinalizado = false
	controlaAtaque=true
	pass


func bloqueado(area):
	if(moverAtaque and (area!=inimigoAtacado) and !voltando):
		if(is_in_group(Constantes.GRUPO_ALIADOS)):
			if(area.is_in_group(Constantes.GRUPO_INIMIGO)):
				bloqueado=true
				voltando = true
				golpesRealizados=golpesPorAtaque
		elif(is_in_group(Constantes.GRUPO_INIMIGO)):
			if(area.is_in_group(Constantes.GRUPO_ALIADOS)):
				bloqueado=true
				voltando = true
				golpesRealizados=golpesPorAtaque

func controlaAtaque(delta):
	if(controlaAtaque):
		if(ataquesRealizados<len(atacados)):
			moverAtaque(delta)
			animacaoAtaque(delta)
			
		else:
			ataqueFinalizado = true
		
		if(!voltando and ataqueFinalizado):
			voltando = true
		animacaoVoltar(delta)
		if(!voltando and turnoTerminado):
			$AnimatedSprite.set_animation("default")
			$AnimationPlayer.stop()
			controlaAtaque=false
			get_parent().terminaTurno()
	
		if(bloqueado):
			animacaoVoltar(delta)
		
func moverAtaque(delta):
	if(moverAtaque and !bloqueado):
		$AnimatedSprite.set_animation("movendo")
		$AnimatedSprite.set_flip_h(!virado)
		inimigoAtacado = atacados[ataquesRealizados]
		var posiAtacado=inimigoAtacado.get_position()
		var frames =inimigoAtacado.get_node("AnimatedSprite").get_sprite_frames()
		var anim = inimigoAtacado.get_node("AnimatedSprite").get_animation()
		var frame =inimigoAtacado.get_node("AnimatedSprite").get_frame()
		var atacadoTamanho=frames.get_frame(anim,frame).get_size()
		var position= get_position()
		var distanciaX= (atacadoTamanho.x + posiAtacado.x) - (position.x)
		var distanciaY= ((posiAtacado.y) - (position.y) )
		
		
		
		if(mover(distanciaX,distanciaY,delta)):
			moverAtaque=false
			$AnimatedSprite.set_flip_h(virado)
			
		
	pass
	
func animacaoAtaque(delta):
	
	if(golpesRealizados>=golpesPorAtaque):
		moverAtaque=!golpeDistancia
		ataquesRealizados+=1
		golpesRealizados=0
		if(ataquesRealizados>=len(atacados)):
			voltando = true
	
	if(!moverAtaque and animacaoAtaque):
		$AnimatedSprite.set_animation("batendo")
		$AnimationPlayer.play("atacando")
		
	pass

func ativaControlaHits():
	controlaHits=true
	hitsPorGolpe=hitsPorGolpeRaiz

func golpesControleHits(delta):
	if(controlaHits and ($timerHit.is_stopped())):
		if(hitsPorGolpe<=0):
			controlaHits=false
		else:
			$timerHit.set_wait_time(intervaloHits)
			$timerHit.start()
		
func criarGolpe():
	
	var golpe = preload("res://nodes/golpes/ataque_simples.tscn").instance()
	add_child(golpe)
	var position = get_global_position()
	var icremento = distanciaDeSurgimentoDoGolpe
	if(!virado):
		icremento *= -1
	position.x = position.x + icremento
	golpe.set_global_position(position)
	golpe.set_z_index(1)
	var grupos = get_groups()
	for i in grupos:
		golpe.add_to_group(i)
	golpe.numHits=hitsSecundariosPorGolpe
	golpe.get_node("AnimatedSprite").set_flip_h(!virado)
	golpe.get_node("AnimationPlayer").play("golpe")

func calculaDano(alvo):
	
	pass
	
func causaDano():
	pass
	
func sofreDano():
	pass
	
 
func animacaoApanhar():
	pass
	

func animacaoVoltar(delta):
	if(voltando):
		$AnimatedSprite.set_animation("movendo")
		$AnimatedSprite.set_flip_h(virado)
		var position= get_position()
		var distanciaX= (posicaoInicial.x) - (position.x)
		var distanciaY= ((posicaoInicial.y) - (position.y) )
	
		if(mover(distanciaX,distanciaY,delta)):
			voltando=false
			$AnimatedSprite.set_animation("default")
			$AnimatedSprite.set_flip_h(virado)
			
			if(ataqueFinalizado):
				turnoTerminado=true
			
			if(bloqueado):
				var tituloAlerta="Bloqueado!"
				var textoAlerta= "Seu golpe foi bloqueado pelo oponente que estava \nno caminho. Tente atacar um oponente que não \nesteja protegido."
				get_parent().alertaCombate(tituloAlerta,textoAlerta,3,true)
				bloqueado=false

func mover(distanciaX,distanciaY,delta):
	
	var moduloX=0
	var moduloY=0
	var moveX=0
	var moveY=0
	
	if(distanciaX>=0):
			moduloX=distanciaX
	else:
		moduloX=-distanciaX
		
	if(distanciaY>=0):
		moduloY=distanciaY
	else:
		moduloY=-distanciaY
	
	if((moduloX>=10)or(moduloY >=10)):
		if(moduloY<=1):
			moduloY=1
		if(moduloX<=1):
			moduloX=1
		if(moduloX>moduloY):
			moveX= distanciaX/moduloX
			moveY= distanciaY/moduloX
		else:
			moveX = distanciaX/moduloY
			moveY= distanciaY/moduloY
		
		set_position(Vector2(position.x+(moveX*delta*(speed+moduloX)),position.y+(moveY*delta*(speed+moduloY))))
	else:
		return true
	return false

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name=="atacando"):
		golpesRealizados+=1
	
	pass 


func _on_timerHit_timeout():	
	criarGolpe()
	hitsPorGolpe -=1
	


func _on_personagem_combate_area_entered(area):
	bloqueado(area)
	pass # Replace with function body.
