extends Node

func getAiPorTipo(cod):
	var lv = cod%10
	var tipo = (cod - lv)/10
	match tipo:
		0:
			return Ai.new()

class Ai :
	
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
		var num_alvos = numAlvos
		if(len(inimigos)<num_alvos):
			num_alvos = len(inimigos)
			
		for i in len(inimigos):
			listaTemp.append(i)
			
		listaTemp.shuffle()
		for i in num_alvos:
			#n esta entrnado
			lista.append(inimigos[listaTemp[i]])
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
