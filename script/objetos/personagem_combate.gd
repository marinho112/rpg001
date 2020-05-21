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
var esperandoAtaque = 0
var taMorto = false

#caracteristicas personagem
var speed = 300
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


func alteraPosicaoPermanente(posicao,inteiro):
	set_position(posicao)
	posicaoInicial=posicao
	personagem.posicaoCombate = inteiro


func atacar(atacados,Ataque):
	
	
	ataque= Ataque
	
	controlaAtaque=0
	
	
	moverAtaque=!ataque.golpeDistancia
	self.listaInimigos=get_parent().listaInimigosObjeto
	ataque.atacados=atacados
	
	pass


func controlaAtaque(delta):
		match controlaAtaque:
	
			0:
				if(taMorto):
					controlaAtaque=10	
					get_parent().terminaTurno()
					
				#verifica inicio do turno
				elif(true):
					#ataque.ataquesRealizados=0
					ataque.golpesRealizados=0
					controlaAtaque=1
					chegarNoAlvo = false
					personagemAtivaInicioTurno(personagem)
			1:
				#verifica pré Movimento
				if(true):
					controlaAtaque=2
					if((ataque.ataquesRealizados<len(ataque.atacados))):
						ataque.inimigoAtacado = ataque.atacados[ataque.ataquesRealizados]
			2:
				if(chegarNoAlvo or (bloqueado>0) or (ataque.ataquesRealizados>=len(ataque.atacados))):
					controlaAtaque=3
				else:
					moverAtaque(delta)
			3:
				#verifica pre ataque
				if(true):
					ativaTodosEfeitosPreAtaque(personagem)
					ativaTodosEfeitoAoSerAtacado(personagem)
					controlaAtaque=4
					
			4:
				if(ataque.golpesRealizados>=ataque.golpesPorAtaque):
					ataque.ataquesRealizados+=1
					voltando = true
					controlaAtaque=5
				else:
					animacaoAtaque(delta)
			5: #verifica Pós ataque
				if(esperandoAtaque<= 0):
					esperandoAtaque = 0
					ativaTodosEfeitosPosAtaque(personagem)
					controlaAtaque=6
			
			6: 
				if(!voltando):
					controlaAtaque = 7
				else:
					animacaoVoltar(delta)
			7:
				#Retorna Posicao
				if(ataque.ataquesRealizados<len(ataque.atacados)):
					controlaAtaque=1
					ataque.golpesRealizados=0
				else:
					controlaAtaque=8
			8:
				#finaliza Turno
				if(true):
					verificaMorte()
					personagemAtivaFinalTurno(personagem)
	
					controlaAtaque=9
			9:
				$AnimatedSprite.set_animation("default")
				$AnimationPlayer.stop()
				controlaAtaque=10
				get_parent().terminaTurno()
			_:
				pass
	
	
func moverAtaque(delta):

	if(!moverAtaque):
		chegarNoAlvo = true
	else:
		$AnimatedSprite.set_animation("movendo")
		$AnimatedSprite.set_flip_h(!virado)
		var posiAtacado=ataque.inimigoAtacado.get_position()
		var frames =ataque.inimigoAtacado.get_node("AnimatedSprite").get_sprite_frames()
		var anim = ataque.inimigoAtacado.get_node("AnimatedSprite").get_animation()
		var frame =ataque.inimigoAtacado.get_node("AnimatedSprite").get_frame()
		var atacadoTamanho=frames.get_frame(anim,frame).get_size()
		if(atacadoTamanho.x< 50):
			atacadoTamanho.x += 50 -(atacadoTamanho.x/2)
		if(is_in_group(Constantes.GRUPO_INIMIGO)):
			atacadoTamanho.x *=-1
		var position= get_position()
		var distanciaX= (atacadoTamanho.x + posiAtacado.x) - (position.x)
		var distanciaY= ((posiAtacado.y) - (position.y) )
		
		
		
		if(mover(distanciaX,distanciaY,delta)):
			$AnimatedSprite.set_flip_h(virado)
			chegarNoAlvo = true
		
	
func animacaoAtaque(delta):
	
	$AnimatedSprite.set_animation("batendo")
	$AnimationPlayer.play("atacando")


