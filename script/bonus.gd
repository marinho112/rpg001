extends Node

var nome = ""
class bonus:
	
	#Calculo atributos
	
	func efeitoPassivo(personagem):
		return true
	
	# Classe do Combate
	
	func efeitoInicioCombate(personagem,combate):
		return true
	
	func efeitoInicioRodada(personagem,combate):
		return true
	
	func efeitoFinalRodada(personagem,combate):
		return true
		
	# N implementado
	func efeitoTerminoCombate(personagem,combate):
		return true
		
	# Classe do Personagem
	
	func efeitoInicioTurno(personagem):
		return true
	
	func efeitoPreAtaque(personagem):
		return true

	func efeitoPosAtaque(personagem):
		return true
	
	func efeitoFinalTurno(personagem):
		return true
	
	# N implementado
	func efeitoAoMorrer(personagem):
		return true
	
	func efeitoAoSerAtacado(atacante,ataque):
		return true
