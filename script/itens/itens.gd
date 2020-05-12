extends Node


class item:
	
	var id
	var nome
	var peso
	var quantidade
	var preco
	var sprite
	var descricao
	var utilizavel = false

class itemConsumivel extends item:
	
	var tipo =0 # 1- Cura
	var emBatalha=true
	var val1 = 0
	var val2 = 0
	var val3 = 0
	
	func _init():
		utilizavel = true
	
	func utilizarItem(personagem):
		return true
		

class itemCura extends itemConsumivel:
	
	func _init():
		tipo = 1
		
	func utilizarItem(personagem):
		personagem.cura(val1)
		return true
