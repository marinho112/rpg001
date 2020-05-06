extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#preload
var preloadMsgDano = preload("res://nodes/objetos/msgDano.tscn")
var preloadEfeitoBloqueio = preload("res://nodes/efeitos/EfeitoBloqueio.tscn")

#Variavei booleanas
var controlaAtaque =10
var controlaHits
var voltando    
var bloqueado = 0 # 0 false , 1 bloqueado , 2 bloqueado com alerta
var virado 
var intangivel  
var iniciaCombate = true
var chegarNoAlvo
var moverAtaque

#caracteristicas personagem
var speed = 200
var posicaoInicial
var personagem


#Caracteristicas ataque
var atacados=[]
var listaInimigos= []
var inimigoAtacado
var ataquesRealizados=0 # Numero de movimentos para ataque
var golpesRealizados = 0 
var golpesPorAtaque=2 #Numero animações de ataque
var intervaloHits=0.01
var hitsPorGolpeRaiz=1 # efeitos de golpe por animação de ataque
var hitsPorGolpe=0
var hitsSecundariosPorGolpe=1 # hits por efeitos de golpe
var distanciaDeSurgimentoDoGolpe = 5

#Caracteristicas Danos

var golpeBloqueavel = true
var golpeEsquivavel = true
var golpeDistancia= false
var golpeMagico = false
var golpeElemento=0
var golpeTipoDano=0


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

func atribuiValoresAtaque(golpesPorAtaque,hitsPorGolpeRaiz,intervaloHits,hitsSecundariosPorGolpe,distanciaDeSurgimentoDoGolpe):
	self.golpesPorAtaque=golpesPorAtaque 
	self.hitsPorGolpeRaiz=hitsPorGolpeRaiz
	self.intervaloHits=intervaloHits
	self.hitsSecundariosPorGolpe=hitsSecundariosPorGolpe
	self.distanciaDeSurgimentoDoGolpe = distanciaDeSurgimentoDoGolpe
	

func atribuiCaracteristicasAtaque(distancia,magico,bloqueavel,esquivavel,elemento,tipoDano):
	
	golpeDistancia=distancia
	golpeMagico=magico
	golpeBloqueavel=bloqueavel
	golpeEsquivavel=esquivavel
	golpeElemento=elemento
	golpeTipoDano=tipoDano

func atacar(atacados,tipoAtaque):
	
	
	match tipoAtaque:
		0:
			
			atribuiValoresAtaque(1,1,0.01,1,50)
			atribuiCaracteristicasAtaque(false,false,true,true,Constantes.PROPRIEDADE_DO_ATAQUE_NEUTRO,Constantes.TIPO_DE_DANO_CORTANTE)
			controlaAtaque=0
	
	moverAtaque=!golpeDistancia
	self.listaInimigos=get_parent().listaInimigosObjeto
	self.atacados=atacados
	
	pass


func controlaAtaque(delta):
	
	match controlaAtaque:
		
		0:
			#verifica inicio do turno
			if(true):
				ataquesRealizados=0
				golpesRealizados=0
				controlaAtaque=1
				chegarNoAlvo = false
		1:
			#verifica pré Movimento
			if(true):
				controlaAtaque=2
		2:
			if(chegarNoAlvo or (bloqueado>0) or (ataquesRealizados>=len(atacados))):
				controlaAtaque=3
			else:
				moverAtaque(delta)
		3:
			#verifica pre ataque
			if(true):
				controlaAtaque=4
				
		4:
			if(ataquesRealizados>=len(atacados)):
				controlaAtaque=5
			else:
				animacaoAtaque(delta)
		5: #verifica Pós ataque
			if(true):
				controlaAtaque=6
		
		6: 
			if(!voltando):
				controlaAtaque = 7
			else:
				animacaoVoltar(delta)
		7:
			#finaliza Turno
			if(true):
				controlaAtaque=8
		8:
			$AnimatedSprite.set_animation("default")
			$AnimationPlayer.stop()
			controlaAtaque=9
			get_parent().terminaTurno()
			
	
func moverAtaque(delta):

	if(!moverAtaque):
		chegarNoAlvo = true
	else:
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
			$AnimatedSprite.set_flip_h(virado)
			chegarNoAlvo = true
		
	
func animacaoAtaque(delta):
	
	if(golpesRealizados>=golpesPorAtaque):
		ataquesRealizados+=1
		golpesRealizados=0
		voltando = true
	else:
	
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
	golpe.add_to_group(Constantes.GRUPO_ATAQUE)
	golpe.numHits=hitsSecundariosPorGolpe
	golpe.get_node("AnimatedSprite").set_flip_h(!virado)
	golpe.get_node("AnimationPlayer").play("golpe")


func bloqueado(area):
	if((area!=inimigoAtacado) and !voltando and (controlaAtaque<7)):
		if(!area.is_in_group(Constantes.GRUPO_ATAQUE)):
			if(is_in_group(Constantes.GRUPO_ALIADOS)):
				if(area.is_in_group(Constantes.GRUPO_INIMIGO)):
					foiBloquado(2,area)

			elif(is_in_group(Constantes.GRUPO_INIMIGO)):
				if(area.is_in_group(Constantes.GRUPO_ALIADOS)):
					foiBloquado(2,area)