func ativaControlaHits():
	controlaHits=true
	ataque.hitsPorGolpe=ataque.hitsPorGolpeRaiz

func golpesControleHits(delta):
	if(controlaHits and ($timerHit.is_stopped())):
		if(ataque.hitsPorGolpe<=0):
			controlaHits=false
		else:
			if(ataque.hitsPorGolpe==ataque.hitsPorGolpeRaiz):
				_on_timerHit_timeout()
			else:
				$timerHit.set_wait_time(ataque.intervaloHits)
				$timerHit.start()
		
func diminuiEsperaAtaque():
	esperandoAtaque -= 1

func criarGolpe():
	if(ataque.esperarAtaque):
		esperandoAtaque += 1
	var golpe = load(ataque.nodeGolpe).instance()
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
	golpe.virar(virado)


func bloqueado(area):
	if(ataque!=null):
		if((area!=ataque.inimigoAtacado) and !voltando and (controlaAtaque<7)):
			if(!area.is_in_group(Constantes.GRUPO_ATAQUE)):
				if(is_in_group(Constantes.GRUPO_ALIADOS)):
					if((area.is_in_group(Constantes.GRUPO_INIMIGO))and (!area.taMorto)):
						foiBloquado(2,area)
	
				elif(is_in_group(Constantes.GRUPO_INIMIGO)):
					if((area.is_in_group(Constantes.GRUPO_ALIADOS))and (!area.taMorto)):
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
	var danoPropriedade = calcularBonusPropriedade(ataque,alvoinfo)
	var danoRaca = calculaBonusRaca(ataque,alvoinfo)
	var vea= personagem.esferasAtaque + ataque.bonusEsferaAtaque
	var ved= alvoinfo.esferasDefesa - ataque.penalEsferaDefesa
	
	
	if(ataque.golpeMagico):
		dano= personagem.danoMagico + personagem.danoMagicoBonus
		defesa = alvoinfo.defesaMagica + alvoinfo.defesaMagicaBonus
	elif(ataque.golpeDistancia):
		dano= personagem.danoDistancia + personagem.danoDistanciaBonus
	
	
	dano += ataque.bonusDanoAtaque 
	defesa -= ataque.penalDefesaAtaque 
	
	defesa -= (ataque.penalDefRatio * defesa) /100
	
	dano = (3*dano) + ((dano/8.0)*(dano/8.0)) 
	
	#defesa = defesa + ((defesa/10)*(defesa/10)) 
	
	var rd = (defesa/12.5)
	rd *= 1 +(0.25* ved)
	
	
	dano = int(dano + (dano*vea*vea))
	
	#Multiplicadores
	dano = int(dano*danoRaca/100.0)
	dano = int(dano*danoPropriedade/100.0)
	dano = int(dano*ataque.skillRatio/100.0)
	
	dano -= int(dano*rand_range(0,30) / 100)
	
	defesa = int(defesa + (defesa*ved))
	
	var danoCausado = int(dano -((dano*rd/100.0) + (defesa)))
	
	if(danoCausado <= 0):
		danoCausado = 1
	
	return danoCausado
	

func ativaTodosEfeitosPreAtaque(personagem):
	
	for item in personagem.habilidadesPassivas:
		ativaEfeitoPreAtaque(item,personagem)
	for item in personagem.retornarEquipamentosEquipados():
		ativaEfeitoPreAtaque(item,personagem)

func ativaEfeitoPreAtaque(item,personagem):
	if((item!=null)):
		item.efeitoPreAtaque(personagem)

func ativaTodosEfeitosPosAtaque(personagem):
	
	for item in personagem.habilidadesPassivas:
		ativaEfeitoPosAtaque(item,personagem)
	for item in personagem.retornarEquipamentosEquipados():
		ativaEfeitoPosAtaque(item,personagem)

func ativaEfeitoPosAtaque(item,personagem):
	if((item!=null)):
		item.efeitoPosAtaque(personagem)



func ativaTodosEfeitoAoSerAtacado(personagem):
	
	for item in ataque.inimigoAtacado.personagem.habilidadesPassivas:
		ativaEfeitoAoSerAtacado(item,personagem)
	for item in ataque.inimigoAtacado.personagem.retornarEquipamentosEquipados():
		ativaEfeitoAoSerAtacado(item,personagem)

