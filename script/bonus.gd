extends Node

var nome = ""
class bonus:
	
	# N implementado
	func efeitoInicioCombate(personagem):
		return true
	
	func efeitoPassivo(personagem):
		return true
	# N implementado
	func efeitoInicioTurno(personagem):
		return true
	
	func efeitoPreAtaque(personagem):
		return true

	func efeitoPosAtaque(personagem):
		return true
	# N implementado	
	func efeitoFinalTurno(personagem):
		return true
	# N implementado
	func efeitoAoMorrer(personagem):
		return true
	# N implementado
	func efeitoTerminoCombate(personagem):
		return true
		
	func efeitoAoSerAtacado(atacante,ataque):
		return true
