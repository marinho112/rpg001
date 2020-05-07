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


var ataque
var listaInimigos= []


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


func atacar(atacados,tipoAtaque):
	
	
	ataque= tipoAtaque
	
	controlaAtaque=0
	
	moverAtaque=!ataque.golpeDistancia
	self.listaInimigos=get_parent().listaInimigosObjeto
	ataque.atacados=atacados
	
	pass


func controlaAtaque(delta):
	match controlaAtaque:
		
		0:
			#verifica inicio do turno
			if(true):
				ataque.ataquesRealizados=0
				ataque.golpesRealizados=0
				controlaAtaque=1
				chegarNoAlvo = false
		1:
			#verifica pré Movimento
			if(true):
				controlaAtaque=2
		2:
			if(chegarNoAlvo or (bloqueado>0) or (ataque.ataquesRealizados>=len(ataque.atacados))):
				controlaAtaque=3
			else:
				moverAtaque(delta)
		3:
			#verifica pre ataque
			if(true):
				controlaAtaque=4
				
		4:
			if(ataque.ataquesRealizados>=len(ataque.atacados)):
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
		_:
			pass
	
func moverAtaque(delta):

	if(!moverAtaque):
		chegarNoAlvo = true
	else:
		$AnimatedSprite.set_animation("movendo")
		$AnimatedSprite.set_flip_h(!virado)
		ataque.inimigoAtacado = ataque.atacados[ataque.ataquesRealizados]
		var posiAtacado=ataque.inimigoAtacado.get_position()
		var frames =ataque.inimigoAtacado.get_node("AnimatedSprite").get_sprite_frames()
		var anim = ataque.inimigoAtacado.get_node("AnimatedSprite").get_animation()
		var frame =ataque.inimigoAtacado.get_node("AnimatedSprite").get_frame()
		var atacadoTamanho=frames.get_frame(anim,frame).get_size()
		if(atacadoTamanho.x< 50):
			atacadoTamanho.x += 50 -(atacadoTamanho.x/2)
		var position= get_position()
		var distanciaX= (atacadoTamanho.x + posiAtacado.x) - (position.x)
		var distanciaY= ((posiAtacado.y) - (position.y) )
		
		
		
		if(mover(distanciaX,distanciaY,delta)):
			$AnimatedSprite.set_flip_h(virado)
			chegarNoAlvo = true
		
	
func animacaoAtaque(delta):
	
	if(ataque.golpesRealizados>=ataque.golpesPorAtaque):
		ataque.ataquesRealizados+=1
		ataque.golpesRealizados=0
		voltando = true
	else:
	
		$AnimatedSprite.set_animation("batendo")
		$AnimationPlayer.play("atacando")
		
	pass

func ativaControlaHits():
	controlaHits=true
	ataque.hitsPorGolpe=ataque.hitsPorGolpeRaiz

func golpesControleHits(delta):
	if(controlaHits and ($timerHit.is_stopped())):
		if(ataque.hitsPorGolpe<=0):
			controlaHits=false
		else:
			$timerHit.set_wait_time(ataque.intervaloHits)
			$timerHit.start()
		
func criarGolpe():
	
	var golpe = preload("res://nodes/golpes/ataque_simples.tscn").instance()
	add_child(golpe)
	var position = get_global_position()
	var icremento = ataque.distanciaDeSurgimentoDoGolpe
	if(!virado):
		icremento *= -1
	position.x = position.x + icremento
	golpe.set_global_position(position)
	golpe.set_z_index(1)
	var grupos = get_groups()
	for i in grupos:
		golpe.add_to_group(i)
	golpe.add_to_group(Constantes.GRUPO_ATAQUE)
	golpe.numHits=ataque.hitsSecundariosPorGolpe
	golpe.get_node("AnimatedSprite").set_flip_h(!virado)
	golpe.get_node("AnimationPlayer").play("golpe")


func bloqueado(area):
	if(ataque!=null):
		if((area!=ataque.inimigoAtacado) and !voltando and (controlaAtaque<7)):
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
	ataque.golpesRealizados=ataque.golpesPorAtaque
	
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
	
	var dano = personagem.dano + personagem.danoBonus
	var defesa = alvoinfo.defesa + alvoinfo.defesaBonus
	var rd = (defesa/15.0)
	var danoPropriedade = calcularBonusPropriedade(ataque,alvoinfo)
	var danoRaca = calculaBonusRaca(ataque,alvoinfo)
	var vea= personagem.esferasAtaque
	var ved= alvoinfo.esferasDefesa
	
	
	if(ataque.golpeMagico):
		dano= personagem.danoMagico + personagem.danoMagicoBonus
		defesa = alvoinfo.defesaMagica + alvoinfo.defesaMagicaBonus
	elif(ataque.golpeDistancia):
		dano= personagem.danoDistancia + personagem.danoDistanciaBonus
	
	dano = (3*dano) + ((dano/8.0)*(dano/8.0)) 
	
	#defesa = defesa + ((defesa/10)*(defesa/10)) 
	
	
	rd *= 1 +(0.25* alvoinfo.esferasDefesa)
	
	
	dano = int(dano + (dano*vea*vea/2.0))
	
	#Multiplicadores
	dano = int(dano*danoRaca/100.0)
	dano = int(dano*danoPropriedade/100.0)
	dano = int(dano*ataque.skillRatio/100.0)
	
	defesa = int(defesa + (defesa*ved*ved/2.0))
	
	var danoCausado = int(dano -((dano*rd/100.0) + (defesa/2.0)))
	
	if(danoCausado <= 0):
		danoCausado = 1
	
	
	return danoCausado
	

