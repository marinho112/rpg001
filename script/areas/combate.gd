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
var pre_indicador = preload("res://nodes/objetos/SetaNumSelecao.tscn")

#Variaveis Inteiras
var tamanhoAmigo
var tamanhoInimigo
var numSelecao =1
var acaoPretendida
var selecionavel


#Variaveis de Controle
var controleDeTurno = true
var mudarLadoSelecao=false
var selecaoAliados=false
var selecaoIndividual=true
var selecionaTudo = false
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

var xMax=0
var xMin=0
		
#objetos 
var atacante


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#ControlaDados.carregaInfoPersonagemMob(1001)
	
	
	listaAmigos.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	listaAmigos.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	listaAmigos.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	#listaAmigos[0]=(Global.personagemGrupo.new())
	listaAmigos[0].posicaoCombate=5
	listaAmigos[1].posicaoCombate=1
	listaAmigos[2].posicaoCombate=2
	var arma = Equipamentos.equipamento_arma.new()
	arma.dano=10
	arma.defesa= 10
	carregaListaInimigos([1001,1001,1001,1001,1001])
	
	
	carregar_personagens()
	
	ativaEfeitosInicioCombate()
	set_process(true)
	pass # Replace with function body.

func ativaEfeitosInicioRodada():
	for personagem in listaTurnos:
		personagemAtivaInicioRodada(personagem.personagem)

func personagemAtivaInicioRodada(personagem):
	
	for equipamento in personagem.retornarEquipamentosEquipados() :
		if equipamento != null:
			equipamento.efeitoInicioRodada(personagem,self)
	
	for habilidade in personagem.habilidadesPassivas :
		habilidade.efeitoInicioRodada(personagem,self)
	
	for status in personagem.status:
		status.efeitoInicioRodada(personagem,self)
		
func ativaEfeitosFinalRodada():
	for personagem in listaTurnos:
		personagemAtivaFinalRodada(personagem.personagem)

func personagemAtivaFinalRodada(personagem):
	
	for equipamento in personagem.retornarEquipamentosEquipados() :
		if equipamento != null:
			equipamento.efeitoFinalRodada(personagem,self)
	
	for habilidade in personagem.habilidadesPassivas :
		habilidade.efeitoFinalRodada(personagem,self)
	
	for status in personagem.status:
		status.efeitoFinalRodada(personagem,self)
		
func ativaEfeitosInicioCombate():
	for personagem in listaTurnos:
		personagemAtivaInicioCombate(personagem.personagem)
	
	ativaEfeitosInicioRodada()


func personagemAtivaInicioCombate(personagem):
	
	for equipamento in personagem.retornarEquipamentosEquipados() :
		if equipamento != null:
			equipamento.efeitoInicioCombate(personagem,self)
	
	for habilidade in personagem.habilidadesPassivas :
		habilidade.efeitoInicioCombate(personagem,self)
	
	for status in personagem.status:
		status.efeitoInicioCombate(personagem,self)
		

