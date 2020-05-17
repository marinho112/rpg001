extends Node

func getAiPorTipo(cod):
	var lv = cod%10
	var tipo = (cod - lv)/10
	match tipo:
		0:
			return AiRaiz.new()
		1: 
			return AiBasica.new()

class AiRaiz :
	
	var nivel = 1
	
	var contador 
	
	func decidirAcao(delta,parent,personagem):
		var acao = golpeAleatorio(personagem,parent.listaAmigosObjeto,parent.listaInimigosObjeto)
		var alvos = escolherAlvoOfensivo(parent.listaAmigosObjeto,parent.listaInimigosObjeto,acao.numSelecao)
		acao.atacados= alvos
		personagem.ataque=acao
		
		parent.atacante = personagem
		parent.vetorSelecionados = alvos
		parent.selecionavel = acao
		parent.acaoPretendida = 0
		return alvos
		
	func escolherAlvoOfensivo(inimigos,aliados,numAlvos):
		var lista = []
		var listaTemp = []
		var inimigosVivos = []
		var num_alvos = numAlvos
		var alvos_validos = []
		var alvos_secundarios = []
		var contadorAdicao=0
		# Recece alvos da linha de frente
		for alvo in inimigos:
			if(!alvo.taMorto):
				inimigosVivos.append(alvo)
		for alvo in inimigosVivos:
			if(alvo.personagem.posicaoCombate<3):
				alvos_validos.append(alvo)
			else:
				alvos_secundarios.append(alvo)
		# se não ouver alvos na linha de frente recebe todos alvos
		if(len(alvos_validos)==0):
			alvos_validos = inimigosVivos
		# verifica se o numero de alvos é maior que o numero de oponentes
		if(len(inimigosVivos)<num_alvos):
			num_alvos = len(inimigosVivos)
			
		# cria uma lista numeria do tamanho de alvos_validos
		for i in len(alvos_validos):
			listaTemp.append(i)
		#randomiza a lista
		listaTemp.shuffle()
		
		#adiciona alvos a lista final
		for i in num_alvos:
			if(i < len(alvos_validos)):
				lista.append(alvos_validos[listaTemp[i]])
			else:
				lista.append(alvos_secundarios[i-len(alvos_validos)])
		return lista
		
		
	func escolherAlvoAjuda(inimigos,aliados,numAlvos):
		var lista = []
		var listaTemp = []
		var num_alvos = numAlvos
		if(len(aliados)>numAlvos):
			num_alvos = len(aliados)
		for i in len(aliados):
			listaTemp.append(i)
		listaTemp.shuffle()
		for i in num_alvos:
			lista.append(aliados[listaTemp[i]])
		return lista
		
		
	func finalizarEscolha():
		pass
		
	func golpeAleatorio(personagem,inimigos,aliados):
		var num_golpes = len(personagem.personagem.habilidadesOfensivas) +1
		var randomico = randi() % num_golpes
		if(randomico == 0):
			return retornaGolpeComum(personagem)
		else:
			return personagem.personagem.habilidadesOfensivas[randomico-1]
	
	func retornaGolpeComum(personagem):
		var golpeBasico = personagem.personagem.golpeBasico
		match golpeBasico:
			0:
				return GolpesClasses.Ataque_Basico_Fisico_Corpo_a_Corpo.new(personagem.personagem)
			1:
				return GolpesClasses.Ataque_Basico_Fisico_Distancia.new(personagem.personagem)
			_: 
				return GolpesClasses.Ataque_Basico_Fisico_Corpo_a_Corpo.new(personagem.personagem)


class AiBasica extends AiRaiz:
	
	func decidirAcao(delta,parent,personagem):
		
		var infoPer = personagem.personagem 
		if((infoPer.retornaHpRate() < 40)and(false)):
			pass
		else:
			return .decidirAcao(delta,parent,personagem)