func foiBloquado(tipo,bloqueador):
	bloqueado=tipo
	voltando = true
	golpesRealizados=golpesPorAtaque
	
	var efeito = preloadEfeitoBloqueio.instance()
	get_parent().add_child(efeito)
	var posicaoBloqueador= bloqueador.get_global_position()
	var sprite = bloqueador.get_node("AnimatedSprite")
	var frames = sprite.get_sprite_frames()
	var anim = sprite.get_animation()
	var frame = sprite.get_frame()
	var atacadoTamanho=frames.get_frame(anim,frame).get_size()
	if(bloqueador.is_in_group(Constantes.GRUPO_INIMIGO)):
		posicaoBloqueador.x += atacadoTamanho.x * 0.65
	else:
		posicaoBloqueador.x -= atacadoTamanho.x * 0.65
	posicaoBloqueador.y -= atacadoTamanho.y *0.7
	
	efeito.set_global_position(posicaoBloqueador)



func calculaDano(alvo):
	
	var alvoinfo = alvo.personagem
	
	var dano = personagem.dano
	var defesa = alvoinfo.defesa
	var rd = (defesa/15.0)
	
	var vea= personagem.esferasAtaque
	var ved= alvoinfo.esferasDefesa
	
	
	if(golpeMagico):
		dano= personagem.danoMagico
		defesa = alvoinfo.defesaMagica
	elif(golpeDistancia):
		dano= personagem.danoDistancia
	
	dano = (3*dano) + ((dano/8.0)*(dano/8.0)) 
	
	#defesa = defesa + ((defesa/10)*(defesa/10)) 
	
	
	rd *= 1 +(0.25* alvoinfo.esferasDefesa)
	
	dano = int(dano + (dano*vea*vea/2.0))
	
	defesa = int(defesa + (defesa*ved*ved/2.0))
	
	var danoCausado = int(dano -((dano*rd/100.0) + (defesa/2.0)))
	
	if(danoCausado <= 0):
		danoCausado = 1
	
	
	return danoCausado
	



func calculaAcerto(alvo):
	
	var valoresAlvo = alvo.personagem
	var acerto = personagem.acerto
	var esquiva = valoresAlvo.esquiva 
	var bloqueio = valoresAlvo.bloqueio 
		
	if(golpeMagico):
		acerto = personagem.acertoMagico
		esquiva = valoresAlvo.esquivaMagico
		bloqueio = valoresAlvo.bloqueioMagico
	
	
	var chanceBloqueio = acertoFormula(acerto,bloqueio)
	var chanceEsquiva = acertoFormula(acerto,esquiva)
	
	
	var diferencaEsferas = personagem.esferasAcerto - valoresAlvo.esferasEsquiva
	if (diferencaEsferas<0):
		diferencaEsferas*=-1
		chanceBloqueio =chanceBloqueio / (1+(0.5*diferencaEsferas)) 
		chanceEsquiva = chanceEsquiva / (1+(0.5*diferencaEsferas)) 
	elif(diferencaEsferas>0):
		chanceBloqueio += chanceBloqueio * diferencaEsferas * 0.5
		chanceEsquiva += chanceEsquiva * diferencaEsferas * 0.5
	
	if((randi()%1000 <= chanceBloqueio*10) and golpeBloqueavel):
		print(str(chanceBloqueio))
		foiBloquado(1,alvo)
	elif((randi()%1000<=chanceEsquiva*10) and !intangivel and golpeEsquivavel):
		print(str(chanceEsquiva))
		criarMsgDano(0)
	else:
		alvo.sofreDano(calculaDano(alvo))


func acertoFormula(num1,num2):
	var dif = 0
	var valor = 30
	
	if(num1>=num2):
		dif= num1 - num2
		for i in dif:
			valor *= 0.95
		return valor
	else:
		dif=num2 - num1
		for i in dif:
			valor *= 0.975
		return 30 + (30 - valor)


func sofreDano(valor):
	
	criarMsgDano(valor)
	animacaoApanhar()
	
	
	pass
	
func criarMsgDano(valor):
	
	var msgDano = preloadMsgDano.instance()
	get_parent().add_child(msgDano)
	msgDano.set_global_position(get_global_position())
	var lbl = msgDano.get_node("Label")
	if(valor==0):
		lbl.set_text("Miss!")
		var fonte = lbl.get_font("font")
	else: 
		lbl.set_text(str(valor))
		
	if(is_in_group(Constantes.GRUPO_ALIADOS) or ((valor==0) and is_in_group(Constantes.GRUPO_INIMIGO))):
		lbl.set("custom_colors/font_color",Color(240,0,0))
 
func animacaoApanhar():
	
	$AnimatedSprite.set_animation("apanhando")
	$AnimationPlayer.play("apanhando")
	
	pass
	

func animacaoVoltar(delta):
	if(true):
		$AnimatedSprite.set_animation("movendo")
		$AnimatedSprite.set_flip_h(virado)
		var position= get_position()
		var distanciaX= (posicaoInicial.x) - (position.x)
		var distanciaY= ((posicaoInicial.y) - (position.y) )
	
		if(mover(distanciaX,distanciaY,delta)):
			voltando=false
			$AnimatedSprite.set_animation("default")
			$AnimatedSprite.set_flip_h(virado)
	
	
			if(golpesRealizados<golpesPorAtaque):
				controlaAtaque=2
			
			if(bloqueado > 0):
				if(bloqueado>1):
					var tituloAlerta="Bloqueado!"
					var textoAlerta= "Seu golpe foi bloqueado pelo oponente que estava \nno caminho. Tente atacar um oponente que não \nesteja protegido."
					get_parent().alertaCombate(tituloAlerta,textoAlerta,3,true)
				
				bloqueado=0

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
