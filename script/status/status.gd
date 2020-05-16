extends Node


class status extends Bonus.bonus:
	
	var idStatus
	var duracao = 0
	var contador = 0
	var efeitoStatus
	var someAoMorrer = true
	var someFimCombate = false

	func removeStatus(personagem):
		var status = personagem.status
		for i in status:
			if(status[i] == self):
				if(efeitoStatus != null):
					efeitoStatus.queue_free()
				status.remove(i)
				return
	
	func efeitoAoMorrer(personagem):
		if(someAoMorrer):
			removeStatus(personagem)
			
	func efeitoTerminoCombate(personagem,combate):
		if(someFimCombate):
			removeStatus(personagem)
