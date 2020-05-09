extends Node

func get_habilidades(mob):
	var listaHabilidades=[]
	if(verificaLista(mob,[1001])):
		listaHabilidades.append(fragilidade.new())
		
	return(listaHabilidades)

func verificaLista(mob,lista):
	for item in lista:
		if(mob.ID==item):
			return true
	return false
	
class fragilidade extends Habilidades.habilidade:
	
	func _init():
		idHabilidade=5000
		
	func efeitoPassivo(personagem):
		
		personagem.defesaBonus -= int(personagem.defesa/2)
		return true
	
	func efeitoAoSerAtacado(atacante,ataque):
		var skillRatio = ataque.skillRatio
		ataque.skillRatio += 20*skillRatio/100
		return true
