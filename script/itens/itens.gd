extends Node


class item:
	
	var id
	var tipo = Constantes.ITEM_TIPO_OUTROS
	var nome = ""
	var peso = 0
	var quantidade = 1
	var preco = 0
	var sprite
	var descricao
	var consumivel = false
	
	func ativar(personagem):
		pass

class itemEquipamento extends item:
	
	var equipamento
	
	func ativar(personagem):
		equipamento.equipar(personagem)
	
	func _init():
		tipo = Constantes.ITEM_TIPO_EQUIPAMENTO

class itemUtilizavel extends item:
	
	var tipoUtilidade =0 # 1- Cura
	var emBatalha=true
	var val1 = 0
	var val2 = 0
	var val3 = 0
	
	func ativar(personagem):
		utilizarItem(personagem)
	
	func _init():
		consumivel = true
		tipo = Constantes.ITEM_TIPO_UTILIZAVEL
	
	func utilizarItem(personagem):
		return true
		

class itemCura extends itemUtilizavel:
	
	func _init():
		tipo = 1
		
	func utilizarItem(personagem):
		personagem.cura(val1)
		return true