func carregaListaInimigos(lista):
	var listaPosicoes=[0,1,2,3,4,5]
	listaPosicoes.shuffle()
	listaInimigos = []
	
	for i in len(lista):
		var objeto = ControlaDados.carregaInfoPersonagemMob(lista[i])
		if(objeto != null):
			objeto.habilidadesPassivas = HabilidadesMobs.get_habilidades(objeto)
			objeto.calculaAtributos()
			objeto.posicaoCombate=listaPosicoes[i]
			listaInimigos.append(objeto)

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
	
	if(turno>=len(listaTurnos)):
		ativaEfeitosFinalRodada()
		turno=0
		rodada+=1
		ativaEfeitosInicioRodada()
	else:
		animaTurno(delta)
		if(controleDeTurno):
			var daVez= listaTurnos[turno]
			
			if (daVez.is_in_group(Constantes.GRUPO_ALIADOS)) :
				var menu = get_node("menuCombate")
				menu.personagemTurno = daVez
				menu.trocaPersonagemMenu()
				if(daVez.taMorto):
					terminaTurno()
				else:
					menu.ativado = true
					controleDeTurno = false
					menu.ativadoEsferas = true
			else:
				if(daVez.personagem.ai == null):
					turno+=1
				else:
					controleDeTurno = false
					vetorSelecionados = daVez.personagem.ai.decidirAcao(delta,self,daVez)
					selecionavel = daVez.ataque
					terminaSelecao()
					
	
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
		item.recuperaTudo(2)
		personagem.personagem=item
		personagem.add_to_group(Constantes.GRUPO_ALIADOS)
		
		var x=900
		var y= item.posicaoCombate * 130
		if(item.posicaoCombate>2):
			x=1100
			y+= 120 - 130 *3
		else:
			y+= 180
			
		personagem.alteraPosicaoPermanente(Vector2(x,y),personagem.personagem.posicaoCombate)
		
	for i in tamanhoInimigo:
		var item= listaInimigos[i]
		
		#var personagem = pre_personagem.instance()
		
		var raiz= "res://nodes/objetos/Mobs/"+ item.node +".tscn"
		var personagem = load(raiz).instance()
		personagem.virado = true
		personagem.get_node("AnimatedSprite").set_flip_h(personagem.virado)
		item.recuperaTudo(2)
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
			
		personagem.alteraPosicaoPermanente(Vector2(x,y),personagem.personagem.posicaoCombate)
	
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
		
		
		if (Input.is_action_just_pressed("ui_up") or (selecionaTudo)):
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
	if(selecionaTudo):
		if(mudarLadoSelecao):
			vetorSelecionados = listaAmigosObjeto + listaInimigosObjeto
		else:
			if(selecaoAliados):
				vetorSelecionados = listaAmigosObjeto
			else:
				vetorSelecionados = listaInimigosObjeto
				
		terminaSelecao()
	else:
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
		else:
			var perso = matrizPosicao[posicaoXCursor][posicaoYCursor]
	
			var naLista = false
			for cursor in listaCursoresSobressalentes:
				if(cursor.personagem == perso):
					naLista = true
					var texto = int(cursor.getTexto())
					cursor.setTexto(str(texto +1))
			if !naLista :
				var novoCursor = pre_indicador.instance()
				var positionElemento = perso.get_position()
				var frames =perso.get_node("AnimatedSprite").get_sprite_frames()
				var anim = perso.get_node("AnimatedSprite").get_animation()
				var frame =perso.get_node("AnimatedSprite").get_frame()
				var tamanhoElemento = frames.get_frame(anim,frame).get_size()
				var alturaImagem =  novoCursor.get_node("Sprite").get_texture().get_size().y
				alturaImagem = alturaImagem * novoCursor.get_scale().y
				positionElemento.y -= (tamanhoElemento.y + alturaImagem)/2
				novoCursor.personagem = perso
				listaCursoresSobressalentes.append(novoCursor)
				novoCursor.set_global_position(positionElemento)
				add_child(novoCursor)
			
		if(numSelecionados<numSelecao):
			numSelecionados+=1
			vetorSelecionados.append(matrizPosicao[posicaoXCursor][posicaoYCursor])
		if(numSelecionados>=numSelecao):
			terminaSelecao()
		
func terminaSelecao():
	
	if(!clicavel):
		clicavel=true
	
	if(vetorSelecionados != null):
		emSelecao=false
		$cursor.set_visible(false)
		chamaAcao(vetorSelecionados) # envias a ação
		listaSelecionados=[]
		for i in len(listaCursoresSobressalentes):
			listaCursoresSobressalentes[i].queue_free()
		listaCursoresSobressalentes=[]
	
func desenhaCursorSelecao(delta):
	
	var personagemNome = matrizPosicao[posicaoXCursor][posicaoYCursor].personagem.nome
	alertaCombate(personagemNome,null,0.2,false)
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
			atacante.atacar(alvos,selecionavel)

func seleciona(selecionavel,fonte):
	
	acaoPretendida=selecionavel.tipoAcao
	atacante=fonte
	self.selecionavel=selecionavel
	emSelecao=true
	vetorSelecionados=[]
	numSelecionados=0
	$cursor.set_visible(true)
	if((selecionavel.tipoSelecao|62)==(63)):
		selecaoAliados = true
	else:
		selecaoAliados = false
	if((selecionavel.tipoSelecao|61)==(63)):
		mudarLadoSelecao=true
	else:
		mudarLadoSelecao=false
	if((selecionavel.tipoSelecao|59)==(63)):
		selecaoIndividual=true
	else:
		selecaoIndividual=false
	if((selecionavel.tipoSelecao|55)==(63)):
		selecionaTudo=true
	else:
		selecionaTudo=false
	
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
		self.numSelecao=selecionavel.numSelecao
	pass
	
	
func terminaTurno():
	controleDeTurno = true
	turno+=1
		

func alertaCombate(titulo,texto,tempo,pausar):
	$alertaTelaCombate/titulo.set_text(titulo)
	$timerAlerta.set_wait_time(tempo)
	$alertaTelaCombate.set_visible(true)
	$timerAlerta.start()
	get_tree().paused=pausar
	if(texto != null):
		$alertaTelaCombate/fundo/texto.set_text(texto)
		$alertaTelaCombate/fundo.set_visible(true)
		$alertaTelaCombate/fundoTitulo.set_visible(false)
	else:
		$alertaTelaCombate/fundoTitulo.set_visible(true)
		$alertaTelaCombate/fundo.set_visible(false)
	pass


func _on_Timer_timeout():
	$alertaTelaCombate.set_visible(false)
	get_tree().paused=false
	pass 