func ativaEfeitoAoSerAtacado(item,personagem):
	if((item!=null)):
		item. efeitoAoSerAtacado(personagem,ataque)

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
	
	
	acerto+=  ataque.bonusAcertoAtaque 
	esquiva-= ataque.penalEsquivaAtaque
	bloqueio-=  ataque.penalBloqueioAtaque

	
	acerto+= (personagem.esferasAcerto + ataque.bonusEsferaAcerto) * acerto
	esquiva+= (valoresAlvo.esferasEsquiva - ataque.penalEsferaEsquiva) * esquiva
	bloqueio+= (valoresAlvo.esferasEsquiva - ataque.penalEsferaEsquiva) * bloqueio

	var chanceAcerto = randi()% (acerto + 50)
	var chanceBloqueio = randi()%bloqueio
	var chanceEsquiva = randi()%esquiva
	
	
	if((chanceAcerto < chanceBloqueio) and ataque.golpeBloqueavel):
		return 0
	elif((chanceAcerto < chanceEsquiva) and !intangivel and ataque.golpeEsquivavel):
		return 1
	else:
		return 2
		

func encaminhaAcerto(val,alvo):
	match val:
		0:
			foiBloquado(1,alvo)
		1:
			criarMsgDano(0)
		2:
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


func sofreDano(valor):
	
	if(valor >= 0):
		personagem.recebeDano(valor)
		criarMsgDano(valor)
		animacaoApanhar()
	else:
		cura(-valor)
	
	
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
		
	if(is_in_group(Constantes.GRUPO_ALIADOS)):
		lbl.set("custom_colors/font_color",Color(240,0,0))
	return msgDano
 
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
			chegarNoAlvo = false
			
			if(bloqueado > 0):
				if(bloqueado>1):
					var tituloAlerta=ControlaDados.receberTexto("combate",1)
					var textoAlerta= ControlaDados.receberTexto("combate",2)
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

func personagemAtivaInicioTurno(personagem):
	
	for equipamento in personagem.retornarEquipamentosEquipados() :
		if equipamento != null:
			equipamento.efeitoInicioTurno(personagem)
	
	for habilidade in personagem.habilidadesPassivas :
		habilidade.efeitoInicioTurno(personagem)
	
	for status in personagem.status:
		status.efeitoInicioTurno(personagem)
		
func personagemAtivaFinalTurno(personagem):
	
	for equipamento in personagem.retornarEquipamentosEquipados() :
		if equipamento != null:
			equipamento.efeitoFinalTurno(personagem)
	
	for habilidade in personagem.habilidadesPassivas :
		habilidade.efeitoFinalTurno(personagem)
	
	for status in personagem.status:
		status.efeitoFinalTurno(personagem)

func cura(val):
	var msg = criarMsgDano(val)
	var lbl = msg.get_node(("Label"))
	lbl.set("custom_colors/font_color",Color(0,240,0))
	personagem.cura(val)
	
func recuperaMp(val):
	var msg = criarMsgDano(val)
	var lbl = msg.get_node(("Label"))
	lbl.set("custom_colors/font_color",Color(0,0,240))
	personagem.recuperaMp(val)

func morrer():
	if(is_in_group(Constantes.GRUPO_INIMIGO)):
		var papai = get_parent()
		papai.listaAmigosObjeto.erase(self)
		papai.listaInimigosObjeto.erase(self)
		papai.listaTurnos.erase(self) 
		for lista in papai.matrizPosicao:
			for i in 3:
				if(lista[i]==self):
					lista[i]=null
		queue_free()
	else:
		print("MORRI!")
		taMorto = true
		$AnimatedSprite.set_animation("morto")
	
	
func verificaMorte():
	
	for personagem in get_parent().listaTurnos:
		if(personagem.personagem.hpAtual <= 0):
			personagem.morrer()

func verificaFimDoCombate():
	var papai = get_parent()
	var geralMorreu = true
	if(len(papai.listaInimigosObjeto)<=0):
		print("Aliado Venceu")
	for personagem in papai.listaAmigosObjeto:
		if(!personagem.taMorto):
			geralMorreu = false
	if(geralMorreu):
		print("aliado Perdeu")


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