func calcularBonusPropriedade(atacante,alvo):
	var bonus = 100
	var at = atacante.golpeElemento
	var al =alvo.propriedade
	match at:
		Constantes.PROPRIEDADE_DO_ATAQUE_NEUTRO:
			if(al == Constantes.PROPRIEDADE_DO_ATAQUE_FANTASMA):
				bonus -=75
		Constantes.PROPRIEDADE_DO_ATAQUE_AGUA:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_GELO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_VENTO)):
				bonus += 50
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_RAIO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_AGUA)):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_RAIO:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_PLANTA)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_AGUA)):
				bonus += 50
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_RAIO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_TERRA)):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_TERRA:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_AGUA)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_RAIO)):
				bonus += 50
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_PLANTA)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_TERRA)):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_PLANTA:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_TERRA)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_RAIO)):
				bonus += 50
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_PLANTA)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_FOGO)):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_FOGO:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_GELO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_PLANTA)):
				bonus += 50
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_VENTO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_FOGO)):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_VENTO:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_FOGO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_TERRA)):
				bonus += 50
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_GELO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_VENTO)):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_GELO:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_VENTO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_FOGO)):
				bonus += 50
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_GELO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_AGUA)):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_MALIGNO:
			if(al == Constantes.PROPRIEDADE_DO_ATAQUE_FANTASMA):
				bonus += 50
			if(al == Constantes.PROPRIEDADE_DO_ATAQUE_MALIGNO):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_SAGRADO:
			if((al == Constantes.PROPRIEDADE_DO_ATAQUE_MALIGNO)or(al == Constantes.PROPRIEDADE_DO_ATAQUE_FANTASMA)):
				bonus += 50
			if(al == Constantes.PROPRIEDADE_DO_ATAQUE_SAGRADO):
				bonus -=25
		Constantes.PROPRIEDADE_DO_ATAQUE_FANTASMA:
			if(al == Constantes.PROPRIEDADE_DO_ATAQUE_NEUTRO):
				bonus += 50
			if(al == Constantes.PROPRIEDADE_DO_ATAQUE_MALIGNO):
				bonus -=25
				
	return bonus
	
	
func calculaAcerto(alvo):
	
	var valoresAlvo = alvo.personagem
	var acerto = personagem.acerto + personagem.acertoBonus
	var esquiva = valoresAlvo.esquiva + valoresAlvo.esquivaBonus
	var bloqueio = valoresAlvo.bloqueio + valoresAlvo.bloqueioBonus
		
	
	if(ataque.golpeMagico):
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
	if((randi()%1000 <= chanceBloqueio*10) and ataque.golpeBloqueavel):
		
		foiBloquado(1,alvo)
	elif((randi()%1000<=chanceEsquiva*10) and !intangivel and ataque.golpeEsquivavel):
		
		criarMsgDano(0)
	else:
		
		alvo.sofreDano(calculaDano(alvo))

func calculaBonusRaca(atacante,alvo):
	var bonus = 100
	var alvoRaca = alvo.raca
	var propriedade = atacante.golpeElemento
	var tipoAtaque = atacante.golpeTipoDano
	
	match alvoRaca:
		
		Constantes.RACA_FERA:
			if(propriedade == Constantes.PROPRIEDADE_DO_ATAQUE_FOGO):
				bonus+=25
		Constantes.RACA_PEIXE:
			if(propriedade == Constantes.PROPRIEDADE_DO_ATAQUE_RAIO):
				bonus+=25
		Constantes.RACA_AVE:
			if(propriedade == Constantes.PROPRIEDADE_DO_ATAQUE_TERRA):
				bonus+=25
		Constantes.RACA_ELEMENTAL:
			if(tipoAtaque == Constantes.TIPO_DE_DANO_IMATERIAL):
				bonus+=50
			else:
				bonus-=50
		Constantes.RACA_DRAGAO:
			if(tipoAtaque != Constantes.TIPO_DE_DANO_IMATERIAL):
				bonus-=50
		Constantes.RACA_MORTO_VIVO:
			if(tipoAtaque != Constantes.TIPO_DE_DANO_PERFURANTE):
				bonus-=50
			if(tipoAtaque != Constantes.TIPO_DE_DANO_CORTANTE):
				bonus-=25
		Constantes.RACA_DEMONIO:
			if(propriedade == Constantes.PROPRIEDADE_DO_ATAQUE_SAGRADO):
				bonus +=25
		Constantes.RACA_GOLEN:
			if(tipoAtaque != Constantes.TIPO_DE_DANO_PERFURANTE):
				bonus-=75
		Constantes.RACA_PLANTA:
			if(propriedade == Constantes.PROPRIEDADE_DO_ATAQUE_FOGO):
				bonus+=25
		Constantes.RACA_MAQUINA:
			if((propriedade == Constantes.PROPRIEDADE_DO_ATAQUE_AGUA)or(propriedade == Constantes.PROPRIEDADE_DO_ATAQUE_RAIO)):
				bonus+=50
	
	return bonus

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
	
	
			if(ataque.golpesRealizados<ataque.golpesPorAtaque):
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
		ataque.golpesRealizados+=1
	
	pass 


func _on_timerHit_timeout():	
	criarGolpe()
	ataque.hitsPorGolpe -=1
	


func _on_personagem_combate_area_entered(area):
	bloqueado(area)
	pass # Replace with function body.
